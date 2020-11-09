Return-Path: <SRS0=FTK2=EP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D0DC2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 11:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7135B206ED
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 11:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgKILqK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Nov 2020 06:46:10 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2303 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgKILqK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Nov 2020 06:46:10 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4CV8ML54sQz13QwC;
        Mon,  9 Nov 2020 19:45:50 +0800 (CST)
Received: from dggemi712-chm.china.huawei.com (10.3.20.111) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 9 Nov 2020 19:46:05 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi712-chm.china.huawei.com (10.3.20.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 9 Nov 2020 19:46:04 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.1913.007;
 Mon, 9 Nov 2020 19:46:04 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linuxarm <linuxarm@huawei.com>,
        "fanghao (A)" <fanghao11@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Wool <vitalywool@gmail.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: RE: [PATCH v7] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Thread-Topic: [PATCH v7] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Thread-Index: AQHWtNNH87FlqW4qs0KvSuGaGT58KKm/Fo6AgACQEbA=
Date:   Mon, 9 Nov 2020 11:46:04 +0000
Message-ID: <017c57cee12f4492977425fab7121ad1@hisilicon.com>
References: <20201107065332.26992-1-song.bao.hua@hisilicon.com>
 <20201109102909.u34zzudqqng6nhg6@linutronix.de>
In-Reply-To: <20201109102909.u34zzudqqng6nhg6@linutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.203.196]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYmFzdGlhbiBBbmRyemVq
IFNpZXdpb3IgW21haWx0bzpiaWdlYXN5QGxpbnV0cm9uaXguZGVdDQo+IFNlbnQ6IE1vbmRheSwg
Tm92ZW1iZXIgOSwgMjAyMCAxMToyOSBQTQ0KPiBUbzogU29uZyBCYW8gSHVhIChCYXJyeSBTb25n
KSA8c29uZy5iYW8uaHVhQGhpc2lsaWNvbi5jb20+DQo+IENjOiBsaW51eC1tbUBrdmFjay5vcmc7
IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7DQo+IGFrcG1AbGludXgtZm91bmRhdGlvbi5v
cmc7IExpbnV4YXJtIDxsaW51eGFybUBodWF3ZWkuY29tPjsgZmFuZ2hhbyAoQSkNCj4gPGZhbmdo
YW8xMUBodWF3ZWkuY29tPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgVml0YWx5IFdv
b2wNCj4gPHZpdGFseXdvb2xAZ21haWwuY29tPjsgTHVpcyBDbGF1ZGlvIFIgLiBHb25jYWx2ZXMg
PGxnb25jYWx2QHJlZGhhdC5jb20+Ow0KPiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFu
YS5vcmcuYXU+OyBEYXZpZCBTIC4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgTWFo
aXBhbCBDaGFsbGEgPG1haGlwYWxyZWRkeTIwMDZAZ21haWwuY29tPjsNCj4gU2V0aCBKZW5uaW5n
cyA8c2plbm5pbmdAcmVkaGF0LmNvbT47IERhbiBTdHJlZXRtYW4gPGRkc3RyZWV0QGllZWUub3Jn
PjsNCj4gV2FuZ3pob3UgKEIpIDx3YW5nemhvdTFAaGlzaWxpY29uLmNvbT47IENvbGluIElhbiBL
aW5nDQo+IDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djddIG1tL3pzd2FwOiBtb3ZlIHRvIHVzZSBjcnlwdG9fYWNvbXAgQVBJIGZvcg0KPiBoYXJkd2Fy
ZSBhY2NlbGVyYXRpb24NCj4gDQo+IEkndmUgYmVlbiBsb29raW5nIGF0IHRoZSBwYXRjaCBhbmQg
aXQgbG9va3MgbGlrZSBpdCBzaG91bGQgd29yay4gSGF2aW5nIG51bWJlcnMNCg0KVGhhbmtzIHZl
cnkgbXVjaCBmb3IgcmV2aWV3aW5nIGl0IGFuZCB0aGUgcHJldmlvdXMgcGF0Y2hlcy4gSSBhcHBy
ZWNpYXRlLg0KDQo+IHRvIGJhY2t1cCB0aGUgcGVyZm9ybWFuY2UgaW4gdGhlIHB1cmUtc29mdHdh
cmUgdmVyc2lvbiBhbmQgd2l0aCBIVw0KPiBhY2NlbGVyYXRpb24gd291bGQgX3ZlcnlfIG5pY2Ug
dG8gaGF2ZS4NCg0KU3VyZS4gVGhlIDFzdCBzdGVwIGlzIGZpeGluZyB0aGUgYnJva2VuIGNvbm5l
Y3QgYmV0d2VlbiBuZXcgY3J5cHRvIEFQSXMgYW5kDQp6c3dhcC4gVGhlbiB3ZSBhcmUgZ29pbmcg
dG8gZGlnIGludG8gcG9zc2libGUgcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnRzLg0KSWYgd2UgcHV0
IGFsbCB0aGUgZ29hbHMgaW4gdGhlIHNpbmdsZSBmaXJzdCBzdGVwLCBpdCB3aWxsIGJlIGhhcmQg
Zm9yIHVzIHRvIHNlZSBhbg0KYWNjb21wbGlzaG1lbnQgb2YgYW55IHJlYWwgaW1wcm92ZW1lbnQu
DQoNCj4gDQo+IE9uIDIwMjAtMTEtMDcgMTk6NTM6MzIgWysxMzAwXSwgQmFycnkgU29uZyB3cm90
ZToNCj4gPiBpbmRleCBmYmI3ODI5Li43M2YwNGRlIDEwMDY0NA0KPiA+IC0tLSBhL21tL3pzd2Fw
LmMNCj4gPiArKysgYi9tbS96c3dhcC5jDQo+ID4gQEAgLTQxNSwzMCArNDQ1LDU0IEBAIHN0YXRp
YyBpbnQgenN3YXBfZHN0bWVtX2RlYWQodW5zaWduZWQgaW50IGNwdSkNCj4g4oCmDQo+ID4gKwlh
Y29tcF9jdHgtPnJlcSA9IHJlcTsNCj4gPiArDQo+ID4gKwljcnlwdG9faW5pdF93YWl0KCZhY29t
cF9jdHgtPndhaXQpOw0KPiA+ICsJLyoNCj4gPiArCSAqIGlmIHRoZSBiYWNrZW5kIG9mIGFjb21w
IGlzIGFzeW5jIHppcCwgY3J5cHRvX3JlcV9kb25lKCkgd2lsbCB3YWtldXANCj4gPiArCSAqIGNy
eXB0b193YWl0X3JlcSgpOyBpZiB0aGUgYmFja2VuZCBvZiBhY29tcCBpcyBzY29tcCwgdGhlIGNh
bGxiYWNrDQo+ID4gKwkgKiB3b24ndCBiZSBjYWxsZWQsIGNyeXB0b193YWl0X3JlcSgpIHdpbGwg
cmV0dXJuIHdpdGhvdXQgYmxvY2tpbmcuDQo+ID4gKwkgKi8NCj4gPiArCWFjb21wX3JlcXVlc3Rf
c2V0X2NhbGxiYWNrKHJlcSwgQ1JZUFRPX1RGTV9SRVFfTUFZX0JBQ0tMT0csDQo+ID4gKwkJCQkg
ICBjcnlwdG9fcmVxX2RvbmUsICZhY29tcF9jdHgtPndhaXQpOw0KPiA+ICsNCj4gPiArCWFjb21w
X2N0eC0+bXV0ZXggPSBwZXJfY3B1KHpzd2FwX211dGV4LCBjcHUpOw0KPiA+ICsJYWNvbXBfY3R4
LT5kc3RtZW0gPSBwZXJfY3B1KHpzd2FwX2RzdG1lbSwgY3B1KTsNCj4gDQo+IFlvdSBhZGRlZCBh
IGNvbW1lbnQgaGVyZSBhbmQgdGhlcmUgeW91IG5ldmVyIG1lbnRpb25lZCB0aGF0IHRoaXMgc2lu
Z2xlDQo+IHBlci1DUFUgbXV0ZXggcHJvdGVjdHMgdGhlIHBlci1DUFUgY29udGV4dCAod2hpY2gg
eW91IGNhbiBoYXZlIG1vcmUgdGhhbg0KPiBvbmUgb24gYSBzaW5nbGUgQ1BVKSBhbmQgdGhlIHNj
cmF0Y2gvZHN0bWVtIHdoaWNoIGlzIG9uZSBwZXItQ1BVLiBPZiBjb3Vyc2UNCj4gaWYgeW91IHJl
YWQgdGhlIGNvZGUgeW91IGZpZ3VyZSBpdCBvdXQuDQo+IEkgc3RpbGwgdGhpbmsgdGhhdCB5b3Ug
c2hvdWxkIGhhdmUgYSBwb29sIG9mIG1lbW9yeSBhbmQgY3J5cHRvIGNvbnRleHRzIHdoaWNoDQo+
IHlvdSBjYW4gdXNlIGluc3RlYWQgb2YgaGF2aW5nIHRoZW0gc3RyaWN0bHkgcGVyLUNQVS4gVGhl
IGNvZGUgaXMgZnVsbHkNCj4gcHJlZW1wdGlibGUgYW5kIHlvdSBtYXkgaGF2ZSBtdWx0aXBsZSBy
ZXF1ZXN0cyBvbiB0aGUgc2FtZSBDUFUuDQo+IFllcywgbG9ja2luZyB3b3JrcyBidXQgYXQgdGhl
IHNhbWUgeW91IGJsb2NrIHByb2Nlc3Npbmcgd2hpbGUgd2FpdGluZyBvbiBhIGxvY2sNCj4gYW5k
IHRoZSAicmVzZXJ2ZWQgbWVtb3J5IiBvbiBvdGhlciBDUFVzIHJlbWFpbnMgdW51c2VkLg0KDQpG
b3Igc3VyZSB0aGUgYnVmZmVyIHBvb2wgd2lsbCBiZSBwdXQgaW50byBteSBUb2RvIGxpc3Qgb24g
enN3YXAgcHJvamVjdC4gRm9yIHRoaXMNCm1vbWVudCwgbGV0J3MgZml4IHRoZSBicm9rZW4gY29u
bmVjdGlvbiBiZXR3ZWVuIFpJUCBkcml2ZXJzIGFuZCB6c3dhcCBmaXJzdC4NClRoaXMgd2lsbCBo
ZWxwIGJ1aWxkIHRoZSBmYWl0aCBvbiB0aGUgd2hvbGUgcHJvamVjdCBhbmQgbW90aXZhdGUgdGhl
IG1vdmUgdG8NCnRoZSBuZXh0IHN0ZXAuDQoNClN0ZXAgYnkgc3RlcCwgd2Ugd2lsbCBtYWtlIHpz
d2FwIGJldHRlciBhbmQgYmV0dGVyIG9uIHBlcmZvcm1hbmNlIGJ5IGxldmVyYWdpbmcNCnRoZSBw
b3dlciBvZiBaSVAgaGFyZHdhcmUuDQoNCj4gDQo+IFNlYmFzdGlhbg0KDQpUaGFua3MNCkJhcnJ5
DQo=
