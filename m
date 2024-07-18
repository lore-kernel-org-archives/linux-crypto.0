Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005703716D;
	Thu, 18 Jul 2024 16:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321536; cv=none; b=bBm7aMGryYyxi07xGNnpZr4/KC4rmrr1HKX6wI9AVHAZwnEnMHJQA8jL1+KRsn6ICqS/V0KPHZA9WvU+kHeiKpxRo0ONWshU3gf5cwf7JeA5FDvHamc7Rj1x5gO1yoho2Uy5dKduPdUoGW5bSpsPdwRFdTU1F95mnMT9gJk74T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321536; c=relaxed/simple;
	bh=ZnX+WIDhVdVxYVXHFRUIZPNjtj3cNuRGslOGjAQbd4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sp8CQ8RipsAindHwpUcBsJ83VT8GSEeyUG5DvWCIBK3WY/qCL3KXx1CJWlnHfB0VinLmCW4P0ElIqGd/N4YNoMwNqmuKYSA0VVFO0qb0Zu0GJMicmdj6JrJsW3xrwrmYUy1eGH88PFnOaKBpaHnCS7Mchz804DRfPeT5BHEF9Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=Jy+Drlp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Jy+Drlp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A5EC4AF0C;
	Thu, 18 Jul 2024 16:52:15 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Jy+Drlp8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1721321532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZnX+WIDhVdVxYVXHFRUIZPNjtj3cNuRGslOGjAQbd4M=;
	b=Jy+Drlp8vqhnVyK7eLOwFzw9W2m9y7nQLfasMgjI7wJLcDuRF6IIozSuNW+CWiwUHJWwS8
	47C0ZnNcj2p2nfBgIJDqubvOhNtTW+89z1m2GhfHrtmX+xhs7nYmyWJ0XrG4Y7JvyPpwl9
	RDEV8Da+4bXEXgcX5MI38RIyif32XyE=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id eae52d3c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 18 Jul 2024 16:52:12 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-260e1b5576aso544700fac.1;
        Thu, 18 Jul 2024 09:52:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUgw7hqYZ8NefiLERGQpFzTeMi2lang//QWfMPEJyMADZS0TBhnLyv99oD/O24/xYm5/CD1GlMrt5A3GU4WDhGRbVuHyu5s1vEHVt7ToijRBXe/nrhpQnRYrsdofgTAVAFf8wSaVPX7NtRM
X-Gm-Message-State: AOJu0YzQ3vyghNCHRPtsoPDpgrDGcdl5xgjPCxJ+HFD1oWnz91FDc8tD
	DMkBVuGnRZDG+LXNtwoVENoCVwHyr20g8pv+37sa7lVPrgFI+4AqXCCa8JpJixjl5pC+bmZbtXB
	YaddsmP6l/PrME5M46qPKrrgZVAE=
X-Google-Smtp-Source: AGHT+IEjjx5WeoBlVvTblOQ5Yroj8xtuhPbFHMfRMdXsd2Iy8to7rONgNEFytjHJi0DWvlUB/MEjgRW29c4x/QEEYs0=
X-Received: by 2002:a05:6870:1701:b0:260:fbf6:3221 with SMTP id
 586e51a60fabf-260fbf6370fmr1355604fac.35.1721321530793; Thu, 18 Jul 2024
 09:52:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000037cdb0061d5924b3@google.com> <46f44064-255b-4a1e-9317-f4b168706d65@kernel.org>
 <flthie3lmh4ovhlullgz2rsd5yfmwwfuqd76yef7xa2ncpqs4j@dxvhd64eoa7t>
 <CAJuCfpEX7JFbWbLT0w+nyKz-m87ccuzSoorB3PfnW82mA-nFfw@mail.gmail.com>
 <CAJuCfpEGATSeybdVNnUW5eS5EKHF00VzxHGwKoMfPiS_QRiKbQ@mail.gmail.com>
 <ZplEgwFFb0LAXbH4@zx2c4.com> <CAJuCfpG07s2jcsgT3EE85B_JGWY2B23n+iPhVWP6amgZgSHi3w@mail.gmail.com>
 <CAHmME9pjUJKTtYz10ULrWYBCB3LUCG77aNFz_n7uBvyddOge6Q@mail.gmail.com> <CAJuCfpEQQ4dKOwS8a9dRgwWtqR7LyKMx2Qr8vjaBu=CM4dNSCw@mail.gmail.com>
In-Reply-To: <CAJuCfpEQQ4dKOwS8a9dRgwWtqR7LyKMx2Qr8vjaBu=CM4dNSCw@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 18 Jul 2024 18:51:59 +0200
X-Gmail-Original-Message-ID: <CAHmME9rugxJiJTVCr5tdz5_YHcJVFckubQfK6Xn9TCuua5o1JA@mail.gmail.com>
Message-ID: <CAHmME9rugxJiJTVCr5tdz5_YHcJVFckubQfK6Xn9TCuua5o1JA@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-use-after-free Read in handle_mm_fault
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	syzbot <syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Suren,

On Thu, Jul 18, 2024 at 6:49=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
> > > Warning: It is no longer safe to dereference vma-> after this point, =
because mmap_lock is dropped, so vma might be destroyed from underneath us.
>
> Better but I would change "mmap_lock is dropped" to "mmap_lock might
> have been dropped by __handle_mm_fault()" because mmap_lock is not
> always dropped by __handle_mm_fault(). Technicality but better be
> clear about it.
> With that changed feel free to add:
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Will do.

Thanks,
Jason
