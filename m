Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ED9146589;
	Mon, 16 Sep 2024 09:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726477736; cv=none; b=JmNxG90gDBb49iIGpHEYnow+lNSS5x8PvGqZVl5Plio2J7NnRQF9UPAPmTy23cerkaoSkm2I3RXjOeKaQmb5fOIGTcbrQ9guOZiu+UHCu+Q+iIGjdFy/0gc6NxRZ6bdNTwF5KfWfRwIYLotFWkSZYEA8nR4b94naz5gTYpIhntA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726477736; c=relaxed/simple;
	bh=SS2UTjyJdke6ooDSmfvCarEKipraJ3+u/4qYonYH5dA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXpJSjUe16mDOCD6HGICQtO6V3SAidRquhUoKSut7smYm8Mnxyun8ZzmWoIe4DXZ7N8QbtyksbQy4IUfobaA83pdvaqaHPEy+onpaQDzKFZPWp4a5ljYe65EBl4brQkcX+pjjOJEVx7O5+vN1OFq93FzjAj9ZOBEglc8r5uegnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=farORbg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="farORbg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B2DC4CEC4;
	Mon, 16 Sep 2024 09:08:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="farORbg5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726477732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SS2UTjyJdke6ooDSmfvCarEKipraJ3+u/4qYonYH5dA=;
	b=farORbg5vciCFv1ykjbviQvYU1myLSJ/FW/oRd3/20NYz2gx4FFqaYeXQMlz6d8FRXMTfq
	pENtLvIfTy84kqnOczIRNYvi3eRfGdufWiez4MzkjxYMGLjhC3envyQPlbRTTE8brM3SFw
	b7+jTN2I8jfS3515wBmetsg9esQgCf4=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 00ff19f8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 16 Sep 2024 09:08:51 +0000 (UTC)
Date: Mon, 16 Sep 2024 11:08:49 +0200
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
Message-ID: <Zuf1oYveC0rryg_6@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRWmJTWqmD92D8d@zx2c4.com>
 <ZuRYoVIrg28kBKqb@zx2c4.com>
 <20240913173206.30385-C-hca@linux.ibm.com>
 <ZuSRKLFdYI1gCHh9@zx2c4.com>
 <20240914174246.8394-A-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240914174246.8394-A-hca@linux.ibm.com>

Hi Heiko,

On Sat, Sep 14, 2024 at 07:42:46PM +0200, Heiko Carstens wrote:
> Please feel free to change the code in whatever way you like.
> If you prefer separate patches, I will provide them.

Just wanted to make sure you saw https://lore.kernel.org/all/20240914231241.3647749-1-Jason@zx2c4.com/

Jason
