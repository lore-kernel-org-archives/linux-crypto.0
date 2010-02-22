From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
 cipher
Date: Mon, 22 Feb 2010 23:08:35 +0100
Message-ID: <20100222220835.GB31291@Chamillionaire.breakpoint.cc>
References: <20100209073718.GA17612@gondor.apana.org.au>
 <20100209145705.GA20421@Chamillionaire.breakpoint.cc>
 <20100209204519.GC26258@gondor.apana.org.au>
 <20100209211238.GC21548@Chamillionaire.breakpoint.cc>
 <20100209214522.GA27002@gondor.apana.org.au>
 <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
 <20100216125125.GA390@gondor.apana.org.au>
 <20100221200140.GC11951@Chamillionaire.breakpoint.cc>
 <20100222004547.GA24812@gondor.apana.org.au>
 <20100222005217.GA24920@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40847 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643Ab0BVWIm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Feb 2010 17:08:42 -0500
Content-Disposition: inline
In-Reply-To: <20100222005217.GA24920@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2010-02-22 08:52:17 [+0800]:

>On Mon, Feb 22, 2010 at 08:45:47AM +0800, Herbert Xu wrote:
>> 
>> How about this? You extend the IV by one more byte, and use that
>> byte as a boolean flag to indicate whether the IV is valid.  All
So I trick the crypto api to allocate more bytes than ->ivsize says.

>> users that cannot supply their own IVs can then set the IV to zero.
which works fine with kzalloc()

>> When you see the zero flag in the IV, you reinitialise the IV per
>> the key.
Okay. When we have to re-key and the user calls setkey() without
re-allocating thr cipher then I would not notice this. So I need a
counter. And all this will make it work but I still think it is fishy.
Plus we waste 258bytes.

>In fact for arc4 we could just drop the key altogether since it
>plays no part after setting the initial state.
Since I'm not allowed to kfree() the ctx in encrypt() are you proposing
tfm->setup_iv(iv, key)? 

>> > salsa also does not stick to plan here. ctx->input[6-9] is initialized
>> > in encrypt() path. So two threads sharing a ctx are going to clobber
>> > their state.
>> 
>> Salsa should also be fixed.
I saw that comming. And I complaind back then that the assembly code was
not pretty enough... and removing the assembly is probably not option :)

>For Salsa on the other hand the key is rather useful since all
>we need is a two-byte IV that's just a sequence number.
No it's 8 bytes. Berstein's U8TO32_LITTLE() is actually a cpu_to_be32().
Not sure if he knows it :)
However I'm not sure where you going with this. salsa is fine besides
the clobber thing, isn't it?

>Cheers,

Sebastian
