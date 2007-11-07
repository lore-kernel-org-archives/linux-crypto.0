From: "Lynch, Jonathan" <jonathan.lynch@intel.com>
Subject: RE: [PATCH] [CRYPTO] Extend sha256_generic.c to support SHA-224and SHA-224-HMAC
Date: Wed, 7 Nov 2007 12:33:05 -0000
Message-ID: <38C7DA95A2704445A1BE05F909D67CC603153863@irsmsx411.ger.corp.intel.com>
References: <20071106190242.GC15572@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="AUDPD.4FbNqDkSY.1PoV/Z.9bVCDGy"
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	"Lynch, Jonathan" <jonathan.lynch@intel.com>
To: "Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54538 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbXKGMdS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Nov 2007 07:33:18 -0500
In-Reply-To: <20071106190242.GC15572@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--AUDPD.4FbNqDkSY.1PoV/Z.9bVCDGy
MIME-Version: 1.0
Content-class: urn:content-classes:message
Content-Type: multipart/signed;
	protocol="application/x-pkcs7-signature";
	micalg=SHA1;
	boundary="----=_NextPart_000_001D_01C8213A.584F2220"

------=_NextPart_000_001D_01C8213A.584F2220
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Answered questions inline. 

I will regenerate the patch and submit it to fix the issues with the
numbering of test cases and remove the additional line.

Regards
Jonathan

-----Original Message-----
From: Sebastian Siewior [mailto:linux-crypto@ml.breakpoint.cc] 
Sent: Tuesday, November 06, 2007 19:03
To: Lynch, Jonathan
Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
Subject: Re: [PATCH] [CRYPTO] Extend sha256_generic.c to support SHA-224and
SHA-224-HMAC

* Jonathan Lynch | 2007-11-06 18:28:00 [+0000]:

>SHA-224 should be chosen as a hash algorithm when 112 bits of security
>strength is required.

Who uses such an algorithm (in terms of application)?

[JL] 
Other crypto algorithms to offer 112 bits of security are as follows:
	3-key Triple DES
	DSA L=2048, N=224	 (DSA2 - fips 186-3)
	RSA K=2048	
	Elliptic-curve ciphers F=224

fips 186-3 recommends new sizes for DSA
   old size : DSA 1024 - SHA 160 in fips 186-2 chnage notice 1
   new sizes : DSA 2048  SHA 224   , DSA 3072 SHA 256
   This is more generally known as DSA2
http://csrc.nist.gov/publications/PubsDrafts.html
http://csrc.nist.gov/publications/drafts/fips_186-3/Draft-FIPS-186-3%20_Marc
h2006.pdf
section 4.2

RFC 4055
   sha 224 used with RSA padding

In Intel we use Crypto API to validate and benchmark our QuickAssist
hardware acceleration of hash and cipher algorithms. SHA-224 is currently
the only SHA2 algorithm not supported in the Linux kernel. 


>diff -uprN -X linux-2.6.24-rc1-vanilla/Documentation/dontdiff
linux-2.6.24-rc1-vanilla/crypto/tcrypt.c linux-2.6.24-rc1/crypto/tcrypt.c
>--- linux-2.6.24-rc1-vanilla/crypto/tcrypt.c	2007-11-05
17:12:50.468842000 +0000
>+++ linux-2.6.24-rc1/crypto/tcrypt.c	2007-11-06 10:20:30.985270000 +0000
>@@ -1097,10 +1102,14 @@ static void do_test(void)
> 		break;
> 
> 	case 6:
>-		test_hash("sha256", sha256_tv_template,
SHA256_TEST_VECTORS);
>+		test_hash("sha224", sha224_tv_template,
SHA224_TEST_VECTORS);
> 		break;
> 
> 	case 7:
>+		test_hash("sha256", sha256_tv_template,
SHA256_TEST_VECTORS);
>+		break;
>+
>+	case 8:
> 		test_cipher("ecb(blowfish)", ENCRYPT, bf_enc_tv_template,
> 			    BF_ENC_TEST_VECTORS);
> 		test_cipher("ecb(blowfish)", DECRYPT, bf_dec_tv_template,
>@@ -1111,7 +1120,7 @@ static void do_test(void)
> 			    BF_CBC_DEC_TEST_VECTORS);
> 		break;
> 
>-	case 8:
>+	case 9:
> 		test_cipher("ecb(twofish)", ENCRYPT, tf_enc_tv_template,
> 			    TF_ENC_TEST_VECTORS);
> 		test_cipher("ecb(twofish)", DECRYPT, tf_dec_tv_template,

Extend does not mean you change the user interface of the module. Please
pick your own number. This breaks atleast two of mine scripts.

[JL] Motivation was to keep sha224 tests beside sha256 tests. I will give
the sha224 tests new numbers at the end of each group in the switch
statement.

>diff -uprN -X linux-2.6.24-rc1-vanilla/Documentation/dontdiff
linux-2.6.24-rc1-vanilla/crypto/tcrypt.h linux-2.6.24-rc1/crypto/tcrypt.h
>--- linux-2.6.24-rc1-vanilla/crypto/tcrypt.h	2007-11-05
17:12:50.492842000 +0000
>+++ linux-2.6.24-rc1/crypto/tcrypt.h	2007-11-05 18:18:31.610720000 +0000
>@@ -173,6 +173,33 @@ static struct hash_testvec sha1_tv_templ
> 	}
> };
> 
>+
>+/*
>+ * SHA224 test vectors from from FIPS PUB 180-2
>+ */
>+#define SHA224_TEST_VECTORS     2
>+
>+static struct hash_testvec sha224_tv_template[] = {
>+	{
>+		.plaintext = "abc",
>+		.psize  = 3,
>+		.digest = { 0x23, 0x09, 0x7D, 0x22, 0x34, 0x05, 0xD8, 0x22,
>+			0x86, 0x42, 0xA4, 0x77, 0xBD, 0xA2, 0x55, 0xB3,
>+			0x2A, 0xAD, 0xBC, 0xE4, 0xBD, 0xA0, 0xB3, 0xF7,
>+			0xE3, 0x6C, 0x9D, 0xA7},
>+	}, {
>+		.plaintext =
>+		"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
>+		.psize  = 56,
>+		.digest = { 0x75, 0x38, 0x8B, 0x16, 0x51, 0x27, 0x76, 0xCC,
>+			0x5D, 0xBA, 0x5D, 0xA1, 0xFD, 0x89, 0x01, 0x50,
>+			0xB0, 0xC6, 0x45, 0x5C, 0xB4, 0xF5, 0x8B, 0x19,
>+			0x52, 0x52, 0x25, 0x25 },
>+		.np     = 2,
>+		.tap    = { 28, 28 }
>+	}
>+};
>+
> /*
>  * SHA256 test vectors from from NIST
>  */
>@@ -753,6 +780,7 @@ static struct hash_testvec hmac_md5_tv_t
> 	},
> };
> 
>+
> /*
>  * HMAC-SHA1 test vectors from RFC2202
>  */
>@@ -817,6 +845,121 @@ static struct hash_testvec hmac_sha1_tv_
> 	},
> };
> 
>+
>+/*
>+ * SHA224 HMAC test vectors from RFC4231
>+ */
>+#define HMAC_SHA224_TEST_VECTORS    4
>+
>+static struct hash_testvec hmac_sha224_tv_template[] = {

Please don't introduce any empty lines. You could save hunk #2 btw :)
[JL] I will remove this.

Sebastian

------=_NextPart_000_001D_01C8213A.584F2220
Content-Type: application/x-pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIXITCCAyAw
ggKJoAMCAQICBDXe9M8wDQYJKoZIhvcNAQEFBQAwTjELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0Vx
dWlmYXgxLTArBgNVBAsTJEVxdWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw05
ODA4MjIxNjQxNTFaFw0xODA4MjIxNjQxNTFaME4xCzAJBgNVBAYTAlVTMRAwDgYDVQQKEwdFcXVp
ZmF4MS0wKwYDVQQLEyRFcXVpZmF4IFNlY3VyZSBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwgZ8wDQYJ
KoZIhvcNAQEBBQADgY0AMIGJAoGBAMFdsVhnCGLuoJotHwhtkRRomAoe/toEbxOEYiHD0XzOnwXg
uAHwTjTs4oqVBGSs8WtTXwWzy2eAv0ICjv7dAQns4QAUT/z78AzdQ7pbK+EfgHCZFVeTFvEPl2q3
wmgjHMxNWTCsUR47ryvW7mNFe8XZX1DS41APOojnvxT94Me5AgMBAAGjggEJMIIBBTBwBgNVHR8E
aTBnMGWgY6BhpF8wXTELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0VxdWlmYXgxLTArBgNVBAsTJEVx
dWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTENMAsGA1UEAxMEQ1JMMTAaBgNVHRAE
EzARgQ8yMDE4MDgyMjE2NDE1MVowCwYDVR0PBAQDAgEGMB8GA1UdIwQYMBaAFEjmaPkr0rKV10fY
IyAQTzOYkJ/UMB0GA1UdDgQWBBRI5mj5K9KylddH2CMgEE8zmJCf1DAMBgNVHRMEBTADAQH/MBoG
CSqGSIb2fQdBAAQNMAsbBVYzLjBjAwIGwDANBgkqhkiG9w0BAQUFAAOBgQBYzinq/Pfetc4CuRe1
hdG54+CVzCUxDQCmkm5/tpJjnlCV0Zpv5BHeY4VumO6o/1rI01WyZnFX3sAh6z0qpyNJAQSGQnv8
7n+iFlK1Z2fTQNs7JliyKHc9rhR3Ydb6KmYnoA36p3Nc6nDxlCFlRF/6/O8paKmih3nvee9PrAd3
ODCCAz0wggKmoAMCAQICAwWw/zANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJVUzEQMA4GA1UE
ChMHRXF1aWZheDEtMCsGA1UECxMkRXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
MB4XDTA2MDIxNjE4MDEzMFoXDTE2MDIxOTE4MDEzMFowUjELMAkGA1UEBhMCVVMxGjAYBgNVBAoT
EUludGVsIENvcnBvcmF0aW9uMScwJQYDVQQDEx5JbnRlbCBFeHRlcm5hbCBCYXNpYyBQb2xpY3kg
Q0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBpd/XOb9QVqEZ8mQ1042TdOIq3ATD
IsV2xDyt30yLyMR5Wjtus0bn3B+he89BiNO/LP6+rFzEwlD55PlX+HLGIKeNNG97dqyc30FElEUj
ZzTZFq2N4e3kVJ/XAEEgANzV8v9qp7qWwxugPgfc3z9BkYot+CifozexHLb/hEZj+yISCU61kRZv
uSQ0E11yYL4dRgcglJeaHo3oX57rvIckaLsYV5/1Aj+R8DM1Ppk965XQAKsHfnyT7C4S50T4lVn4
lz36wOdNZn/zegG1zp41lnoTFfT4KuKVJH5x7YD1p6KbgJCKLovnujGuohquBNfdXKpZkvz6pGv+
iC1HawJdAgMBAAGjgaAwgZ0wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBQaxgxKxEdvqNutK/D0
Vgaj7TdUDDA6BgNVHR8EMzAxMC+gLaArhilodHRwOi8vY3JsLmdlb3RydXN0LmNvbS9jcmxzL3Nl
Y3VyZWNhLmNybDAfBgNVHSMEGDAWgBRI5mj5K9KylddH2CMgEE8zmJCf1DAPBgNVHRMBAf8EBTAD
AQH/MA0GCSqGSIb3DQEBBQUAA4GBABMQOK2kVKVIlUWwLTdywJ+e2O+PC/uQltK2F3lRyrPfBn69
tOkIP4SgDJOfsxyobIrPLe75kBLw+Dom13OBDp/EMZJZ1CglQfVV8co9mT3aZMjSGGQiMgkJLR3j
Mfr900fXZKj5XeqCJ+JP0mEhJGEdVCY+FFlksJjV86fDrq1QMIIFYzCCBEugAwIBAgIKYSyl/gAA
AAAABjANBgkqhkiG9w0BAQUFADBSMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9y
YXRpb24xJzAlBgNVBAMTHkludGVsIEV4dGVybmFsIEJhc2ljIFBvbGljeSBDQTAeFw0wNjAzMjIy
MjIyNDdaFw0xMjAzMjIyMjMyNDdaMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jw
b3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQjCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMDoHJYUGvcdR4k0Qv8/RrwNX4+vEe5PN2LnGn4x
fIWwdUbk5+zvrRy1HjoKdG/AShZfxAuFoVyNIah5GJLpiS/vGbsDYKK+EZcIcmtPfvbB9Yg09EnQ
0OpsZ2ORRd5lYUfMUU+zkpgL96vKFdkiG+eeHEwnSS3VikGVrF7UDdKfvxZwRwQCx6rEHAFPCjBD
VfGYZuYT1EDhSDvzEiU7KzBsxrdBCFU4RYL7kh+do+vyMDlBzpw3WKvMVbf3s5lxYiY7AjEhU8OS
yZEQlgtK8PNyifHjmyrSaeJrPshM3PuLFG4d3gm1UJEiGNzxcHGb6YLP29IQAwY5mAk8j+UOVcsC
AwEAAaOCAjUwggIxMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFG/DcREooZ0ZV/VnV8/ZKSaI
1aWiMAsGA1UdDwQEAwIBhjAQBgkrBgEEAYI3FQEEAwIBADAZBgkrBgEEAYI3FAIEDB4KAFMAdQBi
AEMAQTAfBgNVHSMEGDAWgBQaxgxKxEdvqNutK/D0Vgaj7TdUDDCBvQYDVR0fBIG1MIGyMIGvoIGs
oIGphk5odHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFs
JTIwQmFzaWMlMjBQb2xpY3klMjBDQS5jcmyGV2h0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29t
L3JlcG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNy
bDCB4wYIKwYBBQUHAQEEgdYwgdMwYwYIKwYBBQUHMAKGV2h0dHA6Ly93d3cuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUy
MENBLmNydDBsBggrBgEFBQcwAoZgaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3Np
dG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0Eu
Y3J0MA0GCSqGSIb3DQEBBQUAA4IBAQBAiWWHL6T21QXFZDyaUIye0jh7f40GXqi75Ro5JbpROtlZ
BqyRq6oPMAG6Igxd5Bd9TMtNkOvguknFnK1y17UdMhLOl+FuInE+FAWk803aRW27OsX+ot0KmPio
KnZ3L1K5qcQS3tp6or7AaZzd0w0qFitm4UfP9nnTXQtY9XM5QJ07IKFDE3tlOlamKhjbiJV3FKig
CVesPZSx9h2G7Ve4irEfz915Vks26AJHGZagEHNxM9exkgem4ENsG+t0vYqn9x7YsqJ6fmbOSyrz
jzb3CYeEfyE5SL+f3Vx9uMsQDyb8LVCDBXQtxLEHnFEBPrRSSF9kPmyjavx4UqFdPEyCMIIFgzCC
BGugAwIBAgIKevQKHwAAAAAGdzANBgkqhkiG9w0BAQUFADBWMQswCQYDVQQGEwJVUzEaMBgGA1UE
ChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3Vp
bmcgQ0EgM0IwHhcNMDYxMTIyMTc0NDU0WhcNMDkxMTIxMTc0NDU0WjBDMRgwFgYDVQQDEw9MeW5j
aCwgSm9uYXRoYW4xJzAlBgkqhkiG9w0BCQEWGGpvbmF0aGFuLmx5bmNoQGludGVsLmNvbTCBnzAN
BgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAxcJQztcKg0o/iva3hItjYasH4nk04lORSDY9iHDrMwli
PLYCsM9Bc4CnVE1572ontvQAS/TjWn4N+Crj77vFV1c6fnxbeTtXuJvv8l1nhA04RPEU560wh6oo
SSRnxnZbXHwep9FrEHUW2rtwEc8O6xQ7SgBtlKK3Rs450dHpT7sCAwEAAaOCAugwggLkMAsGA1Ud
DwQEAwIHgDAdBgNVHQ4EFgQUP6sh9vHusvvvz0BxiDaINy9fwz8wPAYJKwYBBAGCNxUHBC8wLQYl
KwYBBAGCNxUIhsOMdYSZ5VGD/YEohY6fU4KRwAlngd69OZXwQwIBZAIBAzAfBgNVHSMEGDAWgBRv
w3ERKKGdGVf1Z1fP2SkmiNWlojCByQYDVR0fBIHBMIG+MIG7oIG4oIG1hlRodHRwOi8vd3d3Lmlu
dGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5n
JTIwQ0ElMjAzQi5jcmyGXWh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkv
Q1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNCLmNybDCB7wYI
KwYBBQUHAQEEgeIwgd8waQYIKwYBBQUHMAKGXWh0dHA6Ly93d3cuaW50ZWwuY29tL3JlcG9zaXRv
cnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUy
MDNCLmNydDByBggrBgEFBQcwAoZmaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3Np
dG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENB
JTIwM0IuY3J0MB8GA1UdJQQYMBYGCCsGAQUFBwMEBgorBgEEAYI3CgMMMCkGCSsGAQQBgjcVCgQc
MBowCgYIKwYBBQUHAwQwDAYKKwYBBAGCNwoDDDBNBgNVHREERjBEoCgGCisGAQQBgjcUAgOgGgwY
am9uYXRoYW4ubHluY2hAaW50ZWwuY29tgRhqb25hdGhhbi5seW5jaEBpbnRlbC5jb20wDQYJKoZI
hvcNAQEFBQADggEBAGtySYRQjc7QnIFYSqcxuTnsGbejjSGtgHz42+CT7R5TpqawTwagW+nKYbkz
ZBdZy9qqYIiIe6/wmWxek6e10fc3tjsRYZD3PNtzSgJmuSNFsgtGABOaHXFAFZ2+cXwuPS4XrYnh
qMlOJbvpRvSm0Gwzm5dg0Sv18yMG5t96B9XC3XJ8uJCsryFkotVmn/yMTbHNIIHQneg//mVky/ec
N/WMXJXJXZ+wmUxr9SDzWn8+rivFqzHs1nz7SSxmHqMA9hOUZ1VUBF3dRqxgoy8m95eJkO+U0tdO
txHqMcLaKwKg+i18BOCOhoA+uT7tjj+I7bMBF4m1B9IB4o4nhLW4mR4wggXKMIIEsqADAgECAgpv
TxiZAAAAAAY5MA0GCSqGSIb3DQEBBQUAMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBD
b3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQjAe
Fw0wNjExMjAxMTI4NTJaFw0wOTExMTkxMTI4NTJaMEMxGDAWBgNVBAMTD0x5bmNoLCBKb25hdGhh
bjEnMCUGCSqGSIb3DQEJARYYam9uYXRoYW4ubHluY2hAaW50ZWwuY29tMIGfMA0GCSqGSIb3DQEB
AQUAA4GNADCBiQKBgQCmW3n7+FMGM8pnhCAGfkZ2AiICavk/sEHznDrwvMbbCbNYx2/Sdyxqw5dp
JYv5yAoWQqE4JUnjqBGm9YViq5CG8q2XTX9z75/ooKajO+axYtXY5ubxctmu4rOp4jdv+Ka/mi5x
mOozDGxUkZH7QDnP584KtdU9Sc1SJwovtT/7VwIDAQABo4IDLzCCAyswCwYDVR0PBAQDAgUgMEQG
CSqGSIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwICAgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAK
BggqhkiG9w0DBzAdBgNVHQ4EFgQUJECTWo2GSZz68cpa1SnGVjKR9fIwPQYJKwYBBAGCNxUHBDAw
LgYmKwYBBAGCNxUIhsOMdYSZ5VGD/YEohY6fU4KRwAlnhLnZQYeE/04CAWQCAQYwHwYDVR0jBBgw
FoAUb8NxESihnRlX9WdXz9kpJojVpaIwgckGA1UdHwSBwTCBvjCBu6CBuKCBtYZUaHR0cDovL3d3
dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNz
dWluZyUyMENBJTIwM0IuY3Jshl1odHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0
b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQi5jcmww
ge8GCCsGAQUFBwEBBIHiMIHfMGkGCCsGAQUFBzAChl1odHRwOi8vd3d3LmludGVsLmNvbS9yZXBv
c2l0b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIw
Q0ElMjAzQi5jcnQwcgYIKwYBBQUHMAKGZmh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3Vpbmcl
MjBDQSUyMDNCLmNydDAfBgNVHSUEGDAWBggrBgEFBQcDBAYKKwYBBAGCNwoDBDApBgkrBgEEAYI3
FQoEHDAaMAoGCCsGAQUFBwMEMAwGCisGAQQBgjcKAwQwTQYDVR0RBEYwRKAoBgorBgEEAYI3FAID
oBoMGGpvbmF0aGFuLmx5bmNoQGludGVsLmNvbYEYam9uYXRoYW4ubHluY2hAaW50ZWwuY29tMA0G
CSqGSIb3DQEBBQUAA4IBAQCy8Wg50YC0kRO8VYIrLB0rPlVNJj+vNuhDZXs1FdhszH4bMrcVZQpB
xa/GvDJSnZYW+Nd7v2zsBjCfiycyX63+w8zRBmlk0+Ud/yFtqgunCYW8UjvnfTdKm05X6YA6j54d
rikGhgjdIsfafkchM3uZB/xzAcJH6YJSNfrSC70IuJtvYlE3tN0SE4tHs0bsOCQ3AftT+NlzLJ4U
Zy6zzmO8CUEUd1B1uRAYS73wL5d/s0jdGffPAoOax6lD38ZmvWdtDFTzZFoOk0bDfFvw7XwwO+T1
AFE5ZqRfXhtLd8qokBp4iKcV38kse3EVK01NmrxKdB0txoD5UQiq+FWfOIY3MYICwDCCArwCAQEw
ZDBWMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIklu
dGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgM0ICCnr0Ch8AAAAABncwCQYFKw4DAhoFAKCC
AbIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDcxMTA3MTIzMzA1
WjAjBgkqhkiG9w0BCQQxFgQUOp5KkTjAAoXpeVeZ7cUhFH5VaA0wZwYJKoZIhvcNAQkPMVowWDAK
BggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZI
hvcNAwICASgwBwYFKw4DAhowCgYIKoZIhvcNAgUwcwYJKwYBBAGCNxAEMWYwZDBWMQswCQYDVQQG
EwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFs
IEJhc2ljIElzc3VpbmcgQ0EgM0ICCm9PGJkAAAAABjkwdQYLKoZIhvcNAQkQAgsxZqBkMFYxCzAJ
BgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0
ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQgIKb08YmQAAAAAGOTANBgkqhkiG9w0BAQEFAASBgJxt
eK7zi+zhrrzGRNq3gkUA9kYexQ2obKhlfa5cc96WErR3pwzAONAI8L1sfGu5Buo3k2n6ox346/yp
AvTiPnX3Be/XF5QgyTf+hXufxcls3iMklYTxuOrU57IGJmj0ovAYjjXPNv0haGTZKu7E4fIp94GU
NA6uc5QGrSwBV7qkAAAAAAAA

------=_NextPart_000_001D_01C8213A.584F2220--

--AUDPD.4FbNqDkSY.1PoV/Z.9bVCDGy
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: One Spencer Dock, North Wall Quay, Dublin 1
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--AUDPD.4FbNqDkSY.1PoV/Z.9bVCDGy--
