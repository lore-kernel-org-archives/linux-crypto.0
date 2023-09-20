Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4F5CE79AC
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 05:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbjITFYj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 01:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbjITFYG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 01:24:06 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4095D1FC6;
        Tue, 19 Sep 2023 22:22:59 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qipfq-00GD6G-8K; Wed, 20 Sep 2023 13:22:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 20 Sep 2023 13:22:57 +0800
Date:   Wed, 20 Sep 2023 13:22:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wenkai Lin <linwenkai6@hisilicon.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        liulongfang@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/sec - fix for sgl unmmap problem
Message-ID: <ZQqBsT0VRAK2Gx11@gondor.apana.org.au>
References: <20230915091329.31708-1-linwenkai6@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915091329.31708-1-linwenkai6@hisilicon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 15, 2023 at 05:13:29PM +0800, Wenkai Lin wrote:
> When sec_aead_mac_init returns an error code, sec_cipher_map
> will exit abnormally, the hardware sgl should be unmmaped.
> 
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
