Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B5729375E;
	Fri, 23 May 2025 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748007230; cv=none; b=EJK0LLTFPDGp2OrIvJBot8DCssX1JzwePi9hGQwp9zULUNzj6yJC9cWjAO/qAweEazT2D9fFGztUPRw8uJzsU7KWPat6TOnrTuVeHXvsmsVg+od267iFcFzLAB3oiRp67esgAOp6QDnBzEM4m4A+aJj6XlvRC3vUT65FAaxoCgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748007230; c=relaxed/simple;
	bh=36QJMW5pEJUHtQkQLki8rTjxolYQrZNrNwsjEeZsaxo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kYJ4n79/UO3lqbzNAGTYs1SeSMRVnIZDBgfik99ij/0HkK463B9YTv//2FFXJ02ZA98FBJrFv5aZWAIM2iyw5i72UvmeoHuYGhAb2IetJKo4bB573eiKHA9A4gfkmSx2fExEJ+qOF+o+v5wVH1iy8NsmbwmDOk9+XudpMwJheWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S035ANL.actianordic.se
 (10.12.31.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 May
 2025 15:18:33 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Fri, 23 May 2025 15:18:33 +0200
From: John Ernberg <john.ernberg@actia.se>
To: =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>
CC: Pengutronix Kernel Team <kernel@pengutronix.de>, Fabio Estevam
	<festevam@gmail.com>, Thomas Richard <thomas.richard@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, John Ernberg <john.ernberg@actia.se>
Subject: [PATCH 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM support
Thread-Topic: [PATCH 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM
 support
Thread-Index: AQHby+UuH7XxjH3Oy02KoZkEi3Dspw==
Date: Fri, 23 May 2025 13:18:32 +0000
Message-ID: <20250523131814.1047662-5-john.ernberg@actia.se>
References: <20250523131814.1047662-1-john.ernberg@actia.se>
In-Reply-To: <20250523131814.1047662-1-john.ernberg@actia.se>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.49.0
x-esetresult: clean, is OK
x-esetid: 37303A2956B14453607162
Content-Type: text/plain; charset="utf-8"
Content-ID: <928AE8E9249EE0458E24F6D5F153B114@actia.se>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

RnJvbTogSG9yaWEgR2VhbnTEgyA8aG9yaWEuZ2VhbnRhQG54cC5jb20+DQoNClRoZSBpTVg4UVhQ
IGFuZCBpTVg4UU0gaGF2ZSBhIENBQU0gKENyeXB0b2dyYXBoaWMgQWNjZWxlcmF0aW9uIGFuZA0K
QXNzdXJhbmNlIE1vZHVsZSkgbGlrZSBtYW55IG90aGVyIGlNWHMuDQoNCkFkZCB0aGUgZGVmaW5p
dGlvbnMgZm9yIGl0Lg0KDQpKb2IgUmluZ3MgMCBhbmQgMSBhcmUgYm91bmQgdG8gdGhlIFNFQ08g
KFNlY3VyaXR5IENvbnRyb2xsZXIpIEFSTSBjb3JlDQphbmQgYXJlIG5vdCBleHBvc2VkIG91dHNp
ZGUgaXQuIFRoZXJlJ3Mgbm8gcG9pbnQgdG8gZGVmaW5lIHRoZW0gaW4gdGhlDQpiaW5kaW5ncyBh
cyB0aGV5IGNhbm5vdCBiZSB1c2VkIG91dHNpZGUgdGhlIFNFQ08uDQoNClNpZ25lZC1vZmYtYnk6
IEhvcmlhIEdlYW50xIMgPGhvcmlhLmdlYW50YUBueHAuY29tPg0KW2plcm5iZXJnOiBDb21taXQg
bWVzc2FnZSwgZml4ZWQgZHRic19jaGVjayB3YXJuaW5ncywgdHJpbW1lZCBtZW1vcnkgcmFuZ2Vz
XQ0KU2lnbmVkLW9mZi1ieTogSm9obiBFcm5iZXJnIDxqb2huLmVybmJlcmdAYWN0aWEuc2U+DQoN
Ci0tLQ0KDQpJbXBvcnRlZCBmcm9tIE5YUCB0cmVlLCB0cmltbWVkIGRvd24gYW5kIGZpeGVkIHRo
ZSBkdGJzX2NoZWNrIHdhcm5pbmdzLg0KQ29uc3RyYWluZWQgdGhlIHJhbmdlcyB0byB0aGUgbmVl
ZGVkIG9uZXMuDQpDaGFuZ2VkIHRoZSBjb21taXQgbWVzc2FnZS4NCk9yaWdpbmFsIGhlcmU6IGh0
dHBzOi8vZ2l0aHViLmNvbS9ueHAtaW14L2xpbnV4LWlteC9jb21taXQvNjk5ZTU0YjM4NmNiOWI1
M2RlZjQwMTc5OGQwYTRlNjQ2MTA1NTgzZA0KLS0tDQogLi4uL2Jvb3QvZHRzL2ZyZWVzY2FsZS9p
bXg4LXNzLXNlY3VyaXR5LmR0c2kgIHwgMzggKysrKysrKysrKysrKysrKysrKw0KIGFyY2gvYXJt
NjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhxbS5kdHNpICAgICB8ICAxICsNCiBhcmNoL2FybTY0
L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4cXhwLmR0c2kgICAgfCAgMSArDQogMyBmaWxlcyBjaGFu
Z2VkLCA0MCBpbnNlcnRpb25zKCspDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvYXJtNjQvYm9v
dC9kdHMvZnJlZXNjYWxlL2lteDgtc3Mtc2VjdXJpdHkuZHRzaQ0KDQpkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OC1zcy1zZWN1cml0eS5kdHNpIGIvYXJjaC9h
cm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OC1zcy1zZWN1cml0eS5kdHNpDQpuZXcgZmlsZSBt
b2RlIDEwMDY0NA0KaW5kZXggMDAwMDAwMDAwMDAwLi5kZjA0ZTIwM2U3ODMNCi0tLSAvZGV2L251
bGwNCisrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDgtc3Mtc2VjdXJpdHku
ZHRzaQ0KQEAgLTAsMCArMSwzOCBAQA0KKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwt
Mi4wKw0KKy8qDQorICogQ29weXJpZ2h0IDIwMTkgTlhQDQorICovDQorDQorI2luY2x1ZGUgPGR0
LWJpbmRpbmdzL2Zpcm13YXJlL2lteC9yc3JjLmg+DQorDQorc2VjdXJpdHlfc3Vic3lzOiBidXNA
MzE0MDAwMDAgew0KKwljb21wYXRpYmxlID0gInNpbXBsZS1idXMiOw0KKwkjYWRkcmVzcy1jZWxs
cyA9IDwxPjsNCisJI3NpemUtY2VsbHMgPSA8MT47DQorCXJhbmdlcyA9IDwweDMxNDAwMDAwIDB4
MCAweDMxNDAwMDAwIDB4OTAwMDA+Ow0KKw0KKwljcnlwdG86IGNyeXB0b0AzMTQwMDAwMCB7DQor
CQljb21wYXRpYmxlID0gImZzbCxzZWMtdjQuMCI7DQorCQlyZWcgPSA8MHgzMTQwMDAwMCAweDkw
MDAwPjsNCisJCWludGVycnVwdHMgPSA8R0lDX1NQSSAxNDggSVJRX1RZUEVfTEVWRUxfSElHSD47
DQorCQkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCisJCSNzaXplLWNlbGxzID0gPDE+Ow0KKwkJcmFu
Z2VzID0gPDAgMHgzMTQwMDAwMCAweDkwMDAwPjsNCisJCWZzbCxzZWMtZXJhID0gPDk+Ow0KKwkJ
cG93ZXItZG9tYWlucyA9IDwmcGQgSU1YX1NDX1JfQ0FBTV9KUjI+Ow0KKw0KKwkJc2VjX2pyMjog
anJAMzAwMDAgew0KKwkJCWNvbXBhdGlibGUgPSAiZnNsLHNlYy12NC4wLWpvYi1yaW5nIjsNCisJ
CQlyZWcgPSA8MHgzMDAwMCAweDEwMDAwPjsNCisJCQlpbnRlcnJ1cHRzID0gPEdJQ19TUEkgNDUz
IElSUV9UWVBFX0xFVkVMX0hJR0g+Ow0KKwkJCXBvd2VyLWRvbWFpbnMgPSA8JnBkIElNWF9TQ19S
X0NBQU1fSlIyPjsNCisJCX07DQorDQorCQlzZWNfanIzOiBqckA0MDAwMCB7DQorCQkJY29tcGF0
aWJsZSA9ICJmc2wsc2VjLXY0LjAtam9iLXJpbmciOw0KKwkJCXJlZyA9IDwweDQwMDAwIDB4MTAw
MDA+Ow0KKwkJCWludGVycnVwdHMgPSA8R0lDX1NQSSA0NTQgSVJRX1RZUEVfTEVWRUxfSElHSD47
DQorCQkJcG93ZXItZG9tYWlucyA9IDwmcGQgSU1YX1NDX1JfQ0FBTV9KUjM+Ow0KKwkJfTsNCisJ
fTsNCit9Ow0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhx
bS5kdHNpIGIvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHFtLmR0c2kNCmluZGV4
IDZmYTMxYmM5ZWNlOC4uNmRmMDE4NjQzZjIwIDEwMDY0NA0KLS0tIGEvYXJjaC9hcm02NC9ib290
L2R0cy9mcmVlc2NhbGUvaW14OHFtLmR0c2kNCisrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJl
ZXNjYWxlL2lteDhxbS5kdHNpDQpAQCAtNjEyLDYgKzYxMiw3IEBAIHZwdV9kc3A6IGRzcEA1NTZl
ODAwMCB7DQogCX07DQogDQogCS8qIHNvcnRlZCBpbiByZWdpc3RlciBhZGRyZXNzICovDQorCSNp
bmNsdWRlICJpbXg4LXNzLXNlY3VyaXR5LmR0c2kiDQogCSNpbmNsdWRlICJpbXg4LXNzLWNtNDEu
ZHRzaSINCiAJI2luY2x1ZGUgImlteDgtc3MtYXVkaW8uZHRzaSINCiAJI2luY2x1ZGUgImlteDgt
c3MtdnB1LmR0c2kiDQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUv
aW14OHF4cC5kdHNpIGIvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHF4cC5kdHNp
DQppbmRleCAwNTEzODMyNmYwYTUuLmUxNDAxNTVkNjVjNiAxMDA2NDQNCi0tLSBhL2FyY2gvYXJt
NjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhxeHAuZHRzaQ0KKysrIGIvYXJjaC9hcm02NC9ib290
L2R0cy9mcmVlc2NhbGUvaW14OHF4cC5kdHNpDQpAQCAtMzIxLDYgKzMyMSw3IEBAIG1hcDAgew0K
IAkvKiBzb3J0ZWQgaW4gcmVnaXN0ZXIgYWRkcmVzcyAqLw0KIAkjaW5jbHVkZSAiaW14OC1zcy1p
bWcuZHRzaSINCiAJI2luY2x1ZGUgImlteDgtc3MtdnB1LmR0c2kiDQorCSNpbmNsdWRlICJpbXg4
LXNzLXNlY3VyaXR5LmR0c2kiDQogCSNpbmNsdWRlICJpbXg4LXNzLWNtNDAuZHRzaSINCiAJI2lu
Y2x1ZGUgImlteDgtc3MtZ3B1MC5kdHNpIg0KIAkjaW5jbHVkZSAiaW14OC1zcy1hZG1hLmR0c2ki
DQotLSANCjIuNDkuMA0K
