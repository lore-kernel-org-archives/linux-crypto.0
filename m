Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF88CC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 08:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB913206C3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 08:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BnoTwQqr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgFCIBR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 04:01:17 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:62375 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725275AbgFCIBQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 04:01:16 -0400
X-UUID: 4ca35eb9f2224bd58242cb8ba52937b9-20200603
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=07Kpr56aB3PFy6IWckMxSvdLdNklg9y3xgmgR9sXxKc=;
        b=BnoTwQqrI6c5pqUfBu6bW3IvXyHAyvA2720ByQBW2kMzuPTryV1OGWaGW6EPN/d+JDnayq5Aq++yoKmI5BFbYVhUO3hzR4KoXB9ig3nXUowlX/lB/GGbYbOOpPbvfTXCkU4HuBmzJu/JXrzBmjs763u2UubjwrzS2u0vValEcJk=;
X-UUID: 4ca35eb9f2224bd58242cb8ba52937b9-20200603
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 172606472; Wed, 03 Jun 2020 15:54:18 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 3 Jun 2020 15:54:16 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Jun 2020 15:54:16 +0800
Message-ID: <1591170857.19414.5.camel@mtkswgap22>
Subject: Re: Security Random Number Generator support
From:   Neal Liu <neal.liu@mediatek.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     Neal Liu <neal.liu@mediatek.com>,
        Julius Werner <jwerner@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Crystal Guo =?UTF-8?Q?=28=E9=83=AD=E6=99=B6=29?= 
        <Crystal.Guo@mediatek.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Date:   Wed, 3 Jun 2020 15:54:17 +0800
In-Reply-To: <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
         <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
         <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
         <1591169342.4878.9.camel@mtkswgap22>
         <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gV2VkLCAyMDIwLTA2LTAzIGF0IDA4OjQwICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIDIwMjAtMDYtMDMgMDg6MjksIE5lYWwgTGl1IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMC0w
Ni0wMiBhdCAyMTowMiArMDgwMCwgTWFyYyBaeW5naWVyIHdyb3RlOg0KPiA+PiBPbiAyMDIwLTA2
LTAyIDEzOjE0LCBBcmQgQmllc2hldXZlbCB3cm90ZToNCj4gPj4gPiBPbiBUdWUsIDIgSnVuIDIw
MjAgYXQgMTA6MTUsIE5lYWwgTGl1IDxuZWFsLmxpdUBtZWRpYXRlay5jb20+IHdyb3RlOg0KPiA+
PiA+Pg0KPiA+PiA+PiBUaGVzZSBwYXRjaCBzZXJpZXMgaW50cm9kdWNlIGEgc2VjdXJpdHkgcmFu
ZG9tIG51bWJlciBnZW5lcmF0b3INCj4gPj4gPj4gd2hpY2ggcHJvdmlkZXMgYSBnZW5lcmljIGlu
dGVyZmFjZSB0byBnZXQgaGFyZHdhcmUgcm5kIGZyb20gU2VjdXJlDQo+ID4+ID4+IHN0YXRlLiBU
aGUgU2VjdXJlIHN0YXRlIGNhbiBiZSBBcm0gVHJ1c3RlZCBGaXJtd2FyZShBVEYpLCBUcnVzdGVk
DQo+ID4+ID4+IEV4ZWN1dGlvbiBFbnZpcm9ubWVudChURUUpLCBvciBldmVuIEVMMiBoeXBlcnZp
c29yLg0KPiA+PiA+Pg0KPiA+PiA+PiBQYXRjaCAjMS4uMiBhZGRzIHNlYy1ybmcga2VybmVsIGRy
aXZlciBmb3IgVHJ1c3R6b25lIGJhc2VkIFNvQ3MuDQo+ID4+ID4+IEZvciBzZWN1cml0eSBhd2Fy
ZW5lc3MgU29DcyBvbiBBUk12OCB3aXRoIFRydXN0Wm9uZSBlbmFibGVkLA0KPiA+PiA+PiBwZXJp
cGhlcmFscyBsaWtlIGVudHJvcHkgc291cmNlcyBpcyBub3QgYWNjZXNzaWJsZSBmcm9tIG5vcm1h
bCB3b3JsZA0KPiA+PiA+PiAobGludXgpIGFuZCByYXRoZXIgYWNjZXNzaWJsZSBmcm9tIHNlY3Vy
ZSB3b3JsZCAoSFlQL0FURi9URUUpIG9ubHkuDQo+ID4+ID4+IFRoaXMgZHJpdmVyIGFpbXMgdG8g
cHJvdmlkZSBhIGdlbmVyaWMgaW50ZXJmYWNlIHRvIEFybSBUcnVzdGVkDQo+ID4+ID4+IEZpcm13
YXJlIG9yIEh5cGVydmlzb3Igcm5nIHNlcnZpY2UuDQo+ID4+ID4+DQo+ID4+ID4+DQo+ID4+ID4+
IGNoYW5nZXMgc2luY2UgdjE6DQo+ID4+ID4+IC0gcmVuYW1lIG10Njd4eC1ybmcgdG8gbXRrLXNl
Yy1ybmcgc2luY2UgYWxsIE1lZGlhVGVrIEFSTXY4IFNvQ3MgY2FuDQo+ID4+ID4+IHJldXNlDQo+
ID4+ID4+ICAgdGhpcyBkcml2ZXIuDQo+ID4+ID4+ICAgLSByZWZpbmUgY29kaW5nIHN0eWxlIGFu
ZCB1bm5lY2Vzc2FyeSBjaGVjay4NCj4gPj4gPj4NCj4gPj4gPj4gICBjaGFuZ2VzIHNpbmNlIHYy
Og0KPiA+PiA+PiAgIC0gcmVtb3ZlIHVudXNlZCBjb21tZW50cy4NCj4gPj4gPj4gICAtIHJlbW92
ZSByZWR1bmRhbnQgdmFyaWFibGUuDQo+ID4+ID4+DQo+ID4+ID4+ICAgY2hhbmdlcyBzaW5jZSB2
MzoNCj4gPj4gPj4gICAtIGFkZCBkdC1iaW5kaW5ncyBmb3IgTWVkaWFUZWsgcm5nIHdpdGggVHJ1
c3Rab25lIGVuYWJsZWQuDQo+ID4+ID4+ICAgLSByZXZpc2UgSFdSTkcgU01DIGNhbGwgZmlkLg0K
PiA+PiA+Pg0KPiA+PiA+PiAgIGNoYW5nZXMgc2luY2UgdjQ6DQo+ID4+ID4+ICAgLSBtb3ZlIGJp
bmRpbmdzIHRvIHRoZSBhcm0vZmlybXdhcmUgZGlyZWN0b3J5Lg0KPiA+PiA+PiAgIC0gcmV2aXNl
IGRyaXZlciBpbml0IGZsb3cgdG8gY2hlY2sgbW9yZSBwcm9wZXJ0eS4NCj4gPj4gPj4NCj4gPj4g
Pj4gICBjaGFuZ2VzIHNpbmNlIHY1Og0KPiA+PiA+PiAgIC0gcmVmYWN0b3IgdG8gbW9yZSBnZW5l
cmljIHNlY3VyaXR5IHJuZyBkcml2ZXIgd2hpY2gNCj4gPj4gPj4gICAgIGlzIG5vdCBwbGF0Zm9y
bSBzcGVjaWZpYy4NCj4gPj4gPj4NCj4gPj4gPj4gKioqIEJMVVJCIEhFUkUgKioqDQo+ID4+ID4+
DQo+ID4+ID4+IE5lYWwgTGl1ICgyKToNCj4gPj4gPj4gICBkdC1iaW5kaW5nczogcm5nOiBhZGQg
YmluZGluZ3MgZm9yIHNlYy1ybmcNCj4gPj4gPj4gICBod3JuZzogYWRkIHNlYy1ybmcgZHJpdmVy
DQo+ID4+ID4+DQo+ID4+ID4NCj4gPj4gPiBUaGVyZSBpcyBubyByZWFzb24gdG8gbW9kZWwgYSBT
TUMgY2FsbCBhcyBhIGRyaXZlciwgYW5kIHJlcHJlc2VudCBpdA0KPiA+PiA+IHZpYSBhIERUIG5v
ZGUgbGlrZSB0aGlzLg0KPiA+PiANCj4gPj4gKzEuDQo+ID4+IA0KPiA+PiA+IEl0IHdvdWxkIGJl
IG11Y2ggYmV0dGVyIGlmIHRoaXMgU01DIGludGVyZmFjZSBpcyBtYWRlIHRydWx5IGdlbmVyaWMs
DQo+ID4+ID4gYW5kIHdpcmVkIGludG8gdGhlIGFyY2hfZ2V0X3JhbmRvbSgpIGludGVyZmFjZSwg
d2hpY2ggY2FuIGJlIHVzZWQgbXVjaA0KPiA+PiA+IGVhcmxpZXIuDQo+ID4+IA0KPiA+PiBXYXNu
J3QgdGhlcmUgYSBwbGFuIHRvIHN0YW5kYXJkaXplIGEgU01DIGNhbGwgdG8gcnVsZSB0aGVtIGFs
bD8NCj4gPj4gDQo+ID4+ICAgICAgICAgIE0uDQo+ID4gDQo+ID4gQ291bGQgeW91IGdpdmUgdXMg
YSBoaW50IGhvdyB0byBtYWtlIHRoaXMgU01DIGludGVyZmFjZSBtb3JlIGdlbmVyaWMgaW4NCj4g
PiBhZGRpdGlvbiB0byBteSBhcHByb2FjaD8NCj4gPiBUaGVyZSBpcyBubyAoZWFzeSkgd2F5IHRv
IGdldCBwbGF0Zm9ybS1pbmRlcGVuZGVudCBTTUMgZnVuY3Rpb24gSUQsDQo+ID4gd2hpY2ggaXMg
d2h5IHdlIGVuY29kZSBpdCBpbnRvIGRldmljZSB0cmVlLCBhbmQgcHJvdmlkZSBhIGdlbmVyaWMN
Cj4gPiBkcml2ZXIuIEluIHRoaXMgd2F5LCBkaWZmZXJlbnQgZGV2aWNlcyBjYW4gYmUgbWFwcGVk
IGFuZCB0aGVuIGdldA0KPiA+IGRpZmZlcmVudCBmdW5jdGlvbiBJRCBpbnRlcm5hbGx5Lg0KPiAN
Cj4gVGhlIGlkZWEgaXMgc2ltcGx5IHRvIGhhdmUgKm9uZSogc2luZ2xlIElEIHRoYXQgY2F0ZXJz
IGZvciBhbGwNCj4gaW1wbGVtZW50YXRpb25zLCBqdXN0IGxpa2Ugd2UgZGlkIGZvciBQU0NJIGF0
IHRoZSB0aW1lLiBUaGlzDQo+IHJlcXVpcmVzIEFSTSB0byBlZGljdCBhIHN0YW5kYXJkLCB3aGlj
aCBpcyB3aGF0IEkgd2FzIHJlZmVycmluZw0KPiB0byBhYm92ZS4NCj4gDQo+IFRoZXJlIGlzIHpl
cm8gYmVuZWZpdCBpbiBoYXZpbmcgYSBwbGF0Zm9ybS1kZXBlbmRlbnQgSUQuIEl0IGp1c3QNCj4g
cG9pbnRsZXNzbHkgaW5jcmVhc2VzIGNvbXBsZXhpdHksIGFuZCBtZWFucyB3ZSBjYW5ub3QgdXNl
IHRoZSBSTkcNCj4gYmVmb3JlIHRoZSBmaXJtd2FyZSB0YWJsZXMgYXJlIGF2YWlsYWJsZSAoeWVz
LCB3ZSBuZWVkIGl0IHRoYXQNCj4gZWFybHkpLg0KPiANCj4gICAgICAgICAgTS4NCg0KRG8geW91
IGtub3cgd2hpY2ggQVJNIGV4cGVydCBjb3VsZCBlZGljdCB0aGlzIHN0YW5kYXJkPw0KT3IgaXMg
dGhlcmUgYW55IGNoYW5jZSB0aGF0IHdlIGNhbiBtYWtlIG9uZT8gQW5kIGJlIHJldmlld2VkIGJ5
DQptYWludGFpbmVycz8NCg0KDQo=

