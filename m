From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in
	sha1_update()
Date: Fri, 26 Feb 2010 16:55:53 +0100
Message-ID: <20100226155553.GD16335@basil.fritz.box>
References: <4B8692E3.9030509@gmail.com> <20100225.071759.98314060.davem@davemloft.net> <25e057c01002250731q68bb9e28ld009163f2a009f48@mail.gmail.com> <87sk8oqkil.fsf@basil.nowhere.org> <19335.55478.733896.68829@pilspetsen.it.uu.se> <19335.60634.75667.480609@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	roel kluin <roel.kluin@gmail.com>,
	David Miller <davem@davemloft.net>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:51431 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965196Ab0BZPz6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2010 10:55:58 -0500
Content-Disposition: inline
In-Reply-To: <19335.60634.75667.480609@pilspetsen.it.uu.se>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Instead of barrier(), this works with gcc-3.2.3 up to gcc-4.4.3
> for the purpose of making the memset() not disappear:
> 
> 	{
> 		struct s { char c[n]; };
> 		asm("" : : "m"(*(struct s *)p));
> 	}
> 
> Every byte in the [p,p+n[ range must be used. If you only use the
> first byte, via e.g. asm("" :: "m"(*(char*)p)), then the compiler
> _will_ skip scrubbing bytes beyond the first.
> 
> An explicit loop that uses each byte individually also works, but
> results in awful code with older compilers.

I suspect it would be worth asking for a __builtin for this.
iirc Visual C already has one.

BTW I remember finding a few more such cases in random user space
code in past code review.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
