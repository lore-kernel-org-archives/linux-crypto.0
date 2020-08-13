Return-Path: <SRS0=zaW3=BX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD18C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 07:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A424720781
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 07:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgHMHL4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Aug 2020 03:11:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55244 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgHMHL4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Aug 2020 03:11:56 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k67Ou-0003gl-ES; Thu, 13 Aug 2020 17:11:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Aug 2020 17:11:48 +1000
Date:   Thu, 13 Aug 2020 17:11:48 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: algif_aead - fix uninitialized ctx->init
Message-ID: <20200813071148.GA3894@gondor.apana.org.au>
References: <20200812125825.436733-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812125825.436733-1-omosnace@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 12, 2020 at 02:58:25PM +0200, Ondrej Mosnacek wrote:
> In skcipher_accept_parent_nokey() the whole af_alg_ctx structure is
> cleared by memset() after allocation, so add such memset() also to
> aead_accept_parent_nokey() so that the new "init" field is also
> initialized to zero. Without that the initial ctx->init checks might
> randomly return true and cause errors.
> 
> While there, also remove the redundant zero assignments in both
> functions.
> 
> Found via libkcapi testsuite.
> 
> Cc: Stephan Mueller <smueller@chronox.de>
> Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when ctx->more is zero")
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
> 
> v2:
>  - intead add missing memset() to algif_aead and remove the redundant
>    zero assignments (suggested by Herbert)
> 
>  crypto/algif_aead.c     | 6 ------
>  crypto/algif_skcipher.c | 7 +------
>  2 files changed, 1 insertion(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
