Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1369C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 07:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF2E206C3
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 07:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgGIHzg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 03:55:36 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2634 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbgGIHzf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 03:55:35 -0400
Received: from dggemi403-hub.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 42D2B1039172E51C53D6;
        Thu,  9 Jul 2020 15:55:31 +0800 (CST)
Received: from DGGEMI525-MBS.china.huawei.com ([169.254.6.177]) by
 dggemi403-hub.china.huawei.com ([10.3.17.136]) with mapi id 14.03.0487.000;
 Thu, 9 Jul 2020 15:55:23 +0800
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
Thread-Index: AQHWVF24fP2q5El5/U63jMMAkQc326j9QfAAgAE0U2D//+LwgIAAht1A
Date:   Thu, 9 Jul 2020 07:55:22 +0000
Message-ID: <B926444035E5E2439431908E3842AFD2561D4E@DGGEMI525-MBS.china.huawei.com>
References: <20200707125210.33256-1-song.bao.hua@hisilicon.com>
 <20200708145934.4w3qk53mgavyyln7@linutronix.de>
 <B926444035E5E2439431908E3842AFD25610B7@DGGEMI525-MBS.china.huawei.com>
 <20200709073905.lgs5kvccnz6eqsyd@linutronix.de>
In-Reply-To: <20200709073905.lgs5kvccnz6eqsyd@linutronix.de>
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
bnQ6IFRodXJzZGF5LCBKdWx5IDksIDIwMjAgNzozOSBQTQ0KPiBUbzogU29uZyBCYW8gSHVhIChC
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
IGFjY2VsZXJhdGlvbg0KPiANCj4gT24gMjAyMC0wNy0wOSAwMTozMjozOCBbKzAwMDBdLCBTb25n
IEJhbyBIdWEgKEJhcnJ5IFNvbmcpIHdyb3RlOg0KPiA+ID4gVGhpcyBsb29rcyB1c2luZyB0aGUg
c2FtZSBzeW5jaHJvbm91cyBtZWNoYW5pc20gYXJvdW5kIGFuDQo+IGFzeW5jaHJvbm91cw0KPiA+
ID4gaW50ZXJmYWNlLiBJdCB3b3JrcyBhcyBhIFBvQy4NCj4gPiA+DQo+ID4gPiBBcyBmYXIgYXMg
SSByZW1lbWJlciB0aGUgY3J5cHRvIGFzeW5jIGludGVyZmFjZSwgdGhlIGluY29taW5nIHNrYnMg
d2VyZSBmZWQNCj4gdG8NCj4gPiA+IHRoZSBhc3luYyBpbnRlcmZhY2UgYW5kIHJldHVybmVkIHRv
IHRoZSBjYWxsZXIgc28gdGhlIE5JQyBjb3VsZCBjb250aW51ZQ0KPiA+ID4gYWxsb2NhdGUgbmV3
IFJYIHNrYnMgYW5kIG1vdmUgb24uIE9ubHkgaWYgdGhlIHF1ZXVlIG9mIHJlcXVlc3RzIHdhcw0K
PiBnZXR0aW5nDQo+ID4gPiB0byBsb25nIHRoZSBjb2RlIHN0YXJ0ZWQgdG8gdGhyb3R0bGUuIEV2
ZW50dWFsbHkgdGhlIGFzeW5jIGNyeXB0byBjb2RlDQo+ID4gPiBjb21wbGV0ZWQgdGhlIGRlY3J5
cHRpb24gb3BlcmF0aW9uIGluIGEgZGlmZmVyZW50IGNvbnRleHQgYW5kIGZlZCB0aGUNCj4gPiA+
IGRlY3J5cHRlZCBwYWNrZXQocykgaW50byB0aGUgc3RhY2suDQo+ID4gPg0KPiA+ID4gRnJvbSBh
IHF1aWNrIHZpZXcsIHlvdSB3b3VsZCBoYXZlIHRvIHJldHVybiAtRUlOUFJPR1JFU1MgaGVyZSBh
bmQgaGF2ZQ0KPiBhdA0KPiA+ID4gdGhlIGNhbGxlciBzaWRlIHNvbWV0aGluZyBsaWtlIHRoYXQ6
DQo+ID4gPg0KPiA+ID4gaWZmIC0tZ2l0IGEvbW0vcGFnZV9pby5jIGIvbW0vcGFnZV9pby5jDQo+
ID4gPiBpbmRleCBlODcyNmYzZTM4MjBiLi45ZDFiYWE0NmVjM2VkIDEwMDY0NA0KPiA+ID4gLS0t
IGEvbW0vcGFnZV9pby5jDQo+ID4gPiArKysgYi9tbS9wYWdlX2lvLmMNCj4gPiA+IEBAIC0yNTIs
MTIgKzI1MiwxNSBAQCBpbnQgc3dhcF93cml0ZXBhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UsIHN0cnVj
dA0KPiA+ID4gd3JpdGViYWNrX2NvbnRyb2wgKndiYykNCj4gPiA+ICAgICAgICAgICAgICAgICB1
bmxvY2tfcGFnZShwYWdlKTsNCj4gPiA+ICAgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gPiA+
ICAgICAgICAgfQ0KPiA+ID4gLSAgICAgICBpZiAoZnJvbnRzd2FwX3N0b3JlKHBhZ2UpID09IDAp
IHsNCj4gPiA+ICsgICAgICAgcmV0ID0gZnJvbnRzd2FwX3N0b3JlKHBhZ2UpOw0KPiA+ID4gKyAg
ICAgICBpZiAocmV0ID09IDApIHsNCj4gPiA+ICAgICAgICAgICAgICAgICBzZXRfcGFnZV93cml0
ZWJhY2socGFnZSk7DQo+ID4gPiAgICAgICAgICAgICAgICAgdW5sb2NrX3BhZ2UocGFnZSk7DQo+
ID4gPiAgICAgICAgICAgICAgICAgZW5kX3BhZ2Vfd3JpdGViYWNrKHBhZ2UpOw0KPiA+ID4gICAg
ICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+ID4gICAgICAgICB9DQo+ID4gPiArICAgICAgIGlm
IChyZXQgPSAtRUlOUFJPR1JFU1MpDQo+ID4gPiArICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+
ID4gPiAgICAgICAgIHJldCA9IF9fc3dhcF93cml0ZXBhZ2UocGFnZSwgd2JjLCBlbmRfc3dhcF9i
aW9fd3JpdGUpOw0KPiA+ID4gIG91dDoNCj4gPiA+ICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiA+
DQo+ID4gVW5mb3J0dW5hdGVseSwgdGhpcyBpcyBub3QgdHJ1ZSBhbmQgdGhpbmdzIGFyZSBub3Qg
dGhhdCBzaW1wbGUuDQo+ID4NCj4gPiBXZSBjYW4ndCBzaW1wbHkgZGVwZW5kIG9uIC1FSU5QUk9H
UkVTUyBhbmQgZ28gb3V0Lg0KPiA+IFdlIGhhdmUgdG8gd2FpdCBmb3IgdGhlIHJlc3VsdCBvZiBj
b21wcmVzc2lvbiB0byBkZWNpZGUgaWYgd2Ugc2hvdWxkDQo+ID4gZG8gX19zd2FwX3dyaXRlcGFn
ZSgpLiBBcyBvbmUgcGFnZSBtaWdodCBiZSBjb21wcmVzc2VkIGludG8gdHdvDQo+ID4gcGFnZXMs
IGluIHRoaXMgY2FzZSwgd2Ugd2lsbCBzdGlsbCBuZWVkIHRvIGRvIF9zd2FwX3dyaXRlcGFnZSgp
Lg0KPiA+IEFzIEkgcmVwbGllZCBpbiB0aGUgbGF0ZXN0IGVtYWlsLCBhbGwgb2YgdGhlIGFzeW5j
IGltcHJvdmVtZW50IHRvIGZyb250c3dhcA0KPiA+IG5lZWRzIHZlcnkgY2FyZWZ1bCB0aGlua2lu
ZyBhbmQgYmVuY2htYXJrLiBJdCBjYW4gb25seSBoYXBwZW4gYWZ0ZXINCj4gPiB3ZSBidWlsZCB0
aGUgYmFzZSBpbiB0aGlzIHBhdGNoLCBmaXhpbmcgdGhlIGJyb2tlbiBjb25uZWN0aW9uIGJldHdl
ZW4NCj4gPiB6c3dhcCBhbmQgdGhvc2UgbmV3IHppcCBkcml2ZXJzLg0KPiANCj4gQXQgdGhlIHRp
bWUgdGhlIGNvbXByZXNzaW9uIGZpbmlzaGVzIHlvdSBzZWUgd2hhdCBoYXBwZW5zIGFuZCBiYXNl
ZCBvbg0KPiB0aGUgZGVzaWduIHlvdSBjYW4gZWl0aGVyIGNvbXBsZXRlIGl0IGltbWVkaWF0ZWx5
ICh0aGUgMC9lcnJvciBjYXNlIGZyb20NCj4gYWJvdmUpIG9yIGZvcndhcmQgdGhlIHJlc3VsdCB0
byB0aGUgY2FsbGVyIGFuZCBsZXQgaGltIGRlY2lkZS4NCg0KSGVsbG8gU2ViYXN0aWFuLCB0aGFu
a3MgZm9yIHlvdXIgcmVwbHkgYW5kIGNhcmVmdWwgcmV2aWV3Lg0KDQpSaWdodCBub3csIGZyb250
c3dhcCBpcyBwcmV0dHkgbXVjaCBvbmUgdGhpbmcgd2hpY2ggaGFwcGVucyBiZWZvcmUgX19zd2Fw
X3dyaXRlcGFnZSgpLg0KVGhlIHdob2xlIGRlc2lnbiBpcyBmdWxsIG9mIHRoZSBhc3N1bXB0aW9u
IHRoYXQgZnJvbnRzd2FwIGlzIHN5bmMuIFNvIGlmIGZyb250c3dhcA0KY29uc3VtZXMgYSBwYWdl
IHdpdGhvdXQgYW55IGVycm9yLCB0aGlzIHBhZ2Ugd29uJ3QgZ28gdG8gX19zd2FwX3dyaXRlcGFn
ZSgpDQp3aGljaCBpcyBhc3luYy4gT24gdGhlIG90aGVyIGhhbmQsIGlmIGZyb250c3dhcCdzIHN0
b3JlIGhhcyBhbnkgZXJyb3IsIHRoYXQgbWVhbnMNCnRoaXMgcGFnZSBuZWVkcyB0byBzd2FwIHRv
IGRpc2suDQoNCmludCBzd2FwX3dyaXRlcGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSwgc3RydWN0IHdy
aXRlYmFja19jb250cm9sICp3YmMpDQp7DQoJaW50IHJldCA9IDA7DQoNCglpZiAodHJ5X3RvX2Zy
ZWVfc3dhcChwYWdlKSkgew0KCQl1bmxvY2tfcGFnZShwYWdlKTsNCgkJZ290byBvdXQ7DQoJfQ0K
CWlmIChmcm9udHN3YXBfc3RvcmUocGFnZSkgPT0gMCkgew0KCQlzZXRfcGFnZV93cml0ZWJhY2so
cGFnZSk7DQoJCXVubG9ja19wYWdlKHBhZ2UpOw0KCQllbmRfcGFnZV93cml0ZWJhY2socGFnZSk7
DQoJCWdvdG8gb3V0Ow0KCX0NCglyZXQgPSBfX3N3YXBfd3JpdGVwYWdlKHBhZ2UsIHdiYywgZW5k
X3N3YXBfYmlvX3dyaXRlKTsNCm91dDoNCglyZXR1cm4gcmV0Ow0KfQ0KDQpJIGRvbid0IHRoaW5r
IHdlIGNhbiBzaW1wbHkgImZvcndhcmQgdGhlIHJlc3VsdCB0byB0aGUgY2FsbGVyIGFuZCBsZXQg
aGltIGRlY2lkZSIuDQpXb3VsZCB5b3UgbGlrZSB0byBwcmVzZW50IHNvbWUgcHNldWRvIGNvZGU/
DQoNClRoYW5rcw0KQmFycnkNCg0K
