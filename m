Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBA7C4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D84A208A9
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgIYIQz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:16:55 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53378 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727248AbgIYIQz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 04:16:55 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLiuS-0007O2-8c; Fri, 25 Sep 2020 18:16:53 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 18:16:52 +1000
Date:   Fri, 25 Sep 2020 18:16:52 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Elena Petrova <lenaptr@google.com>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v9] crypto: af_alg - add extra parameters for DRBG
 interface
Message-ID: <20200925081651.GQ6381@gondor.apana.org.au>
References: <20200918064348.GA9479@gondor.apana.org.au>
 <20200918154216.1678740-1-lenaptr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200918154216.1678740-1-lenaptr@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 18, 2020 at 04:42:16PM +0100, Elena Petrova wrote:
> Extend the user-space RNG interface:
>   1. Add entropy input via ALG_SET_DRBG_ENTROPY setsockopt option;
>   2. Add additional data input via sendmsg syscall.
> 
> This allows DRBG to be tested with test vectors, for example for the
> purpose of CAVP testing, which otherwise isn't possible.
> 
> To prevent erroneous use of entropy input, it is hidden under
> CRYPTO_USER_API_RNG_CAVP config option and requires CAP_SYS_ADMIN to
> succeed.
> 
> Signed-off-by: Elena Petrova <lenaptr@google.com>
> Acked-by: Stephan Müller <smueller@chronox.de>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> Updates in v9:
>   Add IS_ENABLED(CONFIG_CRYPTO_USER_API_RNG_CAVP) condition for replacing
>   proto_ops.
> 
> Updates in v8:
>   Added Reviewed-by tag to the description.
> 
> Updates in v7:
>   1) rebased onto the latest at cryptodev-2.6.git, fixed compiler errors;
>   2) replaced kzfree with kfree_sensitive;
>   3) changed rng_test_sendmsg to return an error if len > MAXSIZE;
>   4) updated documentation to say when can Additional Data be provided.
> 
> Updates in v6:
>   1) Kconfig option renamed to CRYPTO_USER_API_RNG_CAVP and is now bool instead
>      of tristate;
>   2) run-time switch of proto_ops depending on whether the entropy was set;
>   3) corrected the NIST standard name;
>   4) rebased onto the tip of the tree;
>   5) documentation clarified;
> 
> Updates in v5:
>   1) use __maybe_unused instead of #ifdef;
>   2) separate code path for a testing mode;
>   3) only allow Additional Data input in a testing mode.
> 
> Updates in v4:
>   1) setentropy returns 0 or error code (used to return length);
>   2) bigfixes suggested by Eric.
> 
> Updates in v3:
>   1) More details in commit message;
>   2) config option name is now CRYPTO_USER_API_CAVP_DRBG;
>   3) fixed a bug of not releasing socket locks.
> 
> Updates in v2:
>   1) Adding CONFIG_CRYPTO_CAVS_DRBG around setentropy.
>   2) Requiring CAP_SYS_ADMIN for entropy reset.
>   3) Locking for send and recv.
>   4) Length checks added for send and setentropy; send and setentropy now return
>      number of bytes accepted.
>   5) Minor code style corrections.
> 
> libkcapi patch for testing:
>   https://github.com/Len0k/libkcapi/commit/6f095d270b982008f419078614c15caa592cb531
> 
>  Documentation/crypto/userspace-if.rst |  20 ++-
>  crypto/Kconfig                        |   9 ++
>  crypto/af_alg.c                       |  14 ++-
>  crypto/algif_rng.c                    | 175 ++++++++++++++++++++++++--
>  include/crypto/if_alg.h               |   1 +
>  include/uapi/linux/if_alg.h           |   1 +
>  6 files changed, 205 insertions(+), 15 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
