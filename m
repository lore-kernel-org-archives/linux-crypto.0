Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8373FC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 09:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6167A207D0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 09:00:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ls9R6n9I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgFEI77 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 04:59:59 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:16731 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726234AbgFEI7z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 04:59:55 -0400
X-UUID: 181c308322e744dd9a70e2bccac836e6-20200605
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=VjXux5WMEXt+SNJUOpjSrCg/TII0W/Rj7aI7a6xVHpE=;
        b=ls9R6n9IGXDUKqpHS5IXQejgeStm7Hy3+RXWs4hTJ+knZzsD4Aj62NTea3yFMY7uIt/Cx9DNQ051TNBTkashYSbBdUJw9kVVg0KNw/5u0eXPOEut2d+yF3+spTGiZ6k0hKFYz/p2IE3avUG0c/DpU/75Uhtw2dsTCwaVZ+FZ+3g=;
X-UUID: 181c308322e744dd9a70e2bccac836e6-20200605
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 678270201; Fri, 05 Jun 2020 16:59:50 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 5 Jun 2020 16:59:42 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Jun 2020 16:59:42 +0800
Message-ID: <1591347582.21704.9.camel@mtkswgap22>
Subject: Re: Security Random Number Generator support
From:   Neal Liu <neal.liu@mediatek.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Marc Zyngier <maz@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Julius Werner <jwerner@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Crystal Guo =?UTF-8?Q?=28=E9=83=AD=E6=99=B6=29?= 
        <Crystal.Guo@mediatek.com>, "Ard Biesheuvel" <ardb@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Date:   Fri, 5 Jun 2020 16:59:42 +0800
In-Reply-To: <20200605080905.GF1551@shell.armlinux.org.uk>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
         <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
         <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
         <1591169342.4878.9.camel@mtkswgap22>
         <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
         <20200603093416.GY1551@shell.armlinux.org.uk>
         <1591341543.19510.4.camel@mtkswgap22>
         <20200605080905.GF1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 877F0A62BB37F3A937A5DF7C63E4C12D4C5FEB8F623D563618F2A16D037472AE2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gRnJpLCAyMDIwLTA2LTA1IGF0IDA5OjA5ICswMTAwLCBSdXNzZWxsIEtpbmcgLSBBUk0gTGlu
dXggYWRtaW4gd3JvdGU6DQo+IE9uIEZyaSwgSnVuIDA1LCAyMDIwIGF0IDAzOjE5OjAzUE0gKzA4
MDAsIE5lYWwgTGl1IHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAyMC0wNi0wMyBhdCAxNzozNCArMDgw
MCwgUnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4IGFkbWluIHdyb3RlOg0KPiA+ID4gVGhpcyBraW5k
IG9mIHRoaW5nIGlzIHNvbWV0aGluZyB0aGF0IEFSTSBoYXZlIHNlZW1zIHRvIHNoeSBhd2F5IGZy
b20NCj4gPiA+IGRvaW5nIC0gaXQncyBhIHBvaW50IEkgYnJvdWdodCB1cCBtYW55IHllYXJzIGFn
byB3aGVuIHRoZSB3aG9sZQ0KPiA+ID4gdHJ1c3R6b25lIHRoaW5nIGZpcnN0IGFwcGVhcmVkIHdp
dGggaXRzIFNNQyBjYWxsLiAgVGhvc2UgYXJvdW5kIHRoZQ0KPiA+ID4gY29uZmVyZW5jZSB0YWJs
ZSB3ZXJlIG5vdCBpbnRlcmVzdGVkIC0gQVJNIHNlZW1lZCB0byBwcmVmZXIgZXZlcnkNCj4gPiA+
IHZlbmRvciB0byBkbyBvZmYgYW5kIGRvIHRoZWlyIG93biB0aGluZyB3aXRoIHRoZSBTTUMgaW50
ZXJmYWNlLg0KPiA+IA0KPiA+IERvZXMgdGhhdCBtZWFuIGl0IG1ha2Ugc2Vuc2UgdG8gbW9kZWwg
YSBzZWMtcm5nIGRyaXZlciwgYW5kIGdldCBlYWNoDQo+ID4gdmVuZG9yJ3MgU01DIGZ1bmN0aW9u
IGlkIGJ5IERUIG5vZGU/DQo+IA0KPiBfSWZfIHZlbmRvcnMgaGF2ZSBhbHJlYWR5IGdvbmUgb2Zm
IGFuZCBkZWNpZGVkIHRvIHVzZSBkaWZmZXJlbnQgU01DDQo+IGZ1bmN0aW9uIElEcyBmb3IgdGhp
cywgd2hpbGUga2VlcGluZyB0aGUgcmVzdCBvZiB0aGUgU01DIGludGVyZmFjZQ0KPiB0aGUgc2Ft
ZSwgdGhlbiB0aGUgY2hvaWNlIGhhcyBhbHJlYWR5IGJlZW4gbWFkZS4NCj4gDQo+IEkga25vdyBv
biAzMi1iaXQgdGhhdCBzb21lIG9mIHRoZSBzZWN1cmUgd29ybGQgaW1wbGVtZW50YXRpb25zIGNh
bid0DQo+IGJlIGNoYW5nZWQ7IHRoZXkncmUgYnVybnQgaW50byB0aGUgUk9NLiBJIGJlbGlldmUg
b24gNjQtYml0IHRoYXQgaXNuJ3QNCj4gdGhlIGNhc2UsIHdoaWNoIG1ha2VzIGl0IGVhc2llciB0
byBzdGFuZGFyZGlzZS4NCj4gDQo+IERvIHlvdSBoYXZlIHZpc2liaWxpdHkgb2YgaG93IHRoaXMg
U01DIGlzIGltcGxlbWVudGVkIGluIHRoZSBzZWN1cmUNCj4gc2lkZT8gIElzIGl0IGluIEFURiwg
YW5kIGlzIGl0IGRvbmUgYXMgYSB2ZW5kb3IgaGFjayBvciBpcyB0aGVyZSBhbg0KPiBlbGVtZW50
IG9mIGdlbmVyaWMgaW1wbGVtZW50YXRpb24gdG8gaXQ/ICBIYXMgaXQgYmVlbiBzdWJtaXR0ZWQN
Cj4gdXBzdHJlYW0gdG8gdGhlIG1haW4gQVRGIHJlcG9zaXRvcnk/DQo+IA0KDQpUYWtlIE1lZGlh
VGVrIGFzIGFuIGV4YW1wbGUsIHNvbWUgU29DcyBhcmUgaW1wbGVtZW50ZWQgaW4gQVRGLCBzb21l
IG9mDQp0aGVtIGFyZSBpbXBsZW1lbnRlZCBpbiBURUUuIFdlIGhhdmUgbm8gcGxhbiB0byBtYWtl
IGdlbmVyaWMNCmltcGxlbWVudGF0aW9uIGluICJzZWN1cmUgd29ybGQiLg0KDQpEdWUgdG8gdGhl
cmUgbXVzdCBoYXZlIGRpZmZlcmVudCBpbXBsZW1lbnRhdGlvbiBpbiBzZWN1cmUgd29ybGQgZm9y
DQp2ZW5kb3JzLCB3ZSBwbGFuIHRvIHByb3ZpZGUgYSBnZW5lcmljIFNNQyBpbnRlcmZhY2UgaW4g
c2VjdXJlIHJuZyBrZXJuZWwNCmRyaXZlciBmb3IgbW9yZSBmbGV4aWJpbGl0eS4NCg0KVmVuZG9y
cyBjYW4gZGVjaWRlIHdoaWNoICJzZWN1cmUgd29ybGQiIHRoZXkgd2FudCAoSFlQL0FURi9URUUp
IGJ5DQpkaWZmZXJlbnQgc21jL2h2YyBhbmQgZGlmZmVyZW50IFNNQyBmdW5jdGlvbiBJRHMgaW4g
RFQgbm9kZS4NCg==

