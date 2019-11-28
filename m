Return-Path: <SRS0=AT0s=ZU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA56C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Nov 2019 15:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EC5D21771
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Nov 2019 15:03:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TsReZw0M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfK1PDJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Nov 2019 10:03:09 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:2736 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726520AbfK1PDJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Nov 2019 10:03:09 -0500
X-UUID: 05f6b2ffa4b04713801b99ae136d6a82-20191128
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=jC/GKNqOteS0Lvf6BRgDnB35d1Uy+8B/V/fYzSkM2Js=;
        b=TsReZw0Mr4bbpohPuAoz7L7oTaH0PJ3ago56gS3me8xLuznMulWqihmnNiAz72AwYw8GbPAVuOAACb1u9aDcW5X2Q9xgv5qD75OjAQDUf3OSfTGZRQd+u4HKtP+yYefbTsLgCsXGJcRs2/p8o7haYMBSPchg9JefCLMd5o6bJ4s=;
X-UUID: 05f6b2ffa4b04713801b99ae136d6a82-20191128
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 775482770; Thu, 28 Nov 2019 23:02:57 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 28 Nov 2019 23:02:41 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 28 Nov 2019 23:02:47 +0800
Message-ID: <1574953375.6465.8.camel@mtkswgap22>
Subject: Re: [PATCH v5 3/3] hwrng: add mtk-sec-rng driver
From:   Neal Liu <neal.liu@mediatek.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Neal Liu <neal.liu@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Sean Wang <sean.wang@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Crystal Guo =?UTF-8?Q?=28=E9=83=AD=E6=99=B6=29?=" 
        <Crystal.Guo@mediatek.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date:   Thu, 28 Nov 2019 23:02:55 +0800
In-Reply-To: <CAKv+Gu_VicmyCGa8sQOwj_iRBf7Sf-iXpVa_3SQyB2Xjru=rmg@mail.gmail.com>
References: <1574864578-467-1-git-send-email-neal.liu@mediatek.com>
         <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
         <CAKv+Gu_VicmyCGa8sQOwj_iRBf7Sf-iXpVa_3SQyB2Xjru=rmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: BF5CA6FDD2FC2CB9BAB461AD12AAAA406649CF42595E3D02608CD659FD0140C62000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gV2VkLCAyMDE5LTExLTI3IGF0IDIzOjAzICswODAwLCBBcmQgQmllc2hldXZlbCB3cm90ZToN
Cj4gT24gV2VkLCAyNyBOb3YgMjAxOSBhdCAxNToyMywgTmVhbCBMaXUgPG5lYWwubGl1QG1lZGlh
dGVrLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBGb3IgTWVkaWFUZWsgU29DcyBvbiBBUk12OCB3aXRo
IFRydXN0Wm9uZSBlbmFibGVkLCBwZXJpcGhlcmFscyBsaWtlDQo+ID4gZW50cm9weSBzb3VyY2Vz
IGlzIG5vdCBhY2Nlc3NpYmxlIGZyb20gbm9ybWFsIHdvcmxkIChsaW51eCkgYW5kDQo+ID4gcmF0
aGVyIGFjY2Vzc2libGUgZnJvbSBzZWN1cmUgd29ybGQgKEFURi9URUUpIG9ubHkuIFRoaXMgZHJp
dmVyIGFpbXMNCj4gPiB0byBwcm92aWRlIGEgZ2VuZXJpYyBpbnRlcmZhY2UgdG8gQVRGIHJuZyBz
ZXJ2aWNlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTmVhbCBMaXUgPG5lYWwubGl1QG1lZGlh
dGVrLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnICAg
ICAgIHwgICAxNiArKysrKysNCj4gPiAgZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9NYWtlZmlsZSAg
ICAgIHwgICAgMSArDQo+ID4gIGRyaXZlcnMvY2hhci9od19yYW5kb20vbXRrLXNlYy1ybmcuYyB8
ICAxMDMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAzIGZpbGVzIGNo
YW5nZWQsIDEyMCBpbnNlcnRpb25zKCspDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJz
L2NoYXIvaHdfcmFuZG9tL210ay1zZWMtcm5nLmMNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWcgYi9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25m
aWcNCj4gPiBpbmRleCAyNWE3ZDhmLi5mMDhjODUyIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
Y2hhci9od19yYW5kb20vS2NvbmZpZw0KPiA+ICsrKyBiL2RyaXZlcnMvY2hhci9od19yYW5kb20v
S2NvbmZpZw0KPiA+IEBAIC0zOTgsNiArMzk4LDIyIEBAIGNvbmZpZyBIV19SQU5ET01fTVRLDQo+
ID4NCj4gPiAgICAgICAgICAgSWYgdW5zdXJlLCBzYXkgWS4NCj4gPg0KPiA+ICtjb25maWcgSFdf
UkFORE9NX01US19TRUMNCj4gPiArICAgICAgIHRyaXN0YXRlICJNZWRpYVRlayBTZWN1cml0eSBS
YW5kb20gTnVtYmVyIEdlbmVyYXRvciBzdXBwb3J0Ig0KPiA+ICsgICAgICAgZGVwZW5kcyBvbiBI
V19SQU5ET00NCj4gPiArICAgICAgIGRlcGVuZHMgb24gQVJDSF9NRURJQVRFSyB8fCBDT01QSUxF
X1RFU1QNCj4gPiArICAgICAgIGRlZmF1bHQgSFdfUkFORE9NDQo+ID4gKyAgICAgICAgIGhlbHAN
Cj4gPiArICAgICAgICAgVGhpcyBkcml2ZXIgcHJvdmlkZXMga2VybmVsLXNpZGUgc3VwcG9ydCBm
b3IgdGhlIFJhbmRvbSBOdW1iZXINCj4gPiArICAgICAgICAgR2VuZXJhdG9yIGhhcmR3YXJlIGZv
dW5kIG9uIE1lZGlhVGVrIFNvQ3MuIFRoZSBkaWZmZXJlbmNlIHdpdGgNCj4gPiArICAgICAgICAg
bXRrLXJuZyBpcyB0aGUgUmFuZG9tIE51bWJlciBHZW5lcmF0b3IgaGFyZHdhcmUgaXMgc2VjdXJl
DQo+ID4gKyAgICAgICAgIGFjY2VzcyBvbmx5Lg0KPiA+ICsNCj4gPiArICAgICAgICAgVG8gY29t
cGlsZSB0aGlzIGRyaXZlciBhcyBhIG1vZHVsZSwgY2hvb3NlIE0gaGVyZS4gdGhlDQo+ID4gKyAg
ICAgICAgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCBtdGstc2VjLXJuZy4NCj4gPiArDQo+ID4gKyAg
ICAgICAgIElmIHVuc3VyZSwgc2F5IFkuDQo+ID4gKw0KPiA+ICBjb25maWcgSFdfUkFORE9NX1Mz
OTANCj4gPiAgICAgICAgIHRyaXN0YXRlICJTMzkwIFRydWUgUmFuZG9tIE51bWJlciBHZW5lcmF0
b3Igc3VwcG9ydCINCj4gPiAgICAgICAgIGRlcGVuZHMgb24gUzM5MA0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL01ha2VmaWxlIGIvZHJpdmVycy9jaGFyL2h3X3JhbmRv
bS9NYWtlZmlsZQ0KPiA+IGluZGV4IDdjOWVmNGEuLmJlZTU0MTIgMTAwNjQ0DQo+ID4gLS0tIGEv
ZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9NYWtlZmlsZQ0KPiA+ICsrKyBiL2RyaXZlcnMvY2hhci9o
d19yYW5kb20vTWFrZWZpbGUNCj4gPiBAQCAtMzYsNiArMzYsNyBAQCBvYmotJChDT05GSUdfSFdf
UkFORE9NX1BJQzMyKSArPSBwaWMzMi1ybmcubw0KPiA+ICBvYmotJChDT05GSUdfSFdfUkFORE9N
X01FU09OKSArPSBtZXNvbi1ybmcubw0KPiA+ICBvYmotJChDT05GSUdfSFdfUkFORE9NX0NBVklV
TSkgKz0gY2F2aXVtLXJuZy5vIGNhdml1bS1ybmctdmYubw0KPiA+ICBvYmotJChDT05GSUdfSFdf
UkFORE9NX01USykgICAgKz0gbXRrLXJuZy5vDQo+ID4gK29iai0kKENPTkZJR19IV19SQU5ET01f
TVRLX1NFQykgICAgICAgICs9IG10ay1zZWMtcm5nLm8NCj4gPiAgb2JqLSQoQ09ORklHX0hXX1JB
TkRPTV9TMzkwKSArPSBzMzkwLXRybmcubw0KPiA+ICBvYmotJChDT05GSUdfSFdfUkFORE9NX0tF
WVNUT05FKSArPSBrcy1zYS1ybmcubw0KPiA+ICBvYmotJChDT05GSUdfSFdfUkFORE9NX09QVEVF
KSArPSBvcHRlZS1ybmcubw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIvaHdfcmFuZG9t
L210ay1zZWMtcm5nLmMgYi9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL210ay1zZWMtcm5nLmMNCj4g
PiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAuLjY5ZGRlY2ENCj4gPiAt
LS0gL2Rldi9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9tdGstc2VjLXJu
Zy5jDQo+ID4gQEAgLTAsMCArMSwxMDMgQEANCj4gPiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZp
ZXI6IEdQTC0yLjANCj4gPiArLyoNCj4gPiArICogQ29weXJpZ2h0IChDKSAyMDE5IE1lZGlhVGVr
IEluYy4NCj4gPiArICovDQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGludXgvYXJtLXNtY2NjLmg+
DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9od19yYW5kb20uaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4
L21vZHVsZS5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvb2YuaD4NCj4gPiArI2luY2x1ZGUgPGxp
bnV4L3BsYXRmb3JtX2RldmljZS5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvc29jL21lZGlhdGVr
L210a19zaXBfc3ZjLmg+DQo+ID4gKw0KPiA+ICsjZGVmaW5lIE1US19TRUNfUk5HX01BR0lDICAg
ICAgMHg3NDcyNmU2Nw0KPiA+ICsjZGVmaW5lIFNNQ19SRVRfTlVNICAgICAgICAgICAgNA0KPiA+
ICsjZGVmaW5lIE1US19TRUNfUk5EX1NJWkUgICAgICAgKHNpemVvZih1MzIpICogU01DX1JFVF9O
VU0pDQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBtdGtfc2VjX2dldF9ybmQodWludDMyX3QgKnZh
bCkNCj4gPiArew0KPiA+ICsgICAgICAgc3RydWN0IGFybV9zbWNjY19yZXMgcmVzOw0KPiA+ICsN
Cj4gPiArICAgICAgIGFybV9zbWNjY19zbWMoTVRLX1NJUF9LRVJORUxfR0VUX1JORCwNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgTVRLX1NFQ19STkdfTUFHSUMsIDAsIDAsIDAsIDAsIDAsIDAs
ICZyZXMpOw0KPiA+ICsNCj4gDQo+IENhbiB0aGlzIGNhbGwgbmV2ZXIgZmFpbD8gSG93IGRvZXMg
dGhlIGZpcm13YXJlIHNpZ25hbCB0aGF0IHNvbWV0aGluZw0KPiBpcyB3cm9uZyB3aXRoIHRoZSB1
bmRlcmx5aW5nIGhhcmR3YXJlPw0KPiANCg0KVGhlIHNtYyBjYWxsIGlzIHN1cHBvcnRlZCBpbiBi
b3RoIEFSTXY3ICYgQVJNdjggYXJjaGl0ZWN0dXJlcy5CdXQgeWVzLA0KaXQgc2hvdWxkIGNoZWNr
IGhhcmR3YXJlIHN0YXR1cyBiZWZvcmUgYXNzaWduaW5nIGl0Lg0KDQpXZSB3b3VsZCBsaWtlIHRv
IGNoZWNrIHRoYXQgaWYgaGFyZHdhcmUgaXMgc29tZXRoaW5nIHdyb25nLCBhbGwgcmV0dXJuDQp2
YWx1ZSB3aWxsIGJlIHplcm8uIGV4Og0KDQoJaWYgKCFyZXMuYTAgJiYgIXJlcy5hMSAmJiAhcmVz
LmEyICYmICFyZXMuYTMpDQoJCXJldHVybiBmYWxzZTsNCg0KPiA+ICsgICAgICAgdmFsWzBdID0g
cmVzLmEwOw0KPiA+ICsgICAgICAgdmFsWzFdID0gcmVzLmExOw0KPiA+ICsgICAgICAgdmFsWzJd
ID0gcmVzLmEyOw0KPiA+ICsgICAgICAgdmFsWzNdID0gcmVzLmEzOw0KDQoJcmV0dXJuIHRydWU7
DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgbXRrX3NlY19ybmdfcmVhZChzdHJ1Y3Qg
aHdybmcgKnJuZywgdm9pZCAqYnVmLCBzaXplX3QgbWF4LCBib29sIHdhaXQpDQo+ID4gK3sNCj4g
PiArICAgICAgIHUzMiB2YWxbNF0gPSB7MH07DQo+ID4gKyAgICAgICBpbnQgcmV0dmFsID0gMDsN
Cj4gPiArICAgICAgIGludCBpOw0KPiA+ICsNCj4gPiArICAgICAgIHdoaWxlIChtYXggPj0gTVRL
X1NFQ19STkRfU0laRSkgew0KPiA+ICsgICAgICAgICAgICAgICBtdGtfc2VjX2dldF9ybmQodmFs
KTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgIGZvciAoaSA9IDA7IGkgPCBTTUNfUkVUX05V
TTsgaSsrKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgKih1MzIgKilidWYgPSB2YWxb
aV07DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgYnVmICs9IHNpemVvZih1MzIpOw0KPiA+
ICsgICAgICAgICAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgICByZXR2YWwgKz0g
TVRLX1NFQ19STkRfU0laRTsNCj4gPiArICAgICAgICAgICAgICAgbWF4IC09IE1US19TRUNfUk5E
X1NJWkU7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgcmV0dXJuIHJldHZhbDsN
Cj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIHN0cnVjdCBod3JuZyBtdGtfc2VjX3JuZyA9IHsN
Cj4gPiArICAgICAgIC5uYW1lID0gIm10a19zZWNfcm5nIiwNCj4gPiArICAgICAgIC5yZWFkID0g
bXRrX3NlY19ybmdfcmVhZCwNCj4gPiArICAgICAgIC5xdWFsaXR5ID0gOTAwLA0KPiA+ICt9Ow0K
PiA+ICsNCj4gPiArc3RhdGljIGludCBtdGtfc2VjX3JuZ19wcm9iZSh2b2lkKQ0KPiA+ICt7DQo+
ID4gKyAgICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4gPiArICAgICAgIHJldCA9IGh3cm5nX3JlZ2lz
dGVyKCZtdGtfc2VjX3JuZyk7DQo+ID4gKyAgICAgICBpZiAocmV0KSB7DQo+ID4gKyAgICAgICAg
ICAgICAgIHByX2VycigiRmFpbGVkIHRvIHJlZ2lzdGVyIHJuZyBkZXZpY2U6ICVkXG4iLCByZXQp
Ow0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICsgICAgICAgfQ0KPiA+ICsN
Cj4gPiArICAgICAgIHJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IF9f
aW5pdCBtdGtfc2VjX3JuZ19kcml2ZXJfaW5pdCh2b2lkKQ0KPiA+ICt7DQo+ID4gKyAgICAgICBz
dHJ1Y3QgZGV2aWNlX25vZGUgKmZ3X25wOw0KPiA+ICsgICAgICAgc3RydWN0IGRldmljZV9ub2Rl
ICpucDsNCj4gPiArICAgICAgIGNvbnN0IGNoYXIgKm1ldGhvZDsNCj4gPiArDQo+ID4gKyAgICAg
ICBmd19ucCA9IG9mX2ZpbmRfbm9kZV9ieV9uYW1lKE5VTEwsICJmaXJtd2FyZSIpOw0KPiA+ICsg
ICAgICAgaWYgKCFmd19ucCkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+
ID4gKw0KPiA+ICsgICAgICAgbnAgPSBvZl9maW5kX2NvbXBhdGlibGVfbm9kZShmd19ucCwgTlVM
TCwgIm1lZGlhdGVrLG10ay1zZWMtcm5nIik7DQo+ID4gKyAgICAgICBpZiAoIW5wKQ0KPiA+ICsg
ICAgICAgICAgICAgICByZXR1cm4gLUVOT0RFVjsNCj4gPiArDQo+ID4gKyAgICAgICBpZiAob2Zf
cHJvcGVydHlfcmVhZF9zdHJpbmcobnAsICJtZXRob2QiLCAmbWV0aG9kKSkNCj4gPiArICAgICAg
ICAgICAgICAgcmV0dXJuIC1FTlhJTzsNCj4gPiArDQo+ID4gKyAgICAgICBpZiAoc3RybmNtcCgi
c21jIiwgbWV0aG9kLCBzdHJsZW4oInNtYyIpKSkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJu
IC1FSU5WQUw7DQo+ID4gKw0KPiA+ICsgICAgICAgcmV0dXJuIG10a19zZWNfcm5nX3Byb2JlKCk7
DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIF9fZXhpdCBtdGtfc2VjX3JuZ19kcml2
ZXJfZXhpdCh2b2lkKQ0KPiA+ICt7DQo+ID4gKyAgICAgICBod3JuZ191bnJlZ2lzdGVyKCZtdGtf
c2VjX3JuZyk7DQo+ID4gK30NCj4gPiArDQo+ID4gK21vZHVsZV9pbml0KG10a19zZWNfcm5nX2Ry
aXZlcl9pbml0KTsNCj4gPiArbW9kdWxlX2V4aXQobXRrX3NlY19ybmdfZHJpdmVyX2V4aXQpOw0K
PiA+ICsNCj4gPiArTU9EVUxFX0RFU0NSSVBUSU9OKCJNZWRpYVRlayBTZWN1cml0eSBSYW5kb20g
TnVtYmVyIEdlbmVyYXRvciBEcml2ZXIiKTsNCj4gPiArTU9EVUxFX0FVVEhPUigiTmVhbCBMaXUg
PG5lYWwubGl1QG1lZGlhdGVrLmNvbT4iKTsNCj4gPiArTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0K
PiA+IC0tDQo+ID4gMS43LjkuNQ0KPiANCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18NCj4gTGludXgtbWVkaWF0ZWsgbWFpbGluZyBsaXN0DQo+IExpbnV4
LW1lZGlhdGVrQGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gaHR0cDovL2xpc3RzLmluZnJhZGVhZC5v
cmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1tZWRpYXRlaw0KDQo=

