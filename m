From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: randconfig build error with next-20150529, in
 crypto/jitterentropy.c
Date: Mon, 8 Jun 2015 20:25:02 +0800
Message-ID: <20150608122502.GA29454@gondor.apana.org.au>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com>
 <CAHp75VeoCQSUCeswTCzUyKbV_e4RTt5t0yjEJLSzAvtX8jFvNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Waiman Long <Waiman.Long@hp.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59961 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbbFHMZU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 08:25:20 -0400
Content-Disposition: inline
In-Reply-To: <CAHp75VeoCQSUCeswTCzUyKbV_e4RTt5t0yjEJLSzAvtX8jFvNw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2015 at 03:21:09PM +0300, Andy Shevchenko wrote:
> On Fri, May 29, 2015 at 10:14 PM, Jim Davis <jim.epost@gmail.com> wrote:
> > Building with the attached random configuration file,
> 
> Hit the very same error against next-20150605.
> 
> The issue with that file we have no compiler optimization enabled. So,
> guys, how you would recommend to fix it?

Stephan, can we get rid of the no optimisation requirement?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
