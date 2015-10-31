From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] nx-842: Endian swap ->count before handing over to the
 nx-842 compressor
Date: Sat, 31 Oct 2015 11:39:30 -0700
Message-ID: <20151031183930.GB22547@ram.oc3035372033.ibm.com>
References: <20151030224536.GB22549@ram.oc3035372033.ibm.com>
 <CALZtONDNpw=bpmrykQomZiFZZs+CaGxyPZRL5_aWg=vTSyTrJw@mail.gmail.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:57137 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbbJaSjj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 31 Oct 2015 14:39:39 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <linuxram@us.ibm.com>;
	Sat, 31 Oct 2015 14:39:38 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 81F5A6E803F
	for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2015 14:27:46 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9VIdZCJ64028882
	for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2015 18:39:35 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9VIdY2r024532
	for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2015 14:39:35 -0400
Content-Disposition: inline
In-Reply-To: <CALZtONDNpw=bpmrykQomZiFZZs+CaGxyPZRL5_aWg=vTSyTrJw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 31, 2015 at 08:38:17AM -0400, Dan Streetman wrote:
> On Fri, Oct 30, 2015 at 6:45 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> > The nx-842 compressor overshoots the output buffer corrupting memory. Verified
> > that the following patch fixes the issue on a little-endian system.
> >
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > ---
> >  drivers/crypto/nx/nx-842-powernv.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
> > index 3750e13..3b80ea7 100644
> > --- a/drivers/crypto/nx/nx-842-powernv.c
> > +++ b/drivers/crypto/nx/nx-842-powernv.c
> > @@ -66,7 +66,7 @@ static void setup_indirect_dde(struct data_descriptor_entry *dde,
> >                                unsigned int dde_count, unsigned int byte_count)
> >  {
> >         dde->flags = 0;
> > -       dde->count = dde_count;
> > +       dde->count = cpu_to_be32(dde_count);
> 
> ->count is u8, I don't think this is correct...you could change
> dde_count to a u8, but I'm skeptical that's required at all, are you
> sure this is your problem?  The dde->length should restrict the coproc
> from r/w past the output buffer anyway, even if the ->count is too
> large...

Dan, you are right. The problem does resurface even after the above change.
There is something else going on. Please ignore this patch for now.

I see corruption, when the output buffer is smaller than needed to hold
the compressed data. I expect it to return -ENOSPC, but its not; instead
overshoots and corrupts.

RP
