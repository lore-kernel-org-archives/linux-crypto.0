Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D34357CE9
	for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2026 19:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783019898; cv=none; b=Ep4n8gUYDMwMBo1RViCx7DdCFnlez8D1nwfTnNmxe3ITVe8kM99jDrQKGNX9ymUUJgaVGIqS2BoJ5mqwJHzYTZeroLUW4aJZEoRZrVtV3IZfKhnL3mSTnVAIZo6bYe1jcBcfiKFAc10B2Be1dUS6s+c2EtFVL4oTem6vnNsRY6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783019898; c=relaxed/simple;
	bh=GuyPitaavjsTFrGB6uOKJrKHVn2jFv1A9akTsAvemzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uAY1rifLi8cuQ0k+XZEfcQ84tXr0hnAg1iUm3aC6RrNSBQo4QEEGq6RSGShFM6ZQZ16xGzQ6ZIgwdwYslYcfE8RyNboD5MJwcL4YXlDdlZx0PnimeAhCglgB5UtPznhcbMYFPgEGGNzWK7+3oJ9lTp9kwQ0Xdzbqi3++yHfNY2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LAp6gRxJ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAp6gRxJ"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493c55d5c7aso10514815e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2026 12:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783019896; x=1783624696; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=N7rOg5jQez2GHmNcCrLRLcnuXiG+zfw2Mjn8FheeGgs=;
        b=LAp6gRxJ0xwBAKkRQ1Bo9Qx0XFyE2EgQT8MA+eG4GGVuHunXRR8YH5E5TtxSHQ20xB
         62RTezgVtvi2o9KSdijbx+yTpvt/tnQ7QIqWVj/oyhopbBz1iDd7AIWIi4xIcHSrEgmM
         6dz9eyaFj8ITndH/NZagw6T1XZ2/f+xmBkHcii0+ItsECWwKPVaR48WXLtCpmi8RE9Nn
         lbiriBPi13l/lxLldsJkTjlOZabyGtqUW/2ThIjJRt6M9MCG5kTj6x2fL1cT09BPDtU/
         GJwP9Q29q9DobmJ2LNkzIBkWSPz+FbxvkkDjpYNzAqhgAVx0umarddSZmLNtpc9HVKaq
         xNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783019896; x=1783624696;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N7rOg5jQez2GHmNcCrLRLcnuXiG+zfw2Mjn8FheeGgs=;
        b=SxIpKy94PN2WWAv2dqhXUMdjQ+6y5aqGeq7wgUX/SQdVTyNf5KLUymzthPTzpsfaVx
         AJxp0yvoX7y4ChC4IDlOIlb6SBTVKHXE6aCDdkIIwFM5ppj/9rnVqViwbLLSS6n1haQu
         1cwywtni6Z2ZO0S966Cn2im1alURZSM7EksXeR1rHx5yI6JpJPA/vXZyqnuUdI1+2J9j
         QAJ/MsgAeDT8dK2UcaM/xsGezmUT3EfhvKEt/rWeVV9r22IA93SZhf84ZbUXXs3sp9Od
         ey4NEFuPz5Gf0UtIS0ThEKd2NCBeHk85nk+tqHvDO8cLfs2enBGLCloGyv80+vr7Tm+O
         6lgg==
X-Forwarded-Encrypted: i=1; AFNElJ+9qkXtd2QSdgEzT7ZVT4s/nlKDqCU18v219Q2s8rih1avQKFR5pYNMLtgxg/WdPQxCneUYtOKzDsWUvTs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNPzqCvq/2uaArYjC/4Lg8WwlF8pNWVzSoxT7eMVQOpcVLwF1u
	zR2CMAxIb1quxRbI0h3nkGWDOi3biwKjfgV3kRw+I7xyY0DCNw6MmOvb
X-Gm-Gg: AfdE7cmplfYlGYPlR6kTY4rh1569y9axtW+NGrjwu8qcRvjk2pFlWU9S9JcMXdr5YSN
	F41EMcdVVpoX6b8FaLc0Vd23X03nAgDWgJMAL/wSzbo7WZgG3IOtNG8g5fcUNBfdV2eCPNUnnxR
	Fx35/xst55QFZSiBkTKuLNX7fbgzksIlb3UlFepAvsY7HkgNCN+kjgeWojMXgcxQyDTeChy7HT9
	VLeyC8CNrHvmCx0LYeIOq1Zh/RubqbmqXkdIugbDQBU7vl071eS9ne7Ers743+h5nyhPa5iqfjC
	XxpbtPpkV57bYaX/ZhLgWLHgWvRlkgdz/CIUKkcWqIL0jOnXY3KDXE/xNmfWwUuhTgKDqMgPpyp
	/jtbRLFtph7DudsTpnMjO27j9goP/pYPvFLKKwGeGrWu21uKzehVj59mOKTPYD/dPiTKiCSouKW
	AqF5eQreIPRxGpbyClZr2s78IhV2U/+rpwvFUu1qk32ltwkh3sy9XOMoiJmkJbvd74S7Wn3x3k8
	4g34n9U
X-Received: by 2002:a7b:cb49:0:b0:493:bf85:29b9 with SMTP id 5b1f17b1804b1-493c2b55a4dmr67939135e9.17.1783019895863;
        Thu, 02 Jul 2026 12:18:15 -0700 (PDT)
Received: from [10.128.11.240] (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bef17c82sm101298285e9.1.2026.07.02.12.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 12:18:14 -0700 (PDT)
Sender: Julian Braha <julian.braha@gmail.com>
Message-ID: <deb73385-a7a9-4ea9-8338-b7da999a5e9c@gmail.com>
Date: Thu, 2 Jul 2026 20:18:12 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org
Cc: krzk@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com,
 rbannerm@synopsys.com, manjunath.hadli@vayavyalabs.com,
 adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com,
 bhoomikak@vayavyalabs.com
References: <20260701122941.2149121-1-pavitrakumarm@vayavyalabs.com>
 <20260701122941.2149121-5-pavitrakumarm@vayavyalabs.com>
Content-Language: en-US
From: Julian Braha <julianbraha@gmail.com>
In-Reply-To: <20260701122941.2149121-5-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Pavitrakumar,

On 7/1/26 13:29, Pavitrakumar Managutte wrote:

> +config CRYPTO_DEV_SPACC_DEBUG_TRACE_IO
> +	bool "Enable Trace MMIO reads/writes stats"
> +	default n
> +	help
> +	  Say y to enable Trace MMIO reads/writes stats.
> +	  To Debug and trace IO register read/write oprations.
> +

Typo in "operations".

> +config CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
> +	bool "Enable Trace DDT entries stats"
> +	default n
> +	help
> +	  Say y to enable Enable DDT entry stats.
> +	  To Debug and trace DDT opration

Another typo in "operation".

> +
> +config CRYPTO_DEV_SPACC_CONFIG_DEBUG
> +	bool "Enable SPAcc debug logs"
> +	default n
> +	help
> +          Say y to enable additional debug prints and diagnostics in the

Most of your kconfig formatting looks okay, but you strangely have 8
spaces here in your help text.

- Julian Braha
