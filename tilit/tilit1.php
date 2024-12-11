<?php
?>

<html>
 <head>
  <title>tilit</title>
 </head>
 <body>

<?php

$y_tiedot = ;

if (!$yhteys = pg_connect($y_tiedot))
   die("Yhteyden luominen epäonnistui.");

if (isset($_POST['laheta']))
{
    $l_summa = pg_escape_string($_POST['l_summa']);
	$lahettaja = pg_escape_string($_POST['lahettaja']);
	$vastaanottaja = pg_escape_string($_POST['vastaanottaja']);
	
	pg_query('BEGIN')
		or die ('Ei onnistuttu aloittamaan tapahtumaa:' . pg_last_error());
	
	pg_query($yhteys, "LOCK TABLE tilit IN SHARE ROW EXCLUSIVE MODE");
	
	$hae_summa_l = pg_query("SELECT summa, omistaja FROM tilit WHERE tilinumero = '$lahettaja'");
	$summa_l = pg_fetch_result($hae_summa_l,0,0);
	$nimi_l = pg_fetch_result($hae_summa_l,0,1);
	
	$hae_summa_v = pg_query("SELECT summa, omistaja FROM tilit WHERE tilinumero = '$vastaanottaja'");
	$summa_v = pg_fetch_result($hae_summa_v,0,0);
	$nimi_v = pg_fetch_result($hae_summa_v,0,1);
	
	
	
	if ($summa_l < $l_summa) {
		pg_query('ROLLBACK')
			or die ('Ei onnistuttu perumaan tapahtumaa: ' . pg_last_error());
		$viesti = "Omistajan $nimi_l tilillä $lahettaja ei ole tarpeeksi rahaa tilinsiirtoa varten.";
	}	
	else {
		$kysely1 = "UPDATE tilit SET summa = summa - '$l_summa' WHERE tilinumero = '$lahettaja'";
		$kysely2 = "UPDATE tilit SET summa = summa + '$l_summa' WHERE tilinumero = '$vastaanottaja'";
		
		$paivitys1 = pg_query($kysely1)
			or die ('Virhe ensimmäisessä päivityksessä: ' . pg_last_error());
		$paivitys2 = pg_query($kysely2)
			or die ('Virhe toisessa päivityksessä: ' . pg_last_error());

		if ($paivitys1 && (pg_affected_rows($paivitys1) > 0) && $paivitys2 && (pg_affected_rows($paivitys2) > 0)) {
			$viesti = "<span style='color: black;'>$nimi_l on siirtänyt $l_summa euroa henkilölle $nimi_v.</span>";
			pg_query('COMMIT')
				or die ('Ei onnistuttu hyväksymään tapahtumaa: ' . pg_last_error());
		}
		else {
			pg_query('ROLLBACK')
				or die ('Ei onnistuttu perumaan tapahtumaa: ' . pg_last_error());
			$viesti = 'Tilinsiirto ei onnistunut: ' . pg_last_error($yhteys);
		}
	}

}

pg_close($yhteys);

?>

<html>
 <head>
  <title>Tilinsiirto</title>
 </head>
 <body>
	
	<?php if (isset($viesti) && isset($_POST['laheta'])) 
		echo '<p style="color:red">'.$viesti.'</p>';?>
	
	<h4>Anna tilinsiirtoa varten tilinumerot ja siirrettävä summa</h4>
	
	<form action="tilit.php" method="post">

	<table border="0" cellspacing="0" cellpadding="3">
		<tr>
			<td>Lähettäjä</td>
			<td><input type="number" name="lahettaja" min="1" required /></td>
		</tr>
		<tr>
			<td>Vastaanottaja</td>
			<td><input type="number" name="vastaanottaja" min="1" required /></td>
		</tr>
		<tr>
			<td>Summa</td>
			<td><input type="number" name="l_summa" min="1" required /></td>
		</tr>
	</table>

	<br />
	<input type="hidden" name="laheta" value ="laheta" />
	<input type="submit" value="Lähetä rahaa" />
	</form>
</body>
</html>
