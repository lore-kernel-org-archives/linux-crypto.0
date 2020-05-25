Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE408C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 07:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F6320812
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 07:24:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="V1tL8NZb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389017AbgEYHY4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 03:24:56 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:23972 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388948AbgEYHY4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 03:24:56 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04P7LmsH031192;
        Mon, 25 May 2020 09:24:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=uJWboNdI9Fne2EVmQsnu0M7tiRztbcc/DAD3CUCrI1E=;
 b=V1tL8NZbHOPYl3mFUWuhdBS7MK53SFZjDpkz9Eto8ynpMZpAQZehDjokkDTos5+A9ByT
 mHObntfUKYfsziwO6WHJXizLTUfMJkk6yWT8/rp8Ec+0HDBDL92VNcWncSwvdEDXdmmO
 D3A3ABrx0VwMfDJiVut6Yx0C6wDEHR4q78GRYsH67aiwMhva+/bd+8RN1uAnsVw/TZby
 vjsDlWp5q8z1xExWCvPnc9HsQBceuZuJeh/STJYPImiqhOLJ6BCqrlcJTndT9C3v31YO
 lDD2muSk+a7KxnL4yZVUqE3d6pEMIpJzKSuDy/s8HR8junwSf5dgHyCDH/ZHjQigmZ1y Qg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 316sa1s0gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 May 2020 09:24:23 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 8E03610002A;
        Mon, 25 May 2020 09:24:19 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node1.st.com [10.75.127.7])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 4086E206038;
        Mon, 25 May 2020 09:24:19 +0200 (CEST)
Received: from SFHDAG6NODE1.st.com (10.75.127.16) by SFHDAG3NODE1.st.com
 (10.75.127.7) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 May
 2020 09:24:18 +0200
Received: from SFHDAG6NODE1.st.com ([fe80::8d96:4406:44e3:eb27]) by
 SFHDAG6NODE1.st.com ([fe80::8d96:4406:44e3:eb27%20]) with mapi id
 15.00.1473.003; Mon, 25 May 2020 09:24:18 +0200
From:   Nicolas TOROMANOFF <nicolas.toromanoff@st.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre TORGUE" <alexandre.torgue@st.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5] crypto: stm32/crc: protect from concurrent accesses
Thread-Topic: [PATCH 5/5] crypto: stm32/crc: protect from concurrent accesses
Thread-Index: AQHWKGdMVH9jV+o/X0uyAZQ0uxDfN6i0NRcAgAQ4E3A=
Date:   Mon, 25 May 2020 07:24:18 +0000
Message-ID: <67c25d90d9714a85b52f3d9c2070af88@SFHDAG6NODE1.st.com>
References: <20200512141113.18972-1-nicolas.toromanoff@st.com>
 <20200512141113.18972-6-nicolas.toromanoff@st.com>
 <CAMj1kXGs6UgkKb5+tH2B-+26=tbjHq3UUY2gxfcRfMb1nGVuFA@mail.gmail.com>
In-Reply-To: <CAMj1kXGs6UgkKb5+tH2B-+26=tbjHq3UUY2gxfcRfMb1nGVuFA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.44]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-25_02:2020-05-22,2020-05-25 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJkIEJpZXNo
ZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCBNYXkgMjIsIDIwMjAgNjox
MiBQTT4gDQo+IE9uIFR1ZSwgMTIgTWF5IDIwMjAgYXQgMTY6MTMsIE5pY29sYXMgVG9yb21hbm9m
Zg0KPiA8bmljb2xhcy50b3JvbWFub2ZmQHN0LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBQcm90ZWN0
IFNUTTMyIENSQyBkZXZpY2UgZnJvbSBjb25jdXJyZW50IGFjY2Vzc2VzLg0KPiA+DQo+ID4gQXMg
d2UgY3JlYXRlIGEgc3BpbmxvY2tlZCBzZWN0aW9uIHRoYXQgaW5jcmVhc2Ugd2l0aCBidWZmZXIg
c2l6ZSwgd2UNCj4gPiBwcm92aWRlIGEgbW9kdWxlIHBhcmFtZXRlciB0byByZWxlYXNlIHRoZSBw
cmVzc3VyZSBieSBzcGxpdHRpbmcNCj4gPiBjcml0aWNhbCBzZWN0aW9uIGluIGNodW5rcy4NCj4g
Pg0KPiA+IFNpemUgb2YgZWFjaCBjaHVuayBpcyBkZWZpbmVkIGluIGJ1cnN0X3NpemUgbW9kdWxl
IHBhcmFtZXRlci4NCj4gPiBCeSBkZWZhdWx0IGJ1cnN0X3NpemU9MCwgaS5lLiBkb24ndCBzcGxp
dCBpbmNvbWluZyBidWZmZXIuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIFRvcm9t
YW5vZmYgPG5pY29sYXMudG9yb21hbm9mZkBzdC5jb20+DQo+IA0KPiBXb3VsZCB5b3UgbWluZCBl
eHBsYWluaW5nIHRoZSB1c2FnZSBtb2RlbCBoZXJlPyBJdCBsb29rcyBsaWtlIHlvdSBhcmUgc2hh
cmluZyBhDQo+IENSQyBoYXJkd2FyZSBhY2NlbGVyYXRvciB3aXRoIGEgc3luY2hyb25vdXMgaW50
ZXJmYWNlIGJldHdlZW4gZGlmZmVyZW50IHVzZXJzDQo+IGJ5IHVzaW5nIHNwaW5sb2Nrcz8gWW91
IGFyZSBhd2FyZSB0aGF0IHRoaXMgd2lsbCB0aWUgdXAgdGhlIHdhaXRpbmcgQ1BVcw0KPiBjb21w
bGV0ZWx5IGR1cmluZyB0aGlzIHRpbWUsIHJpZ2h0PyBTbyBpdCB3b3VsZCBiZSBtdWNoIGJldHRl
ciB0byB1c2UgYSBtdXRleA0KPiBoZXJlLiBPciBwZXJoYXBzIGl0IHdvdWxkIG1ha2UgbW9yZSBz
ZW5zZSB0byBmYWxsIGJhY2sgdG8gYSBzL3cgYmFzZWQgQ1JDDQo+IHJvdXRpbmUgaWYgdGhlIGgv
dyBpcyB0aWVkIHVwIHdvcmtpbmcgZm9yIGFub3RoZXIgdGFzaz8NCg0KSSBrbm93IG11dGV4IGFy
ZSBtb3JlIGFjY2VwdGFibGUgaGVyZSwgYnV0IHNoYXNoIF91cGRhdGUoKSBhbmQgX2luaXQoKSBt
YXkgYmUgY2FsbCANCmZyb20gYW55IGNvbnRleHQsIGFuZCBzbyBJIGNhbm5vdCB0YWtlIGEgbXV0
ZXguDQpBbmQgdG8gcHJvdGVjdCBteSBjb25jdXJyZW50IEhXIGFjY2VzcyBJIG9ubHkgdGhvdWdo
IGFib3V0IHNwaW5sb2NrLiBEdWUgdG8gcG9zc2libGUNCmNvbnN0cmFpbnQgb24gQ1BVcywgSSBh
ZGQgYSBidXJzdF9zaXplIG9wdGlvbiB0byBmb3JjZSBzbGl0dGluZyBsb25nIGJ1ZmZlciBpbnRv
IHNtYWxsZXIgb25lLA0KYW5kIHNvIGRlY3JlYXNlIHRpbWUgd2UgdGFrZSB0aGUgbG9jay4NCkJ1
dCBJIGRpZG4ndCB0aG91Z2ggdG8gZmFsbGJhY2sgdG8gc29mdHdhcmUgQ1JDLg0KDQpJJ2xsIGRv
IGEgcGF0Y2ggb24gdG9wLg0KSW4gaW4gdGhlIGJ1cnN0X3VwZGF0ZSgpIGZ1bmN0aW9uIEknbGwg
dXNlIGEgc3Bpbl90cnlsb2NrX2lycXNhdmUoKSBhbmQgdXNlIHNvZnR3YXJlIENSQzMyIGlmIEhX
IGlzIGFscmVhZHkgaW4gdXNlLg0KDQpUaGFua3MgYW5kIHJlZ2FyZHMsDQpOaWNvbGFzLg0KDQo+
IFVzaW5nIHNwaW5sb2NrcyBmb3IgdGhpcyBpcyByZWFsbHkgbm90IGFjY2VwdGFibGUuDQo+IA0K
PiANCj4gDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvY3J5cHRvL3N0bTMyL3N0bTMyLWNyYzMyLmMg
fCA0Nw0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgNDUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL2NyeXB0by9zdG0zMi9zdG0zMi1jcmMzMi5jDQo+ID4gYi9kcml2ZXJzL2Ny
eXB0by9zdG0zMi9zdG0zMi1jcmMzMi5jDQo+ID4gaW5kZXggNDEzNDE1YzIxNmVmLi4zYmE0MTE0
OGMyYTQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vc3RtMzIvc3RtMzItY3JjMzIu
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL3N0bTMyL3N0bTMyLWNyYzMyLmMNCj4gPiBAQCAt
MzUsMTEgKzM1LDE2IEBADQo+ID4NCj4gPiAgI2RlZmluZSBDUkNfQVVUT1NVU1BFTkRfREVMQVkg
IDUwDQo+ID4NCj4gPiArc3RhdGljIHVuc2lnbmVkIGludCBidXJzdF9zaXplOw0KPiA+ICttb2R1
bGVfcGFyYW0oYnVyc3Rfc2l6ZSwgdWludCwgMDY0NCk7IE1PRFVMRV9QQVJNX0RFU0MoYnVyc3Rf
c2l6ZSwNCj4gPiArIlNlbGVjdCBidXJzdCBieXRlIHNpemUgKDAgdW5saW1pdGVkKSIpOw0KPiA+
ICsNCj4gPiAgc3RydWN0IHN0bTMyX2NyYyB7DQo+ID4gICAgICAgICBzdHJ1Y3QgbGlzdF9oZWFk
IGxpc3Q7DQo+ID4gICAgICAgICBzdHJ1Y3QgZGV2aWNlICAgICpkZXY7DQo+ID4gICAgICAgICB2
b2lkIF9faW9tZW0gICAgICpyZWdzOw0KPiA+ICAgICAgICAgc3RydWN0IGNsayAgICAgICAqY2xr
Ow0KPiA+ICsgICAgICAgc3BpbmxvY2tfdCAgICAgICBsb2NrOw0KPiA+ICB9Ow0KPiA+DQo+ID4g
IHN0cnVjdCBzdG0zMl9jcmNfbGlzdCB7DQo+ID4gQEAgLTEwOSw2ICsxMTQsNyBAQCBzdGF0aWMg
aW50IHN0bTMyX2NyY19pbml0KHN0cnVjdCBzaGFzaF9kZXNjICpkZXNjKQ0KPiA+ICAgICAgICAg
c3RydWN0IHN0bTMyX2NyY19kZXNjX2N0eCAqY3R4ID0gc2hhc2hfZGVzY19jdHgoZGVzYyk7DQo+
ID4gICAgICAgICBzdHJ1Y3Qgc3RtMzJfY3JjX2N0eCAqbWN0eCA9IGNyeXB0b19zaGFzaF9jdHgo
ZGVzYy0+dGZtKTsNCj4gPiAgICAgICAgIHN0cnVjdCBzdG0zMl9jcmMgKmNyYzsNCj4gPiArICAg
ICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4NCj4gPiAgICAgICAgIGNyYyA9IHN0bTMyX2Ny
Y19nZXRfbmV4dF9jcmMoKTsNCj4gPiAgICAgICAgIGlmICghY3JjKQ0KPiA+IEBAIC0xMTYsNiAr
MTIyLDggQEAgc3RhdGljIGludCBzdG0zMl9jcmNfaW5pdChzdHJ1Y3Qgc2hhc2hfZGVzYyAqZGVz
YykNCj4gPg0KPiA+ICAgICAgICAgcG1fcnVudGltZV9nZXRfc3luYyhjcmMtPmRldik7DQo+ID4N
Cj4gPiArICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZjcmMtPmxvY2ssIGZsYWdzKTsNCj4gPiAr
DQo+ID4gICAgICAgICAvKiBSZXNldCwgc2V0IGtleSwgcG9seSBhbmQgY29uZmlndXJlIGluIGJp
dCByZXZlcnNlIG1vZGUgKi8NCj4gPiAgICAgICAgIHdyaXRlbF9yZWxheGVkKGJpdHJldjMyKG1j
dHgtPmtleSksIGNyYy0+cmVncyArIENSQ19JTklUKTsNCj4gPiAgICAgICAgIHdyaXRlbF9yZWxh
eGVkKGJpdHJldjMyKG1jdHgtPnBvbHkpLCBjcmMtPnJlZ3MgKyBDUkNfUE9MKTsgQEANCj4gPiAt
MTI1LDE4ICsxMzMsMjEgQEAgc3RhdGljIGludCBzdG0zMl9jcmNfaW5pdChzdHJ1Y3Qgc2hhc2hf
ZGVzYyAqZGVzYykNCj4gPiAgICAgICAgIC8qIFN0b3JlIHBhcnRpYWwgcmVzdWx0ICovDQo+ID4g
ICAgICAgICBjdHgtPnBhcnRpYWwgPSByZWFkbF9yZWxheGVkKGNyYy0+cmVncyArIENSQ19EUik7
DQo+ID4NCj4gPiArICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmNyYy0+bG9jaywgZmxh
Z3MpOw0KPiA+ICsNCj4gPiAgICAgICAgIHBtX3J1bnRpbWVfbWFya19sYXN0X2J1c3koY3JjLT5k
ZXYpOw0KPiA+ICAgICAgICAgcG1fcnVudGltZV9wdXRfYXV0b3N1c3BlbmQoY3JjLT5kZXYpOw0K
PiA+DQo+ID4gICAgICAgICByZXR1cm4gMDsNCj4gPiAgfQ0KPiA+DQo+ID4gLXN0YXRpYyBpbnQg
c3RtMzJfY3JjX3VwZGF0ZShzdHJ1Y3Qgc2hhc2hfZGVzYyAqZGVzYywgY29uc3QgdTggKmQ4LA0K
PiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBpbnQgbGVuZ3RoKQ0KPiA+
ICtzdGF0aWMgaW50IGJ1cnN0X3VwZGF0ZShzdHJ1Y3Qgc2hhc2hfZGVzYyAqZGVzYywgY29uc3Qg
dTggKmQ4LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHNpemVfdCBsZW5ndGgpDQo+ID4g
IHsNCj4gPiAgICAgICAgIHN0cnVjdCBzdG0zMl9jcmNfZGVzY19jdHggKmN0eCA9IHNoYXNoX2Rl
c2NfY3R4KGRlc2MpOw0KPiA+ICAgICAgICAgc3RydWN0IHN0bTMyX2NyY19jdHggKm1jdHggPSBj
cnlwdG9fc2hhc2hfY3R4KGRlc2MtPnRmbSk7DQo+ID4gICAgICAgICBzdHJ1Y3Qgc3RtMzJfY3Jj
ICpjcmM7DQo+ID4gKyAgICAgICB1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+DQo+ID4gICAgICAg
ICBjcmMgPSBzdG0zMl9jcmNfZ2V0X25leHRfY3JjKCk7DQo+ID4gICAgICAgICBpZiAoIWNyYykN
Cj4gPiBAQCAtMTQ0LDYgKzE1NSw4IEBAIHN0YXRpYyBpbnQgc3RtMzJfY3JjX3VwZGF0ZShzdHJ1
Y3Qgc2hhc2hfZGVzYw0KPiA+ICpkZXNjLCBjb25zdCB1OCAqZDgsDQo+ID4NCj4gPiAgICAgICAg
IHBtX3J1bnRpbWVfZ2V0X3N5bmMoY3JjLT5kZXYpOw0KPiA+DQo+ID4gKyAgICAgICBzcGluX2xv
Y2tfaXJxc2F2ZSgmY3JjLT5sb2NrLCBmbGFncyk7DQo+ID4gKw0KPiA+ICAgICAgICAgLyoNCj4g
PiAgICAgICAgICAqIFJlc3RvcmUgcHJldmlvdXNseSBjYWxjdWxhdGVkIENSQyBmb3IgdGhpcyBj
b250ZXh0IGFzIGluaXQgdmFsdWUNCj4gPiAgICAgICAgICAqIFJlc3RvcmUgcG9seW5vbWlhbCBj
b25maWd1cmF0aW9uIEBAIC0xODIsMTIgKzE5NSw0MCBAQA0KPiA+IHN0YXRpYyBpbnQgc3RtMzJf
Y3JjX3VwZGF0ZShzdHJ1Y3Qgc2hhc2hfZGVzYyAqZGVzYywgY29uc3QgdTggKmQ4LA0KPiA+ICAg
ICAgICAgLyogU3RvcmUgcGFydGlhbCByZXN1bHQgKi8NCj4gPiAgICAgICAgIGN0eC0+cGFydGlh
bCA9IHJlYWRsX3JlbGF4ZWQoY3JjLT5yZWdzICsgQ1JDX0RSKTsNCj4gPg0KPiA+ICsgICAgICAg
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY3JjLT5sb2NrLCBmbGFncyk7DQo+ID4gKw0KPiA+ICAg
ICAgICAgcG1fcnVudGltZV9tYXJrX2xhc3RfYnVzeShjcmMtPmRldik7DQo+ID4gICAgICAgICBw
bV9ydW50aW1lX3B1dF9hdXRvc3VzcGVuZChjcmMtPmRldik7DQo+ID4NCj4gPiAgICAgICAgIHJl
dHVybiAwOw0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIGludCBzdG0zMl9jcmNfdXBkYXRlKHN0
cnVjdCBzaGFzaF9kZXNjICpkZXNjLCBjb25zdCB1OCAqZDgsDQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHVuc2lnbmVkIGludCBsZW5ndGgpIHsNCj4gPiArICAgICAgIGNvbnN0IHVu
c2lnbmVkIGludCBidXJzdF9zeiA9IGJ1cnN0X3NpemU7DQo+ID4gKyAgICAgICB1bnNpZ25lZCBp
bnQgcmVtX3N6Ow0KPiA+ICsgICAgICAgY29uc3QgdTggKmN1cjsNCj4gPiArICAgICAgIHNpemVf
dCBzaXplOw0KPiA+ICsgICAgICAgaW50IHJldDsNCj4gPiArDQo+ID4gKyAgICAgICBpZiAoIWJ1
cnN0X3N6KQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gYnVyc3RfdXBkYXRlKGRlc2MsIGQ4
LCBsZW5ndGgpOw0KPiA+ICsNCj4gPiArICAgICAgIC8qIERpZ2VzdCBmaXJzdCBieXRlcyBub3Qg
MzJiaXQgYWxpZ25lZCBhdCBmaXJzdCBwYXNzIGluIHRoZSBsb29wICovDQo+ID4gKyAgICAgICBz
aXplID0gbWluKGxlbmd0aCwNCj4gPiArICAgICAgICAgICAgICAgICAgYnVyc3Rfc3ogKyAodW5z
aWduZWQgaW50KWQ4IC0gQUxJR05fRE9XTigodW5zaWduZWQgaW50KWQ4LA0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpemVv
Zih1MzIpKSk7DQo+ID4gKyAgICAgICBmb3IgKHJlbV9zeiA9IGxlbmd0aCwgY3VyID0gZDg7IHJl
bV9zejsNCj4gPiArICAgICAgICAgICAgcmVtX3N6IC09IHNpemUsIGN1ciArPSBzaXplLCBzaXpl
ID0gbWluKHJlbV9zeiwgYnVyc3Rfc3opKSB7DQo+ID4gKyAgICAgICAgICAgICAgIHJldCA9IGJ1
cnN0X3VwZGF0ZShkZXNjLCBjdXIsIHNpemUpOw0KPiA+ICsgICAgICAgICAgICAgICBpZiAocmV0
KQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ID4gKyAgICAgICB9
DQo+ID4gKw0KPiA+ICsgICAgICAgcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRp
YyBpbnQgc3RtMzJfY3JjX2ZpbmFsKHN0cnVjdCBzaGFzaF9kZXNjICpkZXNjLCB1OCAqb3V0KSAg
ew0KPiA+ICAgICAgICAgc3RydWN0IHN0bTMyX2NyY19kZXNjX2N0eCAqY3R4ID0gc2hhc2hfZGVz
Y19jdHgoZGVzYyk7IEBADQo+ID4gLTMwMCw2ICszNDEsOCBAQCBzdGF0aWMgaW50IHN0bTMyX2Ny
Y19wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiA+ICAgICAgICAgcG1fcnVu
dGltZV9pcnFfc2FmZShkZXYpOw0KPiA+ICAgICAgICAgcG1fcnVudGltZV9lbmFibGUoZGV2KTsN
Cj4gPg0KPiA+ICsgICAgICAgc3Bpbl9sb2NrX2luaXQoJmNyYy0+bG9jayk7DQo+ID4gKw0KPiA+
ICAgICAgICAgcGxhdGZvcm1fc2V0X2RydmRhdGEocGRldiwgY3JjKTsNCj4gPg0KPiA+ICAgICAg
ICAgc3Bpbl9sb2NrKCZjcmNfbGlzdC5sb2NrKTsNCj4gPiAtLQ0KPiA+IDIuMTcuMQ0KPiA+DQo=
