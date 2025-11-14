Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0962F1FFA;
	Fri, 14 Nov 2025 19:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763148495; cv=none; b=hNaZYFRIQGaPssw7jWl4RVMW1KEePy2UAJAIMIfhD/gzgPJ8N5cb0GFwMyohxFjZZQ7irdVqGMVJv4A/S08o7rhJYY3j803YAig56EgF9ZvwZ6Q9qVjHscCAnSdBaAyd0ALx1p2EGlmzf+7dT1yYWp9o6x4oUkqGQhkkLZUkdBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763148495; c=relaxed/simple;
	bh=eryx0/b7jG9F3iLaxcmnLHiHXhmS7gVRnhFG5wOTxt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZenXz5493NsETiNuVCFifgAlwnR8mLMCHo5eRk++hSztjaGR3xf6gdGhrqljFBVKFH/RjflCh9oF7jblxDscILnI+NVzwFRSe3ZYW/39vA4eCX0Xe4f0+VNHPACrl2eB24aezeBSHqXSEinsQ7cMRru5PY31SBxq4H+pDzgFnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLR8v5XH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLR8v5XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521C1C4CEF1;
	Fri, 14 Nov 2025 19:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763148495;
	bh=eryx0/b7jG9F3iLaxcmnLHiHXhmS7gVRnhFG5wOTxt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mLR8v5XHQDnT/pZa5Qm3yJcwetP7OhAY75QAQZ/rxur/ztloUEUb650kEiuKn8Zl4
	 cJUjbR6nq4YjeaPs9+N5kyBoeb62qwlfio5JkGOH9WPIB5SAs63S85/95Ld7GMFwAb
	 zsyc+uJVgEWNA/z84Qmm++97Ypxv7+i7VtlJ3vTWcVQxGjQLZItBlyiwXdZCp8p3wR
	 Odvk5szQIA+vap1NU2Wil9KL8YOKOj2whhTsmceaoYOei+4aREfFvX4rcbw3OWN55b
	 ZK4AjyaOkqnsNIzkWm8+g6r1w36e10neiiV/XL93s1kTjvqFmk41nqZXzFSr9IO2y5
	 Vyb/m20+MAbZA==
Date: Fri, 14 Nov 2025 11:28:10 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Colin Ian King <coking@nvidia.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: scatterwalk: propagate errors from failed call
 to skcipher_walk_first
Message-ID: <20251114192810.GA1687@quark>
References: <20251114122620.111623-1-coking@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114122620.111623-1-coking@nvidia.com>

On Fri, Nov 14, 2025 at 12:26:19PM +0000, Colin Ian King wrote:
> There are cases where skcipher_walk_first can fail and errors such as
> -ENOMEM or -EDEADLK are being ignored in memcpy_sglist. Add error checks
> and propagate the error down to callers.
> 
> This fixes silent data loss from callers to memcpy_sglist (since walk is
> zero'd) or potential encryption on the wrong data.
> 
> Signed-off-by: Colin Ian King <coking@nvidia.com>

There's no need for copying between two scatterlists to be able to fail.
memcpy_sglist() should just be implemented from first principles instead
of misusing the skcipher_walk stuff.  I actually suggested this already
(https://lore.kernel.org/linux-crypto/20250427010834.GB68006@quark/) but
unfortunately it was disregarded.

- Eric
