Return-Path: <SRS0=8ohu=DG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B645FC4346E
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 05:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FFAE21548
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 05:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgI2Fa2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Sep 2020 01:30:28 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3534 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbgI2Fa2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Sep 2020 01:30:28 -0400
X-Greylist: delayed 952 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 01:30:26 EDT
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 6A4C513F0518D2320ABE;
        Tue, 29 Sep 2020 13:14:32 +0800 (CST)
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 29 Sep 2020 13:14:32 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi761-chm.china.huawei.com (10.1.198.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 29 Sep 2020 13:14:31 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.1913.007;
 Tue, 29 Sep 2020 13:14:31 +0800
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
Thread-Index: AQHWlat2/tz4PWWjYEyGimM6I0lKCKl+fZuAgACGPEA=
Date:   Tue, 29 Sep 2020 05:14:31 +0000
Message-ID: <76bb2b545117413eb0879abcf91cf0f0@hisilicon.com>
References: <20200818123100.4140-1-song.bao.hua@hisilicon.com>
 <20200928152432.l3auscdx2suyli4u@linutronix.de> 
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU29uZyBCYW8gSHVhIChC
YXJyeSBTb25nKQ0KPiBTZW50OiBUdWVzZGF5LCBTZXB0ZW1iZXIgMjksIDIwMjAgMTA6MDIgQU0N
Cj4gVG86ICdTZWJhc3RpYW4gQW5kcnplaiBTaWV3aW9yJyA8YmlnZWFzeUBsaW51dHJvbml4LmRl
Pg0KPiBDYzogYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgaGVyYmVydEBnb25kb3IuYXBhbmEu
b3JnLmF1Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwu
b3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7
IEx1aXMgQ2xhdWRpbyBSIC4gR29uY2FsdmVzDQo+IDxsZ29uY2FsdkByZWRoYXQuY29tPjsgTWFo
aXBhbCBDaGFsbGEgPG1haGlwYWxyZWRkeTIwMDZAZ21haWwuY29tPjsNCj4gU2V0aCBKZW5uaW5n
cyA8c2plbm5pbmdAcmVkaGF0LmNvbT47IERhbiBTdHJlZXRtYW4gPGRkc3RyZWV0QGllZWUub3Jn
PjsNCj4gVml0YWx5IFdvb2wgPHZpdGFseS53b29sQGtvbnN1bGtvLmNvbT47IFdhbmd6aG91IChC
KQ0KPiA8d2FuZ3pob3UxQGhpc2lsaWNvbi5jb20+OyBmYW5naGFvIChBKSA8ZmFuZ2hhbzExQGh1
YXdlaS5jb20+OyBDb2xpbg0KPiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0K
PiBTdWJqZWN0OiBSRTogW1BBVENIIHY2XSBtbS96c3dhcDogbW92ZSB0byB1c2UgY3J5cHRvX2Fj
b21wIEFQSSBmb3INCj4gaGFyZHdhcmUgYWNjZWxlcmF0aW9uDQo+IA0KPiANCj4gDQo+ID4gLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBTZWJhc3RpYW4gQW5kcnplaiBTaWV3
aW9yIFttYWlsdG86YmlnZWFzeUBsaW51dHJvbml4LmRlXQ0KPiA+IFNlbnQ6IFR1ZXNkYXksIFNl
cHRlbWJlciAyOSwgMjAyMCA0OjI1IEFNDQo+ID4gVG86IFNvbmcgQmFvIEh1YSAoQmFycnkgU29u
ZykgPHNvbmcuYmFvLmh1YUBoaXNpbGljb24uY29tPg0KPiA+IENjOiBha3BtQGxpbnV4LWZvdW5k
YXRpb24ub3JnOyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7DQo+ID4gZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3Jn
Ow0KPiA+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEx1aXMgQ2xhdWRpbyBSIC4gR29u
Y2FsdmVzDQo+ID4gPGxnb25jYWx2QHJlZGhhdC5jb20+OyBNYWhpcGFsIENoYWxsYSA8bWFoaXBh
bHJlZGR5MjAwNkBnbWFpbC5jb20+Ow0KPiA+IFNldGggSmVubmluZ3MgPHNqZW5uaW5nQHJlZGhh
dC5jb20+OyBEYW4gU3RyZWV0bWFuIDxkZHN0cmVldEBpZWVlLm9yZz47DQo+ID4gVml0YWx5IFdv
b2wgPHZpdGFseS53b29sQGtvbnN1bGtvLmNvbT47IFdhbmd6aG91IChCKQ0KPiA+IDx3YW5nemhv
dTFAaGlzaWxpY29uLmNvbT47IGZhbmdoYW8gKEEpIDxmYW5naGFvMTFAaHVhd2VpLmNvbT47IENv
bGluDQo+ID4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gPiBTdWJqZWN0
OiBSZTogW1BBVENIIHY2XSBtbS96c3dhcDogbW92ZSB0byB1c2UgY3J5cHRvX2Fjb21wIEFQSSBm
b3INCj4gPiBoYXJkd2FyZSBhY2NlbGVyYXRpb24NCj4gPg0KPiA+IE9uIDIwMjAtMDgtMTkgMDA6
MzE6MDAgWysxMjAwXSwgQmFycnkgU29uZyB3cm90ZToNCj4gPiA+IGRpZmYgLS1naXQgYS9tbS96
c3dhcC5jIGIvbW0venN3YXAuYw0KPiA+ID4gaW5kZXggZmJiNzgyOTI0Y2NjLi4wMGI1ZjE0YTcz
MzIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9tbS96c3dhcC5jDQo+ID4gPiArKysgYi9tbS96c3dhcC5j
DQo+ID4gPiBAQCAtMTI3LDkgKzEyOSwxNyBAQA0KPiA+IG1vZHVsZV9wYXJhbV9uYW1lZChzYW1l
X2ZpbGxlZF9wYWdlc19lbmFibGVkLA0KPiA+IHpzd2FwX3NhbWVfZmlsbGVkX3BhZ2VzX2VuYWJs
ZWQsDQo+ID4gPiAgKiBkYXRhIHN0cnVjdHVyZXMNCj4gPiA+ICAqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqLw0KPiA+ID4NCj4gPiA+ICtzdHJ1Y3QgY3J5cHRvX2Fjb21wX2N0eCB7
DQo+ID4gPiArCXN0cnVjdCBjcnlwdG9fYWNvbXAgKmFjb21wOw0KPiA+ID4gKwlzdHJ1Y3QgYWNv
bXBfcmVxICpyZXE7DQo+ID4gPiArCXN0cnVjdCBjcnlwdG9fd2FpdCB3YWl0Ow0KPiA+ID4gKwl1
OCAqZHN0bWVtOw0KPiA+ID4gKwlzdHJ1Y3QgbXV0ZXggKm11dGV4Ow0KPiA+ID4gK307DQo+ID4g
PiArDQo+ID4gPiAgc3RydWN0IHpzd2FwX3Bvb2wgew0KPiA+ID4gIAlzdHJ1Y3QgenBvb2wgKnpw
b29sOw0KPiA+ID4gLQlzdHJ1Y3QgY3J5cHRvX2NvbXAgKiBfX3BlcmNwdSAqdGZtOw0KPiA+ID4g
KwlzdHJ1Y3QgY3J5cHRvX2Fjb21wX2N0eCBfX3BlcmNwdSAqYWNvbXBfY3R4Ow0KPiA+ID4gIAlz
dHJ1Y3Qga3JlZiBrcmVmOw0KPiA+ID4gIAlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7DQo+ID4gPiAg
CXN0cnVjdCB3b3JrX3N0cnVjdCByZWxlYXNlX3dvcms7DQo+ID4gPiBAQCAtMzg4LDIzICszOTgs
NDMgQEAgc3RhdGljIHN0cnVjdCB6c3dhcF9lbnRyeQ0KPiA+ICp6c3dhcF9lbnRyeV9maW5kX2dl
dChzdHJ1Y3QgcmJfcm9vdCAqcm9vdCwNCj4gPiA+ICAqIHBlci1jcHUgY29kZQ0KPiA+ID4gICoq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovDQo+ID4gPiAgc3RhdGljIERFRklORV9Q
RVJfQ1BVKHU4ICosIHpzd2FwX2RzdG1lbSk7DQo+ID4gPiArLyoNCj4gPiA+ICsgKiBJZiB1c2Vy
cyBkeW5hbWljYWxseSBjaGFuZ2UgdGhlIHpwb29sIHR5cGUgYW5kIGNvbXByZXNzb3IgYXQgcnVu
dGltZSwNCj4gPiBpLmUuDQo+ID4gPiArICogenN3YXAgaXMgcnVubmluZywgenN3YXAgY2FuIGhh
dmUgbW9yZSB0aGFuIG9uZSB6cG9vbCBvbiBvbmUgY3B1LCBidXQNCj4gPiB0aGV5DQo+ID4gPiAr
ICogYXJlIHNoYXJpbmcgZHRzbWVtLiBTbyB3ZSBuZWVkIHRoaXMgbXV0ZXggdG8gYmUgcGVyLWNw
dS4NCj4gPiA+ICsgKi8NCj4gPiA+ICtzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IG11dGV4
ICosIHpzd2FwX211dGV4KTsNCj4gPg0KPiA+IFRoZXJlIGlzIG5vIG5lZWQgdG8gbWFrZSBpdCBz
dHVyY3QgbXV0ZXgqLiBZb3UgY291bGQgbWFrZSBpdCBzdHJ1Y3QNCj4gPiBtdXRleC4gVGhlIGZv
bGxvd2luZyBtYWtlIGl0IG1vcmUgb2J2aW91cyBob3cgdGhlIHJlbGF0aW9uIGhlcmUgaXMgKGV2
ZW4NCj4gPiB3aXRob3V0IGEgY29tbWVudCk6DQo+ID4NCj4gPiB8c3RydWN0IHpzd2FwX21lbV9w
b29sIHsNCj4gPiB8CXZvaWQJCSpkc3RfbWVtOw0KPiA+IHwJc3RydWN0IG11dGV4CWxvY2s7DQo+
ID4gfH07DQo+ID4gfA0KPiA+IHxzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IHpzd2FwX21l
bV9wb29sICwgenN3YXBfbWVtX3Bvb2wpOw0KPiA+DQo+ID4gUGxlYXNlIGFjY2VzcyBvbmx5IHRo
aXMsIGRvbid0IGFkZCB1c2UgYSBwb2ludGVyIGluIGEgYW5vdGhlciBzdHJ1Y3QgdG8NCj4gPiBk
ZXN0X21lbSBvciBsb2NrIHdoaWNoIG1heSBjb25mdXNlIHBlb3BsZS4NCj4gDQo+IFdlbGwuIEl0
IHNlZW1zIHNlbnNpYmxlLg0KDQpBZnRlciBzZWNvbmQgdGhvdWdodCBhbmQgdHJ5aW5nIHRvIG1h
a2UgdGhpcyBjaGFuZ2UsIEkgd291bGQgbGlrZSB0byBjaGFuZ2UgbXkgbWluZA0KYW5kIGRpc2Fn
cmVlIHdpdGggdGhpcyBpZGVhLiBUd28gcmVhc29uczoNCjEuIHdoaWxlIHVzaW5nIHRoaXNfY3B1
X3B0cigpIHdpdGhvdXQgcHJlZW1wdGlvbiBsb2NrLCBwZW9wbGUgdXN1YWxseSBwdXQgYWxsIHRo
aW5ncyBib3VuZA0Kd2l0aCBvbmUgY3B1IHRvIG9uZSBzdHJ1Y3R1cmUsIHNvIHRoYXQgb25jZSB3
ZSBnZXQgdGhlIHBvaW50ZXIgb2YgdGhlIHdob2xlIHN0cnVjdHVyZSwgd2UgZ2V0DQphbGwgaXRz
IHBhcnRzIGJlbG9uZ2luZyB0byB0aGUgc2FtZSBjcHUuIElmIHdlIG1vdmUgdGhlIGRzdG1lbSBh
bmQgbXV0ZXggb3V0IG9mIHRoZSBzdHJ1Y3R1cmUNCmNvbnRhaW5pbmcgdGhlbSwgd2Ugd2lsbCBo
YXZlIHRvIGRvOg0KCWEuIGdldF9jcHVfcHRyKCkgZm9yIHRoZSBhY29tcF9jdHggICAvL2xvY2sg
cHJlZW1wdGlvbg0KCWIuIHRoaXNfY3B1X3B0cigpIGZvciB0aGUgZHN0bWVtIGFuZCBtdXRleA0K
CWMuIHB1dF9jcHVfcHRyKCkgZm9yIHRoZSBhY29tcF9jdHggIC8vdW5sb2NrIHByZWVtcHRpb24N
CglkLiBtdXRleF9sb2NrKCkNCgkgIHNnX2luaXRfb25lKCkNCgkgIGNvbXByZXNzL2RlY29tcHJl
c3MgZXRjLg0KCSAgLi4uDQoJICBtdXRleF91bmxvY2sNCg0KYXMgdGhlIGdldCgpIGFuZCBwdXQo
KSBoYXZlIGEgcHJlZW1wdGlvbiBsb2NrL3VubG9jaywgdGhpcyB3aWxsIG1ha2UgY2VydGFpbiB0
aGlzX2NwdV9wdHIoKQ0KaW4gdGhlIHN0ZXAgImIiIHdpbGwgcmV0dXJuIHRoZSByaWdodCBkc3Rt
ZW0gYW5kIG11dGV4IHdoaWNoIGJlbG9uZyB0byB0aGUgc2FtZSBjcHUgd2l0aA0Kc3RlcCAiYSIu
DQoNClRoZSBzdGVwcyBmcm9tICJhIiB0byAiYyIgYXJlIHF1aXRlIHNpbGx5IGFuZCBjb25mdXNp
bmcuIEkgYmVsaWV2ZSB0aGUgZXhpc3RpbmcgY29kZSBhbGlnbnMNCndpdGggdGhlIG1vc3Qgc2lt
aWxhciBjb2RlIGluIGtlcm5lbCBiZXR0ZXI6DQoJYS4gdGhpc19jcHVfcHRyKCkgICAvL2dldCBl
dmVyeXRoaW5nIGZvciBvbmUgY3B1DQoJYi4gbXV0ZXhfbG9jaygpDQoJICBzZ19pbml0X29uZSgp
DQoJICBjb21wcmVzcy9kZWNvbXByZXNzIGV0Yy4NCgkgIC4uLg0KCSAgbXV0ZXhfdW5sb2NrDQoN
CjIuIHdoaWxlIGFsbG9jYXRpbmcgbXV0ZXgsIHdlIGNhbiBwdXQgdGhlIG11dGV4IGludG8gbG9j
YWwgbWVtb3J5IGJ5IHVzaW5nIGttYWxsb2Nfbm9kZSgpLg0KSWYgd2UgbW92ZSB0byAic3RydWN0
IG11dGV4IGxvY2siIGRpcmVjdGx5LCBtb3N0IENQVXMgaW4gYSBOVU1BIHNlcnZlciB3aWxsIGhh
dmUgdG8gYWNjZXNzDQpyZW1vdGUgbWVtb3J5IHRvIHJlYWQvd3JpdGUgdGhlIG11dGV4LCB0aGVy
ZWZvcmUsIHRoaXMgd2lsbCBpbmNyZWFzZSB0aGUgbGF0ZW5jeSBkcmFtYXRpY2FsbHkuDQoNClRo
YW5rcw0KQmFycnkNCg0K
