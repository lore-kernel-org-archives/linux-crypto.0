Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A587F47A894
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 21:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791925268; cv=none; b=YJ4orENeF8qEriwL5q2Ivg67sRjNA3gudGcOKPu9ZcrDCSZ4d7Gwk6vlbcVXlXLE12kIPpHYiVMg7ZJRYCfOsYQ1R81f0lHEx7gv7f8VSRalYDlFTUQ90nkE1hFMKt3DqCCwjXJ6vnmEkHqvIPn8PwoeCqYfLt5XsgRFhANTMRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791925268; c=relaxed/simple;
	bh=otzqAwHTarH+nPjYAj7PC0qYusRb59jP1GBa3Q2bM/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A4QeEI1NUOounoe3qq6xF3oP27VzYntRBZZFTMj5hvtLhzAIU7csdt5734Sxb4K0VJWvYkxEuzJ7bbC4FmIOlSVyDGxEet0NmVM1FNTaVq8gw9mEsPlCo9HlPGfAC6202v3ZSFzibmUpg6wszFI+w2DnLhhXehwQXpV0tTIxizs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ze+YyELs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ze+YyELs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D231F00899
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 21:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791925267;
	bh=otzqAwHTarH+nPjYAj7PC0qYusRb59jP1GBa3Q2bM/8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ze+YyELsWXzooRsH8Nwdw8sHpfqQhqX57KvCfNiePy+9l8l0oZs5QDWKMeOOMtJCZ
	 cp9PdgMMnYugE36LIjYfY+bK5/6Bat85gwbdTJRibl+Uf2I9JiUQl/xtsQ3EkHAtAv
	 w0chzgxOlJL+dtI5vxqJgRiychRWf+GrCt6N7MQs4rOflSwAJEYDAZrrbZpyt4mtvS
	 9JYZsHtCMHYZ1njOEW7iGJS6evqzPdlPDMv8j6pcIRQCipPYeF3ZDIyUGHukAYefim
	 HS5s3JwhamteA4n2ZcMBEwFVohicWzhIZ/A1AV4nHmaof/WvK5FcN/jbAs1f5tGVgL
	 MpkjoRUKLClrw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2e5e801487so514055966b.3
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 14:01:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzsDzuloniyMLdR/TgZjmx7+MVktfn7gz6fogJX1Ab8EFAHFJMdWCLL/zpXXh4MNBWDcURHImKv3pFhxxk=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ0BwKIjuaNqMBVRdyfSZNFS58T/zykBm8D9NCgyONLl/a6rExg
	L4YUeblnuU1fjSwNpDcb1qlPUAWxn59KX4rgwN6y6WnemK66f2Ns5wDGb3tnIruRkzGgkz+/T09
	gtnJNwJaM4egxgz+wQOzuWtw0wxxQ2D0=
X-Received: by 2002:a17:907:7b8d:b0:c2d:d9f4:2c85 with SMTP id
 a640c23a62f3a-c31aa0c129fmr1295928366b.41.1791925266214; Tue, 13 Oct 2026
 14:01:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261013151007.2093943-1-usama.arif@linux.dev>
 <20261013151007.2093943-2-usama.arif@linux.dev> <CAO9r8zM-utRFYGBfaEb=89LWM0DOKc8dywcDLSb6L7f4c80yuQ@mail.gmail.com>
In-Reply-To: <CAO9r8zM-utRFYGBfaEb=89LWM0DOKc8dywcDLSb6L7f4c80yuQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 13 Oct 2026 14:00:53 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO5HgtH0-jgCrj1uyv9fjUrHCxSZA21mWpDVU2B7qS7Ww@mail.gmail.com>
X-Gm-Features: AclHuK81jQ6rnaJmrP6r3K2lHMSwKc6BJEWDK7sFlCmG2sgXzWUx5CcLolataic
Message-ID: <CAO9r8zO5HgtH0-jgCrj1uyv9fjUrHCxSZA21mWpDVU2B7qS7Ww@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: zswap: use separate compression and
 decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 1:57=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Oct 13, 2026 at 8:10=E2=80=AFAM Usama Arif <usama.arif@linux.dev>=
 wrote:
> >
> > Stores and loads serialize on the same per-CPU acomp request and mutex.
> > A low-priority store can be preempted as soon as the compressor drops
> > its stream lock, while it still holds the mutex. A higher-priority load
> > on that CPU then waits until the store runs again, which can take a
> > long time when other tasks are runnable.
> >
> > Give compression and decompression their own request, completion wait
> > and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> > decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> > compression, so group it with the compression request. Independent
> > requests can share the per-CPU transform; the codecs and drivers
> > synchronize their shared state internally. Loads can still wait for
> > each other on the decompression mutex, and stores still serialize on
> > the compression mutex.

Probably worth calling out the extra memory usage pCPU (at least on x86_64)=
.
