Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25367CA5527
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Sep 2023 09:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbjIMJgE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Sep 2023 05:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238980AbjIMJgE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Sep 2023 05:36:04 -0400
X-Greylist: delayed 383 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Sep 2023 02:35:59 PDT
Received: from cstnet.cn (smtp20.cstnet.cn [159.226.251.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D7E196
        for <linux-crypto@vger.kernel.org>; Wed, 13 Sep 2023 02:35:59 -0700 (PDT)
Received: from sunying$isrc.iscas.ac.cn ( [180.111.102.117] ) by
 ajax-webmail-APP-10 (Coremail) ; Wed, 13 Sep 2023 17:29:33 +0800
 (GMT+08:00)
X-Originating-IP: [180.111.102.117]
Date:   Wed, 13 Sep 2023 17:29:33 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   sunying@isrc.iscas.ac.cn
To:     linux-kernel@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org,
        "pengpeng@iscas.ac.cn" <pengpeng@iscas.ac.cn>,
        "renyanjie01@gmail.com" <renyanjie01@gmail.com>
Subject: Non-existing CONFIG_ options are used in source code
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.15 build 20230321(1bf45b10)
 Copyright (c) 2002-2023 www.mailtech.cn cnic.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4e8525fe.607e2.18a8ddfdce8.Coremail.sunying@isrc.iscas.ac.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: tACowAC3H+T9gAFlOXAKAA--.25517W
X-CM-SenderInfo: 5vxq5x1qj6x21ufox2xfdvhtffof0/1tbiCQgNCmUBTe3BqAAAsr
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhlIGZvbGxvd2luZyBjb25maWd1cmF0aW9uIG9wdGlvbnMgYXJlIG5vdCBkZWZpbmVkCiAodGhl
eSBtYXkgaGF2ZSBiZWVuIGRlbGV0ZWQgb3Igbm90IHlldCBhZGRlZCkKIGJ1dCBhcmUgdXNlZCBp
biB0aGUgc291cmNlIGZpbGVzLgoKSXMgdGhlcmUgc29tZXRoaW5nIGluIHRoZXNlIHRoYXQgbWln
aHQgbmVlZCBmaXhpbmc/Cgo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQoxLiBDT05GSUdfTkVURlNfREVCVUcKZnMvbmV0ZnMvaW50ZXJuYWwuaDoxMjI6I2Vs
aWYgZGVmaW5lZChDT05GSUdfTkVURlNfREVCVUcpCgoyLiBDT05GSUdfU1NCX0RFQlVHCmluY2x1
ZGUvbGludXgvc3NiL3NzYi5oOjYyNjojaWZkZWYgQ09ORklHX1NTQl9ERUJVRwoKMy4gQ09ORklH
X0NSWVBUT19ERVZfQVNQRUVEX0hBQ0VfQ1JZUFRPX0RFQlVHCmRyaXZlcnMvY3J5cHRvL2FzcGVl
ZC9hc3BlZWQtaGFjZS1jcnlwdG8uYzoxOTojaWZkZWYgQ09ORklHX0NSWVBUT19ERVZfQVNQRUVE
X0hBQ0VfQ1JZUFRPX0RFQlVHCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09CgoKCkJlc3QgcmVnYXJkcywKWWFuamllIFJlbgpZaW5nIFN1bgo=
