Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC2020E6;
	Sat, 28 Jun 2025 06:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751091122; cv=none; b=kCpk23h5yiXG3taRfIrJ8V/EykzjnxsFtx3Td0BPkrmgeW67vxQLbF/ZIjPdmd2j5VC7feR+iNC9xrLwZX863BxHFygDCc99CarJfDb6sR+2sWTOe+Qc2NnwusZ76InTTEaFZl3jGu7+dd3sPnBFzCPcCFz79JU/AHj4z5YSGVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751091122; c=relaxed/simple;
	bh=akOxjAF+jt4G2vDJNyRfh6YemKyOpw+ta5H4u9dRlCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WN6r/vuTjCLiiu2iHVQvGffeffbBMkRQ8iLsfxdsTYuVqpGkmUUV51/h1ks1UyWk0P5HDTHxTpvJnaiC0GBjTaSOt6zxJpDNbFKA8ZT1mgeVXbiPwZOCroXpzeEurxL7Vi9Pw6Ez5EVEYzBpvuCJJzZGkS90HYLSMBdBT8zusAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySm9L0zC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySm9L0zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E170C4CEEA;
	Sat, 28 Jun 2025 06:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751091121;
	bh=akOxjAF+jt4G2vDJNyRfh6YemKyOpw+ta5H4u9dRlCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ySm9L0zCzTL4swhRZMhEWu2Hp2+DtuVS1k87jUJQ9mSCFrpA7wLfLXb/A3hFc+Zbb
	 IgzYgwRBtPHHeUZBaWDyzgSpWs6ekvxW1CvidgXyOMf0MAJyRlIyeozmE/kCko9ia/
	 yHLyT4MJIb5RyFPq0DvIdpfqqHfRzBR44K93op7A=
Date: Sat, 28 Jun 2025 07:11:59 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jay Wang <wanjay@amazon.com>
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert.xu@redhat.com>,
	Samuel Mendoza-Jonas <samjonas@amazon.com>,
	Elena Avila <ellavila@amazon.com>
Subject: Re: [PATCH 1/2] crypto: rng - Override drivers/char/random in FIPS
 mode
Message-ID: <2025062832-gleaming-tamer-fe0a@gregkh>
References: <20250628042918.32253-1-wanjay@amazon.com>
 <20250628042918.32253-2-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250628042918.32253-2-wanjay@amazon.com>

On Sat, Jun 28, 2025 at 04:29:17AM +0000, Jay Wang wrote:
> From: Herbert Xu <herbert.xu@redhat.com>
> 
> Upstream: RHEL only
> Bugzilla: 1984784
> 
> This patch overrides the drivers/char/random RNGs with the FIPS
> RNG from Crypto API when FIPS mode is enabled.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Herbert Xu <herbert.xu@redhat.com>
> (cherry picked from commit 37e0042aaf43d4494bcbea2113605366d0fe6187)

This id is not in Linus's tree, so why is this here?

Are you sure you ment to send this series out?  Have you read the stable
kernel rules?

confused,

greg k-h
