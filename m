Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B53C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 22:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjJ3Wm2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 18:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjJ3Wm2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 18:42:28 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27D28E
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 15:42:25 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id ada2fe7eead31-457bac7c3f5so2009234137.2
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 15:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698705745; x=1699310545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4Xfwsz1oJlkefwpBB8y7aaULUoJ88otHslpIuLKkVg=;
        b=gNqgjGHCyjrLSeV8iaStXHtpf7OojJqoFIVODfWOIn2PxIFTYqdLbJbazTjS0t7TSw
         V7hBdHGaphsXfjEdBRReoPaewFF3mYIoqxJphA+kDcXnIN1rcQp2uQuAe2k3aUBOd4cc
         OkLhsKFUj5cE6qYPXJbdLGaQznDmTBWdx4uYbw6betA8wrmxzfNGTOQkHNFrj5hOoO0O
         MbDd8GJKK++pA7y1HnixKWg1CwxVmfQRDphwkpa5TBOfV3l4LvnQMvtsWj8D6z92KmBC
         CEkZa8SvKCpLnDtipj6zcCLBwQH9/dToF0aFN233DWJhS8IIZ9F3P0MUrB+z9crItmTL
         LdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698705745; x=1699310545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H4Xfwsz1oJlkefwpBB8y7aaULUoJ88otHslpIuLKkVg=;
        b=aOvHWq55TQ2mwcMTmDVWEEGzFDAwvu/+PT0K9OFcniO0qEpkB/2FosQZ10EBwxjbon
         ec9nFOOeYKnUwGzFaHnO4N4vIEGVi8u25/hbWPrGWonN3eEiyeNPk4Xq+pDL5Hb6SpT4
         gquehfFGz6bsRCcI6DiYD9F3PqkN9HouBDqWVoc7z45C0qZXHX4MkwjnJxrxU9wCl1wi
         ridXI2bHXKwpB5YtzUo5vpGq32L440CI7KZmgKU5/mVFJUKzMCzxdV8bz7ue5pAYpDip
         40MWYerrnUR6XlwmPw5tYbecwRfK9yyo0iWh5K4DdKTFWsVHS/BzSeebsbI5Atvz0Nle
         Jvkw==
X-Gm-Message-State: AOJu0YxOFuz2rstj6QFD1zr6X78aA5oekvN3RtHTUnzKbsYHpYzM4ece
        blQ5kgcZfXT7FNUfbnNq/LS0B4qiBbsM8cn7GdxjYQ==
X-Google-Smtp-Source: AGHT+IElSIreengSYfX3J9F+wjAA/z8qeUHV2jxyky2FMN1F5OkngNrqiAGehwXeGLl8fUjyDlcjlGhUu07FRU3iJEo=
X-Received: by 2002:a67:e0c9:0:b0:457:cd8b:57bb with SMTP id
 m9-20020a67e0c9000000b00457cd8b57bbmr8964903vsl.29.1698705744671; Mon, 30 Oct
 2023 15:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20231030023351.6041-1-ebiggers@kernel.org>
In-Reply-To: <20231030023351.6041-1-ebiggers@kernel.org>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Mon, 30 Oct 2023 15:41:46 -0700
Message-ID: <CABCJKufw9qsPKZw9iQVFWzVrp6Qh5LPWQY2yc+8Wadn5R7ecOA@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: hash blocks with shash import+finup when possible
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
        linux-crypto@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Sun, Oct 29, 2023 at 7:34=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Commit d1ac3ff008fb ("dm verity: switch to using asynchronous hash
> crypto API"), from Linux v4.12, made dm-verity do its hashing using the
> ahash API instead of the shash API.  While this added support for
> hardware (off-CPU) hashing offload, it slightly hurt performance for
> everyone else due to additional crypto API overhead.  This API overhead
> is becoming increasingly significant as I/O speeds increase and CPUs
> achieve increasingly high SHA-2 speeds using native SHA-2 instructions.
>
> Recent crypto API patches
> (https://lore.kernel.org/linux-crypto/20231022081100.123613-1-ebiggers@ke=
rnel.org)
> are reducing that overhead.  However, it cannot be eliminated.
>
> Meanwhile, another crypto API related sub-optimality of how dm-verity
> currently implements block hashing is that it always computes each hash
> using multiple calls to the crypto API.  The most common case is:
>
>     1. crypto_ahash_init()
>     2. crypto_ahash_update() [salt]
>     3. crypto_ahash_update() [data]
>     4. crypto_ahash_final()
>
> With less common dm-verity settings, the update of the salt can happen
> after the data, or the data can require multiple updates.
>
> Regardless, each call adds some API overhead.  Again, that's being
> reduced by recent crypto API patches, but it cannot be eliminated; each
> init, update, or final step necessarily involves an indirect call to the
> actual "algorithm", which is expensive on modern CPUs, especially when
> mitigations for speculative execution vulnerabilities are enabled.
>
> A significantly more optimal sequence for the common case is to do an
> import (crypto_ahash_import(), then a finup (crypto_ahash_finup()).
> This results in as few as one indirect call, the one for finup.
>
> Implementing the shash and import+finup optimizations independently
> would result in 4 code paths, which seems a bit excessive.  This patch
> therefore takes a slightly simpler approach.  It implements both
> optimizations, but only together.  So, dm-verity now chooses either the
> existing, fully general ahash method; or it chooses the new shash
> import+finup method which is optimized for what most dm-verity users
> want: CPU-based hashing with the most common dm-verity settings.
>
> The new method is used automatically when appropriate, i.e. when the
> ahash API and shash APIs resolve to the same underlying algorithm, the
> dm-verity version is not 0 (so that the salt is hashed before the data),
> and the data block size is not greater than the page size.
>
> In benchmarks with veritysetup's default parameters (SHA-256, 4K data
> and hash block sizes, 32-byte salt), which also match the parameters
> that Android currently uses, this patch improves block hashing
> performance by about 15% on an x86_64 system that supports the SHA-NI
> instructions, or by about 5% on an arm64 system that supports the ARMv8
> SHA2 instructions.  This was with CONFIG_CRYPTO_STATS disabled; an even
> larger improvement can be expected if that option is enabled.

That's an impressive performance improvement. Thanks for the patch!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
