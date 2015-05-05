From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] Revert "dm crypt: fix deadlock when async crypto algorithm
 returns -EBUSY"
Date: Tue, 5 May 2015 16:22:57 +0300
Message-ID: <5548C431.9000304@freescale.com>
References: <20150505125040.GB7782@redhat.com>
 <1430831756-13155-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <ben.c@servergy.com>, <dm-devel@redhat.com>,
	<linux-crypto@vger.kernel.org>, <mbroz@redhat.com>,
	<herbert@gondor.apana.org.au>, Rabin Vincent <rabinv@axis.com>
To: Rabin Vincent <rabin.vincent@axis.com>, <snitzer@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:53496
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422884AbbEENXK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2015 09:23:10 -0400
In-Reply-To: <1430831756-13155-1-git-send-email-rabin.vincent@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5/5/2015 4:15 PM, Rabin Vincent wrote:
> This reverts commit 0618764cb25f6fa9fb31152995de42a8a0496475.
> 
> The problem which that commit attempts to fix actually lies in the
> Freescale CAAM crypto driver.
> 
> dm-crypt uses CRYPTO_TFM_REQ_MAY_BACKLOG.  This means the the crypto
> driver should internally backlog requests which arrive when the queue is
> full and process them later.  Until the crypto hw's queue becomes full,
> the driver returns -EINPROGRESS.  When the crypto hw's queue if full,
> the driver returns -EBUSY, and if CRYPTO_TFM_REQ_MAY_BACKLOG is set, is
> expected to backlog the request and process it when the hardware has
> queue space.  At the point when the driver takes the request from the
> backlog and starts processing it, it calls the completion function with
> a status of -EINPROGRESS.  The completion function is called (for a
> second time, in the case of backlogged requests) with a status/err of 0
> when a request is done.
> 
> Crypto drivers for hardware without hardware queueing use the helpers,
> crypto_init_queue(), crypto_enqueue_request(), crypto_dequeue_request()
> and crypto_get_backlog() helpers to implement this behaviour correctly,
> while others implement this behaviour without these helpers (ccp, for
> example).
> 
> dm-crypt (before this patch) uses this API correctly.  It queues up as
> many requests as the hw queues will allow (i.e. as long as it gets back
> -EINPROGRESS from the request function).  Then, when it sees at least
> one backlogged request (gets -EBUSY), it waits till that backlogged
> request is handled (completion gets called with -EINPROGRESS), and then
> continues.  The references to af_alg_wait_for_completion() and
> af_alg_complete() in that commit's commit message are irrelevant because
> those functions only handle one request at a time, unlink dm-crypt.
> 
> The problem is that the Freescale CAAM driver, which that commit
> describes as having being tested with, fails to implement the
> backlogging behaviour correctly.  In cam_jr_enqueue(), if the hardware
> queue is full, it simply returns -EBUSY without backlogging the request.
> What the observed deadlock was is not described in the commit message
> but it is obviously the wait_for_completion() in crypto_convert() where
> dm-crypto would wait for the completion being called with -EINPROGRESS
> in the case of backlogged requests.  This completion will never be
> completed due to the bug in the CAAM driver.
> 
> What that commit does is that it makes dm-crypt wait for every request,
> even when the driver/hardware queues are not full, which means that
> dm-crypt will never see -EBUSY.  This means that that commit will cause
> a performance regression on all crypto drivers which implement the API
> correctly.
> 
> Revert it.  Correct backlog handling should be implemented in the CAAM
> driver instead.
> 
> Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>

Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

I confirm CAAM crypto driver currently lacks backlogging support.

Horia
