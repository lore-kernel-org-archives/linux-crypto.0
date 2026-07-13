Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E8A33F598;
	Mon, 13 Jul 2026 02:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783911475; cv=none; b=kdO0dm0ga6ouX1MTSPcbfU5qUNtxriVULXO6Rls71W7yMd6fmUTtHz1WUVJB24eUvPwMxgGIQKymW2kGHJqOpHvd3tH3scp/mMH7vJwffP+VUpNHuDafnwRnB3I7HUWDDIV2MktaV7O+OpeIWpBWqrnHLKa5mC0rQnKnZxVIvsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783911475; c=relaxed/simple;
	bh=1j1ktiudgVP+BmyH45G9e/PokfKl4lKPJgW30o5nsno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8twoO98p6MDHOwg3HoFFoi+L/AKUyTz/7DtQblDZHbFkjPJBtBqZ16qDuppqTIQSx3CFKbmbFomUdziIoboIv+8X0nAU7rpjqXRJMxLFye02DF4W9XQ9FbtT40w6kG4KF+tzd8pydmDkOQn0qVO3ay0xeFMKefJEbRdsiopVZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cG28i22f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cG28i22f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E390A1F000E9;
	Mon, 13 Jul 2026 02:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783911474;
	bh=/hRnTUulKPiYornA9CIY0YUDODR0Yv2On60iD5z+Ovw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cG28i22fpIZ9ePz2SOq4tK5Q2IBQh5aMchvOUFHUtm57MLqZkzCUNNxakiFVRMQEy
	 20JdUtNB3Sbbm/QamvF99sFUFy3J7LMocPnufg3Yez4nFaLE39ZoB7UeDy0/QOhPqh
	 a9MITHEmltMmi+Hyba5xGV4yNwt8eaAtrGuAEvYACfCPYqZM7gqHTexbjKyCoMHDsa
	 ZMyCtqlYfr7Xxl37jRRgqwzFPu/wzE9gBJ1K6ID4Jms6xpYZBSQ014GSUP3l3DhdHQ
	 n4teOvJqClQgWLxBmKDJcPwv1/63Mw1+9avBygJe+dgmtKJFKOpIQk0bP0JarAemz3
	 RSx0Z07Rr03WA==
Date: Sun, 12 Jul 2026 22:57:52 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: demiobenour@gmail.com
Cc: Russell King <linux@armlinux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Message-ID: <20260713025752.GF4362@quark>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>

On Sun, Jul 12, 2026 at 05:31:31PM -0400, Demi Marie Obenour via B4 Relay wrote:
> From: Demi Marie Obenour <demiobenour@gmail.com>
> 
> This driver is harmful:
> 
> - It is much slower than the CPU [1] [2].
> - It Has a history of bugs [2] [3].
> - It does not have exclusive access to the hardware [4], causing races
>   with the secure world.
> - It register its implementations with too low a cra_priority for them
>   to be actually used [5].
> 
> Therefore, disable it to ensure that nobody builds it into kernels they
> intend to ship.
> 
> In the future, the driver will be used for processing restricted media
> content.  However, the kernel does not currently support this.  Since
> the driver will have future uses, allow building it if COMPILE_TEST is
> enabled.
> 
> [1]: https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel.org/
> [2]: https://lore.kernel.org/r/20250615031807.GA81869@sol/
> [3]: https://lore.kernel.org/r/20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com/
> [4]: https://lore.kernel.org/r/20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com/
> [5]: https://lore.kernel.org/r/20260524204537.GB110177@quark/
> 
> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>

Acked-by: Eric Biggers <ebiggers@kernel.org>

- Eric
