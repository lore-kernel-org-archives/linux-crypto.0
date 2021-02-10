Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06718C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 04:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D313864E45
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 04:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhBJE57 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:57:59 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:48770 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230463AbhBJE5l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 23:57:41 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l9hYE-00089l-DV; Wed, 10 Feb 2021 15:56:31 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Feb 2021 15:56:30 +1100
Date:   Wed, 10 Feb 2021 15:56:30 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Meng Yu <yumeng18@huawei.com>
Cc:     davem@davemloft.net, marcel@holtmann.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, tudor.ambarus@microchip.com,
        linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/9] crypto: atmel-ecc - move curve_id of ECDH from
 the key to algorithm name
Message-ID: <20210210045630.GA7510@gondor.apana.org.au>
References: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
 <1612777137-51067-4-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612777137-51067-4-git-send-email-yumeng18@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 08, 2021 at 05:38:51PM +0800, Meng Yu wrote:
> As curve id of ECDH will be moved from its key into algorithm name,
> we cannot use 'curve_id' in 'struct ecdh', so we should modify ECDH
> driver in atmel, and make ECDH algorithm name be the same as crypto
> (like 'ecdh-nist-pxxx');
> 
> Signed-off-by: Meng Yu <yumeng18@huawei.com>
> Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
> ---
>  drivers/crypto/atmel-ecc.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Patches 3-5 need to be squashed into one in order to avoid future
bisection failures.

The alternative is to let the new/old names coexist but it's probably
not worth it for this case as the number of drivers impacted is small.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
