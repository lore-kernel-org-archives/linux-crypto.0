Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEC22EFDB0
	for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 20:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750190916; cv=none; b=Lp3+OfGYNrWn8oErWp/SIuyZOHRFpBsBNr6pcQZnWJ0e84dEtRLP1RCu4n7lvt/8HgS+i//8LcbDwYobAtR+fcsVE66IRNBOQTXBT7K60v46TVjNYacDUJDY/j56y2LOo2GOD9UR5dXfqEexl9MbjmLov54N6Y67dVIJSPoi+dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750190916; c=relaxed/simple;
	bh=NQoGyMTrLvZ94cQK6qr/U5S3n/jCYrB9gj8+lWNrtVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=StaNQ3HrnrTLQlOTh2pgqdPsickI0As5IlOrakQRPeiV9oQNwdFgTA5ZF0D+ZUYYQtnCC3r5A8axCebZB0az6VBnpeuDDYR8duCpv7cDZXKk9nuLY2rAAaPvxF91LTnnH3FfKYhmCwOb1kdyJrbBkVAFMzzv83BMMzBxxpHHwYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cVe6dkP9; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cVe6dkP9"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-60707b740a6so9403795a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 13:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1750190913; x=1750795713; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KANIOG1UnKUU5UjGnVcj73JF4ShRkYSB4zL4V2vR3Pc=;
        b=cVe6dkP9uur6QzffCy42W2mR8Cl8MOM/rhWryIhyZ2BIXOptljutjIT5SaNy2w2mT7
         dHO4C71dPNwSFNHw8odgeex01Lr+qLxenTwYKKWN88Sf5kmHaiaFtlaHo/AfUNk9fGEz
         VJaMGV7u6xv4yvTjVhntFzssofIfR1FwBGFFk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750190913; x=1750795713;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KANIOG1UnKUU5UjGnVcj73JF4ShRkYSB4zL4V2vR3Pc=;
        b=wGzKq+CQV5si8o7d4AjOBags/RKnMdW7IUq63PlneVqHyBSK8RgSrqQ1khbyXAho3C
         o0MYtNR5oIr/FTkn+/Que6x8Bcg3qHiMEo9gbuega/2IVMed4/86Hvc2UG/vf59fjcO1
         WRcgAVEI8g5+d74NFu79u2nElk4jKzCUGQwTjmz9UOTxbaLrXfIbpHOWQtDnU6/pO1o6
         MpJzxjd04+/KWLIzyVTHRT99V9VUYILML2Q4Prvq9/nb23OFFUDB2+KvScbNJwbC7ZXT
         rkufDL56iNDvRFfE4PTluHAJlC3emld2BlgSyNhCpih0Gi4LCokAOhxy/s28Isd+hTX0
         RzfA==
X-Gm-Message-State: AOJu0YxYxRmeZiRlW6LpIqXe/dYoEt9PSA9NjHzyS+kv56QCNkSl09r/
	GsTzqlZ4nNslhdkHLPx2JKGSpJ2J+xguaRtIv5NhAcojX35W9thMQvc7x4YYIEjhbh/NFkoGbgz
	Du6/grgo=
X-Gm-Gg: ASbGncuX7/5UHmYxrWZWifqeZ98tp7tggAXoX7+m7jcyqr0rnnZfLLCyiKRnK2s3DP6
	6nke0itwRzHzdZ0vXLYu0jCrEqXVALszoiBrMoKVD7Cd75q0KoiucGFXESMz7kwaUUbkZod1wXg
	tkZ/L/CACfefLoDAT5eVTIcvTr1nmHaQyTJfh8CjvZnt6EuUjRpn/8pXf+AODOo39BRJ2r0EhqW
	VO83OmLExLJ2kgu61BHJs06vr17fEUTIwC2hv3V0eizzwEDcfWXEZ8X61YNq1+sfYNPOnmQp08O
	cdsJJtaWm3xjIeakdWSQ+Aw3ySYvlH7o6vaSkzpFJUvrpWjANeWo26MrMVH3n9VPABnNoiFWvHv
	wTmyjwMAU3yNc2HA7+waXbeeRrwamiBUimEiE
X-Google-Smtp-Source: AGHT+IE3JoTqZ4sbxrezF/n+m+8hKnbXSQcSri0SwJwncqQBb0LJ5muaqoGvvN1XsVqzI7fZb1p6+g==
X-Received: by 2002:a05:6402:2550:b0:5f3:857f:2b38 with SMTP id 4fb4d7f45d1cf-608d0948ae9mr13954186a12.17.1750190912725;
        Tue, 17 Jun 2025 13:08:32 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b48a8477sm8353857a12.6.2025.06.17.13.08.30
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 13:08:30 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6077dea37easo11922542a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 13:08:30 -0700 (PDT)
X-Received: by 2002:a05:6402:2550:b0:5f3:857f:2b38 with SMTP id
 4fb4d7f45d1cf-608d0948ae9mr13954090a12.17.1750190910438; Tue, 17 Jun 2025
 13:08:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250616014019.415791-1-ebiggers@kernel.org> <20250617060523.GH8289@sol>
 <CAHk-=wi5d4K+sF2L=tuRW6AopVxO1DDXzstMQaECmU2QHN13KA@mail.gmail.com>
 <20250617192212.GA1365424@google.com> <CAHk-=wiB6XYBt81zpebysAoya4T-YiiZEmW_7+TtoA=FSCA4XQ@mail.gmail.com>
 <20250617195858.GA1288@sol>
In-Reply-To: <20250617195858.GA1288@sol>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jun 2025 13:08:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=whJjS_wfxCDhkj2fNp1XPAbxDDdNwF1iqZbamZumBmZPg@mail.gmail.com>
X-Gm-Features: AX0GCFuoL7ATRJ2CnwP4RNLTBvlSmkXnXI8fTIZk-24R8V3-BYf3WTK_tAsCN-o
Message-ID: <CAHk-=whJjS_wfxCDhkj2fNp1XPAbxDDdNwF1iqZbamZumBmZPg@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] SHA-512 library functions
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Jun 2025 at 12:59, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Again, the tests depend on the code they test being added first.

Sure, and that's fine. We have lots of "this depends on that".

> I could do two pull requests, the first with all non-test code and the second
> with all test code, where the second depends on the first, i.e. it will have the
> last commit of the first as its base commit.  Is that what you want?

Yes.

Or if one single pull request, split out the diffstat with the
explanation (that's the "Or at the very least spell things out *very*
clearly" option). But two separate pull requests would actually be my
preference.

          Linus
