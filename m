Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7891DB54A;
	Fri, 13 Sep 2024 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726235566; cv=none; b=e+RI3qIDW1AflNFt0J/0JbKORrjvQidaoNX0HqwUPW//IL9cGAUSvRvTMEjL4NFaHGvj4Y42R641pYlBPLDyYYBmCY3t58y4AMzD7RYxiR9RS0hyEMXlHHNPPLS2PReqkCBbvmLxaV8+4sabr+k8ICfeptUtJY91z2iPiyY+4p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726235566; c=relaxed/simple;
	bh=BoMteBWJY1pw2Z6viKRkR9142nHukMY4QWEuacPJRaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVjEHj5HJygOQ0JIxz7++wsund5nNN8KDyxuUXZUSpbRQqqwoOM7JTv2v2gzlWAmS7cd1H3Jyawhl2Qgb6ewsTvU2I++C/q2ktxlw7sRLLMPHCcN0xBIfMyjTsPpdomHMc68UG6dzUoay/31OjXSr/piFbHkMArWY0SmdusuGXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=hhpeEELy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hhpeEELy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2174C4CEC5;
	Fri, 13 Sep 2024 13:52:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hhpeEELy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726235563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1UfzeKeCJ0IxpFQi1iuP21dghTBpwp6hTLr7aBAFjI4=;
	b=hhpeEELyCgwQ1KuQozkfMDwBybe4OqaLHjmBlyrZXYKOLklLHfBLTwPEE3p3maTyOKSx7Q
	ppCyietmmDIWm+BK4LeOQ6MIlsOBJqm2meb+qbj0lpLKUdJsB9TTnY8rHYrTs82c8xtcCF
	w4cBX5xwoeZYRKl2ILa7Sx8yMWTFvGs=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a32ccf58 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 13 Sep 2024 13:52:42 +0000 (UTC)
Date: Fri, 13 Sep 2024 15:52:39 +0200
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
Message-ID: <ZuRDp4DPOz8BlGAz@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913130544.2398678-1-hca@linux.ibm.com>

Hey Heiko,

On Fri, Sep 13, 2024 at 03:05:36PM +0200, Heiko Carstens wrote:
> Hi Jason,
> 
> quite late but finally the s390 vdso getrandom implementation which applies
> on top of your random git tree.
> 
> As a prerequisite this requires some changes to s390 core code to allow
> alternatives in vdso code. It is fine when all of this gets routed via your
> tree.

On first glance, this series looks perfect. I can't comment too much on
the s390 parts, but first pass of the crypto/vdso/api parts looks spot
on. Nice going.

Were you thinking you'd like me to take these via the random.git tree
for 6.12 next week, or were you thinking of delaying it a release and
taking it into the arch tree for 6.13?

Jason
