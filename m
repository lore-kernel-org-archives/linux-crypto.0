Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646932EAB6F
	for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 19:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750189458; cv=none; b=nkbO6oo6yCt9Tv74BxKHUEUHJibZW79bietu9HyivhueuGrAo8htGtzw8VwvGr70jlNouM+rVlI31wsOmoqXb6ytw47EJjhjjhiSb6cej7Ozgadjy37jnD7arRYYHYNFdpjXI9bohzGfu/cQXvKMRFI1I6kF6uzqDCdlPj3VyXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750189458; c=relaxed/simple;
	bh=GglwgC9V6N5x5dY/greRFE2ImYu5s9zU1NI2hHBVjMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=io9dRfqmXHHTHBy0CgpH8Uk5HxF/nBAESPbougqjqA7qNsDSlyQ2bOGnxFCUsGLEOZ5K6SfFFhGW/YuqFGtWjyU+qRsGfbgbMLHipp2d9zx861+BTgiXWgxx1/8xB/itlyVekj06GY5gpKFbZS9izxDyPwzZqsGLjWrvpJAoh6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MfYfgTBf; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MfYfgTBf"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ade4679fba7so1122976566b.2
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 12:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1750189453; x=1750794253; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9BlEsfucVc/RasLKZoG4B3LJbpSakOO/+DV6/Nb67hA=;
        b=MfYfgTBfympgPOCejPRlacaQ2xSeWXzJsF7Iwjca6GTFxYez5PLk+BD2r11lmLKXC7
         c5Sp4B6OtlvroLdqq5TEQstgQJXfY8PCR5VEYQG2V4ZusT7jwtuV9vCrnr2FQMAm9an6
         g5wTWBeeBzuII18xwdfO+mbIX7eJdLZM5Jsis=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750189453; x=1750794253;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9BlEsfucVc/RasLKZoG4B3LJbpSakOO/+DV6/Nb67hA=;
        b=DqV+YQbB8BoeX8ezH/FPhxGzAcAG1OLUL5qGYgsR8g+KAyQ2VIVVfB+qStiqD3rYmI
         DrHuO01b1E3VzrjwfvhDhdi2wyl3kWG7nJTH/suq/KvB3KNk4AM1ykC4Xa2f3cgB7OyH
         mnamPu8DqjIqU1Td9SE5zpaEicmLN8And1jPaJq3utaQ7Qq0ULE2MIobAqFDG+1Fpdov
         QVIwFo0xMnRBvz3M5OKucsxCys7/1dAP/PTItoy+EFS1p5rWsjJfG+GrdVBvQPeWE2Q7
         YDiOJT/+zOFxnGnkLCv5t6Rl3UZOF5havXnl72336oOJXvLGzsyw4v8WdLAfsf98rnAk
         DgBw==
X-Gm-Message-State: AOJu0YwELkzarBfTRYMMZ5O+QJIn+SXztakbrgqoR3sRYjAvsDwaQcaz
	qmVnwy9+wnLBbJZdTGW9tpj9gX70rKkx5mVk2wjEqhYoZ9h7LrTlG7j8OPb2gCcMnW5ynfwfh10
	wq3whiEs=
X-Gm-Gg: ASbGncsvBYyKXjBWTCru9lUIya08HLEiRiE33HreXRVqqQ8KLq2ooSck/4KQluE47WL
	9CVs4fCuIbksNlxVxeLpXX/ESJ6rvpMixl6dhHEk16yeT+ZK/11Ef5b3xYI1TANqf8GMJhMrAbt
	Rvgvexgmx1Bi6WqhJnwnbe7AfASH8HotaUpolcOnqAXXG8azBIU8xZ/zNHZdHoME1PRIwVYd1M9
	AS1fKNzhstRuwM1es1FDBp/jvLLrCasGIUmEen9aJkNEcnrEcGWRUHEhpvVnuMnfnlmu86eWKGZ
	oQ1Q/y0fRnLMzi2q5OR9Y64pofViaC/QC43PFWO3OjLQWhnIYHg15KkpIEB9VnrVbnkSGxl6dkH
	0OvIBef3qrWE1pXRyWjqXh3hvcvECFUCGuE0K
X-Google-Smtp-Source: AGHT+IGd2+KqMqcVNYJuAiUYHwlG8kl+9KqL/dDE642axjLf3EGMyLEzg1nyE19GMUZdi/gQnlVqmA==
X-Received: by 2002:a17:907:9446:b0:adb:2e9d:bc27 with SMTP id a640c23a62f3a-adfad5de029mr1446178466b.54.1750189453513;
        Tue, 17 Jun 2025 12:44:13 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8158d8esm910066066b.5.2025.06.17.12.44.11
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 12:44:11 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60702d77c60so12933477a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 12:44:11 -0700 (PDT)
X-Received: by 2002:a05:6402:278e:b0:602:29e0:5e2f with SMTP id
 4fb4d7f45d1cf-608d086197cmr14681659a12.10.1750189450991; Tue, 17 Jun 2025
 12:44:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250616014019.415791-1-ebiggers@kernel.org> <20250617060523.GH8289@sol>
 <CAHk-=wi5d4K+sF2L=tuRW6AopVxO1DDXzstMQaECmU2QHN13KA@mail.gmail.com> <20250617192212.GA1365424@google.com>
In-Reply-To: <20250617192212.GA1365424@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jun 2025 12:43:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiB6XYBt81zpebysAoya4T-YiiZEmW_7+TtoA=FSCA4XQ@mail.gmail.com>
X-Gm-Features: AX0GCFszNgSlkg9Mnl9IREDvPmSYgcHDQLiQJ6pRqgmPlre4NTxTJm_9n0SX2DU
Message-ID: <CAHk-=wiB6XYBt81zpebysAoya4T-YiiZEmW_7+TtoA=FSCA4XQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] SHA-512 library functions
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Jun 2025 at 12:22, Eric Biggers <ebiggers@kernel.org> wrote:
>>
> The tests are already in their own patches: patches 4 and 5.  Yes, this patchset
> has a negative diffstat once you subtract them.

Yes, the patches were separate, but my point stands.

Let me repeat that part of the email since you seem to have missed it:

> If I see a pull request that only adds new tests, it's a no-brainer.
>
> If I see a pull request that only re-organizes the code and the
> diffstat just just renames with some small updates for new locations,
> it's a no-brainer.
>
> If I see a pull request that does both, it's a pain in the arse,
> because then I need to start to look into individual commits and go
> "which does what".

IOW, I really prefer pull requests to do clearly separate things too
when we're talking re-organization. Or at the very least spell things
out *very* clearly.

Otherwise I have to waste time just to go split things out _anyway_.

            Linus
