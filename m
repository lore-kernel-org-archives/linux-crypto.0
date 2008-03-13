From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 0/3] Shrink the tcrypt module and fix one XTEA test vector
Date: Thu, 13 Mar 2008 20:29:48 +0800
Message-ID: <20080313122948.GA8743@gondor.apana.org.au>
References: <20080203125524.339000971@breakoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45167 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752783AbYCMM3u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Mar 2008 08:29:50 -0400
Content-Disposition: inline
In-Reply-To: <20080203125524.339000971@breakoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sebastian:

On Sun, Feb 03, 2008 at 01:55:24PM +0100, Sebastian Siewior wrote:
> Hello Herbert,
> 
> I noticed that the tcrypt module got really fat. Don't worry, it is still
> less than the nvidia blob :)
> Patch
> - #1 replaces the memcpy of the struct to something that works with
>   pointers. I noticed that some tests failed without doing this.
> - #2 is the big diet. A copy of the patch is at [1] in case it does not
>   pass the list filters.
> - #3 changes one of the XTEA test vectors because the test vector itself
>   seems to be wrong (and nobody noticed this before).

This is awesome! All applied to cryptodev-2.6.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
