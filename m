Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADB33161B0
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004481; cv=none; b=mOEkxyBMe9+xSST0uM1veAIIScBR7VWkdvTKC6x/2x48OAzEYl8cUI71IkEpNp5PWMayu/hbIcZIOido9zL8OBDJy302r04z/+iLmQ5sheyzBUdRUH2JE724tA5PIJySmsqHdY5igMuYEFxeeQ5hnTZoO64BqdnVCj6A0yQoEYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004481; c=relaxed/simple;
	bh=8xZMWwd0M/dfhIr7wXGgaroo91uGL0x2y+lZDIOTEKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=irGLetg3/j5+SMTntvIYcAsQyIxEbdczEij6c+7rbUrPN1SGHusTN+KTOZOqyGPZ1NoU58Akqu33feXqeqa8CQMED7dB932VFcK22JILmUHmI84bUyApUwLp1JSGMLYj9wkW5GD1jlGovo/v4h2fq9GmpCOFFqNmstxwN0ZwAOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=TYKDQd6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TYKDQd6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08096C4CEF1
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 17:14:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TYKDQd6w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1764004478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8xZMWwd0M/dfhIr7wXGgaroo91uGL0x2y+lZDIOTEKo=;
	b=TYKDQd6wktM3o03PI9pF6JWye+ejRVsgMR6/YRWwk0fUa0XF1C314x3SCWBtJ1KOJ/rDqZ
	xPHKil8NdfA7i9jsoTbp/I0Laq9MG8D5okyvuCI49PLrpjxZqV8xPl0nu1wlUVvbTZ+inB
	ipPRRa0LL5ULefM4cPfJuubbVeeAY3Y=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c5ea3ee7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-crypto@vger.kernel.org>;
	Mon, 24 Nov 2025 17:14:38 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-3ec46e3c65bso3510483fac.0
        for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 09:14:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVGnrAbq2AlbsNW8JASL9ap4/6bzdZbDeX9HQ2jnDFcZnXstG4ScwMbuRDG9xya5ONb02RDF1oYCiYJZFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaeIF7yBbpSLKYZeoeda5HrRSZQc4ppJ7bPQlW8g276vLeAIEA
	xsM5KrHb9rR6ZWcNBw/9H/1enihsXjQt/kMr2p3M49TxP8b/3psx6BvGsdGv2L4M0iUHkCSmeOv
	mHB8Gh7SZg+7h7JAxWZV9+sc78i1EhCY=
X-Google-Smtp-Source: AGHT+IEK7reGzhaWGVxXVQGgGh6yxWORmMn9Q582UtpjAd/C5MidXLc/phYnLFk+JP2Qq/URaMBPD6y4jmzqoKThqOU=
X-Received: by 2002:a05:6808:2386:b0:450:cc88:ecdf with SMTP id
 5614622812f47-45115b5d282mr4294338b6e.45.1764004477074; Mon, 24 Nov 2025
 09:14:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251122105530.441350-2-thorsten.blum@linux.dev>
 <20251123092840.44c92841@pumpkin> <0EA9C088-D1B1-4E6E-B42F-EFE9C69D1005@linux.dev>
 <20251123185818.23ad5d3f@pumpkin> <20251123202629.GA49083@sol> <20251124090846.18d02a78@pumpkin>
In-Reply-To: <20251124090846.18d02a78@pumpkin>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 24 Nov 2025 18:14:31 +0100
X-Gmail-Original-Message-ID: <CAHmME9o7rw=Hi9ykfU4GD6Jxzo6Q404FVGVkUDh+RCjr_-DadQ@mail.gmail.com>
X-Gm-Features: AWmQ_blFd8Oom3QBpJeAp4lzwddO1DSYtupa6f0ggHanHL-ybTgmSWzEzyzvkzY
Message-ID: <CAHmME9o7rw=Hi9ykfU4GD6Jxzo6Q404FVGVkUDh+RCjr_-DadQ@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC <
 12.2 on i386
To: david laight <david.laight@runbox.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Thorsten Blum <thorsten.blum@linux.dev>, 
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 10:08=E2=80=AFAM david laight <david.laight@runbox.=
com> wrote:
> > How about we roll up the BLAKE2b rounds loop if !CONFIG_64BIT?
>
> I do wonder about the real benefit of some of the massive loop unrolling
> that happens in a lot of these algorithms (not just blake2b).

I remember looking at this in the context of blake2s, with two paths,
depending on CONFIG_CC_OPTIMIZE_FOR_SIZE, but the savings didn't seem
enough for the performance hit. It might be platform specific though.
I guess try it and post numbers, and that'll either be a compelling
reason to adjust it or still "meh"?

Jason
