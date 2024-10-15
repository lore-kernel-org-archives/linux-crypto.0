Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C411C07CC
	for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 12:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996529; cv=none; b=ephsZi6YHmgV4Bz+7+AitiG9b2q6JnwaXEKYNgYAUUPktLXkIqCrX/VT5Hxd32ic0y+wEHHagOGsFaGi6HGQdSZolOfIROSSKwEvN2pkpdUY2QMnYAecBxFzUioz4YV4jR6LGYpa/f/mytC7MQy8Pg4dSZ0i1QGGLfqMq+QEjbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996529; c=relaxed/simple;
	bh=zA35WNDDO+XTEpqOhjl4AE+3mcFrw8fEePuTw1HQyOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nea7CGtEy9z54nV48QcSqv+73eZEy790yUns6JpDgPwvK/AdoaEupeqTvw/A+BM85+hZv6xmdLY5zn6unyRRz6TPex8XKyvUV42fOdSrulBh07VRE4l/tfNuRhRtu+vD0wR9aR8EhO3+5UNxbNn8bMiAZeODIHfY7UhlnEfxOkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BSEQltfe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BSEQltfe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728996526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6muWU/G2Bo0tGqDvLyx/Zy7bm86G9nhd+maNiujTvg4=;
	b=BSEQltfew5R++SKzWc6Nsgf8vBbDFRnMOunOwFroF+zhirv3wT1eiKN/ITe+6v/3EK7eGF
	sai97iZJIScsKYuITAlWIOUVG8rsQ0zbDvlHYbYRvQbZBVhm2l3d7Rpd6DYW1T2dzI5ELW
	qFTalNUTPqE4diMcUjinu2n9XY4+16E=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-UqT4OrjTNESOlInhBsCUIQ-1; Tue, 15 Oct 2024 08:48:45 -0400
X-MC-Unique: UqT4OrjTNESOlInhBsCUIQ-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2e2c07adf0aso5371690a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 05:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728996524; x=1729601324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6muWU/G2Bo0tGqDvLyx/Zy7bm86G9nhd+maNiujTvg4=;
        b=Xm7qhQM3Jixq7TfomC5G2Y3zsyFFCxC8TmBVJtRcpIJE7kfaroNizH+szEefMj4E3M
         +CYqqo/5humgGbx335LX6W8KhSeCo4zKrvUMhThFw6q19kuR0a25QTxadDo8KooECP4q
         Q2G58z53l7LL4HWMlDRbLPxRpPX1KKTQvZ5QAZzq1BfRQc5hGUl/dl7vjwq86qd0HBW5
         /mcCTLfFGSGIR8ASeppErPxbbOZ6KZEZls89oOrh+PWLCUY6NaZj+TFWqtyHmy6tcXHm
         oMC+FJ0nay/733M7NlwRAVcMz6wzCx6aoBAOLvHt+Z3wWkFNVa0QkYGVSRpQKjjuBctT
         r8hQ==
X-Gm-Message-State: AOJu0YymFO0wfEop/K49S3rLxzvz7UBzfOJEI6cps6F5NlwRtvs1t/Le
	OZNh5ipxuBf5WHSXufSRx38+Dle2JYJnImM4MrG+GLvlB4GvxHOWJPzvy9uFPc8NeA5rmdDoE/P
	VM0V/vWahNowsttFxl8UkykarqY/YnOK0yJiYRgcmIupq92Wo8z9vfqCKJy7eOoY5gcIEKenAAn
	/9KTseqOUCBoVVh88U12gRQCRBopiCkyuZRBc5
X-Received: by 2002:a17:90a:7c4d:b0:2e2:e545:82c5 with SMTP id 98e67ed59e1d1-2e3ab7c4dabmr67475a91.3.1728996524512;
        Tue, 15 Oct 2024 05:48:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENLPN4SUdlL8Vm5gV+JHk5pQXSA2RYz01XXpd55CQcnZO8Y5U4ROQnm3ua8cjaE1RY+RuZTyiy9zW9xQhx0R8=
X-Received: by 2002:a17:90a:7c4d:b0:2e2:e545:82c5 with SMTP id
 98e67ed59e1d1-2e3ab7c4dabmr67458a91.3.1728996524069; Tue, 15 Oct 2024
 05:48:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007012430.163606-1-ebiggers@kernel.org>
In-Reply-To: <20241007012430.163606-1-ebiggers@kernel.org>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Tue, 15 Oct 2024 14:48:33 +0200
Message-ID: <CAFqZXNtaDNVd_RAT-zM4zMEdT8hBqecYp_j0FvcuxWTaMtf81Q@mail.gmail.com>
Subject: Re: [PATCH 00/10] AEGIS x86 assembly tuning
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 3:33=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> This series cleans up the AES-NI optimized implementation of AEGIS-128.
>
> Performance is improved by 1-5% depending on the input lengths.  Binary
> code size is reduced by about 20% (measuring glue + assembly combined),
> and source code length is reduced by about 150 lines.
>
> The first patch also fixes a bug which could theoretically cause
> incorrect behavior but was seemingly not being encountered in practice.
>
> Note: future optimizations for AEGIS-128 could involve adding AVX512 /
> AVX10 optimized assembly code.  However, unfortunately due to the way
> that AEGIS-128 is specified, its level of parallelism is limited, and it
> can't really take advantage of vector lengths greater than 128 bits.
> So, probably this would provide only another modest improvement, mostly
> coming from being able to use the ternary logic instructions.
>
> Eric Biggers (10):
>   crypto: x86/aegis128 - access 32-bit arguments as 32-bit
>   crypto: x86/aegis128 - remove no-op init and exit functions
>   crypto: x86/aegis128 - eliminate some indirect calls
>   crypto: x86/aegis128 - don't bother with special code for aligned data
>   crypto: x86/aegis128 - optimize length block preparation using SSE4.1
>   crypto: x86/aegis128 - improve assembly function prototypes
>   crypto: x86/aegis128 - optimize partial block handling using SSE4.1
>   crypto: x86/aegis128 - take advantage of block-aligned len
>   crypto: x86/aegis128 - remove unneeded FRAME_BEGIN and FRAME_END
>   crypto: x86/aegis128 - remove unneeded RETs
>
>  arch/x86/crypto/Kconfig               |   4 +-
>  arch/x86/crypto/aegis128-aesni-asm.S  | 532 ++++++++++----------------
>  arch/x86/crypto/aegis128-aesni-glue.c | 145 ++++---
>  3 files changed, 261 insertions(+), 420 deletions(-)
>
>
> base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
> --
> 2.46.2
>

Nice work!

Notwithstanding my non-blocking comment on patch #3:

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

--
Ondrej Mosnacek
Senior Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

