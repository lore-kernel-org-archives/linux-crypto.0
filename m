Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CD4C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 07:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8810207D3
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 07:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgE1HOk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 03:14:40 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:23218 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbgE1HOk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 03:14:40 -0400
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 28 May 2020 15:13:41
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.60.151]
Date:   Thu, 28 May 2020 15:13:41 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Herbert Xu" <herbert@gondor.apana.org.au>
Cc:     "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        "kjlu@umn.edu" <kjlu@umn.edu>, "mpm@selenic.com" <mpm@selenic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ben.dooks@codethink.co.uk" <ben.dooks@codethink.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "rfontana@redhat.com" <rfontana@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: Re: [PATCH] hwrng: ks-sa - fix runtime pm imbalance on error
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10 build 20190906(84e8bf8f)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <20200528065519.GA26960@gondor.apana.org.au>
References: <20200520132957.18776-1-dinghao.liu@zju.edu.cn>
 <ab400cba7523e69b15360b0928cb8fa8b9432d86.camel@nokia.com>
 <20200520164556.GC11084@rowland.harvard.edu>
 <20200528065519.GA26960@gondor.apana.org.au>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <70e24bdf.d2de0.1725a2125ba.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgDn7welZM9eDfU1AA--.6637W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgoOBlZdtOWMMAABsn
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJTRUUUbtIS07vEb7Iv0x
        C_Cr1lV2xY67kC6x804xWlV2xY67CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DMIAI
        bVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4ylV2xY628lY4IE4IxF12IF4w
        CS07vE84x0c7CEj48ve4kI8wCS07vE84ACjcxK6xIIjxv20xvE14v26w1j6s0DMIAIbVA2
        z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWlV2xY628EF7xvwVC2z280aVAFwI0_Gc
        CE3s1lV2xY628EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wCS07vEe2I262IYc4CY6c8I
        j28IcVAaY2xG8wCS07vE5I8CrVACY4xI64kE6c02F40Ex7xfMIAIbVAv7VC0I7IYx2IY67
        AKxVWUJVWUGwCS07vEYx0Ex4A2jsIE14v26r1j6r4UMIAIbVAm72CE4IkC6x0Yz7v_Jr0_
        Gr1lV2xY64IIrI8v6xkF7I0E8cxan2IY04v7MIAIbVCjxxvEw4WlV2xY6xkIecxEwVAFwV
        W8CwCS07vEc2IjII80xcxEwVAKI48JMIAIbVCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l
        V2xY6xCjnVCjjxCrMIAIbVCFx2IqxVCFs4IE7xkEbVWUJVW8JwCS07vEx2IqxVAqx4xG67
        AKxVWUJVWUGwCS07vEx2IqxVCjr7xvwVAFwI0_JrI_JrWlV2xY6I8E67AF67kF1VAFwI0_
        Jw0_GFylV2xY6IIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lV2xY6IIF0xvE2Ix0cI8IcVCY1x
        0267AKxVW8JVWxJwCS07vEIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lV2xY6IIF0xvE
        x4A2jsIE14v26r1j6r4UMIAIbVCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
        evJa73U
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBPbiBXZWQsIE1heSAyMCwgMjAyMCBhdCAxMjo0NTo1NlBNIC0wNDAwLCBzdGVybkByb3dsYW5k
LmhhcnZhcmQuZWR1IHdyb3RlOgo+ID4gT24gV2VkLCBNYXkgMjAsIDIwMjAgYXQgMDM6NDI6MTdQ
TSArMDAwMCwgU3ZlcmRsaW4sIEFsZXhhbmRlciAoTm9raWEgLSBERS9VbG0pIHdyb3RlOgo+ID4g
PiBIZWxsbyBEaW5naGFvLAo+ID4gPiAKPiA+ID4gT24gV2VkLCAyMDIwLTA1LTIwIGF0IDIxOjI5
ICswODAwLCBEaW5naGFvIExpdSB3cm90ZToKPiA+ID4gPiBwbV9ydW50aW1lX2dldF9zeW5jKCkg
aW5jcmVtZW50cyB0aGUgcnVudGltZSBQTSB1c2FnZSBjb3VudGVyIGV2ZW4KPiA+ID4gPiB0aGUg
Y2FsbCByZXR1cm5zIGFuIGVycm9yIGNvZGUuIFRodXMgYSBwYWlyaW5nIGRlY3JlbWVudCBpcyBu
ZWVkZWQKPiA+ID4gPiBvbiB0aGUgZXJyb3IgaGFuZGxpbmcgcGF0aCB0byBrZWVwIHRoZSBjb3Vu
dGVyIGJhbGFuY2VkLgo+ID4gPiAKPiA+ID4gSSBiZWxpZXZlLCB0aGlzIGlzIHRoZSB3cm9uZyBw
bGFjZSBmb3Igc3VjaCBraW5kIG9mIGZpeC4KPiA+ID4gcG1fcnVudGltZV9nZXRfc3luYygpIGhh
cyBvYnZpb3VzbHkgYSBicm9rZW4gc2VtYW50aWNzIHdpdGggcmVnYXJkcyB0bwo+ID4gPiB5b3Vy
IG9ic2VydmF0aW9uIGJ1dCBubyBvdGhlciBkcml2ZXIgZG9lcyB3aGF0IHlvdSBwcm9wb3NlLgo+
ID4gCj4gPiBMb29rIGFnYWluLiAgRm9yIGV4YW1wbGUsIHNlZSB3aGF0IHVzYl9hdXRvcmVzdW1l
X2RldmljZSgpIGluIAo+ID4gZHJpdmVycy91c2IvY29yZS9kcml2ZXIuYyBkb2VzLgo+IAo+IEhv
d2V2ZXIsIHRoZXJlIHNlZW1zIHRvIGJlIHNvbWUgZGlzYWdyZWVtZW50IGFzIHRvIHdoYXQgdG8g
ZG8KPiB3aGVuIHBtX3J1bnRpbWVfZ2V0X3N5bmMgZmFpbHMuICBZb3VyIGRyaXZlciBjaG9vc2Vz
IHRvIGNhbGwKPiBwdXRfc3luYyB3aGlsZSBvdGhlcnMgcHJlZmVyIHBtX3J1bnRpbWVfcHV0X25v
aWRsZSAoZS5nLiwgc2VlCj4gZHJpdmVycy9iYXNlL3Bvd2VyL3J1bnRpbWUuYykuCj4gCj4gVGhp
cyBBUEkgZG9lcyBzZWVtIHRvIGJlIGluIGEgYml0IG9mIGEgbWVzcy4KPiAKCkhlcmUgSSB0aGlu
ayBfcHV0X25vaWRsZSgpIGlzIGJldHRlci4gSXQncyBlbm91Z2ggZm9yIHRoaXMgYnVnCmFuZCBo
YXMgbm8gc2lkZSBlZmZlY3QgKGUuZy4sIF9wdXRfc3luYyBtYXkgc3VzcGVuZCB0aGUgZHJpdmVy
KS4KSSB3aWxsIHNlbmQgYSBuZXcgcGF0Y2ggZm9yIHRoaXMgYnVnLgoKUmVnYXJkcywKRGluZ2hh
bwo=
