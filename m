Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EF345009;
	Tue, 27 May 2025 07:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748330168; cv=none; b=A01jwXwtxAOj9yb/6k9E35vSoh57SgWceQt80kag1/L7/oZn1hItWxNzJJqV09Ayy+mnvUBM1Uc65iLuRL6HehjAifUbzMl8uc8dGFPWJmV02QtlqAvjIEgCprtIYsb+gGv8LjOZRiXVLL1tC2Dov8BNpcqA+ABC3wmWiCx6a/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748330168; c=relaxed/simple;
	bh=k+by0adHcEvdVW7TpYj+/UGk4iIyaS/4a2TG6II89tI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lRK7DdydLuYfEfIzqIYh5MPiYzo1mWkCvrKGpbaaID8rgHmYmXOZ0JO4xpFCaRLbFIiP3hzyJyxKT23H8usCzJsBcFC41h7nKKRCVQ7CceOVzmHsWHSMBrvyveg/dfeQXEYI23qOr927O3K+9WQc+8QHZJXfiiOsNEuXnRurHZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S036ANL.actianordic.se
 (10.12.31.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 May
 2025 09:16:02 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Tue, 27 May 2025 09:16:02 +0200
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
Subject: [PATCH v2 0/4] crypto: caam - iMX8QXP support (and related fixes)
Thread-Topic: [PATCH v2 0/4] crypto: caam - iMX8QXP support (and related
 fixes)
Thread-Index: AQHbztc0+n0doXv/EUywtPoFaqnp/Q==
Date: Tue, 27 May 2025 07:16:02 +0000
Message-ID: <20250527071552.1424997-1-john.ernberg@actia.se>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.49.0
x-esetresult: clean, is OK
x-esetid: 37303A2955B1445360726A
Content-Type: text/plain; charset="utf-8"
Content-ID: <E26ABAA79C8EA24BB96EF0E531D86379@actia.se>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

VGhpcyBzZXJpZXMgZW5hYmxlcyB0aGUgdXNlIG9mIHRoZSBDQUFNIChDcnlwdG9ncmFwaGljIEFj
Y2VsZXJhdGlvbiBhbmQNCkFzc3VyYW5jZSBNb2R1bGUpIG9uIHRoZSBpTVg4UVhQIChhbmQgaXRz
IHZhcmlhbnRzKS4NCg0KDQp2MjogKGRldGFpbGVkIGxvZ3MgaW4gZWFjaCBwYXRjaCkNCiAtIENs
YXJpZnkgaW4gdGhlIGNvbW1pdCBtZXNzYWdlIGhvdyB0aGUgY3Jhc2ggZml4IHdvcmtzIChGcmFu
ayBMaSkNCiAtIFJlc3RyaWN0IHBvd2VyLWRvbWFpbnMgb25seSBmb3IgaU1YOFEqIFNvQ3MgaW4g
YmluZGluZ3MgKEZyYW5rIExpKQ0KIC0gQ29sbGVjdCB0YWdzDQoNCnYxOiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9saW51eC1jcnlwdG8vMjAyNTA1MjMxMzE4MTQuMTA0NzY2Mi0xLWpvaG4uZXJu
YmVyZ0BhY3RpYS5zZS9UDQoNCkhvcmlhIEdlYW50xIMgKDEpOg0KICBhcm02NDogZHRzOiBmcmVl
c2NhbGU6IGlteDhxeHAvaW14OHFtOiBBZGQgQ0FBTSBzdXBwb3J0DQoNCkpvaG4gRXJuYmVyZyAo
Myk6DQogIGNyeXB0bzogY2FhbSAtIFByZXZlbnQgY3Jhc2ggb24gc3VzcGVuZCB3aXRoIGlNWDhR
TSAvIGlNWDhVTFANCiAgY3J5cHRvOiBjYWFtIC0gU3VwcG9ydCBpTVg4UVhQIGFuZCB2YXJpYW50
cyB0aGVyZW9mDQogIGR0LWJpbmRpbmdzOiBjcnlwdG86IGZzbCxzZWMtdjQuMDogQWRkIHBvd2Vy
IGRvbWFpbnMgZm9yIGlNWDhRTSBhbmQNCiAgICBpTVg4UVhQDQoNCiAuLi4vYmluZGluZ3MvY3J5
cHRvL2ZzbCxzZWMtdjQuMC55YW1sICAgICAgICAgfCAzNiArKysrKysrKysrKysrKysrKysNCiAu
Li4vYm9vdC9kdHMvZnJlZXNjYWxlL2lteDgtc3Mtc2VjdXJpdHkuZHRzaSAgfCAzOCArKysrKysr
KysrKysrKysrKysrDQogYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHFtLmR0c2kg
ICAgIHwgIDEgKw0KIGFyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhxeHAuZHRzaSAg
ICB8ICAxICsNCiBkcml2ZXJzL2NyeXB0by9jYWFtL2N0cmwuYyAgICAgICAgICAgICAgICAgICAg
fCAgNyArKy0tDQogZHJpdmVycy9jcnlwdG8vY2FhbS9pbnRlcm4uaCAgICAgICAgICAgICAgICAg
IHwgIDEgKw0KIDYgZmlsZXMgY2hhbmdlZCwgODEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkNCiBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14
OC1zcy1zZWN1cml0eS5kdHNpDQoNCi0tIA0KMi40OS4wDQo=
