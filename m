From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam: fix error reporting
Date: Tue, 4 Nov 2014 10:57:31 -0600
Message-ID: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
	<20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
	<5457486C.3030205@freescale.com>
	<20141103134716.775acd39d6334c6f8aeca151@freescale.com>
	<54589515.2010903@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<horia.geanta@freescale.com>, <marex@denx.de>
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bn0102.outbound.protection.outlook.com ([157.56.110.102]:6624
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751292AbaKDRDI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Nov 2014 12:03:08 -0500
In-Reply-To: <54589515.2010903@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 4 Nov 2014 10:57:57 +0200
Cristian Stoica <cristian.stoica@freescale.com> wrote:

> Hi Kim,
> 
> >> Actually, our static code analyzer did not see this one.
> > 
> > ok, so the patch technically isn't fixing anything broken, then.
> 
> Are you saying the code isn't broken _because_ a static tool analyser
> did not see anything wrong here?

no: I'm saying there was no symptom - something I'd expect to gather
from the original commit message.

> > the new code just added a new condition, which doesn't invalidate
> > the comment.  And simply removing the comment as opposed to amending
> > it is a bit overkill.
> 
> You are partially right, but will the staggering lack of comments in the
> caam driver be fixed by duplicating a cascade of three ifs into english?

well, given that preamble, it would be better than removing the
existing two :), but the simpler version makes it a moot point.

> >> It is indeed simpler but does it consider also the missing error codes
> >> at index 1 and 5? Just checking for an upper bound is not enough.
> >
> > no, the existing code already handles that.  Note that newer
> > documentation fills the 1 and 5 slots, too.
> 
> If you have the new error codes please send them to me for an update.

surely you have access to the documentation, if not, let me know.

> >> On the other hand, if the error field is only three bits wide instead of
> >> four as stated by the documentation, a better fix means using a three
> >> bit mask instead of reporting an invalid error code.
> > 
> > true, but then we'd introduce a direct discrepancy with the
> > documentation, and thus h/w.
> 
> You basically ask me to agree that if there are no _documented_ error
> codes between 0x8 and 0xf then I should trust that they will never come
> up on a 4 bit field.

they may, depending on future revs of the h/w, but that's not what
this patch is about.

> Do you want me to drop the patch and pretend there is nothing to see?

no, fixing potential bugs preemptively is fine; I'd just like to
know that's the case: it wasn't clear from the original commit
message whether the problem occurred on a new h/w revision, in which
case I'd have like to have seen the driver updated with support for
the new error codes.

Kim
