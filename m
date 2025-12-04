Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFB1283C87
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861458; cv=none; b=r+sBuiLvJhILrmPxY9YDDEY1QQMexL5EhK+6AxrTZ0QI7+KKkaTfPyjAj5L6kXWMtQHwQjQZf8mNEE2/VMFd2qft5mig3y9ANu8It7Ol8lHpI7ebHYatn74yapy/QnvNCVEmfKRBMEX2ZyWk2tgQRThCUdM6p4z7wnd1zHZBkww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861458; c=relaxed/simple;
	bh=PhfUA5Q1PPXBmZWMZUohVdeqsdpscP4peWDyn7gSQaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pG7zgSbde/joIWg4IxYuSd8NcLmCVsKIdD9m8pYixj3zWsAvKjz2s0ryQiJZ+snZ3XrPxqucDiN8duJNpBNedgzw2eQzz5+S9QD7iBuREBZnO1Z6AibL9OIRl20vHLNvlmYwqh69iMmB5Fif/GztLCONfrP7q5JtSqq+h1KGcts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=We+U7MFL; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="We+U7MFL"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47789cd2083so6928165e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 07:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764861455; x=1765466255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WSesA1513PF1RTOpQ3ExDpK6F+FkeLsbkbgvrO0OXrA=;
        b=We+U7MFLHX+nD7wnFAsFui0yjjDFIpWta4n+X65HStxzF9rfSH74FWL/WpasOl4vFZ
         pf+mF4rv9MQ72+Ia26W/quQ2rdcjwxayLq2PL1cM5eAgQK4tZYW/PZD6UVvtQkPu7vdc
         JG4tki+hJgT1kd/ntxIamVEgxtU35DbKp9CZE0LUl2UGNU8TdE6SBZFHK8wORpuCusHs
         fPbGO+Jjhggfjkc6pkqiFeRmTdOpTNfa5vaD8Y5A/LD4hmV605kxLZ6VGAcKy7iuXE4G
         CEPEWgwH+2LMtmpNG3r6SAwZdNA1JeNc908AfL5wakFdHeF/E8wVdWC100NaasogMNZZ
         g4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861455; x=1765466255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WSesA1513PF1RTOpQ3ExDpK6F+FkeLsbkbgvrO0OXrA=;
        b=D3WuT/K/PUOOS9MemOR0CZMrJY+kMcMLgjGZqwBA8atO1nTpG6MeMpT7nGo8SlEKbf
         TDjU03+h+yfY+kIVsJW+5QDEaXI8BXM25M0k0PpRxmMdsPeFp7Ldml+lUh25AQkX3oPq
         +bPaGX1xDD9VdEFx+orLWsuck0mWhywyAb0gh6xwQeUQzj0eGdSr8LbOG7zH5Q6ADvQh
         T7tIlEagzExytiwq4grDbgknW3Ob65DrCjY89s0lSwQpGGQ3pVsoEH6fQbIk8g4RFnTm
         sHTAplAOswlz6Kzez8kG4pzAHmH5N3RWzH101b+W2lEGzW4mEoRuOn2BhvqO3pJqKBvM
         n7Yw==
X-Forwarded-Encrypted: i=1; AJvYcCVBEZyDU1hdYuq643UtuKivszQyMWib0FpyOQ+sYuX/pZSIqSC9vqVrzjYK+CVjqfEi7Lhv/DS76RIIVI8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP82ZGr0WVgqUbGzpMEuzJBjbSVWnESQcbPIfM2MeKhb1SyI1d
	f6ZTQRcb00E/GSRwZJ9R4cAHPjpzOmIM6lssrReipYiJND6ucMy+wr0+CfpdCaAwjGEXcMDTiFr
	/Wyt753wNwPfcJv/hrvKayQsqE0mxYo4=
X-Gm-Gg: ASbGncsUVarytlFTBqtqIIYAAd9LGvL14P/A60wH/gYtsgIN/gaddbMv87K0ntZ+kpp
	mTm9NWX3EHapBfyAJoFP8SvOH+4hv0YIrIo07jNVuMCwz2Wn4gFR5ZhA28avr+6T9VX6NyUjJkd
	u1t8pkhsgs1pVrYwJfiDjIcYWzx36J1BwFNAcsv7Jx3LoPSi/CK/QD/KVv32XkY8XkmRSbZ5BA7
	KuYKoCAgyeYdfLH9yZFjXtxYmf7wIUGC6lgXNdAy+nqw8a/VNHyND8E9f085V7CzfLytBJHZuHe
	n9644cE5bencyG8MLko9aviPckZP
X-Google-Smtp-Source: AGHT+IGPH0EJYdbaBhvurzXK12QLylFM9zsem4O87iZvWi2X0pfwfrJuILFzMv5S3tf5HYvfRFYstYyfwHvXAaGIFpU=
X-Received: by 2002:a05:600c:3b05:b0:477:582e:7a81 with SMTP id
 5b1f17b1804b1-4792aed9ab8mr67560995e9.4.1764861454794; Thu, 04 Dec 2025
 07:17:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com> <20251204141250.21114-2-ethan.w.s.graham@gmail.com>
In-Reply-To: <20251204141250.21114-2-ethan.w.s.graham@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Dec 2025 16:17:23 +0100
X-Gm-Features: AWmQ_blzpwZ5TwYvwfzPgYjtrBP8LQtIvLje7Y_oBdFacKxiRRQT788M4KRtDnc
Message-ID: <CA+fCnZcvuXR3R-mG1EfztGx5Qvs1U92kuyYEypRJ4tnF=oG04A@mail.gmail.com>
Subject: Re: [PATCH 01/10] mm/kasan: implement kasan_poison_range
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: glider@google.com, andy@kernel.org, andy.shevchenko@gmail.com, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com, Ethan Graham <ethangraham@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 3:13=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
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
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> Reviewed-by: Alexander Potapenko <glider@google.com>
>
> ---
> PR v3:
> - Move kasan_poison_range into mm/kasan/common.c so that it is built
>   with HW_TAGS mode enabled.
> - Add a runtime check for kasan_enabled() in kasan_poison_range.
> - Add two WARN_ON()s in kasan_poison_range when the input is invalid.
> PR v1:
> - Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
>   kasan_poison_range(), and return -EINVAL when this isn't respected.
> ---
> ---
>  include/linux/kasan.h | 11 +++++++++++
>  mm/kasan/common.c     | 37 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 890011071f2b..cd6cdf732378 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -102,6 +102,16 @@ static inline bool kasan_has_integrated_init(void)
>  }
>
>  #ifdef CONFIG_KASAN
> +
> +/**
> + * kasan_poison_range - poison the memory range [@addr, @addr + @size)
> + *
> + * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE, d=
efined
> + * in <mm/kasan/kasan.h>: if @start is unaligned, the initial partial gr=
anule
> + * at the beginning of the range is only poisoned if CONFIG_KASAN_GENERI=
C=3Dy.

You can also mention that @addr + @size must be aligned.

> + */
> +int kasan_poison_range(const void *addr, size_t size);
> +
>  void __kasan_unpoison_range(const void *addr, size_t size);
>  static __always_inline void kasan_unpoison_range(const void *addr, size_=
t size)
>  {
> @@ -402,6 +412,7 @@ static __always_inline bool kasan_check_byte(const vo=
id *addr)
>
>  #else /* CONFIG_KASAN */
>
> +static inline int kasan_poison_range(const void *start, size_t size) { r=
eturn 0; }
>  static inline void kasan_unpoison_range(const void *address, size_t size=
) {}
>  static inline void kasan_poison_pages(struct page *page, unsigned int or=
der,
>                                       bool init) {}
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 9142964ab9c9..c83579ef37c6 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -570,3 +570,40 @@ bool __kasan_check_byte(const void *address, unsigne=
d long ip)
>         }
>         return true;
>  }
> +
> +int kasan_poison_range(const void *addr, size_t size)
> +{
> +       uintptr_t start_addr =3D (uintptr_t)addr;
> +       uintptr_t head_granule_start;
> +       uintptr_t poison_body_start;
> +       uintptr_t poison_body_end;
> +       size_t head_prefix_size;
> +       uintptr_t end_addr;
> +
> +       if (!kasan_enabled())
> +               return 0;

Please move this check to include/linux/kasan.h; see how
kasan_unpoison_range() is implemented. Otherwise eventually these
checks start creeping into lower level functions and the logic of
checking when and whether KASAN is enabled becomes a mess.

> +
> +       end_addr =3D start_addr + size;
> +       if (WARN_ON(end_addr % KASAN_GRANULE_SIZE))
> +               return -EINVAL;
> +
> +       if (WARN_ON(start_addr >=3D end_addr))
> +               return -EINVAL;
> +
> +       head_granule_start =3D ALIGN_DOWN(start_addr, KASAN_GRANULE_SIZE)=
;
> +       head_prefix_size =3D start_addr - head_granule_start;
> +
> +       if (IS_ENABLED(CONFIG_KASAN_GENERIC) && head_prefix_size > 0)
> +               kasan_poison_last_granule((void *)head_granule_start,
> +                                         head_prefix_size);

As I mentioned before, please rename kasan_poison_last_granule() to
kasan_poison_granule() (or maybe even kasan_poison_partial_granule?).
Here the granule being poisoned is not the last one.


> +
> +       poison_body_start =3D ALIGN(start_addr, KASAN_GRANULE_SIZE);
> +       poison_body_end =3D end_addr;
> +
> +       if (poison_body_start < poison_body_end)
> +               kasan_poison((void *)poison_body_start,
> +                            poison_body_end - poison_body_start,
> +                            KASAN_SLAB_REDZONE, false);
> +       return 0;
> +}
> +EXPORT_SYMBOL(kasan_poison_range);
> --
> 2.51.0
>
