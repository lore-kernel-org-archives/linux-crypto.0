Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7016E357A53
	for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2026 09:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768556785; cv=none; b=Z4PCDBC6ydQu4GvoGhxbMRJgL1EB9ph6sjHashB1+axb/Ceu6fUY0/UDZuYhpPuvBQ9terKkBxgQaMRBWvMOYD6BJgveYAtWkNWTNVkn4n9StxzPRaJBH9Yr8HeHt3tuI2atnQK0n8W+/+AezV0p4x1JBvabybymnbRuuP3xmTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768556785; c=relaxed/simple;
	bh=OznCFI/X6SPcc9FEtZXYTkzJZ5FwPbCECtf62JPUNG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajslZcIHrJdeOek95WJ0g/z4eKBe2aIkVdzyNGY5zXkQYv6088ydjUA3N2VFAs6YiiGuomQH9RH4WClv1sIGLErIxfT9LwvqwmNPg6WKKUA274hr4RTBhpqC2cz0J39pmSZXF+QOJ7L/DhL/N+Q/puxFm3uQPiHekriqY8SrkMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7cfda7bf36bso530149a34.2
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2026 01:46:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768556782; x=1769161582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+p/e5La9Qd80Gf4LnnAnfePPR/VKPMhaOxnmY+Qf1OY=;
        b=UQ49w/UdjBMkCkkj6Ti+vHL6Fy1sXk/V43xS1GtULVsZouCAvl3vpKwbP11YIWB2xs
         6/e5tJPnje2/JUxCdY+XECQgehZuyv1fKGxwRxoCmin7P8YqpPYjlDldTG8wOEk8F1Tu
         w7wj2YDNK3zKB6lpfVzZ32IEtQR0EWKYfqqKJt1wOjsaISU7UmtpaGMc6YYkc1UfO+EB
         pWTJfrPqY+Pf5UgCcpRMKHUNoMorzvaQmiheUVqJhGvGFX1F5eKVHg9h0oygk7dc918a
         rtFIfoeO4oBkmGA9bZb7OA/P4vM0zMM0ne1dYJsYEBNoAj83jwH3Qym2SLGRFg0F69/E
         QeVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQEZg6P/TteRObGekl04ojGJhWGBKn7N4YLFMKr63sv/QOLCxhaT/LvVid7JgSbzVZi0gaDrU5olJXK9I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxdeXfSYQWT98nBA/BNoz5p6yuoQIINqH/RCdpJAK/ufJaJ+ki
	dQ0qAx+CjY8KNVUqPpkbDnUxdgFPhUtWu5zQ46whpZeVPH+9hCnbQ0pY
X-Gm-Gg: AY/fxX6XUI6E+Bxc4hXL5+YHKyILXQr4iopT90wa6QYMzUJiOl2semF0RSk32sXHGWE
	qnV3n5W7iL7gl3Fc29SlRJ9boXv6lQNh/Xn+9y9Qqi6bFXYtW1mW4fykvd9FhJ+rdcpx6VcRSZc
	C7qrHyPtdHrbGgBsp6jYkQTuFBGFYn1pepH9Cn6mZn5iYvwOUmGT40C1Z8IW2yuuxyW3jnGI/cG
	M234purWFVuW02cEW8/DWxzVtvisloWKN9sluh0guHN2CUYaXe3pBDVb6K42MT1XSZk7n7Ow8n9
	coPKEqZCjxOv99v2v5S8WS/K//rUxZiAxpvW8IfRZ12iktkdcLmfiJ37e3BVJMKOIVKI+KqKyZH
	UbW6E3fvJrc97xBfshBSDYX8xuBzkazlbL8UjU6LUgXRrmvz45m8Y5uN7umZgaXHZiVi3dm5b3m
	qShw==
X-Received: by 2002:a05:6830:6735:b0:7cf:d1b7:c319 with SMTP id 46e09a7af769-7cfe00d95aamr1040902a34.2.1768556782240;
        Fri, 16 Jan 2026 01:46:22 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0f0137sm1427232a34.12.2026.01.16.01.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 01:46:21 -0800 (PST)
Date: Fri, 16 Jan 2026 01:46:17 -0800
From: Breno Leitao <leitao@debian.org>
To: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam: fix netdev memory leak in dpaa2_caam_probe
Message-ID: <4h7joiwvamq3sgrkhyemtug4lucyicnx7beuik3i5foydwb256@iemjvkrs7h2d>
References: <20260116014455.2575351-1-jianpeng.chang.cn@windriver.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116014455.2575351-1-jianpeng.chang.cn@windriver.com>

On Fri, Jan 16, 2026 at 09:44:55AM +0800, Jianpeng Chang wrote:
> When commit 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in
> dpaa2") converted embedded net_device to dynamically allocated pointers,
> it added cleanup in dpaa2_dpseci_disable() but missed adding cleanup in
> dpaa2_dpseci_free() for error paths.
> 
> This causes memory leaks when dpaa2_dpseci_dpio_setup() fails during probe
> due to DPIO devices not being ready yet. The kernel's deferred probe
> mechanism handles the retry successfully, but the netdevs allocated during
> the failed probe attempt are never freed, resulting in kmemleak reports
> showing multiple leaked netdev-related allocations all traced back to
> dpaa2_caam_probe().
> 
> Fix this by preserving the CPU mask of allocated netdevs during setup and
> using it for cleanup in dpaa2_dpseci_free(). This approach ensures that
> only the CPUs that actually had netdevs allocated will be cleaned up,
> avoiding potential issues with CPU hotplug scenarios.
> 
> Fixes: 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in dpaa2")
> Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 31 ++++++++++++++++---------------
>  drivers/crypto/caam/caamalg_qi2.h |  2 ++
>  2 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
> index 107ccb2ade42..a66c62174a0f 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -4810,6 +4810,17 @@ static void dpaa2_dpseci_congestion_free(struct dpaa2_caam_priv *priv)
>  	kfree(priv->cscn_mem);
>  }
>  
> +static void free_dpaa2_pcpu_netdev(struct dpaa2_caam_priv *priv, const cpumask_t *cpus)
> +{
> +	struct dpaa2_caam_priv_per_cpu *ppriv;
> +	int i;
> +
> +	for_each_cpu(i, cpus) {
> +		ppriv = per_cpu_ptr(priv->ppriv, i);
> +		free_netdev(ppriv->net_dev);
> +	}
> +}

Why is the function being moved here? Please keep code movement separate
from functional changes, or at minimum explain why the move is necessary
in the commit message.
