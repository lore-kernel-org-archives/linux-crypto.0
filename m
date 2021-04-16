Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FF8C433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 11:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 239DD6115B
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 11:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbhDPL3x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Apr 2021 07:29:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53012 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236893AbhDPL3w (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Apr 2021 07:29:52 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lXMew-0003Ju-Bj; Fri, 16 Apr 2021 21:29:15 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Apr 2021 21:29:14 +1000
Date:   Fri, 16 Apr 2021 21:29:14 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Meng Yu <yumeng18@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        wangzhou1@hisilicon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ecc: delete a useless function declaration
Message-ID: <20210416112914.GA16633@gondor.apana.org.au>
References: <1617676379-18079-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617676379-18079-1-git-send-email-yumeng18@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 06, 2021 at 10:32:59AM +0800, Meng Yu wrote:
> This function declaration has been added in 'ecc_curve.h',
> delete it in 'crypto/ecc.h'.
> 
> Fixes: 4e6602916bc6(crypto: ecdsa - Add support for ECDSA ...)
> Signed-off-by: Meng Yu <yumeng18@huawei.com>
> ---
> 
> v1 -> v2: Modify the 'Fixes tag' from '14bb76768275' to '4e6602916bc6 '.
> 
> ---
>  crypto/ecc.h | 8 --------
>  1 file changed, 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
