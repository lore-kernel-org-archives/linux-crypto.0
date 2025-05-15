Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ECD1F4CB1
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 19:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747337592; cv=none; b=lfoeFq5wN752/MlBmHdXoH7YbLM0f4u2b82U4RJ+KC6FJ/PhNd1tD3JsIL1xxp7ZRpC7ruzELqjTBuAyUf4FRFBgT6P91eLHJGjJbHrtwh+RhPPpiI6nOLHjq3KEE5AIu8Iezm/emPqL5Bgf5ZLJyBpo00IHZExNLBGslVA185E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747337592; c=relaxed/simple;
	bh=RFbi6Jk64Z+ER5QogLgJnZ8LZjPYZEKFOTzYsMFbjmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2Brwnu8K/SBcBNaob0GVpaLuteODPUzVtbKLqJkqCVRcrYgTdKuw0mhiAS4rl/sbFXuOZ+8UsRKbpVjDJD+HGOr79fJ/adGwBpeE6MypcWclV4KGTKm6uP4y0K6FbrVA/47aMuE0s1az2ToeACOl6R9MM6s+6FFOpa5z/rv1fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTDrp0Ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTDrp0Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4280C4CEE7;
	Thu, 15 May 2025 19:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747337592;
	bh=RFbi6Jk64Z+ER5QogLgJnZ8LZjPYZEKFOTzYsMFbjmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CTDrp0OxaESCVq9ev8ROfKT4aDHLyxYXX8ceg2ux1XnP9pNt3u6MaHVTpuCJSzmCL
	 SEF3AasU5Qo7gc/nVm7TGUnspNZY7FxxfGXLG5d9HgKI2MdKLS8P7P7TGKe5ruuvNR
	 +WXE/5lR5LnbxCWrYfaooBI/TxzhEkXq1evhA8P+8hpUd60VXvUT0HAeNhfXfVzgWz
	 WrxN6kDPcobMTvMD434ytHkeJjDm+4YRgygrbFiOvZbrFqxbxS01AG4NmZ9EMxxu1L
	 v8tFTIc+aS+u8M0BuXGAbzM8IO/O8ArSTdGi3gpqvFRu/Ofhkwa831Svw0bnR7Ih64
	 JAf8uprruzH3A==
Date: Thu, 15 May 2025 12:33:09 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 07/11] crypto: algapi - Add driver template support to
 crypto_inst_setname
Message-ID: <20250515193309.GI1411@quark>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
 <894f80301b85b4c4ba7256109bcd513d618c7f48.1747288315.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <894f80301b85b4c4ba7256109bcd513d618c7f48.1747288315.git.herbert@gondor.apana.org.au>

On Thu, May 15, 2025 at 01:54:47PM +0800, Herbert Xu wrote:
> Add support to crypto_inst_setname for having a driver template
> name that differs from the algorithm template name.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Commit message doesn't mention why the change is being made.

- Eric
