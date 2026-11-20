Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168180;
	b=25dJnsXu2jtbH4THITUjQ3pLUzpi1CrMUmbVbmUNG0IhRTskZQgRwFiz7IBi2prZQEKW
	 n29zM7Zjslh9maFj9hrcRQMUhT9A+Gme3eQ9QjDQKsoofq5Dpob7D+/xdTPcQzmckkCKQ
	 7gVtbbn8+RgUrKuPDhNzkWvMYWteaPgaiWSom2tdaEx40PDMs5Ww7EJqx+bHHx8XDcTY0
	 MI16g7RPny0eSjgT6p4SSjMIU5khXH+/nn9DPFGLJzjD88afnrac7KJf8t0dle6oNAeCm
	 P6NpZPhkWFIBEdLoP9Qno1H1AaDU58e0FTRX7ODj3u6EuE3K3aXI68hoqOC/RRegP1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168180;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=7fW/RGjQm4R4BPeAeI/WGaYGJTPLFeO245z4nfgEOkA=;
	b=5r6InFSQwfCGcJTBN8satgh008if9IG36XfnvJUCL33zTKFRYPMEm1gmdiypf6pmTXRs
	 0hDWlmeRj5dI6BXS1KBGhnu4C1ZKhe8j5RhdmNhHrKGbQxV3EnKPCxLZ16FOTjhNQYsmH
	 17Pm684yqo91exgTgk0ZNx9CavX5nWSa7f/j8TuKx9K9qmOICjeN16KKNEsnkyPqBbl6c
	 3XuQVJw8w5K83jRnEnheKW527/hBnHMD3Vn+NYtXP4GuMKJInyu4q5H7R0aDONCFvsLFN
	 zDj0umWdZnlD6GLiWZpbdNBa0Y8TPNOTcjyTbQfyEun7DusWsDnSJYIJxch9prBzmdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=QWd9mMI4;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B3F606A325;
	Fri, 20 Nov 2026 09:49:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88B3F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=QWd9mMI4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7fW/RGjQm4R4BPeAeI/WGaYGJTPLFeO245z4nfgEOkA=; 
	b=QWd9mMI4wFHQM2SDoqfoube/8Ipx2BgCY+vi7XA3UBrXpuNV9AcKnl+a57nW9w1tAF/el8f5Hc/
	XnwM57SWVte1l3s0mlKkEeTqrctUI7zKX2UfHurhoKQ+1B4uCF02uxQ9NRv7pXAiugYtbAFW825nJ
	mUlrA7zr+Z6a5htYZLCK4SSs2NnPMc63V1ZJfE9y+NcCmAZpq7VjPX3Hknbx6/8K9SOg+AeH0oYJK
	XiUq6Y7ghmC3OcV6/6dCBjibENXh0DGgDr4ApjkQlBFh/ibHde1FIoCYGidWEhhVoYcyUEEx9a3hS
	co6/NNp6irf2GlyXNJVN6lWyd4ipK6/cebxw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULFO-0000000HYXA-01uX;
	Fri, 20 Nov 2026 17:49:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:49:34 +0800
Date: Fri, 20 Nov 2026 17:49:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto/arm64: sm4 - Drop cpu feature table for PMULL
Message-ID: <awAXrhYQ-DD3dTl_@gondor.apana.org.au>
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
> 
> Best regards
> Uwe
> 
>  arch/arm64/crypto/sm4-ce-gcm-glue.c | 6 ------
>  1 file changed, 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
