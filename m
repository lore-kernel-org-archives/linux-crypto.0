Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E9F26982C
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 20:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010393; cv=pass; b=XJjwFQRcHJwqUC5A4kIJlX/aR+01l4VbKaOMajAcs7Q+BtDET9q+oZplNlwCHvnX+nboisKb/Nbdn2941pHhTa8twDZpe5JDMkChuRk9+XozeUt53ZnN0FE8VvhCK0gOUx2aMNMTGx/RUT1YMIDNTdHfufX0yyt4ml7lt/aCuHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010393; c=relaxed/simple;
	bh=kHScfoW5QFIW3Mr69IJ6gRNLJcbVSehxc7L4Ub2Bs/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L+TEHq9sEL/m6zY4ZojDLYr5vPjeXRo/70RPTEvBc475MoyH1Hy70SnEM/uiOpFaYr7fYj2Pat8Q9bKWCz8AwX+m4gX+Ljk59M/OESmKRcOPn/aeLpZyiMo4B6BPAM3WPfdVnG7sCy7zvsm2AK3u4aFiNlqUl0MA8uYlXGFtjn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=genproof.com; spf=pass smtp.mailfrom=genproof.com; dkim=pass (2048-bit key) header.d=genproof-com.20251104.gappssmtp.com header.i=@genproof-com.20251104.gappssmtp.com header.b=U7F475Od; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=genproof.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=genproof.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=genproof-com.20251104.gappssmtp.com header.i=@genproof-com.20251104.gappssmtp.com header.b="U7F475Od"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91986c5cb75so8574736d6.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 13:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792010391; cv=none;
        d=google.com; s=arc-20260327;
        b=GI8pVf3iw+PAUc8k/Ltl44qUjFFwxDSIJd9c1nZKJnqzXT43bvWNDKQ4ikHQPaoOlx
         ALeEkuQSNRdWBkOjLrQTyAYFY0vLkW7TdgihOe9Ti3x5U48zsv9vKYoHND2vmPXVsKm0
         jdC/QibI5dyP7+tWe4Jc19U8K3febpxIjAl+ygrc5E3OGA7Q/Z/gNv1lMUvBrMntH6gz
         XTLFEdc7RIoqNiJCjiqoK1rRDpBtbOfnfirLVt8GogAdCfGATLFHSYGSU5NYFqa1GCQA
         9Rgug4Gkrey0o9T7H/09HGxj1X+m62Xvi+CAguiKXZgNy80EeCqve4h1LchjknmjYhD6
         7YVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Hvbv4h83/gh3e9PL4i/Jed17SUFA0/98By/JOQOBZh0=;
        fh=wyWsXAgja5fTTsOZNbb2LupfyLsh27Te7okfNdMlF1U=;
        b=S+0ZBIGY6WJj6xVRlXbTYIPCtOmEfrpC2IKPIG26LYxS7jhhdUQnHlGf6mvR+ZuEg7
         xPxCABHUM+njebYgi23RfgtftfqXKKp2qN9nxPyCMSJd/pDunCwTUxqKBkRkldOjddu9
         0fGfZ6C6WONWnU2SrFBStK5deFjxw4F7+9Gnt30dl6W+xmK1hlgBGOfxKF9jgAdIsFBn
         XJHvyjbMkt0aGE5+THfD5iV3gZ0AmSaipltEAzqcBnWmUNkWMLaDdziwywRFskwupKkg
         Ooyr9yD4DHvQKKQzM6VVv+YGrkGXfUoc02PP6/V3FtzpFgFpiqd9gDxua2dDypFTnImy
         Vb8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=genproof-com.20251104.gappssmtp.com; s=20251104; t=1792010391; x=1792615191; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hvbv4h83/gh3e9PL4i/Jed17SUFA0/98By/JOQOBZh0=;
        b=U7F475OdYf5kb07nThOQvtR0WFPPyrqMnHZjQXQgOzINTPbb0DY8LoFFI5o73SV36+
         VXe7kk3owmDCKmzmde08X+A40npWreGlmfAqsG2EVl1zAjHeyrc3irmnjs/z+MhHYj+z
         LOsFcfDvSwc2lnT7OPa5YKirDwMks2y0wmZytdsbyInUL45lsLWveKAQI65tamLzp+jB
         2oR3qiaAVNCXFaZEHm6AWQIlpyzIMpZ6O0lpx0iZYYbsgn9HVbW/y6DwtM2Qn0p8nSJE
         2lEPbDL/AwR6hMkwocn22Q7QPyTLsAFAkrWcGnDzx68YJgk2ZMOl4xUCcW19unKlf2YJ
         VIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792010391; x=1792615191;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Hvbv4h83/gh3e9PL4i/Jed17SUFA0/98By/JOQOBZh0=;
        b=HqURsJ7YwwQv+aj37ulLU1bqFqEparDSKQa9te+Gqfn8WQIiiStzmJ8E6siTRTjPUt
         BujJ9+Hh1QFLODr4AfSf7chtSu81bVdmG37N8Unu2OzIZOlngsTm7U2GLVqXwcAFn8O4
         rzhJgKAafPtf/rogdFAoyTM7X6FgvrLpw0NkdZwWIal/KcVhKviWGBaeRD3eQhP7mCuC
         kdAq4oiQSUAyq/HCjW5/0ViOrRSRg0gZJSCGgcA17Ms5HMOPccoshGr0JqbDlhOgsyBB
         wV+q+q1UziMDhvuGhvzQReS4kzzvAaPuVQwHwD3qOw6+vyi8ohgbjYbjFeY2ACu5j25h
         gjSg==
X-Gm-Message-State: AFq9FYKDHW0mmqgHOJ0fDpofUK5P4fYa7vOZqhu359ic46chQrnmK2aQ
	xlFaMst5IFiBDedh9Ot/TxqhKpRUaG0rHSSXXGZ8w3Kh/mdOq+GJmPXMjnRPwNIDKl9h7vFSLJq
	F2yAQV23aYJNqf2YsTPSF71rxHDKQEXujPp6rgTXpJ0o=
X-Gm-Gg: AYBFou2EbgtJ0KVSRrUVSmCMy0xHuJ70A6qfFUkhnbhkylUb/vAUSnhMH6hvDDZu53+
	r8/MJAUjzBab3SKPpMWn7EbVRbhFnyE7mqoCs45Z2KzMrVgknC9a0telMsalb3HiZIhCOKT3ZcU
	wFD17zoWkIYDi1lvxffrT4pvjDrpFoHApgDNwCrTAI6Noi+YBezXUGybTICoL1T+sVIkz2XC37f
	CFasp50Sw7/P1lC4X3QMyemKcboclh/FxIaLFxZWewJ2tdNU70smpmqPmIaOy5w9XH7WotNs2Na
	Xr2E9QEKaefkEhHQumJWvMigrrGwIGG+VwZ1tSxd/IAlXby6mcp+oWoYUIysZdIDpQcAVRc5/jt
	YvvOWoWhdzKgr
X-Received: by 2002:a05:6214:5082:b0:91b:80ac:66ea with SMTP id
 6a1803df08f44-91b80ac67d2mr172010016d6.24.1792010390916; Wed, 14 Oct 2026
 13:39:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014152604.323310-1-ebiggers@kernel.org>
In-Reply-To: <20261014152604.323310-1-ebiggers@kernel.org>
From: Vladimir Kukharenko <vladimir@genproof.com>
Date: Wed, 14 Oct 2026 22:39:39 +0200
X-Gm-Features: AclHuK9hyj4qEGknIGYgSBtc9GBfZkkTP8Pl6YErh1Uue02KgFYR-0JbdSeWHNE
Message-ID: <CABB2QaKKvuTFt5fHa6+=n3siom4TFYCqZ67bcHyHTrD+PogojA@mail.gmail.com>
Subject: Re: [PATCH 0/2] lib/crypto: Use size_t lengths for Poly1305 and ChaCha
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

Sorry for not replying to your question on v1. I was already reworking
the series in that direction and should have told you.

Thanks for doing this. I tested your two patches with the lib/crypto
KUnit tests in QEMU on x86_64, i386, arm, arm64, powerpc64le, riscv64,
mips, mips64, s390x and UML, plus temporary tests with buffers over
2 GiB and 4 GiB. Everything passed, except for two things that fail the
same way without your patches: the POWER10 Poly1305 interrupt context
tests (I force-enabled that code, which depends on BROKEN), and two
Poly1305 tests that crash under QEMU with AVX2 because of a QEMU bug.

Tested-by: Vladimir Kukharenko <vladimir@genproof.com>

One gap remains on 32-bit arm and MIPS: the ChaCha assembly there
treats the length as signed, and size_t is 32 bits, so lengths of 2 GiB
or more are still handled incorrectly. On a Cortex-A7, which always
uses the scalar code, a 2 GiB + 4101 byte in-place chacha20_crypt()
changed only one byte.

As a suggestion, I've sent two small fixes on top of your series:

- arm: use unsigned conditions in chacha-scalar-core.S, and
  DIV_ROUND_UP_POW2() for the block count, since DIV_ROUND_UP() wraps
  above 0xffffffc0.
- MIPS: the partial block code also relies on the sign of the remaining
  length, so a small C chacha_crypt_arch() passes the assembly at most
  1 GiB at a time.

Feel free to fold them into your series or handle it differently.

Thanks,
Vladimir Kukharenko
