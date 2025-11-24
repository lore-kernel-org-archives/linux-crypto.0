Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227FC3191C6
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764007595; cv=none; b=sfEB51kpyeD7Znjj3JUB+CDyKKEaCQ5MAicH6tnrgVtBzdbOT3n+I5ecvb5coMSTYsVSl6wn6yLd41ZlPyo/2LXF9GlwnFYkVrDGbDyJsGJRvhXJfS7EOWrzbl/iteClxj4fovTzIdedlhVVpyaTV3U8Cv/nW9rV+wII00hgX10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764007595; c=relaxed/simple;
	bh=4jyjA348Uccis+uPWmeHP3/Cr7AKyDETtMz1PjRInZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YxxgWmecDT+wWMAKd/ne9bbS0Eqt0AvkowoaXYJcV5GOW5pbvVk1fcybcjPKx8Eb/Sq9DkLhZsfzLsjF3FouJ92Ctqlgwh8k4NAwadps4xlhVEamQlYT/pCgMuUx3hgxEUzEUXBosjSFTQiayVXS5dL7rDXkzTE6/YhuHxqt0XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=bJfgEjmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bJfgEjmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82003C4AF09
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 18:06:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bJfgEjmE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1764007590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zi2tifdlnm4pilxLA5hX4iEYZ93yOyBEU+BXbr3Wug0=;
	b=bJfgEjmETChnLppoIv6NT9bWBm3wI4/mCbWKrAymfn1VES+mbp32JL97LFvDxqmeueLv4O
	FFCaD69mAbNsuPwF201bdzYtwP4UDgBUR9ztYOjJUFiFK/o354Jg+YhauFgxFBxVQdw4eo
	yqdJx45EXqfxaQG7IeR79zPkIMAkrHU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 37074352 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-crypto@vger.kernel.org>;
	Mon, 24 Nov 2025 18:06:29 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c7545310b8so2170497a34.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 10:06:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXqiTqLh3+g5+QWFao6RnWlzhPs92Ah/5Rd9BHN1aTpbWBsL3r+rsqPlvv78A0m14MlMCXYMYb88oiv0vw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiouPAL5dLvpBYPp2BeVvNeMwFo2aunVM2rYMenpNXCw7taYGK
	0XBf3ZDqPZueGdiogq6YnO3kzpsnWYCFij+J6MGFy752a6UX1ZbpNeXR6z/D7kRhONSqnTuUzin
	jHraGHmk8Y+CoGvwfYq9N99ADAxBg0fY=
X-Google-Smtp-Source: AGHT+IG9yFbAB9mPY1ah1S5DbEkyC1/NUapcR00z5eBy/hk+C134+OhB4O0SLZVWNpbSJa6pmV5YrLb6e0Z4ZggBlyM=
X-Received: by 2002:a05:6830:2644:b0:78a:8b0d:cd54 with SMTP id
 46e09a7af769-7c798cfe6a7mr7062422a34.34.1764007587801; Mon, 24 Nov 2025
 10:06:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120104439.2620205-6-dhowells@redhat.com> <20251120104439.2620205-1-dhowells@redhat.com>
 <3374841.1763975577@warthog.procyon.org.uk> <20251124164914.GA6186@sol> <3647621.1764005088@warthog.procyon.org.uk>
In-Reply-To: <3647621.1764005088@warthog.procyon.org.uk>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 24 Nov 2025 19:06:20 +0100
X-Gmail-Original-Message-ID: <CAHmME9pPWGKAdm83wKhc3iHCjgZ8gOtZnt=+6x5V6D1prMb2Gw@mail.gmail.com>
X-Gm-Features: AWmQ_blyTgayiMTPgpS1b7DE0B0LOV2Mh4edriTwnBqHPtexJGQ8-Mu5aOF6q1A
Message-ID: <CAHmME9pPWGKAdm83wKhc3iHCjgZ8gOtZnt=+6x5V6D1prMb2Gw@mail.gmail.com>
Subject: Re: [PATCH v10 5/8] crypto: Add ML-DSA crypto_sig support
To: David Howells <dhowells@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Stephan Mueller <smueller@chronox.de>, Lukas Wunner <lukas@wunner.de>, 
	Ignat Korchagin <ignat@cloudflare.com>, linux-crypto@vger.kernel.org, 
	keyrings@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 6:25=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Eric Biggers <ebiggers@kernel.org> wrote:
>
> > Still not really sure what the point is.  There's only one user of
> > crypto_sig, and it could just call the ML-DSA functions directly.
>
> Is it your aim to kill off the crypto/ dir and all the (old) crypto API?

Probably entirely killing off the old API is going to be fraught
because its abstraction has leaked out to userspace. But to the extent
we can minimize its use over time, I think that's a good thing. Even
for crypto usages that generalize to a few different ciphers of one
variety or another, I think being explicit about which ciphers and
having purpose-built dispatchers is usually a better route.

Jason
