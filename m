Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6468F200110;
	Thu,  5 Mar 2026 19:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772739357; cv=none; b=B0IOh4ujhpJmw+YRDc5AgnSZ30ATVU9ig8qckcVTvrADYfqCWIiM5mBmn9GRuyG3zHOff0H33qYSsxQ3Ma3xvrIgnGSm1P0SgRSS1Hj3WJk/I8xmNIovBqSViDffdQyDGOmowCwLi1YV0UWYD4gspd/9kIkWFI/4zxxDIJnwW8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772739357; c=relaxed/simple;
	bh=qR9Ij/FY34eHSXXTcCk/GeK8X2a0zFTqLCAWPVyb0rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ym8i1S9e3jL3vRqTe2DLe7ZhYI+/QMGp43JtvYAR8AoCt91NifLVng2J1GYiFKNwQF091w42X8NzNSaRgdSexnoDvjifGTU6gShh0V44BS4syb1x1KBRu0xDe6+rv/cOpor5WXIsTEgSYM6/oZO04DlY77138MacaMe2k2kFvno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BP4RLTuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BP4RLTuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEECDC116C6;
	Thu,  5 Mar 2026 19:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772739357;
	bh=qR9Ij/FY34eHSXXTcCk/GeK8X2a0zFTqLCAWPVyb0rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BP4RLTuBIUFpwwk876uF1ZcO3ahkW65xMWEDbV3v3kYQO5zXp8HTk0v2nGmoqTicm
	 UaDvPi70FuMpEvVWBmptSJjlOfx6ROOOp6ANdDvWjMYVqDG+rOMZchZoDOaq1w6jOd
	 9ie3CtqaZZnhsJenyEiZ6PLlge2AbhMOT2mTjJJgywo3A+Wag4ZLKiHGRbUIIPQX4u
	 fQT95spfZABECyxBRgCusBohyq3EhkQmoqI/p8J61uRk1150lNJF6FMf5/Aq8F/m4i
	 2dtLWm9m99p4ysaTZACC2jsF+KPSg/56ZKZUp+Tn/lmXtahoG9cZ264t6N601qh7wz
	 4j7jFsOWy7ywA==
Date: Thu, 5 Mar 2026 12:35:55 -0700
From: Keith Busch <kbusch@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/21] nvme-auth: use crypto library for HMAC and hashing
Message-ID: <aanbGwda2pHmMTMx@kbusch-mbp>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260304132327.GA15515@lst.de>
 <20260305193150.GF2796@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305193150.GF2796@quark>

On Thu, Mar 05, 2026 at 11:31:50AM -0800, Eric Biggers wrote:
> On Wed, Mar 04, 2026 at 02:23:27PM +0100, Christoph Hellwig wrote:
> > Thanks, this looks really great:
> > 
> > Acked-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> Thanks.  I assume Keith will pick this series up for 7.1.  Keith, I
> forgot to include you explicitly on the recipients list (I must have run
> get_maintainer on drivers/nvme/target/ instead of drivers/nvme/common/),
> but I assume you received this series via linux-nvme anyway.

No worries, I'll start up a 7.1 branch and get this queued up. Thanks!
