Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9CCC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 07:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62F162068D
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 07:29:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rsiYpbdr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgFCH3H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 03:29:07 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:6641 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725810AbgFCH3H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 03:29:07 -0400
X-UUID: 46bdbf9e4142415ea62346d624dd87a7-20200603
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=uxJ/OyZIhvn8jO7euhdxxdoo6BqLiSJM0zglxbBqOos=;
        b=rsiYpbdrvrTKk8pW+Ygso90z2A10JD7TpaJ9wdg6yWauTg7OT4Hw6IgcOEpu9vtFhCjL64pw7yMgy2sMrsE8tK5quGWduMsZI+iGlpkM0KyiC0grLkG+7Aq2sOQ2Dqodeo/S/GdP4dGfcFQZX2HhNDZkkobZQerRHTMBp+aW4Ik=;
X-UUID: 46bdbf9e4142415ea62346d624dd87a7-20200603
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 526761993; Wed, 03 Jun 2020 15:29:03 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 3 Jun 2020 15:29:02 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Jun 2020 15:29:01 +0800
Message-ID: <1591169342.4878.9.camel@mtkswgap22>
Subject: Re: Security Random Number Generator support
From:   Neal Liu <neal.liu@mediatek.com>
To:     Marc Zyngier <maz@misterjones.org>,
        Julius Werner <jwerner@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
CC:     Neal Liu <neal.liu@mediatek.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Crystal Guo =?UTF-8?Q?=28=E9=83=AD=E6=99=B6=29?= 
        <Crystal.Guo@mediatek.com>, "Rob Herring" <robh+dt@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Date:   Wed, 3 Jun 2020 15:29:02 +0800
In-Reply-To: <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
         <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
         <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTAyIGF0IDIxOjAyICswODAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIDIwMjAtMDYtMDIgMTM6MTQsIEFyZCBCaWVzaGV1dmVsIHdyb3RlOg0KPiA+IE9uIFR1ZSwg
MiBKdW4gMjAyMCBhdCAxMDoxNSwgTmVhbCBMaXUgPG5lYWwubGl1QG1lZGlhdGVrLmNvbT4gd3Jv
dGU6DQo+ID4+IA0KPiA+PiBUaGVzZSBwYXRjaCBzZXJpZXMgaW50cm9kdWNlIGEgc2VjdXJpdHkg
cmFuZG9tIG51bWJlciBnZW5lcmF0b3INCj4gPj4gd2hpY2ggcHJvdmlkZXMgYSBnZW5lcmljIGlu
dGVyZmFjZSB0byBnZXQgaGFyZHdhcmUgcm5kIGZyb20gU2VjdXJlDQo+ID4+IHN0YXRlLiBUaGUg
U2VjdXJlIHN0YXRlIGNhbiBiZSBBcm0gVHJ1c3RlZCBGaXJtd2FyZShBVEYpLCBUcnVzdGVkDQo+
ID4+IEV4ZWN1dGlvbiBFbnZpcm9ubWVudChURUUpLCBvciBldmVuIEVMMiBoeXBlcnZpc29yLg0K
PiA+PiANCj4gPj4gUGF0Y2ggIzEuLjIgYWRkcyBzZWMtcm5nIGtlcm5lbCBkcml2ZXIgZm9yIFRy
dXN0em9uZSBiYXNlZCBTb0NzLg0KPiA+PiBGb3Igc2VjdXJpdHkgYXdhcmVuZXNzIFNvQ3Mgb24g
QVJNdjggd2l0aCBUcnVzdFpvbmUgZW5hYmxlZCwNCj4gPj4gcGVyaXBoZXJhbHMgbGlrZSBlbnRy
b3B5IHNvdXJjZXMgaXMgbm90IGFjY2Vzc2libGUgZnJvbSBub3JtYWwgd29ybGQNCj4gPj4gKGxp
bnV4KSBhbmQgcmF0aGVyIGFjY2Vzc2libGUgZnJvbSBzZWN1cmUgd29ybGQgKEhZUC9BVEYvVEVF
KSBvbmx5Lg0KPiA+PiBUaGlzIGRyaXZlciBhaW1zIHRvIHByb3ZpZGUgYSBnZW5lcmljIGludGVy
ZmFjZSB0byBBcm0gVHJ1c3RlZA0KPiA+PiBGaXJtd2FyZSBvciBIeXBlcnZpc29yIHJuZyBzZXJ2
aWNlLg0KPiA+PiANCj4gPj4gDQo+ID4+IGNoYW5nZXMgc2luY2UgdjE6DQo+ID4+IC0gcmVuYW1l
IG10Njd4eC1ybmcgdG8gbXRrLXNlYy1ybmcgc2luY2UgYWxsIE1lZGlhVGVrIEFSTXY4IFNvQ3Mg
Y2FuIA0KPiA+PiByZXVzZQ0KPiA+PiAgIHRoaXMgZHJpdmVyLg0KPiA+PiAgIC0gcmVmaW5lIGNv
ZGluZyBzdHlsZSBhbmQgdW5uZWNlc3NhcnkgY2hlY2suDQo+ID4+IA0KPiA+PiAgIGNoYW5nZXMg
c2luY2UgdjI6DQo+ID4+ICAgLSByZW1vdmUgdW51c2VkIGNvbW1lbnRzLg0KPiA+PiAgIC0gcmVt
b3ZlIHJlZHVuZGFudCB2YXJpYWJsZS4NCj4gPj4gDQo+ID4+ICAgY2hhbmdlcyBzaW5jZSB2MzoN
Cj4gPj4gICAtIGFkZCBkdC1iaW5kaW5ncyBmb3IgTWVkaWFUZWsgcm5nIHdpdGggVHJ1c3Rab25l
IGVuYWJsZWQuDQo+ID4+ICAgLSByZXZpc2UgSFdSTkcgU01DIGNhbGwgZmlkLg0KPiA+PiANCj4g
Pj4gICBjaGFuZ2VzIHNpbmNlIHY0Og0KPiA+PiAgIC0gbW92ZSBiaW5kaW5ncyB0byB0aGUgYXJt
L2Zpcm13YXJlIGRpcmVjdG9yeS4NCj4gPj4gICAtIHJldmlzZSBkcml2ZXIgaW5pdCBmbG93IHRv
IGNoZWNrIG1vcmUgcHJvcGVydHkuDQo+ID4+IA0KPiA+PiAgIGNoYW5nZXMgc2luY2UgdjU6DQo+
ID4+ICAgLSByZWZhY3RvciB0byBtb3JlIGdlbmVyaWMgc2VjdXJpdHkgcm5nIGRyaXZlciB3aGlj
aA0KPiA+PiAgICAgaXMgbm90IHBsYXRmb3JtIHNwZWNpZmljLg0KPiA+PiANCj4gPj4gKioqIEJM
VVJCIEhFUkUgKioqDQo+ID4+IA0KPiA+PiBOZWFsIExpdSAoMik6DQo+ID4+ICAgZHQtYmluZGlu
Z3M6IHJuZzogYWRkIGJpbmRpbmdzIGZvciBzZWMtcm5nDQo+ID4+ICAgaHdybmc6IGFkZCBzZWMt
cm5nIGRyaXZlcg0KPiA+PiANCj4gPiANCj4gPiBUaGVyZSBpcyBubyByZWFzb24gdG8gbW9kZWwg
YSBTTUMgY2FsbCBhcyBhIGRyaXZlciwgYW5kIHJlcHJlc2VudCBpdA0KPiA+IHZpYSBhIERUIG5v
ZGUgbGlrZSB0aGlzLg0KPiANCj4gKzEuDQo+IA0KPiA+IEl0IHdvdWxkIGJlIG11Y2ggYmV0dGVy
IGlmIHRoaXMgU01DIGludGVyZmFjZSBpcyBtYWRlIHRydWx5IGdlbmVyaWMsDQo+ID4gYW5kIHdp
cmVkIGludG8gdGhlIGFyY2hfZ2V0X3JhbmRvbSgpIGludGVyZmFjZSwgd2hpY2ggY2FuIGJlIHVz
ZWQgbXVjaA0KPiA+IGVhcmxpZXIuDQo+IA0KPiBXYXNuJ3QgdGhlcmUgYSBwbGFuIHRvIHN0YW5k
YXJkaXplIGEgU01DIGNhbGwgdG8gcnVsZSB0aGVtIGFsbD8NCj4gDQo+ICAgICAgICAgIE0uDQoN
CkNvdWxkIHlvdSBnaXZlIHVzIGEgaGludCBob3cgdG8gbWFrZSB0aGlzIFNNQyBpbnRlcmZhY2Ug
bW9yZSBnZW5lcmljIGluDQphZGRpdGlvbiB0byBteSBhcHByb2FjaD8NClRoZXJlIGlzIG5vIChl
YXN5KSB3YXkgdG8gZ2V0IHBsYXRmb3JtLWluZGVwZW5kZW50IFNNQyBmdW5jdGlvbiBJRCwNCndo
aWNoIGlzIHdoeSB3ZSBlbmNvZGUgaXQgaW50byBkZXZpY2UgdHJlZSwgYW5kIHByb3ZpZGUgYSBn
ZW5lcmljDQpkcml2ZXIuIEluIHRoaXMgd2F5LCBkaWZmZXJlbnQgZGV2aWNlcyBjYW4gYmUgbWFw
cGVkIGFuZCB0aGVuIGdldA0KZGlmZmVyZW50IGZ1bmN0aW9uIElEIGludGVybmFsbHkuDQoNCg0K

