Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F20D2918DB
	for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 19:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751312472; cv=none; b=dKO9Oe+9PpgwV/9lO3RK7XqiQHBaNECEqrcDWDUt33Pybh9mZRgR0lDcj0WcUyjoXGYm1MNcyFaTMV4i6b3xW1ikRbuetpjOh30LDMzs+a7Niyt/gwZGAdQbsxzyMFOC1/xlWMUT9HaO2xh1yIEFI96X8o9ozCQRDTQBmxDxMNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751312472; c=relaxed/simple;
	bh=Be6wlW3qxh61YAsYffI4w0XqSmxDwkX60bMi3A/giEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brbL8ZPDPf1elnKRmVNfyYttSrIBMi1TVHHiUWiskKeJepwS10c/zKW/1gpqS8LeBIxo1S8ebXMuTuWyNkyZi3H0tRyIqxJDfZKswsiMgVnMOBt7S6zAui4/OEBKU/ySowpIT0x9aEIUlzErlXqjB2Wx46LBwYJsLTIrYIwkn/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=REE8c3k9; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="REE8c3k9"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-73a4c557d47so2376878a34.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 12:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751312469; x=1751917269; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YmZU1CwxbYdxvjVqnDRbR2hmU1JLOG0dDJmR8AN044k=;
        b=REE8c3k9Llv6fjCLeJmfHradu278Erz2k+VU3g4DSrG941g2VFe2jDCZ39SHGGvrso
         KTjZObWwzFZ6ALjM+UdbYisTShNDFZNaFXdKY2l6jrN8pMeSXYv0Nan0Up2OfYWSSiaV
         HMnASmvLMhXmxwmTbFtfxpLJH96KiWZmFyjwDtjfIJ/HSeZbvGv57aGMkX7lVHFQS/gg
         bulvC90/VU5iFR22U8arTd5mmD7ob7c+ky8Ejj0SSTVSOJaLW8tS/Vn21yiWtD/TCpEv
         p/d64ZmKFhM4hdirZcc06ZPn7iCOjEkOP7EpUI1Dq3wR1cLnRjkdSntDX+TyqF5MCSCB
         LlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751312469; x=1751917269;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmZU1CwxbYdxvjVqnDRbR2hmU1JLOG0dDJmR8AN044k=;
        b=Ke2JxQjLOTmRboGbyt5aGnYitdHp8fp4eQuYaoNHmrmtV8Ry7QxsgJwBQICJUQUXkz
         yY1gTJA1h07kHNo5KSQYs30x2mYE4jYNnjAa9YKnTGo/g4vpkKBMuWk1GhqvxJtz9HOF
         lyr18Ii6nrgrJaPPnOC5PbOEpatkV4VcnwXOgE/psBuHsHg019ffmyHqyhz+6mfCtZZH
         Xbn+xivtX0VdEMEsR312DV1VvQ3baSRa06gC8KEduTN/ejrR4Iwuwg5CYw1JcsnFvob+
         J8xPIpZdy6FXqt9iJ6MWe+bzAVNgGk2sr95VEqVOgWasb+eI7V0DP+VJshEP6e6PpVC5
         qa3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVqtIh8EZtRXCD0PT+Cq0FXduVexIuY+Qgc1ocR3aFXXQlgwS1gOeHlyhxSGyU5iueWGr6EzAoLR+tGTWA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz22fbauihqqYFoqfoDBNJYvXfU0Sm1mRwf+quEX7ZOXPStyQJk
	FR3kyo7+mi3Ky2hRk76XZrrQv22xjCsB04lxZECtAma5Qk+/BLRE2eUl3IiPjgH4XK4=
X-Gm-Gg: ASbGnct0v0BO+/5xL8lv2I4lOghTPhr/KFY9Cqrsg1NxDFQvibXJd4WBJ4wiCNUTqoG
	2TktUc+svE8suXnrBIHsugrb9fAaRkMg6iriptIxyZhUXTEHCxW8FM0aNeSCCKzz13PVFRpMLLm
	TswzTb4O4ZwQJnBKqekBMnXMtgLBuwQI0xJYnGKYLI9iYeeICwrN/4y7nRqqYsrPPzuJCflp/Q1
	Y8KwusFyb+8BQA5bre5o4ya4DBkRtNW6dizBaBJz4EAXHIbXzyl3LUCq0GbMcQ/KcdAUVDAwchE
	IGGRGMlF9LkUGAe7qQdyQFrEH/qHgN78FGqN7gzyp7upHd83vHNH3944olciGSYETZ7J
X-Google-Smtp-Source: AGHT+IFCr/h/Pq7YioC0C96yZfnS46Emb0XznV8LFfoTN6Hof+uG2lgGCVIDP4UToYNd7qu111FhBg==
X-Received: by 2002:a05:6830:2901:b0:72a:ec6:7fc1 with SMTP id 46e09a7af769-73afc6507b1mr8500368a34.14.1751312469502;
        Mon, 30 Jun 2025 12:41:09 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:fb67:363d:328:e253])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73afaff249bsm1798804a34.6.2025.06.30.12.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 12:41:08 -0700 (PDT)
Date: Mon, 30 Jun 2025 22:41:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Lu Jialin <lujialin4@huawei.com>,
	GONG Ruiqi <gongruiqi1@huawei.com>
Subject: Re: [PATCH RFC 0/4] Reintroduce the sm2 algorithm
Message-ID: <0bf20f7e-117c-4495-9805-baade7f466ba@suswa.mountain>
References: <20250630133934.766646-1-gubowen5@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630133934.766646-1-gubowen5@huawei.com>

On Mon, Jun 30, 2025 at 09:39:30PM +0800, Gu Bowen wrote:
> To reintroduce the sm2 algorithm, the patch set did the following:
>  - Reintroduce the mpi library based on libgcrypt.
>  - Reintroduce ec implementation to MPI library.
>  - Rework sm2 algorithm.
>  - Support verification of X.509 certificates.

Remind me, why did we remove these?

regards,
dan carpenter

