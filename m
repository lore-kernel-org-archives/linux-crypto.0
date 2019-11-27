Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FBEC432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 14:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99C58206F0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 14:23:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FWsISVEZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfK0OXP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:23:15 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:15498 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726634AbfK0OXP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 09:23:15 -0500
X-UUID: 5623eca84e664962893906b9f978bb1d-20191127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=NhBME09v3vIkyV7lPjd2SdpUbwvFpe5cLCJrE0AJDLc=;
        b=FWsISVEZgeGOrx7RXH9FxrOyHQF+Ac8LeyYh2C13e8uq3ZmAk8eg2FTdbOHaSGG3faatGbkdjQXY4E0IzcsVByRjLJ5A1vZEKir+qrSkexiQ35jDj941Engs3WRrO39yBt78a8CdBfHRSeDHNoXOsIUbASgX7PJoDGuXE828psY=;
X-UUID: 5623eca84e664962893906b9f978bb1d-20191127
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1720118062; Wed, 27 Nov 2019 22:23:10 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 27 Nov 2019 22:22:59 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 27 Nov 2019 22:23:03 +0800
From:   Neal Liu <neal.liu@mediatek.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>
CC:     Neal Liu <neal.liu@mediatek.com>,
        Crystal Guo <Crystal.Guo@mediatek.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <wsd_upstream@mediatek.com>
Subject: [PATCH v5 0/3] MediaTek Security random number generator support
Date:   Wed, 27 Nov 2019 22:22:55 +0800
Message-ID: <1574864578-467-1-git-send-email-neal.liu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhlc2UgcGF0Y2ggc2VyaWVzIGludHJvZHVjZSBhIGdlbmVyaWMgcm5nIGRyaXZlciBmb3IgVHJ1
c3R6b25lDQpiYXNlZCBrZXJuZWwgZHJpdmVyIHdoaWNoIHdvdWxkIGxpa2UgdG8gY29tbXVuaWNh
dGUgd2l0aCBBVEYNClNJUCBzZXJ2aWNlcy4NCg0KUGF0Y2ggIzEgaW5pdGlhbHMgU01DIGZpZCB0
YWJsZSBmb3IgTWVkaWF0ZWsgU0lQIGludGVyZmFjZXMgYW5kDQphZGRzIEhXUk5HIHJlbGF0ZWQg
U01DIGNhbGwuDQoNClBhdGNoICMyLi4zIGFkZHMgbXRrLXNlYy1ybmcga2VybmVsIGRyaXZlciBm
b3IgVHJ1c3R6b25lIGJhc2VkIFNvQ3MuDQpGb3IgTWVkaWFUZWsgU29DcyBvbiBBUk12OCB3aXRo
IFRydXN0Wm9uZSBlbmFibGVkLCBwZXJpcGhlcmFscyBsaWtlDQplbnRyb3B5IHNvdXJjZXMgaXMg
bm90IGFjY2Vzc2libGUgZnJvbSBub3JtYWwgd29ybGQgKGxpbnV4KSBhbmQNCnJhdGhlciBhY2Nl
c3NpYmxlIGZyb20gc2VjdXJlIHdvcmxkIChBVEYvVEVFKSBvbmx5Lg0KVGhpcyBkcml2ZXIgYWlt
cyB0byBwcm92aWRlIGEgZ2VuZXJpYyBpbnRlcmZhY2UgdG8gQVRGIHJuZyBzZXJ2aWNlLg0KDQoN
CmNoYW5nZXMgc2luY2UgdjE6DQotIHJlbmFtZSBtdDY3eHgtcm5nIHRvIG10ay1zZWMtcm5nIHNp
bmNlIGFsbCBNZWRpYVRlayBBUk12OCBTb0NzIGNhbiByZXVzZQ0KICB0aGlzIGRyaXZlci4NCi0g
cmVmaW5lIGNvZGluZyBzdHlsZSBhbmQgdW5uZWNlc3NhcnkgY2hlY2suDQoNCmNoYW5nZXMgc2lu
Y2UgdjI6DQotIHJlbW92ZSB1bnVzZWQgY29tbWVudHMuDQotIHJlbW92ZSByZWR1bmRhbnQgdmFy
aWFibGUuDQoNCmNoYW5nZXMgc2luY2UgdjM6DQotIGFkZCBkdC1iaW5kaW5ncyBmb3IgTWVkaWFU
ZWsgcm5nIHdpdGggVHJ1c3Rab25lIGVuYWJsZWQuDQotIHJldmlzZSBIV1JORyBTTUMgY2FsbCBm
aWQuDQoNCmNoYW5nZXMgc2luY2UgdjQ6DQotIG1vdmUgYmluZGluZ3MgdG8gdGhlIGFybS9maXJt
d2FyZSBkaXJlY3RvcnkuDQotIHJldmlzZSBkcml2ZXIgaW5pdCBmbG93IHRvIGNoZWNrIG1vcmUg
cHJvcGVydHkuDQoNCg0KTmVhbCBMaXUgKDMpOg0KICBzb2M6IG1lZGlhdGVrOiBhZGQgU01DIGZp
ZCB0YWJsZSBmb3IgU0lQIGludGVyZmFjZQ0KICBkdC1iaW5kaW5nczogcm5nOiBhZGQgYmluZGlu
Z3MgZm9yIE1lZGlhVGVrIEFSTXY4IFNvQ3MNCiAgaHdybmc6IGFkZCBtdGstc2VjLXJuZyBkcml2
ZXINCg0KIC4uLi9hcm0vZmlybXdhcmUvbWVkaWF0ZWssbXRrLXNlYy1ybmcudHh0ICAgICB8ICAx
OCArKysNCiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWcgICAgICAgICAgICAgICAgfCAg
MTYgKysrDQogZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9NYWtlZmlsZSAgICAgICAgICAgICAgIHwg
ICAxICsNCiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL210ay1zZWMtcm5nLmMgICAgICAgICAgfCAx
MDMgKysrKysrKysrKysrKysrKysrDQogaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRrX3Np
cF9zdmMuaCAgICAgIHwgIDMzICsrKysrKw0KIDUgZmlsZXMgY2hhbmdlZCwgMTcxIGluc2VydGlv
bnMoKykNCiBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL2FybS9maXJtd2FyZS9tZWRpYXRlayxtdGstc2VjLXJuZy50eHQNCiBjcmVhdGUgbW9kZSAx
MDA2NDQgZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9tdGstc2VjLXJuZy5jDQogY3JlYXRlIG1vZGUg
MTAwNjQ0IGluY2x1ZGUvbGludXgvc29jL21lZGlhdGVrL210a19zaXBfc3ZjLmgNCg0KLS0gDQoy
LjE4LjA=

