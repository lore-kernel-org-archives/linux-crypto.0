Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794344923;
	b=XDbICQdqo6bDycE2sxAo/J4bFFwPMwxVot/7wMxupTTcZ+SAPbqP2uETZnoEw7l7wUPv
	 WkDq6gzC6eqnkFoZWCxt+HnvHMdbLn1NExSCVqulSAsGcnXiVj37TXMhtyhGsGzZJEt33
	 UScFlucaFBblT0MjGrbyUYaNYrJRmZFbS4vWxITwmTYFTSzF1NX0/mlzeBCGmxH71Mgjz
	 anbOM4gUaJmZi4j+cFV0DqRTXt6grGFZvSlDwzNggrTnX3bHj6ahVFkDhdo8UhSCxIfcW
	 rmRrPM/+iETERBZcpnmq5Bmz36en4SDq2GLPO17786UskMCvFQimyLohWNwIy7LcYUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794344923;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=Wihr2MrF2FO793dTKH7ddHpRfNQ9adLzPWYI0Gv/j84=;
	b=V5oUhhcV43KuLX3R/Ia2/Ktq3k5C6UXQYyi8nAvIwNHh3KGfKtMsP+hO6Ov143AUAjWQ
	 1ZdzHLzP4HajSPaSDA3tRturzm96j31BO80/GMEv8gjk4axjgjC3vMT95eDRxf95oIE+H
	 3zEvRpMTcItRKUrsC1bpzrzrYYWbAiSeR8G6qMxIZFKrYLJL/gNjeu7toUECAx8YVaiy2
	 wpImnjza3xSVlyo6kCcwjgSMIjVdCiwC5MpCdLYTvFd9jEEzbxg/TTEFlin3hS4D+GhWF
	 gK8YqeW1LtK+O+oT08/fkMNYOLUQMnyIz0Ojl7lPjR0+a8rLMJ5PmCyTuoaBl+bH50A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YMVAf3zz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D46606A321;
	Tue, 10 Nov 2026 21:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YMVAf3zz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4EB1F0089F;
	Tue, 10 Nov 2026 21:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344922;
	bh=Wihr2MrF2FO793dTKH7ddHpRfNQ9adLzPWYI0Gv/j84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YMVAf3zzQ0uqmVL+VbTBt+1JwkrNK+Qw1g08kq63UdwgwteUdVwp20F+rr1emd7Vt
	 IvMeVGLIbRV9oE6BEbzcDenCSC3DirWr9GhZJLjENk4g51cUp/DpJzRwygXyzFX6VW
	 1HNSZQaAbAU7dSw9W5Di8cYnz712D2Ae5jk0XTeOguq4TUxW6KnWHGSALSsypJEICZ
	 wtBaRKiKo1RI3Hmk4D8OXQDpRgdrOc9HJwOr+czsitqPSshhWE8TX0MWO5nVrl4RP1
	 SRy2vqLTkcGVCqwTjXDhahGcBbe9vg2BW03u2PtMbhRdo5N50kZW1Spftp6CcNWQbM
	 2gg5qJFmHgYqQ==
Date: Tue, 10 Nov 2026 13:08:40 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto/arm64: sm4 - Drop cpu feature table for PMULL
Message-ID: <20261110210840.GB1907@quark>
References: <20261109161052.890682-2-u.kleine-koenig@baylibre.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261109161052.890682-2-u.kleine-koenig@baylibre.com>

On Mon, Nov 09, 2026 at 05:10:52PM +0100, Uwe Kleine-König wrote:
> The result of having that table is that the sm4-ce-gcm module is
> autoloaded if the CPU supports the PMULL cpu feature. However that
> module is only usefull if there are both SM4 and PMULL. The module is
> already auto-loaded if the CPU has SM4 and calls sm4_ce_gcm_init() then
> which fails without PMULL.
> 
> So dropping the PMULL cpu feature table has the only affect that on
> machines with PMULL but without SM4 the useless module isn't loaded any
> more.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> ---
> Hello,
> 
> PSA: I don't know what these cpu features are and what the sm4-ce-gcm
> module does. I just stumbled over that MODULE_DEVICE_TABLE(cpu, ...) and
> convinced myself by looking at the code about the above analysis. It
> wouldn't be a big surprise to me if I missed something relevant. So
> please apply some distrust before the patch.

I guess this and your other patch look fine, if Herbert wants to apply
them.  Note that we've actually been moving away from having separate
modules for the architecture-optimized crypto code, and when that
happens to this code the MODULE_DEVICE_TABLE will go away anyway.

- Eric
