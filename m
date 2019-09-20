Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86806C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 13:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6400120665
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 13:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfITNBa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:01:30 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34598 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbfITNBa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 09:01:30 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iBIWF-0007oQ-9S; Fri, 20 Sep 2019 23:00:16 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Sep 2019 23:00:12 +1000
Date:   Fri, 20 Sep 2019 23:00:12 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yunfeng Ye <yeyunfeng@huawei.com>
Cc:     davem@davemloft.net, john.garry@huawei.com,
        Jonathan.Cameron@huawei.com, mcgrof@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: hisilicon - Fix double free in
 sec_free_hw_sgl()
Message-ID: <20190920130012.GC23242@gondor.apana.org.au>
References: <c9c52443-59a6-f909-f98b-eddffe999c2b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9c52443-59a6-f909-f98b-eddffe999c2b@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Sep 15, 2019 at 05:26:56PM +0800, Yunfeng Ye wrote:
> There are two problems in sec_free_hw_sgl():
> 
> First, when sgl_current->next is valid, @hw_sgl will be freed in the
> first loop, but it free again after the loop.
> 
> Second, sgl_current and sgl_current->next_sgl is not match when
> dma_pool_free() is invoked, the third parameter should be the dma
> address of sgl_current, but sgl_current->next_sgl is the dma address
> of next chain, so use sgl_current->next_sgl is wrong.
> 
> Fix this by deleting the last dma_pool_free() in sec_free_hw_sgl(),
> modifying the condition for while loop, and matching the address for
> dma_pool_free().
> 
> Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec/sec_algs.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
