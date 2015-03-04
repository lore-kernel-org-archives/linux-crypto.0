From: Andreas Steffen <andreas.steffen@strongswan.org>
Subject: Re: IPSec hmac(sha256) truncation bits length
Date: Wed, 04 Mar 2015 19:38:21 +0100
Message-ID: <54F7511D.6070604@strongswan.org>
References: <CAH=tA9Fnd6+gHsvjCv8oXqRVGLtdV9jr-KP1hxUGFg5orC5Qcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030808000005030405090609"
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: Nicolae Rosia <nicolae.rosia@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:55747 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610AbbCDSqD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Mar 2015 13:46:03 -0500
In-Reply-To: <CAH=tA9Fnd6+gHsvjCv8oXqRVGLtdV9jr-KP1hxUGFg5orC5Qcw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030808000005030405090609
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Nicolae,

up to the Linux 2.6.32 kernel the SHA256 hash was erroneously truncated
to 96 bits. With Linux 2.6.33 the correct truncation to 128 bits
was introduce as well as the SHA384_192 and SHA512_256 data integrity
algorithms. If you want to apply the correct SHA2 truncation, use
XFRMA_ALG_AUTH_TRUNC instead of XFRMA_ALG_AUTH.

Best regards

Andreas

On 03/04/2015 06:13 PM, Nicolae Rosia wrote:
> Hello,
>=20
> I'm trying to understand why icv_truncbits is set to 96 for
> hmac(sha256) in xfrm_algo.c because
> RFC4868 [1] says that the truncation length for HMAC-SHA256 should be 1=
28.
> Am I looking in the wrong place?
>=20
> [1] https://tools.ietf.org/html/rfc4868#section-2.6
>=20
> Best regards,
> Nicolae Rosia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Andreas Steffen                         andreas.steffen@strongswan.org
strongSwan - the Open Source VPN Solution!          www.strongswan.org
Institute for Internet Technologies and Applications
University of Applied Sciences Rapperswil
CH-8640 Rapperswil (Switzerland)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D[ITA-HSR]=3D=3D


--------------ms030808000005030405090609
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMhDCC
BjQwggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDE1NVoXDTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOr
lr6KMoOMpohBllVHrdRvEg/q6r8jR+EK75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSM
zR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6
qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxDz2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSD
kOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr/+N2JLKutIxMYqQOJebr/f/h5t95
m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFcfH6WNU7y1LhRgjAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqD
CH14qywGXLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy
6QMVQjbbMXltUfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPI
zKKR9tQW8gGK+2+RHxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKf
KSETEPrHh7p5shuuNktvsv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HOR
z9v3vQwR4e3ksLc2JZOAFK+ssS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9
sIPP7ON0fz095HdThKjiVJe6vofq+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCie
uoBJ9OlqmsVWQvifIYf40dJPZkk9YgGTzWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7t
w1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGqUp/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQ
G2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb19mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t
5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIGSDCCBTCgAwIBAgIDC0oMMA0GCSqGSIb3DQEB
CwUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMi
U2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20g
Q2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcNMTQwOTIyMTc0MjM0
WhcNMTUwOTIzMTYyNzUyWjBYMScwJQYDVQQDDB5hbmRyZWFzLnN0ZWZmZW5Ac3Ryb25nc3dh
bi5vcmcxLTArBgkqhkiG9w0BCQEWHmFuZHJlYXMuc3RlZmZlbkBzdHJvbmdzd2FuLm9yZzCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALTWE8Ab5LeaiLpYD1vLjg3OM11mc8CC
t2h2gdZGpCg5Yv9awYOy1zd8VlXPoOnVtnk2yiXrT9wnz5iZthKfiaqh0fgd18G43svQYuto
nFJX+G0BldOkTWDobhbYc9aGzl927+XDcIf/zMaZOiZXsU4ErCOnhumq4zUNtJX1kFh/haow
CSj4HPI5MDzRLCGPcngE/XKLmSRLaXnBo+BO1AEmSzysCgihNnwxFxpqfm39X1WlharG0wJy
JGXqgXAuXZ7jh2pDH8A9Ww8G4gxv58iiY5VW5wsfiPmbWwQsbIDIXXq6gFKRKi9zWeqchV5r
JW/g/JFw0AFCqgAkmJwtowkCAwEAAaOCAuQwggLgMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSw
MB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUF3XH/qcfHMgVFp7S
4EH1ZE157+8wHwYDVR0jBBgwFoAUU3Ltkpzg2ssBXHx+ljVO8tS4UYIwKQYDVR0RBCIwIIEe
YW5kcmVhcy5zdGVmZmVuQHN0cm9uZ3N3YW4ub3JnMIIBTAYDVR0gBIIBQzCCAT8wggE7Bgsr
BgEEAYG1NwECAzCCASowLgYIKwYBBQUHAgEWImh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3Bv
bGljeS5wZGYwgfcGCCsGAQUFBwICMIHqMCcWIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5MAMCAQEagb5UaGlzIGNlcnRpZmljYXRlIHdhcyBpc3N1ZWQgYWNjb3JkaW5nIHRv
IHRoZSBDbGFzcyAxIFZhbGlkYXRpb24gcmVxdWlyZW1lbnRzIG9mIHRoZSBTdGFydENvbSBD
QSBwb2xpY3ksIHJlbGlhbmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBwdXJwb3NlIGluIGNv
bXBsaWFuY2Ugb2YgdGhlIHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMDYGA1UdHwQvMC0w
K6ApoCeGJWh0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL2NydHUxLWNybC5jcmwwgY4GCCsGAQUF
BwEBBIGBMH8wOQYIKwYBBQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xh
c3MxL2NsaWVudC9jYTBCBggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2Vy
dHMvc3ViLmNsYXNzMS5jbGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3Rh
cnRzc2wuY29tLzANBgkqhkiG9w0BAQsFAAOCAQEAC5bWzDjemB04RK3lLPYsMhvYGUg58HL6
SUlMl6yZm8VSG5Y3VDgJPLSrpLdGpXJwwP+d7kJ1zxETcd7/ouoXLTcSkTeglnZemEV8M6wd
DNPuGCc3klL7g2hWH22F0/OZkgY/HMMLtpPQcGyAzh83qr2ISJPBY9Pw6tqVOKGIKB/EhQey
rZkMtYuAO6TlKYIwO0FZxqB+Ot1Cp8ocwwzXe504eD+MHAdR8Ikz1hh4KyEqn/p7DBeYhrhY
7ZsCEkRf8eb8ckiJ2XzY/sDmmgby/toBx3m2XISu38Qfu2BdCFdMbBjr9ZcnYMjit+XdNmvT
uCNgX3k/cGlTa7scuAkc8DGCA90wggPZAgEBMIGUMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UE
ChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUg
U2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0
ZSBDbGllbnQgQ0ECAwtKDDAJBgUrDgMCGgUAoIICHTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0xNTAzMDQxODM4MjFaMCMGCSqGSIb3DQEJBDEWBBQSVj8B
XWPtdBrWf+3+D+DniIjZuzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIHMA0GCCqGSIb3DQMCAgEoMIGlBgkrBgEEAYI3EAQxgZcwgZQwgYwxCzAJBgNVBAYTAklM
MRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0
aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50
ZXJtZWRpYXRlIENsaWVudCBDQQIDC0oMMIGnBgsqhkiG9w0BCRACCzGBl6CBlDCBjDELMAkG
A1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdp
dGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJp
bWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMLSgwwDQYJKoZIhvcNAQEBBQAEggEAchee
n8i39mPcrEftpShHBxZ4jd7Y9Gd0t5XoiqIW1SzWF6kBks1rd1etgoUp5hjDuVPBNRBnlgrX
wugZLSckL7Hqcqla535nT/Z0rp3BcFeX7JWQTd9jzo+iI5p7s11iK9fyHK3IO5HcqJL8BeLe
cOU3E0KOvloA0hqJI+8EhbCRnrox2C0CisS6ZynSBJHbsyjHrTdkjH9JrTUn046j+7NkPnqx
uGxFa23Khc7DO6ZJd4A1ona//inPu2RpmjccaT1yeJ0pmvyim09LgIR1wjYViKW/93pgxTJb
ooW2GLPjoNc32cY6CFJupCTVsnXO/c1EBNIJl1mpMukvxErbLwAAAAAAAA==
--------------ms030808000005030405090609--
