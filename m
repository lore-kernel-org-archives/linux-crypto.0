Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="Br1Ehm8M"
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99DB1B3
	for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2023 10:05:55 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-2851b271e51so64543a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2023 10:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1700676355; x=1701281155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sRia2Osk7RLncdx2O06OJMmemHtGkLvZU7Z5fC3vj8w=;
        b=Br1Ehm8MwjFtEwQk56uTiJczL2IqS2ok1I5FeQOoxfaWZVn0KEMMXIf7Ylu7fvtZ1v
         V7mCaOUSH05EgOhIZ2ONq1bfHkrMIZEgNq8XURSMPBL4SNKARZ7nSD2i+A8ppopxBb8I
         eeng3aqjBeF4UGvjhJ3+Mh/KoaFEtBlJYrvgV6y4mPuNYOTRbZDMDoR3sbxo/lGhOVw5
         db2ePGFogoxC85Xv5ZmiMa53Ogdi34Kd789ykR7HhnooEYxfIfGAxLWp2zH0DLN68Kdc
         20egNJQop8GD71vtb6FAT30HqQR7kv+BBMY4yX2CuqpgiBUfaGyjFjy1SHZBAnNdCpxV
         QKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700676355; x=1701281155;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRia2Osk7RLncdx2O06OJMmemHtGkLvZU7Z5fC3vj8w=;
        b=a/uCZG2YIrBultj0U0q2u+H/OFwVkwIKXvPBkQWZ+K6rjtxoFIET2Pb6qvC2g2w+uy
         U1kHVHJduQZLGeJgbm537vT7kiMYZUHMTilcLCbTBWqvh9RfVntZB2/9MoWg+DuSCiuf
         tYwCuxjDpcPaGfYm6HQB8ZSvGAN2fw98EtNPOHpFhzBKpokn87k3upbuRJ7GPr53chLX
         zYy8FRvFzR6PmgU2dCJyrc9I8+gS0mZqq9HYuXBCDw8NzHhjhhcjAl5LljemXBzKpaxe
         1VYSCgOeQfEXbr3FRiXWP2l5ag/p6IiSp6aOskbID4A7/7V0M2AEW5sURIgXRIK8QXAl
         tWrQ==
X-Gm-Message-State: AOJu0Yw837WceJ9wGogIeFMyEOVuE9jH5t0/IB0oxsemHAnFh6Dhkt5y
	eYLtP0GguS6Dq+nbu+3dlKUIZQ==
X-Google-Smtp-Source: AGHT+IFuh32jvNbuYQwaf2abCwtPo2iaOyP3NbHblJ1kjKy0eGzHgihIRy7Qu5I3jl5CSAZMf+hz1w==
X-Received: by 2002:a17:90b:3ecb:b0:280:735:bece with SMTP id rm11-20020a17090b3ecb00b002800735becemr267052pjb.16.1700676355055;
        Wed, 22 Nov 2023 10:05:55 -0800 (PST)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id jw13-20020a170903278d00b001cf5d508246sm6186562plb.224.2023.11.22.10.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 10:05:53 -0800 (PST)
Date: Wed, 22 Nov 2023 10:05:53 -0800 (PST)
X-Google-Original-Date: Wed, 22 Nov 2023 10:05:51 PST (-0800)
Subject:     Re: [PATCH 12/12] RISC-V: crypto: add Zvkb accelerated ChaCha20 implementation
In-Reply-To: <3BDE7B86-0078-4C77-A383-1C83C88E44DA@sifive.com>
CC: Conor Dooley <conor.dooley@microchip.com>, ebiggers@kernel.org,
  Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu, herbert@gondor.apana.org.au, davem@davemloft.net,
  andy.chiu@sifive.com, greentime.hu@sifive.com, guoren@kernel.org, Bjorn Topel <bjorn@rivosinc.com>,
  heiko@sntech.de, Ard Biesheuvel <ardb@kernel.org>, phoebe.chen@sifive.com,
  hongrong.hsu@sifive.com, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
  linux-crypto@vger.kernel.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: jerry.shih@sifive.com
Message-ID: <mhng-1c7aec6e-c2bb-4ad3-a458-7dce3cda0475@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Wed, 22 Nov 2023 09:37:33 PST (-0800), jerry.shih@sifive.com wrote:
> On Nov 21, 2023, at 21:14, Conor Dooley <conor.dooley@microchip.com> wrote:
>> On Tue, Nov 21, 2023 at 06:55:07PM +0800, Jerry Shih wrote:
>>> Sorry, I just use my `internal` qemu with vector-crypto and rva22 patches.
>>> 
>>> The public qemu haven't supported rva22 profiles. Here is the qemu patch[1] for
>>> that. But here is the discussion why the qemu doesn't export these
>>> `named extensions`(e.g. Zicclsm).
>>> I try to add Zicclsm in DT in the v2 patch set. Maybe we will have more discussion
>>> about the rva22 profiles in kernel DT.
>> 
>> Please do, that'll be fun! Please take some time to read what the
>> profiles spec actually defines Zicclsm fore before you send those patches
>> though. I think you might come to find you have misunderstood what it
>> means - certainly I did the first time I saw it!
>
> From the rva22 profile:
>   This requires misaligned support for all regular load and store instructions (including
>   scalar and ``vector``)
>
> The spec includes the explicit `vector` keyword.
> So, I still think we could use Zicclsm checking for these vector-crypto implementations.
>
> My proposed patch is just a simple patch which only update the DT document and
> update the isa string parser for Zicclsm. If it's still not recommend to use Zicclsm
> checking, I will turn to use `RISCV_HWPROBE_MISALIGNED_*` instead.

IMO that's the way to go: even if these are required to be supported by 
Zicclsm, we still need to deal with the performance implications.

>>> [1]
>>> LINK: https://lore.kernel.org/all/d1d6f2dc-55b2-4dce-a48a-4afbbf6df526@ventanamicro.com/#t
>>> 
>>> I don't know whether it's a good practice to check unaligned access using
>>> `Zicclsm`. 
>>> 
>>> Here is another related cpu feature for unaligned access:
>>> RISCV_HWPROBE_MISALIGNED_*
>>> But it looks like it always be initialized with `RISCV_HWPROBE_MISALIGNED_SLOW`[2].
>>> It implies that linux kernel always supports unaligned access. But we have the
>>> actual HW which doesn't support unaligned access for vector unit.
>> 
>> https://docs.kernel.org/arch/riscv/uabi.html#misaligned-accesses
>> 
>> Misaligned accesses are part of the user ABI & the hwprobe stuff for
>> that allows userspace to figure out whether they're fast (likely
>> implemented in hardware), slow (likely emulated in firmware) or emulated
>> in the kernel.
>
> The HWPROBE_MISALIGNED_* checking function is at:
> https://github.com/torvalds/linux/blob/c2d5304e6c648ebcf653bace7e51e0e6742e46c8/arch/riscv/kernel/cpufeature.c#L564-L647
> The tests are all scalar. No `vector` test inside. So, I'm not sure the
> HWPROBE_MISALIGNED_* is related to vector unit or not.
>
> The goal is to check whether `vector` support unaligned access or not
> in this crypto patch.
>
> I haven't seen the emulated path for unaligned-vector-access in OpenSBI
> and kernel. Is the unaligned-vector-access included in user ABI?

I guess it's kind of a grey area, but I'd agrue that it is: we merged 
support for V when the only implementation (ie, QEMU) supported 
misaligned accesses, so we're stuck with that being the defacto 
behavior.  As part of adding support for the K230 we'll need to then add 
the kernel-mode vector misaligned access handlers, but that doesn't seem 
so hard.

So I'd say we should update the hwprobe docs to say that key only 
reflects scalar accesses (or maybe even just integer accesses?  that's 
all we're testing for) -- essentially just make the documentation match 
the implementation, as that'll keep ABI compatibility.  Then we can add 
a new key for vector misaligned access performance.

>
> Thanks,
> Jerry
