Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ADC2209B;
	Wed,  7 Aug 2024 14:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040458; cv=none; b=YCxvJw4ShgMoW+qrQJoIPgKuiEaWguu63qarv+8nQEodnPSK1ho22hpoQJ4xDE6mo3USvXz8MyFJUjUSoqx3Of706df/vOpVPLx3ZOilfmbkQxJig75QrTFmCNgW+7aBgSqquvHLcWS7Ze6JVBm+90ssnP9pEp7RIKm2248KX24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040458; c=relaxed/simple;
	bh=iLtQqJ3VQexC+/HUBMgr0HMLjLF/JY1huZ/Dt7YfC+w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jFe+49eb9naMrshufVJHYXZsXK1BYDyi2M4+KAF7afKRjJcEd82zaayw/RNlETKcpMVD4VJ/rgV2U6wKYEYmWFSJN5ytzQsST7gaayHEl2Ln3s+2bZfDwqZ4R+FtWTzL236CzIhj8MQ551T3Aa4eYMtqDPHa817uwhrWtb1kxzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from msexch01.omp.ru (10.188.4.12) by msexch01.omp.ru (10.188.4.12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Wed, 7 Aug
 2024 17:20:36 +0300
Received: from msexch01.omp.ru ([fe80::485b:1c4a:fb7f:c753]) by
 msexch01.omp.ru ([fe80::485b:1c4a:fb7f:c753%5]) with mapi id 15.02.1258.012;
 Wed, 7 Aug 2024 17:20:36 +0300
From: Roman Smirnov <r.smirnov@omp.ru>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC: "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, Sergey Shtylyov
	<s.shtylyov@omp.ru>, "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: mpi: add NULL checks to mpi_normalize().
Thread-Topic: [PATCH] crypto: mpi: add NULL checks to mpi_normalize().
Thread-Index: AQHa11o1TSphTpofNUacgE4EgGeVc7IT0xkAgAf12AA=
Date: Wed, 7 Aug 2024 14:20:36 +0000
Message-ID: <4ea0ced79912e810e2655bf21896937bd8f8d24e.camel@omp.ru>
References: <20240716082825.65219-1-r.smirnov@omp.ru>
	 <ZqzVPGCbwAS8ChEa@gondor.apana.org.au>
In-Reply-To: <ZqzVPGCbwAS8ChEa@gondor.apana.org.au>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-kse-serverinfo: msexch01.omp.ru, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 8/7/2024 11:55:00 AM
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: InTheLimit
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE7E717FFC66844FAE74F161E036AA70@omp.ru>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI0LTA4LTAyIGF0IDIwOjQ2ICswODAwLCBIZXJiZXJ0IFh1IHdyb3RlOg0KPiBP
biBUdWUsIEp1bCAxNiwgMjAyNCBhdCAxMToyODoyNUFNICswMzAwLCBSb21hbiBTbWlybm92IHdy
b3RlOg0KPiA+IElmIGEtPmQgaXMgTlVMTCwgdGhlIE5VTEwgcG9pbnRlciB3aWxsIGJlIGRlcmVm
ZXJlbmNlZC4gSXQNCj4gPiBpcyBuZWNlc3NhcnkgdG8gcHJldmVudCB0aGlzIGNhc2UuIFRoZXJl
IGlzIGF0IGxlYXN0IG9uZSBjYWxsDQo+ID4gc3RhY2sgdGhhdCBjYW4gbGVhZCB0byBpdDoNCj4g
PiANCj4gPiDCoMKgwqAgbXBpX2VjX2N1cnZlX3BvaW50KCkNCj4gPiDCoMKgwqDCoMKgIGVjX3Bv
dzIoKQ0KPiA+IMKgwqDCoMKgwqDCoMKgIGVjX211bG0oKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oCBlY19tb2QoKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbXBpX21vZCgpDQo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbXBpX2ZkaXZfcigpDQo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIG1waV90ZGl2X3IoKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgbXBpX3RkaXZfcXIoKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIG1waV9yZXNpemUoKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBrY2FsbG9jKCkNCj4gPiANCj4gPiBtcGlfcmVzaXplIGNhbiByZXR1
cm4gLUVOT01FTSwgYnV0IHRoaXMgY2FzZSBpcyBub3QgaGFuZGxlZCBpbiBhbnkgd2F5Lg0KPiA+
IA0KPiA+IE5leHQsIGRlcmVmZXJlbmNpbmcgdGFrZXMgcGxhY2U6DQo+ID4gDQo+ID4gwqDCoMKg
IG1waV9lY19jdXJ2ZV9wb2ludCgpDQo+ID4gwqDCoMKgwqDCoCBtcGlfY21wKCkNCj4gPiDCoMKg
wqDCoMKgwqDCoCBkb19tcGlfY21wKCkNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqAgbXBpX25vcm1h
bGl6ZSgpDQo+ID4gDQo+ID4gRm91bmQgYnkgTGludXggVmVyaWZpY2F0aW9uIENlbnRlciAobGlu
dXh0ZXN0aW5nLm9yZykgd2l0aCBTdmFjZS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb21h
biBTbWlybm92IDxyLnNtaXJub3ZAb21wLnJ1Pg0KPiA+IC0tLQ0KPiA+IMKgbGliL2NyeXB0by9t
cGkvbXBpLWJpdC5jIHwgMyArKysNCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KykNCj4gDQo+IEkndmUganVzdCBwb3N0ZWQgYSBwYXRjaCB0byByZW1vdmUgbXBpX2VjX2N1cnZl
X3BvaW50IGFuZCBtcGlfdGRpdl9xci4NCj4gQXJlIHRoZXJlIGFueSBvdGhlciBjb2RlIHBhdGhz
IHdpdGggdGhlIHNhbWUgcHJvYmxlbT8NCg0KU3ZhY2UgZm91bmQgYSBzaW1pbGFyIGNhc2UgYnV0
IGl0IGlzIG5vIGxvbmdlciByZWxldmFudDoNCg0KTlVMTCBjb25zdGFudDoNCiAgICBtcGlfZWNf
bXVsX3BvaW50KCkNCiAgICAgIGVjX211bG0oejMsIHBvaW50LT56LCB6MiwgY3R4KQ0KICAgICAg
ICBlY19tb2QoKQ0KICAgICAgICAgIG1waV9tb2QoKQ0KICAgICAgICAgICAgbXBpX2ZkaXZfcigp
DQogICAgICAgICAgICAgIG1waV90ZGl2X3IoKQ0KICAgICAgICAgICAgICAgIG1waV90ZGl2X3Fy
KCkNCiAgICAgICAgICAgICAgICAgIG1waV9yZXNpemUoKQ0KICAgICAgICAgICAgICAgICAgICBr
Y2FsbG9jKCkNCg0KRGVyZWZlcmVuY2U6DQogICAgbXBpX2VjX211bF9wb2ludCgpDQogICAgICBl
Y19pbnZtKHozLCB6MywgY3R4KQ0KICAgICAgICBtcGlfaW52bSgpDQogICAgICAgICAgbXBpX2Nt
cF91aSgpDQogICAgICAgICAgICBtcGlfbm9ybWFsaXplKCkNCj4gDQo+IFRoYW5rcywNCg0K
