Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD5841F369
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 10:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784888495; cv=none; b=kJORVnpt9q3FCD4EA8u8tjCUEP/OTPSs7y9wdLcWxtfdL+8i15SLQwsPdsANWeOWFq9dj/zWFAW4mI61kk7ELMVVIhuiMh7zxoRNjUeSu0WEkqu87mr2QfZrV8VCefFz6Fjas+vuuaUaquHoeU0ToPWi8iOMd7j7rxbptHLX+64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784888495; c=relaxed/simple;
	bh=vFJB/vV2mJifYxotCaNiTDna7avkZD7JolTcMZpZw1Y=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hDxFwoM9KX2vvPr3qzcchNf6xIvCHH3YuAO/YrWRhu12eLzgTYsvGu5xwztyecYZ/OpsVDmdiASH41o+xUbPwNG45QgyEIRFEUAuc6rtBCuuAikPhMHNjxWjtzJ1morsT3laLYp6D2Ey3F25168b7jzc+tHA1kb5YReXuCPNiUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIIx1tim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIIx1tim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DCA1F00AC4
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 10:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784888493;
	bh=TJtfdHCrO6eDiC01QnhO5lmd2eGnUfHw9r12C2PiwEU=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=MIIx1tim+ax0CvHF3XSOzqZQTynPmZiAVi5wu8nvMLLMGd+ctYk7wjKJGjEpbmzhw
	 vWlOjmp/MYfqwvKtV0v1RgOaEZjBfIuF/eiktz1nfcwKjgDnxIvwmNUHIkGvtyVi77
	 vHuxr891yx1nNxsza76HO6AZ0BtdfGaEr7TEHXsbwzdZ0H1lK6hMI00j61AnRZYbR/
	 4ACdQTdvKKs196OZnqyXjirH0KU2hctZBQ0+bZSAqQyKPqDvSLBanN7RCMKQSn2PYx
	 OG3klfzkLXThdyXoSfXghKB3ccZgvHrDIFJJIO4DtIlRHBdQ8unVFnZCM4eiO9jM+1
	 xAuOHwf+zHRvA==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b159850b16so249584e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 03:21:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoR+wJPrX9bLm/BBOb0HtMnvkR5Fln4bsjriM2A7qNrC1eGGEmj7V9HlYpme/xGWKRQZ6XOYAlH5ysCwbE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyR8xKBHmyQzaY4R79VwCSQSkpY5C8myT5r7BdovS9qwQNfhei4
	TB4yjlWrcSH7LjSEIACWZHYKxiuPuYTYcgBIW+oJMhtRwJ0K85B1Sk+ZUO0OlAOtL1utG+wkawj
	X2KDLulKwsWYyuevHIzM4iX/aHNlbz0+dvCng80oNPQ==
X-Received: by 2002:a05:6512:61d5:10b0:5b1:5e92:dab3 with SMTP id
 2adb3069b0e04-5b2b2f72d4fmr1091416e87.44.1784888492629; Fri, 24 Jul 2026
 03:21:32 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 03:21:30 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 03:21:30 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260724081537.191992-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724081537.191992-2-thorsten.blum@linux.dev>
Date: Fri, 24 Jul 2026 03:21:30 -0700
X-Gmail-Original-Message-ID: <CAMRc=Me=B_qhoLBJZY8t7+TpzJPYqRmJorAcGqqCMy+OL8gNww@mail.gmail.com>
X-Gm-Features: AUfX_mxaazX8D6vlySySYK7uJRidFtHHRZFVr_2yxcqfuNgsRBKQu6QoeLrRI50
Message-ID: <CAMRc=Me=B_qhoLBJZY8t7+TpzJPYqRmJorAcGqqCMy+OL8gNww@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - fix error path in devm_qce_register_algs
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Bartosz Golaszewski <brgl@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Neil Armstrong <neil.armstrong@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 24 Jul 2026 10:15:38 +0200, Thorsten Blum
<thorsten.blum@linux.dev> said:
> If ops->register_algs() fails, the error path repeatedly calls the same
> ops->unregister_algs() from the failed registration. Use the loop index
> to unregister the previously registered algorithms instead.
>
> Fixes: e80cf84b6087 ("crypto: qce - unregister previously registered algos in error path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/qce/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index ac74f69914d6..ea5b9689ce68 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -58,7 +58,7 @@ static int devm_qce_register_algs(struct qce_device *qce)
>  		ret = ops->register_algs(qce);
>  		if (ret) {
>  			for (j = i - 1; j >= 0; j--)
> -				ops->unregister_algs(qce);
> +				qce_ops[j]->unregister_algs(qce);
>  			return ret;
>  		}
>  	}
>

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
