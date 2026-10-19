Received: from smtp.zfn.uni-bremen.de (smtp.zfn.uni-bremen.de [134.102.50.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7D659A1E3;
	Mon, 19 Oct 2026 14:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.102.50.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792420809; cv=none; b=mDwclXr2X5i2vT+myUylVi62FeFU3RG/k/DBAl8f9Rc6h/m3Bg2hoxkCBDCGOCk4cXbj0Cou4QBaWZZAUT9enu4oMxJYnRmGjRqtg0qOxYKvOiqILBhPUTKN8ag7mFlf4kO6HjYyhJ8pYcomKnFa1p55Ime2lHPV0ULa4AnVMgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792420809; c=relaxed/simple;
	bh=9S5Bkn/vMsmR7T4cxmpuOVhPT2tzjB0mzCrQWT2XyS8=;
	h=Message-ID:Subject:From:To:Cc:Date:References:Content-Type:
	 MIME-Version; b=cLRVsT4Dx5/o6MrUMrK7J+kerfmhv5V0TktQVTbebRk6lJx1MFv8hbnIR8PSEthmj97aHv6lkOvwdh4ToX069ku5zsy2sksVXQoBknSPslJBZ+4L59Dgubk1RkSHProV/o01BLTnXJ8cSkzs6SAXRiqBPrdMzPxmGJ/lhgBUafA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uni-bremen.de; spf=pass smtp.mailfrom=uni-bremen.de; dkim=pass (2048-bit key) header.d=uni-bremen.de header.i=@uni-bremen.de header.b=qCXmtG9a; arc=none smtp.client-ip=134.102.50.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uni-bremen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uni-bremen.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-bremen.de header.i=@uni-bremen.de header.b="qCXmtG9a"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=uni-bremen.de; s=2019;
	t=1792420408; bh=9S5Bkn/vMsmR7T4cxmpuOVhPT2tzjB0mzCrQWT2XyS8=;
	h=Subject:From:To:Cc:Date:References;
	b=qCXmtG9a7UlpbyuyJym9sYzciZcge3bD2LPOerjT8irJqu6ji654aZzTxo/pNT7/o
	 XaoUx2ouZKEk7Ws5pAKWqc3SH0IFQabawNMIIRhXSunOOGzBZurBOxEQSm8iKzplq6
	 8tth0thOofd06WRCKUryPBocykJ4lVSQ1MWbuR96juSK3UqAb2kp+gYjCuE/4s1A2W
	 StxzvCQ5AVwqS99wXHec2GGbCxtiHbfImZZdVM/t0jvrmMsxJtQFIU2uZyR4f1Xjel
	 m2rHvc3NKv2Vqdt14Q1YKGAVC2h699BXHC5Zrp1+IYLrSjPz+muj4lRKILlpIAJOsJ
	 svK/Cpnihs/rw==
Received: from [172.20.227.248] (unknown [134.102.119.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: stahlber)
	by smtp.zfn.uni-bremen.de (Postfix) with ESMTPSA id 4j7dMD07D8zDCbR;
	Mon, 19 Oct 2026 16:33:27 +0200 (CEST)
Message-ID: <9b05b89cf296b8a6392bbe6327228c1bc2f05c49.camel@uni-bremen.de>
Subject: [BUG] X.509: empty Subject DN causes asymmetric-key import to fail
 with EBADMSG
From: Maximilian Stahlberg <maximilian.stahlberg@uni-bremen.de>
To: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
 Ignat Korchagin
	 <ignat@linux.win>
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 19 Oct 2026 16:33:26 +0200
Autocrypt: addr=maximilian.stahlberg@uni-bremen.de; prefer-encrypt=mutual;
 keydata=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
 j5DxrbaIwtf/4P5wc3vh1yk/c=
References: <1792415827.617107.161936276@otrs.zfn.uni-bremen.de>
Organization: University of Bremen
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ZRGFXrNpbv2s8yMbS/8+"
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FromAuthMilter: ok


--=-ZRGFXrNpbv2s8yMbS/8+
Content-Type: multipart/mixed; boundary="=-8Bz9l8iXuIlADY/7uVTp"

--=-8Bz9l8iXuIlADY/7uVTp
Content-Type: multipart/alternative; boundary="=-ue0RNLaENnQ8kA8kVHro"

--=-ue0RNLaENnQ8kA8kVHro
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

my university is issuing a new wifi certificate, which is not accepted
by iwd 3.12 under Linux 7.1.11 (Arch Linux). A debug session gudied by
GPT-6 claims the cause for this is that the server certificate has an
empty subject field, and that the Linux ASN.1 parser rejects it despite
it being comformant with RFC 5280. My wifi administration reproduced
the issue but refuses to reissue the certificate with a populated
subject field to remain compatible with macOS.

The quote below is a more detailed report generated by GPT-6. The
"userpace diagnostic harness" refers to tests it did in the cloud, the
rest describes commands I executed locally. My report to the
administration and their response are forwarded below that. The server
certificate is attached.

Kind regards,
Maximilian Stahlberg


> Linux rejects an X.509 server certificate with an empty Subject DN
> and a critical subjectAltName containing a DNS name. This prevents
> eduroam authentication using iwd following a server-certificate
> change at the University of Bremen.
>=20
> Environment:
> - Arch Linux, kernel 7.1.11-arch1-1
> - iwd 3.12-1
> - ELL 0.83-1
>=20
> The exact server certificate is attached as server.pem. Its DER
> representation is 562 bytes. It has an empty Subject, encoded as an
> empty SEQUENCE, and a critical SAN containing DNS:radius.wlan.uni-
> bremen.de. This form is permitted by RFC 5280 =C2=A7=C2=A74.1.2.6 and 4.2=
.1.6.
>=20
> OpenSSL successfully verifies this certificate against the university
> CA, including sslserver purpose and the expected hostname. The
> command used was:
>=20
> openssl verify -trusted /etc/iwd/ub-private-eduroam-ca.pem \
> -purpose sslserver \
> -verify_hostname radius.wlan.uni-bremen.de \
> /proc/390085/root/tmp/iwd-tls-debug-server-cert.pem
>=20
> Result:
>=20
> /proc/390085/root/tmp/iwd-tls-debug-server-cert.pem: OK
>=20
> During iwd authentication, strace captured this failure:
>=20
> add_key(""..., ""..., ""..., 562, 110656685) =3D -1 EBADMSG (Bad
> message)
>=20
> The abbreviated arguments result from running strace with -s 0. iwd
> subsequently reports =E2=80=9Cbad_certificate=E2=80=9D and:
>=20
> Linking certificate 1 / 1 failed, root not verified against trusted
> CA(s)
>=20
> A separate userspace diagnostic harness using Linux 7.1.11's ASN.1
> compiler, X.509 grammar and decoder, with semantic callbacks stubbed
> out, rejects the attached certificate immediately after its empty
> Subject:
>=20
> ASN1: Data overrun error [m=3D81 d=3D148 ot=3D30 t=3D30 l=3D0]
> PARSE RESULT: -74
>=20
> A parsing-only control with a nonempty Subject and adjusted enclosing
> lengths passes. That modified control was not signature-valid; it
> only isolates the ASN.1 parsing failure.
>=20
> The implicated files are:
> - crypto/asymmetric_keys/x509.asn1
> - scripts/asn1_compiler.c
> - lib/asn1_decoder.c


-------- Forwarded Message --------
From: WLAN Support <wlan@uni-bremen.de>
To: Maximilian Stahlberg <maximilian.stahlberg@uni-bremen.de>
Subject: Re: [Ticket#2026101610000474] new certificate incompatible
with iwd/Linux certificate parser
Date: 10/19/2026 03:17:07 PM

Hallo Maximilian Stahlberg,

we have deployed a notebook with ArchLinux and can reproduce your
issue. Unfortunately we cannot follow your prosposal. We talked to a
colleague who wrote the script which we use to generate the
certificates and he left the subject blank on purpose. The reason is
that macOS has issues if this field is filled. He also mentioned that
this behaviour of iwd is known and might be a bug.

In this case we can only prospose to switch to wpa_supplicant to fix
this issue for you.


Kind regards,
[redacted in forwarded message]



16/10/2026 17:56 - Maximilian Stahlberg wrote:

> 1. Your username (before @uni-bremen.de):
>=20
> [redacted in forwarded message]
>=20
> 2. The device/operating system:
>=20
> Arch Linux with Linux 7.1.11 and iwd 3.12
>=20
> (Linux 7.2.10 is available but I can risk updating only next week.)
>=20
> 3. How does the problem express itself?:
>=20
> iwd (a wifi management daemon not based on wpa-supplicant) does not
> connect with the new certificate and the updated anonymous identity.
> iwd reports a "bad_certificate"; strace shows certificate import
> failing with add_key(...)=3DEBADMSG. A debug session guided by GPT-6
> suggests this happens because the server certificate has an empty
> "Subject" field; only "Subject Alternative Name" is populated. GPT
> claims this is supported by RFC 5280 but that the Linux ASN.1 parser
> rejects the empty Subject. It claims to have verified that populating
> the Subject field would resolve the parsing issue, and proposes to
> reissue the server certificate with "Subject CN=3Dradius.wlan.uni-
> bremen.de".
>=20
> 4. The building/room number where the error occured:=20
>=20
> [redacted in forwarded message]
>=20

--=-ue0RNLaENnQ8kA8kVHro
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head><style>pre,code,address {
  margin: 0px;
}
h1,h2,h3,h4,h5,h6 {
  margin-top: 0.2em;
  margin-bottom: 0.2em;
}
ol,ul {
  margin-top: 0em;
  margin-bottom: 0em;
}
blockquote {
  margin-top: 0em;
  margin-bottom: 0em;
}
</style></head><body style=3D"overflow-wrap: break-word; -webkit-nbsp-mode:=
 space; line-break: after-white-space;"><div>Hello,</div><div><br></div><di=
v>my university is issuing a new wifi certificate, which is not accepted by=
 iwd 3.12 under Linux 7.1.11 (Arch Linux). A debug session gudied by GPT-6 =
claims the cause for this is that the server certificate has an empty subje=
ct field, and that the Linux ASN.1 parser rejects it despite it being comfo=
rmant with RFC 5280. My wifi administration reproduced the issue but refuse=
s to reissue the certificate with a populated subject field to remain compa=
tible with macOS.</div><div><br></div><div>The quote below is a more detail=
ed report generated by GPT-6. The "userpace diagnostic harness" refers to t=
ests it did in the cloud, the rest describes commands I executed locally. M=
y report to the administration and their response are forwarded below that.=
 The server certificate is attached.</div><div><br></div><div>Kind regards,=
</div><div>Maximilian Stahlberg</div><div><br></div><div><br></div><blockqu=
ote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid=
;padding-left:1ex"><div>Linux rejects an X.509 server certificate with an e=
mpty Subject DN and a critical subjectAltName containing a DNS name. This p=
revents eduroam authentication using iwd following a server-certificate cha=
nge at the University of Bremen.</div><div><br></div><div>Environment:</div=
><div>- Arch Linux, kernel 7.1.11-arch1-1</div><div>- iwd 3.12-1</div><div>=
- ELL 0.83-1</div><div><br></div><div>The exact server certificate is attac=
hed as server.pem. Its DER representation is 562 bytes. It has an empty Sub=
ject, encoded as an empty SEQUENCE, and a critical SAN containing DNS:radiu=
s.wlan.uni-bremen.de. This form is permitted by RFC 5280 =C2=A7=C2=A74.1.2.=
6 and 4.2.1.6.</div><div><br></div><div>OpenSSL successfully verifies this =
certificate against the university CA, including sslserver purpose and the =
expected hostname. The command used was:</div><div><br></div><div>    opens=
sl verify -trusted /etc/iwd/ub-private-eduroam-ca.pem \</div><div>        -=
purpose sslserver \</div><div>        -verify_hostname radius.wlan.uni-brem=
en.de \</div><div>        /proc/390085/root/tmp/iwd-tls-debug-server-cert.p=
em</div><div><br></div><div>Result:</div><div><br></div><div>    /proc/3900=
85/root/tmp/iwd-tls-debug-server-cert.pem: OK</div><div><br></div><div>Duri=
ng iwd authentication, strace captured this failure:</div><div><br></div><d=
iv>    add_key(""..., ""..., ""..., 562, 110656685) =3D -1 EBADMSG (Bad mes=
sage)</div><div><br></div><div>The abbreviated arguments result from runnin=
g strace with -s 0. iwd subsequently reports =E2=80=9Cbad_certificate=E2=80=
=9D and:</div><div><br></div><div>    Linking certificate 1 / 1 failed, roo=
t not verified against trusted CA(s)</div><div><br></div><div>A separate us=
erspace diagnostic harness using Linux 7.1.11's ASN.1 compiler, X.509 gramm=
ar and decoder, with semantic callbacks stubbed out, rejects the attached c=
ertificate immediately after its empty Subject:</div><div><br></div><div>  =
  ASN1: Data overrun error [m=3D81 d=3D148 ot=3D30 t=3D30 l=3D0]</div><div>=
    PARSE RESULT: -74</div><div><br></div><div>A parsing-only control with =
a nonempty Subject and adjusted enclosing lengths passes. That modified con=
trol was not signature-valid; it only isolates the ASN.1 parsing failure.</=
div><div><br></div><div>The implicated files are:</div><div>- crypto/asymme=
tric_keys/x509.asn1</div><div>- scripts/asn1_compiler.c</div><div>- lib/asn=
1_decoder.c</div></blockquote><div><br></div><div><br></div><div>-------- F=
orwarded Message --------</div><div><b>From</b>: WLAN Support &lt;<a href=
=3D"mailto:WLAN%20Support%20%3cwlan@uni-bremen.de%3e">wlan@uni-bremen.de</a=
>&gt;</div><div><b>To</b>: Maximilian Stahlberg &lt;<a href=3D"mailto:Maxim=
ilian%20Stahlberg%20%3cmaximilian.stahlberg@uni-bremen.de%3e">maximilian.st=
ahlberg@uni-bremen.de</a>&gt;</div><div><b>Subject</b>: Re: [Ticket#2026101=
610000474] new certificate incompatible with iwd/Linux certificate parser</=
div><div><b>Date</b>: 10/19/2026 03:17:07 PM</div><div><br></div><div>Hallo=
 Maximilian Stahlberg,<br></div><div><br></div><div>we have deployed a note=
book with ArchLinux and can reproduce your issue. Unfortunately we cannot f=
ollow your prosposal. We talked to a colleague who wrote the script which w=
e use to generate the certificates and he left the subject blank on purpose=
. The reason is that macOS has issues if this field is filled. He also ment=
ioned that this behaviour of iwd is known and might be a bug.<br></div><div=
><br></div><div>In this case we can only prospose to switch to wpa_supplica=
nt to fix this issue for you.<br></div><div><br></div><div><br></div><div>K=
ind regards,<br></div><div><div>[redacted in forwarded message]</div></div>=
<div><br></div><div><br></div><div><br></div><div>16/10/2026 17:56 - Maximi=
lian Stahlberg wrote:</div><div><br></div><blockquote type=3D"cite" style=
=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div=
>1. Your username (before @uni-bremen.de):<br></div><div><br></div><div>[re=
dacted in forwarded message]</div><div><br></div><div>2. The device/operati=
ng system:<br></div><div><br></div><div>Arch Linux with Linux 7.1.11 and iw=
d 3.12<br></div><div><br></div><div>(Linux 7.2.10 is available but I can ri=
sk updating only next week.)<br></div><div><br></div><div>3. How does the p=
roblem express itself?:<br></div><div><br></div><div>iwd (a wifi management=
 daemon not based on wpa-supplicant) does not<br></div><div>connect with th=
e new certificate and the updated anonymous identity.<br></div><div>iwd rep=
orts a "bad_certificate"; strace shows certificate import<br></div><div>fai=
ling with add_key(...)=3DEBADMSG. A debug session guided by GPT-6<br></div>=
<div>suggests this happens because the server certificate has an empty<br><=
/div><div>"Subject" field; only "Subject Alternative Name" is populated. GP=
T<br></div><div>claims this is supported by RFC 5280 but that the Linux ASN=
.1 parser<br></div><div>rejects the empty Subject. It claims to have verifi=
ed that populating<br></div><div>the Subject field would resolve the parsin=
g issue, and proposes to<br></div><div>reissue the server certificate with =
"Subject CN=3Dradius.wlan.uni-<br></div><div>bremen.de".<br></div><div><br>=
</div><div>4. The building/room number where the error occured: <br></div><=
div><br></div><div>[redacted in forwarded message]</div><div><br></div></bl=
ockquote><div><br></div><div><span></span></div></body></html>

--=-ue0RNLaENnQ8kA8kVHro--

--=-8Bz9l8iXuIlADY/7uVTp
Content-Type: application/pkcs7-mime; name="server.pem"
Content-Disposition: attachment; filename="server.pem"
Content-Transfer-Encoding: base64

LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNMakNDQWRTZ0F3SUJBZ0lCQXpBS0JnZ3Fo
a2pPUFFRREFqQlVNUXN3Q1FZRFZRUUdFd0pFUlRFY01Cb0cKQTFVRUNnd1RWVzVwZG1WeWMybDBZ
V1YwSUVKeVpXMWxiakVuTUNVR0ExVUVBd3dlVlc1cGRtVnljMmwwWVdWMApJRUp5WlcxbGJpQmxa
SFZ5YjJGdElFTkJNQjRYRFRJMk1EY3dNekEzTXpnd01Gb1hEVEkzTURjd016QTNNemd3Ck1Gb3dB
REIyTUJBR0J5cUdTTTQ5QWdFR0JTdUJCQUFpQTJJQUJNdnE0M0tucEVJdFlNRTltaTA0UTdCa2VQ
bHAKZnEvaSt0b0VJQVRFRWZlTUh5LzErbFh3UzAxb0RtZGgwaXY4S2NabE9EVWx4MkppQ3dBN0M0
dW9JZ2dZNzVKbwpUT3BnelZ0TVk2UXVyR2xRWVFNdytqN2FEdTJWUmY2WGllZUh0cU9CelRDQnlq
QUpCZ05WSFJNRUFqQUFNQjBHCkExVWREZ1FXQkJRbWNaSUwyWHdiMEhNYno3d2kyRkZMZW9RWXJU
QWZCZ05WSFNNRUdEQVdnQlMvQmQ2SmFseTEKUXNDQmxyWU56Y1hJTE8weGhqQVRCZ05WSFNVRURE
QUtCZ2dyQmdFRkJRY0RBVEFuQmdOVkhSRUJBZjhFSFRBYgpnaGx5WVdScGRYTXVkMnhoYmk1MWJt
a3RZbkpsYldWdUxtUmxNRDhHQTFVZEh3UTRNRFl3TktBeW9EQ0dMbWgwCmRIQTZMeTl5WVdScGRY
TXVkMnhoYmk1MWJta3RZbkpsYldWdUxtUmxMMlZrZFhKdllXMWpZUzVqY213d0NnWUkKS29aSXpq
MEVBd0lEU0FBd1JRSWhBSlROMmIwZ1lUemE5T1gxcFJjWFRnWWRBZGttOFh3dElEMVpmTUJBVS9J
SwpBaUI5em5PU1BlcFdGODlxN2lSMUZodmNSaVp4K3Z3NHJ1RUN4UTUyNkJWelB3PT0KLS0tLS1F
TkQgQ0VSVElGSUNBVEUtLS0tLQo=


--=-8Bz9l8iXuIlADY/7uVTp--

--=-ZRGFXrNpbv2s8yMbS/8+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbUWSLMNHRjOvr0aKgsylXSCpAxUFAmrWKjYACgkQgsylXSCp
AxU7uRAAqI1KDMCf3EbiPbY+8Rx98hTXrnT15yYNo9lbAuAyZ6ILbTqojqjTG28m
PqioNKYWMDxWQNQGQfU8KkEu/i1K5jMVs87A0vs8niLJhZKvLIlUgFO+MUEAo7VQ
d62jcTHPPTh2mb27f6Io7umvfboYkQZvYvzkwdI7IUwDC9YddNLTqx/J5obg4Fmg
WzvidlXFsQYZybj8SIBPXNq+TWKsW0V7+BS+aQBa9xtR5Ipo88xaATN8CZllQ+0M
p7nJHunLklkioJVyMEyF66bRxLv8Rv0oIG40aSJh6J3I7iukMCZmEmREGprgSBTq
tZKySar4sIznWrrtWbi7eEkfLjlh+laQYJXXoOnC10KkufueBC//04VtYFc4lIZq
3ZOswpxQP170ejDsbI1J2cz0ihKCzNy9mhXjkSfO3CgAH/WIRul3t6lE7yH9kPwr
vpYRuEpSTbIoIdxuy4zDys2rDIFzRnKpl/9MXEWxJqo0KNe3ZP7iD3sCt8CYeSAy
t4kDa1bIg4ONPBA5UbFyfuA0hvNWp843skcu41I3eH8D37i9c50L9N77QACKTret
9ol2to8+5GZVEbUyngYXmDWej4IJ3tF+xUr7aNHDAQmr9bGfANwcHa2PTfSgr8Ri
pDIU2mD4ceiXFJLWKYbNT/dVdxiIbjWJ1h4WD8z1bWjO7Ceil7Y=
=7LDN
-----END PGP SIGNATURE-----

--=-ZRGFXrNpbv2s8yMbS/8+--
