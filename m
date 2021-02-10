Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A45C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 04:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4892A64E0D
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 04:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhBJE6x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:58:53 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:48816 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhBJE6t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 23:58:49 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l9hZc-0008DN-Oq; Wed, 10 Feb 2021 15:57:57 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Feb 2021 15:57:56 +1100
Date:   Wed, 10 Feb 2021 15:57:56 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Meng Yu <yumeng18@huawei.com>
Cc:     davem@davemloft.net, marcel@holtmann.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, tudor.ambarus@microchip.com,
        linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 7/9] crypto: hisilicon/hpre - add 'ECDH' algorithm
Message-ID: <20210210045756.GB7510@gondor.apana.org.au>
References: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
 <1612777137-51067-8-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612777137-51067-8-git-send-email-yumeng18@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 08, 2021 at 05:38:55PM +0800, Meng Yu wrote:
> 1. Enable 'ECDH' algorithm in Kunpeng 930;
> 2. HPRE ECDH Support: ecdh-nist-p192, ecdh-nist-p224,
>    ecdh-nist-p256, ecdh-nist-p384, ecdh-nist-p521.

Where is the patch that adds the generic ecdh-nist-p384?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
