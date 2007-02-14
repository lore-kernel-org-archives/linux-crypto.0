From: Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Wed, 14 Feb 2007 16:21:38 -0600
Message-ID: <20070214222138.GB4884@us.ibm.com>
References: <20070214213200.GA4852@us.ibm.com> <Pine.LNX.4.64.0702141121030.20368@woody.linux-foundation.org> <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <7291.1171482057@redhat.com> <9513.1171490377@redhat.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47340 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532AbXBNWVl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Feb 2007 17:21:41 -0500
Content-Disposition: inline
In-Reply-To: <9513.1171490377@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 14, 2007 at 09:59:37PM +0000, David Howells wrote:
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> 
> > Right now, eCryptfs just delegates its modular exponentiation
> > operations to a userspace daemon. If RSA ever finds its way into the
> > kernel, I might tweak eCryptfs to use that instead for some of the
> > public key operations.
> 
> Am I right in thinking that RSA uses many of the same MPI lib bits
> as DSA?

I would imagine so. Assuming we aren't having to hassle with key
generation (eCryptfs takes care of that in userspace), then RSA is,
more or less, a^b mod c (mpi_mulpowm() and friends).

Mike
