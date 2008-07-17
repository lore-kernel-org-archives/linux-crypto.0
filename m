From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 4/6] crypto: talitos - fix GFP flag usage
Date: Thu, 17 Jul 2008 11:22:06 -0500
Message-ID: <20080717112206.ec05b503.kim.phillips@freescale.com>
References: <20080716182215.36c1bd11.kim.phillips@freescale.com>
	<BDCB5191-EEDE-4046-A741-80E6EF1333CF@kernel.crashing.org>
	<20080717121758.GA25267@gondor.apana.org.au>
	<D59ED865-85CF-4C1E-9D79-D9DD0DE49505@kernel.crashing.org>
	<20080717102746.33381e30.kim.phillips@freescale.com>
	<8819CEAD-C9D4-4645-A272-026AE2B39D7B@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	linuxppc-dev <linuxppc-dev@ozlabs.org>
To: Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:46298 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYGQQYo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2008 12:24:44 -0400
In-Reply-To: <8819CEAD-C9D4-4645-A272-026AE2B39D7B@kernel.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 17 Jul 2008 10:51:43 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> 
> On Jul 17, 2008, at 10:27 AM, Kim Phillips wrote:
> 
> > On Thu, 17 Jul 2008 07:26:14 -0500
> > Kumar Gala <galak@kernel.crashing.org> wrote:
> >
> >>
> >> On Jul 17, 2008, at 7:17 AM, Herbert Xu wrote:
> >>
> >>> On Wed, Jul 16, 2008 at 06:33:45PM -0500, Kumar Gala wrote:
> >>>>
> >>>> On Jul 16, 2008, at 6:22 PM, Kim Phillips wrote:
> >>>>
> >>>>> use GFP_ATOMIC when necessary; use atomic_t when allocating
> >>>>> submit_count.
> >>>>
> >>>> why?
> >>>
> >>> You mean why are atomics required? Yes that is a good question.
> >>
> >> Yep. the commit message isn't explaining why, just what :)
> >
> > In honouring requests that don't have the CRYPTO_TFM_REQ_MAY_SLEEP  
> > set,
> > afaict, it's the standard non-wait variant GFP that drivers use (see
> > the ixp4xx driver for e.g.).
> 
> so GFP_ATOMIC and atomic_t aren't related.  I can understand the need  
> for GFP_ATOMIC, but I don't get why something needs to be declared  
> atomic_t.

I see what the source of confusion is now; it appears I missed this
atomic_t clean-up when making the patchseries; the atomic_t fix belongs
in the previous "preempt overflow interrupts" patch (3/6).

atomic_t is needed for atomic operations which protect resource
contention on submit_count, which subsequently represents submission
slot availability on a particular SEC channel for multiple, potentially
simultaneous, users.

Kim
