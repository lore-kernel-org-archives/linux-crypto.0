Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A2E337699;
	Thu, 30 Jul 2026 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785415706; cv=none; b=Rij/3Nky3AsnbuI9k/Vr2lQMyV5GNvYff5DMeeyJxGZ+pxnQz38dkVlzBUSw74sQjqPviWWNHGrc3wErIOdMZSx59EnT+KEOeWguPK1+LvSxY8vryEO3IEhVzAhMOUeVmwqfK/kdqrKwCOiSBv/q+uWGKkCX/9bciDKj7/+phpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785415706; c=relaxed/simple;
	bh=IDRlDHgRpTt5rOzINvl/+IGv9UYBycEo97NkFiSz/HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2cUmJ7iB0p/z1imXMwd50HNSUPHupXPt7WgLf1Wh0gT+7DSV8O78jwXxmFqQziOGI1Mq6Db9HI6Zpi+RFnk0pwa+RmU5/6ez8Im0hgIYTwj9cs5cxXpseIoDfGIyMJMppxpn//xzlH2E2etFLdQIqO3Fxe3ZeEoYHZX7sGZ7qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RH0uuZmw; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RH0uuZmw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HQqsdTWyBXD6D3u3asj+6GxWaH3gpfwwSwQU0H87wms=; b=RH0uuZmwkoir64wc+xU611U1vc
	PXQGV1Ba47vug/2emRMZNqXKNJclAT9NCShYJlXnvQRMG5YM2fflPvy0nVHapNZNw3Ff5fPEBtC9L
	KK6+aqneRud3F/nMuMRkGf5oynMpPs34MT5ma63clhqdAu47mlzDpN9TcGcCUbJk3BFOt4YXnoTAZ
	zl5Q6AJL1wS/V7+dLpDJHvVisKwYy/89gAOrg82ezf9XdpNZfiBxi40i7UopoF6SYuNHYwJVSTQDq
	MchShBRXZHZtC6Og2zkwigxAlvE9hWsi9BGGKjJU/jhWYUPSnscNv6tTgDhGlgJBuncpIEMSQPeIP
	dBruZwng==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpQBQ-0000000EVqe-2SfM;
	Thu, 30 Jul 2026 12:48:20 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6630C300969; Thu, 30 Jul 2026 14:48:19 +0200 (CEST)
Date: Thu, 30 Jul 2026 14:48:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 1/4] s390/crypto: Replace cond_resched() with msleep(1)
Message-ID: <20260730124819.GA776954@noisy.programming.kicks-ass.net>
References: <20260730052907.2607026-1-hca@linux.ibm.com>
 <20260730052907.2607026-2-hca@linux.ibm.com>
 <20260730101157.GQ49951@noisy.programming.kicks-ass.net>
 <39570813-27b0-40f9-89c5-8e2dce05e2f0@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39570813-27b0-40f9-89c5-8e2dce05e2f0@linux.ibm.com>

On Thu, Jul 30, 2026 at 01:34:31PM +0200, Holger Dengler wrote:
> Peter,
> 
> On 7/30/26 12:11, Peter Zijlstra wrote:
> > On Thu, Jul 30, 2026 at 07:29:04AM +0200, Heiko Carstens wrote:
> >> With [1] cond_resched() is always compiled away and becomes a no-op.
> >>
> >> The comments for all cond_resched() calls in crypto code however indicate
> >> that the current process should be scheduled away to avoid instant
> >> re-invocation of a callback. This is not what cond_resched() would do or
> >> did.
> >>
> >> Instead of just removing the cond_resched() calls, replace them with
> >> msleep() calls, as suggested by Holger Dengler. This forces the current
> >> task to be scheduled away (sleeps) like originally intended.
> >>
> >> [1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
> >>
> >> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> >> ---
> >>  arch/s390/crypto/paes_s390.c  | 8 ++++----
> >>  arch/s390/crypto/phmac_s390.c | 4 ++--
> >>  2 files changed, 6 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
> >> index 8cfe6166c193..511cb6105436 100644
> >> --- a/arch/s390/crypto/paes_s390.c
> >> +++ b/arch/s390/crypto/paes_s390.c
> >> @@ -555,7 +555,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
> >>  		 * To avoid immediately re-invocation of this callback,
> >>  		 * tell the scheduler to voluntarily give up the CPU here.
> >>  		 */
> >> -		cond_resched();
> >> +		msleep(1);
> >>  		pr_debug("rescheduling request\n");
> >>  		return -ENOSPC;
> >>  	} else if (rc) {
> > 
> > I am somewhat conflicted on this. It will add a 'random' delay to this
> > crypto user (which might be real-time task) that is not related to the
> > actual event this is waiting for.
> > 
> > That is, it could be that this key expiration thing is sorted way faster
> > than this one milisecond.
> > 
> > Is there nothing the crypto layer can do that is more clever; like a
> > condition variable on the key update when -ENOSPC is returned or
> > something.
> 
> Let me give a bit of background here: The protected key can only get
> invalid, if the linux instance (z/VM or KVM guest) is moved to another
> hypervisor on a different machine (aka life guest relocation). In such a
> case, the crypto accelerator card and the host has to exchange the "real
> key", which is wrapped by the host and handed back to the guest as the
> re-newed protected key. Unfortunately there is no asynchronous trigger
> on completion, you have to re-try (and maybe get another "in progress"
> return).
> 
> And as if that weren't bad enough, if this key exchange between card and
> host is the first one, card and host has to instanciate a secure
> communication channel (including a key exchange for the transport layer).
> 
> I agree, this sounds rally bad for real-time tasks. But we're talking
> about 2nd-level virtualization (with non-real-time hypervisors below)
> and about cases, which can only happen right after a guest relocation to
> another machine. Would the current solution be acceptable under these
> circumstances?

Yes, guest migration is very likely far more disruptive than most
anything else. Perhaps clarify the code comment to include some of this
explanation?
