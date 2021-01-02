Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96453C433DB
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE79207A5
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbhABWLP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 17:11:15 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37428 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbhABWLP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 17:11:15 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvp6Q-0000pa-UQ; Sun, 03 Jan 2021 09:10:28 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 09:10:26 +1100
Date:   Sun, 3 Jan 2021 09:10:26 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, pavel@denx.de
Subject: Re: [PATCH] crypto: ecdh - avoid buffer overflow in ecdh_set_secret()
Message-ID: <20210102221026.GS12767@gondor.apana.org.au>
References: <20210102135909.5637-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210102135909.5637-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jan 02, 2021 at 02:59:09PM +0100, Ard Biesheuvel wrote:
> Pavel reports that commit 17858b140bf4 ("crypto: ecdh - avoid unaligned
> accesses in ecdh_set_secret()") fixes one problem but introduces another:
> the unconditional memcpy() introduced by that commit may overflow the
> target buffer if the source data is invalid, which could be the result of
> intentional tampering.
> 
> So check params.key_size explicitly against the size of the target buffer
> before validating the key further.
> 
> Fixes: 17858b140bf4 ("crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()")
> Reported-by: Pavel Machek <pavel@denx.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/ecdh.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
