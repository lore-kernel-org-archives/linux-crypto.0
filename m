From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 26 Jan 2010 12:11:52 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1001261203220.10059@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com>
 <4B5DE54F.7050206@redhat.com> <20100126092234.GA3304@Chamillionaire.breakpoint.cc>
 <4B5EC897.5050102@redhat.com> <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
 <20100126133413.GA5511@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
	Alasdair G Kergon <agk@redhat.com>,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0AZRMQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2010 12:12:16 -0500
In-Reply-To: <20100126133413.GA5511@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 26 Jan 2010, Sebastian Andrzej Siewior wrote:

> * Mikulas Patocka | 2010-01-26 07:27:18 [-0500]:
> 
> >> yes, I think it is better.
> >> (...and I just forgot to add that test to dm-crypt after that suggestion.)
> >> 
> >> Milan
> >
> >Hmm, there is salsa20 that has block size 1, larger initialization 
> >vectors, and can be used to encrypt disks (although salsa20 doesn't 
> >currently work with dm-crypt, because it doesn't accept "ecb(), cbc(), 
> >etc." chaining modes --- but if you remove the chaining mode manually, it 
> >works).
> >
> >You should rather add a flag CRYPTO_ALG_CHANGES_STATE to determine that a 
> >cipher can't be used to encrypt disks.
> 
> Just because it will work does not make it a good idea.
> 
> SALSA20 is a stream cipher not a block cipher.
> Block ciphers are used to encrypt data.
> Stream ciphers are used to create one time pads, a set of encryption
> keys, ...
> There are block modes like CTR which can turn a block cipher into a
> stream cipher. Those should not be used for disk encryption as well.

Salsa20 is unsuitable for disk encryption in most cases. It would be 
suitable if we knew that the attacker can obtain the image of encrypted 
device at most once --- it is OK to protect against laptop theft (it 
happens just once), but it is not OK to protect against support technician 
spying on your data (he can read them multiple times, if you have multiple 
support requests).

Anyway, what I wanted to say, is that block_size <= 1 test is no less 
hacky than !strcmp(cipher, "arc4") test.

Mikulas
