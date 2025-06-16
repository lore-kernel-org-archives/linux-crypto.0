Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEFD136349;
	Mon, 16 Jun 2025 21:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750109153; cv=none; b=oGy7eC6aLhd193LD7a6ZranxXfDIBxqHZ++o/7Bn2v/D20SBznqgJMncB4RPODMAhAJNW/r0rrjM4Xw65vwFifVmqWQLQtIYl64oJuUTUmTVoB6Vq2EOjEviG9zllPAZA1VDTnmm1QNO1M6Bgc9RBc58TXeUm/CZgI4K71WCvxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750109153; c=relaxed/simple;
	bh=0kYeZiVaYQJlDMo+2AJELjaqnqjC9u7JSXwvaUyPgyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qbnN8vshIHiwCHpkMDXiBg92cCnI8si7kdJuVt7xbec89/vGJYjKbr68EZWlJjqbILujTmAdXF8pIxU9lvzxiT2J93XU5ZtcnkSvgQDd36YRZF+oQJ4kAE5EdtOXnFPOc1iJUz+UVW1plBi8kEyiUJfwWR5Lf/3IUzPOyGBQhCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GCU8UjnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GCU8UjnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71296C4CEEA;
	Mon, 16 Jun 2025 21:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750109151;
	bh=0kYeZiVaYQJlDMo+2AJELjaqnqjC9u7JSXwvaUyPgyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GCU8UjnPn2USt+7Xz/zM5pOJJHEVfj6ASltAZDneDkoE5Y6CJ2yb/oCuZwhDFMb+f
	 gHgZQ31+YCH7klDcVql7CTSffdvda/BD5QoNLV6bu1KFLX4qC4z76dT2PqycmmYagx
	 0aVQjWwgBvFSRvbxF/IF8jVmaQjZZAtb14E8uGDY9M+OZhQw3ELvrnJJNPeLowMlbB
	 +ZmMzxGpeA/Ha9BSWrWAd4wO/yhvXdGEnu3ZDQVTRZcvkO1w9AKz5Sv8SzvllnMjZA
	 s1oWc3WILj6jWrR410zfYlKPTOwndaKssY6jI72WmD6IdcVBBl3WAGTLxEOeY5hAZL
	 3eAm59tlpaHSA==
Date: Mon, 16 Jun 2025 21:25:49 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - lower priority for skcipher and aead
 algorithms
Message-ID: <20250616212549.GB23807@google.com>
References: <20250613103309.22440-1-giovanni.cabiddu@intel.com>
 <aE-a-q_wQ5qNFcF_@gondor.apana.org.au>
 <aFAyBgwCUN2NLXOE@gcabiddu-mobl.ger.corp.intel.com>
 <20250616164752.GB1373@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616164752.GB1373@sol>

On Mon, Jun 16, 2025 at 09:47:52AM -0700, Eric Biggers wrote:
> FWIW, on an AMD EPYC 9B45 (Zen 5 / Turin) server processor, I get 35.2 GB/s.
> This processor appeared to run at about 4.15 GHz, so that's about 8.5 bytes per
> cycle.  That's 51% more bytes per cycle than Intel.  This shows that there is
> still room for improvement in VAES, even when it's already much better than QAT.

Also, to be clear, the 35.2 GB/s (and the corresponding bytes/cycle number of
8.5) is single-thread throughput.  This should have been clear since I compared
it to the single-thread throughput on Emerald Rapids.  But I just wanted to make
sure to state it explicitly, as an earlier part of my email discussed
whole-processor throughput which it could be confused with.

- Eric
