Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC0123393E
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223381; cv=none; b=YLLfdc5XErX4oS9H3DfVHapqf1YmzJzO3a88T/l1mk/xJJgZ7Qcj/PXWKd+lFue2SMK/OmkGKrbkg7T8yxVJLeMTeAeRWxGyvjqR07XshIJKq0Nr9qchr1Wz+p6F45ziKL0p/dYvtHN3KxD9HiixzCTjtDCnva5LYJo3wgVRsEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223381; c=relaxed/simple;
	bh=7shf3XLdsUqWAoV6buMRumADCDZKalrI3SMCsgRWBn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QuOFIul5/eGHZBusFaa1YyTdr4UcXO6vdEp06vU+iCgQ1cGt8Y+ZGZXEY+eh360CjHyWvXkcXUqcrqScrvm9eUKCJhuwclbbcAI5S+7r3PpJFySJ1eCgzG+LgiFn1nl1UI4WKyMVCusG4B2DacmarScrQ9+GjbopJUkR2Qb4Njw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [IPV6:2400:2410:b120:f200:9e5c:8eff:fec0:ee40] (unknown [IPv6:2400:2410:b120:f200:9e5c:8eff:fec0:ee40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id A10723F1A5;
	Tue, 19 May 2026 22:36:07 +0200 (CEST)
Message-ID: <e07dc0ab-fcc3-4525-a758-f7b4808953c8@hogyros.de>
Date: Wed, 20 May 2026 05:36:04 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Which, if any, of the async crypto drivers are ever useful in the
 real world?
To: Demi Marie Obenour <demiobenour@gmail.com>, linux-crypto@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <d7084ad8-92e7-4959-8f47-c61029c2ea73@gmail.com>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <d7084ad8-92e7-4959-8f47-c61029c2ea73@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------SRTHhlE1WdQoI4JXUdmXSMim"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------SRTHhlE1WdQoI4JXUdmXSMim
Content-Type: multipart/mixed; boundary="------------JeEyTjTzgSv98EHk26pCS8ak";
 protected-headers="v1"
From: Simon Richter <Simon.Richter@hogyros.de>
To: Demi Marie Obenour <demiobenour@gmail.com>, linux-crypto@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <e07dc0ab-fcc3-4525-a758-f7b4808953c8@hogyros.de>
Subject: Re: Which, if any, of the async crypto drivers are ever useful in the
 real world?
References: <d7084ad8-92e7-4959-8f47-c61029c2ea73@gmail.com>
In-Reply-To: <d7084ad8-92e7-4959-8f47-c61029c2ea73@gmail.com>
Autocrypt-Gossip: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT

--------------JeEyTjTzgSv98EHk26pCS8ak
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGksDQoNCk9uIDUvMTgvMjYgMTk6MTEsIERlbWkgTWFyaWUgT2Jlbm91ciB3cm90ZToNCg0K
PiBJcyBpdCByZWFsbHkgKmFsd2F5cyogYmV0dGVyIHRvIGRvIHRoZSBjcnlwdG9ncmFwaHkg
aW5saW5lIG9yIG9uIHRoZQ0KPiBDUFU/DQoNCklmIHRoZXJlIGlzIGFuIGlubGluZSBjcnlw
dG8gZW5naW5lLCB0aGF0IGlzIHByZWZlcmFibGUsIGJlY2F1c2Ugd2UgY2FuIA0Kc3VibWl0
IGEgc2luZ2xlIGFzeW5jIHJlcXVlc3QgYW5kIGhhdmUgdGhlIGhhcmR3YXJlIG1lZGlhdGUg
dGhlIGFzeW5jIA0KcmVxdWVzdHMgdG8gdGhlIGxvd2VyIGxheWVycyBmb3IgdXMsIHJlZHVj
aW5nIG92ZXJoZWFkLg0KDQpUaGUgQ1BVIGlzIGEgZ29vZCBjaG9pY2UgaWYgdGhlcmUgaXMg
c29tZSBhY2NlbGVyYXRpb24gYnVpbHQgaW50byBpdCANCihsaWtlIEFFUy1OSSBvciBORU9O
KSwgcmVxdWVzdCBzaXplcyBhcmUgc21hbGwsIHRoZXJlIGlzIG5vIGJhdGNoaW5nLCANCnRo
ZSBDUFUgaXMgb3RoZXJ3aXNlIGlkbGUgYW5kIHRvdGFsIHRocm91Z2hwdXQgcGVyIHN0cmVh
bSBpcyBtYW5hZ2VhYmxlIA0Kd2l0aCBhIHNpbmdsZSBjb3JlLg0KDQpUaGF0J3MgYSBsb3Qg
b2YgY29uZGl0aW9ucywgYnV0IHRoZXkgaGFwcGVuIHRvIGJlIGZ1bGZpbGxlZCBpbiBhIHR5
cGljYWwgDQpkZXNrdG9wIFBDIHVzZSBjYXNlLCBhbmQgdXN1YWxseSB0aGVyZSBpcyBubyBh
c3luYyBvZmZsb2FkIG9wdGlvbiB0aGVyZSANCmFueXdheSwgc28gd2UgZW5kIHVwIG9uIGEg
Q1BVLg0KDQpGb3Igb3RoZXIgcGxhdGZvcm1zLCBpdCdzIGRpZmZlcmVudC4gRm9yIGV4YW1w
bGUsIG15IGFsd2F5cy1vbiBtYWNoaW5lIA0KaXMgYSBwYXNzaXZlbHkgY29vbGVkIFJJU0Mt
ViBib2FyZC4gVHJhbnNmZXJyaW5nIGRhdGEgdGhyb3VnaCBhIFNTSCANCnR1bm5lbCBtYXhl
cyBvdXQgYXQgYWJvdXQgMjAgTUIvcywgdGhhdCdzIHdoZXJlIHRoZSBzc2hkIHByb2Nlc3Mg
dXNlcyANCjEwMCUgQ1BVLCBhbmQgaXQgd2lsbCBvbmx5IHJlY2VpdmUgdGhhdCBtdWNoIHRp
bWUgaWYgdGhlcmUgaXMgbm90aGluZyANCmVsc2UgZ29pbmcgb24gb24gdGhhdCBtYWNoaW5l
Lg0KDQpPbmUgb2YgbXkgcGxhbnMgZm9yIHRoZSBuZXh0IHdlZWtzIGlzIHRvIGZpbmFsbHkg
c2V0IHVwIG9mZmxvYWRpbmcgDQp0aHJvdWdoIEFGX0FMRyB0byBzZWUgaWYgdGhhdCBpbXBy
b3ZlcyB0aGluZ3MuIEknbSBmYWlybHkgY29uZmlkZW50IGl0IHdpbGwuDQoNClRoZXJlIGlz
IGFsc28gYSBsb3Qgb2YgcG90ZW50aWFsIGZvciBpbXByb3ZlbWVudCBpbnNpZGUgdGhlIG9m
ZmxvYWQgDQpzdGFjay4gVGhlIGRtLWNyeXB0IGJhdGNoaW5nIGNoYW5nZXMgc2hvdWxkIGhl
bHAgcXVpdGUgYSBiaXQgdG8ga2VlcCANCmxhcmdlIHJlcXVlc3RzIHRvZ2V0aGVyIGFuZCBo
YXZlIHRoZSBoYXJkd2FyZSBzZXF1ZW5jZSB0aGVtIHdpdGhvdXQgaGVscCANCmZyb20gdGhl
IENQVSB3aGVyZSBwb3NzaWJsZS4NCg0KZnNjcnlwdCB3ZW50IHRoZSBvdGhlciBkaXJlY3Rp
b24sIHNwbGl0dGluZyByZXF1ZXN0cyBmcm9tIHVwcGVyIGxheWVycyANCmludG8gaW5kaXZp
ZHVhbCBkYXRhIG9iamVjdHMsIHN1Ym1pdHRpbmcgZWFjaCBzZXBhcmF0ZWx5IGFuZCB3YWl0
aW5nIGZvciANCmNvbXBsZXRpb24sIHdoaWNoIEkgY2FuIHVuZGVyc3RhbmQgZnJvbSBhIHNv
ZnR3YXJlIGNvbXBsZXhpdHkgDQpwZXJzcGVjdGl2ZSwgYnV0IGl0IG1heGltaXplcyBvdmVy
aGVhZCBmb3Igb2ZmbG9hZGluZy4NCg0KPiBJZiBzbywgdGhlbiB0aGUgYXN5bmMgZHJpdmVy
cyBhcmUgcG9pbnRsZXNzIGFuZCBjYW4gYmUgcmVtb3ZlZC4NCg0KSW4gZ2VuZXJhbCwgaWYg
YW4gb2ZmbG9hZCBlbmdpbmUgd2l0aCBhbiBhc3luYyBkcml2ZXIgZXhpc3RzLCBJIHdvdWxk
IA0KZXhwZWN0IHRoYXQgaXQgcHJvdmlkZXMgYSBiZW5lZml0IG92ZXIgdGhlIENQVSwgaW4g
dGhlIHdvcnN0IGNhc2UgaXQgDQpmcmVlcyB1cCBhIENQVSBjb3JlIGV2ZW4gaWYgdGhlcmUg
aXMgbm8gc2lnbmlmaWNhbnQgcGVyZm9ybWFuY2UgDQpkaWZmZXJlbmNlLCBhbmQgaXQgdXNl
cyBsZXNzIGVuZXJneSB0aGFuIGEgZ2VuZXJhbC1wdXJwb3NlIGNvcmUgd291bGQuDQoNCldo
YXQgcHJvYmFibHkgbWFrZXMgc2Vuc2UgaXMgY2hhbmdpbmcgdGhlIGRlZmF1bHRzLiBEZXNr
dG9wcyBhbmQgc2VydmVycyANCmdlbmVyYWxseSBkbyBub3QgaGF2ZSBvZmZsb2FkIGhhcmR3
YXJlLCBhbmQgdGhlcmVmb3JlIGRvIG5vdCByZXF1aXJlIGEgDQp1c2Vyc3BhY2UgaW50ZXJm
YWNlIHRvIG9mZmxvYWQgaGFyZHdhcmUgZWl0aGVyLg0KDQpXZSBjYW4gYWxzbyBleHBlY3Qg
cGVvcGxlIHdobyBoYXZlIGEgbmVlZCBmb3Igb2ZmbG9hZCBoYXJkd2FyZSB0byBkbyANCnNv
bWUgY29uZmlndXJhdGlvbiB3b3JrIHRvIGVuYWJsZSBpdCwgYW5kIGV2ZW4gbW9yZSBjb25m
aWd1cmF0aW9uIHdvcmsgDQppZiB0aGV5IG5lZWQgaXQgdG8gYmUgYWNjZXNzaWJsZSBmcm9t
IHVzZXJzcGFjZS4gVGhlIHVzZXJzIGFyZSBnb2luZyB0byANCmJlIHNraWxsZWQgc3lzYWRt
aW5zIGFuZCBzeXN0ZW0gaW50ZWdyYXRvcnMgYW55d2F5Lg0KDQogICAgU2ltb24NCg==

--------------JeEyTjTzgSv98EHk26pCS8ak--

--------------SRTHhlE1WdQoI4JXUdmXSMim
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEtjuqOJSXmNjSiX3Tfr04e7CZCBEFAmoMybQACgkQfr04e7CZ
CBEbsQf8DSnnIY3oUwthQZE5pDuYXc9tjmpbZQ7mNh+hVNVnk/ZpUhjzCPteVQru
M5RKqeZ1F9yKnn8avsFZLxQm5FMTM9k8isuj2Azd/L3XD7WIVwE/8jgzubCWD9+4
/eaG1Oa9lGAiyCWFCXzIdV9oGManW0YiGmW25FmMljfcbT4mRywWfJTl4Z0UOjKW
kmRGFragW1mw0RCikBF9GBJ9Cx6bVNV7wJuM69DxnCHs5GJCia4J0iWBgilUG60/
UrGxpBHr45sEufagS8JZmteOGw13U+2xrAUq1hr1+Tkkxfjgv5YI2IecYjhgqG8W
3EcV0KxaHli+cNiAt2PWBX13VtVRiA==
=M/Gp
-----END PGP SIGNATURE-----

--------------SRTHhlE1WdQoI4JXUdmXSMim--
