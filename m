Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793743533;
	b=imQ2eYYF5E//DQvDWvBRy6O93ipiQc6wuER1Pmdkdz/6Fi1r3X57W8vCoOmPbcpUZLZC
	 YOMFdKOa5KGMEHV5eALsJ7OJgzm4lJYGdyFx4LOcBaCVKi5WjR8D2sIUiur3G5rzBU14A
	 zKMP9+BGB1g6k0yhsQCBnCgbf+gOFIG1DaJT8TwrnPb0UKWR7Vk5ZRAi2zj5H2YBZizgY
	 NXLBtaWpJrOmwMKg1mU10wZAMEm4V83NKQhYMGn7VtnUhe0pbNXsWcjYr2iSqOrCzHKje
	 /eLctGNb+tNjDKoyhSIU4zzuRpLHYbJbowhDg9gIrAAepzjQo4X/qTRX/SXF5dQHk+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793743533;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SNpO3k7KTdxpQD3zf1WdXzfgBBZWj3c4TeMM20zKnNg=;
	b=w9I5qH5hjTx9ROkZTtmPMAQkagqqOmf+Z3uLSfWnOR54akTJnxPrdNKRAB37qWbavbHx
	 K9WfCQi0UDx1S3YYwIt8bxS2KtOejoHseC0g6WXpWyhDjZaMK/CtD1q2r7iGcvbRqEN3q
	 MoZ8/gC+2hGZtuOJ0gl0RusZcQwvfUuE5GG19Q0cNmv/YSwDLmZgX726DqeG2arEOcKMy
	 qjmpJkInlT82wPTDWNmOYRNWxFmnK44N42EATXKIZDVxrNrdPFi1IpMX0BkA8e7pjED9c
	 FEMUcpRidrx2N4RlQKJnrux41BcRMev/zuas8g23JFhsZsZXd7/GuCjQ5R7l8r8wgrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ULb9BPZG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD291606EEAC
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 22:05:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD291606EEAC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ULb9BPZG
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5bfc3292d90so11991e87.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 14:05:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793743531; cv=none;
        d=google.com; s=arc-20260327;
        b=ILRwTFUwuN0SGiG6TWbHf9RmrpzmfiQEorwHE5vNfaR3aYxIiDr0JwbBxEv0iMSBxW
         96xOAjr6iOCHGPsHIoH4geDT/78hs3hwQt22bBTSgYgllDCCAy4Kv4ftpMekhv5xy2qX
         Sun71vUq2SgFNljLElau6m7z63xzEt8NJxfSIamnG/LsfXMKzwb5vB7gN1fW3ba/kCYM
         GXFitakv542NOwPOi6c2JzMbQyWgWHvQwqdqULgu/KtpLVNvS0LiBE81KahJGFyEa45n
         Y5l/UM26209gFDYLU27R78oWlGWAvQrNuFwsr+2Hz1v34E29wr1+cCK+VdJzcpbDdLPe
         FSiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SNpO3k7KTdxpQD3zf1WdXzfgBBZWj3c4TeMM20zKnNg=;
        fh=03lRut3q9jeHIA5oq3ULEGT7ZViotlFSEUQuypqsfQo=;
        b=m4GkLDrAbYFLsRQW0m6ES4fd4d1LSlasUvf9K8QjU4yBri8d/vPtsgw2pbiHfxlpqR
         HKRppWqGOUHwfOi++8nSD1V26GXZjqEvDK3okAhCdMIerjlBfPXS9tGBPQMXRBKsWf4D
         pKMF6L3ybtDAVEIZliexNtwsg5RqVh+CnnnBn3Sgggvb8yEQ6xnIbIb2ZL+Of/Q1fS6S
         kJh3HMjgmQJY1zJVYkk6511U0LDKoPeHo7hcsEKulhYryWsDgXfxHoifiN5ABEylgJpt
         ce3M6RnDaFr+BI1tpuIHFAo4QF9W4Nje93mUFYoSNf/S4YzWDOoJ3Dh0SYI50uNXEKHp
         ohZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793743531; x=1794348331; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SNpO3k7KTdxpQD3zf1WdXzfgBBZWj3c4TeMM20zKnNg=;
        b=ULb9BPZGWYRGt2VMkR/0Y9smJkiS/qf7Mc9DY++NltbkDEHoGROLCKlKDZkqEJ3Gbe
         HmXX6dsQ7PYIRG3yb9PHYzsJz5UMb5vlzEa2+VdT9kVwwiYfTi4zMiP0ZcxlAs/6OsMo
         jmXXlboS4CGZ7o87ULQ/qBkPg1Xd1RWYQPyKi2AJRkmS4b9YP3wGXL8XgE5jWGmDBn6N
         X+a0GIho6o/+9vKbgyymXo+nKe9UjZVq0T4QgTRXaSkcKtIak2EcKfFWTdq0JusXyUvp
         Q50ptiQrHe6egeDm8aJB7erRudyYvCsO9oNgIGFju7vqkN4m3az51rS5lLfP/QMiACR5
         EHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793743531; x=1794348331;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SNpO3k7KTdxpQD3zf1WdXzfgBBZWj3c4TeMM20zKnNg=;
        b=fjXyhgsrwaPzL8+9lDYBSTaAN6QsUoqsJOPvdIVsNgHAWHxzJz5zhgCSiPHHRq3bTy
         U/AX7fE6yJaAMh/BRWapbOjdfmrntnG4/pmNsefnKxj48zI85YlYwyRuNFPYq34X65za
         gNRCin6W8h8iKks0VrQ2EFrmarrrlvBuNbdfSrYsBCZaTG/efeyZ97lddG3g/cwQ+1Ae
         QY46e0c6Unt6ruUTipQxv8cy3ZycsXuwvL3HzlxK63QcKNphxHJ992GUX0etSf5n12HI
         ikIVdJluvF5GAIZECw4anLaJicaoCscqpw0lcnujDBsJlsVliNr0aRokvDZail9ZPGZB
         A0hw==
X-Forwarded-Encrypted: i=1; AKwUvBwPkQlssM/rceDzqn6tVHswhMCbjG+TAb6+q74907m0tcVyB08gjvISWre7KNgblo8OwDbbQYF++pfDBQM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+z6XUwu+6jQWpey9UPXQYCAONW8lH1++FtLXoYRPxNKAaz9Z11
	bTx1y5zg5BMQRKJsnqO4EPUDy3pjzWtRxJ2/PacKyuWdUCWJud6Ivm04Z2pAYsoYA+wo9kHS/Ww
	fHsPbkTSRqAght02H7vRKA7EWxhxUpkI=
X-Gm-Gg: AYBFou1rOswpYkaUxs8wBn7JenZVDCzFlmGy7HxBzHfZZXDhCG9CXrJzGwP+v1rT0SP
	c5fcG+kziV/zAcaehATFo5g3zbdzya6G5zD/O9QM8LHn4oK+WA7vPYAz+eSdGtFPR2h61DZPi1Z
	7u+Clht7e3+q6o979n4jHDpxaGFgz9gX0fVrBFrvZiD9G7z8P8DnnEW/TUcQI8EWea0IS526JO9
	WoCyuWidiC/mxfzZhur0rrqij8uH0dhwj8p/AQGJdEtOjf/oTDSXZAk4uZ7f4+uHgx4YpQuX85c
	gSdQHg0FFX5OcO8U9RE84u7IbPWgFPk7nTnESjIF6ZVzQdr5O0//7+1Emxnz0n/xVImeV+4CLQ3
	iegScjLNADJ1AxgF26g6AgLV1hxWwp/CKagM4
X-Received: by 2002:a05:6512:131e:b0:5bf:cabe:23b6 with SMTP id
 2adb3069b0e04-5bfd9569866mr4812334e87.33.1793743530815; Tue, 03 Nov 2026
 14:05:30 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261013002140.28880-1-kanchanapsridhar2026@gmail.com> <20261103142600.279899-1-usama.arif@linux.dev>
In-Reply-To: <20261103142600.279899-1-usama.arif@linux.dev>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 3 Nov 2026 14:05:18 -0800
X-Gm-Features: AclHuK_KqFdN8VFfpR0ggkVmcMetMCn8gBaDmQi35Rpfngre-ekOfLRqKDMkPbc
Message-ID: <CACpmpodmeJB5FssJdfFxF+A2PkrC+=hnWGn=F_fTbbEtDfRF_A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and
 decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, yosry@kernel.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, senozhatsky@chromium.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, kernel-team@meta.com, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 6:26=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> On Mon, 12 Oct 2026 17:21:40 -0700 "Kanchana P. Sridhar" <kanchanapsridha=
r2026@gmail.com> wrote:
>
> > On Fri, Oct 9, 2026 at 6:31=E2=80=AFPM Usama Arif <usama.arif@linux.dev=
> wrote:
> > >
> > > Stores and loads serialize on the same per-CPU acomp request and mute=
x.
> > > A low-priority store can be preempted as soon as the compressor drops
> > > its stream lock, while it still holds the mutex. A higher-priority lo=
ad
> > > on that CPU then waits until the store runs again, which can take a
> > > long time when other tasks are runnable.
> > >
> > > Give compression and decompression their own request, completion wait
> > > and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> > > decompression APIs from zsmalloc"), the per-CPU buffer is only used f=
or
> > > compression, so group it with the compression request. Independent
> > > requests can share the per-CPU transform; the codecs and drivers
> > > synchronize their shared state internally. Loads can still wait for
> > > each other on the decompression mutex, and stores still serialize on
> > > the compression mutex.
> > >
> > > acomp_request_free() ignores NULL requests, so drop the check in
> > > acomp_ctx_free().
> > >
> > > This follows the proposal from Sergey Senozhatsky for the same split
> > > for zram [1].
> > >
> > > [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@=
chromium.org/
> > >
> > > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >
> > I have a question with regards to this patch. Is the intent to allow a
> > decompress thread to run concurrently with a store thread for a given p=
rocess?
>
> The request is shared by tasks using the same CPU and zswap pool.
> These may be different processes or threads of the same process.
> Each operation still runs synchronously in its caller.
>
> The motivating case can happen entirely on one CPU:
> 1. Task A compresses page X and releases the codec's stream lock.
> 2. A is preempted while still holding the zswap request mutex.
> 3. Task B runs and faults in an already stored page Y.
>
> With the shared request, B blocks until A runs again and releases the
> mutex. Separate requests let B load Y while A's store is unfinished.
> The codec/driver still synchronizes its own shared state.
>
> > If so, I wonder if incurring context switch/PTE/TLB shootdowns performa=
nce
> > penalty is worth it?
>
> The switch to B already occurs with the existing code. This patch adds
> no worker threads, forced migration, PTE changes or TLB shootdowns.
> It avoids B's subsequent wait on A's request mutex. The 1-vCPU
> benchmark in the cover letter exercises this without CPU migration.
>
> >
> > With the proposed change, will zswap_store() continue to run on the "ol=
d" CPU
> > (i.e. the one to which the process got migrated), or is it a requiremen=
t that
> > the "old" process is in sleep state? If so, should we codify/document t=
his
> > requirement?
> >
>
> There is no requirement for A to sleep. A can remain runnable while
> preempted. Its zswap_store() invocation resumes in the same task, on
> whichever CPU the scheduler selects. If it migrates after selecting
> the context, it retains that pointer and the corresponding mutex,
> as the existing code does. The same task cannot execute on two CPUs
> at once.
>
> > On the new CPU, is the same process "runnable", and if so, how do we en=
sure that
> > the "higher priority" decompress is handled while the zswap_store() pri=
or to
> > preemption is still not done?
>
> Normal scheduler policy decides when B runs. Once it runs, the split
> removes its dependency on A releasing the shared request mutex.
> A load starting on another CPU already selects a different context
> today; migration is unnecessary for the benefit described here.
>
> Existing folio/swap-cache locking still orders accesses to the same
> page. The example above concerns two independent pages.

Thanks for explaining the motivation for this change, and the detailed
analysis! Is it possible that this could cause compression contexts to
be starved of compute resources under memory pressure, potentially
causing deadlocks with page-faults in the worst-case scenario? Since
compression is inherently slower than decompression, could this be
making it easier for swap page-faults to preempt compression. On a
related note, should direct reclaim (only) be allowed to use a
non-preemptible context via a spinlock?

>
> Thanks for the review!
> Usama
>
> >
> > Thanks,
> > Kanchana
> >
