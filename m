Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0A9C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 11:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88FC7248C6
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 11:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgFULmi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 07:42:38 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:60334 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729869AbgFULmh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 07:42:37 -0400
Received: from dggemi404-hub.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 5D47F94BB76BF3AA2A05;
        Sun, 21 Jun 2020 19:42:31 +0800 (CST)
Received: from DGGEMI525-MBS.china.huawei.com ([169.254.6.126]) by
 dggemi404-hub.china.huawei.com ([10.3.17.142]) with mapi id 14.03.0487.000;
 Sun, 21 Jun 2020 19:42:24 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Vitaly Wool <vitaly.wool@konsulko.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        "Dan Streetman" <ddstreet@ieee.org>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v2] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Thread-Topic: [PATCH v2] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Thread-Index: AQHWR13SeIBWlHX1UEepxDijJY/Xw6jiZfgAgACK3QA=
Date:   Sun, 21 Jun 2020 11:42:24 +0000
Message-ID: <B926444035E5E2439431908E3842AFD2511765@DGGEMI525-MBS.china.huawei.com>
References: <20200620235033.8420-1-song.bao.hua@hisilicon.com>
 <CAM4kBBKKR01hFpB02YLPHBHsLiBHuEDfC96RvDug0P4_h6eQzg@mail.gmail.com>
In-Reply-To: <CAM4kBBKKR01hFpB02YLPHBHsLiBHuEDfC96RvDug0P4_h6eQzg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.201.204]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVml0YWx5IFdvb2wgW21h
aWx0bzp2aXRhbHkud29vbEBrb25zdWxrby5jb21dDQo+IFNlbnQ6IFN1bmRheSwgSnVuZSAyMSwg
MjAyMCAxMToxNiBQTQ0KPiBUbzogU29uZyBCYW8gSHVhIChCYXJyeSBTb25nKSA8c29uZy5iYW8u
aHVhQGhpc2lsaWNvbi5jb20+DQo+IENjOiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5k
YXRpb24ub3JnPjsNCj4gaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1OyBkYXZlbUBkYXZlbWxv
ZnQubmV0Ow0KPiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBMaW51eC1NTSA8bGludXgt
bW1Aa3ZhY2sub3JnPjsgTEtNTA0KPiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IExp
bnV4YXJtIDxsaW51eGFybUBodWF3ZWkuY29tPjsgTHVpcw0KPiBDbGF1ZGlvIFIgLiBHb25jYWx2
ZXMgPGxnb25jYWx2QHJlZGhhdC5jb20+OyBTZWJhc3RpYW4gQW5kcnplaiBTaWV3aW9yDQo+IDxi
aWdlYXN5QGxpbnV0cm9uaXguZGU+OyBNYWhpcGFsIENoYWxsYSA8bWFoaXBhbHJlZGR5MjAwNkBn
bWFpbC5jb20+Ow0KPiBTZXRoIEplbm5pbmdzIDxzamVubmluZ0ByZWRoYXQuY29tPjsgRGFuIFN0
cmVldG1hbiA8ZGRzdHJlZXRAaWVlZS5vcmc+Ow0KPiBXYW5nemhvdSAoQikgPHdhbmd6aG91MUBo
aXNpbGljb24uY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyXSBtbS96c3dhcDogbW92ZSB0
byB1c2UgY3J5cHRvX2Fjb21wIEFQSSBmb3INCj4gaGFyZHdhcmUgYWNjZWxlcmF0aW9uDQo+IA0K
PiBPbiBTdW4sIEp1biAyMSwgMjAyMCBhdCAxOjUyIEFNIEJhcnJ5IFNvbmcgPHNvbmcuYmFvLmh1
YUBoaXNpbGljb24uY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IHJpZ2h0IG5vdywgYWxsIG5ldyBa
SVAgZHJpdmVycyBhcmUgdXNpbmcgY3J5cHRvX2Fjb21wIEFQSXMgcmF0aGVyIHRoYW4NCj4gPiBs
ZWdhY3kgY3J5cHRvX2NvbXAgQVBJcy4gQnV0IHpzd2FwLmMgaXMgc3RpbGwgdXNpbmcgdGhlIG9s
ZCBBUElzLiBUaGF0DQo+ID4gbWVhbnMgenN3YXAgd29uJ3QgYmUgYWJsZSB0byB1c2UgYW55IG5l
dyB6aXAgZHJpdmVycyBpbiBrZXJuZWwuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIG1vdmVzIHRvIHVz
ZSBjcnl0b19hY29tcCBBUElzIHRvIGZpeCB0aGUgcHJvYmxlbS4gT24gdGhlDQo+ID4gb3RoZXIg
aGFuZCwgdHJhZGlvbnRhbCBjb21wcmVzc29ycyBsaWtlIGx6NCxsem8gZXRjIGhhdmUgYmVlbiB3
cmFwcGVkDQo+ID4gaW50byBhY29tcCB2aWEgc2NvbXAgYmFja2VuZC4gU28gcGxhdGZvcm1zIHdp
dGhvdXQgYXN5bmMgY29tcHJlc3NvcnMNCj4gPiBjYW4gZmFsbGJhY2sgdG8gdXNlIGFjb21wIHZp
YSBzY29tcCBiYWNrZW5kLg0KPiA+DQo+ID4gQ2M6IEx1aXMgQ2xhdWRpbyBSLiBHb25jYWx2ZXMg
PGxnb25jYWx2QHJlZGhhdC5jb20+DQo+ID4gQ2M6IFNlYmFzdGlhbiBBbmRyemVqIFNpZXdpb3Ig
PGJpZ2Vhc3lAbGludXRyb25peC5kZT4NCj4gPiBDYzogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51
eC1mb3VuZGF0aW9uLm9yZz4NCj4gPiBDYzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBh
bmEub3JnLmF1Pg0KPiA+IENjOiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
DQo+ID4gQ2M6IE1haGlwYWwgQ2hhbGxhIDxtYWhpcGFscmVkZHkyMDA2QGdtYWlsLmNvbT4NCj4g
PiBDYzogU2V0aCBKZW5uaW5ncyA8c2plbm5pbmdAcmVkaGF0LmNvbT4NCj4gPiBDYzogRGFuIFN0
cmVldG1hbiA8ZGRzdHJlZXRAaWVlZS5vcmc+DQo+ID4gQ2M6IFZpdGFseSBXb29sIDx2aXRhbHku
d29vbEBrb25zdWxrby5jb20+DQo+ID4gQ2M6IFpob3UgV2FuZyA8d2FuZ3pob3UxQGhpc2lsaWNv
bi5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmFycnkgU29uZyA8c29uZy5iYW8uaHVhQGhpc2ls
aWNvbi5jb20+DQo+ID4gLS0tDQo+ID4gIC12MjoNCj4gPiAgcmViYXNlIHRvIDUuOC1yYzE7DQo+
ID4gIGNsZWFudXAgY29tbWl0IGxvZzsNCj4gPiAgY2xlYW51cCB0byBpbXByb3ZlIHRoZSByZWFk
YWJpbGl0eSBhY2NvcmRpbmcgdG8gU2ViYXN0aWFuJ3MgY29tbWVudA0KPiA+DQo+ID4gIG1tL3pz
d2FwLmMgfCAxNTMNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTEwIGluc2VydGlvbnMoKyksIDQz
IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL21tL3pzd2FwLmMgYi9tbS96c3dh
cC5jDQo+ID4gaW5kZXggZmJiNzgyOTI0Y2NjLi4wZDkxNGJhNmI0YTAgMTAwNjQ0DQo+ID4gLS0t
IGEvbW0venN3YXAuYw0KPiA+ICsrKyBiL21tL3pzd2FwLmMNCj4gPiBAQCAtMjQsOCArMjQsMTAg
QEANCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3JidHJlZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgv
c3dhcC5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvY3J5cHRvLmg+DQo+ID4gKyNpbmNsdWRlIDxs
aW51eC9zY2F0dGVybGlzdC5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvbWVtcG9vbC5oPg0KPiA+
ICAjaW5jbHVkZSA8bGludXgvenBvb2wuaD4NCj4gPiArI2luY2x1ZGUgPGNyeXB0by9hY29tcHJl
c3MuaD4NCj4gPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvbW1fdHlwZXMuaD4NCj4gPiAgI2luY2x1
ZGUgPGxpbnV4L3BhZ2UtZmxhZ3MuaD4NCj4gPiBAQCAtMTI3LDkgKzEyOSwxNyBAQA0KPiBtb2R1
bGVfcGFyYW1fbmFtZWQoc2FtZV9maWxsZWRfcGFnZXNfZW5hYmxlZCwNCj4gPiB6c3dhcF9zYW1l
X2ZpbGxlZF9wYWdlc19lbmFibGVkLA0KPiA+ICAqIGRhdGEgc3RydWN0dXJlcw0KPiA+ICAqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLw0KPiA+DQo+ID4gK3N0cnVjdCBjcnlwdG9f
YWNvbXBfY3R4IHsNCj4gPiArICAgICAgIHN0cnVjdCBjcnlwdG9fYWNvbXAgKmFjb21wOw0KPiA+
ICsgICAgICAgc3RydWN0IGFjb21wX3JlcSAqcmVxOw0KPiA+ICsgICAgICAgc3RydWN0IGNyeXB0
b193YWl0IHdhaXQ7DQo+ID4gKyAgICAgICB1OCAqZHN0bWVtOw0KPiA+ICsgICAgICAgc3RydWN0
IG11dGV4IG11dGV4Ow0KPiA+ICt9Ow0KPiA+ICsNCj4gPiAgc3RydWN0IHpzd2FwX3Bvb2wgew0K
PiA+ICAgICAgICAgc3RydWN0IHpwb29sICp6cG9vbDsNCj4gPiAtICAgICAgIHN0cnVjdCBjcnlw
dG9fY29tcCAqIF9fcGVyY3B1ICp0Zm07DQo+ID4gKyAgICAgICBzdHJ1Y3QgY3J5cHRvX2Fjb21w
X2N0eCAqIF9fcGVyY3B1ICphY29tcF9jdHg7DQo+ID4gICAgICAgICBzdHJ1Y3Qga3JlZiBrcmVm
Ow0KPiA+ICAgICAgICAgc3RydWN0IGxpc3RfaGVhZCBsaXN0Ow0KPiA+ICAgICAgICAgc3RydWN0
IHdvcmtfc3RydWN0IHJlbGVhc2Vfd29yazsgQEAgLTQxNSwzMCArNDI1LDYwIEBAIHN0YXRpYw0K
PiA+IGludCB6c3dhcF9kc3RtZW1fZGVhZCh1bnNpZ25lZCBpbnQgY3B1KSAgc3RhdGljIGludA0K
PiA+IHpzd2FwX2NwdV9jb21wX3ByZXBhcmUodW5zaWduZWQgaW50IGNwdSwgc3RydWN0IGhsaXN0
X25vZGUgKm5vZGUpICB7DQo+ID4gICAgICAgICBzdHJ1Y3QgenN3YXBfcG9vbCAqcG9vbCA9IGhs
aXN0X2VudHJ5KG5vZGUsIHN0cnVjdCB6c3dhcF9wb29sLA0KPiBub2RlKTsNCj4gPiAtICAgICAg
IHN0cnVjdCBjcnlwdG9fY29tcCAqdGZtOw0KPiA+ICsgICAgICAgc3RydWN0IGNyeXB0b19hY29t
cCAqYWNvbXA7DQo+ID4gKyAgICAgICBzdHJ1Y3QgYWNvbXBfcmVxICpyZXE7DQo+ID4gKyAgICAg
ICBzdHJ1Y3QgY3J5cHRvX2Fjb21wX2N0eCAqYWNvbXBfY3R4Ow0KPiA+DQo+ID4gLSAgICAgICBp
ZiAoV0FSTl9PTigqcGVyX2NwdV9wdHIocG9vbC0+dGZtLCBjcHUpKSkNCj4gPiArICAgICAgIGlm
IChXQVJOX09OKCpwZXJfY3B1X3B0cihwb29sLT5hY29tcF9jdHgsIGNwdSkpKQ0KPiA+ICAgICAg
ICAgICAgICAgICByZXR1cm4gMDsNCj4gPg0KPiA+IC0gICAgICAgdGZtID0gY3J5cHRvX2FsbG9j
X2NvbXAocG9vbC0+dGZtX25hbWUsIDAsIDApOw0KPiA+IC0gICAgICAgaWYgKElTX0VSUl9PUl9O
VUxMKHRmbSkpIHsNCj4gPiAtICAgICAgICAgICAgICAgcHJfZXJyKCJjb3VsZCBub3QgYWxsb2Mg
Y3J5cHRvIGNvbXAgJXMgOiAlbGRcbiIsDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICBwb29s
LT50Zm1fbmFtZSwgUFRSX0VSUih0Zm0pKTsNCj4gPiArICAgICAgIGFjb21wX2N0eCA9IGt6YWxs
b2Moc2l6ZW9mKCphY29tcF9jdHgpLCBHRlBfS0VSTkVMKTsNCj4gPiArICAgICAgIGlmIChJU19F
UlJfT1JfTlVMTChhY29tcF9jdHgpKSB7DQo+ID4gKyAgICAgICAgICAgICAgIHByX2VycigiQ291
bGQgbm90IGluaXRpYWxpemUgYWNvbXBfY3R4XG4iKTsNCj4gPiArICAgICAgICAgICAgICAgcmV0
dXJuIC1FTk9NRU07DQo+ID4gKyAgICAgICB9DQo+ID4gKyAgICAgICBhY29tcCA9IGNyeXB0b19h
bGxvY19hY29tcChwb29sLT50Zm1fbmFtZSwgMCwgMCk7DQo+ID4gKyAgICAgICBpZiAoSVNfRVJS
X09SX05VTEwoYWNvbXApKSB7DQo+ID4gKyAgICAgICAgICAgICAgIHByX2VycigiY291bGQgbm90
IGFsbG9jIGNyeXB0byBhY29tcCAlcyA6ICVsZFxuIiwNCj4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHBvb2wtPnRmbV9uYW1lLCBQVFJfRVJSKGFjb21wKSk7DQo+ID4gICAgICAg
ICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KPiA+ICAgICAgICAgfQ0KPiANCj4gSSBiZXQgeW91
IGFjdHVhbGx5IHdhbnQgdG8gZnJlZSBhY29tcF9jdHggaGVyZS4gT3ZlcmFsbCwgY291bGQgeW91
IHBsZWFzZQ0KPiBwcm92aWRlIG1vcmUgY2FyZWZ1bCBlcnJvciBwYXRoIGltcGxlbWVudGF0aW9u
IG9yIGV4cGxhaW4gd2h5IGl0IGlzbid0DQo+IG5lY2Vzc2FyeT8NCg0KT29wcy4gSSBjb3VsZCBo
YXJkbHkgYmVsaWV2ZSBteSBleWVzLiBpdCBpcyBkZWZpbml0ZWx5IG5lY2Vzc2FyeSB0byBmcmVl
IHRoZSBhbGxvY2F0ZWQgZGF0YSBzdHJ1Y3QgaGVyZSwNCndpbGwgc2VuZCBhbiBpbmNyZW1lbnRh
bCBwYXRjaCB0byBmaXggdGhpcy4gVGhhbmtzIGZvciB5b3VyIGNvbW1lbnQuDQoNCkJlc3QgUmVn
YXJkcywNCkJhcnJ5DQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+ICAgICBWaXRhbHkNCg0K
