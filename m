Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792990208;
	b=cVauTzDdpZnhjc632+B/2yxxsU/foWquqIa1NrzD9TnogUquW4gHJ6e8QRO1os8RZrq+
	 xic3iblDi16v54hkcdtnmhDOIcCd2SQq3id7/zwSKu/MotaTnva201goos84LHZuOUN7P
	 Q0gAHOIx6vDFNbWJ7zV1QBo30ihVUfHykWGfp1vQuGmsWXQEuSRFXesp/9Cm+mUdeqHx/
	 KKE2cFzJPpKdhD4xl4jnj19FLNZIpj8Ylxuj9aXo9kCFAJIsQY3rD6jrUthCUlIy72PWU
	 4fw+flU7+flRQ4HO/n4n7RL9RU1dY8n+/BtDxiVlyZg6oOgFAkutSpC1c5bpDA71uiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792990208;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Bl2W2vOTxi9wy2cQELmAmGrvk4vUTUbxwbB9TWDhuWs=;
	b=wTXARNkaFiyO8Ty9w4kC6lhNSWqgc2EMaAgt8CiJ9OOf11BAVwNWCeq9Cc169EKuo6KG
	 zIXA4y8cgOLOtNa/oxWeRdZnHmblOhL94Nkhb1eiJdf4KflFVbhe/jyZzl0qsA98kXMpT
	 V0Ben7Mi1JsuIU22pnVrSLjfReZMHpRZBOFJ10opPvsmfadnBUWeJvQw/Cc3EvNIQIsY2
	 JsYYKSUmvpUrCxSJohRR+EZfltWrwjbVctvcntP3qOdKfc1OzmPYGlW1yU0ncLwSS9Ff4
	 H1XojK6Axz8tsjUjsrn+4h8pInMotM7gek4IK/MjaPkw7I7gM80w5GWnz79NVgVn4ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WZ5RDdM8;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CBD606A31A;
	Mon, 26 Oct 2026 04:50:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52CBD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WZ5RDdM8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Bl2W2vOTxi9wy2cQELmAmGrvk4vUTUbxwbB9TWDhuWs=; 
	b=WZ5RDdM8X/Iq1Jt4frZTU7DDQjCgJIJwaPjcNtCQJTc8fqvwQY8VKviPrcNqfsmZZ8/ho/9YM54
	vCVFj+QnbEPpNE8ZHNlaskkMTy7uRuKRUDs82QNtTEc7k2ZZ/Lb1h3aGG3VkJ70+kP0XGrNzwa3P3
	tl3vrp8kc8LYAf+Z1ZxzRdiU/rTjTbZX05/HzlC9Q9EPi+m4NsTeq/C6orzkSsAnR5yHl+1BLnEjE
	rAVckr8io5/TLi9o9RB+8CUckyqWLADdWpmSGqpIUCehojfsN/O+X2CPO35LV382B8Ymeieyc5tvS
	5SFkTXaWcigaEhG2RFq5k3mKEt1T0Qvr69CA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xLCeh-00000007XjN-2kM4;
	Mon, 26 Oct 2026 12:49:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 Oct 2026 12:49:55 +0800
Date: Mon, 26 Oct 2026 12:49:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Myeonghun Pak <mhun512@gmail.com>
Cc: Corentin Labbe <clabbe@baylibre.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ijae Kim <ae878000@gmail.com>,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: Re: [PATCH] crypto: amlogic - Free channel IRQs before disabling the
 clock
Message-ID: <at7b8-V0gl-a3d8T@gondor.apana.org.au>
References: <179203206852.2659709.13834828335447558448.G3@gmail.com>
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
In-Reply-To: <179203206852.2659709.13834828335447558448.G3@gmail.com>

On Wed, Oct 14, 2026 at 10:41:48PM -0400, Myeonghun Pak wrote:
> The channel IRQs are requested before the managed channel array is
> allocated. Automatic cleanup consequently frees that array before
> releasing the IRQs. An interrupt handler that has already read a channel
> completion status can still write chanlist[flow].status and complete the
> channel completion after the array is released. A cipher timeout allows
> such a late handler even after its crypto engine becomes idle.
> 
> Release the IRQs explicitly before disabling the bus clock and before
> devres can release the channel array. Do this after crypto_engine_exit()
> so normal requests retain their interrupt-driven completion while the
> engines drain. Use the same cleanup on probe failures after the clock
> has been enabled, preserving the channel allocator's existing unwind.
> 
> This issue was identified as part of our ongoing research while
> reviewing kernel code.
> 
> Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
> Assisted-by: LLM
> Co-developed-by: Ijae Kim <ae878000@gmail.com>
> Signed-off-by: Ijae Kim <ae878000@gmail.com>
> Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
> ---
> Compile-tested with GCC, W=1 (arm). No runtime testing.
> 
> This bounds IRQ access to completion state and registers; hardware DMA
> handling after a cipher timeout is unchanged.
> 
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)

The patch description does not apply to the current cryptodev tree.
Please review this change:

commit e273759a0e29395a6e35e5f17ce03b2690476b2c
Author: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Date:   Wed Sep 16 23:12:27 2026 +0530

    crypto: amlogic - Use devm APIs for clock management

    The driver currently gets the core clock and manually enables it using
    clk_prepare_enable(). This requires matching calls to
    clk_disable_unprepare() in the error paths and remove function.

    Switch to devm_clk_get_enabled() instead. This lets the kernel handle
    enabling and disabling the clock automatically, which allow us to drop
    the manual cleanup code and keeps the probe function simple.

    Reported-by: kernel test robot <lkp@intel.com>
    Closes: https://lore.kernel.org/oe-kbuild-all/202608310329.QgxCCMs1-lkp@intel.com/
    Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
