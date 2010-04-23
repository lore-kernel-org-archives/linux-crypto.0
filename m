From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: VIA Padlock: +30% XTS Performance by using ECB
Date: Fri, 23 Apr 2010 17:44:49 +0200
Message-ID: <20100423154449.GA1138@darkside.12.kls.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:47705 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab0DWPoz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Apr 2010 11:44:55 -0400
Received: from gate.12.kls.lan (vpn14.rz.tu-ilmenau.de [141.24.172.14])
	by piggy.rz.tu-ilmenau.de (8.13.7/8.13.7/Debian-2) with ESMTP id o3NFipwC015925
	for <linux-crypto@vger.kernel.org>; Fri, 23 Apr 2010 17:44:51 +0200
Received: from darkside.12.kls.lan (root@darkside.12.kls.lan [IPv6:2001:6f8:90c:12:21e:8cff:fecf:cfad])
	by gate.12.kls.lan (8.14.3/8.14.3) with ESMTP id o3NFiqF9023458
	for <linux-crypto@vger.kernel.org>; Fri, 23 Apr 2010 17:44:52 +0200
Received: from darkside.12.kls.lan (holbe@localhost [IPv6:::1])
	by darkside.12.kls.lan (8.14.3/8.14.3) with ESMTP id o3NFipQm012777
	for <linux-crypto@vger.kernel.org>; Fri, 23 Apr 2010 17:44:51 +0200
Received: (from holbe@localhost)
	by darkside.12.kls.lan (8.14.3/8.14.3) id o3NFinYS012774
	for linux-crypto@vger.kernel.org; Fri, 23 Apr 2010 17:44:49 +0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--z6Eq5LdranGa6ru8
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

the VIA Padlock engine comes without native XTS-AES support, thus
compared to CBC-AES or ECB-AES XTS-AES performs quite bad on VIA CPUs
because it calls the Padlock ACE for each single AESenc() operation.
Using the Padlock's ECB-AES saves calls to the Padlock ACE and improves
the XTS-AES performance by 30% and more even in a naive proof-of-concept
implementation.
The idea comes from DiskCryptor which does this since v0.9.583.106.

Here are some performance measues for my VIA Nano U2250 done with
dm-crypt aes-xts-plain on top of a 1GB tmpfs-backed loop-device. The
table shows MB/s measured by dd. The first column shows the creation of
the loop-image in tmpfs, i.e. memory-bandwidth. The next 10 columns show
10 write runs on top of the dm-crypt device. The last column shows a
read run on a 10GB dm-crypt'ed disk-partition (read speed on the plain
partition is ~94MB/s). For the last column I also measured DiskCryptor's
read performance.

xts orig 325 | 38.1 38.4 38.4 38.4 38.4 38.4 38.4 38.4 38.4 38.4 | 34.2
xts PoC  322 | 48.6 49.1 49.1 49.1 49.1 49.2 49.2 49.2 49.2 49.2 | 49.2
DC                                                                 65.1

My proof-of-concept comes not even close to DiskCryptor at the moment
but already improves dm-crypt performance significant.


I attached 4 patches with the proof-of-concept code. They need to be
applied one after the other. The code is really just ugly-hacked
proof-of-concept (except the first patch maybe) with incomplete
error-handling and hardcoded ECB-AES usage. Even though it seems to
encode and decode correctly, I strongly recommend to avoid using it to
handle real data.

Utilizing ECB-AES required to unfold and duplicate the scatterlist-walk.
This does also duplicate the GF-Multiplications, which could probably be
avoided by using an internal buffer.

I have no idea where this should finally be implemented, since it slows
down XTS on non-accelerated CPUs. Maybe a seperate xts-aes-padlock
driver would make sense depending on how specific this is to VIA
Padlock, i.e. how it performs on other non-XTS-capable accelerators.


Please CC: me in replies, I'm not a member of the list. Mail-F'up2
should be set correctly.

regards
   Mario
--=20
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

--9amGYk9869ThD9tj
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="xts-01-eliminate-goto.patch.gz"
Content-Transfer-Encoding: base64

H4sICNdu0EsCAzAxLXh0cy1lbGltaW5hdGUtZ290by5wYXRjaAB9Uttu4jAQfXa+YvZl5RAc
bAPbBbaIj9j3KBeHWrhx5TgEtOq/7zhJK1QV8mA7c8ZnzhkPYwyMbroLa23nSsVk+itdytQ6
fVyU7vrm7eLi27QkkvMNE5LxJfDVdi22UqT844OEC86jJEm+Y/tKJDjjKyYliKftSm6xHN/w
J7GWmyUSYaHocAAm+Ga+XEMy7AIOhwgIccp3rgHl3C4CDLSph2eghRLyN8zinu31eRcxkp9z
bRDBQFNcvWoxiOG+deUYxUN61s6neVW5cKOvWj9CeLiFQpnFDMrclJ3JvYJaO0w956ZTYGv4
C7MFpviejjazUr+9KJf5+pWW/sL2vlf5KZ7DIG7a4sDLyNF6O/IFfUBq64DudjH8Q5BUdtzJ
sUZ7r53JLllhFEXTc8AFSRLynVWkHki3Ab/rOWD3TCcBvVGDrSf4fJmzXVPRny3awBu4Imc8
9miqlDxDESSQiX36Rxvv0L9oo4DSUTILSAz7YZtKEl0D7RqjT8pcvyT+CWs8ZJHCYU8/7jxs
z/soDicGjRbmNL1On5tTVtlG0QpdzGGoFA+6g4Qfn92MBytTvTBD92br0XA9mK5J4O1g/wfZ
J8jplQMAAA==

--9amGYk9869ThD9tj
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="xts-02-resolve-xts_round.patch.gz"
Content-Transfer-Encoding: base64

H4sICDWI0EsCAzAyLXh0cy1yZXNvbHZlLXh0c19yb3VuZC5wYXRjaACNUU1v2zAMPcu/gqfC
H5IiKWuXxmsRoNhpFx96DxLZRo2mdiApcYqh/32UbDfAsgYzYFoyHx/J9xhjsGvaw4nZ7mB0
xRS/43PFhZxp87533ezkLNdECSmY+MaUAnm/nMvlreRieiATSogoy7J/cV0jUouluL0gWq2A
LRSVc8jwcwerVQTk2DUlxGndJrF15qAdDLxrV79BSuGw8FF3rXXhnOQRfOAbMes2rtHQtDhc
BYEHZ1mb7tCWE5dt2rqD1NIhn5bWTWTDD2t0ErHfESPbSqrF+tSZOIAse/QR0zkhsxSKAn4w
eAYEQAHpDCsQUrexB9ZvFEIVhhH/9OTxP+Nf1bukRZEMJX81+ew0FZ17YL2v+IhYBJ+bjuJM
2213r7rZv1RmXVZW43YUBSVwke03u1dIezpl9qY5QqrdacCPFrj+fy2gwUqpBP0OmZRzej94
SXpcCB6gZ4944MfGOL4pS+PtwmyNa8V5noCXm5CzWTfoTx+06IPgUYbps1RxOGLfAWM5hvO/
KxZ5Gsu9RzxYNPYYTfrSpqvdL4f5yruwM/HzQfYAW5sPdy/ReP8DtHt/KaYDAAA=

--9amGYk9869ThD9tj
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="xts-03-unfold-loop.patch.gz"
Content-Transfer-Encoding: base64

H4sICCqf0EsCAzAzLXh0cy11bmZvbGQtbG9vcC5wYXRjaADNVE1v4jAQPSe/YnpZOSQOiSlL
l7QVEtpTLxz2jvLh7EaYpHIcAlrx33fshBYooF5Wag6O45k37+XNyJRSEEXZbGldNTLllPnf
/RHzAzZM5e5VVcOtqv3UYkEY0OCeMgbhj+loNB3f+8HhATdgQWC7rnup1tVCLJyGwTRgHwrN
ZkAnE28CrllnMxv2NthQK9mkCuqizCv4a1Mr4SF7gIGKbLff4xasPq/jXap8jSn5Wkc2VZEB
GeSlQy4kedA86DWtylqZvYOgfWQEhUHosRBc/R6HRpRV5EDuWvpcJjvFawdPLMlVI0vgUiIU
Jda+gicgvVIHk4tNZFNMHQ4gjUXaiFhxyAuJlJtYNByqHH7BYIgpqiW9vrR4/cOllklStaXP
quXxyvHA1OtfWiyC8koCiSIHHXKtnn9wLgAj8SYuBMbe9OOpPm9rmXbHuPE3hVR+nGXSYNqs
Vl0MNycxHT1l7jqy3FaSvLMjzINvKMo78gR5nMjShiwW8Ejx7xEEC+2BqdtJcp8gqaPuW8s4
fJsT3YmmFMWKix0h3a9RneDAo14dk2UlEm07YH7nyL9uxHK7TAQnnSq9OoZlj2lw0Sbt8nWb
4IZNBnlkE71l0+ddwqLY6LwkCMnXOA4Gr1eNMJj5XGN+khe+C73FwtGwm+wfxfTs83dyLPr/
etR14IuO8IWJvmaP6fmJPXBmj7le2EhfeOF41N94nzIMjgwD08+zoTYz9DbSN0cetOFGLF5e
6FAiVv2t08ZitcyqkpMMp8oDowQR/wBWWxWXPQYAAA==

--9amGYk9869ThD9tj
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="xts-04-utilize-ecb.patch.gz"
Content-Transfer-Encoding: base64

H4sICJnj0EsCAzA0LXh0cy11dGlsaXplLWVjYi5wYXRjaADtWW1T20YQ/ix+xSadobLesOUY
SAgMhNJOJiShwHQmnzRCPoGKkBlJxqYt/727e3q3ZOwk0/ZDmUSW727fn93bO5umCWEQTedm
MpnGnjBta9sa2lZ/uOXFj/fpZGueJpan2P1B3+y/Mm0b7MGbwejNoG/18z/Q+3a/v6Hrehuv
DkZD6Ntv8N9ge4HR4SGY9sjYAZ2fh4cb8EMQeeF0LOBtxu3aH9i7d9PQujnYgA1I0njqpXAf
Bw/w54apZN/lYscL7m9EDJp3E4TjvQ29MX0V3jZWQAeDdCbcW5x+wv+s5nBIauJzm9VUFIBp
lATXkRhDEKVwKx5DEfU2UKmCJyupeekc9nP+qX/n4IB678YiSnt7yy0gunRuHuTaKNOhDZof
utcJTm1KJuaBF6cOD9ISUkbEca73qG/YqPir14Y9kpqDBpNIQDoBEbFQcKMxjIV8T28EjN3U
BW2L3K1sacDSQSpmwDQRCXwQjzYElrB4fSK8CbK4cUMfJj5o6AsiN5WaTY4XCjeWiqpsngHH
51/OLj87lz9/dM5PfnU+Hl18YJ/UCROR1skqzrwu5jKXwiaGfYngwp9d0vVu6RXaZ1RAgBBE
+K/LSIxSCYxSGHovt5McqWfQ2rKN4o21XEZeUXQJDwSLDyry6ZG+sUincZRjp4gBWZg0LDQa
Yq/rAarFYE36QvO6F2s+vMh9yGpWEyXLalMCl3HcxO2gxK0fxEn6H4RtUaYWkbtUgRYGDfCu
psh3A+8yxNZ0LEDbQfvvI7VU97rFpauBFXLN+3tcm3d2jeEu6Dsj49Uu1+Zie0uCyJ/wVnIl
cPuDdHGjQG1xm/LvaOZhEoxB1fyop7YsQuzv0hOLNMKd3jkatFGoGi8syEorxyLxQKOnUSjl
uWkq4jBALto4SQ1kIg1uW5DESFnbIml/zLdUJHHTwONxVqFTAwPtU2BhduaGt6DNDGjutVKr
LpU7VWWqmrrR1WMqkjYBtPtnLk9nq7pc2rF2pHqs2MqxotVZ6i6L2pIluTOyJQsRzFqcss1Q
akvcBzcIuRayDTR0lSxUiqtw4t0mwR+imkNcwNagkttEpYeTWUN01BkqFvm0yQPHqjI5KpYf
4To/IrMt2QZlZDjyVGkjGy7nBwnTS2FlEeNR1mgfxuYBvcmxvH/DQX5FA9qFMMZn7GKEwgwj
U7xjIGXtkzW1TuM8BHGqYhmdcamm0vliZh5IQBOgGsuDKEjVTcwlmSGUuNnasmp3SNicyVrC
IqxcwkKN5u3Yc0NvGrppvvE+uOFU0M57KbfddKZ2xEpGGu1BNz5kHyx3BRKLKSwmIEX8SQzq
3l5PYiSxKNaaKsus1mPW5DSFgYxzheNI3uJ6i5brleVWvpqio1DQJBN8schrljsexyyBgijn
8KU6p5d0VoNML8msBhUZV7WO9iNW05lPYrXUmIO8iYYYUA6imN6eQlE6O4O3JoYEieCMAkM7
1cAeGsMB6IMhHyfkCUjJj2bOHFNTqJInPTkplSfpghZHml/tGqashxBj4kdqQgmIgWbr6Enm
sEHHx2TQiUq9n3F21iOb0I2tsB7jyUjC2pCVjFHWhDdVx6uYj2R6bqU0R0eOyZ78TiZk3zG3
ZV1RN+WOylryI080ZYm2UgApMY3C4FaEj6oqvWoS/x68pWePV+WKmeT/ZzK9psDXZbq+2I2t
m1OVaP6TCfY9sqglqbIsOi6TCCNaxLAKEmiAhCWvEGXOx9G2gZ3jYPTa2F0vG5fCvoJ6U2nZ
N74laaDEJrAybMf2rjF6jYbsDIzRTnGzsmJDWbBefudSOU6lc5USELcH/656+dKy5+LkGtuk
maeBTHOZ5bSWGsZGC+KG19U9CvuFwHWyuxjZJdJfB41sW2o07O4W8U01pTJF076OUg2aikex
ONT0KnWCp0afn10xfeVZ439grA6MzNP/KWCUOi0Ag/zHnVv7CZfj2HlPyp+rXPXqz1z1NqYD
PIi4kSdAozcEjcpnN62HGpkHDhlIvlkkTO7dWYSo5I/9JjuGGn2pHlyWXBRLPDZvflmH6rUv
HbikPfs1PTIrVf5SnAbeXzgn5+eqnJONQwaTs8vz6hQfyfILNsnWDfEUVrpXfSm8K9VFrL80
oF/cTB2d/uIcXXz5dFw0DblMhkO1cShEZodAyJTsPPtJ1eDFPgy2ZddQWV4isEIhr2gKAiwl
mSv/2m9e1rw7+sl5d/r5+INzevKJt8GMsR8LkXuz4p3adOmVwpjCTPPk/affjk7z3Q/jVWQH
ObeAcX04+5Xim8Ir2+Q2M6pn76UYkD8BLJddC7MsFllP1+Gi+sm/Kb083Ut30Q8RN0GCLhHe
LQRJ9GMK2E6E4SNEQowFNiChcB8EBCkgewG/T/kmAY+diZAHzLVQ9UzkV/CovlRgdsldQXEb
w9wLq3lxDWA/B8wi4nVg5sN50azdaWJh51/07F3+Sc9+nf2ml5V6rp9i/nytX70umisEYSW/
dbEpUEiu+RtDfo+1RB0AAA==

--9amGYk9869ThD9tj--

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBS9HAcRS+e2HeSPbpAQLcxQf+ITuMfG3yLjQa+JOm+1ov5F4ay4aGOAKr
aHXCyNJSRVY3J0fJYNHccbZU3Wag7lPeulQLLlwmxfY6FE9g+8WT/d7kZ5MFVKUM
uhz5O6CYIynh7Yj32YTtmDV7a+ETaaJ4r/9quT7cmtkpSFProjycCegoLK5m8A0z
myEBfDTC1r3cu1qlfI/WCYeKPMjKfNnQS0SGWzcnUXmDUKca0lAktWQraKR07AmO
pc5DuXMgZjJT0G3C5Cab4WEuKdLGiRO3NbfpgqZOM9op6Ovhs/l1y8VX0IKbnWds
6/tUbr6pLrK689li1lRh3PhVdPqccTuEkYMq9AxdDYc77aeGck1OWg==
=WEOV
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--
