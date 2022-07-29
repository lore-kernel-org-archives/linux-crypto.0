Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E687C00144
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jul 2022 10:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiG2Kdf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jul 2022 06:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiG2Kde (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jul 2022 06:33:34 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC2C43E50;
        Fri, 29 Jul 2022 03:33:33 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oHNJ9-005oUY-Bg; Fri, 29 Jul 2022 20:33:28 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Jul 2022 18:33:27 +0800
Date:   Fri, 29 Jul 2022 18:33:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        liulongfang@huawei.com, davem@davemloft.net, xuzaibo@huawei.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH v2] crypto: hisilicon/hpre - don't use GFP_KERNEL to
 alloc mem during softirq
Message-ID: <YuO3d13aIqsYMkhW@gondor.apana.org.au>
References: <20220719042323.260146-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719042323.260146-1-shaozhengchao@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 19, 2022 at 12:23:23PM +0800, Zhengchao Shao wrote:
> The hpre encryption driver may be used to encrypt and decrypt packets
> during the rx softirq, it is not allowed to use GFP_KERNEL.
> 
> Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> This patch is not tested, compiled only.
> ---
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
