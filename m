Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4D13F8231;
	Thu, 30 Jul 2026 10:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785406323; cv=none; b=QuO8iDkhbcGUcpGyR4NU+8psQFwxqnmvn71hyilABPnJfU+dEuIsASfH6UsH6D4kZc+UHhVF2/RBpJIhKtV+aSRw69U1bCKjzQwWW5ftJvSJBdjz5cqdtSg1D196GSg0H84DRrYFLIadLuxskJGPb9O5Ul2AoRWX0TrmwWu2WzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785406323; c=relaxed/simple;
	bh=n/EPU/7Rf7w3/KOeEHDFnaFa+3QKJ8ZGzpfG2nxmcz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYmdeGgLdPZKeKBpP0HE5Pv7sFL5KDH6yvw8rFlJpn7xcSBWT7DLuYYdzWwBr455Y39P/DDfETq+PKtimrLFrTiyWGeLlOK81AKf5QlqD/m4f/Scfuoiu+A2cfxcf8gmBWBDdmMGBIkf9uqq+49A5PQPLFORrcWvpH+Lndwqev0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UaIKw47h; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UaIKw47h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9+PbgHxj9mmjJtARI9aO2cSn96w8izQC86mhCuwECGI=; b=UaIKw47h2TM814Kt2b/fYJCwki
	7cz1xMMC9qvL+zVDK7R3Y4QaWUBUrvAdIG4Ttu9kW93n81Mj2F6TjNFxDTrjd0eQJiXEptnTa858w
	jZT00XM60xsRLtRdk8noAgaRADJgjvT1112Ym7auy+aPzqmVAeu7XG/B69By5ZV+uuljge/h8ZSLL
	7HfQkjMUl6agwTjhMA7r+fQOW7kftHA7Vge3pQ4uvxO2UxJKuPsAA6PqlhqaGrg4vrxu3ngOuZnly
	ZnNRiDT7089VsnfwnaWQRTcBe9FJ7czJB9a9eqASXL2ejZGDP9cJP43VKLNsVJ+gKXw1FASrjVTMl
	XSaV7/rQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpNk6-0000000AwiT-0JFd;
	Thu, 30 Jul 2026 10:11:58 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 834D530095A; Thu, 30 Jul 2026 12:11:57 +0200 (CEST)
Date: Thu, 30 Jul 2026 12:11:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 1/4] s390/crypto: Replace cond_resched() with msleep(1)
Message-ID: <20260730101157.GQ49951@noisy.programming.kicks-ass.net>
References: <20260730052907.2607026-1-hca@linux.ibm.com>
 <20260730052907.2607026-2-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730052907.2607026-2-hca@linux.ibm.com>

On Thu, Jul 30, 2026 at 07:29:04AM +0200, Heiko Carstens wrote:
> With [1] cond_resched() is always compiled away and becomes a no-op.
> 
> The comments for all cond_resched() calls in crypto code however indicate
> that the current process should be scheduled away to avoid instant
> re-invocation of a callback. This is not what cond_resched() would do or
> did.
> 
> Instead of just removing the cond_resched() calls, replace them with
> msleep() calls, as suggested by Holger Dengler. This forces the current
> task to be scheduled away (sleeps) like originally intended.
> 
> [1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/crypto/paes_s390.c  | 8 ++++----
>  arch/s390/crypto/phmac_s390.c | 4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
> index 8cfe6166c193..511cb6105436 100644
> --- a/arch/s390/crypto/paes_s390.c
> +++ b/arch/s390/crypto/paes_s390.c
> @@ -555,7 +555,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
>  		 * To avoid immediately re-invocation of this callback,
>  		 * tell the scheduler to voluntarily give up the CPU here.
>  		 */
> -		cond_resched();
> +		msleep(1);
>  		pr_debug("rescheduling request\n");
>  		return -ENOSPC;
>  	} else if (rc) {

I am somewhat conflicted on this. It will add a 'random' delay to this
crypto user (which might be real-time task) that is not related to the
actual event this is waiting for.

That is, it could be that this key expiration thing is sorted way faster
than this one milisecond.

Is there nothing the crypto layer can do that is more clever; like a
condition variable on the key update when -ENOSPC is returned or
something.

This all sounds like a horrible hack one way or the other.
