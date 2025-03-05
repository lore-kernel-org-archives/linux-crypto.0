Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8291926562D;
	Wed,  5 Mar 2025 22:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741212465; cv=none; b=EFVOqFCguxZOdvHfV3xClCKULM+YtcMC8C4k+UQWVOlHPWhzrFcbBy78EmZ3kU5acmXikOYWKKeDvTYY2b7f/ponwQGgrHirwGRjDtJ3yVZQHjj+Ul6kr7X0vRqjMyJfjH23ug7E5RoLlOBuL2vvLZ4ehdFeEptQeI7NrfjOkRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741212465; c=relaxed/simple;
	bh=+BXq03mrlLCePqP/pG5Wur4pQiq/lOWh+H61RCV87xY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fJth7hb7wPVrlVIgAsqEUCAOB85LdyygNEEASxlNZ2MfqHY6wea8+kLpqnqwFqLJJrVnySAiapUaR41CbBqmhZlt58P9okg/y8aqWYUCPuwKCnKQ/EDM1YLiQOSGUu3WNBJdTQBTSm/dNislu8MKJl8zEc1Vja/FPeSA1ZT8m3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Px18xs17; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Px18xs17"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-390dd35c78dso873980f8f.1;
        Wed, 05 Mar 2025 14:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741212462; x=1741817262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJ4RXyP2ObVyUAS7GvxgV7NKCHNu99kLZisTNWnNyX8=;
        b=Px18xs17jFd4JC2IGZ5+Zqj4CYG93QZQ8o7y9kUEzL/R+8YnUpxt3yXkpRHJP0/jms
         R/5RDfzQFI9Qyh3AZX/tN6E1/nBxqpvUHyKjk1YZFmf1CBb/MNvsbYsCcd8W+V/USL2L
         m+mMI+ox/ZXqh4JXqgd2VV3cQQdQSER9BZq4PJ5xXNb3n46XvEiYWf9YOx722gOJ3m+g
         dxhOTUOI8of8bRQ/Gku3BGiP+mRBcLHAdOcZvxGYUnf/T95+qud5dAuSl4IbgKpqTmyR
         j96BaNjki0usOpO2tXlBIniBotU5lUugMiH2lV9Hz1nHN7LjeE2NFmG5D7RLMgMxb87U
         ihRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741212462; x=1741817262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJ4RXyP2ObVyUAS7GvxgV7NKCHNu99kLZisTNWnNyX8=;
        b=p9Lm+4nbTbeEGzlEl3zB66hzfdN3UZBa3G+ewva7eouGLgboULVVRIRmiiNZUeuOsC
         V6VrHMj2R0rVm4NhKO9c8/twg6ZBm+BlftTWZeOG+aYgw0qqBZUtVbXC3TnEjUQSDFMN
         OSFYcnQFr6YuRiWJA7qiw3KwI6AKdAfoS4vDFmHnW0BNgxCSw0JPamU+g3cNdjQeFk2N
         eNEAqk+VByqg3TDMVXq9N9yMxZxdSrS2InxjW6LDjfm48Ef0Yby+IY1goY9JF9MAhsZg
         9L5xLOg7S8Xe2wG2ryocSlMeEJmWQ8OwYpCe/ROET+fUviGlxI+X/DbcM7J3/N8aWnGD
         W01g==
X-Forwarded-Encrypted: i=1; AJvYcCXMpJorFwfVcTCd+JQEZoTw8rY2mkmt/DOGSUHir3hWKRmTumi3ilCGwRlISQHip+98RiOODQXQIGIdteA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUAdPxvasGCoKHfTHwL3NwXAyg0NI/dLNKCO7E/g7TAjftwbnz
	jVnOp6rlBn47bCLfseB27II/FDqUJ/JTr//c3FmYP/nglIdkOBOf
X-Gm-Gg: ASbGncu9AedE/FkBWhli1S0+ic/LONK/mThyO6kmIhWlDEmAD1i7TS76Mse/fDoU0+V
	YRmWYcae0EcHcojSfNNeI25FlUO+V1xUFB6Ux4vatIeZ8CtvfugJeK9FV7qCE0NGRI8LCL/ULSp
	fanGDbK/nq8Jtes+Sgn2FTYhye8m5j+Bhrv+qyesOAKddTwj3wlBwkiwcdSGFOc9CTYjj2ORajI
	iZORjEJQT1g38+EKML58jc934U56TjxqBje+SO9tgtROS6/f2nK1GiVaozm7hluI+0YjP+CX92c
	FGyKslTSFW+1vRvFhlLycQsSG8RNiPaR0l/4KAlKxZYDslCPagzCYZzCnyaEWtXQlrlTVwx8nmT
	mSwoGa8I=
X-Google-Smtp-Source: AGHT+IFOaAhKCQu7aLZUn/BnXQ8EJArByokwuaJFV+rvT5UJHaY5/C85XY3GI5k6+jjciy4ajP43tA==
X-Received: by 2002:a05:6000:4006:b0:391:23e6:f0ac with SMTP id ffacd0b85a97d-391297db9c0mr853400f8f.11.1741212461562;
        Wed, 05 Mar 2025 14:07:41 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd426d34csm30380965e9.5.2025.03.05.14.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 14:07:41 -0800 (PST)
Date: Wed, 5 Mar 2025 22:07:39 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bill Wendling <morbo@google.com>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel
 <ardb@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Justin Stitt <justinstitt@google.com>,
 linux-crypto@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] x86/crc32: optimize tail handling for crc32c short
 inputs
Message-ID: <20250305220739.1cb4b61e@pumpkin>
In-Reply-To: <20250305191608.GA19889@sol.localdomain>
References: <20250304213216.108925-1-ebiggers@kernel.org>
	<20250305142653.751d9840@pumpkin>
	<20250305191608.GA19889@sol.localdomain>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 5 Mar 2025 11:16:08 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> On Wed, Mar 05, 2025 at 02:26:53PM +0000, David Laight wrote:
> > On Tue,  4 Mar 2025 13:32:16 -0800
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >   
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > For handling the 0 <= len < sizeof(unsigned long) bytes left at the end,
> > > do a 4-2-1 step-down instead of a byte-at-a-time loop.  This allows
> > > taking advantage of wider CRC instructions.  Note that crc32c-3way.S
> > > already uses this same optimization too.  
> > 
> > An alternative is to add extra zero bytes at the start of the buffer.
> > They don't affect the crc and just need the first 8 bytes shifted left.
> > 
> > I think any non-zero 'crc-in' just needs to be xor'ed over the first
> > 4 actual data bytes.
> > (It's over 40 years since I did the maths of CRC.)
...
> > 	David  
> 
> Sure, but that only works when len >= sizeof(unsigned long).  Also, the initial
> CRC sometimes has to be divided between two unsigned longs.

Yes, I was thinking that might make it a bit more tricky.
I need to find some spare time :-)

I wasn't taught anything about using non-carry multiplies either.
And I can't remember the relevant 'number field' stuff either.
But (with no-carry maths) I think you have:
	crc(n + 1) = (crc(n) + data(n)) * poly
If data(n+1) and data(n+2) are zero (handled elsewhere) you have:
	crc(n + 3) = (((crc(n) + data(n)) * poly) * poly) * poly
I think that because it is a field this is the same as
	crc(n + 3) = (crc(n) + data(n)) * (poly * poly * poly)
which is just a different crc polynomial.
If true your '3-way' cpu doesn't have to use big blocks.

I guess I'm missing something.

	David
