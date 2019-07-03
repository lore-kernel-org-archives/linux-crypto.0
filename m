Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786A6C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 14:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 525F421850
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 14:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfGCO35 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 10:29:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52306 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbfGCO35 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 10:29:57 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1higGi-0000ly-18; Wed, 03 Jul 2019 22:29:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1higGg-0000Yc-7T; Wed, 03 Jul 2019 22:29:54 +0800
Date:   Wed, 3 Jul 2019 22:29:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, rabinv@axis.com
Subject: Re: [PATCH] crypto: cryptd - Fix skcipher instance memory leak
Message-ID: <20190703142954.pxvp3hcvnff3cg3o@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702075325.27940-1-vincent.whitchurch@axis.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Vincent Whitchurch <vincent.whitchurch@axis.com> wrote:
> cryptd_skcipher_free() fails to free the struct skcipher_instance
> allocated in cryptd_create_skcipher(), leading to a memory leak.  This
> is detected by kmemleak on bootup on ARM64 platforms:
> 
> unreferenced object 0xffff80003377b180 (size 1024):
>   comm "cryptomgr_probe", pid 822, jiffies 4294894830 (age 52.760s)
>   backtrace:
>     kmem_cache_alloc_trace+0x270/0x2d0
>     cryptd_create+0x990/0x124c
>     cryptomgr_probe+0x5c/0x1e8
>     kthread+0x258/0x318
>     ret_from_fork+0x10/0x1c
> 
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> ---
> crypto/cryptd.c | 1 +
> 1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
