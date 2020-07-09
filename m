Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B68C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 274752074B
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgGIMOZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 08:14:25 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2635 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbgGIMOZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 08:14:25 -0400
Received: from dggemi405-hub.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id E4763ECEA0ED564B8AD5;
        Thu,  9 Jul 2020 20:14:19 +0800 (CST)
Received: from DGGEMI525-MBS.china.huawei.com ([169.254.6.177]) by
 dggemi405-hub.china.huawei.com ([10.3.17.143]) with mapi id 14.03.0487.000;
 Thu, 9 Jul 2020 20:14:09 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        "Colin Ian King" <colin.king@canonical.com>
Subject: RE: [PATCH v4] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Thread-Topic: [PATCH v4] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Thread-Index: AQHWVF24fP2q5El5/U63jMMAkQc326j9QfAAgADy42CAAB5FAIAAvkpA
Date:   Thu, 9 Jul 2020 12:14:08 +0000
Message-ID: <B926444035E5E2439431908E3842AFD25623E4@DGGEMI525-MBS.china.huawei.com>
References: <20200707125210.33256-1-song.bao.hua@hisilicon.com>
 <20200708145934.4w3qk53mgavyyln7@linutronix.de>
 <B926444035E5E2439431908E3842AFD2560DE6@DGGEMI525-MBS.china.huawei.com>
 <20200709071714.32m7hatmkr4pk2f4@linutronix.de>
In-Reply-To: <20200709071714.32m7hatmkr4pk2f4@linutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.202.83]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtY3J5cHRvLW93
bmVyQHZnZXIua2VybmVsLm9yZw0KPiBbbWFpbHRvOmxpbnV4LWNyeXB0by1vd25lckB2Z2VyLmtl
cm5lbC5vcmddIE9uIEJlaGFsZiBPZiBTZWJhc3RpYW4gQW5kcnplag0KPiBTaWV3aW9yDQo+IFNl
bnQ6IFRodXJzZGF5LCBKdWx5IDksIDIwMjAgNzoxNyBQTQ0KPiBUbzogU29uZyBCYW8gSHVhIChC
YXJyeSBTb25nKSA8c29uZy5iYW8uaHVhQGhpc2lsaWNvbi5jb20+DQo+IENjOiBha3BtQGxpbnV4
LWZvdW5kYXRpb24ub3JnOyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7DQo+IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNr
Lm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgTGludXhhcm0gPGxpbnV4YXJt
QGh1YXdlaS5jb20+OyBMdWlzIENsYXVkaW8NCj4gUiAuIEdvbmNhbHZlcyA8bGdvbmNhbHZAcmVk
aGF0LmNvbT47IE1haGlwYWwgQ2hhbGxhDQo+IDxtYWhpcGFscmVkZHkyMDA2QGdtYWlsLmNvbT47
IFNldGggSmVubmluZ3MgPHNqZW5uaW5nQHJlZGhhdC5jb20+Ow0KPiBEYW4gU3RyZWV0bWFuIDxk
ZHN0cmVldEBpZWVlLm9yZz47IFZpdGFseSBXb29sDQo+IDx2aXRhbHkud29vbEBrb25zdWxrby5j
b20+OyBXYW5nemhvdSAoQikgPHdhbmd6aG91MUBoaXNpbGljb24uY29tPjsNCj4gQ29saW4gSWFu
IEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2
NF0gbW0venN3YXA6IG1vdmUgdG8gdXNlIGNyeXB0b19hY29tcCBBUEkgZm9yDQo+IGhhcmR3YXJl
IGFjY2VsZXJhdGlvbg0KPiANCj4gT24gMjAyMC0wNy0wOCAyMTo0NTo0NyBbKzAwMDBdLCBTb25n
IEJhbyBIdWEgKEJhcnJ5IFNvbmcpIHdyb3RlOg0KPiA+ID4gT24gMjAyMC0wNy0wOCAwMDo1Mjox
MCBbKzEyMDBdLCBCYXJyeSBTb25nIHdyb3RlOg0KPiA+ID4gPiBAQCAtMTI3LDkgKzEyOSwxNyBA
QA0KPiA+ID4gPiArc3RydWN0IGNyeXB0b19hY29tcF9jdHggew0KPiA+ID4gPiArCXN0cnVjdCBj
cnlwdG9fYWNvbXAgKmFjb21wOw0KPiA+ID4gPiArCXN0cnVjdCBhY29tcF9yZXEgKnJlcTsNCj4g
PiA+ID4gKwlzdHJ1Y3QgY3J5cHRvX3dhaXQgd2FpdDsNCj4gPiA+ID4gKwl1OCAqZHN0bWVtOw0K
PiA+ID4gPiArCXN0cnVjdCBtdXRleCBtdXRleDsNCj4gPiA+ID4gK307DQo+ID4gPiDigKYNCj4g
PiA+ID4gQEAgLTEwNzQsMTIgKzExMzgsMzIgQEAgc3RhdGljIGludCB6c3dhcF9mcm9udHN3YXBf
c3RvcmUodW5zaWduZWQNCj4gPiA+IHR5cGUsIHBnb2ZmX3Qgb2Zmc2V0LA0KPiA+ID4gPiAgCX0N
Cj4gPiA+ID4NCj4gPiA+ID4gIAkvKiBjb21wcmVzcyAqLw0KPiA+ID4gPiAtCWRzdCA9IGdldF9j
cHVfdmFyKHpzd2FwX2RzdG1lbSk7DQo+ID4gPiA+IC0JdGZtID0gKmdldF9jcHVfcHRyKGVudHJ5
LT5wb29sLT50Zm0pOw0KPiA+ID4gPiAtCXNyYyA9IGttYXBfYXRvbWljKHBhZ2UpOw0KPiA+ID4g
PiAtCXJldCA9IGNyeXB0b19jb21wX2NvbXByZXNzKHRmbSwgc3JjLCBQQUdFX1NJWkUsIGRzdCwg
JmRsZW4pOw0KPiA+ID4gPiAtCWt1bm1hcF9hdG9taWMoc3JjKTsNCj4gPiA+ID4gLQlwdXRfY3B1
X3B0cihlbnRyeS0+cG9vbC0+dGZtKTsNCj4gPiA+ID4gKwlhY29tcF9jdHggPSAqdGhpc19jcHVf
cHRyKGVudHJ5LT5wb29sLT5hY29tcF9jdHgpOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsJbXV0ZXhf
bG9jaygmYWNvbXBfY3R4LT5tdXRleCk7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlzcmMgPSBrbWFw
KHBhZ2UpOw0KPiA+ID4gPiArCWRzdCA9IGFjb21wX2N0eC0+ZHN0bWVtOw0KPiA+ID4NCj4gPiA+
IHRoYXQgbXV0ZXggaXMgcGVyLUNQVSwgcGVyLWNvbnRleHQuIFRoZSBkc3RtZW0gcG9pbnRlciBp
cyBwZXItQ1BVLg0KPiA+ID4gU28gaWYgSSByZWFkIHRoaXMgcmlnaHQsIHlvdSBjYW4gZ2V0IHBy
ZWVtcHRlZCBhZnRlcg0KPiA+ID4gY3J5cHRvX3dhaXRfcmVxKCkgYW5kIGFub3RoZXIgY29udGV4
dCBpbiB0aGlzIENQVSB3cml0ZXMgaXRzIGRhdGEgdG8NCj4gPiA+IHRoZSBzYW1lIGRzdG1lbSBh
bmQgdGhlbuKApg0KPiA+ID4NCj4gPg0KPiA+IFRoaXMgaXNuJ3QgdHJ1ZS4gQW5vdGhlciB0aHJl
YWQgaW4gdGhpcyBjcHUgd2lsbCBiZSBibG9ja2VkIGJ5IHRoZSBtdXRleC4NCj4gPiBJdCBpcyBp
bXBvc3NpYmxlIGZvciB0d28gdGhyZWFkcyB0byB3cml0ZSB0aGUgc2FtZSBkc3RtZW0uDQo+ID4g
SWYgdGhyZWFkMSByYW4gb24gY3B1MSwgaXQgaGVsZCBjcHUxJ3MgbXV0ZXg7IGlmIGFub3RoZXIg
dGhyZWFkIHdhbnRzIHRvIHJ1bg0KPiBvbiBjcHUxLCBpdCBpcyBibG9ja2VkLg0KPiA+IElmIHRo
cmVhZDEgcmFuIG9uIGNwdTEgZmlyc3QsIGl0IGhlbGQgY3B1MSdzIG11dGV4LCB0aGVuIGl0IG1p
Z3JhdGVkIHRvIGNwdTINCj4gKHdpdGggdmVyeSByYXJlIGNoYW5jZSkNCj4gPiAJYS4gaWYgYW5v
dGhlciB0aHJlYWQgd2FudHMgdG8gcnVuIG9uIGNwdTEsIGl0IGlzIGJsb2NrZWQ7DQo+IA0KPiBI
b3cgaXQgaXMgYmxvY2tlZD8gVGhhdCAic3RydWN0IGNyeXB0b19hY29tcF9jdHgiIGlzDQo+ICJ0
aGlzX2NwdV9wdHIoZW50cnktPnBvb2wtPmFjb21wX2N0eCkiIC0gd2hpY2ggaXMgcGVyLUNQVSBv
ZiBhIHBvb2wgd2hpY2gNCj4geW91IGNhbiBoYXZlIG11bHRpcGxlIG9mLiBCdXQgYGRzdG1lbScg
eW91IGhhdmUgb25seSBvbmUgcGVyLUNQVSBubyBtYXR0ZXINCj4gaGF2ZSBtYW55IHBvb2xzIHlv
dSBoYXZlLg0KPiBTbyBwb29sMSBvbiBDUFUxIHVzZXMgdGhlIHNhbWUgYGRzdG1lbScgYXMgcG9v
bDIgb24gQ1BVMS4gQnV0IHBvb2wxIGFuZA0KPiBwb29sMiBvbiBDUFUxIHVzZSBhIGRpZmZlcmVu
dCBtdXRleCBmb3IgcHJvdGVjdGlvbiBvZiB0aGlzIGBkc3RtZW0nLg0KDQpHb29kIGNhdGNoLCBT
ZWJhc3RpYW4sIHRoYW5rcyENCnRoaXMgaXMgYSBjb3JuZXIgY2FzZSB0ZXN0aW5nIGhhcyBub3Qg
ZW5jb3VudGVyZWQgeWV0LiBUaGVyZSBpcyBhIHJhY2UgaWYgd2UgY2hhbmdlIHRoZSBwb29sIHR5
cGUgYXQgcnVudGltZS4NClR5cGljYWxseSwgYSBncm91cCBvZiBpbml0aWFsIHBhcmFtZXRlcnMg
d2VyZSBzZXQsIHRoZW4gc29mdHdhcmUgd3JvdGUvcmVhZCBsb3RzIG9mIGFub24gcGFnZXMgdG8g
Z2VuZXJhdGUNCnN3YXBwaW5nIGFzIGJ1c3kgYXMgcG9zc2libGUuIEJ1dCBuZXZlciB0cmllZCB0
byBjaGFuZ2UgdGhlIGNvbXByZXNzb3IvcG9vbCB0eXBlIGF0IHJ1bnRpbWUuDQoNCndpbGwgYWRk
cmVzcyB0aGlzIHByb2JsZW0gaW4gdjUgd2l0aCB0aGUgY2xlYW51cCBvZiBhY29tcF9jdHggcG9p
bnRlciBpbiB6c3dhcF9wb29sLiBJIG1lYW4gdG8NCmNyZWF0ZSBhY29tcCBpbnN0YW50cyBmb3Ig
cGVyLWNwdSwgbm90IGZvciAocG9vbHMgKiBwZXItY3B1KS4NCg0KVGhhbmtzDQpCYXJyeQ0K
