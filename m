Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B7FC432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 11:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 475A9217F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 11:30:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="B0kGmm32"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfK2Laz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 06:30:55 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:21979 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726215AbfK2Laz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 06:30:55 -0500
X-UUID: 0463d9a3274143959e604d33b956bd31-20191129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=PwCHJ/ylLxsFTolp1LFDT4a1s0102DjGPATz1zjtxA0=;
        b=B0kGmm32hS6rMrCce03DSS9/I49LmnvX9Of9xHT/lE4Yysz5JkdCowVMOt2ZRII8RGPauflXRDTpVRv0T0+7II32lMHsf/zwEReNp4o9aO9ByBej+e2FzRcMbHI3TUv3pbabwCw7WTWibWCP3OwLzmF3DzwlF5paVrx67Xv1ZMU=;
X-UUID: 0463d9a3274143959e604d33b956bd31-20191129
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1743712512; Fri, 29 Nov 2019 19:30:48 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 29 Nov 2019 19:30:42 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 29 Nov 2019 19:30:44 +0800
Message-ID: <1575027046.24848.4.camel@mtkswgap22>
Subject: Re: [PATCH v5 3/3] hwrng: add mtk-sec-rng driver
From:   Neal Liu <neal.liu@mediatek.com>
To:     Lars Persson <lists@bofh.nu>
CC:     Mark Rutland <mark.rutland@arm.com>,
        DTML <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Sean Wang <sean.wang@kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Crystal Guo =?UTF-8?Q?=28=E9=83=AD=E6=99=B6=29?= 
        <Crystal.Guo@mediatek.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Date:   Fri, 29 Nov 2019 19:30:46 +0800
In-Reply-To: <CADnJP=uhD=J2NrpSwiX8oCTd-u_q05=HhsAV-ErCsXNDwVS0rA@mail.gmail.com>
References: <1574864578-467-1-git-send-email-neal.liu@mediatek.com>
         <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
         <CADnJP=uhD=J2NrpSwiX8oCTd-u_q05=HhsAV-ErCsXNDwVS0rA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gRnJpLCAyMDE5LTExLTI5IGF0IDE4OjAyICswODAwLCBMYXJzIFBlcnNzb24gd3JvdGU6DQo+
IEhpIE5lYWwsDQo+IA0KPiBPbiBXZWQsIE5vdiAyNywgMjAxOSBhdCAzOjIzIFBNIE5lYWwgTGl1
IDxuZWFsLmxpdUBtZWRpYXRlay5jb20+IHdyb3RlOg0KPiA+DQo+ID4gRm9yIE1lZGlhVGVrIFNv
Q3Mgb24gQVJNdjggd2l0aCBUcnVzdFpvbmUgZW5hYmxlZCwgcGVyaXBoZXJhbHMgbGlrZQ0KPiA+
IGVudHJvcHkgc291cmNlcyBpcyBub3QgYWNjZXNzaWJsZSBmcm9tIG5vcm1hbCB3b3JsZCAobGlu
dXgpIGFuZA0KPiA+IHJhdGhlciBhY2Nlc3NpYmxlIGZyb20gc2VjdXJlIHdvcmxkIChBVEYvVEVF
KSBvbmx5LiBUaGlzIGRyaXZlciBhaW1zDQo+ID4gdG8gcHJvdmlkZSBhIGdlbmVyaWMgaW50ZXJm
YWNlIHRvIEFURiBybmcgc2VydmljZS4NCj4gPg0KPiANCj4gSSBhbSB3b3JraW5nIG9uIHNldmVy
YWwgU29DcyB0aGF0IGFsc28gd2lsbCBuZWVkIHRoaXMga2luZCBvZiBkcml2ZXINCj4gdG8gZ2V0
IGVudHJvcHkgZnJvbSBBcm0gdHJ1c3RlZCBmaXJtd2FyZS4NCj4gSWYgeW91IGludGVuZCB0byBt
YWtlIHRoaXMgYSBnZW5lcmljIGludGVyZmFjZSwgcGxlYXNlIGNsZWFuIHVwIHRoZQ0KPiByZWZl
cmVuY2VzIHRvIE1lZGlhVGVrIGFuZCBnaXZlIGl0IGEgbW9yZSBnZW5lcmljIG5hbWUuIEZvciBl
eGFtcGxlDQo+ICJBcm0gVHJ1c3RlZCBGaXJtd2FyZSByYW5kb20gbnVtYmVyIGRyaXZlciIuDQo+
IA0KPiBJdCB3aWxsIGFsc28gYmUgaGVscGZ1bCBpZiB0aGUgU01DIGNhbGwgbnVtYmVyIGlzIGNv
bmZpZ3VyYWJsZS4NCj4gDQo+IC0gTGFycw0KDQpZZXMsIEknbSB0cnlpbmcgdG8gbWFrZSB0aGlz
IHRvIGEgZ2VuZXJpYyBpbnRlcmZhY2UuIEknbGwgdHJ5IHRvIG1ha2UNCkhXL3BsYXRmb3JtIHJl
bGF0ZWQgZGVwZW5kZW5jeSB0byBiZSBjb25maWd1cmFibGUgYW5kIGxldCBpdCBtb3JlDQpnZW5l
cmljLg0KVGhhbmtzIGZvciB5b3VyIHN1Z2dlc3Rpb24uDQoNCj4gDQo+IF9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+IExpbnV4LW1lZGlhdGVrIG1haWxp
bmcgbGlzdA0KPiBMaW51eC1tZWRpYXRla0BsaXN0cy5pbmZyYWRlYWQub3JnDQo+IGh0dHA6Ly9s
aXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbWVkaWF0ZWsNCg0K

