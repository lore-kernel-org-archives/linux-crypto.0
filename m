Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A29C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 07:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiF3HRk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 03:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiF3HRi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 03:17:38 -0400
X-Greylist: delayed 1840 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Jun 2022 00:17:36 PDT
Received: from m1564.mail.126.com (m1564.mail.126.com [220.181.15.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C185937A00
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 00:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=NN20i
        txAdcG9WJ4vlRFmSP7Bwljia5bFnUVW/m+oGMs=; b=CdFX2SNbfQaamv5pjOpc8
        8kWEekfvDn4B6FAg0kiE2MJk/8PX23C0zabVblgOJgQB3fjTvSrTAwv43vtFR3Gi
        V6h1EFYg7PCJ72kSB6fllXlk6HqNOxv6pLUE2D6ugJcpaqq5gKKknCYkNSoI0hTW
        9tVuEXj8mK12v/1xeRNyxA=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr64
 (Coremail) ; Thu, 30 Jun 2022 14:46:27 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Thu, 30 Jun 2022 14:46:27 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Herbert Xu" <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re:Re: [PATCH] crypto: Hold the reference returned by
 of_find_compatible_node
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <Yr1GCZF/gWBm4zHp@gondor.apana.org.au>
References: <Yr1GCZF/gWBm4zHp@gondor.apana.org.au>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <2c070a4e.4403.181b35c6c67.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: QMqowACntnLFRr1i5ZtCAA--.36250W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGgQwF1-HZaStQAABsM
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CgoKQXQgMjAyMi0wNi0zMCAxNDo0MzoyMSwgIkhlcmJlcnQgWHUiIDxoZXJiZXJ0QGdvbmRvci5h
cGFuYS5vcmcuYXU+IHdyb3RlOgo+TGlhbmcgSGUgPHdpbmRobEAxMjYuY29tPiB3cm90ZToKPj4g
SW4gbng4NDJfcHNlcmllc19pbml0KCkgYW5kIGNyeXB0bzR4eF9wcm9iZSgpLCB3ZSBzaG91bGQg
aG9sZCB0aGUKPj4gcmVmZXJlbmNlIHJldHVybmVkIGJ5IG9mX2ZpbmRfY29tcGF0aWJsZV9ub2Rl
KCkgYW5kIHVzZSBpdCB0byBjYWxsCj4+IG9mX25vZGVfcHV0IHRvIGtlZXAgcmVmY291bnQgYmFs
YW5jZS4KPj4gCj4+IFNpZ25lZC1vZmYtYnk6IExpYW5nIEhlIDx3aW5kaGxAMTI2LmNvbT4KPj4g
LS0tCj4+IGRyaXZlcnMvY3J5cHRvL2FtY2MvY3J5cHRvNHh4X2NvcmUuYyAgfCAxMyArKysrKysr
Ky0tLS0tCj4+IGRyaXZlcnMvY3J5cHRvL254L254LWNvbW1vbi1wc2VyaWVzLmMgfCAgNSArKysr
LQo+PiAyIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4K
PlBsZWFzZSBzcGxpdCB0aGlzIGludG8gdHdvIHBhdGNoZXMuCj4KCk9LLgoKPj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY3J5cHRvL2FtY2MvY3J5cHRvNHh4X2NvcmUuYyBiL2RyaXZlcnMvY3J5cHRv
L2FtY2MvY3J5cHRvNHh4X2NvcmUuYwo+PiBpbmRleCA4Mjc4ZDk4MDc0ZTkuLjE2OWI2YTA1ZTc1
MiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vYW1jYy9jcnlwdG80eHhfY29yZS5jCj4+
ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2FtY2MvY3J5cHRvNHh4X2NvcmUuYwo+PiBAQCAtMTM3OCw2
ICsxMzc4LDcgQEAgc3RhdGljIGludCBjcnlwdG80eHhfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2Rl
dmljZSAqb2ZkZXYpCj4+ICAgICAgICBzdHJ1Y3QgcmVzb3VyY2UgcmVzOwo+PiAgICAgICAgc3Ry
dWN0IGRldmljZSAqZGV2ID0gJm9mZGV2LT5kZXY7Cj4+ICAgICAgICBzdHJ1Y3QgY3J5cHRvNHh4
X2NvcmVfZGV2aWNlICpjb3JlX2RldjsKPj4gKyAgICAgICBzdHJ1Y3QgZGV2aWNlX25vZGUgKm5w
Owo+PiAgICAgICAgdTMyIHB2cjsKPj4gICAgICAgIGJvb2wgaXNfcmV2YiA9IHRydWU7Cj4+IAo+
PiBAQCAtMTM4NSwyMCArMTM4NiwyMCBAQCBzdGF0aWMgaW50IGNyeXB0bzR4eF9wcm9iZShzdHJ1
Y3QgcGxhdGZvcm1fZGV2aWNlICpvZmRldikKPj4gICAgICAgIGlmIChyYykKPj4gICAgICAgICAg
ICAgICAgcmV0dXJuIC1FTk9ERVY7Cj4+IAo+PiAtICAgICAgIGlmIChvZl9maW5kX2NvbXBhdGli
bGVfbm9kZShOVUxMLCBOVUxMLCAiYW1jYyxwcGM0NjBleC1jcnlwdG8iKSkgewo+PiArICAgICAg
IGlmICgobnAgPSBvZl9maW5kX2NvbXBhdGlibGVfbm9kZShOVUxMLCBOVUxMLCAiYW1jYyxwcGM0
NjBleC1jcnlwdG8iKSkgIT0gTlVMTCkgewo+Cj5UaGlzIGlzIGdldHRpbmcgYXdrd2FyZGx5IGxv
bmcuICBQbGVhc2UgY2hhbmdlIHRoaXMgdG8KPgo+CW5wID0gLi4uOwo+CWlmIChucCkgewo+Cj5U
aGFua3MsCj4tLSAKPkVtYWlsOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcu
YXU+Cj5Ib21lIFBhZ2U6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1L35oZXJiZXJ0Lwo+UEdQ
IEtleTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUvfmhlcmJlcnQvcHVia2V5LnR4dAoKVGhh
bmtzLCBIZXJiZXJ0LgoKSSB3aWxsIHJlc2VuZCB0d28gcGF0Y2hlcyB3aXRoIGFib3ZlIGNoYW5n
ZS4KCkxpYW5nCgo=
