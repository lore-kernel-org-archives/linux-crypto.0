Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE4DC433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 11:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 808D520787
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 11:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="Kd6js+c0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390164AbgEYLuI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 07:50:08 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:27622 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388697AbgEYLuH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 07:50:07 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04PBm2dF023009;
        Mon, 25 May 2020 13:49:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=ZLPJbD1i52pQmhWGud8u9OF5Yeh//Hrj8jaTYYs9M5U=;
 b=Kd6js+c0GtO9/IEl9vzto9Y8GRXycY27HMPexBUqs+VTSoehYyl+sjHlU1lrl+GElZLK
 WE1Mf3lI5suTEZKRtnv0a7knaBYa0SZV/1V7COQiI79ue5zX9MJV9R9hY7bG4lPmqM8H
 MxNc+UaPLdg46wE59rALpCUX+roPIerHdStpPpIEZ09pb6nAILTuKJx11U2HmUkgdIoM
 oGShsqDs2T/76Ka0CzY1lxjCYs9QHlUHEw2WAeb+EIiUXNIEmDB963Kt8ZIE6bQ/u4/H
 g4n1zaNdojeeyXLwkYpwvxqDpcnMBl67VJSxXZUAKispXLGsUKRRV4oqsf0Rvui4+k42 xQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 316rya26p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 May 2020 13:49:38 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 10CAF10002A;
        Mon, 25 May 2020 13:49:37 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node1.st.com [10.75.127.7])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id BB6C121E681;
        Mon, 25 May 2020 13:49:37 +0200 (CEST)
Received: from SFHDAG6NODE1.st.com (10.75.127.16) by SFHDAG3NODE1.st.com
 (10.75.127.7) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 May
 2020 13:49:37 +0200
Received: from SFHDAG6NODE1.st.com ([fe80::8d96:4406:44e3:eb27]) by
 SFHDAG6NODE1.st.com ([fe80::8d96:4406:44e3:eb27%20]) with mapi id
 15.00.1473.003; Mon, 25 May 2020 13:49:37 +0200
From:   Nicolas TOROMANOFF <nicolas.toromanoff@st.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
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
Thread-Index: AQHWMnPoC6hseRPByUqqkn4smN/k96i4hBOA
Date:   Mon, 25 May 2020 11:49:37 +0000
Message-ID: <31e99726fa6544fcaac88490de3186e6@SFHDAG6NODE1.st.com>
References: <20200512141113.18972-1-nicolas.toromanoff@st.com>
 <20200512141113.18972-6-nicolas.toromanoff@st.com>
 <CAMj1kXGs6UgkKb5+tH2B-+26=tbjHq3UUY2gxfcRfMb1nGVuFA@mail.gmail.com>
 <67c25d90d9714a85b52f3d9c2070af88@SFHDAG6NODE1.st.com>
 <CAMj1kXGo+9aXeYppGSheqhC-pNeJCcEie+SAnWy_sAiooEDMsQ@mail.gmail.com>
 <bd6cac3bd4c74db1a403df58082028fd@SFHDAG6NODE1.st.com>
 <CAMj1kXFwt6cs-MJhAeMRF4-yiddm=ezq=qvSjA_sRAX+_Gdqhw@mail.gmail.com>
In-Reply-To: <CAMj1kXFwt6cs-MJhAeMRF4-yiddm=ezq=qvSjA_sRAX+_Gdqhw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.44]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-25_07:2020-05-25,2020-05-25 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
YkBrZXJuZWwub3JnPg0KPiBTZW50OiBNb25kYXksIE1heSAyNSwgMjAyMCAxMTowNyBBTQ0KPiBU
bzogTmljb2xhcyBUT1JPTUFOT0ZGIDxuaWNvbGFzLnRvcm9tYW5vZmZAc3QuY29tPjsgRXJpYyBC
aWdnZXJzDQo+IDxlYmlnZ2Vyc0BrZXJuZWwub3JnPg0KPiBPbiBNb24sIDI1IE1heSAyMDIwIGF0
IDExOjAxLCBOaWNvbGFzIFRPUk9NQU5PRkYNCj4gPG5pY29sYXMudG9yb21hbm9mZkBzdC5jb20+
IHdyb3RlOg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJv
bTogQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz4NCj4gPiA+IFNlbnQ6IE1vbmRheSwg
TWF5IDI1LCAyMDIwIDk6NDYgQU0NCj4gPiA+IFRvOiBOaWNvbGFzIFRPUk9NQU5PRkYgPG5pY29s
YXMudG9yb21hbm9mZkBzdC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIDUvNV0gY3J5
cHRvOiBzdG0zMi9jcmM6IHByb3RlY3QgZnJvbSBjb25jdXJyZW50DQo+ID4gPiBhY2Nlc3Nlcw0K
PiA+ID4NCj4gPiA+IE9uIE1vbiwgMjUgTWF5IDIwMjAgYXQgMDk6MjQsIE5pY29sYXMgVE9ST01B
Tk9GRg0KPiA+ID4gPG5pY29sYXMudG9yb21hbm9mZkBzdC5jb20+IHdyb3RlOg0KPiA+ID4gPg0K
PiA+ID4gPiBIZWxsbywNCj4gPiA+ID4NCj4gPiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+ID4gPiA+IEZyb206IEFyZCBCaWVzaGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+DQo+
ID4gPiA+ID4gU2VudDogRnJpZGF5LCBNYXkgMjIsIDIwMjAgNjoxMiBQTT4gT24gVHVlLCAxMiBN
YXkgMjAyMCBhdA0KPiA+ID4gPiA+IDE2OjEzLCBOaWNvbGFzIFRvcm9tYW5vZmYgPG5pY29sYXMu
dG9yb21hbm9mZkBzdC5jb20+IHdyb3RlOg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFByb3Rl
Y3QgU1RNMzIgQ1JDIGRldmljZSBmcm9tIGNvbmN1cnJlbnQgYWNjZXNzZXMuDQo+ID4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gQXMgd2UgY3JlYXRlIGEgc3BpbmxvY2tlZCBzZWN0aW9uIHRoYXQgaW5j
cmVhc2Ugd2l0aCBidWZmZXINCj4gPiA+ID4gPiA+IHNpemUsIHdlIHByb3ZpZGUgYSBtb2R1bGUg
cGFyYW1ldGVyIHRvIHJlbGVhc2UgdGhlIHByZXNzdXJlIGJ5DQo+ID4gPiA+ID4gPiBzcGxpdHRp
bmcgY3JpdGljYWwgc2VjdGlvbiBpbiBjaHVua3MuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4g
U2l6ZSBvZiBlYWNoIGNodW5rIGlzIGRlZmluZWQgaW4gYnVyc3Rfc2l6ZSBtb2R1bGUgcGFyYW1l
dGVyLg0KPiA+ID4gPiA+ID4gQnkgZGVmYXVsdCBidXJzdF9zaXplPTAsIGkuZS4gZG9uJ3Qgc3Bs
aXQgaW5jb21pbmcgYnVmZmVyLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFNpZ25lZC1vZmYt
Ynk6IE5pY29sYXMgVG9yb21hbm9mZiA8bmljb2xhcy50b3JvbWFub2ZmQHN0LmNvbT4NCj4gPiA+
ID4gPg0KPiA+ID4gPiA+IFdvdWxkIHlvdSBtaW5kIGV4cGxhaW5pbmcgdGhlIHVzYWdlIG1vZGVs
IGhlcmU/IEl0IGxvb2tzIGxpa2UNCj4gPiA+ID4gPiB5b3UgYXJlIHNoYXJpbmcgYSBDUkMgaGFy
ZHdhcmUgYWNjZWxlcmF0b3Igd2l0aCBhIHN5bmNocm9ub3VzDQo+ID4gPiA+ID4gaW50ZXJmYWNl
IGJldHdlZW4gZGlmZmVyZW50IHVzZXJzIGJ5IHVzaW5nIHNwaW5sb2Nrcz8gWW91IGFyZQ0KPiA+
ID4gPiA+IGF3YXJlIHRoYXQgdGhpcyB3aWxsIHRpZSB1cCB0aGUgd2FpdGluZyBDUFVzIGNvbXBs
ZXRlbHkgZHVyaW5nDQo+ID4gPiA+ID4gdGhpcyB0aW1lLCByaWdodD8gU28gaXQgd291bGQgYmUg
bXVjaCBiZXR0ZXIgdG8gdXNlIGEgbXV0ZXgNCj4gPiA+ID4gPiBoZXJlLiBPciBwZXJoYXBzIGl0
IHdvdWxkIG1ha2UgbW9yZSBzZW5zZSB0byBmYWxsIGJhY2sgdG8gYSBzL3cNCj4gPiA+ID4gPiBi
YXNlZCBDUkMgcm91dGluZSBpZiB0aGUgaC93IGlzIHRpZWQgdXANCj4gPiA+IHdvcmtpbmcgZm9y
IGFub3RoZXIgdGFzaz8NCj4gPiA+ID4NCj4gPiA+ID4gSSBrbm93IG11dGV4IGFyZSBtb3JlIGFj
Y2VwdGFibGUgaGVyZSwgYnV0IHNoYXNoIF91cGRhdGUoKSBhbmQNCj4gPiA+ID4gX2luaXQoKSBt
YXkgYmUgY2FsbCBmcm9tIGFueSBjb250ZXh0LCBhbmQgc28gSSBjYW5ub3QgdGFrZSBhIG11dGV4
Lg0KPiA+ID4gPiBBbmQgdG8gcHJvdGVjdCBteSBjb25jdXJyZW50IEhXIGFjY2VzcyBJIG9ubHkg
dGhvdWdoIGFib3V0IHNwaW5sb2NrLg0KPiA+ID4gPiBEdWUgdG8gcG9zc2libGUgY29uc3RyYWlu
dCBvbiBDUFVzLCBJIGFkZCBhIGJ1cnN0X3NpemUgb3B0aW9uIHRvDQo+ID4gPiA+IGZvcmNlIHNs
aXR0aW5nIGxvbmcgYnVmZmVyIGludG8gc21hbGxlciBvbmUsIGFuZCBzbyBkZWNyZWFzZSB0aW1l
IHdlIHRha2UNCj4gdGhlIGxvY2suDQo+ID4gPiA+IEJ1dCBJIGRpZG4ndCB0aG91Z2ggdG8gZmFs
bGJhY2sgdG8gc29mdHdhcmUgQ1JDLg0KPiA+ID4gPg0KPiA+ID4gPiBJJ2xsIGRvIGEgcGF0Y2gg
b24gdG9wLg0KPiA+ID4gPiBJbiBpbiB0aGUgYnVyc3RfdXBkYXRlKCkgZnVuY3Rpb24gSSdsbCB1
c2UgYQ0KPiA+ID4gPiBzcGluX3RyeWxvY2tfaXJxc2F2ZSgpIGFuZCB1c2UNCj4gPiA+IHNvZnR3
YXJlIENSQzMyIGlmIEhXIGlzIGFscmVhZHkgaW4gdXNlLg0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+
IFJpZ2h0LiBJIGRpZG4ndCBldmVuIG5vdGljZSB0aGF0IHlvdSB3ZXJlIGtlZXBpbmcgaW50ZXJy
dXB0cw0KPiA+ID4gZGlzYWJsZWQgdGhlIHdob2xlIHRpbWUgd2hlbiB1c2luZyB0aGUgaC93IGJs
b2NrLiBUaGF0IG1lYW5zIHRoYXQNCj4gPiA+IGFueSBzZXJpb3VzIHVzZSBvZiB0aGlzIGgvdyBi
bG9jayB3aWxsIG1ha2UgSVJRIGxhdGVuY3kgZ28gdGhyb3VnaCB0aGUgcm9vZi4NCj4gPiA+DQo+
ID4gPiBJIHJlY29tbWVuZCB0aGF0IHlvdSBnbyBiYWNrIHRvIHRoZSBkcmF3aW5nIGJvYXJkIG9u
IHRoaXMgZHJpdmVyLA0KPiA+ID4gcmF0aGVyIHRoYW4gcGFwZXJpbmcgb3ZlciB0aGUgaXNzdWVz
IHdpdGggYSBzcGluX3RyeWxvY2soKS4gUGVyaGFwcw0KPiA+ID4gaXQgd291bGQgYmUgYmV0dGVy
IHRvIG1vZGVsIGl0IGFzIGEgYWhhc2ggKGV2ZW4gdGhvdWdoIHRoZSBoL3cgYmxvY2sNCj4gPiA+
IGl0c2VsZiBpcyBzeW5jaHJvbm91cykgYW5kIHVzZSBhIGt0aHJlYWQgdG8gZmVlZCBpbiB0aGUg
ZGF0YS4NCj4gPg0KPiA+IEkgdGhvdWdodCB3aGVuIEkgdXBkYXRlZCB0aGUgZHJpdmVyIHRvIG1v
dmUgdG8gYSBhaGFzaCBpbnRlcmZhY2UsIGJ1dA0KPiA+IHRoZSBtYWluIHVzYWdlIG9mIGNyYzMy
IGlzIHRoZSBleHQ0IGZzLCB0aGF0IGNhbGxzIHRoZSBzaGFzaCBBUEkuDQo+ID4gQ29tbWl0IDg3
N2I1NjkxZjI3YSAoImNyeXB0bzogc2hhc2ggLSByZW1vdmUgc2hhc2hfZGVzYzo6ZmxhZ3MiKQ0K
PiA+IHJlbW92ZWQgcG9zc2liaWxpdHkgdG8gc2xlZXAgaW4gc2hhc2ggY2FsbGJhY2suIChiZWZv
cmUgdGhpcyBjb21taXQNCj4gPiBhbmQgd2l0aCBNQVlfU0xFRVAgb3B0aW9uIHNldCwgdXNpbmcg
YSBtdXRleCBtYXkgaGF2ZSBiZWVuIGZpbmUpLg0KPiA+DQo+IA0KPiBBY2NvcmRpbmcgdG8gdGhh
dCBjb21taXQncyBsb2csIHNsZWVwaW5nIGlzIG5ldmVyIGZpbmUgZm9yIHNoYXNoKCksIHNpbmNl
IGl0IHVzZXMNCj4ga21hcF9hdG9taWMoKSB3aGVuIGl0ZXJhdGluZyBvdmVyIHRoZSBzY2F0dGVy
bGlzdC4NCg0KVG9kYXksIHdlIGNvdWxkIGF2b2lkIHVzaW5nIGttYXBfYXRvbWljKCkgaW4gc2hh
c2hfYXNoYXNoXyooKSBBUElzICh0aGUNCm9uZXMgdGhhdCBXYWxrcyB0aHJvdWdoIHRoZSBzY2F0
dGVybGlzdCkgYnkgdXNpbmcgdGhlDQpjcnlwdG9fYWhhc2hfd2Fsa19maXJzdCgpIGZ1bmN0aW9u
IHRvIGluaXRpYWxpemUgdGhlIHNoYXNoX2FoYXNoIHdhbGtlcg0KKG5vdGUgdGhhdCB0aGlzIGZ1
bmN0aW9uIGlzIG5ldmVyIGNhbGwgaW4gY3VycmVudCBrZXJuZWwgc291cmNlIFt0byByZW1vdmUg
P10pLg0KVGhlbiBzaGFzaF9haGFzaF8qKCkgZnVuY3Rpb25zIHdpbGwgY2FsbCBhaGFzaF8qKCkg
ZnVuY3Rpb24gdGhhdCB1c2Uga21hcCgpDQppZiAod2Fsay0+ZmxhZ3MgJiBDUllQVE9fQUxHX0FT
WU5DKSBbZmxhZyBzZXQgYnkgY3J5cHRvX2FoYXNoX3dhbGtfZmlyc3QoKV0NClRoZSBsYXN0IGtt
YXBfYXRvbWljKCkgd2lsbCBiZSBpbiB0aGUgc2hhc2hfYWhhc2hfZGlnZXN0KCkgY2FsbCBpbiB0
aGUNCm9wdGltaXplIGJyYW5jaCAodGhhdCBzaG91bGQgYmUgcmVwbGFjZWQgYnkgdGhlIG5vIGF0
b21pYyBvbmUpDQoNCkkgZGlkbid0IGludmVzdGlnYXRlIG1vcmUgdGhpcyB3YXksIGJlY2F1c2Ug
SSBkaWRuJ3QgY2hlY2sgdGhlIGRyYXdiYWNrIG9mDQp1c2luZyBrbWFwKCkgaW5zdGVhZCBvZiBr
bWFwX2F0b21pYygpLCBJIHdhbnRlZCB0byBhdm9pZCBtb2RpZnlpbmcgYmVoYXZpb3INCm9mIG90
aGVyIGRyaXZlcnMgYW5kIHVzaW5nIGEgZnVuY3Rpb24gbmV2ZXIgdXNlIGVsc2V3aGVyZSBpbiBr
ZXJuZWwgc2NhcnJlZA0KbWUgOy0pLg0KSWYgdGhlc2UgdXBkYXRlcyBjb3JyZWN0IHZpc2libGUg
YnVncyBpbiB0aGUgYWhhc2ggdXNhZ2Ugb2YgdGhlIHN0bTMyLWNyYzMyDQpjb2RlIFtubyBtb3Jl
ICJzbGVlcCB3aGlsZSBhdG9taWMiIHRyYWNlcyBldmVuIHdpdGggbXV0ZXggaW4gdGVzdHNdLCAN
CkRvY3VtZW50YXRpb24gc3RhdGVzIHRoYXQgc2hhc2ggQVBJIGNvdWxkIGJlIGNhbGxlZCBmcm9t
IGFueSBjb250ZXh0LA0KSSBjYW5ub3QgYWRkIG11dGV4IGluIHRoZW0uDQoNCj4gPiBCeSBub3cg
dGhlIHNvbHV0aW9uIEkgc2VlIGlzIHRvIHVzZSB0aGUgc3Bpbl90cnlsb2NrX2lycXNhdmUoKSwN
Cj4gPiBmYWxsYmFjayB0byBzb2Z0d2FyZSBjcmMgKkFORCogY2FwcGluZyBidXJzdF9zaXplIHRv
IGVuc3VyZSB0aGUgbG9ja2VkDQo+IHNlY3Rpb24gc3RheSByZWFzb25hYmxlLg0KPiA+DQo+ID4g
RG9lcyB0aGlzIHNlZW1zIGFjY2VwdGFibGUgPw0KPiA+DQo+IA0KPiBJZiB0aGUgcmVhc29uIGZv
ciBkaXNhYmxpbmcgaW50ZXJydXB0cyBpcyB0byBhdm9pZCBkZWFkbG9ja3MsIHdvdWxkbid0IHRo
ZSBzd2l0Y2gNCj4gdG8gdHJ5bG9jaygpIHdpdGggYSBzb2Z0d2FyZSBmYWxsYmFjayBhbGxvdyB1
cyB0byBrZWVwIGludGVycnVwdHMgZW5hYmxlZD8NCg0KUmlnaHQsIHdpdGggdGhlIHRyeWxvY2ss
IEkgZG9uJ3Qgc2VlIHdoeSB3ZSBtYXkgbmVlZCB0byBtYXNrIGludGVycnVwdHMuDQoNCg0K
