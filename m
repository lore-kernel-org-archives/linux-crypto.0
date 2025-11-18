Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AC427CCE0
	for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2025 23:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508773; cv=none; b=k8JKF6RV35V6mLYBeAWt10HcUAGlTkvQ7LaMC8K39oYFnlC2HBP4F+qSuH1dqef2nPtsdbYG64EEN3Slrw07qzlCH570ipOPl7FrqZflamSHmBqciJ4B8wxR5T3abow8vJ2DHgqPBRliR+jJLKedhzEdaITeAaco/buuMGVJGKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508773; c=relaxed/simple;
	bh=gc+9z7LRBHbabfw3b29ZsJw9bP20wApU3Pk3FyrzDHI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z8THPguNRQvbeIXd+6SdT+rS4SokhyItQXUxwoYf6pvAbvKyGkqmaqX7OdoCY+BXkg9jtW6c8pbFOwM9/0554QBLSmR0pCieDjBayVzlY81v8PHoe6qXF1riGgriX7H1Ho/lWyuGShYUcEpkyS4cvfVu91mdzRDSStRSc5mPtsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XX5OGirG; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XX5OGirG"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640860f97b5so9682552a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2025 15:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763508769; x=1764113569; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DdOnk4vNud3zT/3fonf9hfUW4gFW7SUuhbuv817jh/g=;
        b=XX5OGirGDNwd3xJ0kLsOQsgMV2NfMhe1AB8+uP3HDhLGhGcAu1YxwAkKuUHDGkPS2O
         uoGVrRfV0azx+8hZukUNSrWmn96bdkJ5EKl6z+0I7qWjd7mvz58Q6PT9p8C1Gb5KwkuG
         7R3O5GGYp+snDhUwvv9YNjj6ZZaHgQF8SxnOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508769; x=1764113569;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DdOnk4vNud3zT/3fonf9hfUW4gFW7SUuhbuv817jh/g=;
        b=HVw8QB3+HOHwQIB7PD1AXYyauln+nJeW5ur1T5M6MN9cEAZF396mKr13H1T43CZ/k4
         puouPGxrYkTMNqWnzsze4We2hUOA1EOMlYcCjsKpnSeWyldaS0+/PsrhOrumCJTG9ScS
         XSgGeIWyMW5BCksCdBJQKEXCdal8XIfEsanMpu4OPBscI7qZyMre8Rmls0kZJAAZIKX3
         7vweI4lvq4Rp91FY2F60XpQigLLWKpEIUtxTcapABkbpEXsBLDAgvLmsrqosXXUpgYsa
         PkmVxqTEbKO7dqxTry33R1eGN9Tq4J/9GPMtOPwyeXkPxAzdDE1WlILWsHKkqUhIyyts
         OTvw==
X-Forwarded-Encrypted: i=1; AJvYcCUDhIaX5BuVe1NTIwFb9u9tD4OIboYt1gYbnTVNtfUiipLMCw9ZK54QfmthAo3XN1CKOwL04jzjqObDA2g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpoFXC3OKeN+27Ca95OBt3rhHqpNmy6r8QU1n7k9q6UYOp/MSQ
	q8h+0ooupo75VP+Sroh3KtrLzcKasGHwbqV9hO+YWj2tCua50f1R2h56kMjr/ajQmzgJSX4USxP
	ycLrISYQ=
X-Gm-Gg: ASbGncvvwrJEhzrcuUL/gtxiCP/dCAl9hp+uGjczNOu1vZbcQoDMpeASI1zNNiWwmy2
	GAdxLcl7KIzPYatQFMKF+SkQP00oY+zP7rGb6gz2s5pynP6QfPsVs9QAlkPRCADBgVLyKVFcQbf
	3dLof6cmjamXfAnxxLeHMshUpHeM4joUNo5s7AkQAjKCJfC7pOd4SqKNipFqZmtB5gS14sedJLR
	qLCpCwKbWByq6ouDwdW86TjRfZ9xeJ+FVTKRTtJV5eUsC1GDj5yqvvbSD25by9y9gcpegsPckZB
	1CJmVufrsJ/zBB/3FXPU7s6ZwLmhSbsLbCJtavr4CkhnpVbF14fX8N5PcEdCIeFqyffRXD+8FM6
	6GECsvtk0bBUFE5ASc0uqZ/LYTbTYbqnB1JAcVCgqkb8sh2m4dqbprBjmcHESgv5d5B1KDNq15X
	EwQra/xknXuQ6p4IFwlFhN3MjdCqcP5NTIfO0s5LMP9Ot4qc89gI+3M1FyFiIY
X-Google-Smtp-Source: AGHT+IF5i6+RdV8jhm7GxX/2osAaqw9uYPeLUISDk3ImXLzSRlZXRPRueaoEgfUwjYci/KZl52sytw==
X-Received: by 2002:a05:6402:3592:b0:641:6535:6ccc with SMTP id 4fb4d7f45d1cf-64350e201c4mr16976300a12.10.1763508769557;
        Tue, 18 Nov 2025 15:32:49 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a4b1db6sm13807841a12.26.2025.11.18.15.32.47
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 15:32:48 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso9763019a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2025 15:32:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXnylsHQoexwbt/gOH261i/VjkgThDDIttjeRQZazEcxI+iBaxcr4PZYWonuLOOPevq0c0S2hNzvR5cOjE=@vger.kernel.org
X-Received: by 2002:a17:906:9fcb:b0:b76:277b:9a3b with SMTP id
 a640c23a62f3a-b76277b9fbdmr442642466b.21.1763508767290; Tue, 18 Nov 2025
 15:32:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118170240.689299-1-Jason@zx2c4.com> <20251118232435.GA6346@quark>
In-Reply-To: <20251118232435.GA6346@quark>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Nov 2025 15:32:31 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgkKPgsmcC0SFni7hhQM_b3qNjoyzw_JL2ZVs2eWXEZWQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmtQgVMXLWCo7Ygrkt3hq066GQgGoFzlNIC0c_cAn4tPaf_oRMDBOYpiAc
Message-ID: <CAHk-=wgkKPgsmcC0SFni7hhQM_b3qNjoyzw_JL2ZVs2eWXEZWQ@mail.gmail.com>
Subject: Re: [PATCH libcrypto 1/2] array_size: introduce min_array_size()
 function decoration
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Nov 2025 at 15:24, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Anyway, I actually have a slight preference for just using 'static n'
> directly, without the unnecessary min_array_size() wrapper.  But if
> other people prefer min_array_size(), that's fine with me too.  At least
> this is what Linus asked for
> (https://lore.kernel.org/linux-crypto/CAHk-=wj6J5L5Y+oHc-i9BrDONpSbtt=iEemcyUm3dYnZ3pXxxg@mail.gmail.com/).

I wouldn't call that "asked for".

It was more a musing on how random that "static" syntax is and it's
likely incomprehensible to a lot of people - but also pointing out
that we already do have users of it, and saying that maybe it won't be
incomprehensible once we have a lot of users.

So I'm definitely not pushing for it.

But I do suspect it makes people understand what the code does more...

            Linus
