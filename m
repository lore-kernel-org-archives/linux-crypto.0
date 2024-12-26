Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5F88249F;
	Thu, 26 Dec 2024 19:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735239916; cv=none; b=bO37C7mWj0BSi7mP3pcEDh6QrTlvsE+6lSTNChapPM5zIHeKBhBc9jpYel93Jly/kzhBNnNvNyO297RYzoNcCMa5WhGM7KMdRwtuhlTO4d4xmm35xM/zgufYaMyZ6spFO4UtAyqXs7npVP7H6N/bZH7rlTMaYLKvzsTIOUumBo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735239916; c=relaxed/simple;
	bh=pM17w8Jt4nMg1ozRnjn3CwfaFzP+ctyU6I7v251FZ9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L4I3pvreW2qEEH/PC4HbK2S5PcwqKJTRgbZA9hQ7nk9wsPMFJGz1Rc6oGXcEkPHE3tTAWrxhUlmB9AwmUVXS6yghYQBM/EhS0qsGeg9R2j3HYO3s5BYgvQktuHQh25RiA1e0abhLCEJX0fLnP7ydlmDnEh7Y31OUI66eaMVyimM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKWzzBVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKWzzBVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F34DC4CED1;
	Thu, 26 Dec 2024 19:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735239915;
	bh=pM17w8Jt4nMg1ozRnjn3CwfaFzP+ctyU6I7v251FZ9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JKWzzBVOEmP0+eOWkhTYYalHJOIHkIC6/9068GdfBqvs8/WMqcxhLiB9iDuy8iJbA
	 FQ9sVIf7zJMSeWO90BPtsiJhU70OkoKXadOzsBdJ0YtJlwVQdneAOdAyWEEPpihX9i
	 UlY+/0sAujilMJQIfFh387D2lem/ReJsT3bLlJDov7s+tPja8tn/dafmnnFf2dU7gK
	 LHzfgJbfE0d5C7jItoGgscQHEJuyCu0PwNyYdnrj88nPtKnFjxeLhwNqrlJpb4h3j2
	 ivjB5CAnhbvLD8uvF6vIZbRkiCMxKuUpJJh/NttBr2qJw2edumMbxh1Q/5BKq99Jcf
	 YwpZO+3POfOxw==
Date: Thu, 26 Dec 2024 11:05:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Atharva Tiwari <evepolonium@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: vmac - Handle unaligned input in vmac_update
Message-ID: <20241226190507.GA4648@quark.localdomain>
References: <20241226170049.1526-1-evepolonium@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241226170049.1526-1-evepolonium@gmail.com>

On Thu, Dec 26, 2024 at 10:30:49PM +0530, Atharva Tiwari wrote:
> The `vmac_update` function previously assumed that `p` was aligned,
> which could lead to misaligned memory accesses when processing blocks.
> This patch resolves the issue by, 
> introducing a temporary buffer to ensure alignment.
> 
> Changes include:
> - Allocating a temporary buffer (`__le64 *data`) to store aligned blocks.
> - Using `get_unaligned_le64` to safely read data into the temporary buffer.
> - Iteratively processing blocks with the `vhash_blocks` function.
> - Properly freeing the allocated temporary buffer after processing.
> 
> Signed-off-by: Atharva Tiwari <evepolonium@gmail.com>

Are you using vmac for something?  As far as I know it is unused upstream, and
we should just remove it instead.

- Eric
