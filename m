Return-Path: <SRS0=cmAM=7D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5253DC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 06:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 283B720748
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 06:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgEUGWK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 May 2020 02:22:10 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:32566 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726506AbgEUGWK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 May 2020 02:22:10 -0400
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 21 May 2020 14:21:03
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.77.158]
Date:   Thu, 21 May 2020 14:21:03 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Cc:     "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "kjlu@umn.edu" <kjlu@umn.edu>, "mpm@selenic.com" <mpm@selenic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ben.dooks@codethink.co.uk" <ben.dooks@codethink.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "rfontana@redhat.com" <rfontana@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: Re: [PATCH] hwrng: ks-sa - fix runtime pm imbalance on error
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10 build 20190906(84e8bf8f)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <ab400cba7523e69b15360b0928cb8fa8b9432d86.camel@nokia.com>
References: <20200520132957.18776-1-dinghao.liu@zju.edu.cn>
 <ab400cba7523e69b15360b0928cb8fa8b9432d86.camel@nokia.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <945e695.ba3c9.17235e473d9.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgCnjwrPHcZeJgjoAQ--.39295W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgQHBlZdtOPFNQABsq
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJTRUUUbt0S07vEb7Iv0x
        C_Cr1lV2xY67kC6x804xWlV2xY67CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DMIAI
        bVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4ylV2xY628lY4IE4IxF12IF4w
        CS07vE84x0c7CEj48ve4kI8wCS07vE84ACjcxK6xIIjxv20xvE14v26w1j6s0DMIAIbVA2
        z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wCS07vE84ACjcxK6I8E87Iv67AKxVW0oV
        Cq3wCS07vE84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DMIAIbVAS0I0E0xvYzxvE52x0
        82IY62kv0487MIAIbVAqx4xG64xvF2IEw4CE5I8CrVC2j2WlV2xY6cIj6xIIjxv20xvE14
        v26r1j6r18MIAIbVAv7VC2z280aVAFwI0_Jr0_Gr1lV2xY6cvjeVCFs4IE7xkEbVWUJVW8
        JwCS07vEFIxGxcIEc7CjxVA2Y2ka0xkIwI1lV2xY6x02cVAKzwCS07vEc2xSY4AK67AK6r
        47MIAIbVCY0x0Ix7I2Y4AK64vIr41lV2xY6xAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCS
        07vE4x8a6x804xWlV2xY6xC20s026xCaFVCjc4AY6r1j6r4UMIAIbVC20s026c02F40E14
        v26r1j6r18MIAIbVC20s026x8GjcxK67AKxVWUGVWUWwCS07vEx4CE17CEb7AF67AKxVWU
        tVW8ZwCS07vEIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCS07vEIxAIcVC0I7IYx2IY6xkF7I
        0E14v26r4j6F4UMIAIbVCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCS07vEIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lV2xY6IIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgQWxleGFuZGVyLAoKVGhlcmUgYXJlIGxhcmdlIGFtb3VudHMgb2YgY2FzZXMgdGhhdCBhc3N1
bWUgcG1fcnVudGltZV9nZXRfc3luYygpCndpbGwgbW9kaWZ5IHJ1bnRpbWUgUE0gdXNhZ2UgY291
bnRlciBvbiBlcnJvci4gRml4aW5nIHRoaXMgaW4gUE0gCnN1YnN5c3RlbSB3aWxsIGluZmx1ZW5j
ZSBhbGwgY2FsbGVycyBvZiBwbV9ydW50aW1lX2dldF9zeW5jKCkgYW5kCmludHJvZHVjZSBuZXcg
YnVncy4gVGhlcmVmb3JlIEkgdGhpbmsgdGhlIGJldHRlciBzb2x1dGlvbiBpcyB0byBmaXgKbWlz
dXNlZCBjYXNlcyBpbmRpdmlkdWFsbHkuCgpEaW5naGFvCgo+IEhlbGxvIERpbmdoYW8sCj4gCj4g
T24gV2VkLCAyMDIwLTA1LTIwIGF0IDIxOjI5ICswODAwLCBEaW5naGFvIExpdSB3cm90ZToKPiA+
IHBtX3J1bnRpbWVfZ2V0X3N5bmMoKSBpbmNyZW1lbnRzIHRoZSBydW50aW1lIFBNIHVzYWdlIGNv
dW50ZXIgZXZlbgo+ID4gdGhlIGNhbGwgcmV0dXJucyBhbiBlcnJvciBjb2RlLiBUaHVzIGEgcGFp
cmluZyBkZWNyZW1lbnQgaXMgbmVlZGVkCj4gPiBvbiB0aGUgZXJyb3IgaGFuZGxpbmcgcGF0aCB0
byBrZWVwIHRoZSBjb3VudGVyIGJhbGFuY2VkLgo+IAo+IEkgYmVsaWV2ZSwgdGhpcyBpcyB0aGUg
d3JvbmcgcGxhY2UgZm9yIHN1Y2gga2luZCBvZiBmaXguCj4gcG1fcnVudGltZV9nZXRfc3luYygp
IGhhcyBvYnZpb3VzbHkgYSBicm9rZW4gc2VtYW50aWNzIHdpdGggcmVnYXJkcyB0bwo+IHlvdXIg
b2JzZXJ2YXRpb24gYnV0IG5vIG90aGVyIGRyaXZlciBkb2VzIHdoYXQgeW91IHByb3Bvc2UuCj4g
SSB0aGluayB0aGUgcHJvcGVyIGZpeCBiZWxvbmcgaW50byBQTSBzdWJzeXN0ZW0sIHBsZWFzZSB0
YWtlIGEgbG9vawo+IG9udG8gY29tbWl0IDE1YmNiOTFkN2U2MCAiUE0gLyBSdW50aW1lOiBJbXBs
ZW1lbnQgYXV0b3N1c3BlbmQgc3VwcG9ydCIuCj4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBEaW5naGFv
IExpdSA8ZGluZ2hhby5saXVAemp1LmVkdS5jbj4KPiA+IC0tLQo+ID4gIGRyaXZlcnMvY2hhci9o
d19yYW5kb20va3Mtc2Etcm5nLmMgfCAxICsKPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKykKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9od19yYW5kb20va3Mtc2Et
cm5nLmMgYi9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2tzLXNhLXJuZy5jCj4gPiBpbmRleCBlMjMz
MGU3NTdmMWYuLjg1YzgxZGE0YThhZiAxMDA2NDQKPiA+IC0tLSBhL2RyaXZlcnMvY2hhci9od19y
YW5kb20va3Mtc2Etcm5nLmMKPiA+ICsrKyBiL2RyaXZlcnMvY2hhci9od19yYW5kb20va3Mtc2Et
cm5nLmMKPiA+IEBAIC0yNDQsNiArMjQ0LDcgQEAgc3RhdGljIGludCBrc19zYV9ybmdfcHJvYmUo
c3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKPiA+ICAJcmV0ID0gcG1fcnVudGltZV9nZXRf
c3luYyhkZXYpOwo+ID4gIAlpZiAocmV0IDwgMCkgewo+ID4gIAkJZGV2X2VycihkZXYsICJGYWls
ZWQgdG8gZW5hYmxlIFNBIHBvd2VyLWRvbWFpblxuIik7Cj4gPiArCQlwbV9ydW50aW1lX3B1dF9z
eW5jKGRldik7Cj4gPiAgCQlwbV9ydW50aW1lX2Rpc2FibGUoZGV2KTsKPiA+ICAJCXJldHVybiBy
ZXQ7Cj4gPiAgCX0KPiAtLSAKPiBBbGV4YW5kZXIgU3ZlcmRsaW4uCj4gCg==
