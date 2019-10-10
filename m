Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B9BC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74903206B6
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387800AbfJJM5B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 08:57:01 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37664 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733300AbfJJM5B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 08:57:01 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iIY01-0001u3-P0; Thu, 10 Oct 2019 23:56:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2019 23:56:53 +1100
Date:   Thu, 10 Oct 2019 23:56:53 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     linux-crypto@vger.kernel.org, smueller@chronox.de,
        Atul Gupta <atul.gupta@chelsio.com>
Subject: Re: [af_alg v2] crypto:af_alg cast ki_complete ternary op to int
Message-ID: <20191010125653.GH31566@gondor.apana.org.au>
References: <20191004175058.11850-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004175058.11850-1-ayush.sawal@chelsio.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 04, 2019 at 10:50:58AM -0700, Ayush Sawal wrote:
> when libkcapi test is executed  using HW accelerator, cipher operation
> return -74.Since af_alg_async_cb->ki_complete treat err as unsigned int,
> libkcapi receive 429467222 even though it expect -ve value.
> 
> Hence its required to cast resultlen to int so that proper
> error is returned to libkcapi.
> 
> AEAD one shot non-aligned test 2(libkcapi test)
> ./../bin/kcapi   -x 10   -c "gcm(aes)" -i 7815d4b06ae50c9c56e87bd7
> -k ea38ac0c9b9998c80e28fb496a2b88d9 -a
> "853f98a750098bec1aa7497e979e78098155c877879556bb51ddeb6374cbaefc"
> -t "c4ce58985b7203094be1d134c1b8ab0b" -q
> "b03692f86d1b8b39baf2abb255197c98"
> 
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> v1: cast err and resultlen to long
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
> ---
>  crypto/af_alg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
