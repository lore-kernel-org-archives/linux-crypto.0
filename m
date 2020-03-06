Return-Path: <SRS0=LFd7=4X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E72AC3F2D1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 01:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F280E20726
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 01:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgCFBwZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 20:52:25 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:46174 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgCFBwZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 20:52:25 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jA2A2-0005vy-NE; Fri, 06 Mar 2020 12:52:23 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Mar 2020 12:52:22 +1100
Date:   Fri, 6 Mar 2020 12:52:22 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto 5.6] crypto: x86/curve25519 - support assemblers
 with no adx support
Message-ID: <20200306015222.GN30653@gondor.apana.org.au>
References: <20200301145235.200032-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301145235.200032-1-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 01, 2020 at 10:52:35PM +0800, Jason A. Donenfeld wrote:
> Some older version of GAS do not support the ADX instructions, similarly
> to how they also don't support AVX and such. This commit adds the same
> build-time detection mechanisms we use for AVX and others for ADX, and
> then makes sure that the curve25519 library dispatcher calls the right
> functions.
> 
> Reported-by: Willy Tarreau <w@1wt.eu>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> This patch is meant for 5.6-rcX.
> 
>  arch/x86/Makefile           | 5 +++--
>  arch/x86/crypto/Makefile    | 7 ++++++-
>  include/crypto/curve25519.h | 6 ++++--
>  3 files changed, 13 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
