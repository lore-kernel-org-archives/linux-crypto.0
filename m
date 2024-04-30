Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22A117F37D
	for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2024 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714496175; cv=none; b=B7wSi64dHLeIiGZ6p2ouz6mF896Yg11c7x52zcJJhbi1DZL0y1W1rBcF/rKoRUU+QE2aLIpiMaBqgaHXSHxTOJSElF1/4IYj9lj8csBGbJTA89yK3wOV4VQ/ZWcpXkrC62fIxH7a0Ry5NINS261VKxTvLpOdp6X5mUyeC9U4ZOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714496175; c=relaxed/simple;
	bh=LUVmQSZ4qGo1AkTdWS5JEx7b3HeJ4vexz5J88zbpQjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUc2a3oGAkgu+7HghQ6amCpp8pkxOZzRi2rirbrBi3Oe95GayK74gJyVxBFAP0xxMQYjU9qCtuODUKZskqsBi132W1f++vd2VnqKSwjiwpXT1G+rpUjJgbfgzsyjPlbkmJUfyHkxNJaeILXbBbYbBUqb2EMd+D5xlCbeMSHO1gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hqx4LPrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hqx4LPrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21857C2BBFC;
	Tue, 30 Apr 2024 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714496175;
	bh=LUVmQSZ4qGo1AkTdWS5JEx7b3HeJ4vexz5J88zbpQjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hqx4LPrw0PORrvdF4RCjelR4i59Wa8JFMieu8SEUPz72YovgD/fEeCZL5TRLMKw8v
	 1qcJyn81rnzeOU1JDD9Ts1dsqLNqyoA5XKpZEJYYEjQQOC/wh1IVPN1HE5z2mE+WZe
	 LDhBqXo0tlWZnMdYjuqVYJm/YxmbmYkHtKbMgn9Rosk3ZbCZWtZiHoi3+FqynkTSR0
	 NK9GeN/Wj1FnqZ6fSG+UefBB3O62TVYsi3+CRpYJsbFMCUpPX6Tevha+IFkFuYeEzC
	 gj1NDp7OofzP60qyL+J+qGcny+Dh3BfnoZ3BrjYQhMMa7gUABx2Zl3bLPBvfk+8cx1
	 OEcJhFDx76lKQ==
Date: Tue, 30 Apr 2024 09:56:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/1] crypto: use 'time_left' instead of 'timeout' with
 wait_for_*() functions
Message-ID: <20240430165613.GA1110@sol.localdomain>
References: <20240430121443.30652-1-wsa+renesas@sang-engineering.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430121443.30652-1-wsa+renesas@sang-engineering.com>

On Tue, Apr 30, 2024 at 02:14:41PM +0200, Wolfram Sang wrote:
> [PATCH 0/1] crypto: use 'time_left' instead of 'timeout' with wait_for_*() functions

1-patch series should not have a cover letter.  Just include the details in the
patch itself.

> There is a confusing pattern in the kernel to use a variable named 'timeout' to
> store the result of wait_for_*() functions causing patterns like:
> 
>         timeout = wait_for_completion_timeout(...)
>         if (!timeout) return -ETIMEDOUT;
> 
> with all kinds of permutations. Use 'time_left' as a variable to make the code
> obvious and self explaining.

I would understand it to be the remaining timeout, so I'm not sure the existing
name is really that bad.  But I agree that time_left is clearer.

- Eric
