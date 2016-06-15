From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Wed, 15 Jun 2016 22:59:08 +0800
Message-ID: <20160615145908.GA18866@gondor.apana.org.au>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <1465832919-11316-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	andi@firstfloor.org, sandyinchina@gmail.com, jsd@av8n.com,
	hpa@zytor.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52121 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbcFOO7R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 10:59:17 -0400
Content-Disposition: inline
In-Reply-To: <1465832919-11316-6-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 13, 2016 at 11:48:37AM -0400, Theodore Ts'o wrote:
> The CRNG is faster, and we don't pretend to track entropy usage in the
> CRNG any more.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  crypto/chacha20_generic.c |  61 --------
>  drivers/char/random.c     | 374 +++++++++++++++++++++++++++++++++-------------
>  include/crypto/chacha20.h |   1 +
>  lib/Makefile              |   2 +-
>  lib/chacha20.c            |  79 ++++++++++
>  5 files changed, 353 insertions(+), 164 deletions(-)
>  create mode 100644 lib/chacha20.c
> 
> diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
> index da9c899..1cab831 100644
> --- a/crypto/chacha20_generic.c
> +++ b/crypto/chacha20_generic.c

I think you should be accessing this through the crypto API rather
than going direct.  We already have at least one accelerated
implementation of chacha20 and there may well be more of them
in future.  Going through the crypto API means that you will
automatically pick up the best implementation for the platform.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
