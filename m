Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF681582BA9;
	Thu, 15 Oct 2026 20:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097514; cv=none; b=sRBW0HRcngWqK+FLn5EKPT7bL4zZD/Tf9AzefwnCj34UEEmd9rw10nbeZUOIYY/Gq9BlFF79wzvJKxsqY8PucDqn9EBFJKEyXbZd99Sjc60IO2JHNRXw5pu3QikSPltXaosNnSGqR+rVAD+tRp0yF9w7aoPq8YqWq6ya4V/YW60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097514; c=relaxed/simple;
	bh=MliyD8HM5P09GJYi/L/FR0L1ZjXWA5Md2FulqSgbm14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kOTOKCuKK32SvuA2msgtyLifEYrQG+yuhf2PRkZaLqvymVJDGsppq/BhGxncQKif36iILGP11mWk1X9+w3v+tq7bwI6+LvVD8kgd9YBm6lSoy+CLJPGW9im3QLA7NzigzQ0cUmwuTKOpsbKVeHeLDdKbw8gLFukIc1TiwNMxJ+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBXvenvK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBXvenvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F0F1F000C4;
	Thu, 15 Oct 2026 20:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792097511;
	bh=QLxGqpbZnvX+/NXZ/lMDc7bpmFm89JglMLr6a9v2S+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cBXvenvK7cZChA+GWZ+QMZn1tGP9/Z4HSIkne2PhPzMw+djHnjjHNic+fZSbAn1Ty
	 YzjP8LSpgv86okuq2N9t9MswyO+Nh2exPbWkUMkdR1j8dURK3rU8ev62MKXn5bxeFS
	 9xgqP5Ss0lTzjm0ELwfeQmNz15FQFkFjcbU5uDC6PsZ1vHtsZwL4vPtNWHHTMaxwaE
	 6gOZZdiR/5i4BKpanDi3qbWvcZXEK0vtg39iNw0p1UKIcjGczBAoFFx9RxDvn/GNcu
	 g1oTi+hq4BF5y1IOwUeCohvsFn0BgAxeACKWtQWU6lXhqT0RCniiGOUjxYj7UlixRJ
	 dxSb/H1LTGndg==
Date: Thu, 15 Oct 2026 20:51:46 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Frank.Li@oss.nxp.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 6/6] async_tx: Mark as Deprecated in Kconfig
Message-ID: <20261015205146.GA2331635@google.com>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
 <20261014-async_tx_dma-v1-6-35790d01e190@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-async_tx_dma-v1-6-35790d01e190@nxp.com>

On Wed, Oct 14, 2026 at 03:43:50PM -0400, Frank.Li@oss.nxp.com wrote:
> From: Frank Li <Frank.Li@nxp.com>
> 
> The async_tx framework was introduced to support asynchronous RAID
> memory operations and DMA offload engines that were common at the time.
> Today, adoption is limited, most clients use DMAEngine interfaces
> directly, and the framework's dependency-chaining and software fallback
> features provide little value for new users.
> 
> Maintaining async_tx adds an extra abstraction layer and ongoing
> maintenance burden while serving a shrinking set of users. Deprecate the
> framework and discourage new users in favor of direct DMAEngine APIs.
> 
> Signed-off-by: Frank Li <Frank.Li@nxp.com>
> ---
>  crypto/async_tx/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
> index 89bafa2efc300..02d472fc7a476 100644
> --- a/crypto/async_tx/Kconfig
> +++ b/crypto/async_tx/Kconfig
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  config ASYNC_CORE
> -	tristate
> +	tristate "Async tx core (DEPRECATED)"

If possible we should just remove async_tx entirely
(https://lore.kernel.org/linux-crypto/20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com/)
as your other series does.  Adding the prompt here actually does the
opposite of deprecating it: it starts asking people to unnecessarily
enable it, while doing nothing to make it easier to disable.

- Eric
