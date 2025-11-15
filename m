Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4AE23C512;
	Sat, 15 Nov 2025 22:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763246828; cv=none; b=CTEdB35e9s5WQnJTDSOvn/XXYlbiCFewTAk4m1KbhLqZhFWBVD9kP54Zi3CGch7niWhnNRRT45EexHpHxiPTG2uIe6XZaC38Nvz4EzdY/LuBuJMjY9bzUD3KTMzAhau0bfsLebDGugkZms3UmabyCX0Jx/Iziu9oajeCiTRyf3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763246828; c=relaxed/simple;
	bh=hQwb56XishG6Npr0bKU5tri4GKJyyN/6ZQreEwScrKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRV2iS6HJyF4/BZhspURAh8otSFH5mxY3Zs3rngZ3HfQdqGs3fYdaYBi3XO49dsj8UWfSL7PMtOP1PBfg98ztC/IMk+iq7OfuCL7IX9mkT0nBrmUlwsdm4RfIH+rb1JdmOyv2Ht5dym0KQ+1mDLI5LrqdmfanJQXTpd32Dq8yCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lxb0xi7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lxb0xi7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D11C4CEF7;
	Sat, 15 Nov 2025 22:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763246824;
	bh=hQwb56XishG6Npr0bKU5tri4GKJyyN/6ZQreEwScrKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lxb0xi7PJvh7StcNDuwQvJrFI+1nX4Ftglp4eQgwlPlN5UQhvCnXRqzGD+QyLwGdz
	 lgDw5CniJZbi29c2Cw1mQVXTlpQ4NC+Q+Z3yBueMnVW/e4lQMjz63dPlb1Bam4b5q0
	 9HdscdILI8NFCphk36akV2Y6GXciklLJRRusO6CPJRkl7hYe+V88prQp0ptLB+N21O
	 Ef1xK10onaipIy6utWNAtpLQQYooPqe0q/TDZQXzm9jg1/ZFUKnX8XFI6CzCz/sOHA
	 O6Yt9g1wPjuuYdPwhscQ+/E9yruO07nFqptcm/Qaubkr8dHyASFxbUwVYWRkxImwMX
	 +/nnf+gzR33Ng==
Date: Sat, 15 Nov 2025 14:47:00 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Colin Ian King <coking@nvidia.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: scatterwalk - Fix memcpy_sglist() to always
 succeed
Message-ID: <20251115224700.GA8885@quark>
References: <20251114225851.324143-1-ebiggers@kernel.org>
 <20251114225851.324143-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114225851.324143-2-ebiggers@kernel.org>

On Fri, Nov 14, 2025 at 02:58:50PM -0800, Eric Biggers wrote:
> +/**
> + * memcpy_sglist() - Copy data from one scatterlist to another
> + * @dst: The destination scatterlist.  Can be NULL if @nbytes == 0.
> + * @src: The source scatterlist.  Can be NULL if @nbytes == 0.
> + * @nbytes: Number of bytes to copy
> + *
> + * The scatterlists can overlap.  Hence this really acts like memmove(), not
> + * memcpy().
> + *
> + * Context: Any context
> + */
[...]
> +			if (src_virt != dst_virt) {
> +				memmove(dst_virt, src_virt, len);
> +				if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
> +					__scatterwalk_flush_dcache_pages(
> +						dst_page, dst_offset, len);
> +			}

I realized that this doesn't correctly handle arbitrary overlaps in the
case where there are multiple copy steps.  So, my idea to make this
function more robust by allowing arbitrary overlaps won't easily work.
I'll send a revised version that only claims to support exact overlaps,
which is consistent with the current code.

- Eric
