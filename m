Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B594649AA44;
	Mon, 28 Sep 2026 22:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790635306; cv=none; b=B6eYkKlFnFi3CCnXqOZJOQ+ocEghx5OBwdTSzDBiWykBVelV6M1ncVUU1vmCjYeKJYvEeVualFF0DVrU53XRjrTErmEPJIfGaQCC+rGlzdlwurjDsZoixKq6R8yYyYruHiXek7KOG6sTv47nv02lpPWtg0R6Mr20L59DIApKysI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790635306; c=relaxed/simple;
	bh=b45Z3ZboJOsUP2WV2BRfGrK5MtMLYnngMngDInlHtp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8MVkOQPjPhvzvuOyZ4jRKCrnrqQdPmwXAp+UhrnO4TmIsluuFR9ekKS11PBaPpL2M1kK+dmw2tRF3B3W1NLrkJJqkfqMqfQBvcg6x5JF0l6VrbQeNYsx/tXf4H85W8TvF3pSDsC144BrTc+oiZQvfj346LKfE2ly61hIR8obyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XHHvMFNb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XHHvMFNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80E41F000FF;
	Mon, 28 Sep 2026 22:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790635305;
	bh=CJC+wU3aeJ04GaWymNLWVJ7XwS479N36ElyR50vrvb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XHHvMFNbyVr9h0mcR1QwN55Ys4QozdWE6xrESNGa48IKkmWiLlBGmm+irAz6d1vPr
	 +s1fGRCyJndkfYSYjhTIMuTlsLR59xMzsddEmmskwRHdejFPXV8hIZ2YJ83dXCNvPI
	 IqOKYkoz7nuEvocwKYvJIfNmGazWXRx4UYLOwyRI2hbOlYTq6+hsSnIXskN3dyFxfl
	 ruxwxUaUg1H4q+n1oFj7voagPATOW5xUYlN/kTqFbP26DWa3rdrYm7dtfzMDNNFqA7
	 5FSFKhA2WLhxm1n4c5752vuzQX7XtoelCRK2vlLXGwTyYbUV/YAoQm6aSpNa6Sbj1q
	 KNDEPi41XUDkA==
Date: Mon, 28 Sep 2026 22:41:43 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: vjardin@free.fr
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: caam/qi2 - algorithm priority configurable
Message-ID: <20260928224143.GA21235@google.com>
References: <20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr>

On Mon, Sep 28, 2026 at 04:01:02PM +0200, Vincent Jardin via B4 Relay wrote:
> dpaa2_caam registers its skcipher, aead and ahash algorithms at a fixed
> priority above the ARMv8 Crypto Extensions, so on DPAA2 SoCs
> every in-kernel consumers of AES, SHA or GCM use the SEC.
> 
> Patch 1 adds dpaa2_caam.priority module parameter
> Patch 2 doc fsl,qi2-crypto-priority property on the SEC node
> Patch 3 reads it at probe, the module parameter takes precedence
> 
> Signed-off-by: Vincent Jardin <vjardin@free.fr>

Is there *any* real-world use case in which these caamalg_qi2.c
algorithms are worth using?  This looks like another one of those
problematic drivers pushed by the hardware vendor as a checkbox feature.
Just doing the crypto on the CPU is almost always much faster and more
reliable.

As shown by your other patch
(https://lore.kernel.org/linux-crypto/20260928-for-upstream-caam-qi-plain-keylen-v1-1-6edb56649cf9@free.fr/)
it also seems that this driver has been critically broken for the last
year, with it being unable to set keys.  Evidently, no one has tested or
used it in the last year until now.

It also has the usual anti-patterns like supporting MD5 and DES.

I really don't see the point.  Why do people put themselves through
these issues at all?  It seems this functionality should just be
disabled everywhere, without putting policy in the device tree which as
has been noted many times isn't the right place for it.

- Eric
