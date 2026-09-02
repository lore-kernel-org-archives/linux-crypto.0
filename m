Received: from mta1.migadu.com (out-236.mta1.migadu.com [95.215.58.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D76D4A64D1
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 16:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367999; cv=none; b=C0NYxC+1F8K30GSRq0L9nAZFt/Rv2vgP90Ysi+AogLXWn33PO3EZm1hfo4/JlqUdA+pPVjI3qrqNIc5dwHiBLGGhtKL6xqhu7ywCefLwWC8NqfVFqPrslCo+yRY1ncPFRgb0Qn7so8F4282SWOGpkxVB5Ds7/tRsN5dckpxTk38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367999; c=relaxed/simple;
	bh=iHvZqKrXE7zNfYJuUPYEjllsfLjqNrNtwxd1pFBCEOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GyHGVPnDxIk5IWLE6O3rJ/HyWZg/uZ1fmY4R52paO0AUJeZpXx4wF9TV1uA2AHcS9a9QHD3BA1XfLecEb7UAJe/6PpipyQc04SMsaYtPbv2bo3FMYJ4TUWg6eHUMfFKl1wNkPOJhNXt4cu13vuIaEuKUjHsE4AcWEV2e+qb8wmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U1GrSfFB; arc=none smtp.client-ip=95.215.58.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U1GrSfFB"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iHvZqKrXE7zNfYJuUPYEjllsfLjqNrNtwxd1pFBCEOI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788367995; v=1; x=1788972795;
 b=U1GrSfFBnHdhZ158PJrFBB13z+t//fAG3f9LpCksZwrzOxvjBQHdGG1AgLVzkUAAxxM30GQM
 scWVWwa9L0yooRBLO6FO2azA9U63OBGaXrof38+fHJSjamE+T+rhCTflanUHjq3Vt6c9VMjxDMb
 KF/orzS+kcN3ZFIgy0a5SguU=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 9188a3c33d52887f;
	Wed, 02 Sep 2026 16:53:15 +0000
X-Mizu-Trace-ID: 9188a3c33d52887f
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 18:53:13 +0200
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Pramod Gurav <pramod.gurav@smartplayin.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-tdes - zero-initialize device state
Message-ID: <aphUecsl_R3Jc6og@linux.dev>
References: <20260829035821.67220-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829035821.67220-1-kmehltretter@gmail.com>

On Sat, Aug 29, 2026 at 05:58:21AM +0200, Karl Mehltretter wrote:
> Commit c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of
> kzalloc") accidentally replaced kzalloc() with devm_kmalloc(), so the
> device state is no longer zeroed.
> 
> atmel_tdes_hw_init() tests dd->flags during probe: a stale TDES_FLAGS_INIT
> skips the hardware reset, and a stale TDES_FLAGS_BUSY makes
> atmel_tdes_handle_queue() treat the engine as permanently busy, leaving
> every request queued and never dispatched.
> 
> Seen on a SAM9X75 Curiosity: the first TDES request after boot never
> completes and the TDES interrupt count stays at zero, while the AES and
> SHA engines on the same SoC work normally.
> 
> Switch to devm_kzalloc(), matching the Atmel AES and SHA drivers.
> 
> Fixes: c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of kzalloc")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  drivers/crypto/atmel-tdes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

LGTM, thanks.

Reviewed-by: Thorsten Blum <blum@kernel.org>
