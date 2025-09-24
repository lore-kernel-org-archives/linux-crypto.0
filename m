Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D8219AD5C;
	Wed, 24 Sep 2025 19:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758740772; cv=none; b=iVIofyITDIJkcOHwdYgqv+NlLvCBFQF8pSnM5flRqreZgv+EDNjy7zJu+v/p4vAISkK23amwEUnQsiHKhNvV1IfvR2xidwUqaLRfapXAMxLNxUtqG3H4/xEjHaWLtIcD6bbsEXD3yxtEywldBXodTWL1Hln82XANDvUtshij2lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758740772; c=relaxed/simple;
	bh=yyP6vn3eJdEwhQ9yMdZcV+Vkf7vdp0qvAuTTPFI4nfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwaxAGqAexqpaEDs5RvmOqL/jyxs/4b75RVTSP4stQgwD9yn1AzfQjMXfrqR9DIvibOcn/wyjAQ85C/t6dzvXgvLg+kyD7zfYh3q5hChZqhmWSbFronXxBBy/kEMdpbThYvgQ+GRQQiNJQUdXt9NRWWLXau6/o91N/EXWUQvqT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vP6YE6Zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vP6YE6Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533C4C4CEE7;
	Wed, 24 Sep 2025 19:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758740771;
	bh=yyP6vn3eJdEwhQ9yMdZcV+Vkf7vdp0qvAuTTPFI4nfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vP6YE6ZugbrlggWnSH9Lh+NQrvAmfpXwaiNk7JWif2N5CkMfnk/z78ioO0LbFktdP
	 8yW/fffJAzFtJlto3ZxNw4KHbwMkYCOrP/jSakoMCeJ16ncZNqw2+GyyslSRydLx/8
	 qm/mfOgDksA7wuJIFSsW3hXnXM/P9jQA+yiFJKIF+7LkSxuZCZR8bdu7998Op49j/C
	 TAmnSBcGG0E01i3wfFpEjd+cgcDqGsIRSkSqj1ix5/YM4bdYpBeXPguTivcm4s1/fS
	 J+9higYbXbkK7FGV+ql+OQPOmLAZf7KS/B5e1P1yP2raX5WjBb59VjBoG3cxRMrQWX
	 STxWWcdROfaMA==
Date: Wed, 24 Sep 2025 19:06:09 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Fixes for 6.17
Message-ID: <20250924190609.GA809378@google.com>
References: <aMzXm4zy8LARVMbk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMzXm4zy8LARVMbk@gondor.apana.org.au>

On Fri, Sep 19, 2025 at 12:10:03PM +0800, Herbert Xu wrote:
> Herbert Xu (2):
>       crypto: af_alg - Set merge to zero early in af_alg_sendmsg
>       crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg

These seem to have been pushed out without any public review.  Note that
the second patch is buggy, since it changed fields from 'bool' to 1-bit
bitfields without updating code to stop assigning values greater than 1.

- Eric
