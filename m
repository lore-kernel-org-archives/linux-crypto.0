Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50453CA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 06:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 226DC20B7C
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 06:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387675AbfJVGP5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 02:15:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43546 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387488AbfJVGP5 (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Tue, 22 Oct 2019 02:15:57 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iMnST-0001Lm-EB; Tue, 22 Oct 2019 14:15:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iMnSQ-00025c-RF; Tue, 22 Oct 2019 14:15:50 +0800
Date:   Tue, 22 Oct 2019 14:15:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH] crypto: zlib-deflate - add zlib-deflate test case in
 tcrypt
Message-ID: <20191022061550.jak3xnou2gezdfxf@gondor.apana.org.au>
References: <1570695707-46528-1-git-send-email-wangzhou1@hisilicon.com>
 <20191018071424.GA16131@gondor.apana.org.au>
 <5DAD2D40.6000901@hisilicon.com>
 <20191021054559.GA32542@gondor.apana.org.au>
 <5DAD701A.7010701@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5DAD701A.7010701@hisilicon.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 21, 2019 at 04:45:14PM +0800, Zhou Wang wrote:
>
> I made CRYPTO_MANAGER_DISABLE_TESTS=n and CRYPTO_TEST=m. After loading
> hisi_qm and hisi_zip modules, I got:
> 
> [  138.232605] hisi_zip 0000:75:00.0: Adding to iommu group 40
> [  138.239325] hisi_zip 0000:75:00.0: enabling device (0000 -> 0002)
> [  138.245896] hisi_zip 0000:b5:00.0: Adding to iommu group 41
> [  138.252435] hisi_zip 0000:b5:00.0: enabling device (0000 -> 0002)
> [  138.260393] alg: No test for gzip (hisi-gzip-acomp)
> 
> This is OK: as the test of zlib-deflate of hisi_zip was successful, so
> it was quiet, as there is no test case for gzip, so it printed above message.
> 
> cat /proc/crypto, I got:
> name         : gzip
> driver       : hisi-gzip-acomp
> module       : hisi_zip
> priority     : 300
> refcnt       : 1
> selftest     : passed
> internal     : no
> type         : acomp
> 
> name         : zlib-deflate
> driver       : hisi-zlib-acomp
> module       : hisi_zip
> priority     : 300
> refcnt       : 1
> selftest     : passed
> internal     : no
> type         : acomp
> [...]
> 
> However, seems we can not trigger a test by loading tcrypto.

The test has already been carried out when the algorithm is
registered.  Testing twice doesn't change anything.  To trigger
a new test, unload the algorithm and then run tcrypt again.

> Do you mean as crypto_has_alg can detect if an alg has already
> been tested, so it directly breaks in the case 0 in do test in tcrypto?

As I said, tests are always carried out at registration time so
by triggering the registration tcrypt knows that the test would
have already occured.

In fact this tcrypt code exists only for legacy reasons.  You can
also trigger the registration directly by loading your modules or
for templates use crconf.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
