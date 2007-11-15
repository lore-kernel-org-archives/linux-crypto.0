From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: [PATCH 2/3] [eSTREAM] stream: Wrapper for eSTREAM ciphers
Date: Thu, 15 Nov 2007 09:14:40 +0800
Message-ID: <fd3e431c0711141714qbd444f9o2b15973caaf15a3c@mail.gmail.com>
References: <fd3e431c0711121159p4eec500fw5a3caec76f07295d@mail.gmail.com>
	 <E1IrkoZ-0007hT-00@gondolin.me.apana.org.au>
	 <fd3e431c0711130925s6b7acddck80dd0054b41d1147@mail.gmail.com>
	 <20071114030740.GA8539@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:25810 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbXKOBOl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Nov 2007 20:14:41 -0500
Received: by wa-out-1112.google.com with SMTP id v27so444291wah
        for <linux-crypto@vger.kernel.org>; Wed, 14 Nov 2007 17:14:40 -0800 (PST)
In-Reply-To: <20071114030740.GA8539@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Nov 14, 2007 11:07 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> What I'm suggesting is that you implement the stream ciphers that
> use an IV directly using the blkcipher interface, and not the cipher
> interface.  That way you can do whatever you want with the IV.
The "Ah-ha!" moment! :-) Finally I get what you are saying. Ok, sounds
like a good idea. I will try it out this evening and get back to you
when I am done.

> That's right.  Apart from Salsa you shouldn't have to use the cipher
> interface at all.  Which means that what the cipher interface lacks
> is not a problem :)
I was under the wrong impression that only the templates use the
blkcipher interface.

> Salsa can use the cipher interface because deep down it's a block
> cipher.  It's just being used in counter mode.
I might still implement it using the blkcipher interface as it seems
strange to call it via "ctr(salsa20,..)" as it is meant to be a stream
cipher after all. I always find "ecb(arc4)" kind of strange. :-)

Swee Heng
