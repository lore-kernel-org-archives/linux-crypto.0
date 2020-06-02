Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43088C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 08:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F3E62077D
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 08:15:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qY8s67Ye"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgFBIPG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 04:15:06 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:62402 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725969AbgFBIPF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 04:15:05 -0400
X-UUID: 1461e1b9a496442097e260296ada67a0-20200602
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=KYrBaNtif/3VCFCQAyrN/XFfbiRCsls3LdboJ24kUjg=;
        b=qY8s67YeVECuQIyw8X8zQ/SwpWodMlTt7i3G6G6R2KivOz/GJUh3mUZZLqCjfPHwfK/qeqJ2d2+K8+6Ixd/Pt/XCp7SVQiJuTVD5r56mux+YtI9hrpeExj0m6jNgc3oYAQEQn8CFcf5F7E/69e8KJh0FvOb3xbsrsEY0mK+/k+E=;
X-UUID: 1461e1b9a496442097e260296ada67a0-20200602
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 722661085; Tue, 02 Jun 2020 16:15:00 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 2 Jun 2020 16:14:58 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Jun 2020 16:14:58 +0800
From:   Neal Liu <neal.liu@mediatek.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Neal Liu <neal.liu@mediatek.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, <wsd_upstream@mediatek.com>,
        Crystal Guo <Crystal.Guo@mediatek.com>
Subject: Security Random Number Generator support
Date:   Tue, 2 Jun 2020 16:14:36 +0800
Message-ID: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 94F4E944B9EF29E1123C6BE1784E0CFC99BCFFF856242D1AE2433041B1BDFE682000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhlc2UgcGF0Y2ggc2VyaWVzIGludHJvZHVjZSBhIHNlY3VyaXR5IHJhbmRvbSBudW1iZXIgZ2Vu
ZXJhdG9yDQp3aGljaCBwcm92aWRlcyBhIGdlbmVyaWMgaW50ZXJmYWNlIHRvIGdldCBoYXJkd2Fy
ZSBybmQgZnJvbSBTZWN1cmUNCnN0YXRlLiBUaGUgU2VjdXJlIHN0YXRlIGNhbiBiZSBBcm0gVHJ1
c3RlZCBGaXJtd2FyZShBVEYpLCBUcnVzdGVkDQpFeGVjdXRpb24gRW52aXJvbm1lbnQoVEVFKSwg
b3IgZXZlbiBFTDIgaHlwZXJ2aXNvci4NCg0KUGF0Y2ggIzEuLjIgYWRkcyBzZWMtcm5nIGtlcm5l
bCBkcml2ZXIgZm9yIFRydXN0em9uZSBiYXNlZCBTb0NzLg0KRm9yIHNlY3VyaXR5IGF3YXJlbmVz
cyBTb0NzIG9uIEFSTXY4IHdpdGggVHJ1c3Rab25lIGVuYWJsZWQsDQpwZXJpcGhlcmFscyBsaWtl
IGVudHJvcHkgc291cmNlcyBpcyBub3QgYWNjZXNzaWJsZSBmcm9tIG5vcm1hbCB3b3JsZA0KKGxp
bnV4KSBhbmQgcmF0aGVyIGFjY2Vzc2libGUgZnJvbSBzZWN1cmUgd29ybGQgKEhZUC9BVEYvVEVF
KSBvbmx5Lg0KVGhpcyBkcml2ZXIgYWltcyB0byBwcm92aWRlIGEgZ2VuZXJpYyBpbnRlcmZhY2Ug
dG8gQXJtIFRydXN0ZWQNCkZpcm13YXJlIG9yIEh5cGVydmlzb3Igcm5nIHNlcnZpY2UuDQoNCg0K
Y2hhbmdlcyBzaW5jZSB2MToNCi0gcmVuYW1lIG10Njd4eC1ybmcgdG8gbXRrLXNlYy1ybmcgc2lu
Y2UgYWxsIE1lZGlhVGVrIEFSTXY4IFNvQ3MgY2FuIHJldXNlDQogIHRoaXMgZHJpdmVyLg0KICAt
IHJlZmluZSBjb2Rpbmcgc3R5bGUgYW5kIHVubmVjZXNzYXJ5IGNoZWNrLg0KDQogIGNoYW5nZXMg
c2luY2UgdjI6DQogIC0gcmVtb3ZlIHVudXNlZCBjb21tZW50cy4NCiAgLSByZW1vdmUgcmVkdW5k
YW50IHZhcmlhYmxlLg0KDQogIGNoYW5nZXMgc2luY2UgdjM6DQogIC0gYWRkIGR0LWJpbmRpbmdz
IGZvciBNZWRpYVRlayBybmcgd2l0aCBUcnVzdFpvbmUgZW5hYmxlZC4NCiAgLSByZXZpc2UgSFdS
TkcgU01DIGNhbGwgZmlkLg0KDQogIGNoYW5nZXMgc2luY2UgdjQ6DQogIC0gbW92ZSBiaW5kaW5n
cyB0byB0aGUgYXJtL2Zpcm13YXJlIGRpcmVjdG9yeS4NCiAgLSByZXZpc2UgZHJpdmVyIGluaXQg
ZmxvdyB0byBjaGVjayBtb3JlIHByb3BlcnR5Lg0KDQogIGNoYW5nZXMgc2luY2UgdjU6DQogIC0g
cmVmYWN0b3IgdG8gbW9yZSBnZW5lcmljIHNlY3VyaXR5IHJuZyBkcml2ZXIgd2hpY2gNCiAgICBp
cyBub3QgcGxhdGZvcm0gc3BlY2lmaWMuDQoNCioqKiBCTFVSQiBIRVJFICoqKg0KDQpOZWFsIExp
dSAoMik6DQogIGR0LWJpbmRpbmdzOiBybmc6IGFkZCBiaW5kaW5ncyBmb3Igc2VjLXJuZw0KICBo
d3JuZzogYWRkIHNlYy1ybmcgZHJpdmVyDQoNCiAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcv
c2VjLXJuZy55YW1sICAgICAgfCAgNTMgKysrKysrDQogZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9L
Y29uZmlnICAgICAgICAgICAgICAgIHwgIDEzICsrDQogZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9N
YWtlZmlsZSAgICAgICAgICAgICAgIHwgICAxICsNCiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL3Nl
Yy1ybmcuYyAgICAgICAgICAgICAgfCAxNTUgKysrKysrKysrKysrKysrKysrDQogNCBmaWxlcyBj
aGFuZ2VkLCAyMjIgaW5zZXJ0aW9ucygrKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3Mvcm5nL3NlYy1ybmcueWFtbA0KIGNyZWF0ZSBtb2RlIDEw
MDY0NCBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL3NlYy1ybmcuYw0KDQotLSANCjIuMTguMA0K

