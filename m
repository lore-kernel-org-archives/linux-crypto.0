From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: sha1_mb broken
Date: Tue, 04 Oct 2016 09:08:42 -0700
Message-ID: <1475597322.3916.283.camel@linux.intel.com>
References: <1939675.7gNnqUbNs6@positron.chronox.de>
         <9643256.KgnRM79R5B@positron.chronox.de>
         <C440BA31B54DCD4AAC682D2365C8FEE703CEF891@ORSMSX111.amr.corp.intel.com>
         <2176107.gSz0A05ekE@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>,
        "Dey, Megha" <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18329 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752289AbcJDQIq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2016 12:08:46 -0400
In-Reply-To: <2176107.gSz0A05ekE@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2016-10-04 at 16:10 +0200, Stephan Mueller wrote:
> Am Dienstag, 4. Oktober 2016, 00:25:07 CEST schrieb Dey, Megha:
> 
> Hi Megha,
> 
> > 
> > 
> > > 
> > > Hi Stephan,
> > > 
> > > Your test code initialized the completion structure incorrectly, that led
> > > to the missing completion from being received. The init_completion call
> > > should be made before the crypto_ahash_digest call. The following change
> Thanks a lot for pointing that one out. Can you help me understand why your 
> code trips over that issue whereas other ahash implementations do not (all 
> other SHA-1 or SHA-2 implementations work perfectly fine with that code)?
> 

There is a spin lock protecting the completion's wait_queue on the processes waiting for
the completion of the job, and the queue head.  My suspicion is if these
structures are not initialized properly, we fail to look up the waiting process in the queue
properly to call it.  For the other tested cases, they may not be a true ahash operation
in the sense of passing request through the crypto daemon, and have to context switch
to let crypto daemon complete the job.  The computation proceeds
and returns in the same call chain.

Thanks.

Tim
