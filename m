Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12D8299AAF
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 09:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758015336; cv=none; b=r9/IG0D+WjyWwtWheLyzrJX3WiXPuP7AfShOX//mT9EgzXfi4eHpJeHr3aszNxQa7tc0HsocgQSrpQaQ8MM07AeJVX9DyqwkUKdcCCr593rwBF2yNuWIlrsZ+XFs9EYGikaXRAqbVkCH3necJEH3F5Sxt7dwwoMFajoauHXqqVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758015336; c=relaxed/simple;
	bh=uVJcNQLIaI0TFYuzHf9V948rCw4GzWbCyOZcjnOCgjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ceeylc3DmmMAwgNOeMEqo8iHfBUFDdsJ0gxs5uO7ZGhZ5lONrJH3G/Zo7a0BQerKD1w/fuYCnSsuH/2gU9HbYVJ9m8QpdCbHlQw1nWBA71HF0yInxREk0nVq0EobN1xGLlGLgjBJ1RhRHRymUzXKRxFejWizmNbAGejSyvLeyq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SKAMH1ry; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SKAMH1ry"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b79773a389so24154191cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 02:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758015334; x=1758620134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItFEEUKNnd6JDkvIGqIsrhAmf5lSlmXXN6ieayVKa88=;
        b=SKAMH1ryj8J2J012Y1bbgYx0UEv6Z2AGMpSXuuQ0c9mXf2n4QbpWNkQ69n0hjm5E3g
         GIQcDL14+IUXZ7hP1Hpk8mkozPlVHa3Uw/QPVxtIP6gTWl7uzZ4kBI7i0jui4+7bDkkh
         Upx9Pyd5Icy3HPeHwbW+o6Zz0F15Bsc2fIrXqj0xn1En4HJ4riFVdj/8Ccod7JDrV8Yz
         41NNKWfJoffNX4o8h62ibuXgY9PvguzsA5NHyqvr8ZbDHG1jTResEaXyaY1rpqpCfviT
         5L/xBKtur7MVjdeB/PB2iCaovNfB/Zg7t5TDdlUfY8ozjnlBkZjIfn3wQwmSO8ZpsCNF
         JxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758015334; x=1758620134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ItFEEUKNnd6JDkvIGqIsrhAmf5lSlmXXN6ieayVKa88=;
        b=gwnEX+eJ2+P6dr/gOwS7iPfVG3PISFv1xaVKKOyVU/dgfcxZwLIuoCiCCXXwHW12NY
         W0GBQCAvClY4l07iaXSAE2zcMzcXuhyto9ylaYgunFC0ukYV2wmOgevzBbTMhVZvKCqS
         Bt6K64Gp/cswJ68wp4dEC0LUv/iaK77HCrnXXeszZqLEms2EdFMjDqDH1NptmuThE+1z
         RNebeC0zCpCHLoxuH33fwYPIqvTGlO8yYBHUnINgIXcFywDF+YuVuD+m3BvePkUMSQw9
         aqY4C9tQkG5kMtCtfI0PndN0Kjtf+vtRFgMgttPGOQvrn5SuFKpPGzQpnb4NzZJYSGJ9
         TmEA==
X-Forwarded-Encrypted: i=1; AJvYcCVDwHpdDvag1TCPu1y23mJyghJpVWWECWTvjMM5NrO+ZUv7oTRvGEF7/DugJCEN00wrZRH2j/M23dBKVyc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjK9JAmf8XHCLjNPsgUK0EO02JSj866jBnAjwhUpPX7slR1SFB
	NOe+hRdiisQxvq1ZeB/QetKkoF4qJvVfyH3x8jBJH14MYErt3JQBU0JNYdcL4gafbTlTgVmWThW
	gaGpH7YjGYMRmTkjdHHwAoQunxvnBnCE6N0TjfXpi
X-Gm-Gg: ASbGncuMCnvi0+qleJEA1oqgBSSHLIToah1F1uwkmiTInZA22OkX8CGHNFW+nQlmVqR
	kVPH4WTS5G9eDT4Gc3h1VsUdEVG61TxP514YjK0prmMQkPH++TT8cUGpZXMP+uyN9h0G7GlVCXn
	9CBsMI1Bd6SMCTvLxFdm2oKigPGLg2RNE+4Uume+7Wg3I+UQOCEDllHqZrfyZilES2UJxSqZh01
	BVI+hkfpZ8CnOSIOpM8RyQ/xKukzc50xFZ65wb4ujrc21xfPtCGLRQ=
X-Google-Smtp-Source: AGHT+IEoi69t7mYkGM64faWfanIG3G+aZjIxCT9T7NbXrz1Tm5ebO1fIisC59kXZkBUKvdy4EFZyz1T9cHFhC09CFbA=
X-Received: by 2002:a05:622a:17ce:b0:4b7:9438:c362 with SMTP id
 d75a77b69052e-4b79438e5dcmr151588411cf.33.1758015333543; Tue, 16 Sep 2025
 02:35:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-2-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-2-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Sep 2025 11:34:56 +0200
X-Gm-Features: AS18NWAeZ0I8Ql6T2VXhNmbi0_zOyyX9JImpZH4pIDJbyS4OHq46p0yv6zBf1BI
Message-ID: <CAG_fn=U-SH5u4Lv3CcqKVHnK1ewrF46AF3JU1eiAh-JYxj86sg@mail.gmail.com>
Subject: Re: [PATCH v1 01/10] mm/kasan: implement kasan_poison_range
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 11:01=E2=80=AFAM Ethan Graham
<ethan.w.s.graham@gmail.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Introduce a new helper function, kasan_poison_range(), to encapsulate
> the logic for poisoning an arbitrary memory range of a given size, and
> expose it publically in <include/linux/kasan.h>.
>
> This is a preparatory change for the upcoming KFuzzTest patches, which
> requires the ability to poison the inter-region padding in its input
> buffers.
>
> No functional change to any other subsystem is intended by this commit.
>
> ---
> v3:
> - Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
>   kasan_poison_range(), and return -EINVAL when this isn't respected.
> ---
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
