Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF9C1A8F68;
	Wed, 29 Jan 2025 16:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738167132; cv=none; b=ZGSNwN9EMhFGRALae1A4/YcW53fptThQQ7D9iMECQPMivr3aEwRkKTh5bf6k8lI+8v1uy/ywTelB2KKMpAjOJRIUER5juoZb4YiWZezqmbsvCwtVXgby4BXbsaE+dlz+D6pCFHfCIZ8fGp7rtlrL4zgxgkfOtkufPlV4x2efWWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738167132; c=relaxed/simple;
	bh=bdQG3ThtpBzxKMQu/Gt2TJHkftd4mSRH7SPpdXqPFDA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V42o6I8EKF/gAkDcl6gsm8aO3i95Y3idv+5PRvZE77OCTBB1UWLqpvd0Mn9Q7G6Kqr5+pdToxc036kF7N5ZalQstJhsbl/jrGdHWwqNyBB3bl9YVle7N3PcpZYVDwckSTh+n1878rRpgUvxly7lo9y3UXlWEqT95jemfimYluk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cjuh9Juq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cjuh9Juq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127A3C4CEE5;
	Wed, 29 Jan 2025 16:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738167132;
	bh=bdQG3ThtpBzxKMQu/Gt2TJHkftd4mSRH7SPpdXqPFDA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cjuh9JuqzPLcU3LqkfqZ0mmDWEx7yEoz5k2ewH7QrCnDGVA/2GSBnMzSHtvl5eylO
	 oghTb4EYsvMpv27/yAH7hYloRTGNl1r0ifDYVWr0h40MI8q1GRa9GBRPjZOYibD1h/
	 eyKmsD+9MQOM6R7z2gCEcXQcYwpW4GB2AVfgLOqq05z6dtO3pjn4Ig9Xn23MamIj0w
	 s1NnFZFe/G2BvXGC33quD7itEqiSwELo7QioEkWMBxqHyKoApFU3L6mZ+wmp37xuwx
	 OvdR3G9USeJEoijwOO8aKgQjNfkLuy2jMB00hWFaGx1djN28MZL3UTtmxWgYhu1Seh
	 mvSBlalekCv9g==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-54298ec925bso8124239e87.3;
        Wed, 29 Jan 2025 08:12:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWNqWzrKnKD0Z5NKZzRT2tMQ4v6SdQuGaUwrm1QZASbKq9veWw4+cR6SNIGBPvZ2dsCOIW54/5S6Mdn/pU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL93qO2OBpY3+JBKERro20lR1FbRfZlk4hSfjLXkZj5tBmIO8d
	BbjgraUXIY3lrFW8548UacIf5HBGHhG7CP/kUonOwivxkpc0Jky7PhbhsCy38Lbz638zBetB6DE
	I/WgZkM1GU8jtmDnDT1jZtZYhmtw=
X-Google-Smtp-Source: AGHT+IFz+8DBj6p54pTo4XOrzRDXv5Q1kqK7GmIKYqORSGBbwQKGnlqPaNXsZI3DNqhYSJixdC24+45xVMW3rDszKcc=
X-Received: by 2002:a05:6512:401e:b0:53e:385c:e86b with SMTP id
 2adb3069b0e04-543e4c031a5mr1249722e87.27.1738167129196; Wed, 29 Jan 2025
 08:12:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250123212904.118683-1-ebiggers@kernel.org> <20250125003708.GA4039986@google.com>
In-Reply-To: <20250125003708.GA4039986@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 29 Jan 2025 17:11:57 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFYH39XzAo2D9toZdWm=tTABNBzt=TV_coo-NjPaHNuVA@mail.gmail.com>
X-Gm-Features: AWEUYZl0-sVXjV6xn5MO2vgkh-amiwYjKgmo4Qo5-lZbVtvrHegwTc7SXWsK2LU
Message-ID: <CAMj1kXFYH39XzAo2D9toZdWm=tTABNBzt=TV_coo-NjPaHNuVA@mail.gmail.com>
Subject: Re: [PATCH 0/2] lib/crc: simplify choice of CRC implementations
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Chao Yu <chao@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Theodore Ts'o" <tytso@mit.edu>, Vinicius Peixoto <vpeixoto@lkcamp.dev>, WangYuli <wangyuli@uniontech.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 25 Jan 2025 at 01:37, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jan 23, 2025 at 01:29:02PM -0800, Eric Biggers wrote:
> > This series simplifies the choice of CRC implementations, as requested
> > by Linus at
> > https://lore.kernel.org/linux-crypto/CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com/
> >
> > Eric Biggers (2):
> >   lib/crc: simplify the kconfig options for CRC implementations
> >   lib/crc32: remove other generic implementations
> >
> >  lib/Kconfig          | 118 +++--------------------
> >  lib/crc32.c          | 225 ++-----------------------------------------
> >  lib/crc32defs.h      |  59 ------------
> >  lib/gen_crc32table.c | 113 ++++++----------------
> >  4 files changed, 53 insertions(+), 462 deletions(-)
> >  delete mode 100644 lib/crc32defs.h
>
> FYI, I am tentatively planning a pull request next week with this, and this is
> now in linux-next (via my crc-next tree).  Reviews / acks appreciated!
>

For the series,

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
