From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: crypto: libcrc32c should select crc32c
Date: Sun, 18 Jan 2009 21:45:42 +0100
Message-ID: <20090118204542.GA2978@uranus.ravnborg.org>
References: <alpine.LSU.2.00.0901172346500.14505@fbirervta.pbzchgretzou.qr> <20090118053713.GB23663@gondor.apana.org.au> <alpine.LSU.2.00.0901180910390.14063@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:44259 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZARUn6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Jan 2009 15:43:58 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0901180910390.14063@fbirervta.pbzchgretzou.qr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 18, 2009 at 09:14:16AM +0100, Jan Engelhardt wrote:
> 
> On Sunday 2009-01-18 06:37, Herbert Xu wrote:
> >On Sat, Jan 17, 2009 at 11:48:42PM +0100, Jan Engelhardt wrote:
> >>
> >> Looking at libcrc32c.c shows that it essentially depends on the
> >> crc32c crypto module, which was not packed into my initramfs image
> >> by mkinitrd because.. there is no dependency.
> >
> >Actually the whole point of doing the crc32c/libcrc32c reversal
> >was to allow multiple providers of crc32c.  As it stands we have
> >a generic C version plus an Intel version.
> >
> >So by applying yuor patch we'll go back to always using the C
> >version which is unacceptable.
> >
> >I think a better way of tackling this is to note this information
> >explicitly in the module.  For example, just like module aliases
> >we can add explicit module dependencies.
> 
> Can we?
> 
> I was already thinking about it.. the Solaris kernel has
> its "_depends_on" variable for such things
> 
> 	char _depends_on[] = "crc32c";
> 
> kbuild has something similar in its .mod.c files:
> 
> 	static const char __module_depends[]
> 	__used
> 	__attribute__((section(".modinfo"))) =
> 	"depends=crc32c";
> 
> But in kbuild, this functionality does not seem exported
> to me as a macro (maybe MODULE_DEPENDS?).

kbuild finds out during modpost what modules depends on what other modules
and this is used for the dependencies.
There is no way to control this manually today.

	Sam


