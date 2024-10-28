Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51501917FF
	for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 08:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730105337; cv=none; b=ctOELir1cuc8UdMvrgJ0fAUFm1iI4XNZoDayE8LmgrhruZJ88kwMpVKy0qrIZwqH1lg08ZTDdZqUwNGDwximU0hN+Pz6rSxWfqlALrp0EPPiops+xfq7o/syxgyLQYdR66kNVIy+HrOiIN8XlV5pwkIheWcbjcu0112dLnEkgP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730105337; c=relaxed/simple;
	bh=j2xt+trhQJQXYZaSllPkx3D8Wpc1vrMkDLbDwCWMDOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/DuOYbs36NgtViTVEAdr0nNLeeTCsKlzA6yUBi7BV6qSJ/wgTWW9Oh5A15vK05K/R5McVdtcIscfrvDTMUCXsCjR27gg4Je7uN+ZvsAue6vpnPTb/ZvoKW3hLJ/t3m7yO9vhJOso3RfHZ0spyLtGOgQUGDuYCz1Y7Xk6OT3qfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l3zh0Hr4; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l3zh0Hr4"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37d4ac91d97so3512510f8f.2
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 01:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730105334; x=1730710134; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yH8rSI6GTPme8vkq348HNrx9rwQPSGuC28jjl3dlmxg=;
        b=l3zh0Hr4hplY7Z5GZlCke9s2uQ9f/DPcR6Rl6ZITB7YF7TVmnn0sDCWmHQj56HDCZU
         wXzqDZxcbMNghanFFryfwKrgsQf5NUnOnuCGaiHMN3LYIc01ldoTAZjwJ69ZsXoEOzbX
         TIfBWmu6uNKgm5NVa2ah94ZgnG5sSNX45Gl+kzRSGvnxYtTeNLjoeMJHDU5GN3NLkyl9
         EmdKHc6qro4nt9dgYzqGUxzZIz5lNy7ORhB4GISK1+160N1s1ghoccaJPmCgrLQ16RHR
         pqCFEJ9w14B5pa8lP4AKVobXwvAjDatDoZTJJMGmCzFl5J0jXS6Ph5YWzv/Q+QXgFz+1
         e1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730105334; x=1730710134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yH8rSI6GTPme8vkq348HNrx9rwQPSGuC28jjl3dlmxg=;
        b=PQFxL+FkGfgXMIhBo6QL+QFklxx8GObxnLwQcCrRYDvMIlxiXRud/b9PsZlCQv1Qed
         NbrSXoOTLh2sASsUn8yhFnQYWDUJQK+sqaIGAzcJT+9SEs32h1B41CLkxRO3BKKaXx7C
         l6n/ChucTjP1l4J1z0uguQMLJw69ufHgLqx50k5VL6RATLN+t6aMW+IX7TYwll9vUVmr
         TyIyaNkiW1euNtYkORGhLrnOXma4kWnzC2H8e35gLSIf8C0Ktli8zwlWn5uARrx9AceN
         iJmEhRWg9Fu/Bfkl7jYkWE9oOfLp/KhfVepSK3qx6wuXQnJZc3Xu8lRU4ec+9Icvnm+t
         9X3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJ/T/52SEQlYURstPtRDxMOvJFD/DJd4foJ2z5ccBbK+GLq/6wmkU61bY9+xqvxn2nT5J6trMaRwVENzI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd/XezezyaJw86STfKPYRNfOUEaIpYCnF4X/TECK0u9cvamekK
	1ny+cnjKlFxehGZwNhjfWmJHo2f1fog6oiJum5sSQZaGjoOJXF0f1GD2XSmFCeE=
X-Google-Smtp-Source: AGHT+IH9y5ZsNU0/1IZVAwqxMjl/THOn02DoTBZeJQXoIQD78iYBw9cg5G5ERRFPQ7WvpJL4YR5few==
X-Received: by 2002:adf:ea91:0:b0:37c:c51b:8d9c with SMTP id ffacd0b85a97d-38061228564mr7060382f8f.38.1730105333982;
        Mon, 28 Oct 2024 01:48:53 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b3c861sm8872842f8f.44.2024.10.28.01.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 01:48:53 -0700 (PDT)
Date: Mon, 28 Oct 2024 11:48:50 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v4 3/3] crypto: Add Mediatek EIP-93 crypto engine support
Message-ID: <2c53b5f9-cba8-48a8-a9ad-9c72656b7479@stanley.mountain>
References: <20241025094734.1614-1-ansuelsmth@gmail.com>
 <20241025094734.1614-3-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025094734.1614-3-ansuelsmth@gmail.com>

On Fri, Oct 25, 2024 at 11:47:24AM +0200, Christian Marangi wrote:
> +static void eip93_hash_free_data_blocks(struct ahash_request *req)
> +{
> +	struct eip93_hash_reqctx *rctx = ahash_request_ctx(req);
> +	struct mkt_hash_block *block;
> +
> +	list_for_each_entry(block, &rctx->blocks, list) {
> +		dma_unmap_single(rctx->mtk->dev, block->data_dma,
> +				 SHA256_BLOCK_SIZE, DMA_TO_DEVICE);
> +		kfree(block);

You need to use list_for_each_entry_safe() to avoid a use after free.

> +	}
> +}

regards,
dan carpenter

