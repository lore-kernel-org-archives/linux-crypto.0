Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575543;
	b=YerH6BV0tokI6rX4KzhDiPcOM8EOxrpw3PIL1cEYrTer2k3Kr+k8KMZhD82Z2DrOvi3y
	 QnxZsw5w872QZb5KidSBR8mBU8I8n8906pQiXIt5AlzG/3fE84Ij3RWVn5Y/jn7aYSG8t
	 pBugx+6UkIb6WmlX+ORL01RveMyohUOGy/XBh0LTgJe0gPea26UGbYPhM2QfA1Gp423t3
	 dNnflAQiS7wfs5fAiI4i2D9ytY9PB9WWbw6LoAJJJr1PCD2Vt/18OChNt4V5RqsOw2oMo
	 Cc6IH5p5wxiugWc5NvJIB8LzIjwhskk6NXevLwmymGIgtl7IrRhv8DG0Tp4jjhmWd5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575543;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=BEAe5s9SBOdqODPn2arcQPFCRRyq9enYmZjtSCRz1Oo=;
	b=M7PZuUgkWIzSuLWq1IkNe5BltOxDGkgWGNgDLXccbzBNxXZSYgAlYF/JyRobJnFKjrpM
	 V/+JCaHHd9y4Dg0zNYR3jOFHPzvChiGW7CtgJcfc6/v82Lgj58Wso2QTsfs15yQ0s22hC
	 u+3/EgjWmmFiZsF7poVWCOC2C/miaWEw48TSKCGBI/KZO4Gk56/rm14vOTGzNhBowCAHJ
	 b8In/JIUEFYNQcAVRA8xwrLcLaotP1g1sxtnkPbU6gE6eKUswEXmIKdkxj8ekkudcNq7W
	 sBuxaIzGP55uGGae/bagoSn9cyHKCXV601DEu9y5X8NHzJa7JQ/IK+7grfcYKd+1sSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=G5KCHl4X;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73CD606A327;
	Fri, 13 Nov 2026 13:12:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E73CD606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=G5KCHl4X
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BEAe5s9SBOdqODPn2arcQPFCRRyq9enYmZjtSCRz1Oo=; 
	b=G5KCHl4X9JAYLXV+UR6WMuWOvyn2xn45bCaN/Sczi6/HCfzAPGf+LEwbhyTw1wyz44VkWp6HB3Y
	eQyd/2xFDPGw+Fo4a/L0KR+qgenHox9IWCyVR9zkPdW9KW3wq8RgsMvN46nD7bHPSk7Utix2EGwhd
	hUAfS3kwnV5ZHJmbm/WyhwBhvUZUWLMJh82T0351KpvIk/P4YIGA636bNtXc+CnUPeX0rTgeghKOe
	xnUV9B6JQr2omfNnfw2vCpnZKAISgIAhm7GhfWsZl1WbUyD6Yj7Ah5hbRjRa5wc0Dkb40KC64A+F8
	nO7dxAMafwt8YAz4/lL0J0GZpgIHoIgvGkEA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRr4l-0000000EfRb-2DAK;
	Fri, 13 Nov 2026 21:12:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:12:19 +0800
Date: Fri, 13 Nov 2026 21:12:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: ayush.sawal@chelsio.com, harsh@chelsio.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: chelsio - Fix wrcount leak in AES encrypt and
 decrypt
Message-ID: <avcMsxrji3DeptQY@gondor.apana.org.au>
References: <20260916092359.2001753-1-vulab@iscas.ac.cn>
 <arNk6ujyrvTsFBfS@gondor.apana.org.au>
 <179395069486.2116632.4190811765560584696@iscas.ac.cn>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179395069486.2116632.4190811765560584696@iscas.ac.cn>

On Fri, Nov 06, 2026 at 07:38:14AM -0000, Wentao Liang wrote:
> chcr_aes_encrypt() and chcr_aes_decrypt() increment the device inflight
> count with chcr_inc_wrcount() before building the work request, but both
> can return early without dropping the count.
> 
> chcr_aes_encrypt() leaks the count when process_cipher() fails or
> returns no skb. chcr_aes_decrypt() leaks it when the tx queue is full or
> when process_cipher() fails and returns no skb. No completion can
> balance those increments, so every failed request permanently skews the
> count and eventually blocks the device from being detached, with the
> detach worker warning "CHCR:request Still Pending".
> 
> chcr_aes_encrypt() already has an error label that calls
> chcr_dec_wrcount(), so jump to it on the remaining failure path. Add the
> same label to chcr_aes_decrypt() and jump to it from both of its failure
> paths, mirroring the encrypt side.
> 
> Fixes: fef4912b66d6 ("crypto: chelsio - Handle PCI shutdown event")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
> Changes in v2:
> - Fix chcr_aes_encrypt() and chcr_aes_decrypt() in a single patch, as
>   requested. Sorry for the late reply.
> - Link to v1: https://lore.kernel.org/all/20260916092527.2002187-1-vulab@iscas.ac.cn/
>   https://lore.kernel.org/all/20260916092359.2001753-1-vulab@iscas.ac.cn/
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
