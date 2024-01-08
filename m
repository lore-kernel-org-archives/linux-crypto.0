Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D980D2904
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jan 2024 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yiwt5CWH"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-55745901085so2875161a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jan 2024 14:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704753438; x=1705358238; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P0Wg2B2xBGG1Cu5qs0eAgovYqyf38el6XsD5yrJOGPM=;
        b=Yiwt5CWH3nkEHhaGFdeieca7mKwuEGJDWQD3qamdLvdciNQt12IhdTgDtuuCPsfSud
         zbzVZ6uQItnEnduwhfoW6s0SBe0SCtfq6QlrIz5NYZUCX3nGhVobsmJ+EYyHoGTL5SP/
         Hr5rOYnNnNa2vk3x9k1bwV4YoTU4WehUc6sVZOGYpVCYNLdbeEuvCUW5jWJB7DUrYIfJ
         L3sU/HEAQDkZXG3xel6kN+mRotyeOXxf+UJ4uAa7G8YMI2oHUYn4/VAS9scIXq8d/3wV
         EGRLfxbRUUbbpASsfRvnx8thMP0JoooMTOiyjcz/0jFbiOnc1jpFL0CDhA5wC8F46E37
         n/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704753438; x=1705358238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P0Wg2B2xBGG1Cu5qs0eAgovYqyf38el6XsD5yrJOGPM=;
        b=Kuz4BiIrParvmaLfyuv3DYI9DgUrWxHQrf/vx/YWQSGl4PUEM9vvxWCRvXVpibnIhD
         VK8MsjGGyJNx5f5puMT7Dhahx7GXjrTKGBLC8790JWW86zOSJL9HVQ9k6z3ZQ6nKfmZ0
         U1h2u6UEaxyDbT8VG2kFt8JvcR2/Xc9a0NDgsRmlS+xRc9WfTe4CdXU5cZqzyPkWbosN
         FNSSRTdjNKFHWUy09naVKLgNHaZokCFJ6XmOT2r+pjIxna9gKkCdVl42PoZU4w6Vn3Zl
         jPmXcN/ysJXJbQQoFhybP5vxP/JnQ8hUwLatNhEs1KyiCplNEO6N8F/5eatS+jks8sRu
         rQMQ==
X-Gm-Message-State: AOJu0Ywuv2QzNgWgCHzRqY4evsRhcgt9pgcKpuKXGQGnnUF98TxO2yTr
	Al1bcDSxlzaM2Fjgori+5iIaBC/hVLy3DOROmLKvsl/0pfFd
X-Google-Smtp-Source: AGHT+IFN5J1doAci6kryiLc1sO6gh6B0fzumEjG+b7LNFMoojDVQWz4rXQtX+Ihwcq8B+lNiH24SVRS6WZPZs+N9Il8=
X-Received: by 2002:a17:906:dac8:b0:a1f:99dd:15a3 with SMTP id
 xi8-20020a170906dac800b00a1f99dd15a3mr77902ejb.107.1704753438108; Mon, 08 Jan
 2024 14:37:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240103095006.608744-1-21cnbao@gmail.com> <20240103095006.608744-3-21cnbao@gmail.com>
In-Reply-To: <20240103095006.608744-3-21cnbao@gmail.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 8 Jan 2024 14:36:41 -0800
Message-ID: <CAJD7tkb=ax3=yMATTTrLU9kjSVr+-4oEcSUH_3Jzve8rzhSiYg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/zswap: remove the memcpy if acomp is not asynchronous
To: Barry Song <21cnbao@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	akpm@linux-foundation.org, ddstreet@ieee.org, sjenning@redhat.com, 
	vitaly.wool@konsulko.com, linux-crypto@vger.kernel.org, chriscli@google.com, 
	chrisl@kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nphamcs@gmail.com, zhouchengming@bytedance.com, 
	Barry Song <v-songbaohua@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 3, 2024 at 1:50=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrote=
:
>
> From: Barry Song <v-songbaohua@oppo.com>
>
> Most compressors are actually CPU-based and won't sleep during
> compression and decompression. We should remove the redundant
> memcpy for them.
>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
> ---
>  mm/zswap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ca25b676048e..36898614ebcc 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -168,6 +168,7 @@ struct crypto_acomp_ctx {
>         struct crypto_wait wait;
>         u8 *buffer;
>         struct mutex mutex;
> +       bool is_async; /* if acomp can sleep */

As pointed out in patch 1, I think we should name this explicitly to
be about sleep-ability (e.g. sleepable or can_sleep).
