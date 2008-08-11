From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Date: Mon, 11 Aug 2008 18:10:15 +0200
Message-ID: <20080811161015.GA5240@ucw.cz>
References: <a36005b50808072038w3e88658p6769e1e3779b6cab@mail.gmail.com> <E1KRS7u-0005EP-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ulrich Drepper <drepper@gmail.com>, austin_zhang@linux.intel.com,
	bunk@kernel.org, dwmw2@infradead.org, davem@davemloft.net,
	randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3543 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752898AbYHLO7c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Aug 2008 10:59:32 -0400
Content-Disposition: inline
In-Reply-To: <E1KRS7u-0005EP-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri 2008-08-08 21:35:30, Herbert Xu wrote:
> Ulrich Drepper <drepper@gmail.com> wrote:
> >
> > I think you want to use
> > 
> >  #define SCALE_F sizeof(unsigned long)
> 
> Yeah in general that's what we should do.  However, this driver
> is specific to Intel x86 CPUs.

I thought we support intel x86 cpus in both 32 and 64bit modes...?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
