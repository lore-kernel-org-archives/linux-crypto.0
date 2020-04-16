Return-Path: <SRS0=NP+Z=6A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E31C352BE
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5618B21556
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437209AbgDPGxD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:53:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41506 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437083AbgDPGws (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Apr 2020 02:52:48 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jOyOA-0005NM-R2; Thu, 16 Apr 2020 16:52:44 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Apr 2020 16:52:42 +1000
Date:   Thu, 16 Apr 2020 16:52:42 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] crypto: algapi - Avoid spurious modprobe on LOADED
Message-ID: <20200416065242.GA8061@gondor.apana.org.au>
References: <20200407051744.GA13037@gondor.apana.org.au>
 <20200407060240.175837-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407060240.175837-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 06, 2020 at 11:02:40PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently after any algorithm is registered and tested, there's an
> unnecessary request_module("cryptomgr") even if it's already loaded.
> Also, CRYPTO_MSG_ALG_LOADED is sent twice, and thus if the algorithm is
> "crct10dif", lib/crc-t10dif.c replaces the tfm twice rather than once.
> 
> This occurs because CRYPTO_MSG_ALG_LOADED is sent using
> crypto_probing_notify(), which tries to load "cryptomgr" if the
> notification is not handled (NOTIFY_DONE).  This doesn't make sense
> because "cryptomgr" doesn't handle this notification.
> 
> Fix this by using crypto_notify() instead of crypto_probing_notify().
> 
> Fixes: dd8b083f9a5e ("crypto: api - Introduce notifier for new crypto algorithms")
> Cc: <stable@vger.kernel.org> # v4.20+
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  crypto/algapi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
