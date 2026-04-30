Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AC526A08F;
	Thu, 30 Apr 2026 06:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777529557; cv=none; b=fpK6ujUYbAUF1vFbPbldLB7G6Q6Y/X5VAUSkheVHt568KbijbzQNr78Zi6iruqZLunidKwWp2PT6vW0CicXoeQzF/wDnrLp0PmXy5MBuwuOj02ALXL6sZriDxfFfbB5wLPoGKiI2gZGCEj/tUVHV62rWd2SXCfBVC5R0Pm1pHnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777529557; c=relaxed/simple;
	bh=zPGdDQ+PrPyFerPmVm/Y5B5p/nKE873SF8qNvNEwDYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FyG0DD1209zWF/qTMAg5l1CbpqCTs8BDpiQQAf6iqHs6voujVf2gyiK7yt2655WJONFgNql0shp1I9T+HVWbQHkQIvt1itbWIw26MZb+/i+i6DIoDXj1QEr0V0JpTdzYbyY1YuRXLLNN6psJjX+9+8qOjlZNuDB5F8qgMUZQNzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s129gl3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s129gl3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E181C2BCB9;
	Thu, 30 Apr 2026 06:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777529557;
	bh=zPGdDQ+PrPyFerPmVm/Y5B5p/nKE873SF8qNvNEwDYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s129gl3E3a5L7DyBQbFFTfgW8bIV+NfD6/LPaJCM9A4SRed8fUPm/zSuW7uxMNV9+
	 3x/EDqhCiC7NiEKkuRF/WjJURbS+CTyxulxHekM7ngICw7/pS0Eq6gf5ewB/DfCpYq
	 YVk2vkxzR6SGIJQhP+vvd2mVp1ET7/Jpl+mhKv70XUijUkl3GLztrpOwoB8ujavYoP
	 h0HzLZfYiCO82atEpfGJUmcRpzhMqNPngGKyLsZk7xjk+ajUhbS7ZkFg+aG90xndXD
	 bX+kZwIZO/tVvVLOWRjLd1YY1V9T+nqRw1gZzkMneRmGSDIGlC+/4Bk+uY+nr78Sme
	 5TeajdYJ60tSw==
Date: Wed, 29 Apr 2026 23:11:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.12 0/8] AF_ALG fixes
Message-ID: <20260430061120.GA54208@sol>
References: <20260430060702.110091-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430060702.110091-1-ebiggers@kernel.org>

On Wed, Apr 29, 2026 at 11:06:54PM -0700, Eric Biggers wrote:
> This series backports the recent AF_ALG fixes to 6.12.  These include
> the fix for https://copy.fail/, fixes for that fix, and some other fixes
> that went in at around the same time that seem related.
> 
> To enable the 5 actual fix commits to cherry-pick cleanly, commit 1
> copies the latest implementation of memcpy_sglist() from upstream, and
> commits 2 and 5 cleanly cherry-pick a couple cleanup commits.
> 
> I didn't check older kernels yet, but this should be usable as a
> starting point for them.

It applies to 6.6 as well.  There's a conflict on 6.1.

- Eric
