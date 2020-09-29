Return-Path: <SRS0=8ohu=DG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51464C4346E
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 10:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A67B206B8
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 10:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgI2KCT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Sep 2020 06:02:19 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:33216 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725468AbgI2KCT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Sep 2020 06:02:19 -0400
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 968367AF5184FA23B79D;
        Tue, 29 Sep 2020 18:02:15 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 29 Sep 2020 18:02:15 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 29 Sep 2020 18:02:15 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.1913.007;
 Tue, 29 Sep 2020 18:02:15 +0800
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
Thread-Index: AQHWlat2/tz4PWWjYEyGimM6I0lKCKl+fZuAgACGPED//9FBgIAAiB0w
Date:   Tue, 29 Sep 2020 10:02:15 +0000
Message-ID: <5951148aef79459192826f405a6fa5aa@hisilicon.com>
References: <20200818123100.4140-1-song.bao.hua@hisilicon.com>
 <20200928152432.l3auscdx2suyli4u@linutronix.de>
 <76bb2b545117413eb0879abcf91cf0f0@hisilicon.com>
 <20200929093113.3cv63szruo3c4inu@linutronix.de>
In-Reply-To: <20200929093113.3cv63szruo3c4inu@linutronix.de>
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
eSwgU2VwdGVtYmVyIDI5LCAyMDIwIDEwOjMxIFBNDQo+IFRvOiBTb25nIEJhbyBIdWEgKEJhcnJ5
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
IGFjY2VsZXJhdGlvbg0KPiANCj4gT24gMjAyMC0wOS0yOSAwNToxNDozMSBbKzAwMDBdLCBTb25n
IEJhbyBIdWEgKEJhcnJ5IFNvbmcpIHdyb3RlOg0KPiA+IEFmdGVyIHNlY29uZCB0aG91Z2h0IGFu
ZCB0cnlpbmcgdG8gbWFrZSB0aGlzIGNoYW5nZSwgSSB3b3VsZCBsaWtlIHRvIGNoYW5nZQ0KPiBt
eSBtaW5kDQo+ID4gYW5kIGRpc2FncmVlIHdpdGggdGhpcyBpZGVhLiBUd28gcmVhc29uczoNCj4g
PiAxLiB3aGlsZSB1c2luZyB0aGlzX2NwdV9wdHIoKSB3aXRob3V0IHByZWVtcHRpb24gbG9jaywg
cGVvcGxlIHVzdWFsbHkgcHV0IGFsbA0KPiB0aGluZ3MgYm91bmQNCj4gPiB3aXRoIG9uZSBjcHUg
dG8gb25lIHN0cnVjdHVyZSwgc28gdGhhdCBvbmNlIHdlIGdldCB0aGUgcG9pbnRlciBvZiB0aGUg
d2hvbGUNCj4gc3RydWN0dXJlLCB3ZSBnZXQNCj4gPiBhbGwgaXRzIHBhcnRzIGJlbG9uZ2luZyB0
byB0aGUgc2FtZSBjcHUuIElmIHdlIG1vdmUgdGhlIGRzdG1lbSBhbmQgbXV0ZXgNCj4gb3V0IG9m
IHRoZSBzdHJ1Y3R1cmUNCj4gPiBjb250YWluaW5nIHRoZW0sIHdlIHdpbGwgaGF2ZSB0byBkbzoN
Cj4gPiAJYS4gZ2V0X2NwdV9wdHIoKSBmb3IgdGhlIGFjb21wX2N0eCAgIC8vbG9jayBwcmVlbXB0
aW9uDQo+ID4gCWIuIHRoaXNfY3B1X3B0cigpIGZvciB0aGUgZHN0bWVtIGFuZCBtdXRleA0KPiA+
IAljLiBwdXRfY3B1X3B0cigpIGZvciB0aGUgYWNvbXBfY3R4ICAvL3VubG9jayBwcmVlbXB0aW9u
DQo+ID4gCWQuIG11dGV4X2xvY2soKQ0KPiA+IAkgIHNnX2luaXRfb25lKCkNCj4gPiAJICBjb21w
cmVzcy9kZWNvbXByZXNzIGV0Yy4NCj4gPiAJICAuLi4NCj4gPiAJICBtdXRleF91bmxvY2sNCj4g
Pg0KPiA+IGFzIHRoZSBnZXQoKSBhbmQgcHV0KCkgaGF2ZSBhIHByZWVtcHRpb24gbG9jay91bmxv
Y2ssIHRoaXMgd2lsbCBtYWtlIGNlcnRhaW4NCj4gdGhpc19jcHVfcHRyKCkNCj4gPiBpbiB0aGUg
c3RlcCAiYiIgd2lsbCByZXR1cm4gdGhlIHJpZ2h0IGRzdG1lbSBhbmQgbXV0ZXggd2hpY2ggYmVs
b25nIHRvIHRoZQ0KPiBzYW1lIGNwdSB3aXRoDQo+ID4gc3RlcCAiYSIuDQo+ID4NCj4gPiBUaGUg
c3RlcHMgZnJvbSAiYSIgdG8gImMiIGFyZSBxdWl0ZSBzaWxseSBhbmQgY29uZnVzaW5nLiBJIGJl
bGlldmUgdGhlIGV4aXN0aW5nDQo+IGNvZGUgYWxpZ25zDQo+ID4gd2l0aCB0aGUgbW9zdCBzaW1p
bGFyIGNvZGUgaW4ga2VybmVsIGJldHRlcjoNCj4gPiAJYS4gdGhpc19jcHVfcHRyKCkgICAvL2dl
dCBldmVyeXRoaW5nIGZvciBvbmUgY3B1DQo+ID4gCWIuIG11dGV4X2xvY2soKQ0KPiA+IAkgIHNn
X2luaXRfb25lKCkNCj4gPiAJICBjb21wcmVzcy9kZWNvbXByZXNzIGV0Yy4NCj4gPiAJICAuLi4N
Cj4gPiAJICBtdXRleF91bmxvY2sNCj4gDQo+IE15IHBvaW50IHdhcyB0aGF0IHRoZXJlIHdpbGwg
YmUgYSB3YXJuaW5nIGF0IHJ1bi10aW1lIGFuZCB5b3UgZG9uJ3Qgd2FudA0KPiB0aGF0LiBUaGVy
ZSBhcmUgcmF3XyBhY2Nlc3NvcnMgaWYgeW91IGtub3cgd2hhdCB5b3UgYXJlIGRvaW5nLiBCdXTi
gKYNCg0KSSBoYXZlIG9ubHkgc2VlbiBnZXRfY3B1X3B0ci92YXIoKSB0aGluZ3Mgd2lsbCBkaXNh
YmxlIHByZWVtcHRpb24uIEkgZG9uJ3QgdGhpbmsNCndlIHdpbGwgaGF2ZSBhIHdhcm5pbmcgYXMg
dGhpc19jcHVfcHRyKCkgd29uJ3QgZGlzYWJsZSBwcmVlbXB0aW9uLg0KDQo+IA0KPiBFYXJsaWVy
IHlvdSBoYWQgY29tcHJlc3Npb24vZGVjb21wcmVzc2lvbiB3aXRoIGRpc2FibGVkIHByZWVtcHRp
b24gYW5kDQoNCk5vLiB0aGF0IGlzIHJpZ2h0IG5vdyBkb25lIGluIGVuYWJsZWQgcHJlZW1wdGlv
biBjb250ZXh0IHdpdGggdGhpcyBwYXRjaC4gVGhlIGNvZGUgYmVmb3JlIHRoaXMgcGF0Y2gNCndh
cyBkb2luZyAoZGUpY29tcHJlc3Npb24gaW4gcHJlZW1wdGlvbi1kaXNhYmxlZCBjb250ZXh0IGJ5
IHVzaW5nIGdldF9jcHVfcHRyIGFuZCBnZXRfY3B1X3Zhci4NCg0KPiBzdHJpY3QgcGVyLUNQVSBt
ZW1vcnkgYWxsb2NhdGlvbi4gTm93IGlmIHlvdSBrZWVwIHRoaXMgcGVyLUNQVSBtZW1vcnkNCj4g
YWxsb2NhdGlvbiB0aGVuIHlvdSBnYWluIGEgcG9zc2libGUgYm90dGxlbmVjay4NCj4gSW4gdGhl
IHByZXZpb3VzIGVtYWlsIHlvdSBzYWlkIHRoYXQgdGhlcmUgbWF5IGJlIGEgYm90dGxlbmVjayBp
biB0aGUNCj4gdXBwZXIgbGF5ZXIgd2hlcmUgeW91IGNhbid0IHV0aWxpemUgYWxsIHRoYXQgbWVt
b3J5IHlvdSBhbGxvY2F0ZS4gU28geW91DQo+IG1heSB3YW50IHRvIHJldGhpbmsgdGhhdCBzdHJh
dGVneSBiZWZvcmUgdGhhdCByZXdvcmsuDQoNCndlIGFyZSBwcm9iYWJseSBub3QgdGFsa2luZyBh
Ym91dCBzYW1lIHRoaW5nIDotKQ0KSSB3YXMgdGFsa2luZyBhYm91dCBwb3NzaWJsZSBnZW5lcmlj
IHN3YXAgYm90dGxlbmVjay4gRm9yIGV4YW1wbGUsIExSVSBpcyBnbG9iYWwsDQp3aGlsZSBzd2Fw
cGluZywgbXVsdGlwbGUgY29yZXMgbWlnaHQgaGF2ZSBzb21lIGxvY2tzIG9uIHRoaXMgTFJVLiBm
b3IgZXhhbXBsZSwNCmlmIHdlIGhhdmUgOCBpbmFjdGl2ZSBwYWdlcyB0byBzd2FwIG91dCwgSSBh
bSBub3Qgc3VyZSBpZiBtbSBjYW4gdXNlIDggY29yZXMNCnRvIHN3YXAgdGhlbSBvdXQgYXQgdGhl
IHNhbWUgdGltZS4NCg0KPiANCj4gPiAyLiB3aGlsZSBhbGxvY2F0aW5nIG11dGV4LCB3ZSBjYW4g
cHV0IHRoZSBtdXRleCBpbnRvIGxvY2FsIG1lbW9yeSBieSB1c2luZw0KPiBrbWFsbG9jX25vZGUo
KS4NCj4gPiBJZiB3ZSBtb3ZlIHRvICJzdHJ1Y3QgbXV0ZXggbG9jayIgZGlyZWN0bHksIG1vc3Qg
Q1BVcyBpbiBhIE5VTUEgc2VydmVyIHdpbGwNCj4gaGF2ZSB0byBhY2Nlc3MNCj4gPiByZW1vdGUg
bWVtb3J5IHRvIHJlYWQvd3JpdGUgdGhlIG11dGV4LCB0aGVyZWZvcmUsIHRoaXMgd2lsbCBpbmNy
ZWFzZSB0aGUNCj4gbGF0ZW5jeSBkcmFtYXRpY2FsbHkuDQo+IA0KPiBJZiB5b3UgbmVlZCBzb21l
dGhpbmcgcGVyLUNQVSB0aGVuIERFRklORV9QRVJfQ1BVKCkgd2lsbCBnaXZlIGl0IHRvIHlvdS4N
Cg0KWWVzLiBJdCBpcyB0cnVlLg0KDQo+IEl0IHdvdWxkIGJlIHZlcnkgYmFkIGZvciBwZXJmb3Jt
YW5jZSBpZiB0aGlzIGFsbG9jYXRpb25zIHdlcmUgbm90IGZyb20NCj4gQ1BVLWxvY2FsIG1lbW9y
eSwgcmlnaHQ/IFNvIHdoYXQgbWFrZXMgeW91IHRoaW5rIHRoaXMgaXMgd29yc2UgdGhhbg0KPiBr
bWFsbG9jX25vZGUoKSBiYXNlZCBhbGxvY2F0aW9ucz8NCg0KWWVzLiBJZiB5b3VyIHJlYWQgenN3
YXAgY29kZSwgaXQgaGFzIGNvbnNpZGVyZWQgTlVNQSB2ZXJ5IGNhcmVmdWxseSBieSBhbGxvY2F0
aW5nIHZhcmlvdXMNCm1lbW9yeSBsb2NhbGx5LiBBbmQgaW4gY3J5cHRvIGZyYW1ld29yaywgSSBh
bHNvIGFkZGVkIEFQSSB0byBhbGxvY2F0ZSBsb2NhbCBjb21wcmVzc2lvbi4NCmh0dHBzOi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9j
b21taXQvP2lkPTdiYzEzYjViNjBlOTQNCnRoaXMgenN3YXAgcGF0Y2ggaGFzIHVzZWQgdGhlIG5l
dyBub2RlLWF3YXJlIEFQSS4NCg0KTWVtb3J5IGFjY2VzcyBjcm9zc2luZyBOVU1BIG5vZGUsIHBy
YWN0aWNhbGx5IGNyb3NzaW5nIHBhY2thZ2VzLCBjYW4gZHJhbWF0aWNhbGx5IGluY3JlYXNlLA0K
bGlrZSBkb3VibGUsIHRyaXBsZSBvciBtb3JlLg0KDQpUaGFua3MNCkJhcnJ5DQoNCg==
