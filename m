Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5B9299937
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 09:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758015542; cv=none; b=IIvB5JjiQMai5b91uwjxTCcw2AbNGm1T5YJVO43cHZBsHKR9LwEX5z5gXHIDywbRt9nOtSSARtQc2QufG8nPB+z0wr2d52f9Zua/xzE3IhQlzYVWSsvgLGgzG6rtJGoPR1olUpAEMFTF+nooJc5GpfkXzJvOmqVTOFWEpJKHme0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758015542; c=relaxed/simple;
	bh=fOm7n0oqTh35bOtTCp2VEPwcj/762d6UfcwiSPgUo3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=li205g7napmap4RwFzP/v1PTUptNunQ4fiHLQsaPiJpsGO43bhqHJP3qoIsGzksZDO9UzoAy9x5NZJZgXDXOKiSqUq/hkWlNTwv6zOy1+muY79ORjad0b1LWRXNv6k2eDK+yOiQjONgCXTuezk5/91tnYN74COHQBonqPsXMEHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bsTWZ5VR; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bsTWZ5VR"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-828d8d06630so259087585a.1
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 02:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758015540; x=1758620340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UMmgtmyqL3pSVlf5uAfBg8YLZnU4eepFksA8tWxfUtY=;
        b=bsTWZ5VRxzL/eq8kukNK20lsIP3sO5YsRQ7c5k7l4veJYDijBIfP0tv+nB73b2//zY
         lUbpMy7HT5+8cmtTYMDjuz0Bo0ChkTJhnvLhNkwvVLEGh88PmRldRxKKPwgwpsV7p9h6
         Ho0NkeqzrOGeHH3CVLTYTv/wlm5if8zNRmiTqMWKoEfSuUZZN/4x4SaCcumPsylW19NY
         QrZXgsV8bK5/ku8fKhfaHQG3w5g9I2ynvcnrBGsUlXh/Ye4q8Kn0brpFO6gdA0cp6YeW
         1EuAwmorETWjuCWSGbgnYCRUZhQHYy0voEeTs+fn3Ten9MBVMjX2ZlmRJLh96jGjNEGZ
         yXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758015540; x=1758620340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UMmgtmyqL3pSVlf5uAfBg8YLZnU4eepFksA8tWxfUtY=;
        b=wYbjBr5WNQXZTIvgBFiqBEVQYdUK4KrVbc8c24fBL4g5K3z0dvrbgT5x6LgjSpy2zZ
         iD7qgkXqnPiloOe129MxzezhlJNkHeq73JynGXhQFg4UKy8ADB1T9DJBuV+EM1frgXtr
         L+nmv5S/3vEMTG/UyhpzYFyLNB4EGc4cbRFtxHiNjcjUvXWfHMWl71almnureuLCaC5E
         cVfbQW0QipJGmbqpRREdUuxT2fUJo9JjFzPo0rpd7Z3IqQtxkN3HZzgfQVh9EfMWq9v1
         QMyHjf5RXMhp5IWo/tq9YNNr5nV++gDwYEq0CaJuiHDgWNzFHJTSQjwCMme7DpmfU+/I
         y7Zg==
X-Forwarded-Encrypted: i=1; AJvYcCXMl8kBKh0I5KDMyoXTKGxmUHfHtnGO3w1sEf/vrh7pqjz8BnLimga9Sn3360Ne0Cm2B4/b2IRgQYcQujg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi5WcmaVMq57NCfL723EpEGOyAjenRVF4C9tY1TeuWag56I704
	cMaMEaYNHZfk1oWoUVavJ17E4vdcCyVdz9mCcsF6Q50NmA8GIX/DyJoW5OYpOwIzeb8em7fffbB
	afWfUs34aSA/5c8YJSGtOVSjP2006u/1YYDGum3tX
X-Gm-Gg: ASbGncu2f/bUVkuAWg/zu2QaxAmXcUIEj1gA4B/aYeDqjlAPC0YZzVa6qjmmEyYM1dK
	SMEpv491XcfVLnJuf9RSJW0aDXWGN7X/K9s2eM/3hf0KUu9Sgdw+hkgrTFoU4yB/zgOEWrhXg2c
	tZIZiaHgQQk9qjVJPfPl8blnFiw/4XTaH3DiXCOicITJEZ05bTWBOt8bzaQNZcqBCoFeeJCdDXo
	W4+CDPYvVSsRf/5HmOocdMvkYars8q+GaSNz+7Byfs76FddE5/1XWE=
X-Google-Smtp-Source: AGHT+IGpUtzKURh5f5eNEdht+Fw3FifoSxUl0tHxuZWY/z6ZGb7OmyvobO6UGWMj43Uq8+koYYCVKrSUCM9X3xc1Gas=
X-Received: by 2002:a05:620a:17a8:b0:805:d2df:54b2 with SMTP id
 af79cd13be357-82b9be9cb55mr140912985a.6.1758015539317; Tue, 16 Sep 2025
 02:38:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-11-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-11-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Sep 2025 11:38:22 +0200
X-Gm-Features: AS18NWDPNjOn1tpd4dh2PjA_D9sETIOVojzQySxiayXszkU2oRRijwgocF7cJt0
Message-ID: <CAG_fn=U-pYHi7R3Bq0zd_n7uzaw1vkL1RM=oyF1Or1Ovx_q1Tw@mail.gmail.com>
Subject: Re: [PATCH v1 10/10] MAINTAINERS: add maintainer information for KFuzzTest
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
> Add myself as maintainer and Alexander Potapenko as reviewer for
> KFuzzTest.

This patch is missing your Signed-off-by: tag.

Otherwise:

Acked-by: Alexander Potapenko <glider@google.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dcfbd11efef..14972e3e9d6a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13641,6 +13641,14 @@ F:     include/linux/kfifo.h
>  F:     lib/kfifo.c
>  F:     samples/kfifo/
>
> +KFUZZTEST
> +M:  Ethan Graham <ethan.w.s.graham@gmail.com>
> +R:  Alexander Potapenko <glider@google.com>
> +F:  include/linux/kfuzztest.h
> +F:  lib/kfuzztest/
> +F:  Documentation/dev-tools/kfuzztest.rst
> +F:  tools/kfuzztest-bridge/
> +
>  KGDB / KDB /debug_core
>  M:     Jason Wessel <jason.wessel@windriver.com>
>  M:     Daniel Thompson <danielt@kernel.org>
> --
> 2.51.0.384.g4c02a37b29-goog
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
