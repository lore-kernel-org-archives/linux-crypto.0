Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4ABC433E0
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 21:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A266F20795
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 21:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbhABVZz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 16:25:55 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37128 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbhABVZz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 16:25:55 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvoOT-00009r-DV; Sun, 03 Jan 2021 08:25:02 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 08:25:01 +1100
Date:   Sun, 3 Jan 2021 08:25:01 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] drivers: crypto: qce: sha: Restore/save
 sha1_state/sha256_state with qce_sha_reqctx in export/import
Message-ID: <20210102212501.GA1931@gondor.apana.org.au>
References: <20201219033027.3066042-1-thara.gopinath@linaro.org>
 <20201219033027.3066042-2-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219033027.3066042-2-thara.gopinath@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 18, 2020 at 10:30:22PM -0500, Thara Gopinath wrote:
> Export and import interfaces save and restore partial transformation
> states. The partial states were being stored and restored in struct
> sha1_state for sha1/hmac(sha1) transformations and sha256_state for
> sha256/hmac(sha256) transformations.This led to a bunch of corner cases
> where improper state was being stored and restored. A few of the corner
> cases that turned up during testing are:
> 
> - wrong byte_count restored if export/import is called twice without h/w
> transaction in between
> - wrong buflen restored back if the pending buffer
> length is exactly the block size.
> - wrong state restored if buffer length is 0.
> 
> To fix these issues, save and restore the entire qce_sha_rctx structure
> instead of parts of it in sha1_state and sha256_state structures.
> This in turn simplifies the export and import apis.
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  drivers/crypto/qce/sha.c | 93 ++++------------------------------------
>  1 file changed, 8 insertions(+), 85 deletions(-)

How is this safe when the reqctx structure contains pointers?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
