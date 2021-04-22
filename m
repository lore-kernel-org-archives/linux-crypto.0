Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB783C433ED
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 07:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79A6D6145A
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 07:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbhDVHr7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:47:59 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48766 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235239AbhDVHrz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Apr 2021 03:47:55 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lZU3N-00035l-Ca; Thu, 22 Apr 2021 17:47:14 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 Apr 2021 17:47:13 +1000
Date:   Thu, 22 Apr 2021 17:47:13 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccp - Make ccp_dev_suspend and ccp_dev_resume
 void functions
Message-ID: <20210422074713.GH14354@gondor.apana.org.au>
References: <1618535202-11397-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618535202-11397-1-git-send-email-tiantao6@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 16, 2021 at 09:06:42AM +0800, Tian Tao wrote:
> Since ccp_dev_suspend() and ccp_dev_resume() only return 0 which causes
> ret to equal 0 in sp_suspend and sp_resume, making the if condition
> impossible to use. it might be a more appropriate fix to have these be
> void functions and eliminate the if condition in sp_suspend() and
> sp_resume().
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> ---
> v2: handle the case that didn't define CONFIG_CRYPTO_DEV_SP_CCP.
> ---
>  drivers/crypto/ccp/ccp-dev.c | 12 ++++--------
>  drivers/crypto/ccp/sp-dev.c  | 12 ++----------
>  drivers/crypto/ccp/sp-dev.h  | 15 ++++-----------
>  3 files changed, 10 insertions(+), 29 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
