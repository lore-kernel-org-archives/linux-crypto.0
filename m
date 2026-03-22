Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC96199FAC
	for <linux-crypto@vger.kernel.org>; Sun, 22 Mar 2026 09:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774171790; cv=pass; b=HxyRVzQFL1pCSEOr623wWOFwVWgiUJIaSvwk+SZNxZBrDZc94pCjAUSiodJa+Fr4NBnGXjiFkOSmvIPTWum5pEqfYc39YGdmr2wY+9QmBDKKkKexwz7dNHLYHleqTZnU7Fr3kcyxTAR7JEaZ9+eXOl6nj/zrQNg02LfznkKUT7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774171790; c=relaxed/simple;
	bh=49v0X0XXpVTGJTxfPmWDsoTtraAxLLbmvdeBbvCQgM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P1/7eFfhlMXxYbLnoLgRFhdqTZRhQY8NEa+n/Wc4s+7ULvgnU/wTziifv9iEwObUJ6xFW5Ob6C+tzTIrZ5UFytqC2Gg/schm022o5ZeEn2pIUK4mZCSUY9NN/iYB49sLmjBe80ipbmD9z8gBSp3G2dCg3r+RY8+FUz3TRxi/QI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kF9FJx+C; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kF9FJx+C"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-487012ce896so9090845e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 22 Mar 2026 02:29:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774171788; cv=none;
        d=google.com; s=arc-20240605;
        b=a/zi2zv8OJAyyRaK3EZUIdRwWDVUqN/LPq8F6MJIVimBAr9PkcclPZ0AgjntkHAQu4
         RP2uALQECQXoYZXyasZFmWYq6tT8di7mftu1qWwkD4yjjvf+HcitutI6eZVXqTXcGUcb
         CJE1atUrN3JfuI/g8BZcXJzDTYEMFtpF0LkR+nW3TroxNZUCPtVBKQBf4yK3HeL6JtsL
         m86GQrhQcoqtaLmGTDkojKMKVHuruRZJHllD48OAl/6IG0fhaVFIVfdJDvEz/gmPnPNp
         rRRoBJOpOpai54hdwzzjmZ+L4+6RMUpwzhcY8kiPcoaB3aCcoNRr7zOBBBFkXeX3KCNi
         cl8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EfhzysQTOvwn9gCls/m3vNIn8HYNOMCQ5HEu/oqWw+E=;
        fh=gG+Lh7TMSUsbGX1wG+90yvJxWRzG1KFzxkubu6IA4ig=;
        b=hnQjtvfLoQkok0oa/nOtnMLKiGJhguY8gVGFhjrLyuebUUvimPiNJezylRFGMa3P5n
         342IErHisT70YZAKo+VJVqHu0HsBtcMk8p7Zu9Lc+A6CArJMvIUHYbUjk1fMh2MxgoIY
         fZ5fgUufe+wQLYsjaOGsgrN0GgxSvDeE7UQfLxWsxcE1I75GakLTkTmx1wDjc9R8Zhqg
         xIw+R+kxbDpWmF8KCDTRAXTp0iNhwWY2z/2vEo8zKuRJL8zrqVS3Lc42oWNQJq4wkxMW
         WophjNxdHC0/kJwlNF4mo64g9xvl+vcBC6KK0vkyWSzTJ44gkarzllRBvwEKunm7kiUp
         NqAQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774171788; x=1774776588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfhzysQTOvwn9gCls/m3vNIn8HYNOMCQ5HEu/oqWw+E=;
        b=kF9FJx+CGp2ubf9zJnlsWfOzgdHbGkvHO6FSz1KuC0pojW7F/FtsDz9kktnvqZxsVT
         gvm8S3P18gpPsp2rHIBW+a+B8dU/7v1FQeeeu9hl/jGxPx57wp14DYFQlx7dLjUIuIyg
         gjfi4NydifHft+hgF2gg90R3bJRYDMBoBTdQ/8uqr7R5YEyHPhY8Y1TU1rZTJ5nRCwpd
         h8zjKVq8HvIbNdJqmY9n8ru5BcrF2z0JbJa41YGH7dU3G4C0z5vF5si6IaaHdYGgRMBX
         pYvabTKb7TSudLhMd3Mt4h+0dLCogLE6VV3vznxg8NlAjE+cmQ2O7YBaqObWEJSn9tuS
         MkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774171788; x=1774776588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EfhzysQTOvwn9gCls/m3vNIn8HYNOMCQ5HEu/oqWw+E=;
        b=YOx6885h1+sKuLHlZnzdoowkFqxlKwQmUU1yOG1+qeZEsl+N+aAw2B/YVvVKQt06sc
         oDKUj2FiRIZrEQXHydAw3fO0hIZrhJ+WZ+Uco/lcSkpsr8A+PNpvj6cEGEmiMMbpjOTQ
         yFCHoUaQG3OS9Nl/HkgD3Rc8fRvJ+qSOULQZGQzVYvQsem+56yzVGG+syudT22RN6gR2
         aQAIwjfr11ddMOehAk+rlpO/xQ5z2pVGyEeBohE0YiKrXhIo9uO9fsc2UIfHDics1sBB
         ekR5nJE5nl9/1jiYJjw36vNS4rz3wBC1dd8C7kgdC4gWkk+fAFYQYlqfnVfI/o/5aVZk
         QOfg==
X-Forwarded-Encrypted: i=1; AJvYcCWCH03GycCTJjoVKI2Q2uv5qFFJ4OS21cl3Yg16f+zXnE6bAp+YEkB8v5jNNduH2EgoCgjVYERQzE2XH4o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6qDlUNWVjEkd630oIgdzXg/Mk8sC/LijISF78tqgcNZ5z5OEg
	0f3GyBhxSYqarg0yBvsalm+BdwjoIVLaAkIi4aHtB7GddUtL+5X9eOksM8+zE8W1frZpFEWUEH2
	LhepQC/48aLRxWkcvaqhDhb2kDOIbtC5ex4mQta0IFg==
X-Gm-Gg: ATEYQzyAUEF5k8CHkw95y+mvzEwUep/Kx62d75cYx2r3FUQ+P/RCt0tmvaqgB+GdkgK
	Oi5/aI8UIAE3vYnG0SmeeRU9XZbUkUFlKVCVQvY9JN4wk/G272/XsmeEucdU5OA+JY+1RMyvx+M
	mI7+w/BGRikcbCuoAAtularhfBeJFsSKQCuZcZTxrLMFST3z71tS+goC3VonzrlK3O+PzK4nrT8
	VXxvPxec7je++0ebQvvWGuMPYS5l49wCOsFXOpjfluVENrpDdWWUyfV3SoDkoTMXVn/eZppVUfd
	OyHHAg==
X-Received: by 2002:a05:600c:a59a:b0:487:1c2:6a79 with SMTP id
 5b1f17b1804b1-48701c26c3fmr58120855e9.1.1774171787816; Sun, 22 Mar 2026
 02:29:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260317065425.2684093-1-demyansh@gmail.com> <20260319190908.GB10208@quark>
 <20260320103624.0e13d26f@pumpkin> <20260320200039.GA2085@quark>
In-Reply-To: <20260320200039.GA2085@quark>
From: Demian Shulhan <demyansh@gmail.com>
Date: Sun, 22 Mar 2026 11:29:36 +0200
X-Gm-Features: AQROBzA-TN69FYB2KftzMGkGtG4N5t38t1xJbpzSZipPCmkr_TcYSnLP5fqwVaU
Message-ID: <CAOLeWCvSokaVROhg7f8pM=G7GaRS9OBp2q4T5WPP18C+wJuyVA@mail.gmail.com>
Subject: Re: [PATCH] lib/crc: arm64: add NEON accelerated CRC64-NVMe implementation
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, ardb@kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric, David,

Thanks to both of you for the review and suggestions! I've addressed
all your comments and will send the v2 patch shortly.

The idea of a unified PMULL template for ARM64 is very interesting. I
can own it and work on it, but as it requires careful design (parallel
folding across multiple vectors, handling LSB/MSB differences, and
generalizing Barrett reduction), it will take some time to implement
and test properly.

Do you think it makes sense to merge this current solution(with fixed
comments) for now, and I will follow up with the general template
implementation in a separate patchset later?

Thanks,
Demian


=D0=BF=D1=82, 20 =D0=B1=D0=B5=D1=80. 2026=E2=80=AF=D1=80. =D0=BE 22:00 Eric=
 Biggers <ebiggers@kernel.org> =D0=BF=D0=B8=D1=88=D0=B5:
>
> On Fri, Mar 20, 2026 at 10:36:24AM +0000, David Laight wrote:
> > I'm also pretty sure that the same loop will process 32bit and 16bit CR=
C
> > (just needs the high bits of the constant multiplier set to zero).
> > There are fewer bits to correct for at the end (I think it is always
> > the size of the CRC) but that may not be worth worrying about.
>
> Again, see lib/crc/x86/ and lib/crc/riscv/ which do basically this.
>
> > It might be better to write some C that required the architecture provi=
de
> > the functions required for doing a CRC with 128bit registers that hold
> > two 64bit values (etc) and give them sane names.
> >
> > Then common C code can be used provided the required instructions exist=
.
>
> While it would be great to share more CRC code between architectures by
> using a C "template" combined with some arch-dependent inline asm
> blocks, there's actually a lot of variation in what instructions and
> register widths the different architectures have.
>
> lib/crc/riscv/crc-clmul-template.h actually has something very similar
> to this already: it's written in C, and there are just three
> single-instruction inline asm blocks to access RISC-V's clmul
> instructions.  Unfortunately, the carryless multiplication instructions
> on the other architectures are not compatible with these.  So, it's hard
> to make it anything more than RISC-V specific code.
>
> There might be enough similarity between arm, arm64, and x86_64 for them
> to share code using a similar "template".  However, consider that for
> x86_64 we need to support different register widths.  See
> lib/crc/x86/crc-pclmul-template.S.
>
> > I'm pretty sure the loop is effectively:
> >       for (; p < limit; p++)
> >               p[N] ^=3D low(*p) * const_a ^ high(*p) * const_b;
> > where N is at least one and you don't actually want to write into the b=
uffer.
> > Making N > 1 should improve performance - just needs care.
>
> Well, you're welcome to read the actual code and not just speculate.
>
> But again, maybe best to not get too sidetracked for now, unless you or
> Demian are actually planning to work on the more general version.
>
> - Eric
