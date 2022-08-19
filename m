Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D50C32771
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 10:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347912AbiHSK6U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 06:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347652AbiHSK6T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 06:58:19 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DC863F3;
        Fri, 19 Aug 2022 03:58:14 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oOzhY-00CpTM-GA; Fri, 19 Aug 2022 20:58:09 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Aug 2022 18:58:08 +0800
Date:   Fri, 19 Aug 2022 18:58:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, javier.martin@vista-silicon.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH v3] crypto: sahara - don't sleep when in softirq
Message-ID: <Yv9swI5nyPEvw7AW@gondor.apana.org.au>
References: <20220725040928.77227-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725040928.77227-1-shaozhengchao@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 25, 2022 at 12:09:28PM +0800, Zhengchao Shao wrote:
> Function of sahara_aes_crypt maybe could be called by function
> of crypto_skcipher_encrypt during the rx softirq, so it is not
> allowed to use mutex lock.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> This patch is not yet tested, compiled only.
> ---
>  drivers/crypto/sahara.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
