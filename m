From: Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 1/2] keys: fixed handling of update method of the encrypted key type
Date: Thu, 7 Oct 2010 14:29:24 +0200
Message-ID: <201010071429.24664.roberto.sassu@polito.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1585546.Rar81MA0MJ";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from new1.smtp.messagingengine.com ([66.111.4.221]:44431 "EHLO
	new1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760423Ab0JGM3x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Oct 2010 08:29:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart1585546.Rar81MA0MJ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This patch adds the UPDATE keyword for encrypted key types:
prevents updating existent keys if UPDATE is missing and creating
new keys when UPDATE is specified.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
=2D--
 security/keys/encrypted_defined.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_de=
fined.c
index 6b26db6..54c0f0f 100644
=2D-- a/security/keys/encrypted_defined.c
+++ b/security/keys/encrypted_defined.c
@@ -64,7 +64,8 @@ static int aes_get_sizes(int *ivsize, int *blksize)
 }
=20
 enum {
=2D	Opt_err =3D -1, Opt_new =3D 1, Opt_load, Opt_NEW, Opt_LOAD
+	Opt_err =3D -1, Opt_new =3D 1, Opt_load,=20
+	Opt_update, Opt_NEW, Opt_LOAD, Opt_UPDATE
 };
=20
 static match_table_t key_tokens =3D {
@@ -72,6 +73,8 @@ static match_table_t key_tokens =3D {
 	{Opt_NEW, "NEW"},
 	{Opt_load, "load"},
 	{Opt_LOAD, "LOAD"},
+	{Opt_update, "update"},
+	{Opt_UPDATE, "UPDATE"},
 	{Opt_err, NULL}
 };
=20
@@ -81,6 +84,7 @@ static match_table_t key_tokens =3D {
  * datablob format:
  * NEW <master-key name> <decrypted data length>
  * LOAD <master-key name> <decrypted data length> <encrypted iv + data>
+ * UPDATE <new-master-key name>
  *
  * Tokenizes a copy of the keyctl data, returning a pointer to each token,
  * which is null terminated.
@@ -104,23 +108,36 @@ static int datablob_parse(char *datablob, char **mast=
er_desc,
 	*master_desc =3D strsep(&datablob, " \t");
 	if (!*master_desc)
 		goto out;
=2D	*decrypted_datalen =3D strsep(&datablob, " \t");
=2D	if (!*decrypted_datalen)
=2D		goto out;
+
+	if (decrypted_datalen) {
+		*decrypted_datalen =3D strsep(&datablob, " \t");
+		if (!*decrypted_datalen)
+			goto out;
+	}
=20
 	switch (key_cmd) {
 	case Opt_new:
 	case Opt_NEW:
+		if (!decrypted_datalen)
+			break;
 		ret =3D 0;
 		break;
 	case Opt_load:
 	case Opt_LOAD:
+		if (!decrypted_datalen)
+			break;
 		*hex_encoded_iv =3D strsep(&datablob, " \t");
 		if (!*hex_encoded_iv)
 			break;
 		*hex_encoded_data =3D *hex_encoded_iv + (2 * ivsize) + 2;
 		ret =3D 0;
 		break;
+	case Opt_update:
+	case Opt_UPDATE:
+		if (decrypted_datalen)
+			break;
+		ret =3D 0;
+		break;
 	case Opt_err:
 		break;
 	}
@@ -647,11 +664,9 @@ static int encrypted_update(struct key *key, const voi=
d *data, size_t datalen)
 		return -ENOMEM;
=20
 	memcpy(buf, data, datalen);
=2D	new_master_desc =3D strsep(&buf, " \t");
=2D	if (!*new_master_desc) {
=2D		ret =3D -EINVAL;
+	ret =3D datablob_parse(buf, &new_master_desc, NULL, NULL, NULL);
+	if (ret < 0)
 		goto out;
=2D	}
=20
 	new_epayload =3D encrypted_key_alloc(key, new_master_desc,
 					   epayload->datalen);
=2D-=20
1.7.2.3


--nextPart1585546.Rar81MA0MJ
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQCTCCBLMw
ggOboAMCAQICARQwDQYJKoZIhvcNAQEFBQAwQTEQMA4GA1UEChMHRXVyb1BLSTEtMCsGA1UEAxMk
RXVyb1BLSSBSb290IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA2MTAyNDEzMzEzM1oXDTEw
MTIzMTEyNTk1OVowUTELMAkGA1UEBhMCSVQxEDAOBgNVBAoTB0V1cm9QS0kxMDAuBgNVBAMTJ0V1
cm9QS0kgSXRhbGlhbiBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAPbJ3y5bE0iL2iFW59R4KGHS3iTc22mq2GlDaOZLE3Xz1wTvB/yBl5e4ntMZ
eEeWTW9JInNRTtfC3mcLk0gnEdK1rQZbe4lQwBVHdkG8LvRQDWHIkZNuccoUpQXMv+JbZjI6m7rH
fU2CN/YCvFY9QL08xXsfDxvX2Ee4S7EwJiSEEJSiy+R00uTfvfn27d8a6LCqYLzlInRlz4C2CUbk
+U2UAwjYEPTP2ziqFxztysbxC3fjqH8e6P5wIPXOS5cSYnVaEyp21VXhAOamVJEGlQCdVoTHs+pP
BYqCBuNhBfienUPaEDHHUUYHZ2nS4eNzd9XOu+5hFi1/8hVZxN4sbdECAwEAAaOCAaQwggGgMEwG
CWCGSAGG+EIBDQQ/Fj1Jc3N1ZWQgdW5kZXIgcG9saWN5OgogaHR0cDovL3d3dy5ldXJvcGtpLm9y
Zy9jYS9yb290L2Nwcy8xLjEvMGUGCCsGAQUFBwEBBFkwVzAoBggrBgEFBQcwAYYcaHR0cDovL29j
c3AuZXVyb3BraS5vcmc6ODAyNjArBggrBgEFBQcwAoYfaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9j
YS9yb290LzA7BgNVHR8ENDAyMDCgLqAshipodHRwOi8vd3d3LmV1cm9wa2kub3JnL2NhL3Jvb3Qv
Y3JsL2NybC5kZXIwDAYDVR0TBAUwAwEB/zBOBgNVHSAERzBFMEMGCisGAQQBqQcBAQEwNTAzBggr
BgEFBQcCARYnaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9yb290L2Nwcy8xLjEvMA4GA1UdDwEB
/wQEAwIB9jAdBgNVHQ4EFgQUjl4HtzG0Gbu5BJU0rMX9016KQsAwHwYDVR0jBBgwFoAUjNyLsaVK
kOdOiHMYPJ3VXn7kss0wDQYJKoZIhvcNAQEFBQADggEBAFjlAWMiL7uhEAVcrPeMXsbQU+bQNbP1
TBqyBoMCMJ4RakM7/67AsmqpKGIYwhjVkSNHhscRl5BuSiyviHOLbWUJ9tAAKt6hzMDr1J4OvWSH
Sn8y9fSlyQU8+fQE8FHxXT3Aa7aLYVqsqr0ppmxRDL/9b/mdUVcMXiKFAdopFzhXIigfZFh6MW/o
7/GEiDMGsovCiwKJ5ZL46zGRDaS+O0aRYQv2PHZaWrC8i0OPwghlTeB2DfUBzm0urPijBATdjzP8
yO3YGymFZOIG08Roe4bwzrANGzX5luBk3lNmtXTPHoUtRLn3ADa+IUGwK6VYWHYJe1+uUHRNziQu
/Zsb858wggU/MIIEJ6ADAgECAgIJzzANBgkqhkiG9w0BAQUFADBRMQswCQYDVQQGEwJJVDEQMA4G
A1UEChMHRXVyb1BLSTEwMC4GA1UEAxMnRXVyb1BLSSBJdGFsaWFuIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5MB4XDTA2MTEwNjE3MTU1OVoXDTEwMTIzMTEyNTk1OVowZTELMAkGA1UEBhMCSVQxHjAc
BgNVBAoTFVBvbGl0ZWNuaWNvIGRpIFRvcmlubzE2MDQGA1UEAxMtUG9saXRlY25pY28gZGkgVG9y
aW5vIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEA/s1vopfmSp2eqKG/jW4H5YyfrZc/jWEnctMMm7TlVT+ryxJ2ifYV/7VyuYVIGdnCBnmJiav6
uhePqpHyuejEZ+IdCchk04BSBbgzkSbWakw2ekv1SKm8WfvhxHbiSo/t//LQEANMJ+XeeqGl1TRR
8gdMC6erWFGdl5FcuOpMoaqW6DszVGlOAf7Uo/DExZ0/9cw77GTRoDTA3vi1QJEYGaAAvI2/flaU
8gn4QoktjowchDXBylVsyqs+ux3v7m3H0cgC3q62t2om2badk40F9XH1w2WPLQB6rSl+TPDxkl2k
kR4goQprXR0b0OujS5ADq5Ds2w7YPj5h4J6ebsbIUQIDAQABo4ICCzCCAgcwdQYJYIZIAYb4QgEN
BGgWZklzc3VlZCB1bmRlciBwb2xpY2llczoKIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Evcm9v
dC9jcHMvMS4xLwogaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLzBcBggrBgEF
BQcBAQRQME4wKAYIKwYBBQUHMAGGHGh0dHA6Ly9vY3NwLmV1cm9wa2kub3JnOjgwMjYwIgYIKwYB
BQUHMAKGFmh0dHA6Ly93d3cuZXVyb3BraS5vcmcwPAYDVR0fBDUwMzAxoC+gLYYraHR0cDovL3d3
dy5ldXJvcGtpLm9yZy9jYS9pdDIvY3JsMDMvY3JsLmRlcjAPBgNVHRMBAf8EBTADAQH/MIGTBgNV
HSAEgYswgYgwQwYKKwYBBAGpBwEBATA1MDMGCCsGAQUFBwIBFidodHRwOi8vd3d3LmV1cm9wa2ku
b3JnL2NhL3Jvb3QvY3BzLzEuMS8wQQYKKwYBBAGpBwIBATAzMDEGCCsGAQUFBwIBFiVodHRwOi8v
d3d3LmV1cm9wa2kub3JnL2NhL2l0L2Nwcy8xLjEvMAsGA1UdDwQEAwIB9jAdBgNVHQ4EFgQUCf0l
GW/jaHyCazVzvCgAviw8OjgwHwYDVR0jBBgwFoAUjl4HtzG0Gbu5BJU0rMX9016KQsAwDQYJKoZI
hvcNAQEFBQADggEBANfGdD6B98NUwBOVYIiuo+SNfw8Afjr2oFHLYEHYhKdBED1WBckhK610v2zJ
ctramnrqdd+xfyzmkyNm48OtkiVetYzXbgYeyMGxhO8HrJ1Ztf1yEN0lL8HgdK3lmJeLYNYH/cwZ
5SlKwvTR/VENHLYlWsgWk47ut7W8+Zd/ESwzNdJUCBUMoQnGZ3giyhAXKAgIOckwL0g8KmnceY7J
Y4L1G++1OuOoUcgg2jRPxcVmHVEe/cM0WHfUcigDXSBTIxAiDwlQ7ni97yX1RqBV/6IVdRDYKyjg
YkdYcwU9ZuOKUP4Pl5KKCegLOHRoo5kX6V1o7b2IZGBFoVmkag4m4kkwggYLMIIE86ADAgECAgID
wTANBgkqhkiG9w0BAQUFADBlMQswCQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkg
VG9yaW5vMTYwNAYDVQQDEy1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRo
b3JpdHkwHhcNMDgxMjA1MTYwMDAwWhcNMTAxMjMwMTIwMDAwWjB5MQswCQYDVQQGEwJJVDEeMBwG
A1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTEwLwYDVQQLEyhEaXBhcnRpbWVudG8gZGkgQXV0
b21hdGljYSBlIEluZm9ybWF0aWNhMRcwFQYDVQQDEw5Sb2JlcnRvICBTYXNzdTCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBAOS/leMNzG5v7FG73ythWtNPOdq8MEFpzg7mjy4M7UsS9+sc
b7QE8TOX365q/+mBwxZ7qW+OhNKfgv14A3y/quju5P7mjTmTNvKWDpsUBjC+tCs+WpWsgIPc2xxW
PrR7br04U/SYYNsxynh1TtO2gsQrHIj9S/wNiNRP8GGPCAiuYRlaL2CeSVn4JEKcT0zOeLIIqfDp
3Ad3YeBhj+cR3TrmO9TyGTPCAb1oyq9wuA1Tx044rqSQNbp0e0RvOrwAIpD/2mNPP3ReTeB53aSg
q0pCHoH1s2AcY/jWJ1joYFC9hh/2DqZRvMNIsM7Uce5Iiz2sgl1I61IUD4658HYzCmMCAwEAAaOC
Aq8wggKrMIGVBglghkgBhvhCAQ0EgYcWgYRJc3N1ZWQgdW5kZXIgcG9saWNpZXM6CiBodHRwOi8v
d3d3LmV1cm9wa2kub3JnL2NhL3Jvb3QvY3BzLzEuMS8KIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcv
Y2EvaXQvY3BzLzEuMS8KIGh0dHA6Ly9jYS5wb2xpdG8uaXQvY3BzLzIuMS8wEQYJYIZIAYb4QgEB
BAQDAgCwMGMGCCsGAQUFBwEBBFcwVTAoBggrBgEFBQcwAYYcaHR0cDovL29jc3AuZXVyb3BraS5v
cmc6ODAyNjApBggrBgEFBQcwAoYdaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC8wMgYDVR0f
BCswKTAnoCWgI4YhaHR0cDovL2NhLnBvbGl0by5pdC9jcmwwMy9jcmwuZGVyMAwGA1UdEwEB/wQC
MAAwOgYDVR0RBDMwMYEXcm9iZXJ0by5zYXNzdUBwb2xpdG8uaXSgFgYKKwYBBAGVYgIBAaAIFgYw
MjEzMDUwgc0GA1UdIASBxTCBwjBDBgorBgEEAakHAQEBMDUwMwYIKwYBBQUHAgEWJ2h0dHA6Ly93
d3cuZXVyb3BraS5vcmcvY2Evcm9vdC9jcHMvMS4xLzBBBgorBgEEAakHAgEBMDMwMQYIKwYBBQUH
AgEWJWh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2EvaXQvY3BzLzEuMS8wOAYKKwYBBAGVYgECATAq
MCgGCCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjEvMAsGA1UdDwQEAwIE8DAd
BgNVHQ4EFgQUP+37DpRL6r5BNjgsgFjI8MHvGTcwHwYDVR0jBBgwFoAUCf0lGW/jaHyCazVzvCgA
viw8OjgwDQYJKoZIhvcNAQEFBQADggEBADRj0OWMglzLXTPuKND9gMTHd1iRPzRNI1TiYFN/WIyu
a3mNev65wKn35VxbbMV6k7zuxxdC7o+iYRLepVOnpw90Af/SiJRc9QI4rk8tzSr5xII7vI0fPvcl
rjSMymXCvwKrbYwrKe0FhBnSZ8AoewXoHDQ8f64heLIU8mLWuwo1+brq0pJUH5Q+69WAGD03ln+l
Fhk2KqvVv8yAD21PydrS7Uk2ZLE7l7/+BTQBY8ZjpNRZ44C6+o7lou2zN6lkWtVHBwUNVdfu3wkS
TdtCm/yxR8XUlFyZkLHfhY19VW4luxb7KZ4GiPKDERdQwBb0kja4eqSOBkAPWZ9Y8zpv4bAxggIc
MIICGAIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8x
NjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQIC
A8EwCQYFKw4DAhoFAKCBhzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0xMDEwMDcxMjI5MjRaMCMGCSqGSIb3DQEJBDEWBBSAC8t+y56Wm6df+BW5zFFd7/llRjAoBgkq
hkiG9w0BCQ8xGzAZMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQEFAASCAQC1
KxrSxYY9zAH4lDxYJ9kFU/E4TSmOvuy9L5W4RWg2fnEpG/Oe3VX7QLFCnnSBLViNVQvk6cSBHQJk
tl+3iw99b3r2t4oK5gLcJmgjzQTGvuWt/IW+a29TPT/5BuQeGEFI066K9u6+Lx/2Pc4rs1YG5vS1
15euK05iUsyHc3xfq0veO4HDYIqa4W1ZlWG5v2hW+z6bNTDGFoZ0zqTZt/32nHsDbXheF8hEdKcz
VabFJ9t8Nh6u7mvZMKVcVnGBfOwzWM2bIzcpYQkHILKeM/IVsKA+EP1qx1ivQ6EKw8oFVm1p9Akn
wGZZ3QWGzA5vb57FnxS5OohWcWPAiIVxMV6qAAAAAAAA

--nextPart1585546.Rar81MA0MJ--
