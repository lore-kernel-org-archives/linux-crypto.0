Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF3D24CED8;
	Mon, 10 Feb 2025 21:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739223428; cv=none; b=J4iTXNhC5qvILxA5zdDQOrThxQpNDaSrMfz/oDhzW4o3KPFSWT2f16XWgivUDCqn9dHxJeFFC2+2/TVztJirG2EsRXd9+C7YPyoTSVkbkJXm8ef3TZvZqfMKV1iUPOYSrwPStByNIkBQxD6E6oFbzmTwNAm5RGK04pSX7307dvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739223428; c=relaxed/simple;
	bh=0vrzO08uxRI9nXVKLQ7vEzjbLqL+9WEKyehkyq7gHhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3hLX5zNcDpXDDFj99JyB4D1QdZrnuqhUD59uXV6Iog9ytqfK/bXXPMJ+aUq/XMfsMrP0Y8EIXphHtXgoe1wmOifiNtbCyIDSaE9cCyv/x2EsjBFtpJY4947n/SurBGHk84xrt0zmszinAtFuDcKjUxnETz9aN3NbU402/wXVjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuL4Jfv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuL4Jfv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF147C4CEE4;
	Mon, 10 Feb 2025 21:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739223427;
	bh=0vrzO08uxRI9nXVKLQ7vEzjbLqL+9WEKyehkyq7gHhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BuL4Jfv2JCgoeWvCeXR7drVxBrxhbihc/zrhYIinYXlBXpNTMJJ0KLRJRzHmsOt7M
	 I1dlC62cHqT6rmB038YO9SgH5xWz0pzc4Slo0ioy9LFNUYBJewf1cKEFfCJojSoag8
	 SYZ/gJGOdJbz3lAGCohtenu+A/DmG36msHiwSDUdLUP1qtsEwBjza2j6tA+zCHbsiP
	 Q47O/dQ9GQJJjG/LhI/vkKZaxnmvprhvwV7VLlOJ5EK3uLepZlLDBW1XqpKatW93hB
	 CMYkhghYj/pSTgB6XUUQdIWfWeCd0K0iYyNfTc+jGTpAA7KdTedvLdIdLegdx0Cscq
	 7uyTKaNxWU1jw==
Date: Mon, 10 Feb 2025 13:37:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v4 1/6] x86: move ZMM exclusion list into CPU feature flag
Message-ID: <20250210213705.GD348261@sol.localdomain>
References: <20250210174540.161705-1-ebiggers@kernel.org>
 <20250210174540.161705-2-ebiggers@kernel.org>
 <20250210204030.GBZ6pkPumjGQMaHWLb@fat_crate.local>
 <20250210210103.GC348261@sol.localdomain>
 <20250210211710.GCZ6ps1pNklAXyqD0p@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210211710.GCZ6ps1pNklAXyqD0p@fat_crate.local>

On Mon, Feb 10, 2025 at 10:17:10PM +0100, Borislav Petkov wrote:
> On Mon, Feb 10, 2025 at 01:01:03PM -0800, Eric Biggers wrote:
> > I see that cpu_feature_enabled() uses code patching while boot_cpu_has() does
> > not.  All these checks occur once at module load time, though, so code patching
> > wouldn't be beneficial.
> 
> We want to convert all code to use a single interface for testing CPU features
> - cpu_feature_enabled() - and the implementation shouldn't be important to
> users - it should just work.
> 
> Since you're adding new code, you might as well use the proper interface. As
> to converting crypto/ and the rest of the tree, that should happen at some
> point... eventually...

Well, it's new code in a function that already has a bunch of boot_cpu_has()
checks.  I don't really like leaving around random inconsistencies.  If there is
a new way to do it, we should just update it everywhere.

I'll also note that boot_cpu_has() is missing a comment that says it is
deprecated (if it really is).

- Eric
