From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Mon, 18 Jul 2016 10:59:05 +0200
Message-ID: <20160718085905.GA5701@amd>
References: <20160629144242.GE22818@mwanda>
 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
 <1467319339.22178.256.camel@linux.intel.com>
 <20160701075559.GA11902@gmail.com>
 <20160701092806.GA13424@gondor.apana.org.au>
 <20160701101329.GA3833@gmail.com>
 <20160708162803.GA29111@linux.intel.com>
 <20160708164502.GA3064@gondor.apana.org.au>
 <CA+55aFyQYJerovMsSoSKS7PessZBr4vNp-3QUUwhqk4A4_jcbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52865 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbcGRI7J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 04:59:09 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFyQYJerovMsSoSKS7PessZBr4vNp-3QUUwhqk4A4_jcbg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri 2016-07-08 10:19:26, Linus Torvalds wrote:
> [ rare comment rant. I think I'll do this once, and then ignore the discussion ]
> 
> On Fri, Jul 8, 2016 at 9:45 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Nack.  As I said the commenting style in the crypto API is the
> > same as the network stack.  So unless we decide to change both
> > please stick to the current style.
> 
> Can we please get rid of the brain-damaged stupid networking comment
> syntax style, PLEASE?

Please? :-). Having different comment styles between networking and
the rest is confusing.

And yes, this uglyness is documented for net/ and drivers/net/, but
not for crypto/, so at the very least Documentation/CodingStyle should
be updated.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
