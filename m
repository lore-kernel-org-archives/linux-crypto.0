From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 26 Jan 2010 07:27:18 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com>
 <4B5DE54F.7050206@redhat.com> <20100126092234.GA3304@Chamillionaire.breakpoint.cc>
 <4B5EC897.5050102@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
	linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab0AZM1r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2010 07:27:47 -0500
In-Reply-To: <4B5EC897.5050102@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> >>> This patch disables the use of arc4 on block devices.
> >>
> >> arc4 again. it is simply not a block cipher:-)
> >>
> >> This should be solved inside cryptoAPI and not blacklist it in dm-crypt,
> >> see that thread
> >> http://article.gmane.org/gmane.linux.kernel.cryptoapi/3441
> > 
> > I some how remember Herbert saying to test for block size > 1. Wouldn't
> > this be acceptable to block all stream cipher in one go?
> 
> yes, I think it is better.
> (...and I just forgot to add that test to dm-crypt after that suggestion.)
> 
> Milan

Hmm, there is salsa20 that has block size 1, larger initialization 
vectors, and can be used to encrypt disks (although salsa20 doesn't 
currently work with dm-crypt, because it doesn't accept "ecb(), cbc(), 
etc." chaining modes --- but if you remove the chaining mode manually, it 
works).

You should rather add a flag CRYPTO_ALG_CHANGES_STATE to determine that a 
cipher can't be used to encrypt disks.

Mikulas
