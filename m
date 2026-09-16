Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9237B37F33C;
	Wed, 16 Sep 2026 12:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563166; cv=none; b=a3nksCUSoOIK/poNB+9gTpWUFIem3xB4OalbyO4nLFoBDd6ugG+w6l2IFJZ6Ltu/sEsGBuXH+bZnUsXAeB4pQ6Z4QLoTnWj/ajvAYqWAohCPjrRD4bL2c0L3O9pi2oYzbsQgNKuJa0+Xh6EaXAFGW3FC2F3aW3HQFdfdd18U1Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563166; c=relaxed/simple;
	bh=Jq9vttnO9xO2Jk0JiUgS/XjP00ZkvddAObklyRw0QI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUqaMdKtggO4HgtXNzvvqhgfFrBNyTzYbJ++dnCW/bjmNLCtLeA6FuJzZDiXsFmDMOmIMASGGH99PEnMOhFNWCsd8LUcBCs7HK8QQ9jqnRdRM2pQWXHvt3FWQOLgAcgiGl3uw9W616CTRxxfiB6wXW1xsrgIsnl6zMZhnNbdhG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LE0u9hq7; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LE0u9hq7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GsoRHD8aMQ2FeGGWT4vMQiPcLcCsPohhSBsh5dfsoR8=; 
	b=LE0u9hq7xq92TCZFjhSploUls9vq66y9yxFfK53u964GTDRy+KhuMu/k8p/a56krkiZ2t7HRxlg
	OjMnndUbyuM+dLQ8LSEM4JanmRfc3LwsE+0WaYSpVU/NgrFXYnhwnWSOFQWAGy2caN7drtnkjejhe
	lipA3I8mSTSg8VjluPlpWcMSDhrJpJx3o/LGQz/TVq98nwqAm2XoPuWcZTS/+Ee/YCZ+PNrgDMLls
	j45fGqJ7NyWrPdl/LG8kwoGHmrvXapj/K1p9QwFp+kYEbhbty46TnuRlMIw7SMix3yXJ3TMyj5188
	zkbfEqyeb/27UXBdZLhK3FEj/Wz/uzUXbNDw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6p7k-0000000EcWS-3aNJ;
	Wed, 16 Sep 2026 20:52:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 22:52:28 +1000
Date: Wed, 16 Sep 2026 22:52:28 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel-tdes - sync output bounce buffer before
 DMA
Message-ID: <aqqRDIBn_joIAnIM@gondor.apana.org.au>
References: <20260902192323.29337-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902192323.29337-1-kmehltretter@gmail.com>

On Wed, Sep 02, 2026 at 09:23:23PM +0200, Karl Mehltretter wrote:
> The slow path maps its output bounce buffer once at probe time with
> dma_map_single() and DMA_FROM_DEVICE, then reuses the mapping for every
> request.  After the CPU copies a result from the buffer,
> dma_sync_single_for_device() must hand the buffer back to the device before
> the next DMA transfer.  The driver omits this call, so cache lines from the
> previous result can remain valid while the device writes the next one.
> 
> This bug was masked by the completion paths calling
> dma_sync_single_for_device() immediately before the CPU copied the output,
> where dma_sync_single_for_cpu() was required.  For DMA_FROM_DEVICE on
> ARM926, dma_sync_single_for_device() invokes arm926_dma_map_area(), which
> invalidates the cache lines.  The misplaced call therefore discarded the
> stale lines before every copy-out.
> 
> Commit c8a9a647532f ("crypto: atmel-tdes - fix DMA sync direction")
> correctly changed the completion paths to call dma_sync_single_for_cpu().
> On ARM926, that function invokes arm926_dma_unmap_area(), which is a no-op.
> The missing pre-DMA dma_sync_single_for_device() was therefore exposed on
> ARM926-based SAM9X60 and SAM9X7 SoCs.
> 
> With CONFIG_CRYPTO_SELFTESTS=y all four DES/TDES algorithms fail on
> SAM9X75:
> 
>   alg: skcipher: atmel-ecb-tdes encryption test failed (wrong result) on
>   test vector 2, cfg="unaligned buffer, offset=1"
> 
> Call dma_sync_single_for_device() for the output buffer before starting DMA
> in both atmel_tdes_crypt_pdc() and atmel_tdes_crypt_dma().
> 
> Fixes: c8a9a647532f ("crypto: atmel-tdes - fix DMA sync direction")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> Changes in v2:
> - Reword the changelog and use full function names. No code changes.
>   (Thorsten)
> 
> Link to v1:
>   https://lore.kernel.org/r/20260829045316.92931-1-kmehltretter@gmail.com/
> 
> Tested on top of:
> 
>   crypto: atmel-tdes - zero-initialize device state
>   https://lore.kernel.org/r/20260829035821.67220-1-kmehltretter@gmail.com/
> 
> Without that fix, on the tested SAM9X75 the DES/TDES self-tests hang on
> their first requests before reaching this test vector, so the failure
> fixed here is not observable on an otherwise unpatched tree.
> 
> The two patches are independent and apply in either order.
> 
>  drivers/crypto/atmel-tdes.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
