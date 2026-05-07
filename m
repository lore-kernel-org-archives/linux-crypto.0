Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E76F3BE145
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778165409; cv=none; b=ex5gNBnyBfxcf9fU3npY6V8vaUPTh1md9wKPCeFKzr5NdEEzmi3K30ZlPomaQqZ8T6Z20fG9c3RFEvLX2WyTgxpqlX7e2l4C0+Vo6mTA5o79Gr76yT4F2n8YLt5MDsmzZfck55YSIB6vY2rQKSO8tcaTR+mUNTMHELAh2I1hYMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778165409; c=relaxed/simple;
	bh=wdi4qtiEctfoiQNuVz+U8eHaMc662FosLCEsmsjfrHE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bHW2DPQjrgkKPE5YvpWRQYtUGz2a0TyIbv8n0NWX9l7PdlKzJeKor2tx2W6Pcj/3rXxOrrmAAVGA/VkVmGFoVap8cfh1dJOUQL+JecSUYCa+cR3mnpXkxkOx14uCFt+Rje5ZLBSwrPZqmemDG7kAUzw+KTdeXj0QNR6JHdp5SOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qNvqkC8x; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qNvqkC8x"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488ad135063so9008885e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 07 May 2026 07:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778165407; x=1778770207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fyk8eDbl85Hd7XiZtHIzqBxAFI/hqUpEHNnD2/TC2s0=;
        b=qNvqkC8xDFXnGCMT2tPOpIREvMk+O/7oCxsAAocQ3WaZCzbRDbUTwypXkINy9mTtO/
         7LDncDHZpdRFIR9GwgvDKfu7fSS9K1c22wEExbJYovTyIsMBUwfQ3wUJFn2v5RVXGM+I
         eY4wJ2JX3FrJ2yw1G8TzHZ3TznTxECrMrsFE5IetJnHKrB0N1JPCxzAM792VHLctgrLW
         5f6HBucjdBsp+noydhJ2v2iw6Ebwqnx7jiJ/WDk1bKgnv5o9jroea7umpCBI8ldyeC0f
         rbiofezDJJ0Yc6eEw0UsCXg5MGfcdJZhbMO1LlAShX4eiFEYrF9isqDT23HxzBMsE5fz
         T7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778165407; x=1778770207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fyk8eDbl85Hd7XiZtHIzqBxAFI/hqUpEHNnD2/TC2s0=;
        b=UfTZKeLQ3C/U5QLhjuuLfj+pObbmVETb3XM83BD6aBeeNd/QB1k8MzF2vb37t5bnHq
         /Q/oPBotLDGecpLht9Vb5RrSPFSuqX6Li4CxPpLa/ghfLNapzPWSM1Kyh34RX9G+jEOo
         KieZd+ZNgdKln1dnOu4AV3iU7PgE00qRHscrIa/te0AAQ8/Appl52BSamTalS63zsGbX
         dBKIni79zodTn06DYjcFcVKubMglOM8u3AcpI/MHH3CCelBz6yxqMKrJcTMoUqQQurFn
         UaT3MGOBR47rYVxggAK/9zPYSnk7w2zbacaaFr5cfxd9Z4QxZBZ14yWK86FqZtvFMLic
         TBuw==
X-Forwarded-Encrypted: i=1; AFNElJ//Q07pKXbfUv51vaRc0aoJBUrr2Yf0vEJg8TgYZPcIlPDG33sK46HEefSUPYGgTlL2g+bgaYqHNULNoGU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFR8nemTnH1QjV4e6hQH2qhxMPFHt7aj+3v+o359jJG2dMNVJs
	BCTLN5jPHb63BktmoHTyTtqggG5MqwDEnCpiNezHawH3GYAVVCofeMty
X-Gm-Gg: AeBDieuo4v+T0GW2Ai72ejaNXBINQAPd7QrEOlZVP5ayekJSL2LmyUpj1ZPfsqir2HK
	t1+nroTAEbXdJofmVBPMfLxs2Ng1j4pfJ1tLgvr90Rd2Qc5Ov//2z56n0XxQKP54/BqKHh56aHm
	QeguPMUKC9wTdZtO3mWudwHTjT4sLT1PhLakXFg28PrUZ3Ck555zbRQdbGjLTMEgGufXkz4k1tH
	0PN7HvglPsZondm1OOipJrf+mLSdiYM3S9rWH17kBnEKcJe+vAvwXTerndWWFfwhXU0rGUCBbeo
	TZVmdBJCVCpNG1ekOsvZbzYa66i0IMAtZ/RDJrByrOF5lVzOvJI4afPkfb5cwV6IY2dLf4WKmbP
	t1ILj+SWzHeLV+1UW5/7QH+Af9pTi31Ed9iO6tf34V5S0PfWocT6fLjZ76PdE9FbGtRseCCx2NP
	Yc00EKA7QDwLpmXIYinXMGZrzdBefQ7kAFpqphTtbrXjEAeqLuXc3+CwxSvD93btgu2IulWIiy8
	FJCxto77twLDA==
X-Received: by 2002:a05:600c:8012:b0:48e:5fb8:f80f with SMTP id 5b1f17b1804b1-48e5fb8fac9mr40003765e9.24.1778165406496;
        Thu, 07 May 2026 07:50:06 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e53895effsm125874225e9.3.2026.05.07.07.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 07:50:06 -0700 (PDT)
Date: Thu, 7 May 2026 15:50:04 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, Nicolas Ferre <nicolas.ferre@microchip.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea
 <claudiu.beznea@tuxon.dev>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - replace min_t with min
Message-ID: <20260507155004.4d537703@pumpkin>
In-Reply-To: <20260507135525.331107-3-thorsten.blum@linux.dev>
References: <20260507135525.331107-3-thorsten.blum@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  7 May 2026 15:55:27 +0200
Thorsten Blum <thorsten.blum@linux.dev> wrote:

> Use the simpler min() macro since the values are all unsigned and
> compatible.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

I'm all for nuking min_t(), so:

Reviewed-by: David Laight <david.laght.linux@gmail.com>

> ---
>  drivers/crypto/atmel-ecc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> index b6a77c8d439c..2cf53f0b6742 100644
> --- a/drivers/crypto/atmel-ecc.c
> +++ b/drivers/crypto/atmel-ecc.c
> @@ -56,7 +56,7 @@ static void atmel_ecdh_done(struct atmel_i2c_work_data *work_data, void *areq,
>  		goto free_work_data;
>  
>  	/* might want less than we've got */
> -	n_sz = min_t(size_t, ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);
> +	n_sz = min(ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);

Not entirely related, but (to me) the arguments are in the wrong order.

>  
>  	/* copy the shared secret */
>  	copied = sg_copy_from_buffer(req->dst, sg_nents_for_len(req->dst, n_sz),
> @@ -150,7 +150,7 @@ static int atmel_ecdh_generate_public_key(struct kpp_request *req)
>  		return -EINVAL;
>  
>  	/* might want less than we've got */
> -	nbytes = min_t(size_t, ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
> +	nbytes = min(ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
>  
>  	/* public key was saved at private key generation */
>  	copied = sg_copy_from_buffer(req->dst,
> 

