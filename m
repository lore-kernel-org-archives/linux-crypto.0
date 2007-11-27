From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from <linux/kernel.h> instead
Date: Tue, 27 Nov 2007 09:35:40 +0800
Message-ID: <20071127013540.GA793@gondor.apana.org.au>
References: <20071126143939.GB28022@gondor.apana.org.au> <1196098095-8995-1-git-send-email-crquan@gmail.com> <1196100104.31590.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Denis Cheng <crquan@gmail.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, dengxw@163.com,
	Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4360 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753250AbXK0Bfr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 20:35:47 -0500
Content-Disposition: inline
In-Reply-To: <1196100104.31590.11.camel@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 26, 2007 at 10:01:44AM -0800, Joe Perches wrote:
> On Tue, 2007-11-27 at 01:28 +0800, Denis Cheng wrote:
> > -static void hexdump(unsigned char *buf, unsigned int len)
> > -{
> > -	while (len--)
> > -		printk("%02x", *buf++);
> > -
> > -	printk("\n");
> > -}
> 
> #define hexdump(buf, len) \
> 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, \
> 	               (buf), (len), false)
> 
> requires no other changes.

Yes that's a good idea.  Denis could you do another patch with
this, preferably as a static inline function? That way you don't
even need to worry about test_aead.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
