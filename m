Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9AC21B9CF;
	Thu, 29 May 2025 09:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748512170; cv=none; b=c4EtnYgEjlXM9+LPpfSSrgJIXxPSh9BKiQzCJhIZjTC0+rPjhWPVxF2jryfEtnuRX2NhbKf9Hm1XW8gWq5VXZv1YMGmpxG2kWk6XqUVLLUdbiefKZ63yaw76PuIdOZrKTsXC9M94xgQLNYXK5dFTcGyOY/MaMXm6GztbUy8BlHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748512170; c=relaxed/simple;
	bh=OinrcQkKP+invtmfZEgmKc9uaH1M7ZYOcO3eHfnnWrM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZVQV7bfwStuvLhqDzt8SQqWjlYrWABvIsnySjtrNO8Q+4le2SF+RGftQ2QUshPiCagylSQckRjPe2kU+q4zX+SMAOx+wX1khTNmJs6nCpjKz0hzj/V7FAzewR4O6Wn2gcrSm6XWJTSrK+G6ETc0iOkiUGrxZ8jpTFd+aFKyHoHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S035ANL.actianordic.se
 (10.12.31.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 May
 2025 11:49:26 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Thu, 29 May 2025 11:49:26 +0200
From: John Ernberg <john.ernberg@actia.se>
To: Frank Li <Frank.li@nxp.com>
CC: =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, Thomas Richard
	<thomas.richard@bootlin.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM
 support
Thread-Topic: [PATCH v3 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM
 support
Thread-Index: AQHbz97Tt285JTpbTEmv8WU56gl5orPoAYiAgAE7H4A=
Date: Thu, 29 May 2025 09:49:26 +0000
Message-ID: <aDgtpd_pXyLjgoIJ@w447anl.localdomain>
References: <20250528144259.2603914-1-john.ernberg@actia.se>
 <20250528144259.2603914-5-john.ernberg@actia.se>
 <aDclTQ8Z5WcHMxgT@lizhi-Precision-Tower-5810>
In-Reply-To: <aDclTQ8Z5WcHMxgT@lizhi-Precision-Tower-5810>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-esetresult: clean, is OK
x-esetid: 37303A2956B14453637562
Content-Type: text/plain; charset="utf-8"
Content-ID: <1915B73BA669544EBEE2CF7E9C60C389@actia.se>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SGkgRnJhbmssDQoNCk9uIFdlZCwgTWF5IDI4LCAyMDI1IGF0IDExOjAxOjMzQU0gLTA0MDAsIEZy
YW5rIExpIHdyb3RlOg0KPiBPbiBXZWQsIE1heSAyOCwgMjAyNSBhdCAwMjo0MzowOFBNICswMDAw
LCBKb2huIEVybmJlcmcgd3JvdGU6DQo+ID4gRnJvbTogSG9yaWEgR2VhbnTEgyA8aG9yaWEuZ2Vh
bnRhQG54cC5jb20+DQo+ID4NCj4gPiBUaGUgaU1YOFFYUCBhbmQgaU1YOFFNIGhhdmUgYSBDQUFN
IChDcnlwdG9ncmFwaGljIEFjY2VsZXJhdGlvbiBhbmQNCj4gPiBBc3N1cmFuY2UgTW9kdWxlKSBs
aWtlIG1hbnkgb3RoZXIgaU1Ycy4NCj4gPg0KPiA+IEFkZCB0aGUgZGVmaW5pdGlvbnMgZm9yIGl0
Lg0KPiA+DQo+ID4gSm9iIFJpbmdzIDAgYW5kIDEgYXJlIGJvdW5kIHRvIHRoZSBTRUNPIChTZWN1
cml0eSBDb250cm9sbGVyKSBBUk0gY29yZQ0KPiA+IGFuZCBhcmUgbm90IGV4cG9zZWQgb3V0c2lk
ZSBpdC4gVGhlcmUncyBubyBwb2ludCB0byBkZWZpbmUgdGhlbSBpbiB0aGUNCj4gPiBiaW5kaW5n
cyBhcyB0aGV5IGNhbm5vdCBiZSB1c2VkIG91dHNpZGUgdGhlIFNFQ08uDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBIb3JpYSBHZWFudMSDIDxob3JpYS5nZWFudGFAbnhwLmNvbT4NCj4gPiBbamVy
bmJlcmc6IENvbW1pdCBtZXNzYWdlLCBmaXhlZCBkdGJzX2NoZWNrIHdhcm5pbmdzLCB0cmltbWVk
IG1lbW9yeSByYW5nZXNdDQo+IA0KPiB3aGF0J3MgdGhpcyBmb3I/ICByZW1vdmUgaXQgaWYgbm90
IHJlbGF0ZWQgd2l0aCB0aGlzIHBhdGNoLg0KDQpUaGVzZSBhcmUgdGhlIGFkanVzdG1lbnRzIEkg
ZGlkIHRvIHRoZSBwYXRjaCBieSBIb3JpYSB0aGF0IEkgdG9vayBvdXQgb2YNCnRoZSBsaW51eC1p
bXggdHJlZSAob3JpZ2luYWwgcGF0Y2ggbGlua2VkIGJlbG93IGluIGNvbnRleHQpLg0KDQpXaGls
ZSBub3QgcGFydCBvZiB0aGUgcHJvY2VzcyBJIGhhdmUgc2VlbiB0aGVtIHVzZWQgYW5kIGZvdW5k
IHRoZW0gaGVscGZ1bCwNCkkgY2FuIGRyb3AgaXQgaWYgcHJlZmVycmVkLg0KDQpCZXN0IHJlZ2Fy
ZHMgLy8gSm9obiBFcm5iZXJnDQoNCj4gDQo+IEZyYW5rDQo+IA0KPiA+IFNpZ25lZC1vZmYtYnk6
IEpvaG4gRXJuYmVyZyA8am9obi5lcm5iZXJnQGFjdGlhLnNlPg0KPiA+DQo+ID4gLS0tDQo+ID4N
Cj4gPiBJbXBvcnRlZCBmcm9tIE5YUCB0cmVlLCB0cmltbWVkIGRvd24gYW5kIGZpeGVkIHRoZSBk
dGJzX2NoZWNrIHdhcm5pbmdzLg0KPiA+IENvbnN0cmFpbmVkIHRoZSByYW5nZXMgdG8gdGhlIG5l
ZWRlZCBvbmVzLg0KPiA+IENoYW5nZWQgdGhlIGNvbW1pdCBtZXNzYWdlLg0KPiA+IE9yaWdpbmFs
IGhlcmU6IGh0dHBzOi8vZ2l0aHViLmNvbS9ueHAtaW14L2xpbnV4LWlteC9jb21taXQvNjk5ZTU0
YjM4NmNiOWI1M2RlZjQwMTc5OGQwYTRlNjQ2MTA1NTgzZA0KPiA+DQo+ID4gLS0t
