From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Wed, 10 Feb 2010 07:45:19 +1100
Message-ID: <20100209204519.GC26258@gondor.apana.org.au>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com> <20100209073718.GA17612@gondor.apana.org.au> <20100209145705.GA20421@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	linux-crypto@ml.breakpoint.cc, dm-devel@redhat.com, agk@redhat.com,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebatian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37899 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752046Ab0BIUpX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 15:45:23 -0500
Content-Disposition: inline
In-Reply-To: <20100209145705.GA20421@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 09, 2010 at 03:57:05PM +0100, Sebastian Andrzej Siewior wrote:
>
> >As to blacklisting algorithms not suitable for disk encryption,
> >that is up to the dm-crypt maintainers to decide.
> 
> Herbert, what happend to the "check for streamcipher" idea you had? Is
> it gone? On the other hand it wouldn't be probably that bad to have a

Well again whether that should be done is up to the dm-crypt
maintainers.

> seprate interface to grab a block cipher _or_ a stream cipher. So

Just because something isn't a stream cipher doesn't mean that
it is safe for disk encryption.  People simply shouldn't be using
random algorithms for disk encryption.

> I can't imaging how you want to fix arc4 that it will work in dm-crypt.

I thought I've explained this before.  Just turn it into a blkcipher
and add IV.

> The algorithm relies more or less on the fact that it envolves itself
> during processing of data.

This is no different to any stream cipher.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
