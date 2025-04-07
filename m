Received: from smtp-out-2a.sgdsn.gouv.fr (smtp-out-2b.sgdsn.gouv.fr [143.126.255.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7518C227E9B
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 08:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.126.255.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014678; cv=none; b=ZNNXVoGqQvBdA63reaVtNuXamCWBkPehb5Gw4wX11Ws+mMXSm0++C9+BHeRqSt/NgXm7EfWxyF0UHREvB5KOGNQVECMsp200RqGSaSVxaMYexdDAXM/A8k7UkO3aKhCioYUiJxRGff7hn/obSbFLpUaSXawQNkasbX+4cQDcugk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014678; c=relaxed/simple;
	bh=91sGCy3OZwsZUWF8r7qKffjp+f48iuGCmvdisqNbrhc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=shoTnV18j+S8CMepayu4gr6shQ7+f2Aay9QwmfpRddAc3coeBuXNaxzO8bqeQVNjHVjJQSYKQV3Q6IhCQQgrw4wY+7uuRYiMgYANbKi2Kj0FyA/coUN0IrJRBdO8SzlDAY2irPV6SWXfG3MFpuIXJyY6TNI6B+HuPH8gVmOaXcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ssi.gouv.fr; spf=pass smtp.mailfrom=ssi.gouv.fr; dkim=pass (2048-bit key) header.d=ssi.gouv.fr header.i=@ssi.gouv.fr header.b=pontg/53; arc=none smtp.client-ip=143.126.255.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ssi.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ssi.gouv.fr header.i=@ssi.gouv.fr header.b="pontg/53"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ssi.gouv.fr;
	s=20240601; t=1744014291;
	bh=91sGCy3OZwsZUWF8r7qKffjp+f48iuGCmvdisqNbrhc=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From:Subject;
	b=pontg/53GnYl76q6gfcViNkZ/bsBkhcT89YxNYGur6dkRshOaaxMvCUeJRpJ0h+pm
	 AGIORPXass/yLre+hhVhWzQ/TIiiDfMFacv+ijcP0s6uX8dCWsz+cAzj7D/w+s1I1o
	 SkF+VbYFRu+SsLo7JfxOWmT5JEaocDd0FuiingU06HheAk986wNrwhDL3uL5ZcYUmO
	 OeUEKoriw4HmAGJ8mH9dMeVNLIuZcg++iXtPaZRIRCVsCtreBH26xZ/bzfSwWSXE+k
	 qpa45GSU0e4xRm0UomFDueFo1hsxIz4Cgje+003w5aAHKdGZGUlcU/ZJs94QpBLjT5
	 3nCAbj8SnkvYA==
From: EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>
To: Boris Brezillon <boris.brezillon@collabora.com>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Boris Brezillon
	<bbrezillon@kernel.org>, Srujana Challa <schalla@marvell.com>
Subject: RE: [v2 PATCH] MAINTAINERS: Update maintainers for crypto/marvell
Thread-Topic: [v2 PATCH] MAINTAINERS: Update maintainers for crypto/marvell
Thread-Index: AQHboRN7cENnWOytqkKwMi/iidQ33LOM5EYAgAsFe4A=
Date: Mon, 7 Apr 2025 08:24:50 +0000
Message-ID: <8c84459629b949a49ae388dde52772b3@ssi.gouv.fr>
References: <Z91Ld28V6L2ek-JV@gondor.apana.org.au>
	<20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr>
	<Z-JnegwRrihCos3z@gondor.apana.org.au>
	<20250325094829.586fb525@collabora.com>
	<Z-ie8LWRsoGb4qIP@gondor.apana.org.au>
 <20250331120214.0fc41ed6@collabora.com>
In-Reply-To: <20250331120214.0fc41ed6@collabora.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

DQoNCi0tLS0tTWVzc2FnZSBkJ29yaWdpbmUtLS0tLQ0KRGUgOiBCb3JpcyBCcmV6aWxsb24gPGJv
cmlzLmJyZXppbGxvbkBjb2xsYWJvcmEuY29tPg0KRW52b3nDqSA6IGx1bmRpIDMxIG1hcnMgMjAy
NSAxMjowMg0Kw4AgOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQpD
YyA6IEVCQUxBUkQgQXJuYXVkIDxBcm5hdWQuRWJhbGFyZEBzc2kuZ291di5mcj47IExpbnV4IENy
eXB0byBNYWlsaW5nIExpc3QgPGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc+OyBCb3JpcyBC
cmV6aWxsb24gPGJicmV6aWxsb25Aa2VybmVsLm9yZz47IFNydWphbmEgQ2hhbGxhIDxzY2hhbGxh
QG1hcnZlbGwuY29tPg0KT2JqZXQgOiBSZTogW3YyIFBBVENIXSBNQUlOVEFJTkVSUzogVXBkYXRl
IG1haW50YWluZXJzIGZvciBjcnlwdG8vbWFydmVsbA0KDQpPbiBTdW4sIDMwIE1hciAyMDI1IDA5
OjMxOjI4ICswODAwDQpIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+IHdy
b3RlOg0KDQo+IE9uIFR1ZSwgTWFyIDI1LCAyMDI1IGF0IDA5OjQ4OjI5QU0gKzAxMDAsIEJvcmlz
IEJyZXppbGxvbiB3cm90ZToNCj4gPg0KPiA+IEkgaGF2ZW4ndCByZXZpZXdlZCBjb250cmlidXRp
b25zIG9yIGNvbnRyaWJ1dGVkIG15c2VsZiB0byB0aGlzDQo+ID4gZHJpdmVyIGZvciB3aGlsZS4g
Q291bGQgeW91IHJlbW92ZSBtZSBhcyB3ZWxsPw0KPg0KPiBUaGFua3MgZm9yIHlvdXIgY29udHJp
YnV0aW9ucyBCb3Jpcy4gIEknbGwgYWRkIHlvdSB0byB0aGUgcGF0Y2ggYXMNCj4gd2VsbDoNCj4N
Cj4gLS0tODwtLS0NCj4gUmVtb3ZlIHRoZSBlbnRyaWVzIGZvciBBcm5hdWQgRWJhbGFyZCBhbmQg
Qm9yaXMgQnJlemlsbG9uIGFzDQo+IHJlcXVlc3RlZC4NCj4NCj4gTGluazoNCj4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGludXgtY3J5cHRvLzIwZjAxNjI2NDNmOTQ1MDliMDkyOGUxN2FmYjdl
ZmJkQA0KPiBzc2kuZ291di5mci8NCj4gU2lnbmVkLW9mZi1ieTogSGVyYmVydCBYdSA8aGVyYmVy
dEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KDQpBY2tlZC1ieTogQXJuYXVkIEViYWxhcmQgPGFybmF1
ZC5lYmFsYXJkQHNzaS5nb3V2LmZyPg0KDQo+IGRpZmYgLS1naXQgYS9NQUlOVEFJTkVSUyBiL01B
SU5UQUlORVJTIGluZGV4DQo+IGY4ZmIzOTZlNmIzNy4uOGVkYTI1N2ZmZGM5IDEwMDY0NA0KPiAt
LS0gYS9NQUlOVEFJTkVSUw0KPiArKysgYi9NQUlOVEFJTkVSUw0KPiBAQCAtMTQwMDksOCArMTQw
MDksNiBAQCBGOmRyaXZlcnMvZ3B1L2RybS9hcm1hZGEvDQo+ICBGOmluY2x1ZGUvdWFwaS9kcm0v
YXJtYWRhX2RybS5oDQo+DQo+ICBNQVJWRUxMIENSWVBUTyBEUklWRVINCj4gLU06Qm9yaXMgQnJl
emlsbG9uIDxiYnJlemlsbG9uQGtlcm5lbC5vcmc+DQo+IC1NOkFybmF1ZCBFYmFsYXJkIDxhcm5v
QG5hdGlzYmFkLm9yZz4NCj4gIE06U3J1amFuYSBDaGFsbGEgPHNjaGFsbGFAbWFydmVsbC5jb20+
DQo+ICBMOmxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gIFM6TWFpbnRhaW5lZA0KDQpM
ZXMgZG9ubsOpZXMgw6AgY2FyYWN0w6hyZSBwZXJzb25uZWwgcmVjdWVpbGxpZXMgZXQgdHJhaXTD
qWVzIGRhbnMgbGUgY2FkcmUgZGUgY2V0IMOpY2hhbmdlLCBsZSBzb250IMOgIHNldWxlIGZpbiBk
4oCZZXjDqWN1dGlvbiBk4oCZdW5lIHJlbGF0aW9uIHByb2Zlc3Npb25uZWxsZSBldCBz4oCZb3DD
qHJlbnQgZGFucyBjZXR0ZSBzZXVsZSBmaW5hbGl0w6kgZXQgcG91ciBsYSBkdXLDqWUgbsOpY2Vz
c2FpcmUgw6AgY2V0dGUgcmVsYXRpb24uIFNpIHZvdXMgc291aGFpdGV6IGZhaXJlIHVzYWdlIGRl
IHZvcyBkcm9pdHMgZGUgY29uc3VsdGF0aW9uLCBkZSByZWN0aWZpY2F0aW9uIGV0IGRlIHN1cHBy
ZXNzaW9uIGRlIHZvcyBkb25uw6llcywgdmV1aWxsZXogY29udGFjdGVyIGNvbnRhY3QucmdwZEBz
Z2Rzbi5nb3V2LmZyLiBTaSB2b3VzIGF2ZXogcmXDp3UgY2UgbWVzc2FnZSBwYXIgZXJyZXVyLCBu
b3VzIHZvdXMgcmVtZXJjaW9ucyBk4oCZZW4gaW5mb3JtZXIgbOKAmWV4cMOpZGl0ZXVyIGV0IGRl
IGTDqXRydWlyZSBsZSBtZXNzYWdlLiBUaGUgcGVyc29uYWwgZGF0YSBjb2xsZWN0ZWQgYW5kIHBy
b2Nlc3NlZCBkdXJpbmcgdGhpcyBleGNoYW5nZSBhaW1zIHNvbGVseSBhdCBjb21wbGV0aW5nIGEg
YnVzaW5lc3MgcmVsYXRpb25zaGlwIGFuZCBpcyBsaW1pdGVkIHRvIHRoZSBuZWNlc3NhcnkgZHVy
YXRpb24gb2YgdGhhdCByZWxhdGlvbnNoaXAuIElmIHlvdSB3aXNoIHRvIHVzZSB5b3VyIHJpZ2h0
cyBvZiBjb25zdWx0YXRpb24sIHJlY3RpZmljYXRpb24gYW5kIGRlbGV0aW9uIG9mIHlvdXIgZGF0
YSwgcGxlYXNlIGNvbnRhY3Q6IGNvbnRhY3QucmdwZEBzZ2Rzbi5nb3V2LmZyLiBJZiB5b3UgaGF2
ZSByZWNlaXZlZCB0aGlzIG1lc3NhZ2UgaW4gZXJyb3IsIHdlIHRoYW5rIHlvdSBmb3IgaW5mb3Jt
aW5nIHRoZSBzZW5kZXIgYW5kIGRlc3Ryb3lpbmcgdGhlIG1lc3NhZ2UuDQo=
