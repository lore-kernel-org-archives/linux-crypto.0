Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E26202996;
	Tue, 27 May 2025 07:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748330171; cv=none; b=vBdGEiWZMBYBNmoXlHyAD5cnlfrxC54OIk2DhII4ioCJXOwuur7TgHsOW2iuMU1jNi3vNRjyqTSH0Iczr80zyRIKHb+PNKgzjwgwaNV8PqVcdWYd3L+hU2eF1FZFjv1VbWCJ7zRyzOgNL2HcKoFkowKyLaNev7HnroL8Hyw2Qzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748330171; c=relaxed/simple;
	bh=Y08a/dTVSVM+/XsHWHTfPzKKXmUsqI91RqkkVefuBdk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gjhDbwtjYSWJMkIGO888egVoa6mvI5LubRKMeKBsN3KJH1/OsM+OrWq84vbm53Oadv7PtdevvtEM2qX8/9ERSdg0Y56xLD0xBlZ0uGGoGn2KCAYLqYv2GWcQ+FppBWYGGUHoVzxaE/q6V3nfAJ9T+uU0G3UGZeDHy8gtJxDIYng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S035ANL.actianordic.se
 (10.12.31.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 May
 2025 09:16:03 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Tue, 27 May 2025 09:16:03 +0200
From: John Ernberg <john.ernberg@actia.se>
To: =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>
CC: Frank Li <Frank.li@nxp.com>, Pengutronix Kernel Team
	<kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>, Thomas Richard
	<thomas.richard@bootlin.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, John Ernberg <john.ernberg@actia.se>
Subject: [PATCH v2 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM
 support
Thread-Topic: [PATCH v2 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM
 support
Thread-Index: AQHbztc0T1fA+eNp8E2a5tgCivNrBA==
Date: Tue, 27 May 2025 07:16:03 +0000
Message-ID: <20250527071552.1424997-5-john.ernberg@actia.se>
References: <20250527071552.1424997-1-john.ernberg@actia.se>
In-Reply-To: <20250527071552.1424997-1-john.ernberg@actia.se>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.49.0
x-esetresult: clean, is OK
x-esetid: 37303A2956B1445360726A
Content-Type: text/plain; charset="utf-8"
Content-ID: <26D9C3FA2C04A740B422139B30F6361A@actia.se>
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
M2RlZjQwMTc5OGQwYTRlNjQ2MTA1NTgzZA0KDQotLS0NCg0KdjI6DQogLSBVc2UgbmV3IGNvbXBh
dGlibGVzIGludHJvZHVjZWQgaW4gMy80IChGcmFuayBMaSkNCi0tLQ0KIC4uLi9ib290L2R0cy9m
cmVlc2NhbGUvaW14OC1zcy1zZWN1cml0eS5kdHNpICB8IDM4ICsrKysrKysrKysrKysrKysrKysN
CiBhcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4cW0uZHRzaSAgICAgfCAgMSArDQog
YXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHF4cC5kdHNpICAgIHwgIDEgKw0KIDMg
ZmlsZXMgY2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNo
L2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4LXNzLXNlY3VyaXR5LmR0c2kNCg0KZGlmZiAt
LWdpdCBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDgtc3Mtc2VjdXJpdHkuZHRz
aSBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDgtc3Mtc2VjdXJpdHkuZHRzaQ0K
bmV3IGZpbGUgbW9kZSAxMDA2NDQNCmluZGV4IDAwMDAwMDAwMDAwMC4uOWVjYWJiMmQwM2U5DQot
LS0gL2Rldi9udWxsDQorKysgYi9hcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4LXNz
LXNlY3VyaXR5LmR0c2kNCkBAIC0wLDAgKzEsMzggQEANCisvLyBTUERYLUxpY2Vuc2UtSWRlbnRp
ZmllcjogR1BMLTIuMCsNCisvKg0KKyAqIENvcHlyaWdodCAyMDE5IE5YUA0KKyAqLw0KKw0KKyNp
bmNsdWRlIDxkdC1iaW5kaW5ncy9maXJtd2FyZS9pbXgvcnNyYy5oPg0KKw0KK3NlY3VyaXR5X3N1
YnN5czogYnVzQDMxNDAwMDAwIHsNCisJY29tcGF0aWJsZSA9ICJzaW1wbGUtYnVzIjsNCisJI2Fk
ZHJlc3MtY2VsbHMgPSA8MT47DQorCSNzaXplLWNlbGxzID0gPDE+Ow0KKwlyYW5nZXMgPSA8MHgz
MTQwMDAwMCAweDAgMHgzMTQwMDAwMCAweDkwMDAwPjsNCisNCisJY3J5cHRvOiBjcnlwdG9AMzE0
MDAwMDAgew0KKwkJY29tcGF0aWJsZSA9ICJmc2wsaW14OHFtLWNhYW0iLCAiZnNsLHNlYy12NC4w
IjsNCisJCXJlZyA9IDwweDMxNDAwMDAwIDB4OTAwMDA+Ow0KKwkJaW50ZXJydXB0cyA9IDxHSUNf
U1BJIDE0OCBJUlFfVFlQRV9MRVZFTF9ISUdIPjsNCisJCSNhZGRyZXNzLWNlbGxzID0gPDE+Ow0K
KwkJI3NpemUtY2VsbHMgPSA8MT47DQorCQlyYW5nZXMgPSA8MCAweDMxNDAwMDAwIDB4OTAwMDA+
Ow0KKwkJZnNsLHNlYy1lcmEgPSA8OT47DQorCQlwb3dlci1kb21haW5zID0gPCZwZCBJTVhfU0Nf
Ul9DQUFNX0pSMj47DQorDQorCQlzZWNfanIyOiBqckAzMDAwMCB7DQorCQkJY29tcGF0aWJsZSA9
ICJmc2wsaW14OHFtLWpvYi1yaW5nIiwgImZzbCxzZWMtdjQuMC1qb2ItcmluZyI7DQorCQkJcmVn
ID0gPDB4MzAwMDAgMHgxMDAwMD47DQorCQkJaW50ZXJydXB0cyA9IDxHSUNfU1BJIDQ1MyBJUlFf
VFlQRV9MRVZFTF9ISUdIPjsNCisJCQlwb3dlci1kb21haW5zID0gPCZwZCBJTVhfU0NfUl9DQUFN
X0pSMj47DQorCQl9Ow0KKw0KKwkJc2VjX2pyMzoganJANDAwMDAgew0KKwkJCWNvbXBhdGlibGUg
PSAiZnNsLGlteDhxbS1qb2ItcmluZyIsICJmc2wsc2VjLXY0LjAtam9iLXJpbmciOw0KKwkJCXJl
ZyA9IDwweDQwMDAwIDB4MTAwMDA+Ow0KKwkJCWludGVycnVwdHMgPSA8R0lDX1NQSSA0NTQgSVJR
X1RZUEVfTEVWRUxfSElHSD47DQorCQkJcG93ZXItZG9tYWlucyA9IDwmcGQgSU1YX1NDX1JfQ0FB
TV9KUjM+Ow0KKwkJfTsNCisJfTsNCit9Ow0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvYm9vdC9k
dHMvZnJlZXNjYWxlL2lteDhxbS5kdHNpIGIvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUv
aW14OHFtLmR0c2kNCmluZGV4IDZmYTMxYmM5ZWNlOC4uNmRmMDE4NjQzZjIwIDEwMDY0NA0KLS0t
IGEvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHFtLmR0c2kNCisrKyBiL2FyY2gv
YXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhxbS5kdHNpDQpAQCAtNjEyLDYgKzYxMiw3IEBA
IHZwdV9kc3A6IGRzcEA1NTZlODAwMCB7DQogCX07DQogDQogCS8qIHNvcnRlZCBpbiByZWdpc3Rl
ciBhZGRyZXNzICovDQorCSNpbmNsdWRlICJpbXg4LXNzLXNlY3VyaXR5LmR0c2kiDQogCSNpbmNs
dWRlICJpbXg4LXNzLWNtNDEuZHRzaSINCiAJI2luY2x1ZGUgImlteDgtc3MtYXVkaW8uZHRzaSIN
CiAJI2luY2x1ZGUgImlteDgtc3MtdnB1LmR0c2kiDQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9i
b290L2R0cy9mcmVlc2NhbGUvaW14OHF4cC5kdHNpIGIvYXJjaC9hcm02NC9ib290L2R0cy9mcmVl
c2NhbGUvaW14OHF4cC5kdHNpDQppbmRleCAwNTEzODMyNmYwYTUuLmUxNDAxNTVkNjVjNiAxMDA2
NDQNCi0tLSBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhxeHAuZHRzaQ0KKysr
IGIvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHF4cC5kdHNpDQpAQCAtMzIxLDYg
KzMyMSw3IEBAIG1hcDAgew0KIAkvKiBzb3J0ZWQgaW4gcmVnaXN0ZXIgYWRkcmVzcyAqLw0KIAkj
aW5jbHVkZSAiaW14OC1zcy1pbWcuZHRzaSINCiAJI2luY2x1ZGUgImlteDgtc3MtdnB1LmR0c2ki
DQorCSNpbmNsdWRlICJpbXg4LXNzLXNlY3VyaXR5LmR0c2kiDQogCSNpbmNsdWRlICJpbXg4LXNz
LWNtNDAuZHRzaSINCiAJI2luY2x1ZGUgImlteDgtc3MtZ3B1MC5kdHNpIg0KIAkjaW5jbHVkZSAi
aW14OC1zcy1hZG1hLmR0c2kiDQotLSANCjIuNDkuMA0K
