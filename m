Return-Path: <SRS0=Y8jf=AA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6311BC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 01:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40DE32080D
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 01:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dShO2w/8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgFSBru (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jun 2020 21:47:50 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:54715 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727853AbgFSBru (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jun 2020 21:47:50 -0400
X-UUID: 003aa035522d440484d9920def9fccb7-20200619
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=DE1s9SBibd4ThP5Mt1aI+rVY3mxb520JHblT3mUqGaQ=;
        b=dShO2w/8LsUTwSulcr8n8eFKbLMqOm1ibtY5V+MHMCu13c0gTTz3gobwabWzsxWSytHYCVJK9VpD0ycT0m9OLmUgQ+dfXYbEFSYCNEDUqL53TjL2iObeNrs1HcjqORJA5+goO0P/S2dQ7byVR+MYGbI9MNeNwi5ZWUEZQm5M/PQ=;
X-UUID: 003aa035522d440484d9920def9fccb7-20200619
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1442301035; Fri, 19 Jun 2020 09:47:47 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 19 Jun 2020 09:47:39 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 19 Jun 2020 09:47:44 +0800
Message-ID: <1592531264.19628.2.camel@mtkswgap22>
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
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        <Jose.Marinho@arm.com>
Date:   Fri, 19 Jun 2020 09:47:44 +0800
In-Reply-To: <c3d5d4a79c7fe158cae117ff79ab332b@kernel.org>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
         <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
         <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
         <1591169342.4878.9.camel@mtkswgap22>
         <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
         <1591170857.19414.5.camel@mtkswgap22>
         <c3d5d4a79c7fe158cae117ff79ab332b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: DFDBAF610BC86DD2371E32B64FAA3749787DA7AB10884CFFC46B8422DC8468052000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgTWFyYywNCg0KT24gVGh1LCAyMDIwLTA2LTE4IGF0IDEwOjUwICswMTAwLCBNYXJjIFp5bmdp
ZXIgd3JvdGU6DQo+IE9uIDIwMjAtMDYtMDMgMDg6NTQsIE5lYWwgTGl1IHdyb3RlOg0KPiANCj4g
SGkgTmVhbCwNCj4gDQo+ID4gRG8geW91IGtub3cgd2hpY2ggQVJNIGV4cGVydCBjb3VsZCBlZGlj
dCB0aGlzIHN0YW5kYXJkPw0KPiA+IE9yIGlzIHRoZXJlIGFueSBjaGFuY2UgdGhhdCB3ZSBjYW4g
bWFrZSBvbmU/IEFuZCBiZSByZXZpZXdlZCBieQ0KPiA+IG1haW50YWluZXJzPw0KPiANCj4gSXQg
YXBwZWFycyB0aGF0IEFSTSBqdXN0IHJlbGVhc2VkIGEgYmV0YSB2ZXJzaW9uIG9mIHRoZSBzcGVj
IGF0IFsxXS4NCj4gDQo+IEknZCBlbmNvdXJhZ2UgeW91IChhbmQgYW55b25lIGVsc2UpIHRvIGhh
dmUgYSBsb29rIGF0IGl0IGFuZCBwcm92aWRlIA0KPiBmZWVkYmFjayB0byBBUk0uDQo+IA0KPiBU
aGFua3MsDQo+IA0KPiAgICAgICAgICBNLg0KPiANCj4gWzFdIA0KPiBodHRwczovL2RldmVsb3Bl
ci5hcm0uY29tLy0vbWVkaWEvRmlsZXMvcGRmL0RFTjAwOTgtVHJ1ZV9SYW5kb21fTnVtYmVyX0dl
bmVyYXRvcl9GaXJtd2FyZV9JbnRlcmZhY2UtMS4wQkVUMi5wZGYNCg0KSSBhbHNvIHJlY2VpdmVk
IHRoaXMgc3BlYyBmcm9tIEFSTS4gSSdsbCB0YWtlIGEgbG9vayBhbmQgc2VlIGlmIGl0IG1lZXRz
DQpvdXIgbmVlZHMuDQpUaGFua3MgZm9yIHlvdXIgc2hhcmluZy4NCg==

