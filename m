Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9374B5413;
	Thu,  3 Sep 2026 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788445384; cv=none; b=DGCvPW8IdMC1D1BY3a9mp0MGy05vCGzYT2qEpj76mmPm05BXkG0QAjXHoFWXToBh6Rrc4qscWC9j9vj++mmXh5KAd4jDR+nVabomQ7Jn+LraXRzmBELfl31vVYGDACmXIR+36A2Q0OfLJCTY2hIakgl1HzYUqOWtEyIPsxB5C/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788445384; c=relaxed/simple;
	bh=qURY06nLEmoQKqQ6pj/Oes9/2ar+r/f01DShS+6IwWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ed72GHNfP5CbY2z+GLfkB3rNpBRgsn/s0S18/M8hgRvlTksL0hAyZYO/Zv5mgRHG2KkbTMz9gTSQ26CNWLJaujBDEcZnCulUEGNW7iOwSqV1tyEJPq0WwPUKBVnEOBjyH12BSRLkM/3QznWb2C3Y32YNqEN74XLNRUAzUZs7pY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIhg8xkn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIhg8xkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FAE1F00A3A;
	Thu,  3 Sep 2026 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788445364;
	bh=TBU02k+XzoPdmqydAHzpAb3ZuayNpJVBxKlMr3WuRYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cIhg8xkn3Mywk8kIj3Ub4wIHzfHVb0eF7oGn4PLX8QhuU52NQkoZAHtYCD5zi6GWn
	 btEGAIIDNx5ByqjIvykDRg6/GwjX5iwaOffsQ2JI2tjS+dIP+JALtqUlJMK98FL6dS
	 PSN88Dh4X0ODr4IknsHJUF70cbjZC4TLBcVDFcRRK4XBBWJA7eolNdjSFjeimr7GBN
	 oicWSWBy1UioLwk8QpUnTjbB2IJ+OXDBZoaZ5X204/SSfz//A+LGJINrmYVLNuTCQD
	 pX0YmGuIk5i+jZZkL4B3hV2er8APlTcPt2H4k4pe4Xx8LcBD6oSKRNaWFVF52eerS7
	 jEZ/WKgKGudwg==
Date: Thu, 3 Sep 2026 16:22:38 +0200
From: Thorsten Blum <blum@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel-tdes - sync output bounce buffer before
 DMA
Message-ID: <apmCrvihjaMSr_Dd@kernel.org>
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

LGTM, thanks.

Reviewed-by: Thorsten Blum <blum@kernel.org>
