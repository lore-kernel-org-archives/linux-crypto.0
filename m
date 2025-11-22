Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACEC26980F
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 14:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763822203; cv=none; b=Bj1i1aNThnvf+11ffZpt16bUigD+LugmBjkuDpvFe+lUAlJE814eS8T0lHCSkspMUxgoIL8h45tnblyoYqIjChM4sxZLzhHCotbGoSmEj/ratdyHYEdLwXvyqVkDJo0sVJGM3viBOE+nnvIonqcuUOKIvEQEIW3FvNMXS7nItBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763822203; c=relaxed/simple;
	bh=EFYi9L5UwDPh1mzI94F/EK35AXPC5I9gw0Q51gsezgI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pb633lNHI0u+IE1oBxop6uaD5uUfRnJzn8UOXUHyF2Q52nCp9JO2YZEnNVQtu82HjB4ktlTny+pYLNv2KkI+4PKJtsoxflsiZ3IbyNEZIhDdMJwIPQO4P3AhaL+0XGNg1kDhH2ZtXQ+UpEmQiYTcl87W6SzZ5LZbugZMIN3J2Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c7503c73b4so1636513a34.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 06:36:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763822200; x=1764427000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mrG3FRl3ZQJELga2T7IxRw84N89LNPCPL/hcWM8uf/0=;
        b=Q04QwyUNuGaltd7A0uXhlZHo+7cILqXkPcAmQhlt1XUGlmCE1EdPTpjw5PjcN1J3VW
         5AAdUW/I6SN8nB7B5Cvze3kKvdRLSSZvbnWL3zdTYpWHRHQgN1XlgmQTmgGdgvYMJQj4
         9PWlFOd0nVvvR4jiRApBUWJuwDB28odkth+TpQnzeUDG4EodlbM69h+ZQZr+86Bhn1hb
         5VlguDFCMchpoxm8UUC9Z5R8kDzcyQ/0yVx9R2BXF/zDj3Ky+dRIrRth2wUkEw3bp2pO
         B7fVl0Q7Drxz+cnGdjuYZnKHpmXYgxLNsfNEtt4PfQ4s2Glmu9UoIHp1TorMEpCM4FcT
         LGaA==
X-Forwarded-Encrypted: i=1; AJvYcCVYLGtuzzvYn6mDAFyrJUhUwxQHrThQrCHZCziCne3guzIb37yPY8FPQ0gU2ZVyjpNvJg9HWMApE5moST4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjOSzEM7o+1PIs2q7ZFHsiNiQdhuekyHMuZ8ZRc5vlV3IL/2Am
	MjHhxK+picMNi/yYZ5k75SyA+v7wAq1slOz+NtHo9v/PRfADC082iqSTa3aeQA==
X-Gm-Gg: ASbGnctxlKUjXqoUJSiZDk/NUkRq4H6dMY6HX5tPD6y8krKKPm31f4THpCs5or6zegv
	e+53ORIVil2BqAojgo5IysN3Kk1BmDH06iGFBBqO+RrLdph/444ljwPqFUgRLrUD4jN2/Gv1meu
	raD40E5Y9BE0ogci0obC8RLxgfnphSeRc8UFtHxt5+wC1IMZAmd6v1PkikHxRVEYmm71f8HVfTX
	yAzBCX3b6hqOVI8PGiGXB4IQQMMzSAre6TuAzxqCIu0i3hQ9C1BIU/fq7j8gzQen8uU00Nzk1Vs
	NxXaWfoiY0sTVgwuv3K6DAjqr9NWfrk1Tan46YEI1u11o0C7e1EWbGgKAn1deNFyOGoZhcnsPP5
	mklwE33LiOVCP0u9OrLapwQv7lx076fg3EAgkS5LTOafNlxeLhSXuHyv7EfWXqmQDH+fuLmbxHi
	nBzSPow2fOPgeLTP3en73puJwZi2CKSvuXTCWo/Sqs3thbURq6pUQFuDy1WvzAlyMDsdgf9OhE
X-Google-Smtp-Source: AGHT+IHNcVWbQu348+/v02qWhSD4KrblkW5BNMqlCk3pqS7m6qtQtdzea1rKExJPx5HRB1sH7ySVGA==
X-Received: by 2002:a05:6808:3507:b0:44f:6ab9:4aee with SMTP id 5614622812f47-45115cb85c1mr2162896b6e.63.1763822200000;
        Sat, 22 Nov 2025 06:36:40 -0800 (PST)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-450ffe2f361sm2477847b6e.1.2025.11.22.06.36.39
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 06:36:39 -0800 (PST)
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7c7503c73b4so1636510a34.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 06:36:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWd7b9bhcKtK4mns3QYypdWzX3mjTVkeNEUItKAm0FisU5NH48s1bLLN5IVh5EpcAdHUQbZXHebdsT8VvI=@vger.kernel.org
X-Received: by 2002:a05:6830:3488:b0:771:5ae2:fcde with SMTP id
 46e09a7af769-7c798f7ba96mr2916201a34.2.1763822199328; Sat, 22 Nov 2025
 06:36:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7458cde1f481c8d8af2786ee64d2bffde5f0386c.1763700989.git.wqu@suse.com>
 <9523838F-B99E-4CC5-8434-B34B105FD08B@scientia.org> <bc5249ba-9c39-42b1-903d-e50375a433d2@suse.com>
 <3C200394-F95B-4D1C-9256-3718E331ED34@scientia.org> <5495561f-415d-4bb0-9cd4-4543c510f111@suse.com>
In-Reply-To: <5495561f-415d-4bb0-9cd4-4543c510f111@suse.com>
From: Neal Gompa <neal@gompa.dev>
Date: Sat, 22 Nov 2025 09:36:03 -0500
X-Gmail-Original-Message-ID: <CAEg-Je_3rtWr2P_j76792+s30VPn84sDv-u_61_vmLBUE0ztkg@mail.gmail.com>
X-Gm-Features: AWmQ_bmqpnKk3EPf9MVQGz5yyOka6iv918VShrajeq5dDuRVH8lOvvN7LP780X0
Message-ID: <CAEg-Je_3rtWr2P_j76792+s30VPn84sDv-u_61_vmLBUE0ztkg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: docs: add warning for btrfs checksum features
To: Qu Wenruo <wqu@suse.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.org>, linux-btrfs@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 1:44=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2025/11/21 16:32, Christoph Anton Mitterer =E5=86=99=E9=81=93:
> >
> >
> > On November 21, 2025 6:24:26 AM GMT+01:00, Qu Wenruo <wqu@suse.com> wro=
te:
> >> =E5=9C=A8 2025/11/21 15:47, Christoph Anton Mitterer =E5=86=99=E9=81=
=93:
> >>> Is that even the case when the wohle btrfs itself is encrypted, like =
in dm-crypt (without AEAD or verity, but only a normal cipher like aes-xts-=
plain64)?
> >>> Wouldn't an attacker then neet to know how he can forge the right enc=
rypted checksum?
> >>
> >> In that case the attacker won't even know it's a btrfs or not.
> >
> > I wouldn't be so sure about that, at least not depending on the threat =
model.
> > First, there's always the case of leaking meta data,... like people obs=
erving the list or my access to Debian's packages archives (btrfs-progs) wo=
uld e.g. know that there's a good chance I'm using btrfs.
> >
> > Also, an attacker might be able to make snapshots of the offline device=
 and see write patterns that may be typical for btrfs.
> > Even with only a single snapshot being made, with the empty device not =
randomised in advance, it might be clear which fs is used.
> >
> >
> > But all that's anyway not the main point.
> >
> > Even if an attacker doesn't know what's in it,  he could try to silentl=
y corrupt data or replace (encrypted)  blocks with such from an older snaps=
hot... which would then perhaps decrypt to something non-gibberish.
>
> Adding linux-crypto list for more feedback.
>
> In that case, as long as the csum tree can not be modified, no matter
> whatever algorithm is, btrfs can still detect something is modified.
>

A few years back, the Fedora Btrfs folks debated whether we should
switch the default away from crc32c to xxhash or anything else[1], and it
basically came down to the performance hit being too significant to
consider.
Given that crc32c does the job in detecting tampering with it, and you
can reinforce it with fsverity, I'm not too worried about it.

[1]: https://pagure.io/fedora-btrfs/project/issue/40



--
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
