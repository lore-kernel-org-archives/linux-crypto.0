Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7239C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 09:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C58972076A
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 09:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgGIJJN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 05:09:13 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2539 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbgGIJJM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 05:09:12 -0400
Received: from dggemi403-hub.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 8F8E03A7B6D4AD727A89;
        Thu,  9 Jul 2020 17:09:09 +0800 (CST)
Received: from DGGEMI423-HUB.china.huawei.com (10.1.199.152) by
 dggemi403-hub.china.huawei.com (10.3.17.136) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 9 Jul 2020 17:09:08 +0800
Received: from DGGEMI525-MBS.china.huawei.com ([169.254.6.177]) by
 dggemi423-hub.china.huawei.com ([10.1.199.152]) with mapi id 14.03.0487.000;
 Thu, 9 Jul 2020 17:09:02 +0800
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
Thread-Index: AQHWVF24fP2q5El5/U63jMMAkQc326j9QfAAgAE0U2D//+LwgIAAht1A//+KWACAAIZeoA==
Date:   Thu, 9 Jul 2020 09:09:02 +0000
Message-ID: <B926444035E5E2439431908E3842AFD2561F4F@DGGEMI525-MBS.china.huawei.com>
References: <20200707125210.33256-1-song.bao.hua@hisilicon.com>
 <20200708145934.4w3qk53mgavyyln7@linutronix.de>
 <B926444035E5E2439431908E3842AFD25610B7@DGGEMI525-MBS.china.huawei.com>
 <20200709073905.lgs5kvccnz6eqsyd@linutronix.de>
 <B926444035E5E2439431908E3842AFD2561D4E@DGGEMI525-MBS.china.huawei.com>
 <20200709084040.cf3jzkndiaefky4r@linutronix.de>
In-Reply-To: <20200709084040.cf3jzkndiaefky4r@linutronix.de>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogb3duZXItbGludXgtbW1A
a3ZhY2sub3JnIFttYWlsdG86b3duZXItbGludXgtbW1Aa3ZhY2sub3JnXSBPbg0KPiBCZWhhbGYg
T2YgU2ViYXN0aWFuIEFuZHJ6ZWogU2lld2lvcg0KPiBTZW50OiBUaHVyc2RheSwgSnVseSA5LCAy
MDIwIDg6NDEgUE0NCj4gVG86IFNvbmcgQmFvIEh1YSAoQmFycnkgU29uZykgPHNvbmcuYmFvLmh1
YUBoaXNpbGljb24uY29tPg0KPiBDYzogYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgaGVyYmVy
dEBnb25kb3IuYXBhbmEub3JnLmF1Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBsaW51eC1jcnlw
dG9Admdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IExpbnV4YXJtIDxsaW51eGFybUBodWF3ZWkuY29tPjsgTHVpcyBDbGF1
ZGlvDQo+IFIgLiBHb25jYWx2ZXMgPGxnb25jYWx2QHJlZGhhdC5jb20+OyBNYWhpcGFsIENoYWxs
YQ0KPiA8bWFoaXBhbHJlZGR5MjAwNkBnbWFpbC5jb20+OyBTZXRoIEplbm5pbmdzIDxzamVubmlu
Z0ByZWRoYXQuY29tPjsNCj4gRGFuIFN0cmVldG1hbiA8ZGRzdHJlZXRAaWVlZS5vcmc+OyBWaXRh
bHkgV29vbA0KPiA8dml0YWx5Lndvb2xAa29uc3Vsa28uY29tPjsgV2FuZ3pob3UgKEIpIDx3YW5n
emhvdTFAaGlzaWxpY29uLmNvbT47DQo+IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9u
aWNhbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjRdIG1tL3pzd2FwOiBtb3ZlIHRvIHVz
ZSBjcnlwdG9fYWNvbXAgQVBJIGZvcg0KPiBoYXJkd2FyZSBhY2NlbGVyYXRpb24NCj4gDQo+IE9u
IDIwMjAtMDctMDkgMDc6NTU6MjIgWyswMDAwXSwgU29uZyBCYW8gSHVhIChCYXJyeSBTb25nKSB3
cm90ZToNCj4gPiBIZWxsbyBTZWJhc3RpYW4sIHRoYW5rcyBmb3IgeW91ciByZXBseSBhbmQgY2Fy
ZWZ1bCByZXZpZXcuDQo+IEhpLA0KPiANCj4gPiBJIGRvbid0IHRoaW5rIHdlIGNhbiBzaW1wbHkg
ImZvcndhcmQgdGhlIHJlc3VsdCB0byB0aGUgY2FsbGVyIGFuZCBsZXQgaGltDQo+IGRlY2lkZSIu
DQo+ID4gV291bGQgeW91IGxpa2UgdG8gcHJlc2VudCBzb21lIHBzZXVkbyBjb2RlPw0KPiANCj4g
SSBwcm92aWRlZCBqdXN0IHNvbWUgcHNldWRvIGNvZGUgdG8gaWxsdXN0cmF0ZSBhbiBleGFtcGxl
IGhvdyB0aGUgYXN5bmMNCj4gaW50ZXJmYWNlIHNob3VsZCBsb29rIGxpa2UgKG1vcmUgb3IgbGVz
cykuIFRoZSBlc3NlbnRpYWwgcGFydCBpcyB3aGVyZQ0KPiB5b3UgYWxsb3cgdG8gZmVlZCBtdWx0
aXBsZSByZXF1ZXN0cyB3aXRob3V0IGJsb2NraW5nLg0KDQpTZWJhc3RpYW4sIERvIHlvdSBtZWFu
IHRoZSBiZWxvdyBjb2RlPw0KDQpAQCAtMjUyLDEyICsyNTIsMTUgQEAgaW50IHN3YXBfd3JpdGVw
YWdlKHN0cnVjdCBwYWdlICpwYWdlLCBzdHJ1Y3Qgd3JpdGViYWNrX2NvbnRyb2wgKndiYykNCiAg
ICAgICAgICAgICAgICB1bmxvY2tfcGFnZShwYWdlKTsNCiAgICAgICAgICAgICAgICBnb3RvIG91
dDsNCiAgICAgICAgfQ0KLSAgICAgICBpZiAoZnJvbnRzd2FwX3N0b3JlKHBhZ2UpID09IDApIHsN
CisgICAgICAgcmV0ID0gZnJvbnRzd2FwX3N0b3JlKHBhZ2UpOw0KKyAgICAgICBpZiAocmV0ID09
IDApIHsNCiAgICAgICAgICAgICAgICBzZXRfcGFnZV93cml0ZWJhY2socGFnZSk7DQogICAgICAg
ICAgICAgICAgdW5sb2NrX3BhZ2UocGFnZSk7DQogICAgICAgICAgICAgICAgZW5kX3BhZ2Vfd3Jp
dGViYWNrKHBhZ2UpOw0KICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KICAgICAgICB9DQorICAg
ICAgIGlmIChyZXQgPSAtRUlOUFJPR1JFU1MpDQorICAgICAgICAgICAgICAgZ290byBvdXQ7DQog
ICAgICAgIHJldCA9IF9fc3dhcF93cml0ZXBhZ2UocGFnZSwgd2JjLCBlbmRfc3dhcF9iaW9fd3Jp
dGUpOw0KIG91dDoNCiAgICAgICAgcmV0dXJuIHJldDsNCg0KSSB0aGluayB0aGlzIHdvbicgd29y
ay4gLUVJTlBST0dSRVNTIHdvbid0IGJlIGFibGUgdG8gZGVjaWRlIGlmIHdlIHNob3VsZCBnb3Rv
IG91dC4gV2UgY2FuIG9ubHkgZ290byBvdXQgaWYgdGhlIGNvbXByZXNzaW9uDQpoYXMgZG9uZSB3
aXRob3V0IGFueSBlcnJvci4gVGhlIGVycm9yIG1pZ2h0IGJlIGJlY2F1c2Ugb2YgSFcgbGlrZSBF
SU8gb3IgYmVjYXVzZSB0aGUgZGF0YSBpcyBub3Qgc3VpdGFibGUgdG8gY29tcHJlc3MuIFdlIGNh
bg0Kb25seSBrbm93IHRoZSByZXN1bHQgYWZ0ZXIgdGhlIGNvbXByZXNzaW9uIGlzIHJlYWxseSBk
b25lIGFuZCB0aGUgY29tcGxldGlvbiBjYWxsYmFjayBpcyBjYWxsZWQgYnkgWklQIGRyaXZlcnMu
DQoNCklmIHRoZSBjb21wcmVzc2lvbiBpcyBzdGlsbCBJTlBST0dSRVNTLCB3ZSBkb24ndCBrbm93
IHdoYXQgd2lsbCBoYXBwZW4uDQoNCj4gSSB3ZW50IHVwIHRoZSBjYWxsLWNoYWluIGFuZCBmb3Vu
ZCBvbmUgcG90ZW50aWFsIHVzZXIgd2hpY2ggc2VlbSB0byBoYXZlDQo+IGEgbGlzdCBvZiBwYWdl
cyB3aGljaCBhcmUgcHJvY2Vzc2VkLiBUaGlzIGxvb2tlZCBsaWtlIGEgbmljZSBleGFtcGxlLiBJ
DQo+IGhhdmVuJ3QgbG9va2VkIGF0IHRoZSBkZXRhaWxzLg0KPiANCj4gSSBoYXZlIG5vIG9waW5p
b24gd2hldGhlciBvciBub3QgaXQgbWFrZXMgc2Vuc2UgdG8gc3dpdGNoIHRvIHRoZSBhc3luYw0K
PiBpbnRlcmZhY2UgaW4gYSBzeW5jIHdheS4NCg0KSSBhbHdheXMgYXBwcmVjaWF0ZSB5b3VyIGNv
bW1lbnQgYW5kIHlvdXIgb3Bpbmlvbi4NCg0KVGhlIHJlYWwgcHJvYmxlbSBoZXJlIGlzIHRoYXQg
YWxsIG9mIHRob3NlIG5ldyB6aXAgZHJpdmVycyBhcmUgYWRhcHRlZCB0byBhc3luYyBpbnRlcmZh
Y2UuIFRoZXJlIGlzIG5vIG9sZCBpbnRlcmZhY2Ugc3VwcG9ydA0KZm9yIHRob3NlIG5ldyBkcml2
ZXJzIG1haW5saW5lZCB0aGVzZSB5ZWFycy4genN3YXAgZG9lc27igJl0IHdvcmsgb24gdGhvc2Ug
bmV3IGRyaXZlcnMgYXMgdGhleSB0b3RhbGx5IGRvbid0IHN1cHBvcnQNCmNyeXB0b19jb21wX2Nv
bXByZXNzKCkNCmNyeXB0b19jb21wX2RlY29tcHJlc3MoKQ0KLi4uDQoNClNvIHRoZSBpbml0aWFs
IGdvYWwgb2YgdGhpcyBwYXRjaCBpcyBmaXhpbmcgdGhlIGRpc2Nvbm5lY3RlZCBicmlkZ2UgYmV0
d2VlbiBuZXcgemlwIGRyaXZlcnMgYW5kIHpzd2FwLg0KDQpNYWtpbmcgZnJvbnRzd2FwIGFzeW5j
IGNhbiBwcm9iYWJseSBoYXBwZW4gaWYgd2Ugc2VlIHBlcmZvcm1hbmNlIGltcHJvdmVtZW50LiBC
dXQgaXQgc2VlbXMgaXQgaXMgYSBiaWcgcHJvamVjdCwgbm90DQp0aGF0IHNpbXBsZS4gT24gdGhl
IG90aGVyIGhhbmQsIGl0IHNlZW1zIGhpc2lfemlwIGluIGRyaXZlcnMvY3J5cHRvIGlzIHRoZSBv
bmx5IGFzeW5jIGRyaXZlciB0aWxsIG5vdy4gU29ycnkgaWYgSSBhbSBtaXNzaW5nDQphbnkgb25l
LiBvdGhlciBkcml2ZXJzIGFyZSBhZGFwdGVkIHRvIGFjb21wIEFQSXMgYnkgc2NvbXAgQVBJcy4g
Rm9yIGV4YW1wbGU6DQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0L2NyeXB0by9sejQuYz9pZD04Y2Q5MzMwZTBh
DQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxk
cy9saW51eC5naXQvY29tbWl0L2NyeXB0by9sem8uYz9pZD1hYzlkMmM0YjMNCg0KU28gZXZlbiB3
ZSBtYWtlIGZyb250c3dhcCB0b3RhbGx5IGFzeW5jLCBtb3N0IHppcCBkcml2ZXJzIGFyZSBzdGls
bCBzeW5jIGFuZCB3ZSBkb24ndCBnZXQgdGhlIGJlbmVmaXQuIEZyb20gbXkgcHJvc3BlY3RpdmUs
DQpJIGFtIGdsYWQgdG8gdHJ5IHRoZSBwb3NzaWJpbGl0eSBvZiBtYWtpbmcgZnJvbnRzd2FwIGFz
eW5jIHRvIGxldmVyYWdlIHRoZSBwb3dlciBvZiBaSVAgaGFyZHdhcmUuIFRoaXMgd291bGQgcHJv
YmFibHkgYW5kDQpvbmx5IGhhcHBlbiBhZnRlciB3ZSBoYXZlIGEgYmFzZSB0byBzdXBwb3J0IGFj
b21wIEFQSXMuDQoNClRoYW5rcw0KQmFycnkNCg==
