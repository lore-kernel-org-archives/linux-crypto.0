Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD50370D55
	for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 22:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699175; cv=pass; b=GPrex7LXLWzftS3fhseFuuEOZu4qkZSguMEYTwpIlgoaLyErOg5QRAK+dE61MQ/Kmeqh/0aerBSKeU7GvvWoDY1z6pMtZOOl5DhvQXvBLwUZnjSRKEUoZdmC64Ul3qEv7YN4BpaQlAETWgxTR1OZxMumxJS58U8bG1vvTiD1Mhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699175; c=relaxed/simple;
	bh=rsp7Ihi8TSAj7hc2vakkxGqqL2oEkNH6XMA5zjqI1qA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjIQRX6zwnaaPjKPTGcMi0eiX984D4r104AXT5pZ+XC+AKdlWeCloGvHbSvedEvBE5SK/SwDX8lwwigxqO8euraPtnNpq6Xn2zKruaXBh2D6pwnbRa2TjQQ7o8yNHI9rHrxOIQf7wu4X+UDCMssFvTFCMXhPG7uKR0Sj66t26hs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXFirVf+; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXFirVf+"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-662b5bf4b10so9129252a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 15:12:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773699172; cv=none;
        d=google.com; s=arc-20240605;
        b=j9bYa2apyObnVtJVpYw6XCv/993BaZcXTyQmrs7GNUu+DlqvaC6YP1rR5NwDNdWgxz
         PXu4IT98Vjxw7zxgcsPuS4LW0/+PxtSHYOagAp5Y14yQpbjeKS9DK6EVvm9ebQRTZGn4
         3ei2r+I0wPY8RWsF77unNOYbRQn3JWKaC5yJMOm3ewCrzzhyhiwWgc3Dqm7qF8bE+vvk
         H0mnjpocz+4HEDxQg+HOJICY6GKf+tMQRch81KpsKP80Sd5ehRUYTk2vO+rPvOaPPPr+
         cbbTjPyqR5Dx2pdX4RhdAN4xwJ9IHD5ASHKrNHZyTsQwA/zlDWMmvwr4qxg/o9Rwce1/
         YrUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pAPcwDRyDaYRxv6m5ec0p6vencyIfyK+pU3obaup7wA=;
        fh=geuDEB/rchboLPNXx2lBVl2P4kFfpGhSygeixELIIIo=;
        b=DQmzoUrlkmTHEdJ/x5zB1SMokVQou78PuASm/Z4VPv+d4oiNtRDGS0UUFOskVTMYeg
         QI3EBzeRvb4XsawMaUvorXooB/lRHfi3PGwiUaK8NkjuMeacTMVT/92CyaLJqroS1W3Z
         7agfQ58FCd729kRB34QtMHnwLgYqbFlw5De5tP7/xiVx5HGFyJpGUZ5DWNqDm0/MzCUg
         3rIYYiWCeGi0nYjSnOa/HaMGXmdA3zXFL8cqDZjPUUO/wOQAjt11EdqdU4rFkpPiSUBD
         mdubml6WJaX8tq767Wkt0pCh+B5og4jxg3wniWAS4LXjAKsT26ieawEZg/DPXa5F7SRb
         OXRA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773699172; x=1774303972; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAPcwDRyDaYRxv6m5ec0p6vencyIfyK+pU3obaup7wA=;
        b=nXFirVf+3TZ7nayCWf+YAe8f5IxUtczrfP1EXNbBIrmwKiqwYyLnNpAauLND8FQtug
         qyiFy+esPMVr68OOOX82lIQLtv4g9BlFNZaBwo4KsXwCVqnfA/cnHzxN3Su9BCI72YRq
         auyRj61mHF94yEemJmjWC/U+E7H+3VcjkmPSPrWbYeT/sNINXe1KOC5DtsQxJjPZdVBP
         hNMRzTNBiyInnITmm9ONHtYXDRin1mMnPr1z331IK2KJiXXPmzS1yp1rdXfeMlAWA2Ci
         qg4RD1I8Hp+NegL76P7aa4Y8Cgz6Ykhx1YR2At11/HUaYDUKWkEbjQlI4WP+iffGCmKo
         wGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773699172; x=1774303972;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pAPcwDRyDaYRxv6m5ec0p6vencyIfyK+pU3obaup7wA=;
        b=kORQ6cGbMYNXO0jpSl/3uqk1B5wyUoJjf2eLIH/zbGqrsAy09VjY/wfYThSh2n/xjE
         pH0+MR77EA1xglsMNmbVjB77kg1F7UVrYtErWuD+KHQuEXdRJpWVs8vODdVNhpzjXFrv
         j1wOeWXAa9k7BKOkpZOILDpFMC/Cx/DbNZmkHJNRpUoULYHnAdtM1JI2udCEFJpf6fgD
         GTDSgcXO44YNy3vvoNNIUCY8lICFnfLiE740K+J9BVHS+AAMfdCMFYYa7RSyeQUQ7cs+
         Dm242X+fYT9lWf9+E8v/87TiWUnlmnXyN9g2OuoKz9jxrNac0vR3BWoTQVQ1T+xQzg4B
         hP+w==
X-Forwarded-Encrypted: i=1; AJvYcCUFGQ1EgLit4oHL/lWcoUqDNxfs0OA9VN1CXU/aKnUxfh+C0cpIG/odjfgNigPzi0qMvum7B+T03kAfFsE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtnZwJvc+tOxh1wkDYtHUFmuSrbkNXwcIamg7pkMpyRQp2oO17
	TLjsOhjc204eK+OF9Uy796Qh0u6w0oU3SvAgu7DYVgs7AjffQLKHycCUR8pDDk9G57SQhXlR94d
	4Ky/EIghhfi5zBiMI0RFEVPSup5sYo54=
X-Gm-Gg: ATEYQzwmj6NzVgQU6cK0ieEidfjnW5aGcdnv0MzZX9cpwQERwSVeEfdUufTImn/8sx3
	40QvPMzFzHbjg97BQWvo2C4ySJ28HifuVUOwawBqjyOXdrk6E76zqlkHh7C8/KEFzYUcHm4/4lZ
	gZV+PaVcfhLesco/8WgIKi7LZjVVldVacLAO6N+wc6ahqZLRY8mW6atY04/Wbwq0q4ncXNGFkK7
	TUsHlI/ghLEodKqs8WKc7nHiFFixSiu07vWrrdb9z0S1qVG8tWv4FuIzfShJBVVgNOn8PbouEXU
	EPD+aNdL15ANiVAG3dWtbxqcUrdnqG5Gy0kkVUGb
X-Received: by 2002:a17:907:1c0b:b0:b97:b515:31e with SMTP id
 a640c23a62f3a-b97b51509acmr346111966b.50.1773699172087; Mon, 16 Mar 2026
 15:12:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311070416.972667-1-hch@lst.de> <20260311070416.972667-11-hch@lst.de>
In-Reply-To: <20260311070416.972667-11-hch@lst.de>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Mon, 16 Mar 2026 23:12:39 +0100
X-Gm-Features: AaiRm53MOL-S4iIRiZrnVZNNZCm-cfe6kMQGe2L4WL9TC_xpq_akeJ994p2lXMA
Message-ID: <CA+=Fv5QkJm8+ysx8W=ypr84oSR=rrikfk-iMMU6_xrtS1PsWvg@mail.gmail.com>
Subject: Re: [PATCH 10/27] alpha: move the XOR code to lib/raid/
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Arnd Bergmann <arnd@arndb.de>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
	Li Nan <linan122@huawei.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 8:06=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Move the optimized XOR code out of line into lib/raid.
>
> Note that the giant inline assembly block might be better off as a
> separate assembly source file now, but I'll leave that to the alpha
> maintainers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/alpha/include/asm/xor.h | 853 +----------------------------------
>  lib/raid/xor/Makefile        |   2 +
>  lib/raid/xor/alpha/xor.c     | 849 ++++++++++++++++++++++++++++++++++
>  3 files changed, 855 insertions(+), 849 deletions(-)
>  create mode 100644 lib/raid/xor/alpha/xor.c
>

Hi,

I applied this patch and ran it on my UP2000+

The kernel builds and boots, and I verified the new lib/raid/xor/alpha
implementation using the XOR KUnit test, the test passed, see below:

[   25.705064]     KTAP version 1
[   25.705064]     # Subtest: xor
[   25.705064]     # module: xor_kunit
[   25.705064]     1..1
[   28.957992]     # xor_test: Test should be marked slow (runtime:
3.253413330s)
[   28.958969]     ok 1 xor_test

Acked-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
