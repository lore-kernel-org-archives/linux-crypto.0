Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994464D8BB;
	Fri, 13 Sep 2024 14:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726239472; cv=none; b=lOkZ5OBJexGHIST1MAdYCBRatZlYQg4cscONI8STSuccyAcDL9wmat8Kur1TZ0zxdCJzJUCyLnoY5YealfbmVBU43dQ35rxa6Lv6HAIipdlvZaEoWF3s0emSdMc5DB4WMPgF24+itq0CDLFel4oX8QpAzqMWw5etooTFmu9phVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726239472; c=relaxed/simple;
	bh=s71P89mZ3W54rQGJ2W+BW9+a5VW5k+C+l2iwCeyAKjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMDnJb0UgvGk4YfirjgC/CeCzbXUvK62qQNNNQ6P4XPOnHLIR11sW2Tood4elzDpbNKa51E/yZLd7vwOfgR5cGDughN4M8XB4kn3V2ELso5NbwxErQv1k/ZHisUKRRGz7cSs4uhbblTw/QgALrCVDjvDAmbiAnSmTVs2cf14Dzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=VvfwAPwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VvfwAPwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDD8C4CEC0;
	Fri, 13 Sep 2024 14:57:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VvfwAPwJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726239469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cESnPJPd5KN2wqEJOEZA45EYxyB/wM6lqjeLiC/AT4s=;
	b=VvfwAPwJn4tqAd97Od/1D43eDs6zlr0WjR4vUT4OFc5w3q8cT20r4RaJOM2IHHyLD/yNM1
	DDnHK8O10oSelwqDAkFMj0FkXQCiesoT5o0mKStJ0vLLeximSPQtkeORhqHWIz26TiLNhU
	Tuqdg0uQsSdt8DqPaYmEBa6ITnAXAmo=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 37e3f428 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 13 Sep 2024 14:57:49 +0000 (UTC)
Date: Fri, 13 Sep 2024 16:57:47 +0200
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
Message-ID: <ZuRS6wEa6lKOyuo9@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <ZuRDp4DPOz8BlGAz@zx2c4.com>
 <ZuREmWTzI3Vg7tZE@zx2c4.com>
 <20240913142924.30385-B-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913142924.30385-B-hca@linux.ibm.com>

On Fri, Sep 13, 2024 at 04:29:24PM +0200, Heiko Carstens wrote:
> Hi Jason,
> 
> > > On first glance, this series looks perfect. I can't comment too much on
> > > the s390 parts, but first pass of the crypto/vdso/api parts looks spot
> > > on. Nice going.
> > > 
> > > Were you thinking you'd like me to take these via the random.git tree
> > > for 6.12 next week, or were you thinking of delaying it a release and
> > > taking it into the arch tree for 6.13?
> > 
> > If you did want it to be in 6.12, assuming this series continues to look
> > good, I think we'd still want it to be in -next for at least a week, so
> > maybe that'd take the form of me sending an additional late pull during
> > the merge window for this. Either way, I'll defer to your judgement
> > here, as most of these changes are fiddly s390 things more than anything
> > else.
> 
> This series is intended to go into 6.12. I don't see a reason to delay
> this for a full release cycle. If something breaks we'll fix it, as usual.
> 
> So a late pull request would be perfectly fine. Alternatively we can
> take this via s390 also for a second pull request; whatever you prefer
> and is less work for you.

Okay, great. I'll queue it up then in random.git.

Jason
