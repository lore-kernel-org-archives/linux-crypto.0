From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 26 Jan 2010 14:34:13 +0100
Message-ID: <20100126133413.GA5511@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com>
 <4B5DE54F.7050206@redhat.com>
 <20100126092234.GA3304@Chamillionaire.breakpoint.cc>
 <4B5EC897.5050102@redhat.com>
 <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
	Alasdair G Kergon <agk@redhat.com>,
	linux-crypto@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46149 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab0AZNeO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2010 08:34:14 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Mikulas Patocka | 2010-01-26 07:27:18 [-0500]:

>> yes, I think it is better.
>> (...and I just forgot to add that test to dm-crypt after that suggestion.)
>> 
>> Milan
>
>Hmm, there is salsa20 that has block size 1, larger initialization 
>vectors, and can be used to encrypt disks (although salsa20 doesn't 
>currently work with dm-crypt, because it doesn't accept "ecb(), cbc(), 
>etc." chaining modes --- but if you remove the chaining mode manually, it 
>works).
>
>You should rather add a flag CRYPTO_ALG_CHANGES_STATE to determine that a 
>cipher can't be used to encrypt disks.

Just because it will work does not make it a good idea.

SALSA20 is a stream cipher not a block cipher.
Block ciphers are used to encrypt data.
Stream ciphers are used to create one time pads, a set of encryption
keys, ...
There are block modes like CTR which can turn a block cipher into a
stream cipher. Those should not be used for disk encryption as well.

>
>Mikulas

Sebastian
