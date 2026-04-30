Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0674399350;
	Thu, 30 Apr 2026 07:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777532745; cv=none; b=VK9IRC7u7deTOJkD261mHgRt/S9KnIZHCvx4oe9rVAUyqLFFkh+LegoEzoJy5VKylzZcnF+UZ4riw3ci09TdK+lvbKrSP+fmtWuAHM4O358kGPjmkNcsN/cCOA4xwT+mFl2sLMnRn0tP1Yl/KmtNlK0ZcU2W396LWZ2bjnR4/DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777532745; c=relaxed/simple;
	bh=l1EryPlKHRRTqH8BalExfFp9ox1UD1VNuSidiDnXZ/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NuHhyrWPVsMQ39v4hAkls/PY6ro8bD8pY4kWw0WpUNGPUsmqN/d3ijKiWHgm789OPcLt8lyxl5kiVV3BiVDk0NrT0Yma5xYgXtWRU5pLPZZMSFMFRRns9XJ7Z7rl2Mbxh83OahvtU7pI8xssVFXCaE0GRXXwbR7Nj9FYvLfIsPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=MPCIs5Uc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=r6ewvIPe; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="MPCIs5Uc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="r6ewvIPe"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 09B9A1D0008E;
	Thu, 30 Apr 2026 03:05:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 30 Apr 2026 03:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1777532742; x=1777619142; bh=Tfx6KIAZI5
	DGLRZGs5/ecI2HihbQLWjAJOUVeyQRGBc=; b=MPCIs5Uc/aFWpDEyA+6UO9pLre
	tsKllgApSXVBFf2hwJMiIvVEl/ogdQgfFDGgmVMl/+GSZ0k8d9YqjIS+b4c7Y/ZV
	QsRJEVeG0kX5xCjyZLSOEr4X3GfmE93grd6pVQFBEg8DO4KE+LcAt1a+vn0DMJSD
	S73OFzhFNVrLozP9esYu9SA2xY8L0mdR+pSamJJcHIXPYQ9XUMGIblNr7li4cnpL
	20wdCSyOHMRBRs+45UgQ/co+XJ8fOWeQ6SLJjGvma3Gn83bCbP9eQbB5M9JezYTQ
	CKsrt/arn9BDcIDBRZ1ndNcwcE5ogfko4sStFdlWDokltYVX3MaVwksiI2TQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1777532742; x=1777619142; bh=Tfx6KIAZI5DGLRZGs5/ecI2HihbQLWjAJOU
	VeyQRGBc=; b=r6ewvIPeBUv17tevphEB50PqoyjBzp9ORrOx8T2CferKXTdMvKx
	NHtEQR/2rKf2w/gnPQu+zc0WY8hOfrmHRUu2BT85P1tHVUuBdVqz/1FEfYVH5Luc
	44CXrw/g3QsvW9DeC/9HPZypwJAV96A1sHn4uu5pdg5g0uwgXfWldye8uxcPyNQH
	5VKIoLs1jAGHRG8vrcq13hj6B5VY5pE9tBVEcVIrylyE3X3fJVSL0rZdXcSX69xR
	8t+GLaWchLJnir8CWEYUFKgDMcE2dKntUuWG6nCspZGRFbND7Zwq8Lg2PodbFBqj
	aOma6GX3ZmKW/VlD8HR+mS/3Cmi1g4cAu3Q==
X-ME-Sender: <xms:Rv_yaaEy64JeIeWixphr6zJVA36woNgQPRa_CEcJTQjoz-UU7vDvag>
    <xme:Rv_yaeY1gojL9YGnmhnxySSaDEOrDMVYuSdyoOcvvDKi-KXCZIb7lPxPl5D20hM5a
    5-VpyFkQuffJMEdBPFQHf5CEtRYvLpB01nlXdHaJKYV4E4Y>
X-ME-Received: <xmr:Rv_yaexuA5wiAMXqAwcnoECAnJQqT2lZItOY20kQPKiKwgEBdwAuGdeLntL_4M6xwjYTAxEpJxvbytBe-Wz_27ni-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekieeijecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcumffj
    uceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefhjefgffekie
    ehteekhefftdefueehudevffeiheevheeltefgtdeuudfgffekudenucffohhmrghinhep
    tghophihrdhfrghilhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhdpnhgspghrtghpthhtohepkedpmhho
    uggvpehsmhhtphhouhhtpdhrtghpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghu
X-ME-Proxy: <xmx:Rv_yaQS6sEWeBoYdcDZOwGyThMoexUzxezkUSz8UYvN44i1K4Sl01A>
    <xmx:Rv_yabI0z_ppyNlhxE3kSLA3f2lk0jWPK1hFneop3jXU9H8kqXPZZA>
    <xmx:Rv_yaXVsG6ZcF-dMCruUA6ZG5qoMTUWiQbtmP72XBisrOjNat4DEXA>
    <xmx:Rv_yafQNdViiL4KElkYrx0gp5VwyNqv9yuw1m5gElR-hNe9A7Fjyvg>
    <xmx:Rv_yaZMM-mWjDCXQT2R1auByU0kPlv4p2eQ-I3V8c6gseDhKiOf_j1fs>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Apr 2026 03:05:41 -0400 (EDT)
Date: Thu, 30 Apr 2026 09:05:02 +0200
From: Greg KH <greg@kroah.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.12 0/8] AF_ALG fixes
Message-ID: <2026043052-juiciness-dreamlike-e33c@gregkh>
References: <20260430060702.110091-1-ebiggers@kernel.org>
 <20260430061120.GA54208@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430061120.GA54208@sol>

On Wed, Apr 29, 2026 at 11:11:20PM -0700, Eric Biggers wrote:
> On Wed, Apr 29, 2026 at 11:06:54PM -0700, Eric Biggers wrote:
> > This series backports the recent AF_ALG fixes to 6.12.  These include
> > the fix for https://copy.fail/, fixes for that fix, and some other fixes
> > that went in at around the same time that seem related.
> > 
> > To enable the 5 actual fix commits to cherry-pick cleanly, commit 1
> > copies the latest implementation of memcpy_sglist() from upstream, and
> > commits 2 and 5 cleanly cherry-pick a couple cleanup commits.
> > 
> > I didn't check older kernels yet, but this should be usable as a
> > starting point for them.
> 
> It applies to 6.6 as well.  There's a conflict on 6.1.

There's a conflict on 6.6, let me see if I can fix it up...
