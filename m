Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA9FC433E4
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 07:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 064F3206E6
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 07:19:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pkSJ4qjn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgFEHTN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 03:19:13 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:52162 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725280AbgFEHTM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 03:19:12 -0400
X-UUID: ba4e6b62c5944400a14738fa76b5e78b-20200605
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=19vrRMWmwFaMyOZYFFMoP+8hHxPd3vzl6HzvP+kgneA=;
        b=pkSJ4qjn5Aj54DqVDsthFFeFeI6lpzQTgLZdOWyyIhouzbwjR2Pj2zlKMEiSXFIYfoiUdqr6YoMSq8x/atjwjuSVIPnwMXGm6NqokpUEs8rqIbRBmmqU2l96uVKnTRd2PWqYGoK7z+oZg1QK1RExZjgZOHniN/rfvB3pIWpUcBQ=;
X-UUID: ba4e6b62c5944400a14738fa76b5e78b-20200605
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1814770406; Fri, 05 Jun 2020 15:19:05 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 5 Jun 2020 15:19:03 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Jun 2020 15:19:02 +0800
Message-ID: <1591341543.19510.4.camel@mtkswgap22>
Subject: Re: Security Random Number Generator support
From:   Neal Liu <neal.liu@mediatek.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>
CC:     Neal Liu <neal.liu@mediatek.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Julius Werner <jwerner@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Ard Biesheuvel <ardb@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Date:   Fri, 5 Jun 2020 15:19:03 +0800
In-Reply-To: <20200603093416.GY1551@shell.armlinux.org.uk>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
         <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
         <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
         <1591169342.4878.9.camel@mtkswgap22>
         <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
         <20200603093416.GY1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 57A0643566E8C5377AB748C11626465C1385BB50C574232E8C6EF02F5FB61C3F2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gV2VkLCAyMDIwLTA2LTAzIGF0IDE3OjM0ICswODAwLCBSdXNzZWxsIEtpbmcgLSBBUk0gTGlu
dXggYWRtaW4gd3JvdGU6DQo+IE9uIFdlZCwgSnVuIDAzLCAyMDIwIGF0IDA4OjQwOjU4QU0gKzAx
MDAsIE1hcmMgWnluZ2llciB3cm90ZToNCj4gPiBPbiAyMDIwLTA2LTAzIDA4OjI5LCBOZWFsIExp
dSB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgMjAyMC0wNi0wMiBhdCAyMTowMiArMDgwMCwgTWFyYyBa
eW5naWVyIHdyb3RlOg0KPiA+ID4gPiBPbiAyMDIwLTA2LTAyIDEzOjE0LCBBcmQgQmllc2hldXZl
bCB3cm90ZToNCj4gPiA+ID4gPiBPbiBUdWUsIDIgSnVuIDIwMjAgYXQgMTA6MTUsIE5lYWwgTGl1
IDxuZWFsLmxpdUBtZWRpYXRlay5jb20+IHdyb3RlOg0KPiA+ID4gPiA+Pg0KPiA+ID4gPiA+PiBU
aGVzZSBwYXRjaCBzZXJpZXMgaW50cm9kdWNlIGEgc2VjdXJpdHkgcmFuZG9tIG51bWJlciBnZW5l
cmF0b3INCj4gPiA+ID4gPj4gd2hpY2ggcHJvdmlkZXMgYSBnZW5lcmljIGludGVyZmFjZSB0byBn
ZXQgaGFyZHdhcmUgcm5kIGZyb20gU2VjdXJlDQo+ID4gPiA+ID4+IHN0YXRlLiBUaGUgU2VjdXJl
IHN0YXRlIGNhbiBiZSBBcm0gVHJ1c3RlZCBGaXJtd2FyZShBVEYpLCBUcnVzdGVkDQo+ID4gPiA+
ID4+IEV4ZWN1dGlvbiBFbnZpcm9ubWVudChURUUpLCBvciBldmVuIEVMMiBoeXBlcnZpc29yLg0K
PiA+ID4gPiA+Pg0KPiA+ID4gPiA+PiBQYXRjaCAjMS4uMiBhZGRzIHNlYy1ybmcga2VybmVsIGRy
aXZlciBmb3IgVHJ1c3R6b25lIGJhc2VkIFNvQ3MuDQo+ID4gPiA+ID4+IEZvciBzZWN1cml0eSBh
d2FyZW5lc3MgU29DcyBvbiBBUk12OCB3aXRoIFRydXN0Wm9uZSBlbmFibGVkLA0KPiA+ID4gPiA+
PiBwZXJpcGhlcmFscyBsaWtlIGVudHJvcHkgc291cmNlcyBpcyBub3QgYWNjZXNzaWJsZSBmcm9t
IG5vcm1hbCB3b3JsZA0KPiA+ID4gPiA+PiAobGludXgpIGFuZCByYXRoZXIgYWNjZXNzaWJsZSBm
cm9tIHNlY3VyZSB3b3JsZCAoSFlQL0FURi9URUUpIG9ubHkuDQo+ID4gPiA+ID4+IFRoaXMgZHJp
dmVyIGFpbXMgdG8gcHJvdmlkZSBhIGdlbmVyaWMgaW50ZXJmYWNlIHRvIEFybSBUcnVzdGVkDQo+
ID4gPiA+ID4+IEZpcm13YXJlIG9yIEh5cGVydmlzb3Igcm5nIHNlcnZpY2UuDQo+ID4gPiA+ID4+
DQo+ID4gPiA+ID4+DQo+ID4gPiA+ID4+IGNoYW5nZXMgc2luY2UgdjE6DQo+ID4gPiA+ID4+IC0g
cmVuYW1lIG10Njd4eC1ybmcgdG8gbXRrLXNlYy1ybmcgc2luY2UgYWxsIE1lZGlhVGVrIEFSTXY4
IFNvQ3MgY2FuDQo+ID4gPiA+ID4+IHJldXNlDQo+ID4gPiA+ID4+ICAgdGhpcyBkcml2ZXIuDQo+
ID4gPiA+ID4+ICAgLSByZWZpbmUgY29kaW5nIHN0eWxlIGFuZCB1bm5lY2Vzc2FyeSBjaGVjay4N
Cj4gPiA+ID4gPj4NCj4gPiA+ID4gPj4gICBjaGFuZ2VzIHNpbmNlIHYyOg0KPiA+ID4gPiA+PiAg
IC0gcmVtb3ZlIHVudXNlZCBjb21tZW50cy4NCj4gPiA+ID4gPj4gICAtIHJlbW92ZSByZWR1bmRh
bnQgdmFyaWFibGUuDQo+ID4gPiA+ID4+DQo+ID4gPiA+ID4+ICAgY2hhbmdlcyBzaW5jZSB2MzoN
Cj4gPiA+ID4gPj4gICAtIGFkZCBkdC1iaW5kaW5ncyBmb3IgTWVkaWFUZWsgcm5nIHdpdGggVHJ1
c3Rab25lIGVuYWJsZWQuDQo+ID4gPiA+ID4+ICAgLSByZXZpc2UgSFdSTkcgU01DIGNhbGwgZmlk
Lg0KPiA+ID4gPiA+Pg0KPiA+ID4gPiA+PiAgIGNoYW5nZXMgc2luY2UgdjQ6DQo+ID4gPiA+ID4+
ICAgLSBtb3ZlIGJpbmRpbmdzIHRvIHRoZSBhcm0vZmlybXdhcmUgZGlyZWN0b3J5Lg0KPiA+ID4g
PiA+PiAgIC0gcmV2aXNlIGRyaXZlciBpbml0IGZsb3cgdG8gY2hlY2sgbW9yZSBwcm9wZXJ0eS4N
Cj4gPiA+ID4gPj4NCj4gPiA+ID4gPj4gICBjaGFuZ2VzIHNpbmNlIHY1Og0KPiA+ID4gPiA+PiAg
IC0gcmVmYWN0b3IgdG8gbW9yZSBnZW5lcmljIHNlY3VyaXR5IHJuZyBkcml2ZXIgd2hpY2gNCj4g
PiA+ID4gPj4gICAgIGlzIG5vdCBwbGF0Zm9ybSBzcGVjaWZpYy4NCj4gPiA+ID4gPj4NCj4gPiA+
ID4gPj4gKioqIEJMVVJCIEhFUkUgKioqDQo+ID4gPiA+ID4+DQo+ID4gPiA+ID4+IE5lYWwgTGl1
ICgyKToNCj4gPiA+ID4gPj4gICBkdC1iaW5kaW5nczogcm5nOiBhZGQgYmluZGluZ3MgZm9yIHNl
Yy1ybmcNCj4gPiA+ID4gPj4gICBod3JuZzogYWRkIHNlYy1ybmcgZHJpdmVyDQo+ID4gPiA+ID4+
DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGVyZSBpcyBubyByZWFzb24gdG8gbW9kZWwgYSBTTUMg
Y2FsbCBhcyBhIGRyaXZlciwgYW5kIHJlcHJlc2VudCBpdA0KPiA+ID4gPiA+IHZpYSBhIERUIG5v
ZGUgbGlrZSB0aGlzLg0KPiA+ID4gPiANCj4gPiA+ID4gKzEuDQo+ID4gPiA+IA0KPiA+ID4gPiA+
IEl0IHdvdWxkIGJlIG11Y2ggYmV0dGVyIGlmIHRoaXMgU01DIGludGVyZmFjZSBpcyBtYWRlIHRy
dWx5IGdlbmVyaWMsDQo+ID4gPiA+ID4gYW5kIHdpcmVkIGludG8gdGhlIGFyY2hfZ2V0X3JhbmRv
bSgpIGludGVyZmFjZSwgd2hpY2ggY2FuIGJlIHVzZWQgbXVjaA0KPiA+ID4gPiA+IGVhcmxpZXIu
DQo+ID4gPiA+IA0KPiA+ID4gPiBXYXNuJ3QgdGhlcmUgYSBwbGFuIHRvIHN0YW5kYXJkaXplIGEg
U01DIGNhbGwgdG8gcnVsZSB0aGVtIGFsbD8NCj4gPiA+ID4gDQo+ID4gPiA+ICAgICAgICAgIE0u
DQo+ID4gPiANCj4gPiA+IENvdWxkIHlvdSBnaXZlIHVzIGEgaGludCBob3cgdG8gbWFrZSB0aGlz
IFNNQyBpbnRlcmZhY2UgbW9yZSBnZW5lcmljIGluDQo+ID4gPiBhZGRpdGlvbiB0byBteSBhcHBy
b2FjaD8NCj4gPiA+IFRoZXJlIGlzIG5vIChlYXN5KSB3YXkgdG8gZ2V0IHBsYXRmb3JtLWluZGVw
ZW5kZW50IFNNQyBmdW5jdGlvbiBJRCwNCj4gPiA+IHdoaWNoIGlzIHdoeSB3ZSBlbmNvZGUgaXQg
aW50byBkZXZpY2UgdHJlZSwgYW5kIHByb3ZpZGUgYSBnZW5lcmljDQo+ID4gPiBkcml2ZXIuIElu
IHRoaXMgd2F5LCBkaWZmZXJlbnQgZGV2aWNlcyBjYW4gYmUgbWFwcGVkIGFuZCB0aGVuIGdldA0K
PiA+ID4gZGlmZmVyZW50IGZ1bmN0aW9uIElEIGludGVybmFsbHkuDQo+ID4gDQo+ID4gVGhlIGlk
ZWEgaXMgc2ltcGx5IHRvIGhhdmUgKm9uZSogc2luZ2xlIElEIHRoYXQgY2F0ZXJzIGZvciBhbGwN
Cj4gPiBpbXBsZW1lbnRhdGlvbnMsIGp1c3QgbGlrZSB3ZSBkaWQgZm9yIFBTQ0kgYXQgdGhlIHRp
bWUuIFRoaXMNCj4gPiByZXF1aXJlcyBBUk0gdG8gZWRpY3QgYSBzdGFuZGFyZCwgd2hpY2ggaXMg
d2hhdCBJIHdhcyByZWZlcnJpbmcNCj4gPiB0byBhYm92ZS4NCj4gDQo+IFRoaXMgc291bmRzIGFs
bCB0b28gZmFtaWxpYXIuDQo+IA0KPiBUaGlzIGtpbmQgb2YgdGhpbmcgaXMgc29tZXRoaW5nIHRo
YXQgQVJNIGhhdmUgc2VlbXMgdG8gc2h5IGF3YXkgZnJvbQ0KPiBkb2luZyAtIGl0J3MgYSBwb2lu
dCBJIGJyb3VnaHQgdXAgbWFueSB5ZWFycyBhZ28gd2hlbiB0aGUgd2hvbGUNCj4gdHJ1c3R6b25l
IHRoaW5nIGZpcnN0IGFwcGVhcmVkIHdpdGggaXRzIFNNQyBjYWxsLiAgVGhvc2UgYXJvdW5kIHRo
ZQ0KPiBjb25mZXJlbmNlIHRhYmxlIHdlcmUgbm90IGludGVyZXN0ZWQgLSBBUk0gc2VlbWVkIHRv
IHByZWZlciBldmVyeQ0KPiB2ZW5kb3IgdG8gZG8gb2ZmIGFuZCBkbyB0aGVpciBvd24gdGhpbmcg
d2l0aCB0aGUgU01DIGludGVyZmFjZS4NCg0KRG9lcyB0aGF0IG1lYW4gaXQgbWFrZSBzZW5zZSB0
byBtb2RlbCBhIHNlYy1ybmcgZHJpdmVyLCBhbmQgZ2V0IGVhY2gNCnZlbmRvcidzIFNNQyBmdW5j
dGlvbiBpZCBieSBEVCBub2RlPw0KDQo+IA0KPiBUaGVuIE9NQVAgY2FtZSBhbG9uZyB3aXRoIGl0
cyBTTUMgaW50ZXJmYWNlcywgYW5kIHNvIGRpZCB0aGUgcGFpbiBvZg0KPiBub3QgaGF2aW5nIGEg
c3RhbmRhcmRpc2VkIHdheSB0byBjb25maWd1cmUgdGhlIEwyQyB3aGVuIExpbnV4IHdhcw0KPiBy
dW5uaW5nIGluIHRoZSBub24tc2VjdXJlIHdvcmxkLCByZXN1bHRpbmcgaW4gc3R1ZmYgbGlrZSBs
MmNfY29uZmlndXJlDQo+IGV0Yywgd2hlcmUgZWFjaCBhbmQgZXZlcnkgaW1wbGVtZW50YXRpb24g
aGFzIHRvIHN1cHBseSBhIGZ1bmN0aW9uIHRvDQo+IGNhbGwgaXRzIHBsYXRmb3JtIHNwZWNpZmlj
IFNNQyBpbnRlcmZhY2VzIHRvIGNvbmZpZ3VyZSBhIHBpZWNlIG9mDQo+IGhhcmR3YXJlIGNvbW1v
biBhY3Jvc3MgbWFueSBkaWZmZXJlbnQgcGxhdGZvcm1zLg0KPiANCj4gQVJNIGhhdmUgc2VlbWVk
IHJlbHVjdGFudCB0byBzdGFuZGFyZGlzZSBvbiBzdHVmZiBsaWtlIHRoaXMsIHNvDQo+IHVubGVz
cyBzb21lb25lIHB1c2hlcyBoYXJkIGZvciBpdCBmcm9tIGluc2lkZSBBUk0sIEkgZG91YnQgaXQg
d2lsbA0KPiBldmVyIGhhcHBlbi4NCj4gDQoNCg0K

