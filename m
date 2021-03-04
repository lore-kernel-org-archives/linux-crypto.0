Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F670C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6432C64F09
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhCDGno (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 01:43:44 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52616 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235581AbhCDGnX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 01:43:23 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lHhgz-0007c2-0X; Thu, 04 Mar 2021 17:42:38 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Mar 2021 17:42:36 +1100
Date:   Thu, 4 Mar 2021 17:42:36 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Hulk Robot <hulkci@huawei.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mike Healy <mikex.healy@intel.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: keembay-ocs-aes - Fix error return code in
 kmb_ocs_aes_probe()
Message-ID: <20210304064236.GG15863@gondor.apana.org.au>
References: <20210210074527.867400-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210074527.867400-1-weiyongjun1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 10, 2021 at 07:45:27AM +0000, Wei Yongjun wrote:
> Fix to return negative error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 885743324513 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/crypto/keembay/keembay-ocs-aes-core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
