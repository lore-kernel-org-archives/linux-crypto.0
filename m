Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B6226A097
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 08:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747643341; cv=none; b=beft4VRAtsrmF1FPCB5OGv+IhZavZn+54mM+Zh3MvbIBNMMjkI+OB7b1adWmGH5Y26ob0RMSsEuBbmCrjEfglzrWa/Yvftv7wDXup73MLX1DZQ+KC7WWx+016TVWqyQFD28Dy30ENJYqUf8vAcl4kUlGV75FuDMcBbUP//zEvd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747643341; c=relaxed/simple;
	bh=nhc5OGZZ9ffWF6e7ILOZfg5xN+kJLKYtLWOYqp1HR2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YKZPwxSibKmV75BffgJP7dMEh/vguwu1q5RE6rUDXZjAkn+s+ONVXJVZ+ku4G1WuPPFvH+OotGggARzTqf45kchDU5ipWJbV5BvjRq0aQRffrxCHdJ/fUTKVGdmAnbo/dmphxClIoRoaprz86rGGAIJDOS65qQ4xJ9GbQ9z+wLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HMsc+cMT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HMsc+cMT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+FBrK03aDmRFHwNuD09otfcvtROIBfR9kD+dJyzwBuc=; b=HMsc+cMT9qvtIwRCz4xyn3lkfo
	VwcAouXJFUiITDIdh315SgbU6BKO9WucZWCmNJTDgy0ehiVOPcGgDoSsAzS6/+KnJbTG/JY8fw24V
	5i7dk5zi7tdT2GH9Cwg8nBZLQ+98q4Z8UOK6Ns2Kd9+kxnkWnFKuMC8xyCcWEEqwKjHPcadLQp+Tx
	zzkeSivibs3y6RPSuS1+lD2MOapCCuBH1DZGK/A4DKG1jzlR9imovQdzbJfoAeCzBllGk2b6R6dhP
	OEDMxaol9lkjLFlkU6yCIkRWyrlcGOEpgexmfJ7HIrqxOJZLgfr79l5f/hwV7G28zvYUlLriDYNXS
	eL51PT/A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGvrZ-007AJO-2P;
	Mon, 19 May 2025 16:28:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 16:28:45 +0800
Date: Mon, 19 May 2025 16:28:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org
Subject: Re: Sporadic errors with alg selftest on next kernel.
Message-ID: <aCrrveKBY9ZsV62M@gondor.apana.org.au>
References: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>

On Mon, May 19, 2025 at 10:09:10AM +0200, Ingo Franzki wrote:
> Hi Herbert,
> 
> besides the regression found in paes-crt on s390x (reported and analyzed by Harald already), we sporadically encounter additional strange failures in our CI on the next kernel:
> 
> During this weekend's CI run, we got the following:
> 
>     alg: aead: error allocating gcm_base(ctr(aes-generic),ghash-generic) (generic impl of gcm(aes)): -17
>     alg: self-tests for gcm(aes) using gcm-aes-s390 failed (rc=-17)
> 
> Last week, we had a similar failure:
> 
>     aes_s390: Allocating AES fallback algorithm ctr(aes) failed
>     alg: skcipher: failed to allocate transform for ctr-aes-s390: -17
>     alg: self-tests for ctr(aes) using ctr-aes-s390 failed (rc=-17)
> 
> Those are only single failures, not reproducible, happen only of one system, although the same code is run on multiple systems.
> So it must be some kind a race condition...
> 
> -17 is EEXIST, and from a quick look into the code this might be coming from registering an alg (e.g. __crypto_register_alg(), crypto_register_template(), af_alg_register_type(), crypto_add_alg()) when the alg is already there....
> So looks like one wants to register the same alg although it was already registered concurrently? 

Yes it looks like a race condition.  It's normal for multiple
entities to try to construct the same algorithm at the same time.
The larvals/test larvals are meant to take care of that problem
But from time to time there are bugs (e.g., commit 7505436e2925)
that cause errors like this.
 
> Its hard to debug, since it only happens sporadically and can't be reproduced easily.
> 
> Any idea where this might come from? 
> We did not see these kind of errors since long time, and still don't see them on kernels other than next. 

Well the immediate reason is the extra tests are now enabled by
default.  So your CI likely weren't executing these extra tests,
and now they are.  One thing that the extra tests do is allocating
a generic fallback to compare the test results against, that's
what was happening in the first error you saw above.

The next proximate cause is parallel testing but this has been
around for a few months already.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
