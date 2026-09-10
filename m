Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F003AFD0E;
	Thu, 10 Sep 2026 08:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789029498; cv=none; b=sH7xiNrq7g9ud1zeYolQ/xJwtMBeggRFoGrcITumNHwdl+qfv9apdM7PnclCmHtCIo3nhCg4XcOFJiG6ViT3XF4LqcJY/NVSGAdNZ7l8UaC5bxLaTMdd/s1TPb58QewpUyEcVV4JjTNXIPtZsF2pKmhivjy4tEbJGlYp6xEUW5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789029498; c=relaxed/simple;
	bh=zK73mQCE7eL25giVjETkO1jHrD9oIHRwKKp1VRgnYrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPZmyVxZ9I9uh7ZKOCRwk347kEkLXxik/JrqHVtGPz0BzUDwbZGAoaY6dAa3m0I1Gy7VAxhnqynOPkAZST/r5p8WbdlZwn7Ioj7oJARXBYJi1GUb55m57UxJ1Ifb/bR62p3v8yUFsv7V8x4P7BfRf7+If8VUj3f5Kyp/f78XuJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eJEcYmwb; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eJEcYmwb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mG/4AGN6tjfd63G18lYs6f5vejXgChWS/qvpHpogEEE=; b=eJEcYmwbeaU9Von9rzUqN922Y8
	/LYSnBHA1uZsh91UEF2DJYRHPrVy6B3UjC1uMfbSG/lv5mtiTb6822MmMms6UJOEgFw+3SQmSLxOQ
	gTlmt4Ie9xzj3O60Eu+hEM0VlmsLaEyW+OBlBB33IkfTG85xxvnoYRCrrf2SfDWmmU48b1NkProQ+
	3AUxJZ/JMOZre/1eZRS8kr96tLtZSXxE9WiXuoA5swejH8Qx8FpzP5awusmh0mlCYhHJExWjM5ih/
	9pcwde1UfS8NSNe1H5bwiI7sac7PnJPz+UDBPcoiT/upywFCOkNt9tzc9T/xq9TpaU7/Fo5s5G44y
	DPP6Sxnw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x4aIF-00000002CmU-1F4p;
	Thu, 10 Sep 2026 08:38:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B502E30056B; Thu, 10 Sep 2026 10:38:01 +0200 (CEST)
Date: Thu, 10 Sep 2026 10:38:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 6/8] x86/fpu: Remove cpu_has_xfeatures()
Message-ID: <20260910083801.GU4121339@noisy.programming.kicks-ass.net>
References: <20260901145740.42337-1-ebiggers@kernel.org>
 <20260901145740.42337-7-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901145740.42337-7-ebiggers@kernel.org>

On Tue, Sep 01, 2026 at 07:57:38AM -0700, Eric Biggers wrote:
> The only remaining caller of cpu_has_xfeatures() is
> print_xstate_features(), which uses it only to check and get the name of
> a single feature.
> 
> Remove it and just inline the needed code into print_xstate_features().
> 
> This also makes the "unknown xstate feature" entry at index XFEATURE_MAX
> of xfeature_names[] unnecessary, so remove that too.
> 
> Acked-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Turns out there are a few new ones in tip/perf/core, so if you merge
tip/x86/fpu and tip/perf/core things no longer build.

I'm not entirely sure how to go about fixing this. Some seem trivial
enough, but others, like XFEATURE_MASK_OPMASK I don't readily see a
replacement for.

Boris, can you have a look? For now I'm reverting this patch locally.
