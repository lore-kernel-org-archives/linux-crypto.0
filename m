From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 9 Feb 2010 09:02:35 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1002090900050.19526@hs20-bc2-1.build.redhat.com>
References: <20100209073718.GA17612@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: mbroz@redhat.com, linux-crypto@ml.breakpoint.cc,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab0BIODk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 09:03:40 -0500
In-Reply-To: <20100209073718.GA17612@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 9 Feb 2010, Herbert Xu wrote:

> Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > You should rather add a flag CRYPTO_ALG_CHANGES_STATE to determine that a 
> > cipher can't be used to encrypt disks.
> 
> No, please see my reply in the previous thread.  What we should
> do is fix arc4.  I just haven't got around to doing it yet.

What is the fix for arc4? Copy the internal state after a key schedule and 
restore it with every encryption?

> As to blacklisting algorithms not suitable for disk encryption,
> that is up to the dm-crypt maintainers to decide.
> 
> Cheers,

I think blacklisting "arc4" is better, because it provides a fix now. 
Otherwise, people will just keep on arguing what is the "clean" solution 
and nothing gets done.

Mikulas
