From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC PATCH] crypto: add buffer overflow checks to testmgr
Date: Thu, 4 Jun 2009 17:59:36 -0400
Message-ID: <200906041759.37762.jarod@redhat.com>
References: <200905291132.55848.jarod@redhat.com> <20090529221055.GA17957@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50745 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbZFDWAg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2009 18:00:36 -0400
In-Reply-To: <20090529221055.GA17957@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday 29 May 2009 18:10:55 Herbert Xu wrote:
> On Fri, May 29, 2009 at 11:32:54AM -0400, Jarod Wilson wrote:
> > At present, its entirely possible to add a test vector to testmgr with
> > an input longer than a page in length w/o specifying a .np option, and
> > overflow the page of memory allocated to {a,}xbuf[0], silently
> > corrupting memory. I know, because I've accidentally done it. :)
> > 
> > While this doesn't currently happen in practice w/the existing code,
> > due to all !np vectors being less than a 4k page in length (and the
> > page allocation loop often returns contiguous pages anyway), explicit
> > checks or a way to remove the 4k limit would be a good idea.
> > 
> > A few ways to fix and/or work around this:
> > 
> > 1) allocate some larger guaranteed contiguous buffers using
> > __get_free_pages() or kmalloc and use them in the !np case
> > 
> > 2) catch the > PAGE_SIZE && !np case and then do things similar to how
> > they are done in the np case
> > 
> > 3) catch the > PAGE_SIZE && !np case and simply exit with an error
> > 
> > Since there currently aren't any test vectors that are actually larger
> > than a page and not tagged np, option 1 seems like a waste of memory
> > and option 2 sounds like unnecessary complexity, so I'd offer up
> > option 3 as the most viable alternative right now.
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> I just posted exactly the same thing yesterday :)

One note... This is actually causing some new compile warnings to be
spit out, varies from arch to arch, dependent on page size... ppc64
with 64k pages is the worst offender:

crypto/testmgr.c: In function 'test_nhash':
crypto/testmgr.c:194: warning: comparison is always false due to limited range of data type
crypto/testmgr.c: In function 'test_aead':
crypto/testmgr.c:374: warning: comparison is always false due to limited range of data type
crypto/testmgr.c:375: warning: comparison is always false due to limited range of data type
crypto/testmgr.c: In function 'test_cipher':
crypto/testmgr.c:676: warning: comparison is always false due to limited range of data type
crypto/testmgr.c: In function 'test_skcipher':
crypto/testmgr.c:771: warning: comparison is always false due to limited range of data type



-- 
Jarod Wilson
jarod@redhat.com
