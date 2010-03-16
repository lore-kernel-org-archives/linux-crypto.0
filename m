From: Pavel Roskin <proski@gnu.org>
Subject: Re: Converting mac80211 CCMP to packet-at-a-time processing
Date: Tue, 16 Mar 2010 02:21:14 -0400
Message-ID: <1268720474.26820.36.camel@mj>
References: <20100313122847.GA26337@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: roberto.sassu@polito.it, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36823 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965996Ab0CPGVR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Mar 2010 02:21:17 -0400
In-Reply-To: <20100313122847.GA26337@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2010-03-13 at 20:28 +0800, Herbert Xu wrote:
> Pavel Roskin <proski@gnu.org> wrote:
> > 
> > However, it's disappointing that the caller needs to deal explicitly
> > with completions.  The blkcipher API is much simpler.  I would have hard
> > time advocating a patch to CCMP that makes the code more complicated.
> 
> You won't have to deal with completions if you allocate your
> algorithm with the CRYPTO_ALG_ASYNC bit off.  Of course you won't
> be able to use most hardware accelerations either.

Actually, I thought using CRYPTO_ALG_ASYNC in the mask meant to
_exclude_ asynchronous algorithms.

Is there any documentation for Linux crypto API that documents use of
CRYPTO_ALG_ASYNC?  Also, I'd like to know meanings of
CRYPTO_TFM_REQ_MAY_BACKLOG and CRYPTO_TFM_REQ_MAY_SLEEP.

The crypto API feels like a minefield to me - I should check everything
in the code or even experiment to figure out how the public API works.

-- 
Regards,
Pavel Roskin
