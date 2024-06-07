Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1039313E41D
	for <linux-crypto@vger.kernel.org>; Fri,  7 Jun 2024 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717785650; cv=none; b=WnZJrpMjp2mrhpehDbF0Lge3+X7HWif5TvpnQwUHFUvLN5ZxqTPt0RhsFJAZxKUtfo28LHvHi4ZcaxpRn67g01kK4U9rzXhB1M31oeJ7EVr+YU1gieHa+HQVM1JEOzSf4EH8EC1z6dARxcj+cxLHU8FXPqiDMoP83tOule4BEw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717785650; c=relaxed/simple;
	bh=nLT1CS3bAADtDvYR/iyCMdc1XfAIDAMUu13CcxexJ8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I5FduQwtYBOc7VzMMA9J1scM+lyL6A179AgVtV7Ofm3JMGL0CmYREpdwXLoNZY/loyN4WF8F0OxnnNtFy2TIXCm6QucbbWyWEbDeL9zDiqJQ9vxb+H53R24ax0ySCvVlTTbF7VIrB4B8D5APmdBAB7Fx6EFlYRiC+FOHgHnmDM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=lIFmfqmE; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="lIFmfqmE"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-24cbb884377so1292501fac.0
        for <linux-crypto@vger.kernel.org>; Fri, 07 Jun 2024 11:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1717785648; x=1718390448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWP3oVZEyR0+a+YIhKNFwQ+oDZLDTYUDKfQwa7N72nY=;
        b=lIFmfqmEbNvXbeyH1jERzARJtTWuAvqn8uqb5SK7/PMlu5+bWUAmknsp5f1oG/eEGU
         2k7Ykj0gM3WIHu6hZtiEjhFZgBOsLLMSq1rTjGP6vgEZnxK8gzr+ytbTtnkf9q39Cgx+
         1r1FqudUiDptvrkVDye7NpeMW6irl7xOtOzfmLOnK7kgpnAX5oxaskeoorRvA9HhEmVt
         +4WImlEm4LQseVwMZRcD25us6e6AANqC9NMTMMFBNaDP8T7TFdSwd8FHX8XVEwWt4I4J
         ymmTTYL1XE/qlUM0+qdP4PHPYRWPZIPQt+DHQyZij8D0hJox5HXez+0G/7QSJC5tkxFJ
         u4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717785648; x=1718390448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VWP3oVZEyR0+a+YIhKNFwQ+oDZLDTYUDKfQwa7N72nY=;
        b=l0t0ssmGQ/VVQHE9rBvFq7x2Zn4YxD55R2XsCHO8B4zzrUR5mluMOcNMmibC0WhCy3
         MKaJX7Hd16QZwRlW43LHX/KMmbQtvae/egSX+AKiianuL63rDCfU3TQHnL7sAxONRx9L
         eNwa+i58Rxlloz6P/J0Ch6NSL6V/0yovJ1u5ROs4nL2q7MQmS6F14rKHRDDwTxSIFQuS
         4wH+u7FEGJlpE4vSmTYIrnEllk2KMWJURnzhYri9ajeBl6MC6e4ntPJICV3PLRVFemyQ
         i4VgvvviEgFbs1V4M3XlDKbYPlxAfgSyjWReLTuqNzW9B+jeDPjCK6h7xT54/MGCjRu3
         9Avg==
X-Forwarded-Encrypted: i=1; AJvYcCWS/G5OteT72989fQ3z0iryIJwS7EX2XG34zqBExFhyo677LtaD0iIG9StS3RDTgmx22kJ9p/xnCa34Imt+3H2bIHDG/3qVxpnMYR0k
X-Gm-Message-State: AOJu0Yy3VgTbCxJKBvkWDQVOtIMLNKXEpS0EqPZWU6xF7wvSMJYA1ezh
	wkD9M4ZfAoVm9Jeq2H0IT41Qc2bf5RUTuSLokvu2SWke1CPeSMx8FcUaB4OaQxV3uS5fNLxOJ9V
	ctuHkxp3X14xM+0MHEkm7JU/dfUQN5ICtibIr
X-Google-Smtp-Source: AGHT+IGM13uj3U+ARgcKJSVs/VmcSppJ4o+ZTjupN8yH80mNMzyyWgUWj/akZRB539Rs2Rn6cvM6cRncobvhndjrU8I=
X-Received: by 2002:a05:6871:e015:b0:250:7353:c8f2 with SMTP id
 586e51a60fabf-254647efd11mr3404898fac.43.1717785646594; Fri, 07 Jun 2024
 11:40:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-2-Jason@zx2c4.com>
In-Reply-To: <20240528122352.2485958-2-Jason@zx2c4.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 7 Jun 2024 11:40:33 -0700
Message-ID: <CALCETrVJFefyDT6U3QoHdZvNh=3nqk=3AK88eRuqdn4W4t8vsA@mail.gmail.com>
Subject: Re: [PATCH v16 1/5] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 5:24=E2=80=AFAM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
>
> The vDSO getrandom() implementation works with a buffer allocated with a
> new system call that has certain requirements:
>
> - It shouldn't be written to core dumps.
>   * Easy: VM_DONTDUMP.

I'll bite: why shouldn't it be written to core dumps?

The implementation is supposed to be forward-secret: an attacker who
gets the state can't predict prior outputs.  And a core-dumped process
is dead: there won't be future outputs.
