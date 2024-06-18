Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4D7A50
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 00:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718669198; cv=none; b=aj4fcC46afKJn0da275vCYmYRj1H8tryVrx9Xw/xaEAlLjxkbm40PP5yVVGjf6TCUaSXpikvp94ZzAeWnaNamBGKwTbIxhUOK7Y3H5P5eKKJV+li959TtWFDkPWhy3UqeE3DKDoh/7W7ptIL5Qqm2CL2Wd8J003LA6RdA3GDpKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718669198; c=relaxed/simple;
	bh=UGatSlxeogA3j0K+wKO32ig6IQDTDriv/UTII2rF8aA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VYoHjuG+VYMdYLbhZxgg6kcgTCQidTz2Zoe+18h5SFDl25BXmhWL4TW8ZC4O27yyXmlAP1Vec9QjQymfKyinBbpFxt/MCiCaFhpZUJu4iz8bkOuNGiCx3V7t661reIWbC2AUwC3lSoX9Ech94nJr88b6kgMGiGnlkmFrJRBNsAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=nsO6jHQv; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="nsO6jHQv"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-57a30dbdb7fso8599426a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 17:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1718669195; x=1719273995; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NhBCdjZfpxKVO+6tjifmXo9LRGWI17cs8I9O4iYikok=;
        b=nsO6jHQv07tGiBwKMISNMG+VMjPGv2/ZXDkEwH1aCHs313Vd2qYOobr82YmQVyL8oP
         c+vFC8fq6Lh0dTNZKd4yFWLrICzWaJUDoEP7PA5dTwEZySocs79D8MvtEa5uPbSIn3bf
         RxGBYw+okkn31YPO1o9MuNUaUTd9tevpcVxWP7sghLc25ptBHROtfBpTQinKSnVfVW/6
         PvHH1cUcsvds6ER/mclPXY9JQb7hmNpvYoAcdaUyy6MLTVYSYp8XBmtKvu5m+/BBvMQG
         Oqu4qF2Wp7hTjh6Ol3U7Niy3DVT2meOzaFEKLoXG0yvh639VXzTd9j6kTqs/4dP0jF6f
         oPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718669195; x=1719273995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhBCdjZfpxKVO+6tjifmXo9LRGWI17cs8I9O4iYikok=;
        b=MdvCxTGv69gxu0SNLyXc7+R2IQjNAxQ6V4VbBTh1u77lKt6wGlBgPh4/LSdPyG9t50
         JtNsA1sb8RD7KWCc8W69gXxft9rOl35RBpfzTq0sRVRbEryUFmdjGPwnJyusVKxsL1+p
         PuEfqpHfj2vHkKqTWz7nuaMkFRwIIs67puky7iPx+Vbpz76sHSPyUyaZQoqiuqWX0U2J
         YNrybiuNgOKiOhuCi6Rn9Cjc3oO7cF1IvvUWcQyBYlFNxqL5TbNnnSihE1cUXKyEwPjy
         B83+FpMmt7gSNzvqisCmcJHpcXpxXWdhlhV7zn+vXAD3ZtdEZ0wg/w0lFQHGVFftdk+t
         lLow==
X-Forwarded-Encrypted: i=1; AJvYcCX4mdfqVQHaK2Fx1NbApP9vkx3R4fCpO1BdnVDUs8Y4P3g2DIwciK//dbV+o2+v3NE+vZQGSmfQKeZIToYzUxYbeR6cxlk6GCdgCykT
X-Gm-Message-State: AOJu0YxMCnAm1paXymeK+DgO6qzeIP0z2QM4Dstp/bAzL7fC1xHWEFO8
	jfqq3RVMQRIdjcQH6pGcdaA3IDA26H3owk8WeFaWp0Nb7sa3L2K8lIrk50tUDVr1TKULB/vvioB
	LzuivRQEjPmWskuor4rW2xXF3t13N8QWuVo/t
X-Google-Smtp-Source: AGHT+IG4GxHatmoy2CQa4K9NAS5MI8D1mWbcUvj+Npci2j6Mst8MU7YuWAjJuO9TwNpePI1dphaTrN9ug+F4RXaI42Q=
X-Received: by 2002:a50:cc9a:0:b0:57c:61a3:546 with SMTP id
 4fb4d7f45d1cf-57cbd67c8acmr8252492a12.21.1718669194582; Mon, 17 Jun 2024
 17:06:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240614190646.2081057-1-Jason@zx2c4.com> <20240614190646.2081057-5-Jason@zx2c4.com>
In-Reply-To: <20240614190646.2081057-5-Jason@zx2c4.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Jun 2024 17:06:22 -0700
Message-ID: <CALCETrVQtQO87U3SEgQyHfkNKsrcS8PjeZrsy2MPAU7gQY70XA@mail.gmail.com>
Subject: Re: [PATCH v17 4/5] random: introduce generic vDSO getrandom() implementation
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 14, 2024 at 12:08=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.co=
m> wrote:
>
> Provide a generic C vDSO getrandom() implementation, which operates on
> an opaque state returned by vgetrandom_alloc() and produces random bytes
> the same way as getrandom(). This has a the API signature:
>
>   ssize_t vgetrandom(void *buffer, size_t len, unsigned int flags, void *=
opaque_state);

Last time around, I mentioned some potential issues with this function
signature, and I didn't see any answer.  My specific objection was to
the fact that the caller passes in a pointer but not a length, and
this potentially makes reasoning about memory safety awkward,
especially if anything like CRIU is involved.

--Andy
