Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB9D29B775
	for <linux-crypto@vger.kernel.org>; Tue,  2 Dec 2025 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764694192; cv=none; b=XXELOlL2WuuUWduVjDMTz5EgVVhmyxXa7sVQsSbia3d7MAOlT+r70FDaAWcp+6w4lWqDndhhNQCMUonoNQUOUPNt/Dy/MvJmKNBVmLungZcp4rOz/QgWC/8fPDW8MrnMU0nzVmNBbJTULmvroKpHwaDgxmB67A+2swwcGQVm70s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764694192; c=relaxed/simple;
	bh=TKAOBnswEox4omcVCL2zGJNH6WB61aMtden6gcUfLdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mOBuElSr5APzJWIFE7ZZ49OKprN7RLghx8ygZiYBZSjYMzvpSTxyjgsCMQ0Fg7R9tqkrsGOwm/a0G/r1UVuL9/LQJmwOxPxYt5Gte/rhCWQWcZRPV6qpcXtx5/Its9uoxehYnLT1Olf4w9yyZY+HOOso1NQVsOV6SC4vebHLGhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rMKsahSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMKsahSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A650C4CEF1;
	Tue,  2 Dec 2025 16:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764694191;
	bh=TKAOBnswEox4omcVCL2zGJNH6WB61aMtden6gcUfLdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rMKsahSzCRQ9XMH4yU+dvRuxJHLdkUsKDCWsf/AKI5sMKIYvsKk9Tt9xKqgnfIi4b
	 RgNYK34J+14cV9QGzUiGGiqinsGdVzN0/whRPZyCOLytQXVOOLLeC6Yy6rBOw56BI0
	 9uNbEm35qjU0wKzYLHpS3IUnW+wW4Ux5mmJ+SWVowTGpLqye70Mrj2SK4+v2RSAtsy
	 DlV96HRfD7VfIRjIohhGJSSmQFSKOeDAmSUYwkaZLXLI5KrenCZCyNySGJWwWERYWZ
	 Fx632Pno+QGH4Z0VCqUvGLJrvCFwoIk+TiBlcXPoKETXuMUGz4HdImzRLcPp0V0RXY
	 59rJ+DGsrS3VA==
Date: Tue, 2 Dec 2025 16:49:49 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de,
	kees@kernel.org, linux-crypto@vger.kernel.org,
	torvalds@linux-foundation.org,
	Aaron Ballman <aaron@aaronballman.com>
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <20251202164949.GB1638706@google.com>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <20251202015750.GA1638706@google.com>
 <ei7wbiu6m2lvso3gbc4ohvz3h575anjxqm64zqi7lg3pzilaxy@go4bjuiv3exr>
 <uqtp7y4smylm475jfn6krdvib66mjgxavnr5c6ciznslkwdlhd@k3awdazxphqt>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uqtp7y4smylm475jfn6krdvib66mjgxavnr5c6ciznslkwdlhd@k3awdazxphqt>

On Tue, Dec 02, 2025 at 02:42:13PM +0100, Alejandro Colomar wrote:
> > Clang doesn't enforce it.  Clang doesn't even enforce [static n].
> > Clang is in fact quite bad at diagnosing array bounds violations.
> > Aaron, could you please fix this in Clang?
> 
> Self-correction: Actually, there's different enforcement in one case:

Right, and it's the case that actually matters, which is kind of the
point.  Maybe you missed the earlier discussions.

- Eric
