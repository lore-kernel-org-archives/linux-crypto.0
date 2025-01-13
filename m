Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11AF3A8D0
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jan 2025 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736783474; cv=none; b=axselxz8DLzmcTZc7k+/KijEP2tqmqr4qqBsDI5ByNSDYLrm/WC88ux3z6ejqRlxcJibyAxMVnma426wDC8xqs1pBZSKjZ+Gjpd/HR0Y6OCGMeRc69oBNXeuIGW4q+1eX78t+BEnpWJ/T17zxfDk4mJIb/KQPSM00Jn5d5YgVNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736783474; c=relaxed/simple;
	bh=VqG+knayBXGWHGpYVp5ETWLpXggdoELncTMTP1mFS9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=plPJ0Cu2ofbveowKPirSipr3ImdKLaDSinD71+1olwtbZjhi6ymSX5g16GIMg7oBysQgLzD5ZngZLwtzFvt36U4vAR8n898uW6M7J4Ar/Cb0xGP+cOkYBGNOimBMls8ANSOcujDHvt0F/IymO7v/SafehQNzFViyLxkNkVxvZLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/VutF8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/VutF8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AE9C4CED6;
	Mon, 13 Jan 2025 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736783474;
	bh=VqG+knayBXGWHGpYVp5ETWLpXggdoELncTMTP1mFS9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p/VutF8AVXvSDq1D7tj1Vjrg2cTzEfFC2d7/P42dh4if6UKPH0rtON339JzLiP1yD
	 7GirrzLnLh61UdiZzfLY2qGbOicRG6O4l/9UY+Njyi46s5UmeWtnYBIUsd6n6105wW
	 pH+RPSfEEeyiwzfy5mc/iVH/3MvZD2KaCs2CJD5Rf9oqc0IbzCcvZU7aY3e7pkSUCI
	 AxAQ9kpGvA0cOTRAp2F3RtL4eI4BP8XhhCYPVRabsnJ9bACGhvmoUkPkitRwPJYCSy
	 NO0ciEoNS6UjLQm2SagNme6GocJHV8LMCfHbWUZ7twWuSYAxcYiB6Ft9urzZ1zTl9m
	 7+MVcBa8VtAJQ==
Date: Mon, 13 Jan 2025 08:51:12 -0700
From: Keith Busch <kbusch@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 09/10] nvmet-tcp: support secure channel concatenation
Message-ID: <Z4U2cEhXMkwZeEDm@kbusch-mbp>
References: <20241203110238.128630-1-hare@kernel.org>
 <20241203110238.128630-11-hare@kernel.org>
 <Z36o7IqZnwkuckwF@kbusch-mbp>
 <69208b76-71ac-464f-bdb9-50c9c5558ac6@suse.de>
 <Z4REeAUzXi3z2jeb@kbusch-mbp>
 <f5772112-abdd-4b20-a505-3ce71fe8d7ba@suse.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5772112-abdd-4b20-a505-3ce71fe8d7ba@suse.de>

On Mon, Jan 13, 2025 at 10:34:48AM +0100, Hannes Reinecke wrote:
> On 1/12/25 23:38, Keith Busch wrote:
> diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
> index 486afe598184..10e453b2436e 100644
> --- a/drivers/nvme/host/Kconfig
> +++ b/drivers/nvme/host/Kconfig
> @@ -109,7 +109,7 @@ config NVME_HOST_AUTH
>         bool "NVMe over Fabrics In-Band Authentication in host side"
>         depends on NVME_CORE
>         select NVME_AUTH
> -       select NVME_KEYRING if NVME_TCP_TLS
> +       select NVME_KEYRING
>         help
>           This provides support for NVMe over Fabrics In-Band Authentication in
>           host side.
> 
> 
> which obviously needs to be folded into patch 'nvme-tcp: request
> secure channel concatenation' (the cited patch is a red herring;
> it only exposes the issue, but the issue got introduced with the
> patch to nvme-tcp).
> 
> Can you fold it in or shall I resubmit?

Sure, I can fold it in.

Were you okay with my merge conflict resolution on this patch too?
