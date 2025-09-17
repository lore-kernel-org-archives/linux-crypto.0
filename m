Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1BC2F25E9
	for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 08:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758098864; cv=none; b=LAy8jnCeyjE8RUn6dOE9cPM8E7M0V8SKf/eqINcnpAmmNFz/mLK9tAwlTmrIHg+wRbaBCeWybnNoidxZx6OrhZQWHNL4yAij1pNOPnYN6VHTK6zntAc7gNLriT2paNZnUrC7r61DgATzcfKfxovpTiWYvhhOUgOr6/Buz1DQg+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758098864; c=relaxed/simple;
	bh=mD1dKSaDbFABDNdxhBOrHC0pI1BKnXyc1MHH71Bb614=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eZS3kk/thMNGMGY5pZgmMYtRZ2ZiDpiny/SQE5YuDO1qB4iAvVKw8kTHyP6Mroxe7Ezu6ESBURfF1s82upFhW+2S17YG9ftU79ECzDWl5D2DmvgFGg9H5AzDe/Wgf8ojYBoW0IUef5GU8vwICnEFtfz5vfEU46srOb5MNNX203o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nMFHz4rL; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nMFHz4rL"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-787d9eab745so23169486d6.1
        for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 01:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758098862; x=1758703662; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSQBwTY7x8IQoxtsTDFfPaHwMvtropOKYFv/BGH9LuE=;
        b=nMFHz4rLjW9HxACLfiGmFUDToCY8xwg3npc15bK5XMjrlNTdzc/sYKlZNyYjkiJfGV
         04709FfI9hX4IQyLJ7g988v3DW+ZR9dju8jlw3jQkKIhABgqSomLxrvzNVlNclndI92e
         c58nFVIiq2itPPGMNki0u2UyFSgm03ZV5JC7j7UrBDtHRldm691Li1IU1NevcMlG+Q0r
         T9ioL2PauUpuY3pdIHhEoGaT3I3lNRfrShFnPUBnQ9xnlme1deOG7y2l5Km5miG10rZT
         Sw7KaDM/c7b4xNktgKwB+rMrN8eNbu28K+KoBe0GdhmPot3yrgFcifmKnCOIdEv/dyts
         l9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758098862; x=1758703662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qSQBwTY7x8IQoxtsTDFfPaHwMvtropOKYFv/BGH9LuE=;
        b=v22kaYJqDU7MhmlW0IrdB0Ydo4p8RvYmSYFRdK84WBtzc+APD/5f7FH8hyneHVNs0q
         PEJr/Q8yhZYx19vqOmKXszcDerS/fRYevZtjOGm6U4PNr9Y5qENqZ9meCh0ilQA+fyOA
         M+vZxKYuQw/xzTzHk0FlpNnyYQCh9dXUlExgz/AfokwZ5KA2pCa5yowjGYFq01t6Fr7w
         FxZiyqpdWplqS28g82PSqGSNTyRhzSBKF82rwiaxSuZmeRhzaaJdRQq6Yr5wq8K3bDmx
         d42FHFE9QRJEWASH2a3q5KsYYko8APMexJe8FUcrGUR5TcQqbKeIxTsLnx9Ual9+lhNq
         SL6A==
X-Forwarded-Encrypted: i=1; AJvYcCWcWAFh0/CSxVZruukujCxl8DnXtrz+Gsn07AMebcekANibHUk4gvCOucba3PmirdRuO+pqyy2+RMZXwdo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGZoW8bmdl9qIofFj5GFT/kytgEcLuiaFeD03rzIuhxmUvm2/4
	4NNle+x/+e1izR9ScA3foqulGIWOiDCbEbtxRu2faPzI4ykHWwzH7BESldoY5kiWNxgpPjSAQbj
	sMVGH7ElxFyOP0EtKMgqZDN5+NDNADxLCKZxaxiFP
X-Gm-Gg: ASbGncuLE8PiNRCJsoz15xIfiIcWEuGJjNhQL4JdnCj82p0HQa5kygc74cmXQgzzcyH
	duLJKUjNcaPhRZw1xm2Rel47eUK+572KzLWwQ8G61S/KpypmgwVFy7mK6JWp7oEDNy5D8nTkKSd
	2Y3+kEAo3+jbubiGgq6X9N2WEDMecNzgNcXzG21hnxIWyzgZz5AnHbMoVYWYS2y5+Se08ZWyIme
	0CDpft8ecehnS7IdeM4MAFa8PWiMVlOL/kBrqfCJe8=
X-Google-Smtp-Source: AGHT+IHQqM5a49OQaZzq5NlAj4f7mo4PVwkO0Od/qpE6zKcTcL2cYsdQMpOPx7K+APxdGyrFaBcGHMy5truFRbrqA1M=
X-Received: by 2002:ad4:4eab:0:b0:76f:6972:bb91 with SMTP id
 6a1803df08f44-78ecc6316d3mr11179046d6.10.1758098861793; Wed, 17 Sep 2025
 01:47:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911195858.394235-1-ebiggers@kernel.org>
In-Reply-To: <20250911195858.394235-1-ebiggers@kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 17 Sep 2025 10:47:05 +0200
X-Gm-Features: AS18NWCHIE1dESGpN9uvlB5H-Nyc3e2nakhbUlwz_P_LJD2Kd7WI7My-Di8UNK8
Message-ID: <CAG_fn=UY1HxmxpkM_YFGbr8W272F_bZgZHKiuvbsUjgFCs1RcA@mail.gmail.com>
Subject: Re: [PATCH v2] kmsan: Fix out-of-bounds access to shadow memory
To: Eric Biggers <ebiggers@kernel.org>
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com, 
	Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 10:01=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> kmsan_internal_set_shadow_origin():
>
>     BUG: unable to handle page fault for address: ffffbc3840291000
>     #PF: supervisor read access in kernel mode
>     #PF: error_code(0x0000) - not-present page
>     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
>     Oops: 0000 [#1] SMP NOPTI
>     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G               =
  N  6.17.0-rc3 #10 PREEMPT(voluntary)
>     Tainted: [N]=3DTEST
>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.=
0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
>     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
>     [...]
>     Call Trace:
>     <TASK>
>     __msan_memset+0xee/0x1a0
>     sha224_final+0x9e/0x350
>     test_hash_buffer_overruns+0x46f/0x5f0
>     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
>     ? __pfx_test_hash_buffer_overruns+0x10/0x10
>     kunit_try_run_case+0x198/0xa00
>
> This occurs when memset() is called on a buffer that is not 4-byte
> aligned and extends to the end of a guard page, i.e. the next page is
> unmapped.
>
> The bug is that the loop at the end of
> kmsan_internal_set_shadow_origin() accesses the wrong shadow memory
> bytes when the address is not 4-byte aligned.  Since each 4 bytes are
> associated with an origin, it rounds the address and size so that it can
> access all the origins that contain the buffer.  However, when it checks
> the corresponding shadow bytes for a particular origin, it incorrectly
> uses the original unrounded shadow address.  This results in reads from
> shadow memory beyond the end of the buffer's shadow memory, which
> crashes when that memory is not mapped.
>
> To fix this, correctly align the shadow address before accessing the 4
> shadow bytes corresponding to each origin.
>
> Fixes: 2ef3cec44c60 ("kmsan: do not wipe out origin when doing partial un=
poisoning")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

Thanks a lot!
