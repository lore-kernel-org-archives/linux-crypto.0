Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5B1C43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51AFB2176B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIRHa1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:30:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57668 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbgIRHa1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:30:27 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kJAqf-0003ZI-4V; Fri, 18 Sep 2020 17:30:26 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2020 17:30:25 +1000
Date:   Fri, 18 Sep 2020 17:30:25 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH] crypto: mark unused ciphers as obsolete
Message-ID: <20200918073025.GJ23319@gondor.apana.org.au>
References: <20200911141103.14832-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911141103.14832-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 11, 2020 at 05:11:03PM +0300, Ard Biesheuvel wrote:
> We have a few interesting pieces in our cipher museum, which are never
> used internally, and were only ever provided as generic C implementations.
> 
> Unfortunately, we cannot simply remove this code, as we cannot be sure
> that it is not being used via the AF_ALG socket API, however unlikely.
> 
> So let's mark the Anubis, Khazad, SEED and TEA algorithms as obsolete,
> which means they can only be enabled in the build if the socket API is
> enabled in the first place.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> Hopefully, I will be able to convince the distro kernel maintainers to
> disable CRYPTO_USER_API_ENABLE_OBSOLETE in their v5.10+ builds once the
> iwd changes for arc4 make it downstream (Debian already has an updated
> version in its unstable distro). With the joint coverage of their QA,
> we should be able to confirm that these algos are never used, and
> actually remove them altogether.
> 
>  crypto/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
