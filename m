Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85402EF9C9
	for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 21:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750194639; cv=none; b=NX0SIKUFqoQlDhQ0ZWNnr4djFSy5JkS3/f9r6ydCpcTubnc05HRFdlumc6UKWh0OPaPM+Fy2xjOR4cbCqcxTuQVHoV1AFKcvhni8yKiLbS6wf1I/LiI79k63N7jfq5R863jKbwBUbrsVVBccJ2fSOB635h6zEdUsDBFqZuTlbbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750194639; c=relaxed/simple;
	bh=ir2qXEQz0ITQfoN65/zED7gUfzbFZUXr94ByJGJvwQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A2Ber42/SYSCR+HUcpX+hw2UNwE7zlgkfTJ1OssLEwG+i0aPYR587XFOBdJb1Hvwrdlxzv+p5+5ppsjTN0ZytFRqhymEdbVke2v4jyJAIZ1Wr7/VxDdlL9uqgSDNmncOwdY/NoTF0ZFsgG9fAQjTCCS0D3g0B5CZaRwu+07qbBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GKGxioJe; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GKGxioJe"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6071ac9dc3eso10773334a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 14:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1750194634; x=1750799434; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NscEjg9Y1LWinfHLpsahI5dfBkkxck14FsEzSEH/mHM=;
        b=GKGxioJeNQ1m3MD+VTMFWiahlOG40+CTfxNSdw6ozP/K0DiboOKFT1CYrPNsR9hG+C
         S4wl1fAL0nwXFJoNPcxlUofj6jn7zWG6CQ5fZVIurImhqLwNJXzSGz8RveJ1TIGiKaQW
         DZ6u+A+f/kRtJ9rOqSJ0xtaaZHD1uiDiEf+lw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750194634; x=1750799434;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NscEjg9Y1LWinfHLpsahI5dfBkkxck14FsEzSEH/mHM=;
        b=FImsGvYRMk2wg1DMvl3oosJZBqDmZ1MFWJ+vfr11wrTzrP5sVRYCbtPcogagoGZK5N
         Z9HdA/wJWk4LRSbgL4TPC+qxeAKI1BuVQWg10BHHw3f2Y0AW+qTu+O137siWoaN2k/qG
         zYSkv70lnNXKHTuAJmyeqg1WXdwO08bbHdKf4bfJULApihWQWjr1JWtIkZfSz4OhYhvo
         G8FiVdkIX6h3qxtQ4RLDyZUjyw6KXj5OFcehiu/kgfYPxnu6K/hfq/qIOMn9REnoeWeW
         DwtJWyw6M5vklE96iYmGmwBs+C68bMQttqSRAg4buNkTnhoJI1mHa60fxDKxedhtZ4XW
         dPdQ==
X-Gm-Message-State: AOJu0Yz0KYVfOeOjT8a94TQpLY1JSanXTZXPmHEklqgi30hrmNBrg8d4
	O/1FDW71ZqlEnm9mscHy4qipXfFi+l0WFiAgx4DoUhlCNp0efDq1S9d0Ep7+6SvT8dYFjT9W5Xn
	602Je1Mc=
X-Gm-Gg: ASbGnct/DrWpiSApKiBp1+Qfebb4NK0J7NnYr9I4V6YA69r8XYvBzBfG8kjs/WNnPnK
	ZBG4/qd6gRg3eyuItyo87fo8ebLrqXMY5/eBxZwxWYhVJIEgqpm5jkQTeE3G5ESxAXZf8/wECv6
	h8NnQO7qw9s52ge3VSCGF/KpJJ4rvZtYWlRuoZgztnWhK/jdM417D8he8QPKGE1ZXyST/hRy0lt
	mjrddziZgqwZMzHdUr1dOdOjm2SSAIFcApxvJpUVJQ5biauQK9DSMxWzjAkxjEqnzJbAOxbXX+k
	j95KjttMeRSb+KKSR+ux98JGydGChFcIFeiYsU9s4agwd9WtdAvIx06fFPdTKskKWrqTH16jUGm
	VyRzzLo/3KBCOdd6Br1adQROgM3At4BVEy83E
X-Google-Smtp-Source: AGHT+IG8CkYhYrqO/e6OFDrqgouVUkG7WovcTTu1CkYIf6bwJ1MTjVUxcFofiOGSEDDyOOWL+oI2Gw==
X-Received: by 2002:a05:6402:1e88:b0:605:c057:729 with SMTP id 4fb4d7f45d1cf-608d09a0e00mr12895601a12.34.1750194633985;
        Tue, 17 Jun 2025 14:10:33 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608fb58e00dsm6118218a12.32.2025.06.17.14.10.32
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 14:10:32 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6077d0b9bbeso11416770a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 14:10:32 -0700 (PDT)
X-Received: by 2002:a05:6402:5188:b0:607:f55d:7c56 with SMTP id
 4fb4d7f45d1cf-608d097a0a3mr14798722a12.25.1750194632040; Tue, 17 Jun 2025
 14:10:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250616014019.415791-1-ebiggers@kernel.org> <20250617060523.GH8289@sol>
 <CAHk-=wi5d4K+sF2L=tuRW6AopVxO1DDXzstMQaECmU2QHN13KA@mail.gmail.com>
 <20250617192212.GA1365424@google.com> <CAHk-=wiB6XYBt81zpebysAoya4T-YiiZEmW_7+TtoA=FSCA4XQ@mail.gmail.com>
 <20250617195858.GA1288@sol> <CAHk-=whJjS_wfxCDhkj2fNp1XPAbxDDdNwF1iqZbamZumBmZPg@mail.gmail.com>
 <20250617203726.GC1288@sol>
In-Reply-To: <20250617203726.GC1288@sol>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jun 2025 14:10:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=whLENPVgWtHg5jt42he8Eb2pFzZngbvfSWXUmq64cyaAw@mail.gmail.com>
X-Gm-Features: AX0GCFteh8AxHdG-O3SktB-Vd7hTjMUC_EBJsHwrbakY8eEhqvV4OBO-zVcDyV4
Message-ID: <CAHk-=whLENPVgWtHg5jt42he8Eb2pFzZngbvfSWXUmq64cyaAw@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] SHA-512 library functions
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Jun 2025 at 13:37, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Okay.  For now I'll keep the test commits last and plan for a separate pull
> request with them, based on the first.  I fear I'll quickly run into
> interdependencies, in which case I'll need to fall back to "one pull request and
> spell things out very clearly".  But I'll try it.

Thanks.

Note that this "split it out" is really _only_ for when there's big
code movement and re-organization like this - it's certainly not a
general thing.

So you don't need to feel like I'm going to ask you to jump through
hoops in general for normal crypto library updates, this is really
only for these kinds of initial "big code movement" things.

> Just so it's clear, this is the diffstat of this patchset broken down by
> non-test code (patches 1-3 and 6-17) and tests (4-5):
>
>     Non-test:
>          65 files changed, 1524 insertions(+), 1756 deletions(-)
>
>     Test:
>          14 files changed, 2488 insertions(+)

Looks good. That's the kind of diffstat that makes me happy to pull:
the first one removes move code than it adds, and the second one very
clearly just adds tests.

So yes, this is the kind of thing that makes my life easy..

> Note that the non-test part includes kerneldoc comments.  I'll assume you aren't
> going to insist on those being in a separate "documentation" pull request...

Naah, they're relatively tiny, and don't skew the diffstat in huge ways.

             Linus
