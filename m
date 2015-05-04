From: Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 3.14 73/92] dm crypt: fix deadlock when async crypto
 algorithm returns -EBUSY
Date: Mon, 4 May 2015 23:32:54 +0200
Message-ID: <20150504213254.GA27445@debian>
References: <20150502190109.683061482@linuxfoundation.org>
 <20150502190117.069180534@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ben Collins <ben.c@servergy.com>,
	Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33130 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbbEDVdC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 17:33:02 -0400
Content-Disposition: inline
In-Reply-To: <20150502190117.069180534@linuxfoundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, May 02, 2015 at 09:03:28PM +0200, Greg Kroah-Hartman wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ben Collins <ben.c@servergy.com>
> 
> commit 0618764cb25f6fa9fb31152995de42a8a0496475 upstream.

The commit in question was recently merged to mainline and is now being
sent to various stable kernels.  But I think the patch is wrong and the
real problem lies in the Freescale CAAM driver which is described as
having being tested with.

 commit 0618764cb25f6fa9fb31152995de42a8a0496475
 Author: Ben Collins <ben.c@servergy.com>
 Date:   Fri Apr 3 16:09:46 2015 +0000
 
     dm crypt: fix deadlock when async crypto algorithm returns -EBUSY
     
     I suspect this doesn't show up for most anyone because software
     algorithms typically don't have a sense of being too busy.  However,
     when working with the Freescale CAAM driver it will return -EBUSY on
     occasion under heavy -- which resulted in dm-crypt deadlock.
     
     After checking the logic in some other drivers, the scheme for
     crypt_convert() and it's callback, kcryptd_async_done(), were not
     correctly laid out to properly handle -EBUSY or -EINPROGRESS.
     
     Fix this by using the completion for both -EBUSY and -EINPROGRESS.  Now
     crypt_convert()'s use of completion is comparable to
     af_alg_wait_for_completion().  Similarly, kcryptd_async_done() follows
     the pattern used in af_alg_complete().
     
     Before this fix dm-crypt would lockup within 1-2 minutes running with
     the CAAM driver.  Fix was regression tested against software algorithms
     on PPC32 and x86_64, and things seem perfectly happy there as well.
     
     Signed-off-by: Ben Collins <ben.c@servergy.com>
     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
     Cc: stable@vger.kernel.org

dm-crypt uses CRYPTO_TFM_REQ_MAY_BACKLOG.  This means the the crypto
driver should internally backlog requests which arrive when the queue is
full and process them later.  Until the crypto hw's queue becomes full,
the driver returns -EINPROGRESS.  When the crypto hw's queue if full,
the driver returns -EBUSY, and if CRYPTO_TFM_REQ_MAY_BACKLOG is set, is
expected to backlog the request and process it when the hardware has
queue space.  At the point when the driver takes the request from the
backlog and starts processing it, it calls the completion function with
a status of -EINPROGRESS.  The completion function is called (for a
second time, in the case of backlogged requests) with a status/err of 0
when a request is done.

Crypto drivers for hardware without hardware queueing use the helpers,
crypto_init_queue(), crypto_enqueue_request(), crypto_dequeue_request()
and crypto_get_backlog() helpers to implement this behaviour correctly,
while others implement this behaviour without these helpers (ccp, for
example).

dm-crypt (before this patch) uses this API correctly.  It queues up as
many requests as the hw queues will allow (i.e. as long as it gets back
-EINPROGRESS from the request function).  Then, when it sees at least
one backlogged request (gets -EBUSY), it waits till that backlogged
request is handled (completion gets called with -EINPROGRESS), and then
continues.  The references to af_alg_wait_for_completion() and
af_alg_complete() in the commit message are irrelevant because those
functions only handle one request at a time, unlink dm-crypt.

The problem is that the Freescale CAAM driver, which this problem is
described as being seen on, fails to implement the backlogging behaviour
correctly.  In cam_jr_enqueue(), if the hardware queue is full, it
simply returns -EBUSY without backlogging the request.  What the
observed deadlock was is not described in the commit message but it is
obviously the wait_for_completion() in crypto_convert() where dm-crypto
would wait for the completion being called with -EINPROGRESS in the case
of backlogged requests.  This completion will never be completed due to
the bug in the CAAM driver.

What this patch does is that it makes dm-crypt wait for every request,
even when the driver/hardware queues are not full, which means that
dm-crypt will never see -EBUSY.  This means that this patch will cause a
performance regression on all crypto drivers which implement the API
correctly.

So, I think this patch should be reverted in mainline and the stable
kernels where it has been merged, and correct backlog handling should be
implemented in the CAAM driver instead.
