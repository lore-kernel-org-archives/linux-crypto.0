Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3317143144;
	Fri, 13 Sep 2024 13:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726235628; cv=none; b=cJf74ZAXtL4NGiJFpZVw8w3SxAggUNQLfrG1pIyPQW93F4EEHLuA5499OlC7m5gT6+44nioMJVmTguIXrzIdD48DdqoE9lxdFUjNcv4A9EF17HHeNvwOHvSPYZ5MhztWa8ShxWHzxlnvUHvHT2mrO3Qdzemsej/MUcJCiHrVrAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726235628; c=relaxed/simple;
	bh=juI5630aqctV+NqY5uamwwA3WxN+ZI+u/KMYEKTGY2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TzgTKgMrculX8XxOPA9mYtWnsctrFZNPM3jP8ALyR1DUSgdZyP14CLMLqHcfP1FV2Cs3WhY8SVAQj+h8ypGjK4LdK63nuwOmyJaNnYxgxkOHAlpyYRpptx54RTTJI8pIXonOn9hX82pWogvdrUtfrSOl1N8z8HS5AO4P+JvCo6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=a/HBLjJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="a/HBLjJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145F8C4CEC5;
	Fri, 13 Sep 2024 13:53:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="a/HBLjJx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726235625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HCNDLSiKXcPuEEF+DIXaBydnj4KDUjibgOzKdFWgOSg=;
	b=a/HBLjJx6dXjO84R2gV0hbY5LDsulbVOvFUyQT2hPXqpvjSP7cFNEdGHCSzeIVyvnAD4eB
	auNZdbRHipGuiSfbxfsopIi73549XeUZ8RCSRHEILEp164ULbwr2NlN0CJhSNqa1D5Gy7W
	pJmUqpkcmibFXbyNUdBMPUTusXVOKIk=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5e565c20 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 13 Sep 2024 13:53:45 +0000 (UTC)
Date: Fri, 13 Sep 2024 15:53:43 +0200
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
Message-ID: <ZuRD58DrEzzcXKZg@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913130544.2398678-8-hca@linux.ibm.com>

On Fri, Sep 13, 2024 at 03:05:43PM +0200, Heiko Carstens wrote:
> Provide the s390 specific vdso getrandom() architecture backend.
> 
> _vdso_rng_data required data is placed within the _vdso_data vvar page, by
> using a hardcoded offset larger than vdso_data.
> 
> As required the chacha20 implementation does not write to the stack.
> 
> The implementation follows more or less the arm64 implementations and
> makes use of vector instructions. It has a fallback to the getrandom()
> system call for machines where the vector facility is not
> installed.
> The check if the vector facility is installed, as well as an
> optimization for machines with the vector-enhancements facility 2,
> is implemented with alternatives, avoiding runtime checks.
> 
> Note that __kernel_getrandom() is implemented without the vdso user wrapper
> which would setup a stack frame for odd cases (aka very old glibc variants)
> where the caller has not done that. All callers of __kernel_getrandom() are
> required to setup a stack frame, like the C ABI requires it.
> 
> The vdso testcases vdso_test_getrandom and vdso_test_chacha pass.

I'd be curious to see the results of ./vdso_test_getrandom bench-single
and such.

Jason
