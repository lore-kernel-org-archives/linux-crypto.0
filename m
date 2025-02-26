Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64535270028;
	Wed, 26 Feb 2025 23:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740613640; cv=none; b=ZvgycWVeANK9t7aJFK+M0GIl99fpyZ53mEgH2LqNLRDaHQ80Kdo+T/9qyLF5fmjNtSutruUadXUf4+8XhkTteDAYYsMtfvZ+Xj2AgU1a2Mf4Wc+UPZs74YW/zWf0xqJwcdwgttXHtpYdAj5csAVkT2tcDYoGix5PeitcE9tc9RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740613640; c=relaxed/simple;
	bh=oUksBLA91DdVi78/wu0jy/FINTrgnDiQpK5Zeurc1JQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l2fOR0EJa15BTM6U1tVp3U8Hhdn1XPKpLRjErRAGcZhxcxuIaL2BhzHCs6Hp28NiQPHX/N2ynbTzM/7QsFZGtyaTvkTO1KyvawzuDzoiWKNNR0Eo8FqhTkrqeiHPOTRPnGPOmsopMiAV86IYz7hqU3SD+JZNZA9dq/+UpP2ICTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TwR6SWup; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TwR6SWup"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c04df48a5bso38653985a.2;
        Wed, 26 Feb 2025 15:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740613638; x=1741218438; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=liXUNycYFC9vjDNrycuN+V1sVb9jvR/WsQuvQlMOVkM=;
        b=TwR6SWupl06DrAtG+1ZpLd2u3ldgpB7d0GHCL1SfPZrgSbOUcu6osyBl2xuDpjSGGN
         7jazpU0tFhBU6r/6r5Xd9wIT3auNbqlIT/Fnc0n8ejMn9FDI8zuSljo20dat/6FAZrSO
         YBvvSwA1DIo6CwwWsXo8rrp898FKYCjeJDyxS/4dssMx3jidNxTe0p4cIBOSPmnZ6ahG
         Nwwv5NTEzOd1edPsp7FiLRMnxYDWO+ShLoW9kXQwyhCyQ1vOJZHrCzoq9Puf5nam0sI9
         /SiBpIsrXD9v41H0A4V040pcf+9x756Nr0543Gjvwir20zBX8PAwuhCHLfGiKiaopy4j
         apxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740613638; x=1741218438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=liXUNycYFC9vjDNrycuN+V1sVb9jvR/WsQuvQlMOVkM=;
        b=i8y/k67bOCuGqhFdW3t/M8+Nm8x4t+mr0gEZUqOnU6j4jYRiDFYZREUpffPFk++G8Q
         VHRdaLY6uT4s+5ksymwsSrTDr39PMxVL4XiR6k/aKD6stg0+LZxTve2sKjZQ/a7DPdSU
         0/rUM2HHwvYXglxr3lFLZD/s0k6PG74AXth5KfAc5I73Oke5QICOTM0Xa9c1CT4OwMjo
         sPSndQ8tmr4oi5pUC7JFZe3LwfADrxr00nY9OWgfnTi8cnPq+jg6H0K79ltvtNSNCiI4
         qk7uXrqSIlBAVCG/vSiQHocBXQz4fQKG1fgtAK1W0TKB6XXHZmYvWu/5QlU1K8T8ToZw
         v32Q==
X-Forwarded-Encrypted: i=1; AJvYcCU3VSL5KTz/RmynDujcBO1J6NgsGndacAbxS53BXYt3eETFfogS1aiDyjkOLsnb7Q7EEoKBeHdedCUXCR1d@vger.kernel.org, AJvYcCUZtuDIkxaXP5jJoiRJncYQaLHOP9Z+HTNZ5X706Ua2uetqkaFGF8aXF5aFxM8o5i9DKGJs0jppwK4iyXw=@vger.kernel.org, AJvYcCWjKlbb8J4qbVbNIL7AkRaW9Hoh+D3b4gSZyWH7a4ElmjdfAXefNtVTYB7R2oAOs4IFL5z0ogmb@vger.kernel.org
X-Gm-Message-State: AOJu0YzLFrYg2BowzBx0x+Fd76QFH1QMqO00OdH6rcCPWmtuBJYfKzpF
	uZOOWMe694PGkj4OOP2+3OJRcUfVI6UWOBcwpisRjpDpeZ1zzSAkHWYotXUrvEsnzEno5astF86
	m7JGZUhhvzGOPJb4mEZQo/TLjJOU=
X-Gm-Gg: ASbGncscFH9Mcku+bo4p8n6ohBzot6IkDuWxvix67lfShGwYSXEJxx7JYTZ0ngdAMfi
	tiGTRUYKhUsJ2gZ4TuCwCZyKVR+/6fyM8Q58OqslvOCwqQVto9v/DpH2h+v+7eKsiX8hE06zXPh
	32XLuhosfR6nLFUaHYU2Jvea0=
X-Google-Smtp-Source: AGHT+IFaza/mzOY4P7cX85X8N+cye/wkhSM/zT8ahz1vKD1VMVe06emD5Zm7qAX9AxwOYAPP284uKjDZVdQ8M6xLzmo=
X-Received: by 2002:a05:620a:4441:b0:7c0:99b9:c8a3 with SMTP id
 af79cd13be357-7c247fe7836mr819662585a.58.1740613638270; Wed, 26 Feb 2025
 15:47:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250226185625.2672936-1-yosry.ahmed@linux.dev>
 <20250226200016.GB3949421@google.com> <Z796VjPjno2PLTut@google.com>
 <20250226211628.GD3949421@google.com> <Z7-GaVJHC_1ynigx@google.com>
In-Reply-To: <Z7-GaVJHC_1ynigx@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 26 Feb 2025 15:47:06 -0800
X-Gm-Features: AQ5f1JqW3YIJaViBWFvZwwc9Y_BLX9n108G7cgjKGJSx-48v7AmcKBwq4pCS8uY
Message-ID: <CAKEwX=O8zQj3Vj=2G6aCjK7e2DDs+VBUhRd25AefTdcvFOT-=A@mail.gmail.com>
Subject: Re: [PATCH v2] mm: zswap: fix crypto_free_acomp() deadlock in zswap_cpu_comp_dead()
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, 
	syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2025 at 1:23=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Wed, Feb 26, 2025 at 09:16:28PM +0000, Eric Biggers wrote:
> > On Wed, Feb 26, 2025 at 08:32:22PM +0000, Yosry Ahmed wrote:
> > > On Wed, Feb 26, 2025 at 08:00:16PM +0000, Eric Biggers wrote:
> > > > On Wed, Feb 26, 2025 at 06:56:25PM +0000, Yosry Ahmed wrote:
> > > > > Currently, zswap_cpu_comp_dead() calls crypto_free_acomp() while =
holding
> > > > > the per-CPU acomp_ctx mutex. crypto_free_acomp() then holds scomp=
_lock
> > > > > (through crypto_exit_scomp_ops_async()).
> > > > >
> > > > > On the other hand, crypto_alloc_acomp_node() holds the scomp_lock
> > > > > (through crypto_scomp_init_tfm()), and then allocates memory.
> > > > > If the allocation results in reclaim, we may attempt to hold the =
per-CPU
> > > > > acomp_ctx mutex.
> > > >
> > > > The bug is in acomp.  crypto_free_acomp() should never have to wait=
 for a memory
> > > > allocation.  That is what needs to be fixed.
> > >
> > > crypto_free_acomp() does not explicitly wait for an allocation, but i=
t
> > > waits for scomp_lock (in crypto_exit_scomp_ops_async()), which may be
> > > held while allocating memory from crypto_scomp_init_tfm().
> > >
> > > Are you suggesting that crypto_exit_scomp_ops_async() should not be
> > > holding scomp_lock?
> >
> > I think the solution while keeping the bounce buffer in place would be =
to do
> > what the patch
> > https://lore.kernel.org/linux-crypto/Z6w7Pz8jBeqhijut@gondor.apana.org.=
au/ does,
> > i.e. make the actual allocation and free happen outside the lock.
>
> I am fine with a solution like that if Herbert is fine with it. Although
> as I mentioned, I think this patch is nice to have anyway.
>
> >
> > > > But really the bounce buffering in acomp (which is what is causing =
this problem)
> > > > should not exist at all.  There is really no practical use case for=
 it; it's
> > > > just there because of the Crypto API's insistence on shoehorning ev=
erything into
> > > > scatterlists for no reason...
> > >
> > > I am assuming this about scomp_scratch logic, which is what we need t=
o
> > > hold the scomp_lock for, resulting in this problem.
> >
> > Yes.
> >
> > > If this is something that can be done right away I am fine with dropp=
ing
> > > this patch for an alternative fix, although it may be nice to reduce =
the
> > > lock critical section in zswap_cpu_comp_dead() to the bare minimum
> > > anyway.
> >
> > Well, unfortunately the whole Crypto API philosophy of having a single =
interface
> > for software and for hardware offload doesn't really work.  This is jus=
t yet
> > another example of that; it's a problem caused by shoehorning software
> > compression into an interface designed for hardware offload.  zcomp rea=
lly
> > should just use the compression libs directly (like most users of compr=
ession in
> > the kernel already do), and have an alternate code path specifically fo=
r
> > hardware offload (using acomp) for the few people who really want that.
>
> zcomp is for zram, zswap does not use it. If zswap is not going to use
> the crypto API we'll want something like zcomp or maybe reuse zcomp
> itself. That's a problem for another day :)

I'm actually thinking whether we should expose the zcomp API and use
it for zswap. There are a couple of parameters for zstd I wanna play
with, which zcomp/zram seems to already support, but not the crypto
API (zstd level, dictionary, etc.).

But yes, a different problem for another day :)
