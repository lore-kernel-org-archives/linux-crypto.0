Return-Path: <SRS0=tFxg=4K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF970C35670
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F7D720722
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgBVBnC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 20:43:02 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52260 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727723AbgBVBnB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 20:43:01 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1j5Jon-000308-CL; Sat, 22 Feb 2020 12:42:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Feb 2020 12:42:57 +1100
Date:   Sat, 22 Feb 2020 12:42:57 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 0/9] crypto: caam - backlogging support
Message-ID: <20200222014257.GF19028@gondor.apana.org.au>
References: <1581530124-9135-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581530124-9135-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 12, 2020 at 07:55:15PM +0200, Iuliana Prodan wrote:
> Integrate crypto_engine framework into CAAM, to make use of
> the engine queue.
> Added support for SKCIPHER, HASH, RSA and AEAD algorithms.
> This is intended to be used for CAAM backlogging support.
> The requests, with backlog flag (e.g. from dm-crypt) will be
> listed into crypto-engine queue and processed by CAAM when free.
> 
> While here, I've also made some refactorization.
> Patches #1 - #4 include some refactorizations on caamalg, caamhash
> and caampkc.
> Patch #5 changes the return code of caam_jr_enqueue function
> to -EINPROGRESS, in case of success, -ENOSPC in case the CAAM is
> busy, -EIO if it cannot map the caller's descriptor.
> Patches #6 - #9 integrate crypto_engine into CAAM, for
> SKCIPHER/AEAD/RSA/HASH algorithms.
> 
> ---
> Changes since V5:
> 	- remove unnecessary initializations;
> 	- add local variable for share descriptor offset for skcipher and hash;
> 	- handle error case for ahash_update_first and ahash_update_no_ctx.
> 
> Changes since V4:
> 	- reorganize {skcipher,aead,rsa}_edesc struct for a proper
> 	  cacheline sharing.
> 
> Changes since V3:
> 	- update return on ahash_enqueue_req function from patch #9.
> 
> Changes since V2:
> 	- remove patch ("crypto: caam - refactor caam_jr_enqueue"),
> 	  that added some structures not needed anymore;
> 	- use _done_ callback function directly for skcipher and aead;
> 	- handle resource leak in case of transfer request to crypto-engine;
> 	- update commit messages.
> 
> Changes since V1:
> 	- remove helper function - akcipher_request_cast;
> 	- remove any references to crypto_async_request,
> 	  use specific request type;
> 	- remove bypass crypto-engine queue, in case is empty;
> 	- update some commit messages;
> 	- remove unrelated changes, like whitespaces;
> 	- squash some changes from patch #9 to patch #6;
> 	- added Reviewed-by.
> 
> Iuliana Prodan (9):
>   crypto: caam - refactor skcipher/aead/gcm/chachapoly {en,de}crypt
>     functions
>   crypto: caam - refactor ahash_done callbacks
>   crypto: caam - refactor ahash_edesc_alloc
>   crypto: caam - refactor RSA private key _done callbacks
>   crypto: caam - change return code in caam_jr_enqueue function
>   crypto: caam - support crypto_engine framework for SKCIPHER algorithms
>   crypto: caam - add crypto_engine support for AEAD algorithms
>   crypto: caam - add crypto_engine support for RSA algorithms
>   crypto: caam - add crypto_engine support for HASH algorithms
> 
>  drivers/crypto/caam/Kconfig    |   1 +
>  drivers/crypto/caam/caamalg.c  | 413 ++++++++++++++++++-----------------------
>  drivers/crypto/caam/caamhash.c | 338 +++++++++++++++++----------------
>  drivers/crypto/caam/caampkc.c  | 185 +++++++++++-------
>  drivers/crypto/caam/caampkc.h  |  10 +
>  drivers/crypto/caam/caamrng.c  |   4 +-
>  drivers/crypto/caam/intern.h   |   2 +
>  drivers/crypto/caam/jr.c       |  36 +++-
>  drivers/crypto/caam/key_gen.c  |   2 +-
>  9 files changed, 512 insertions(+), 479 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
