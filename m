Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBB377101;
	Fri, 13 Sep 2024 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726239448; cv=none; b=MvG5bgzEYBTrcW0ldatUBnPrVvgee+FnokMls44OR+wWlwxX1RYFdlDuvBXcR/wwQM2Gmc0vv5uomZKdxzs0AlortVaaYd56qcW8QIXcXI0TSYCfn/nrQaIx1yP5+DQ6yWWADQe9NtEV4h+qQd9CCDdhH2XNOf4SJI1X7kquKfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726239448; c=relaxed/simple;
	bh=0pQSKjyDUhXIEugFiuzdrF8bAxtZ6BKZdYhNanK6JsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUreZoZItDRQI4dMWAYsJGT3FyKo7Wj7F2a8eyVxQ/+GvtITSi3Wo8ilYfCc62uqdXX7hFjWFsLyRFuXLs44vz/WJRnyaG5UBO+D78rf6IzDdSqFZbpOHcqIyXTWC+ayomEKE2gXllUYBBLRzVie/atnSFBoH4aF4x1txrwIOmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=mldlbSfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mldlbSfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C13C4CEC5;
	Fri, 13 Sep 2024 14:57:27 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mldlbSfB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726239445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DxtSJbsFiH8dQ1jg4k4rteEz9A3w5akpU+RXvsLEdZk=;
	b=mldlbSfBDjDhPptlAaw4VSSPKV54dfCxY8+zMtmXHqLEucpVwgAN3wq8g8e/jMa1VFSNXy
	P8SAItWz2EtDhE3ud+7xM7/2QrKEO6CBmDrr5922m+BWLRGqzBV9+0LscIYQ1SNGe2nqUO
	rG9nq8b3iM+Rhi8ww1EsWxpB+N79W2U=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 809a3f81 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 13 Sep 2024 14:57:24 +0000 (UTC)
Date: Fri, 13 Sep 2024 16:57:22 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/vdso: Wire up getrandom() vdso implementation
Message-ID: <ZuRS0sz_9_mkHsnl@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRD58DrEzzcXKZg@zx2c4.com>
 <20240913141651.30385-A-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913141651.30385-A-hca@linux.ibm.com>

On Fri, Sep 13, 2024 at 04:16:51PM +0200, Heiko Carstens wrote:
> On Fri, Sep 13, 2024 at 03:53:43PM +0200, Jason A. Donenfeld wrote:
> > On Fri, Sep 13, 2024 at 03:05:43PM +0200, Heiko Carstens wrote:
> > > The vdso testcases vdso_test_getrandom and vdso_test_chacha pass.
> > 
> > I'd be curious to see the results of ./vdso_test_getrandom bench-single
> > and such.
> 
> It looks like this with two layers of hypervisors in between, but that
> shouldn't matter too much for this type of workload:
> 
> $ ./vdso_test_getrandom bench-single
>    vdso: 25000000 times in 0.493703559 seconds
>    libc: 25000000 times in 6.371764073 seconds
> syscall: 25000000 times in 6.584025337 seconds

Cool. I'll amend that to the commit message, perhaps, so we have some
historical snapshot of what it does. What cpu generation/model is this?

Jason
