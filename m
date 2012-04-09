From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3 v4] crypto: ux500: Add driver for HASH hardware
Date: Mon, 9 Apr 2012 15:09:19 +0800
Message-ID: <20120409070919.GA30624@gondor.apana.org.au>
References: <1333098168-30706-1-git-send-email-andreas.westin@stericsson.com> <1333098168-30706-3-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kim.phillips@freescale.com
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:60979 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752919Ab2DIHJ2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Apr 2012 03:09:28 -0400
Content-Disposition: inline
In-Reply-To: <1333098168-30706-3-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 30, 2012 at 11:02:47AM +0200, Andreas Westin wrote:
>
> +/**
> + * hash_hw_update - Updates current HASH computation hashing another part of
> + *                  the message.
> + * @req:	Byte array containing the message to be hashed (caller
> + *		allocated).
> + *
> + * Reentrancy: Non Re-entrant
> + */

As the crypto API is reentrant this comment suggests that this
driver cannot be accepted as is.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
