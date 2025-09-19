Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593F9313E11
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 15:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758294372; cv=none; b=Mn5f9BJ09OKKqivk/CYvDdj5NTOpC0pXIREVbrwdXXuLMbeE53fJP1Wt6MF0M0X+h01fKw2vT06T6KgRbyMYMlzk7B5TXjsxV2PC+I/5NF2SdiXik9k/sgQum2ePhkspGvEZlwBU1RnY7REfp2W19SGixIq4fytd2M7qTrzdA0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758294372; c=relaxed/simple;
	bh=wdojHUk/IaswjOXNhFweViADqPcfNEDUvrpmqOD6T84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B2L8oUe+Tya/CivaXWvsfuGWO/OJXgWsm2RwUG/pa8rgm3zK3tO6siWIuYyUJ59A8W5EwTxFOPLenuf+EuCnnjU48Fkf/QyEmzQNScXNN7psLsVibjQs++8eplz1DPDDQv6BO+X8G2n72Si0omij5UcPgKuurccJWmRTlHmXufI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XrsxQaBU; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XrsxQaBU"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-78e4056623fso18560886d6.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 08:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294370; x=1758899170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2StnNKxKVl/rGS0fAgoxWZPalUwZSRkr2jKpUk0esc=;
        b=XrsxQaBUoAzDlaVC2qo327eDnsB0qVHV3qKzQ4XsbuYZU+zzFZbVnwoELn7t3qon4G
         At+HS8deqXMDM3w+VcAJYS7SuOzONXdzYyYBjZh6DYUsmdDU1VkIy1GIMgLyfdpdcIm0
         qLysFY8v9aS8akIHeyLBK8SMB9eLq5dIjM8Q58T1KahckVXaKUkJu9qAcFnmJdd5AmRe
         TwVgmIoySQygVlJspzO933T7mYPLzU0W0NcSyN97SPVo+vHXXnoizKgRTwVzhf/f5Ppc
         /5yTK/e+gUP/OjXbD5/OCIQcjpx5Iny/4MIlBdMZi6Njz8yjfR8AAgFWz9wRdd6P+xjs
         b4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294370; x=1758899170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X2StnNKxKVl/rGS0fAgoxWZPalUwZSRkr2jKpUk0esc=;
        b=HeAHMwFOYQtlm8FgTqXEvVGBOO1UbLse02llqdOtfO0BiYZNyTCQJrqRi7PPVkvx4F
         aBhIc5L1wJ1YqGkGlEARCUGAZk2CRPyGcsCNPAQxC+srhOqtv/bon7eUfZjKtxyz/IT0
         2wXCszjiXT/BDdv/BDh1KZoB7MmS7E8ecNEyMvfia5WrGcqwhoFr9/z7ylpqjD6VejPy
         LseMoqyIWR5UoEdMFFQBlnTezr9li/r5zQ5J3SagE1reA1DSktzVHakqYBp+07C9JcSL
         4lJwO6EWRQo6cQZpukCjrHRgcsUEhXRgXlS+m86oXCNedYqu6fQN+NWYg5af9bZFxhwS
         CpFg==
X-Forwarded-Encrypted: i=1; AJvYcCXMPuUiYhq75rldF5dD2V+aV7iZ8Ch0eMmSLqnEGx3Yv9gDMEH8Rw8zYNXF/TTS90Acx86lqD8/Jxpzmkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YytrUwoW5K6/Di+or5vs8vzJexMHDtwVIU4eRxPECUkTsijdIrU
	0zxUclcAmdUzeTVvX04PH6rdLkU3aZgxV/jniuEwm7UNNpolPBUlGbVhQccO9EC5yMZPcwSEbE0
	XnNJNd1/7JLZ4z7MaR0Rc5DeRKweW3cXd+1HTWhyU
X-Gm-Gg: ASbGncvS1Eq1NaE/9fggeW6DwGJLGiIqhLLYB9AuGZviDVJDXB7rFRxFyj4CxUwiEd7
	Vl2AQeQ364r6lEXIpuqM9OrW9WvtpW0hcJitUw9AUJB4UJrCJJVX3u2ZB7gaf+QT7DI/vxbzekD
	/XCsSrZTCl/umvh6if8FDNslM/hPc1evhOBA2cq7EFPn1Q/3e5ZOj7qfQi1+53OMAXLqGl+VBQO
	fYoNb5fyuBUU7sRZv3tJXQAPYb6TB1tDy2qAw==
X-Google-Smtp-Source: AGHT+IHfnOEj1gMhyVykBwx/odq4LWyP4tOsK2JQ1CQRm3BPJztFNuuL5zFmF2mdOG0LX/4UQZju33b9dOCcFbl89Gs=
X-Received: by 2002:a05:6214:2aa6:b0:787:68a5:51f4 with SMTP id
 6a1803df08f44-799139ccbe6mr37966906d6.26.1758294369549; Fri, 19 Sep 2025
 08:06:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-4-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-4-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:05:32 +0200
X-Gm-Features: AS18NWBlYb6i59Bt1eV3KacTLjZoCQjcTTUaAaIGM2IX6otsVz3ln6Zi77bGuIg
Message-ID: <CAG_fn=Xd07FvCp-tU_kSyjeJS-4gruaO1x5iowrQQ7zkv2cLeQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/10] kfuzztest: implement core module and input processing
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add the core runtime implementation for KFuzzTest. This includes the
> module initialization, and the logic for receiving and processing
> user-provided inputs through debugfs.
>
> On module load, the framework discovers all test targets by iterating
> over the .kfuzztest_target section, creating a corresponding debugfs
> directory with a write-only 'input' file for each of them.
>
> Writing to an 'input' file triggers the main fuzzing sequence:
> 1. The serialized input is copied from userspace into a kernel buffer.
> 2. The buffer is parsed to validate the region array and relocation
>    table.
> 3. Pointers are patched based on the relocation entries, and in KASAN
>    builds the inter-region padding is poisoned.
> 4. The resulting struct is passed to the user-defined test logic.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
