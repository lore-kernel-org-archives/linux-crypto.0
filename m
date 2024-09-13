Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD981DB54F;
	Fri, 13 Sep 2024 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726235807; cv=none; b=g75Yieerloj+zx2JrJBO5mMyU8r4v7vbBkdqZOSj9Zw8F2t7mLWBP4OTMN6QpxMzQJlObsrb5oyliHUgSInmLRMy2LXRNeLz6xwdgfsgkuckoSrN8QctA8HyRIJBppIpYsy0LBbHdPM3uozNCswo15hEYU3R8X/S18JQFmEdPkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726235807; c=relaxed/simple;
	bh=Z+JGJC4cGVy8Es4BV7Gea7Hxxm66ryAaCGe4Wx2jH70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mfz3WMIatT9ZmwrNN1B7kIRriJNHEOyqv55RXpnnoZoB0Ni3/3DA9xn+VsS3Ny9+n+5IfY6IWZl2TctMmt8r8sTxQYtUflOghM8tuNm0uU3H9Fqctri/B0ZcxOaBKagoZmjhHXyq+4Z8GfRHOTHg8C+At/2IJL5a6DkzXBW+aJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=I9nLfr1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="I9nLfr1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DED5C4CEC0;
	Fri, 13 Sep 2024 13:56:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="I9nLfr1v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726235803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sT7Jk5lsyiM42TzxIImcQ2IqsDCQPtqaIpgfI0clKJc=;
	b=I9nLfr1vmnutnLjQhhSx43pZVxtwinw/inCJLCNAUL/k2rYcvg0efI4wkSUTme9JgV+TEr
	bD7x34B2fDbK1yZ+Zlhiy91NcAcbQBHMWbHRwXtqfChc+pXjBFgbZBX1qJK5H2UiujPcSf
	RNx5mfh9ozmvtI/SFeJavievQHEsIa0=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ab438405 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 13 Sep 2024 13:56:43 +0000 (UTC)
Date: Fri, 13 Sep 2024 15:56:41 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/7] s390/vdso: getrandom() vdso implementation
Message-ID: <ZuREmWTzI3Vg7tZE@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <ZuRDp4DPOz8BlGAz@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZuRDp4DPOz8BlGAz@zx2c4.com>

On Fri, Sep 13, 2024 at 03:52:39PM +0200, Jason A. Donenfeld wrote:
> Hey Heiko,
> 
> On Fri, Sep 13, 2024 at 03:05:36PM +0200, Heiko Carstens wrote:
> > Hi Jason,
> > 
> > quite late but finally the s390 vdso getrandom implementation which applies
> > on top of your random git tree.
> > 
> > As a prerequisite this requires some changes to s390 core code to allow
> > alternatives in vdso code. It is fine when all of this gets routed via your
> > tree.
> 
> On first glance, this series looks perfect. I can't comment too much on
> the s390 parts, but first pass of the crypto/vdso/api parts looks spot
> on. Nice going.
> 
> Were you thinking you'd like me to take these via the random.git tree
> for 6.12 next week, or were you thinking of delaying it a release and
> taking it into the arch tree for 6.13?

If you did want it to be in 6.12, assuming this series continues to look
good, I think we'd still want it to be in -next for at least a week, so
maybe that'd take the form of me sending an additional late pull during
the merge window for this. Either way, I'll defer to your judgement
here, as most of these changes are fiddly s390 things more than anything
else.

Jason
