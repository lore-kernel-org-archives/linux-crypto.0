Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40036CA9EB5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 08:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D36520659
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 08:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfJUIp0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 04:45:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4738 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726725AbfJUIpZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 04:45:25 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 22DB1DEB1D82C640D696;
        Mon, 21 Oct 2019 16:45:22 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 21 Oct 2019
 16:45:15 +0800
Subject: Re: [PATCH] crypto: zlib-deflate - add zlib-deflate test case in
 tcrypt
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1570695707-46528-1-git-send-email-wangzhou1@hisilicon.com>
 <20191018071424.GA16131@gondor.apana.org.au> <5DAD2D40.6000901@hisilicon.com>
 <20191021054559.GA32542@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5DAD701A.7010701@hisilicon.com>
Date:   Mon, 21 Oct 2019 16:45:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20191021054559.GA32542@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/10/21 13:45, Herbert Xu wrote:
> On Mon, Oct 21, 2019 at 12:00:00PM +0800, Zhou Wang wrote:
>>
>> seems it can not work, when I run insmod tcrypt.ko alg="zlib-deflate" type=10 mask=15
>> I got: insmod: can't insert 'tcrypt.ko': Resource temporarily unavailable
> 
> This error is intentional.  This is so that you can test again
> without having to unload the module.

Yes.

> 
>> crypto_has_alg in case 0 in do_test does find "zlib-deflate", however, it breaks and
>> do nothing about test.
> 
> It doesn't have to do anything.  As long as it causes the algorithm
> to be registered the crypto API will test it automatically.  So
> after doing the modprobe, can you find the algorithm in /proc/crypto
> and if so what does its test status say?

I made CRYPTO_MANAGER_DISABLE_TESTS=n and CRYPTO_TEST=m. After loading
hisi_qm and hisi_zip modules, I got:

[  138.232605] hisi_zip 0000:75:00.0: Adding to iommu group 40
[  138.239325] hisi_zip 0000:75:00.0: enabling device (0000 -> 0002)
[  138.245896] hisi_zip 0000:b5:00.0: Adding to iommu group 41
[  138.252435] hisi_zip 0000:b5:00.0: enabling device (0000 -> 0002)
[  138.260393] alg: No test for gzip (hisi-gzip-acomp)

This is OK: as the test of zlib-deflate of hisi_zip was successful, so
it was quiet, as there is no test case for gzip, so it printed above message.

cat /proc/crypto, I got:
name         : gzip
driver       : hisi-gzip-acomp
module       : hisi_zip
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : acomp

name         : zlib-deflate
driver       : hisi-zlib-acomp
module       : hisi_zip
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : acomp
[...]

However, seems we can not trigger a test by loading tcrypto.
Do you mean as crypto_has_alg can detect if an alg has already
been tested, so it directly breaks in the case 0 in do test in tcrypto?

Best,
Zhou

> 
> Cheers,
> 

