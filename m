Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA9FC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 08:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10BD32078D
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 08:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgHUIPi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 04:15:38 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:17530 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725965AbgHUIPi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 04:15:38 -0400
Received: by ajax-webmail-mail-app3 (Coremail) ; Fri, 21 Aug 2020 16:15:13
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.85.18]
Date:   Fri, 21 Aug 2020 16:15:13 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     "Gilad Ben-Yossef" <gilad@benyossef.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccree - fix runtime PM imbalance on error
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.12 build 20200616(0f5d8152)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <5fe48e8a.e845.1741016074a.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgBH_96Rgj9fyzj9Ag--.45498W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgoSBlZdtPnBhAAns4
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJTRUUUbAIS07vEb7Iv0x
        C_Cr1lV2xY67kC6x804xWlV2xY67CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DMIAI
        bVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4ylV2xY628lY4IE4IxF12IF4w
        CS07vE84x0c7CEj48ve4kI8wCS07vE84ACjcxK6xIIjxv20xvE14v26w1j6s0DMIAIbVA2
        z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIAIbVA2z4x0Y4vEx4A2jsIE14v26r
        xl6s0DMIAIbVA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lV2xY62AIxVAIcxkEcVAq
        07x20xvEncxIr21lV2xY6c02F40EFcxC0VAKzVAqx4xG6I80ewCS07vEYx0E2Ix0cI8IcV
        AFwI0_JrI_JrylV2xY6cIj6I8E87Iv67AKxVWUJVW8JwCS07vEOx8S6xCaFVCjc4AY6r1j
        6r4UMIAIbVACjI8F5VA0II8E6IAqYI8I648v4I1lV2xY6x02cVAKzwCS07vEc2IjII80xc
        xEwVAKI48JMIAIbVCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1lV2xY6xCjnVCjjxCrMIAI
        bVCFx2IqxVCFs4IE7xkEbVWUJVW8JwCS07vEx2IqxVAqx4xG67AKxVWUJVWUGwCS07vEx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlV2xY6I8E67AF67kF1VAFwI0_Jw0_GFylV2xY6IIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lV2xY6IIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCS07
        vEIxAIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCS07vEIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        V2xY6IIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

cG1fcnVudGltZV9nZXRfc3luYygpIGluY3JlbWVudHMgdGhlIHJ1bnRpbWUgUE0gdXNhZ2UgY291
bnRlcgpldmVuIHdoZW4gaXQgcmV0dXJucyBhbiBlcnJvciBjb2RlLiBIb3dldmVyLCB1c2VycyBv
ZiBjY19wbV9nZXQoKSwKYSBkaXJlY3Qgd3JhcHBlciBvZiBwbV9ydW50aW1lX2dldF9zeW5jKCks
IGFzc3VtZSB0aGF0IFBNIHVzYWdlCmNvdW50ZXIgd2lsbCBub3QgY2hhbmdlIG9uIGVycm9yLiBU
aHVzIGEgcGFpcmluZyBkZWNyZW1lbnQgaXMgbmVlZGVkCm9uIHRoZSBlcnJvciBoYW5kbGluZyBw
YXRoIHRvIGtlZXAgdGhlIGNvdW50ZXIgYmFsYW5jZWQuCgpGaXhlczogOGM3ODQ5YTMwMjU1YyAo
ImNyeXB0bzogY2NyZWUgLSBzaW1wbGlmeSBSdW50aW1lIFBNIGhhbmRsaW5nIikKU2lnbmVkLW9m
Zi1ieTogRGluZ2hhbyBMaXUgPGRpbmdoYW8ubGl1QHpqdS5lZHUuY24+Ci0tLQogZHJpdmVycy9j
cnlwdG8vY2NyZWUvY2NfcG0uYyB8IDYgKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NyZWUv
Y2NfcG0uYyBiL2RyaXZlcnMvY3J5cHRvL2NjcmVlL2NjX3BtLmMKaW5kZXggZDM5ZTE2NjRmYzdl
Li4zYzY1YmYwNzBjOTAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcmVlL2NjX3BtLmMK
KysrIGIvZHJpdmVycy9jcnlwdG8vY2NyZWUvY2NfcG0uYwpAQCAtNjUsOCArNjUsMTIgQEAgY29u
c3Qgc3RydWN0IGRldl9wbV9vcHMgY2NyZWVfcG0gPSB7CiBpbnQgY2NfcG1fZ2V0KHN0cnVjdCBk
ZXZpY2UgKmRldikKIHsKIAlpbnQgcmMgPSBwbV9ydW50aW1lX2dldF9zeW5jKGRldik7CisJaWYg
KHJjIDwgMCkgeworCQlwbV9ydW50aW1lX3B1dF9ub2lkbGUoZGV2KTsKKwkJcmV0dXJuIHJjOwor
CX0KIAotCXJldHVybiAocmMgPT0gMSA/IDAgOiByYyk7CisJcmV0dXJuIDA7CiB9CiAKIHZvaWQg
Y2NfcG1fcHV0X3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2KQotLSAKMi4xNy4xCg==
