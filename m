From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3.14 73/92] dm crypt: fix deadlock when async crypto
 algorithm returns -EBUSY
Date: Tue, 5 May 2015 08:50:40 -0400
Message-ID: <20150505125040.GB7782@redhat.com>
References: <20150502190109.683061482@linuxfoundation.org>
 <20150502190117.069180534@linuxfoundation.org>
 <20150504213254.GA27445@debian>
 <20150505032213.GB4954@redhat.com>
 <55486664.4000607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rabin Vincent <rabin@rab.in>, herbert@gondor.apana.org.au,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	Ben Collins <ben.c@servergy.com>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbbEEMum (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2015 08:50:42 -0400
Content-Disposition: inline
In-Reply-To: <55486664.4000607@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 05 2015 at  2:42am -0400,
Milan Broz <mbroz@redhat.com> wrote:

> On 05/05/2015 05:22 AM, Mike Snitzer wrote:
> > On Mon, May 04 2015 at  5:32pm -0400,
> > Rabin Vincent <rabin@rab.in> wrote:
> > 
> >> On Sat, May 02, 2015 at 09:03:28PM +0200, Greg Kroah-Hartman wrote:
> >>> 3.14-stable review patch.  If anyone has any objections, please let me know.
> >>>
> >>> ------------------
> >>>
> >>> From: Ben Collins <ben.c@servergy.com>
> >>>
> >>> commit 0618764cb25f6fa9fb31152995de42a8a0496475 upstream.
> >>
> >> The commit in question was recently merged to mainline and is now being
> >> sent to various stable kernels.  But I think the patch is wrong and the
> >> real problem lies in the Freescale CAAM driver which is described as
> >> having being tested with.
> ...
> 
> >> dm-crypt uses CRYPTO_TFM_REQ_MAY_BACKLOG.  This means the the crypto
> >> driver should internally backlog requests which arrive when the queue is
> >> full and process them later.  Until the crypto hw's queue becomes full,
> >> the driver returns -EINPROGRESS.  When the crypto hw's queue if full,
> >> the driver returns -EBUSY, and if CRYPTO_TFM_REQ_MAY_BACKLOG is set, is
> >> expected to backlog the request and process it when the hardware has
> >> queue space.  At the point when the driver takes the request from the
> >> backlog and starts processing it, it calls the completion function with
> >> a status of -EINPROGRESS.  The completion function is called (for a
> >> second time, in the case of backlogged requests) with a status/err of 0
> >> when a request is done.
> 
> 
> Mike, I thought there was a discussion with crypto API maintainer before
> merging this patch, I think there were some comments that the patch seems
> to be not correct...

I unfortunately didn't cc Herbert on the original v2 patch (but I did
later bounce the mail to him IIRC).  Regardless, no I didn't see any
feedback and I really should've been more active in engaging him.

> This API (EBUSY/EINPROGESS codes) use was there since dmcrypt switched
> to async crypto API.
> 
> There should tests for it (some years ago we tested the async path by forcing
> to use cryptd, this was able to clearly simulate the BUSY path as well),
> but not sure if it is still possible so easily.
> 
> > Any chance you'd be willing to provide in-code comments in the
> > appropriate places in dm-crypt.c (after having reverted this patch in
> > question)?
> > 
> > I'd be happy to take the combination of the revert and documentation in
> > a single patch and get it to Linus for 4.0-rc3.
> 
> Please, do not mix revert patches with additions (even if it is just comment),
> someone could be even more confused what's going on here.

I was only saying to mix comments and revert if the patch in question
didn't get into stable@ at all.

But safer to just do a pure revert.  I get it queued up to send to Linus.

> If nobody volunteers, I'll try to add some comments later to dmcrypt code,
> but that is definitely not for stable.

Yeap, thanks.
