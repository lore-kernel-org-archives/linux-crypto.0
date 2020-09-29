Return-Path: <SRS0=8ohu=DG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 515CBC4727C
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 11:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C9D221E7
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 11:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgI2LGf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Sep 2020 07:06:35 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3564 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728299AbgI2LFQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Sep 2020 07:05:16 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 636CEFA2707949798961;
        Tue, 29 Sep 2020 19:05:10 +0800 (CST)
Received: from dggemi711-chm.china.huawei.com (10.3.20.110) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 29 Sep 2020 19:05:05 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi711-chm.china.huawei.com (10.3.20.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 29 Sep 2020 19:05:04 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.1913.007;
 Tue, 29 Sep 2020 19:05:05 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        "Dan Streetman" <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        "fanghao (A)" <fanghao11@huawei.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: RE: [PATCH v6] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Thread-Topic: [PATCH v6] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Thread-Index: AQHWlat2/tz4PWWjYEyGimM6I0lKCKl+fZuAgACGPED//9FBgIAAiB0w//+H/YCAAIqusA==
Date:   Tue, 29 Sep 2020 11:05:05 +0000
Message-ID: <2fe9a511f03c48c29a37ac1d6092410a@hisilicon.com>
References: <20200818123100.4140-1-song.bao.hua@hisilicon.com>
 <20200928152432.l3auscdx2suyli4u@linutronix.de>
 <76bb2b545117413eb0879abcf91cf0f0@hisilicon.com>
 <20200929093113.3cv63szruo3c4inu@linutronix.de>
 <5951148aef79459192826f405a6fa5aa@hisilicon.com>
 <20200929102851.3m5ardu2orfbhe3d@linutronix.de>
In-Reply-To: <20200929102851.3m5ardu2orfbhe3d@linutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.200.63]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2ViYXN0aWFuIEFuZHJ6
ZWogU2lld2lvciBbbWFpbHRvOmJpZ2Vhc3lAbGludXRyb25peC5kZV0NCj4gU2VudDogVHVlc2Rh
eSwgU2VwdGVtYmVyIDI5LCAyMDIwIDExOjI5IFBNDQo+IFRvOiBTb25nIEJhbyBIdWEgKEJhcnJ5
IFNvbmcpIDxzb25nLmJhby5odWFAaGlzaWxpY29uLmNvbT4NCj4gQ2M6IGFrcG1AbGludXgtZm91
bmRhdGlvbi5vcmc7IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsNCj4gZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3Jn
Ow0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBMdWlzIENsYXVkaW8gUiAuIEdvbmNh
bHZlcw0KPiA8bGdvbmNhbHZAcmVkaGF0LmNvbT47IE1haGlwYWwgQ2hhbGxhIDxtYWhpcGFscmVk
ZHkyMDA2QGdtYWlsLmNvbT47DQo+IFNldGggSmVubmluZ3MgPHNqZW5uaW5nQHJlZGhhdC5jb20+
OyBEYW4gU3RyZWV0bWFuIDxkZHN0cmVldEBpZWVlLm9yZz47DQo+IFZpdGFseSBXb29sIDx2aXRh
bHkud29vbEBrb25zdWxrby5jb20+OyBXYW5nemhvdSAoQikNCj4gPHdhbmd6aG91MUBoaXNpbGlj
b24uY29tPjsgZmFuZ2hhbyAoQSkgPGZhbmdoYW8xMUBodWF3ZWkuY29tPjsgQ29saW4NCj4gSWFu
IEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2
Nl0gbW0venN3YXA6IG1vdmUgdG8gdXNlIGNyeXB0b19hY29tcCBBUEkgZm9yDQo+IGhhcmR3YXJl
IGFjY2VsZXJhdGlvbg0KPiANCj4gT24gMjAyMC0wOS0yOSAxMDowMjoxNSBbKzAwMDBdLCBTb25n
IEJhbyBIdWEgKEJhcnJ5IFNvbmcpIHdyb3RlOg0KPiA+ID4gTXkgcG9pbnQgd2FzIHRoYXQgdGhl
cmUgd2lsbCBiZSBhIHdhcm5pbmcgYXQgcnVuLXRpbWUgYW5kIHlvdSBkb24ndA0KPiA+ID4gd2Fu
dCB0aGF0LiBUaGVyZSBhcmUgcmF3XyBhY2Nlc3NvcnMgaWYgeW91IGtub3cgd2hhdCB5b3UgYXJl
IGRvaW5nLg0KPiA+ID4gQnV04oCmDQo+ID4NCj4gPiBJIGhhdmUgb25seSBzZWVuIGdldF9jcHVf
cHRyL3ZhcigpIHRoaW5ncyB3aWxsIGRpc2FibGUgcHJlZW1wdGlvbi4gSQ0KPiA+IGRvbid0IHRo
aW5rIHdlIHdpbGwgaGF2ZSBhIHdhcm5pbmcgYXMgdGhpc19jcHVfcHRyKCkgd29uJ3QgZGlzYWJs
ZQ0KPiBwcmVlbXB0aW9uLg0KPiANCj4gR29vZC4gSnVzdCBlbmFibGUgQ09ORklHX0RFQlVHX1BS
RUVNUFQgYW5kIHRlbGwgcGxlYXNlIHdoYXQgaGFwcGVucy4NCj4gDQoNClByb2JhYmx5IGdvdCB3
aGF0IHlvdSBtZWFuIHdoaWxlIHRoaXNfY3B1X3B0ciBzaG91bGQgdXN1YWxseSBiZSBjYWxsZWQg
aW4gcHJlZW1wdGlvbi1kaXNhYmxlZA0KY29udGV4dC4gV2lsbCBkbyBmdXJ0aGVyIHRlc3QgdG8g
Y2hlY2sgYW5kIHZlcmlmeSBjYXJlZnVsbHkgd2l0aCBERUJVR19QUkVFTVBULg0KDQpTbyB5b3Vy
IHN1Z2dlc3Rpb24gaXMgYWN0dWFsbHkgdGhlIGJlbG93Pw0KYS4gZ2V0X2NwdV9wdHIgIC8vIGZv
ciBhY29tcF9jdHggYW5kIGRpc2FibGUgcHJlZW1wdGlvbg0KYi4gcmF3X2NwdV9wdHIgb3IgdGhp
c19jcHVfcHRyICAvLyBmb3IgZHN0bWVtKyBtdXRleA0KYy4gcHV0X2NwdV9wdHIgIC8vZW5hYmxl
IHByZWVtcHRpb24NCg0KaW4gdGhpcyB3YXksIGFsbCBzdGVwcyAiYSIgdG8gImMiIGFyZSBzdHJp
Y3RseSBpbiBhIHByZWVtcHRpb24tZGlzYWJsZWQgY29udGV4dC4NCg0KPiA+ID4gRWFybGllciB5
b3UgaGFkIGNvbXByZXNzaW9uL2RlY29tcHJlc3Npb24gd2l0aCBkaXNhYmxlZCBwcmVlbXB0aW9u
DQo+ID4gPiBhbmQNCj4gPg0KPiA+IE5vLiB0aGF0IGlzIHJpZ2h0IG5vdyBkb25lIGluIGVuYWJs
ZWQgcHJlZW1wdGlvbiBjb250ZXh0IHdpdGggdGhpcw0KPiA+IHBhdGNoLiBUaGUgY29kZSBiZWZv
cmUgdGhpcyBwYXRjaCB3YXMgZG9pbmcgKGRlKWNvbXByZXNzaW9uIGluDQo+IHByZWVtcHRpb24t
ZGlzYWJsZWQgY29udGV4dCBieSB1c2luZyBnZXRfY3B1X3B0ciBhbmQgZ2V0X2NwdV92YXIuDQo+
IA0KPiBFeGFjdGx5IHdoYXQgSSBhbSBzYXlpbmcuIEFuZCB3aXRoaW4gdGhpcyBnZXRfY3B1X3B0
cigpIHNlY3Rpb24gdGhlcmUgd2FzIHRoZQ0KPiBjb21wcmVzc2lvbi9kZWNvbXByZXNzaW9uIHNp
dHRpbmcuIFNvIGNvbXByZXNzaW9uL2RlY29tcHJlc3Npb24gaGFwcGVuZA0KPiB3aGlsZSBwcmVl
bXRpb24gd2FzIG9mZi4NCj4gDQo+ID4gPiBzdHJpY3QgcGVyLUNQVSBtZW1vcnkgYWxsb2NhdGlv
bi4gTm93IGlmIHlvdSBrZWVwIHRoaXMgcGVyLUNQVQ0KPiA+ID4gbWVtb3J5IGFsbG9jYXRpb24g
dGhlbiB5b3UgZ2FpbiBhIHBvc3NpYmxlIGJvdHRsZW5lY2suDQo+ID4gPiBJbiB0aGUgcHJldmlv
dXMgZW1haWwgeW91IHNhaWQgdGhhdCB0aGVyZSBtYXkgYmUgYSBib3R0bGVuZWNrIGluIHRoZQ0K
PiA+ID4gdXBwZXIgbGF5ZXIgd2hlcmUgeW91IGNhbid0IHV0aWxpemUgYWxsIHRoYXQgbWVtb3J5
IHlvdSBhbGxvY2F0ZS4gU28NCj4gPiA+IHlvdSBtYXkgd2FudCB0byByZXRoaW5rIHRoYXQgc3Ry
YXRlZ3kgYmVmb3JlIHRoYXQgcmV3b3JrLg0KPiA+DQo+ID4gd2UgYXJlIHByb2JhYmx5IG5vdCB0
YWxraW5nIGFib3V0IHNhbWUgdGhpbmcgOi0pIEkgd2FzIHRhbGtpbmcgYWJvdXQNCj4gPiBwb3Nz
aWJsZSBnZW5lcmljIHN3YXAgYm90dGxlbmVjay4gRm9yIGV4YW1wbGUsIExSVSBpcyBnbG9iYWws
IHdoaWxlDQo+ID4gc3dhcHBpbmcsIG11bHRpcGxlIGNvcmVzIG1pZ2h0IGhhdmUgc29tZSBsb2Nr
cyBvbiB0aGlzIExSVS4gZm9yDQo+ID4gZXhhbXBsZSwgaWYgd2UgaGF2ZSA4IGluYWN0aXZlIHBh
Z2VzIHRvIHN3YXAgb3V0LCBJIGFtIG5vdCBzdXJlIGlmIG1tDQo+ID4gY2FuIHVzZSA4IGNvcmVz
IHRvIHN3YXAgdGhlbSBvdXQgYXQgdGhlIHNhbWUgdGltZS4NCj4gDQo+IEluIHRoYXQgY2FzZSB5
b3UgcHJvYmFibHkgZG9uJ3QgbmVlZCA4KiBwZXItQ1BVIG1lbW9yeSBmb3IgdGhpcyB0YXNrLg0K
DQpFdmVudHVhbGx5IEkgZ290IHdoYXQgeW91IG1lYW4sIGl0IHNlZW1zIHlvdSBtZWFuIHdlIG1p
Z2h0IGJlIGFibGUgdG8gc2F2ZSBzb21lIG1lbW9yeQ0Kc2luY2Ugd2UgaGF2ZSBtb3ZlZCB0byBw
cmVlbXB0aW9uLWVuYWJsZWQgY29udGV4dCBmb3IgKGRlKWNvbXByZXNzaW9uLCB3ZSBkb27igJl0
IGhhdmUgdG8NCnN0cmljdGx5IGRlcGVuZCBvbiBwZXItY3B1IHBhZ2UuDQoNCkkgYWdyZWUgaXQg
bWlnaHQgYmUgcHV0IGludG8gdG9kbyBsaXN0IHRvIGludmVzdGlnYXRlLiBGb3IgdGhlIGZpcnN0
IHBhdGNoIHRvIGZpeCB0aGUgYnJva2VuIEFQSXMNCmNvbm5lY3Rpb24sIGl0IHNlZW1zIGl0IGlz
IG5vdCB0aGUgcHJvcGVyIHRpbWUgdG8gaGFuZGxlIHRoaXMgbWVtb3J5IHNhdmluZyBpc3N1ZS4g
QW5kIGl0IGlzDQphY3R1YWxseSBxdWl0ZSBjb21wbGljYXRlZCBhcyB3ZSBuZWVkIGEgcGVyLW51
bWEgcG9vbCBmb3IgZHN0bWVtIHJhdGhlciB0aGFuIGdsb2JhbCBwb29sLg0KDQo+IA0KPiA+ID4N
Cj4gPiA+ID4gMi4gd2hpbGUgYWxsb2NhdGluZyBtdXRleCwgd2UgY2FuIHB1dCB0aGUgbXV0ZXgg
aW50byBsb2NhbCBtZW1vcnkNCj4gPiA+ID4gYnkgdXNpbmcNCj4gPiA+IGttYWxsb2Nfbm9kZSgp
Lg0KPiA+ID4gPiBJZiB3ZSBtb3ZlIHRvICJzdHJ1Y3QgbXV0ZXggbG9jayIgZGlyZWN0bHksIG1v
c3QgQ1BVcyBpbiBhIE5VTUENCj4gPiA+ID4gc2VydmVyIHdpbGwNCj4gPiA+IGhhdmUgdG8gYWNj
ZXNzDQo+ID4gPiA+IHJlbW90ZSBtZW1vcnkgdG8gcmVhZC93cml0ZSB0aGUgbXV0ZXgsIHRoZXJl
Zm9yZSwgdGhpcyB3aWxsDQo+ID4gPiA+IGluY3JlYXNlIHRoZQ0KPiA+ID4gbGF0ZW5jeSBkcmFt
YXRpY2FsbHkuDQo+ID4gPg0KPiA+ID4gSWYgeW91IG5lZWQgc29tZXRoaW5nIHBlci1DUFUgdGhl
biBERUZJTkVfUEVSX0NQVSgpIHdpbGwgZ2l2ZSBpdCB0byB5b3UuDQo+ID4NCj4gPiBZZXMuIEl0
IGlzIHRydWUuDQo+ID4NCj4gPiA+IEl0IHdvdWxkIGJlIHZlcnkgYmFkIGZvciBwZXJmb3JtYW5j
ZSBpZiB0aGlzIGFsbG9jYXRpb25zIHdlcmUgbm90DQo+ID4gPiBmcm9tIENQVS1sb2NhbCBtZW1v
cnksIHJpZ2h0PyBTbyB3aGF0IG1ha2VzIHlvdSB0aGluayB0aGlzIGlzIHdvcnNlDQo+ID4gPiB0
aGFuDQo+ID4gPiBrbWFsbG9jX25vZGUoKSBiYXNlZCBhbGxvY2F0aW9ucz8NCj4gPg0KPiA+IFll
cy4gSWYgeW91ciByZWFkIHpzd2FwIGNvZGUsIGl0IGhhcyBjb25zaWRlcmVkIE5VTUEgdmVyeSBj
YXJlZnVsbHkgYnkNCj4gPiBhbGxvY2F0aW5nIHZhcmlvdXMgbWVtb3J5IGxvY2FsbHkuIEFuZCBp
biBjcnlwdG8gZnJhbWV3b3JrLCBJIGFsc28gYWRkZWQgQVBJDQo+IHRvIGFsbG9jYXRlIGxvY2Fs
IGNvbXByZXNzaW9uLg0KPiA+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb20NCj4gPiBtaXQvP2lkPTdiYzEzYjViNjBl
OTQgdGhpcyB6c3dhcCBwYXRjaCBoYXMgdXNlZCB0aGUgbmV3IG5vZGUtYXdhcmUNCj4gPiBBUEku
DQo+ID4NCj4gPiBNZW1vcnkgYWNjZXNzIGNyb3NzaW5nIE5VTUEgbm9kZSwgcHJhY3RpY2FsbHkg
Y3Jvc3NpbmcgcGFja2FnZXMsIGNhbg0KPiA+IGRyYW1hdGljYWxseSBpbmNyZWFzZSwgbGlrZSBk
b3VibGUsIHRyaXBsZSBvciBtb3JlLg0KPiANCj4gU28geW91IGFyZSB0ZWxsaW5nIG1lLCBERUZJ
TkVfUEVSX0NQVSgpIGRvZXMgbm90IGFsbG9jYXRlIHRoZSBtZW1vcnkgZm9yDQo+IGVhY2ggQ1BV
IHRvIGJlIGxvY2FsIGJ1dCBrbWFsbG9jX25vZGUoKSBkb2VzPw0KDQpGb3IgdGhlIGZpcnN0IGJl
Z2lubmluZywgdGhleSBhcmUgcHV0IHRvZ2V0aGVyLiBCdXQgYWZ0ZXIgc2V0dXBfcGVyX2NwdV9h
cmVhcygpDQp0aGV5IGFyZSBjb3BpZWQgdG8gYSBtZW1vcnkgYWNjb2xhdGVkIGJ5IG1lbWJsb2Nr
IHdpdGggbm9kZSBpbmZvcm1hdGlvbi4NCkkgbWlzc2VkIHRoZSBzZWNvbmQgcGFydC4gWW91IGFy
ZSByaWdodCA6LSkNCg0KVGhhbmtzDQpCYXJyeQ0K
