Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB6BC282DD
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5F652084F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfDHGlb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:41:31 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:45984 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDHGlb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 02:41:31 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDNxx-0008B2-FW; Mon, 08 Apr 2019 14:41:13 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDNxq-0005r1-IB; Mon, 08 Apr 2019 14:41:06 +0800
Date:   Mon, 8 Apr 2019 14:41:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     haren@us.ibm.com, davem@davemloft.net, benh@kernel.crashing.org,
        paulus@samba.org, mpe@ellerman.id.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH -next] crypto: nx842 - remove set but not used variables
 'dpadding' and 'max_sync_size'
Message-ID: <20190408064106.fpwxlct73jqgatsx@gondor.apana.org.au>
References: <20190330055429.25848-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190330055429.25848-1-yuehaibing@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 30, 2019 at 01:54:29PM +0800, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> 
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/crypto/nx/nx-842.c: In function 'decompress':
> drivers/crypto/nx/nx-842.c:356:25: warning: variable 'dpadding' set but not used [-Wunused-but-set-variable]
> drivers/crypto/nx/nx-842-pseries.c: In function 'nx842_pseries_compress':
> drivers/crypto/nx/nx-842-pseries.c:299:15: warning: variable 'max_sync_size' set but not used [-Wunused-but-set-variable]
> drivers/crypto/nx/nx-842-pseries.c: In function 'nx842_pseries_decompress':
> drivers/crypto/nx/nx-842-pseries.c:430:15: warning: variable 'max_sync_size' set but not used [-Wunused-but-set-variable]
> 
> They are not used any more and can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/nx/nx-842-pseries.c | 6 ++----
>  drivers/crypto/nx/nx-842.c         | 3 +--
>  2 files changed, 3 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
