From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Moving xor_* functions into common header file
Date: Tue, 20 Nov 2007 16:52:19 +0800
Message-ID: <20071120085219.GA15675@gondor.apana.org.au>
References: <fd3e431c0711191034qe0bda50r5123544076795b42@mail.gmail.com> <20071120073335.GA15090@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4784 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732AbXKTIwY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Nov 2007 03:52:24 -0500
Content-Disposition: inline
In-Reply-To: <20071120073335.GA15090@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 20, 2007 at 03:33:35PM +0800, Herbert Xu wrote:
>
> I'm currently working on a patch to just restrict the block
> size for non-stream ciphers to multiples of 8 since that's what
> we have anyway.  That allows us to just use bitmap_xor.

Nevermind, obviously stream ciphers do need xors to the byte.
So I'm spinning up a patch to put this into algapi.c and hence
available for all crypto algorithms.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
