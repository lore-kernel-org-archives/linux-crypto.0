Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8984EC00144
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jul 2022 10:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiG2Kg3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jul 2022 06:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbiG2KgZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jul 2022 06:36:25 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE5C82124;
        Fri, 29 Jul 2022 03:36:24 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oHNLv-005ocL-7x; Fri, 29 Jul 2022 20:36:20 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Jul 2022 18:36:19 +0800
Date:   Fri, 29 Jul 2022 18:36:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/sec - fix auth key size error
Message-ID: <YuO4I9y6fYbpnL5I@gondor.apana.org.au>
References: <20220721021831.25609-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721021831.25609-1-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 21, 2022 at 10:18:31AM +0800, Kai Ye wrote:
> The authentication algorithm supports a maximum of 128-byte keys.
> The allocated key memory is insufficient.
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 6 +++---
>  drivers/crypto/hisilicon/sec2/sec_crypto.h | 1 +
>  2 files changed, 4 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
