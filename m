Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575135;
	b=wFNOcGez/t/X8nzFNSTjjNj3tMX4UCjGpVLfmQZXp0BbWTlA3Fd3kZCWeJizOu4UswN/
	 QuGPyG0yYBY/bRrx+Kgaaa3iRV93X0ME9q5bMIdxlGUSkaiwbi9UB2atGecwqnOxLq4/7
	 pb8xvhC4UI7qYk47QFawtyIIkngOu5FomUhkpxbjojj9Ugm/QSC4ANqnx5+UDWwpxKEz5
	 YGeeN+PbAlRw+6TFBlG9syZF9EYeGjY4lHbMtLN3EONLC8GH34VTdT4TQ2zkRnQ6fVDCh
	 WH0xjwtSCEbAvhjCNtIQL02oyWbELtdurJBc1CTVlyHyz1deJZ+jHtPOV+0/JFDcpvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575135;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=4cmFUMcPAMvcv/oWl7bACmLFpt/PFZRCaHhzhd0+rMs=;
	b=yu/w3QqolbELhxonSxASefJGFmp9ohpvm7g1u4DlfYtbdmUQP67Lv3Kg0WJncTR8HruJ
	 g/uk36WwINHv9a2rSD4I0hYMlQCz6J0w3fnb++MSS2WxMF2IOb1Tmw9+ZsYS0yG54IKwj
	 2PQW404T6YECEXE2y/1yRPhcEoXNDLeD9D6E+hdtgVTQZ7mSNTBbmDJiUIYwgqt6De3Em
	 gNlMtWNStJUIwYXl8zj2bOhj3j5aL5b0keYFWOdk56EJoM27Q57OopMVfMR658s6pD2rc
	 f7dQQ+yKagojjF5XmMjTM+4ZUxcmpnUMZwKt04WRvUtK1v99kj08XYpUSATLmlQ112w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WETKN16L;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8EA606A32D;
	Fri, 13 Nov 2026 13:05:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC8EA606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WETKN16L
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4cmFUMcPAMvcv/oWl7bACmLFpt/PFZRCaHhzhd0+rMs=; 
	b=WETKN16LBGZKxHYigk0fqsdX8r8k4hW2X5DYm2W5PUhET19Sgk5kzPlUeRz4uXFXCtsU35z+Jly
	jVRsrlgSRZ0oijj+o3nQFx5DnDk2ZmCiCmSm+knTJK33sFMKn6eKysEB2y8FyLhNbOiABBaXH9656
	8SFFcg5ZIrRCq6NhwKmcj77N8etIotXiQQTNGdKqu/ogHVQcBy9TRXRnYNv+svQlBvSAH8xee18jp
	M9vXgZSwV6wCG+76BFz73QZ0TtkUc95Fmr/r8fePEi7xK+zGtyqZX4Z4Tf0bKLSwd797tOvtaOQSp
	2dI+0h68jgNHnpxujaf1Mw5grmw3uaVVVQMg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqy7-0000000EfGg-34d2;
	Fri, 13 Nov 2026 21:05:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:05:27 +0800
Date: Fri, 13 Nov 2026 21:05:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: clabbe@baylibre.com, davem@davemloft.net, linusw@kernel.org,
	kaloz@kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ixp4xx - Free the fallback cipher if context
 initialization fails
Message-ID: <avcLF6uiIj-r9AVq@gondor.apana.org.au>
References: <20261103062942.1021598-1-vulab@iscas.ac.cn>
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
In-Reply-To: <20261103062942.1021598-1-vulab@iscas.ac.cn>

On Tue, Nov 03, 2026 at 06:29:42AM +0000, Wentao Liang wrote:
> init_tfm_ablk() allocates a fallback skcipher before calling init_tfm().
> If allocating either security association context fails, init_tfm()
> returns an error and the fallback is left allocated. The crypto core
> does not call the algorithm exit callback after a failed initialization,
> so exit_tfm_ablk() cannot release it.
> 
> Free the fallback cipher when init_tfm() fails. The security association
> contexts are already unwound by init_tfm().
> 
> Fixes: dfb098d692ea ("crypto: ixp4xx - fallback when having more than one SG")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
