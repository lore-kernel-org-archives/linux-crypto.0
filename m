Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="AJ5CJHSD"
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29101A8
	for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2023 09:37:41 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1cc5fa0e4d5so81685ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2023 09:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1700674661; x=1701279461; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YB+axD1Vcc97GiHQ3MbqEUMAVWCgEbLU/Yl6K+bGqgI=;
        b=AJ5CJHSD40bQf0osWlhqm5fgwJfC41Rii+W6khK47Sa4yANV9Zc2Rko5iOy5ZYsbvS
         DpgjjSqObdeErInOP57p3EEwrWL/Rq2uN1r2P89TJ44ththbu+fUbHpMlA57qrerQLVs
         Uz5VqXmA3urKZryUyKLiTjvM8bV3nlPJw9nGufOkpiHkvBMjVVmSNFEilBsjmYedx9Yu
         NCaZOPeNZ/pHq26gxK7gPG4uzWXMOtJ+t5Iih7nt2z48wwOQstgS5FPN3zwPRmgqtZFN
         +smpG/KVv4ZV1u9qDoO+WQYQunx8eVBdZ95u69WA2Pg5gMwTClHNNRpXtyWFpTwCixLM
         mZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700674661; x=1701279461;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YB+axD1Vcc97GiHQ3MbqEUMAVWCgEbLU/Yl6K+bGqgI=;
        b=mjWtyow/+1iklq0r6N1e0F1c9KiDdf8cshedlTY+Y8A0H5MpoDFwUKu9CCnqjTN8Xg
         VDTvXT6OBdYPlQnI0fzda5RNsbj9htiS+uvTpQGXRZuVU+Wu2Mv5g21m9bzqWYP9umTB
         psNgTWUP7Tk84w7gn5tAHgXVA87HO1EgBGaGm646Jqtfgt79ASqk+N7nn4LdPXplQ5ww
         nsb4QQ6dkLsXIksHkCgcTcqMydOVtcZAGLCI+GD6E9dlCHXkGl3GSzRIS8c/MbkTuJ+L
         wGA6MEBLRkbpXEg61LZCwG6pZUn2+AeXppJIUtAZm3WFYV+jKgbIklkEqoMcs/J464lC
         pFRg==
X-Gm-Message-State: AOJu0YwXODjnOfSqSg4ttxJtdlSr7dVBzbMZZ7xaXjXXFUjjRHYMNY/7
	XceQvwP4FvvQeiC1X9BD328zYj86zhaQldAKVz45HA==
X-Google-Smtp-Source: AGHT+IF46NJ+qL5ZN5PT+NT5x4N0gK+lFvsXp00qpP0ZTSDTMzWCcTLDobwk4fc21ZcVVM0Kfc+aRw==
X-Received: by 2002:a17:902:bd06:b0:1cc:3544:ea41 with SMTP id p6-20020a170902bd0600b001cc3544ea41mr2553752pls.46.1700674661156;
        Wed, 22 Nov 2023 09:37:41 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:5a5b:a845:b3e1:8307:922c? ([2402:7500:4ce:5a5b:a845:b3e1:8307:922c])
        by smtp.gmail.com with ESMTPSA id 19-20020a170902c11300b001bc6e6069a6sm8165114pli.122.2023.11.22.09.37.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Nov 2023 09:37:40 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH 12/12] RISC-V: crypto: add Zvkb accelerated ChaCha20
 implementation
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231121-knelt-resource-5d71c9246015@wendy>
Date: Thu, 23 Nov 2023 01:37:33 +0800
Cc: Eric Biggers <ebiggers@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 Albert Ou <aou@eecs.berkeley.edu>,
 herbert@gondor.apana.org.au,
 davem@davemloft.net,
 andy.chiu@sifive.com,
 greentime.hu@sifive.com,
 guoren@kernel.org,
 bjorn@rivosinc.com,
 heiko@sntech.de,
 ardb@kernel.org,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3BDE7B86-0078-4C77-A383-1C83C88E44DA@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-13-jerry.shih@sifive.com>
 <20231102054327.GH1498@sol.localdomain>
 <90E2B1B4-ACC1-4316-81CD-E919D3BD03BA@sifive.com>
 <20231120191856.GA964@sol.localdomain>
 <9724E3A5-F43C-4239-9031-2B33B72C4EF4@sifive.com>
 <20231121-knelt-resource-5d71c9246015@wendy>
To: Conor Dooley <conor.dooley@microchip.com>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 21, 2023, at 21:14, Conor Dooley <conor.dooley@microchip.com> =
wrote:
> On Tue, Nov 21, 2023 at 06:55:07PM +0800, Jerry Shih wrote:
>> Sorry, I just use my `internal` qemu with vector-crypto and rva22 =
patches.
>>=20
>> The public qemu haven't supported rva22 profiles. Here is the qemu =
patch[1] for
>> that. But here is the discussion why the qemu doesn't export these
>> `named extensions`(e.g. Zicclsm).
>> I try to add Zicclsm in DT in the v2 patch set. Maybe we will have =
more discussion
>> about the rva22 profiles in kernel DT.
>=20
> Please do, that'll be fun! Please take some time to read what the
> profiles spec actually defines Zicclsm fore before you send those =
patches
> though. I think you might come to find you have misunderstood what it
> means - certainly I did the first time I saw it!

=46rom the rva22 profile:
  This requires misaligned support for all regular load and store =
instructions (including
  scalar and ``vector``)

The spec includes the explicit `vector` keyword.
So, I still think we could use Zicclsm checking for these vector-crypto =
implementations.

My proposed patch is just a simple patch which only update the DT =
document and
update the isa string parser for Zicclsm. If it's still not recommend to =
use Zicclsm
checking, I will turn to use `RISCV_HWPROBE_MISALIGNED_*` instead.

>> [1]
>> LINK: =
https://lore.kernel.org/all/d1d6f2dc-55b2-4dce-a48a-4afbbf6df526@ventanami=
cro.com/#t
>>=20
>> I don't know whether it's a good practice to check unaligned access =
using
>> `Zicclsm`.=20
>>=20
>> Here is another related cpu feature for unaligned access:
>> RISCV_HWPROBE_MISALIGNED_*
>> But it looks like it always be initialized with =
`RISCV_HWPROBE_MISALIGNED_SLOW`[2].
>> It implies that linux kernel always supports unaligned access. But we =
have the
>> actual HW which doesn't support unaligned access for vector unit.
>=20
> https://docs.kernel.org/arch/riscv/uabi.html#misaligned-accesses
>=20
> Misaligned accesses are part of the user ABI & the hwprobe stuff for
> that allows userspace to figure out whether they're fast (likely
> implemented in hardware), slow (likely emulated in firmware) or =
emulated
> in the kernel.

The HWPROBE_MISALIGNED_* checking function is at:
=
https://github.com/torvalds/linux/blob/c2d5304e6c648ebcf653bace7e51e0e6742=
e46c8/arch/riscv/kernel/cpufeature.c#L564-L647
The tests are all scalar. No `vector` test inside. So, I'm not sure the
HWPROBE_MISALIGNED_* is related to vector unit or not.

The goal is to check whether `vector` support unaligned access or not
in this crypto patch.

I haven't seen the emulated path for unaligned-vector-access in OpenSBI
and kernel. Is the unaligned-vector-access included in user ABI?

Thanks,
Jerry



