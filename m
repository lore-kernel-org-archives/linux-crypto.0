Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D6FC2D0C9
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 05:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27DDB2465B
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 05:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YCgcz9bc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfLLFNi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 00:13:38 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:57462 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726680AbfLLFNi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 00:13:38 -0500
X-UUID: a90999917e1047b48b74d47f96834312-20191212
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=RH3N4/Myeg9e4TIYQEyUEpEdg2os6y04iBsq0O3Go64=;
        b=YCgcz9bc+PAVRpWHAXIyZ1NulimYwwu15Mo4Okf9w/0MVb64NiMvUGi1XmvxDZe+j7RaUXdGzUity7h2DR8Px9kzYRlPKlAHFvKFI0OqSMnhjLJc8qdgcqS2SYkz00usA/KiJCNr231jgft3wsHcS25VQhGUU3w2bcThmL3cR9o=;
X-UUID: a90999917e1047b48b74d47f96834312-20191212
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 868332676; Thu, 12 Dec 2019 13:13:31 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Dec 2019 13:13:14 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Dec 2019 13:12:53 +0800
Message-ID: <1576127609.27185.8.camel@mtkswgap22>
Subject: Re: [PATCH v5 3/3] hwrng: add mtk-sec-rng driver
From:   Neal Liu <neal.liu@mediatek.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        DTML <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sean Wang <sean.wang@kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-crypto@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Crystal Guo =?UTF-8?Q?=28=E9=83=AD=E6=99=B6=29?= 
        <crystal.guo@mediatek.com>, "Will Deacon" <will@kernel.org>,
        Lars Persson <lists@bofh.nu>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Thu, 12 Dec 2019 13:13:29 +0800
In-Reply-To: <b7043e932211911a81383274e0cc983d@www.loen.fr>
References: <1574864578-467-1-git-send-email-neal.liu@mediatek.com>
         <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
         <CADnJP=uhD=J2NrpSwiX8oCTd-u_q05=HhsAV-ErCsXNDwVS0rA@mail.gmail.com>
         <1575027046.24848.4.camel@mtkswgap22>
         <CAKv+Gu_um7eRYXbieW7ogDX5mmZaxP7JQBJM9CajK+6CsO5RgQ@mail.gmail.com>
         <20191202191146.79e6368c@why>
         <299029b0-0689-c2c4-4656-36ced31ed513@gmail.com>
         <b7043e932211911a81383274e0cc983d@www.loen.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gVHVlLCAyMDE5LTEyLTAzIGF0IDExOjE3ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIDIwMTktMTItMDMgMDQ6MTYsIEZsb3JpYW4gRmFpbmVsbGkgd3JvdGU6DQo+ID4gT24gMTIv
Mi8yMDE5IDExOjExIEFNLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+ID4+IE9uIE1vbiwgMiBEZWMg
MjAxOSAxNjoxMjowOSArMDAwMA0KPiA+PiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxA
bGluYXJvLm9yZz4gd3JvdGU6DQo+ID4+DQo+ID4+PiAoYWRkaW5nIHNvbWUgbW9yZSBhcm02NCBm
b2xrcykNCj4gPj4+DQo+ID4+PiBPbiBGcmksIDI5IE5vdiAyMDE5IGF0IDExOjMwLCBOZWFsIExp
dSA8bmVhbC5saXVAbWVkaWF0ZWsuY29tPiANCj4gPj4+IHdyb3RlOg0KPiA+Pj4+DQo+ID4+Pj4g
T24gRnJpLCAyMDE5LTExLTI5IGF0IDE4OjAyICswODAwLCBMYXJzIFBlcnNzb24gd3JvdGU6DQo+
ID4+Pj4+IEhpIE5lYWwsDQo+ID4+Pj4+DQo+ID4+Pj4+IE9uIFdlZCwgTm92IDI3LCAyMDE5IGF0
IDM6MjMgUE0gTmVhbCBMaXUgPG5lYWwubGl1QG1lZGlhdGVrLmNvbT4gDQo+ID4+Pj4+IHdyb3Rl
Og0KPiA+Pj4+Pj4NCj4gPj4+Pj4+IEZvciBNZWRpYVRlayBTb0NzIG9uIEFSTXY4IHdpdGggVHJ1
c3Rab25lIGVuYWJsZWQsIHBlcmlwaGVyYWxzIA0KPiA+Pj4+Pj4gbGlrZQ0KPiA+Pj4+Pj4gZW50
cm9weSBzb3VyY2VzIGlzIG5vdCBhY2Nlc3NpYmxlIGZyb20gbm9ybWFsIHdvcmxkIChsaW51eCkg
YW5kDQo+ID4+Pj4+PiByYXRoZXIgYWNjZXNzaWJsZSBmcm9tIHNlY3VyZSB3b3JsZCAoQVRGL1RF
RSkgb25seS4gVGhpcyBkcml2ZXIgDQo+ID4+Pj4+PiBhaW1zDQo+ID4+Pj4+PiB0byBwcm92aWRl
IGEgZ2VuZXJpYyBpbnRlcmZhY2UgdG8gQVRGIHJuZyBzZXJ2aWNlLg0KPiA+Pj4+Pj4NCj4gPj4+
Pj4NCj4gPj4+Pj4gSSBhbSB3b3JraW5nIG9uIHNldmVyYWwgU29DcyB0aGF0IGFsc28gd2lsbCBu
ZWVkIHRoaXMga2luZCBvZiANCj4gPj4+Pj4gZHJpdmVyDQo+ID4+Pj4+IHRvIGdldCBlbnRyb3B5
IGZyb20gQXJtIHRydXN0ZWQgZmlybXdhcmUuDQo+ID4+Pj4+IElmIHlvdSBpbnRlbmQgdG8gbWFr
ZSB0aGlzIGEgZ2VuZXJpYyBpbnRlcmZhY2UsIHBsZWFzZSBjbGVhbiB1cCANCj4gPj4+Pj4gdGhl
DQo+ID4+Pj4+IHJlZmVyZW5jZXMgdG8gTWVkaWFUZWsgYW5kIGdpdmUgaXQgYSBtb3JlIGdlbmVy
aWMgbmFtZS4gRm9yIA0KPiA+Pj4+PiBleGFtcGxlDQo+ID4+Pj4+ICJBcm0gVHJ1c3RlZCBGaXJt
d2FyZSByYW5kb20gbnVtYmVyIGRyaXZlciIuDQo+ID4+Pj4+DQo+ID4+Pj4+IEl0IHdpbGwgYWxz
byBiZSBoZWxwZnVsIGlmIHRoZSBTTUMgY2FsbCBudW1iZXIgaXMgY29uZmlndXJhYmxlLg0KPiA+
Pj4+Pg0KPiA+Pj4+PiAtIExhcnMNCj4gPj4+Pg0KPiA+Pj4+IFllcywgSSdtIHRyeWluZyB0byBt
YWtlIHRoaXMgdG8gYSBnZW5lcmljIGludGVyZmFjZS4gSSdsbCB0cnkgdG8gDQo+ID4+Pj4gbWFr
ZQ0KPiA+Pj4+IEhXL3BsYXRmb3JtIHJlbGF0ZWQgZGVwZW5kZW5jeSB0byBiZSBjb25maWd1cmFi
bGUgYW5kIGxldCBpdCBtb3JlDQo+ID4+Pj4gZ2VuZXJpYy4NCj4gPj4+PiBUaGFua3MgZm9yIHlv
dXIgc3VnZ2VzdGlvbi4NCj4gPj4+Pg0KPiA+Pj4NCj4gPj4+IEkgZG9uJ3QgdGhpbmsgaXQgbWFr
ZXMgc2Vuc2UgZm9yIGVhY2ggYXJtNjQgcGxhdGZvcm0gdG8gZXhwb3NlIGFuDQo+ID4+PiBlbnRy
b3B5IHNvdXJjZSB2aWEgU01DIGNhbGxzIGluIGEgc2xpZ2h0bHkgZGlmZmVyZW50IHdheSwgYW5k
IG1vZGVsIA0KPiA+Pj4gaXQNCj4gPj4+IGFzIGEgaC93IGRyaXZlci4gSW5zdGVhZCwgd2Ugc2hv
dWxkIHRyeSB0byBzdGFuZGFyZGl6ZSB0aGlzLCBhbmQNCj4gPj4+IHBlcmhhcHMgZXhwb3NlIGl0
IHZpYSB0aGUgYXJjaGl0ZWN0dXJhbCBoZWxwZXJzIHRoYXQgYWxyZWFkeSBleGlzdA0KPiA+Pj4g
KGdldF9yYW5kb21fc2VlZF9sb25nKCkgYW5kIGZyaWVuZHMpLCBzbyB0aGV5IGdldCBwbHVnZ2Vk
IGludG8gdGhlDQo+ID4+PiBrZXJuZWwgcmFuZG9tIHBvb2wgZHJpdmVyIGRpcmVjdGx5Lg0KPiA+
Pg0KPiA+PiBBYnNvbHV0ZWx5LiBJJ2QgbG92ZSB0byBzZWUgYSBzdGFuZGFyZCwgQVJNLXNwZWNp
ZmllZCwgdmlydHVhbGl6YWJsZQ0KPiA+PiBSTkcgdGhhdCBpcyBhYnN0cmFjdGVkIGZyb20gdGhl
IEhXLg0KPiA+DQo+ID4gRG8geW91IHRoaW5rIHdlIGNvdWxkIHVzZSB2aXJ0aW8tcm5nIG9uIHRv
cCBvZiBhIG1vZGlmaWVkIHZpcnRpby1tbWlvDQo+ID4gd2hpY2ggaW5zdGVhZCBvZiBiZWluZyBi
YWNrZWQgYnkgYSBoYXJkd2FyZSBtYWlsYm94LCBjb3VsZCB1c2UgDQo+ID4gaHZjL3NtYw0KPiA+
IGNhbGxzIHRvIHNpZ25hbCB3cml0ZXMgdG8gc2hhcmVkIG1lbW9yeSBhbmQgZ2V0IG5vdGlmaWNh
dGlvbnMgdmlhIGFuDQo+ID4gaW50ZXJydXB0PyBUaGlzIHdvdWxkIGFsc28gb3BlbiB1cCB0aGUg
ZG9vcnMgdG8gb3RoZXIgdmlydGlvIHVzZXMgDQo+ID4gY2FzZXMNCj4gPiBiZXlvbmQganVzdCBS
TkcgKGUuZy46IGNvbnNvbGUsIGJsb2NrIGRldmljZXM/KS4gSWYgdGhpcyBpcyANCj4gPiBjb21w
bGV0ZWx5DQo+ID4gc3R1cGlkLCB0aGVuIHBsZWFzZSBkaXNyZWdhcmQgdGhpcyBjb21tZW50Lg0K
PiANCj4gVGhlIHByb2JsZW0gd2l0aCBhIHZpcnRpbyBkZXZpY2UgaXMgdGhhdCBpdCBpcyBhIC4u
LiBkZXZpY2UuIFdoYXQgd2UgDQo+IHdhbnQNCj4gaXMgdG8gYmUgYWJsZSB0byBoYXZlIGFjY2Vz
cyB0byBhbiBlbnRyb3B5IHNvdXJjZSBleHRyZW1lbHkgZWFybHkgaW4gDQo+IHRoZQ0KPiBrZXJu
ZWwgbGlmZSwgYW5kIGRldmljZXMgdGVuZCB0byBiZSBhdmFpbGFibGUgcHJldHR5IGxhdGUgaW4g
dGhlIGdhbWUuDQo+IFRoaXMgbWVhbnMgd2UgY2Fubm90IHBsdWcgdGhlbSBpbiB0aGUgYXJjaGl0
ZWN0dXJhbCBoZWxwZXJzIHRoYXQgQXJkDQo+IG1lbnRpb25zIGFib3ZlLg0KPiANCj4gV2hhdCB5
b3UncmUgc3VnZ2VzdGluZyBsb29rcyBtb3JlIGxpa2UgYSBuZXcga2luZCBvZiB2aXJ0aW8gdHJh
bnNwb3J0LA0KPiB3aGljaCBpcyBpbnRlcmVzdGluZywgaW4gYSByZW1hcmthYmx5IHR3aXN0ZWQg
d2F5Li4uIDstKQ0KPiANCj4gVGhhbmtzLA0KPiANCj4gICAgICAgICAgTS4NCg0KSW4gY29uY2x1
c2lvbiwgaXMgaXQgaGVscGZ1bCB0aGF0IGh3X3JhbmRvbSBoYXMgYSBnZW5lcmljIGludGVyZmFj
ZSB0bw0KYWRkIGRldmljZSByYW5kb21uZXNzIGJ5IHRhbGtpbmcgdG8gaHdybmcgd2hpY2ggaXMg
aW1wbGVtZW50ZWQgaW4gdGhlDQpmaXJtd2FyZSBvciB0aGUgaHlwZXJ2aXNvcj8NCkZvciBtb3N0
IGNoaXAgdmVuZG9ycywgSSB0aGluayB0aGUgYW5zd2VyIGlzIHllcy4gV2UgYWxyZWFkeSBwcmVw
YXJlZCBhDQpuZXcgcGF0Y2hzZXQgYW5kIG5lZWQgeW91IGFncmVlIHdpdGggdGhpcyBpZGVhLg0K
DQpUaGFua3MNCg0KLU5lYWwNCg0K

