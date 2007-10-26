From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Patch to support stream ciphers
Date: Fri, 26 Oct 2007 14:21:02 +0400
Message-ID: <20071026102102.GB4970@2ka.mipt.ru>
References: <fd3e431c0710251055n1e810c90u285bb0be7d95dd07@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52314 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbXJZKVs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2007 06:21:48 -0400
Content-Disposition: inline
In-Reply-To: <fd3e431c0710251055n1e810c90u285bb0be7d95dd07@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi.

On Fri, Oct 26, 2007 at 01:55:48AM +0800, Tan Swee Heng (thesweeheng@gmail.com) wrote:
> Hi all,
> 
> I am learning CryptoAPI by porting stream ciphers into it
> (particularly eSTREAM candidates at
> <http://www.ecrypt.eu.org/stream/>). As eSTREAM ciphers manipulates IV
> differently depending on algorithm design, it seems that standard
> block modes cannot be used: ECB has no IV; CBC and CTR don't let
> ciphers control how the IV is processed.
> 
> So I derived stream.c from Herbert's cbc.c and Joy's ctr.c. It wraps
> around any cipher exporting cia_ivsize and cia_setiv_crypt() from
> "struct cipher_alg". As a test case, I've used Daniel Bernstein's
> Salsa20 implementation at <http://cr.yp.to/snuffle.html> as the
> cipher. My patch against Herbert's cryptodev-2.6 git is attached.
> 
> Some questions come to mind:
>  1. Is this the way to go for general stream ciphers?
>  2. Would a separate "struct stream_alg" be better than hijacking
> "struct cipher_alg"?
>  3. Currently cia_setiv_crypt() does setiv() and inplace encryption;
> is this a good design?
>  4. Should the blocksize be 1 for the stream template?

It depends. I do not know any stream cipher, which operates on 1-byte
quantity in real life, but stream means 1-byte blocksize is a correct
assumption.

Your approach is likely the less intrusive for existing block-based
design, so I believe this is a way to go.

Besides number of codying style issues (like comments, () placement,
spaces and the like) it looks good.

-- 
	Evgeniy Polyakov
