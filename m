From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from kernel.h instead
Date: Thu, 29 Nov 2007 22:13:24 +1100
Message-ID: <20071129111324.GH22537@gondor.apana.org.au>
References: <20071126143939.GB28022@gondor.apana.org.au> <1196098095-8995-1-git-send-email-crquan@gmail.com> <1196100104.31590.11.camel@localhost> <20071127013540.GA793@gondor.apana.org.au> <1196131632-7285-1-git-send-email-crquan@gmail.com> <474B87F1.2060109@student.ltu.se> <91b13c310711262103w781b3047k6338acda56837c0@mail.gmail.com> <20071127012622.3e3a6bd1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: rae l <crquan@gmail.com>,
	Richard Knutsson <ricknu-0@student.ltu.se>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dengxw@163.com, Randy Dunlap <randy.dunlap@oracle.com>,
	Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2354 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752171AbXK2LNh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Nov 2007 06:13:37 -0500
Content-Disposition: inline
In-Reply-To: <20071127012622.3e3a6bd1.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 27, 2007 at 01:26:22AM -0800, Andrew Morton wrote:
> On Tue, 27 Nov 2007 13:03:29 +0800 "rae l" <crquan@gmail.com> wrote:
> 
> > -static void hexdump(unsigned char *buf, unsigned int len)
> > +static inline void hexdump(unsigned char *buf, unsigned int len)
> >  {
> > -	while (len--)
> > -		printk("%02x", *buf++);
> > -
> > -	printk("\n");
> > +	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
> > +			16, 1,
> > +			buf, len, false);
> >  }
> 
> uninlining this function shrinks crypto/tcrypt.o's .text from 20,009 bytes
> down to 19,701.
> 
> inlining is almost always wrong.

I agree.  Please do as Andrew suggests and resubmit.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
