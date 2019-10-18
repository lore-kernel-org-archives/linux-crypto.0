Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F217CA9EA1
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 352822089C
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391356AbfJRIEI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:04:08 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37306 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbfJRIEI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 04:04:08 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iLNEp-0001uY-CI; Fri, 18 Oct 2019 19:03:56 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Oct 2019 19:03:55 +1100
Date:   Fri, 18 Oct 2019 19:03:55 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-geode@lists.infradead.org,
        Gert Robben <t2@gert.gr>, Florian Bezdeka <florian@bezdeka.de>,
        Jelle de Jong <jelledejong@powercraft.nl>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: geode-aes - convert to skcipher API and make
 thread-safe
Message-ID: <20191018080355.GE25128@gondor.apana.org.au>
References: <20191011045132.159422-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011045132.159422-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 10, 2019 at 09:51:32PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The geode AES driver is heavily broken because it stores per-request
> state in the transform context.  So it will crash or produce the wrong
> result if used by any of the many places in the kernel that issue
> concurrent requests for the same transform object.
> 
> This driver is also implemented using the deprecated blkcipher API,
> which makes it difficult to fix, and puts it among the drivers
> preventing that API from being removed.
> 
> Convert this driver to use the skcipher API, and change it to not store
> per-request state in the transform context.
> 
> Fixes: 9fe757b0cfce ("[PATCH] crypto: Add support for the Geode LX AES hardware")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> NOTE: I don't have the hardware to test this patch.  Anyone who does,
> please check whether it passes CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, and
> whether it still works for anything else you're using it for.
> 
>  drivers/crypto/geode-aes.c | 440 +++++++++++++------------------------
>  drivers/crypto/geode-aes.h |  15 +-
>  2 files changed, 149 insertions(+), 306 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
