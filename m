Received: from smtp-out-1a.sgdsn.gouv.fr (smtp-out-1b.sgdsn.gouv.fr [143.126.255.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557041EDA18
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 12:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.126.255.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742559898; cv=none; b=IxZxF+UAsYfMnxc8pCtzbEeSxxcJYdw0oxCZWVQHolMLcLIOsl2U3LY2zp4onSsJ+wGTtI/PWLRrRcT0eGj+fnBkYmGyIE0HO4mnIVkUX2VgBtSBzguoPFciMg+ICn3SMjuJ9IAszC0CdldYKwcL8jxmhyq8VKCCcbqw2ZSCYY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742559898; c=relaxed/simple;
	bh=8IJ9MBejl0zG6Gp+uTUbXan7KdiZGslDjT+OVCMPJ0M=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jvLzQ8tbVKKbh2EaAGxWnaQfkJVNAC175oWAUMU+Pd85m3YJeV7+BR6yRldAawmcV8HV15IUaeKAqyB/29s2gkZPSe100mPPZSxZ4iKf4wY3G/ICAtJ+T8xGEZ5+krNzsoDUKgI6QOB3jfUrmOcQT0CtVP6+jHkWJpji8XHBBOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ssi.gouv.fr; spf=pass smtp.mailfrom=ssi.gouv.fr; dkim=pass (2048-bit key) header.d=ssi.gouv.fr header.i=@ssi.gouv.fr header.b=P4qRFAXy; arc=none smtp.client-ip=143.126.255.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ssi.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ssi.gouv.fr header.i=@ssi.gouv.fr header.b="P4qRFAXy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ssi.gouv.fr;
	s=20240601; t=1742559513;
	bh=8IJ9MBejl0zG6Gp+uTUbXan7KdiZGslDjT+OVCMPJ0M=;
	h=From:To:Subject:Date:References:In-Reply-To:From:Subject;
	b=P4qRFAXytmtHgxNLOTtiTdg1aLbVphDwks+HGpoMQLD8zh4shE5KlJGq9F7SPyJJn
	 xugeDOhzBJ5dJbmMKvWMYtFVGoEbgtOyN0UdG0w+La67+LSupDW09lp3Cfa8gHsgSd
	 fZxQ968rusZuZ4LWq+6uDZqGsbs6Jozmgcw0AsI5xvEXNfGdhiDwrHK1dABd4TV2bR
	 ZKKgSW0nUQPq9A3bZ8yZiLBJxeJ+fsa4Tp1HB30qVJ+zWqhy9vjH8XxzOyqj0G2b8b
	 lNaLLnaKy8LhCm4hPxVTFphOeGTTCodcDuYCej6dyshytpNC4ZXPdD53dlf3S3i/YC
	 8uS9nxo2yCqRw==
From: EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>, Boris Brezillon <bbrezillon@kernel.org>,
	Srujana Challa <schalla@marvell.com>
Subject: RE: [PATCH] MAINTAINERS: Update email address for Arnaud Ebalard
Thread-Topic: [PATCH] MAINTAINERS: Update email address for Arnaud Ebalard
Thread-Index: AQHbmlNCDPo97/u8bkmaAq87WlU9b7N9f6XA
Date: Fri, 21 Mar 2025 12:18:32 +0000
Message-ID: <20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr>
References: <Z91Ld28V6L2ek-JV@gondor.apana.org.au>
In-Reply-To: <Z91Ld28V6L2ek-JV@gondor.apana.org.au>
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

SGkgSGVyYmVydCwNCg0KTmF0aXNiYWQub3JnIG1haWwgc2VydmVyIGlzIGluZGVlZCBpbiBleHRl
bmRlZCBob2xpZGF5cy4gWW91ciBjaGFuZ2UgaXMgZmluZSB3LyBtZSBidXQgSSBkbyBub3QgaGF2
ZSBtdWNoIHNwYXJlIHRpbWUgdG8gc3BlbmQgb24gdGhlIHRvcGljIGFueW1vcmUgc28gSSBndWVz
cyB0aGUgYmVzdCBhcHByb2FjaCB3b3VsZCBiZSB0byByZW1vdmUgbWUgZnJvbSBNQUlOVEFJTkVS
UyBmaWxlIGVudGlyZWx5IGFuZCBsZXQgdGhlIHNsb3QgdG8gc29tZW9uZSBlbHNlLg0KDQpDaGVl
cnMsDQoNCmErDQoNCi0tLS0tTWVzc2FnZSBkJ29yaWdpbmUtLS0tLQ0KRGUgOiBIZXJiZXJ0IFh1
IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQpFbnZvecOpIDogdmVuZHJlZGkgMjEgbWFy
cyAyMDI1IDEyOjIwDQrDgCA6IExpbnV4IENyeXB0byBNYWlsaW5nIExpc3QgPGxpbnV4LWNyeXB0
b0B2Z2VyLmtlcm5lbC5vcmc+OyBFQkFMQVJEIEFybmF1ZCA8QXJuYXVkLkViYWxhcmRAc3NpLmdv
dXYuZnI+OyBCb3JpcyBCcmV6aWxsb24gPGJicmV6aWxsb25Aa2VybmVsLm9yZz47IFNydWphbmEg
Q2hhbGxhIDxzY2hhbGxhQG1hcnZlbGwuY29tPg0KT2JqZXQgOiBbUEFUQ0hdIE1BSU5UQUlORVJT
OiBVcGRhdGUgZW1haWwgYWRkcmVzcyBmb3IgQXJuYXVkIEViYWxhcmQNCg0KVGhlIGV4aXN0aW5n
IGVtYWlsIGFkZHJlc3MgZm9yIEFybmF1ZCBFYmFsYXJkIGlzIGJvdW5jaW5nLiAgVXBkYXRlIGl0
IHRvIHdoYXQgYXBwZWFycyB0byBiZSB0aGUgbW9zdCByZWNlbnRseSB1c2VkIGVtYWlsIGFkZHJl
c3MuDQoNClNpZ25lZC1vZmYtYnk6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9y
Zy5hdT4NCg0KZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMNCmluZGV4IGY4
ZmIzOTZlNmIzNy4uNjhjOTAzYmY2YWEwIDEwMDY0NA0KLS0tIGEvTUFJTlRBSU5FUlMNCisrKyBi
L01BSU5UQUlORVJTDQpAQCAtMTQwMTAsNyArMTQwMTAsNyBAQCBGOmluY2x1ZGUvdWFwaS9kcm0v
YXJtYWRhX2RybS5oDQoNCiBNQVJWRUxMIENSWVBUTyBEUklWRVINCiBNOkJvcmlzIEJyZXppbGxv
biA8YmJyZXppbGxvbkBrZXJuZWwub3JnPg0KLU06QXJuYXVkIEViYWxhcmQgPGFybm9AbmF0aXNi
YWQub3JnPg0KK006QXJuYXVkIEViYWxhcmQgPGFybmF1ZC5lYmFsYXJkQHNzaS5nb3V2LmZyPg0K
IE06U3J1amFuYSBDaGFsbGEgPHNjaGFsbGFAbWFydmVsbC5jb20+DQogTDpsaW51eC1jcnlwdG9A
dmdlci5rZXJuZWwub3JnDQogUzpNYWludGFpbmVkDQotLQ0KRW1haWw6IEhlcmJlcnQgWHUgPGhl
cmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4gSG9tZSBQYWdlOiBodHRwOi8vZ29uZG9yLmFwYW5h
Lm9yZy5hdS9+aGVyYmVydC8NClBHUCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1L35o
ZXJiZXJ0L3B1YmtleS50eHQNCkxlcyBkb25uw6llcyDDoCBjYXJhY3TDqHJlIHBlcnNvbm5lbCBy
ZWN1ZWlsbGllcyBldCB0cmFpdMOpZXMgZGFucyBsZSBjYWRyZSBkZSBjZXQgw6ljaGFuZ2UsIGxl
IHNvbnQgw6Agc2V1bGUgZmluIGTigJlleMOpY3V0aW9uIGTigJl1bmUgcmVsYXRpb24gcHJvZmVz
c2lvbm5lbGxlIGV0IHPigJlvcMOocmVudCBkYW5zIGNldHRlIHNldWxlIGZpbmFsaXTDqSBldCBw
b3VyIGxhIGR1csOpZSBuw6ljZXNzYWlyZSDDoCBjZXR0ZSByZWxhdGlvbi4gU2kgdm91cyBzb3Vo
YWl0ZXogZmFpcmUgdXNhZ2UgZGUgdm9zIGRyb2l0cyBkZSBjb25zdWx0YXRpb24sIGRlIHJlY3Rp
ZmljYXRpb24gZXQgZGUgc3VwcHJlc3Npb24gZGUgdm9zIGRvbm7DqWVzLCB2ZXVpbGxleiBjb250
YWN0ZXIgY29udGFjdC5yZ3BkQHNnZHNuLmdvdXYuZnIuIFNpIHZvdXMgYXZleiByZcOndSBjZSBt
ZXNzYWdlIHBhciBlcnJldXIsIG5vdXMgdm91cyByZW1lcmNpb25zIGTigJllbiBpbmZvcm1lciBs
4oCZZXhww6lkaXRldXIgZXQgZGUgZMOpdHJ1aXJlIGxlIG1lc3NhZ2UuIFRoZSBwZXJzb25hbCBk
YXRhIGNvbGxlY3RlZCBhbmQgcHJvY2Vzc2VkIGR1cmluZyB0aGlzIGV4Y2hhbmdlIGFpbXMgc29s
ZWx5IGF0IGNvbXBsZXRpbmcgYSBidXNpbmVzcyByZWxhdGlvbnNoaXAgYW5kIGlzIGxpbWl0ZWQg
dG8gdGhlIG5lY2Vzc2FyeSBkdXJhdGlvbiBvZiB0aGF0IHJlbGF0aW9uc2hpcC4gSWYgeW91IHdp
c2ggdG8gdXNlIHlvdXIgcmlnaHRzIG9mIGNvbnN1bHRhdGlvbiwgcmVjdGlmaWNhdGlvbiBhbmQg
ZGVsZXRpb24gb2YgeW91ciBkYXRhLCBwbGVhc2UgY29udGFjdDogY29udGFjdC5yZ3BkQHNnZHNu
LmdvdXYuZnIuIElmIHlvdSBoYXZlIHJlY2VpdmVkIHRoaXMgbWVzc2FnZSBpbiBlcnJvciwgd2Ug
dGhhbmsgeW91IGZvciBpbmZvcm1pbmcgdGhlIHNlbmRlciBhbmQgZGVzdHJveWluZyB0aGUgbWVz
c2FnZS4NCg==
