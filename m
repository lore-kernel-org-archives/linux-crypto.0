Return-Path: <SRS0=zaW3=BX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172F8C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 19:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1F1E20838
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 19:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597347162;
	bh=ncO0/loO/c3oh5BhhMwIm39kXDttCNxlxMDJJm1l5WE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LZ5oJjLF3lCroje5fLO7q9xiIGxCXV4mzGhFxXoE45BLUtilsblbJ5ubhEx6lXMTE
	 GD31Yod1DuwhBoUlE29SK8O8CVZ0HM2Eyyvp57nEUeuLpPcaDJHAT+XXpXt+jx6qFU
	 Z2gB0WlbinJNjBCpE5E/RUSn+t4HMwDGaw1OeYXQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgHMTcm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Aug 2020 15:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgHMTcm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Aug 2020 15:32:42 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1ED020791;
        Thu, 13 Aug 2020 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597347161;
        bh=ncO0/loO/c3oh5BhhMwIm39kXDttCNxlxMDJJm1l5WE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VRra9OG7qww58DHpfa2HwoP4KJ0NLmXPjRDCWssktWbd8uP9AnbY9plK1LJfAodgq
         xrZ3jV2VIt0BeUL38Rmw6YrzPZS5Thl8bGJ2SpaWb5G0hkJqD+KF5peEmmYZoWoDq0
         pYdEO+ns75RqhnV4IfxdvUt+bx8ljNpDWPMA9jow=
Date:   Thu, 13 Aug 2020 12:32:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Elena Petrova <lenaptr@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Subject: Re: [PATCH v5] crypto: af_alg - add extra parameters for DRBG
 interface
Message-ID: <20200813193239.GA2470@sol.localdomain>
References: <CABvBcwYPXvK1_b2hR5THaqfq8nKVwppdBd2aJF6cmS_aCxHxUg@mail.gmail.com>
 <20200813160811.3568494-1-lenaptr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200813160811.3568494-1-lenaptr@google.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 13, 2020 at 05:08:11PM +0100, Elena Petrova wrote:
> Extend the user-space RNG interface:
>   1. Add entropy input via ALG_SET_DRBG_ENTROPY setsockopt option;
>   2. Add additional data input via sendmsg syscall.
> 
> This allows DRBG to be tested with test vectors, for example for the
> purpose of CAVP testing, which otherwise isn't possible.
> 
> To prevent erroneous use of entropy input, it is hidden under
> CRYPTO_USER_API_CAVP_DRBG config option and requires CAP_SYS_ADMIN to
> succeed.
> 
> Signed-off-by: Elena Petrova <lenaptr@google.com>
> Acked-by: Stephan Müller <smueller@chronox.de>
> ---
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
>  Documentation/crypto/userspace-if.rst |  17 ++-
>  crypto/Kconfig                        |   9 ++
>  crypto/af_alg.c                       |   8 ++
>  crypto/algif_rng.c                    | 172 ++++++++++++++++++++++++--
>  include/crypto/if_alg.h               |   1 +
>  include/uapi/linux/if_alg.h           |   1 +
>  6 files changed, 193 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
> index ff86befa61e0..ef7132802c2d 100644
> --- a/Documentation/crypto/userspace-if.rst
> +++ b/Documentation/crypto/userspace-if.rst
> @@ -296,15 +296,23 @@ follows:
>  
>      struct sockaddr_alg sa = {
>          .salg_family = AF_ALG,
> -        .salg_type = "rng", /* this selects the symmetric cipher */
> -        .salg_name = "drbg_nopr_sha256" /* this is the cipher name */
> +        .salg_type = "rng", /* this selects the random number generator */
> +        .salg_name = "drbg_nopr_sha256" /* this is the RNG name */
>      };
>  
>  
>  Depending on the RNG type, the RNG must be seeded. The seed is provided
>  using the setsockopt interface to set the key. For example, the
>  ansi_cprng requires a seed. The DRBGs do not require a seed, but may be
> -seeded.
> +seeded. The seed is also known as a *Personalization String* in DRBG800-90A
> +standard.

Isn't the standard called "NIST SP 800-90A"?
"DRBG800-90A" doesn't return many hits on Google.

> +For the purpose of CAVP testing, the concatenation of *Entropy* and *Nonce*
> +can be provided to the RNG via ALG_SET_DRBG_ENTROPY setsockopt interface. This
> +requires a kernel built with CONFIG_CRYPTO_USER_API_CAVP_DRBG, and
> +CAP_SYS_ADMIN permission.
> +
> +*Additional Data* can be provided using the send()/sendmsg() system calls.

This doesn't make it clear whether the support for "Additional Data" is
dependent on CONFIG_CRYPTO_USER_API_CAVP_DRBG or not.

> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 091c0a0bbf26..7c8736f71681 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1896,6 +1896,15 @@ config CRYPTO_STATS
>  config CRYPTO_HASH_INFO
>  	bool
>  
> +config CRYPTO_USER_API_CAVP_DRBG
> +	tristate "Enable CAVP testing of DRBG"
> +	depends on CRYPTO_USER_API_RNG && CRYPTO_DRBG
> +	help
> +	  This option enables extra API for CAVP testing via the user-space
> +	  interface: resetting of DRBG entropy, and providing Additional Data.
> +	  This should only be enabled for CAVP testing. You should say
> +	  no unless you know what this is.

Using "tristate" here is incorrect because this option is not a module itself.
It's an option *for* a module.  So it needs to be "bool" instead.

Also, since this is an option to refine CRYPTO_USER_API_RNG, how about renaming
it to "CRYPTO_USER_API_RNG_CAVP", and moving it to just below the definition of
"CRYPTO_USER_API_RNG" so that they show up adjacent to each other?

> +static int rng_test_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> +			    int flags)
> +{
> +	struct sock *sk = sock->sk;
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct rng_ctx *ctx = ask->private;
> +	int err;
> +
> +	lock_sock(sock->sk);
> +	err = _rng_recvmsg(ctx->drng, msg, len, ctx->addtl, ctx->addtl_len);
> +	rng_reset_addtl(ctx);
> +	release_sock(sock->sk);
> +
> +	return err ? err : len;

Shouldn't this just return the value that _rng_recvmsg() returned?

Also 'err' is conventionally just for 0 or -errno codes.  Use 'ret' if the
variable can also hold a length.

> +static struct proto_ops __maybe_unused algif_rng_test_ops = {
> +	.family		=	PF_ALG,
> +
> +	.connect	=	sock_no_connect,
> +	.socketpair	=	sock_no_socketpair,
> +	.getname	=	sock_no_getname,
> +	.ioctl		=	sock_no_ioctl,
> +	.listen		=	sock_no_listen,
> +	.shutdown	=	sock_no_shutdown,
> +	.getsockopt	=	sock_no_getsockopt,
> +	.mmap		=	sock_no_mmap,
> +	.bind		=	sock_no_bind,
> +	.accept		=	sock_no_accept,
> +	.setsockopt	=	sock_no_setsockopt,
> +	.sendpage	=	sock_no_sendpage,
> +
> +	.release	=	af_alg_release,
> +	.recvmsg	=	rng_test_recvmsg,
> +	.sendmsg	=	rng_test_sendmsg,
> +};
[...]
>  static const struct af_alg_type algif_type_rng = {
> @@ -171,7 +314,12 @@ static const struct af_alg_type algif_type_rng = {
>  	.release	=	rng_release,
>  	.accept		=	rng_accept_parent,
>  	.setkey		=	rng_setkey,
> +#if IS_ENABLED(CONFIG_CRYPTO_USER_API_CAVP_DRBG)
> +	.setentropy	=	rng_setentropy,
> +	.ops		=	&algif_rng_test_ops,
> +#else
>  	.ops		=	&algif_rng_ops,
> +#endif
>  	.name		=	"rng",
>  	.owner		=	THIS_MODULE
>  };

I think that switching to the separate proto_ops structs made the patch worse.
Now there's duplicated code.

Since proto_ops are almost identical, and only one is used in a given kernel
build, why not just do:

static struct proto_ops algif_rng_ops = {
	...
#ifdef CONFIG_CRYPTO_USER_API_RNG_CAVP
	.sendmsg	= rng_sendmsg,
#else
	.sendmsg	= sock_no_sendmsg,
#endif
	...
};

Similarly for .recvmsg(), although I don't understand what's wrong with just
adding the lock_sock() instead...  The RNG algorithms do locking anyway, so it's
not like that would regress the ability to recvmsg() in parallel.  Also,
conditional locking depending on the kernel config makes it more difficult to
find kernel bugs like deadlocks.

- Eric
