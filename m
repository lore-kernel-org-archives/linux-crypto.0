Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD50046AF00;
	Fri, 25 Sep 2026 20:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790367073; cv=none; b=OkgBOJ3iqRHYYi1USy69pNvBj+R53Z+x00SycZ6HOCPpz2AUIZnqtAcBWilN/NqNP1Iu0zTM44CeOVPdOcVAPeXaF47DWrS8E+1BIzYT6h2UdcUZWj9/9lBOowUHB/GheVxxaAUh7bQ2wBHsHBLqV/iqRwQQX6Yaw9G+RBlekvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790367073; c=relaxed/simple;
	bh=NAOgnCpCFzVulMxzsRWb7i7Kgps5cpZTdQZTvGoKD7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u3mO/IcEFOvf9P48HK0QQT7uSFsfhQrTSvDdFxpkioRjF1/e43e0MrfNwZKf2zLz0fmU8C6sx8WbO3v3jiPj6L97x6PtHTP0+eZSsKcVszVA6ZwbvnQ4dy6KlfWrO5pxW2lyogpt1E604Mlwn7KX2w0L8uJyYsp/L/KmvoBymUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGmZ1LPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGmZ1LPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28641F000FF;
	Fri, 25 Sep 2026 20:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367059;
	bh=kJP8N/L1Glrj60sMlpvG+mFjCCFKLy8Oo8F0HfdhWWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SGmZ1LPU/R43kHCl00Yz+LpGs6VbBdQod6a9lHIn7x64K1g67Lt2F4BsSGK3snikw
	 FNRAwzmvN50bi3v+iFG4vnSCewDqlF3ipHmGEFbrYEmmXw4Dx6q1HulDgXEGKVtXMj
	 uoPBYHh5Icdd5Lh4mzrCpdNqfgSM0rWmqubm+mJcTpuX4aBfZhuFW9lO6ApJgYPMBw
	 sWnGdSX0yYYVpRMWj2dH4A9qDhftEkXbo8C2oQm4Qgx1VYlKb6EmLfIoE7C6z1U8+m
	 GKJk2DLI4ly1C8gi1f2RYz5UBPyXw09hMPxHwomgZ39fn6pPQjJ+bKWRfByBKyubvU
	 0U6Oxj0xYzwFg==
Date: Fri, 25 Sep 2026 13:10:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Place libcrypto docs under CRYPTO LIBRARY
Message-ID: <20260925201057.GD5511@quark>
References: <20260925053240.189395-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925053240.189395-1-ebiggers@kernel.org>

On Thu, Sep 24, 2026 at 10:32:40PM -0700, Eric Biggers wrote:
> Place Documentation/crypto/libcrypto* under the appropriate entry in
> MAINTAINERS.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is intended to be taken through libcrypto-next
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
