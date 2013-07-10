From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: unable to finish booting when "crypto: crct10dif - Wrap
 crc_t10dif function all to use crypto transform framework" applied
Date: Wed, 10 Jul 2013 16:16:22 +1000
Message-ID: <20130710061621.GA20488@gondor.apana.org.au>
References: <51D8420C.7010602@internode.on.net>
 <1373385611.22432.230.camel@schen9-DESK>
 <51DC52C7.3010101@internode.on.net>
 <1373405654.22432.258.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:60918 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750710Ab3GJGQ1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jul 2013 02:16:27 -0400
Content-Disposition: inline
In-Reply-To: <1373405654.22432.258.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 09, 2013 at 02:34:14PM -0700, Tim Chen wrote:
>
> > I'm not sure what the root disk is doing, just using Debian's mk-kpkg 
> > kernel_package to build a kernel with an initial ramdisk.
> > 
> > On one of the failed boot-up attempts I saw an error like:
> > 
> > sd_mod - unknown symbol crc*
> 
> If you have any detailed dumps on the messages from sd_mod that will 
> be helpful.

I think that's the key.  Whatever is creating the initrd of that
distro isn't including the new crct10dif module.  I can't believe
they still haven't fixed the initrd tools to do dependency checking.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
