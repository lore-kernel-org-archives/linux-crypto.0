Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CFD84FD6;
	Wed, 12 Jun 2024 21:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718228467; cv=none; b=ttWhKLp3BXd35zF5sV9EKypfDWBdPU3evsK0zn6tJSWct9XMeCWfhjKZZ3Ya8Y0A0FxSSTojg34NGEtEITE2WY8jt+miL70Gw6CYvDPPvhjRoI0LMM2JZvGmhxm2qiqGXUD/ej1384JUdjqIJ7QE6dlavVxq1UYbqx0rA70lXHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718228467; c=relaxed/simple;
	bh=ziYzFLawczmHhgIWSrqFxQLHUdUZWpR/vS18tblY604=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cVKXr/OzrtkagGuXXFoyNIgA17+jkr2+IFPD0fNWvoC9099bRrkMsJug0fgF0eLXkY4E4sCGcWa8yTpwKCCmF1lF6VBKISRhAwY6liOV6GbflHjfg4+wrqpxvQ+Xu2vU5G/Ibx1ffNc3PEG2dziXUkAq3BiAK73nzH5fdpqpzEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=hUOX1iOH; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="hUOX1iOH"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 6BBE845E2C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1718228465; bh=qIc356MqW+8GvLC3z6w6lKJewxejf1SBuJ5raswiJNk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=hUOX1iOHRgjtb2Al4eoDjrXBk8jheHUTSOe0XcRV4PQozwJAJfhTVtwOHuv0u803c
	 n4aCxxAAd4XyGfkueM5FNjKlJxpt1vsInQhqkMeeDcaR4St3WvNIdU340VMkEFdVP4
	 FP03i0wvLI4x3xMfMACDYHlY4I0F3gHek8upcxi10MX4m3rySdFHnxpnx/BmnPGaNF
	 RvbRxi27E9fQuWzWzmEXzlLfEzpx0+8GkEtR9dL7o1zc1kR+p6e2AvtqWj0t40vVNt
	 XaKn06Z8hbfbXiCcJkcMaU+LkBHgDDPtjNiurP4wi0GT1zxupGJ3l+7ZmdQIrUKcQp
	 mpzxjSXy/qNOQ==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 6BBE845E2C;
	Wed, 12 Jun 2024 21:41:05 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>, Dan Williams
 <dan.j.williams@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Andre Noll <maan@systemlinux.org>
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel@pengutronix.de, Ahmad Fatoum
 <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v2] docs: crypto: async-tx-api: fix broken code example
In-Reply-To: <20240529-async-dma-docs-v2-1-8faf87e72e6d@pengutronix.de>
References: <20240529-async-dma-docs-v2-1-8faf87e72e6d@pengutronix.de>
Date: Wed, 12 Jun 2024 15:41:04 -0600
Message-ID: <87cyolon4f.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ahmad Fatoum <a.fatoum@pengutronix.de> writes:

> The code example fails to compile:
>
>   1) addr_conv is defined twice, once as a VLA, which have been phased out
>
>   2) submit is not a pointer, but is still dereferenced with ->
>
>   3) The first call to async_xor() lacked the trailing semicolon
>
> Fix these issues and while at it, fix some code style nitpicks as well:
>
>   1) make the functions static as users are unlikely to export them
>
>   2) include the relevant header
>
>   3) Shorten the example a bit by removing a redundant variable
>      definition
>
> Fixes: 04ce9ab385dc ("async_xor: permit callers to pass in a 'dma/page scribble' region")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

It looks like nobody has picked this up, so I've applied it.

Thanks,

jon
