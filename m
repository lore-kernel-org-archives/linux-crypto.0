Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D90378D92
	for <linux-crypto@vger.kernel.org>; Sun, 26 Jul 2026 20:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785096663; cv=pass; b=CEQi3q0kJGWsPQYU050BrT/ne92XfqUawRGEgVSiCTSrCeADFRSKp5ARl5RmNO/A65et4cBAW7z5hZycQfW3kVgUIvvvt4DFWi2EnkUVIj0+WL2Ef9s3zfnN82dj1jThqH+ZNXIxbMRjR9l9Drrc7QF35FqxvesTBwtimeAtv2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785096663; c=relaxed/simple;
	bh=kWd2ZlnaGIqOzhBDtr6CPo+wqxbzhTWntedFRzAihME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pdLDemwrQuW51osbEC1x06+3PXYYcdg6LBcMB2kS29MkB0poGEXdbo6dGWYSaRKi0DCdK5g7vQNkY+F3R9TneWPy9tBxuM9z6xaEjcvANcLx29+9juk1BHFXtOmCGYBCgV93fFbzGPqnNKdy3PnsdI5BnaJj0QtOTDlNxbmDR2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bWjNmrzf; arc=pass smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bWjNmrzf"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso2892279a91.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Jul 2026 13:11:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785096661; cv=none;
        d=google.com; s=arc-20260327;
        b=gorv0Q/bsKTFrPxCu/H2uG1MVJv8LuvVQxmp4u8xsZ0N0YFfaWYjwIjsxT62XZwlWt
         SD7K8C9kJzee6Q/mXYhUZyQPHqHaEZJ/fOPMUaiRfIS4VKmrdJHEioL8c1M0MiXa6C4G
         lnmWZYOihDog2qbMu3YR/1faWU5fwsS8yksSJhuRr/FHDYvCf0/8B6EdrI3dI7K3XyM2
         RkPpEB5bhm40KSl2Ny0RI6ifSqZpML3nsb57kCm6siRIKi+cQ+xjQFaUx81/IIopVNdu
         3rFY2N0T3E3GA0n+AIAwdSXf3adqvv4vuJsRJ9IfXdkNkivMkZ7yDHrkvDlrOpD23US7
         L0pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2+Bo0viCEB2m22FDhwGjICfsYsQ1DUFzTfnhxFo1SU0=;
        fh=sCSR5KSY3lUNxy7Pd2zou3oP/bLrLhOAoHPbabu4Vv0=;
        b=WqwFRUW3mb3ik83JsKXsgJn621fzo2AS6ujjqVNzEPCxLu6mG2KM5kOyHjeEQ7RA7n
         bB4SMsTkQNwDexT6G+SwOUMiovbw+yMs/eUFfTAyrs3u8JVBVPdQz90G+QzurbcU2uEm
         iRMDmUZ1XV5HJNhfxGFdE8LABaX7x1pTMyKcHW8n3rBkiBap+J5M/FAGulg1G5q9p0r7
         RG2u5Gxcq+F4yWXv6ctXU5hJFaCWRIsKNwm1hfKaFhpLeSLFti86K5rRjx/swCBdOnSF
         Rp4Q41+NMFe0hXXNtyvstujnMzc4D+giIElPsXOxelQhiMRNAYuq07l0xCAbE6kcgVI9
         Q3bQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785096661; x=1785701461; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2+Bo0viCEB2m22FDhwGjICfsYsQ1DUFzTfnhxFo1SU0=;
        b=bWjNmrzfOcznBPitgGj/HS0xLXFm9c9EvME+U9Y38WewNosDqzxcptmAggNl6jtEYm
         THi8L8kT7chED9bWcXg7+qUv/N7TMowQCnPZL3LwK7fkr6tym+6FhlhoxdYN4k1BD/Uf
         9qaSxmxHi4Sjq3UYpbzBwI0DQFesqVWoJqU2jiPsnBPApLeCtmNo0OUMuH18+2f9+5LA
         oo9hGHabcykOJDdvexQexzB4IBppCw9JBRQRZdnqM2zqJLAfzdlDvLn0nywYK8qtiGOj
         x9pUhyT/uAItjv0TDjAWjuOVo5/1tolIctW/xUEQ+wdpDz9bPsJdIrkZuxbm8Nu+sMBL
         pOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785096661; x=1785701461;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2+Bo0viCEB2m22FDhwGjICfsYsQ1DUFzTfnhxFo1SU0=;
        b=V1b+OuPQeDPHK08mIzOarME6pyhQ6z6nHysu3YhV1WxHJRZauXoFhWcf34AhzXrQ+/
         p0hbwwJ2jc6Q42j3NSzsP0Qzfhwsrmv9ZU8EWL9GCR/iEP+cbsxnk4ohmw/HS2m0LoLV
         5dH48bahSMJcuVuXXGuulsJEwKAso921RBp7BAuK4S0Ff3x2sQQQYgaFS7dkUL1t454m
         vuHIQCqLGpOgqXiE5rTlfsumcmRJb+OqQ//BEFo3mJT2Dqqzd3AY2SKOAxAk+UEacAFd
         soNwGQ/En2VKvSC0jMR+uDH/oGDd8zazevoezK62pW1KGBsxHfW1G7VFwyEHckc4Z1rl
         1zJw==
X-Forwarded-Encrypted: i=1; AHgh+RoTPZ2kSRQX3RIDOFqbSNyUcNNApi5QePq76P8HGuF4LOVBxFqjXzrHPSVaPsJ9/rI1oU2h6B89KZdh0lE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYBpjmZK+/ktikZokKrvc6tKlG+329CfRlsSzdWHUzquRe7+1A
	5xvneVTVh6tykrs7DXtXJcYeWxG69b0kIZG+rHY5uN+1XU/R15pNlEzmkSr0frPZ7ivlq4sTf+R
	f/k0BgRu3bDlodUxs9UuDk5TLgJCMb2c=
X-Gm-Gg: AR+sD121tlCA4Mu95xeO3cW1O7o11WozeMO70LtO57uPfZLrpkDfNVNxITttgTYjQ5k
	NJnztVcPgAGx53bpMd4D84zgWUVNFBLNHEZQqOrMSQ7lR6eIYEqlpWnxqVcwGY+u/mRVHcoTJvg
	kGANsd+tgrYnEWwuWi8fNwFqn2rLug+YVxeASE4+Kn1uC6uTW6BZRXhlcF86Wl4cG3D6xBNCe7H
	rovoXUXenEby7VEMrTr1Iia6czUaxHbE2zLdV1hw2mEwklCSp7AcVu0RGO6feMN1BjWZTB0
X-Received: by 2002:a17:90b:384b:b0:38d:ef48:b04 with SMTP id
 98e67ed59e1d1-38f294ea3c5mr6088330a91.10.1785096661118; Sun, 26 Jul 2026
 13:11:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com> <amOGWwdjnJqyxH5L@codewreck.org>
 <20260724160034.GB2032@sol> <amOTjPW__CNZui3_@codewreck.org>
 <CAFLxGvy+ec3nQLrQtwFZgGELhT2pKBDnHdD0pMvEGh-Mf3rjgQ@mail.gmail.com>
 <20260725220443.GA41199@quark> <CAFLxGvyBGzfwh61F5YkYqctNPCQJCpFOwTtKfDs4L+iK8WJZpQ@mail.gmail.com>
 <20260726155024.GB1673@sol>
In-Reply-To: <20260726155024.GB1673@sol>
From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Sun, 26 Jul 2026 22:10:48 +0200
X-Gm-Features: AUfX_mwZurnXooec2A3FqadK1K8O_igYrMZGYhDFbqwtbTaFK-ATjGnI_bmWgHQ
Message-ID: <CAFLxGvzaAH+ZGr-OFo=Li1aOxgwBjjR76T7m1CjFaL-6w3KPPQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
To: Eric Biggers <ebiggers@kernel.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>, demiobenour@gmail.com, 
	Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org, adrian.hunter@intel.com, 
	alexander.shishkin@linux.intel.com, ardb@kernel.org, axboe@kernel.dk, 
	corbet@lwn.net, davem@davemloft.net, edumazet@google.com, 
	herbert@gondor.apana.org.au, horms@kernel.org, io-uring@vger.kernel.org, 
	irogers@google.com, james.clark@linaro.org, jolsa@kernel.org, kuba@kernel.org, 
	kuniyu@google.com, linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, peterz@infradead.org, 
	skhan@linuxfoundation.org, willemb@google.com, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 26, 2026 at 5:52=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
> Then I would suggest that skcipher_bind() should check if the name is
> "cbc(paes)", and if so use 0 instead of AF_ALG_CRYPTOAPI_MASK.  Please
> go ahead and send a patch against mainline (for v7.2-rc6) if you're
> interested.

Patch sent.

> On cryptodev/master (future 7.3) it should get an entry in the new
> skcipher_allowlist as well: { "cbc(paes)", true }.  That would be a
> separate patch.

Do you mind a new field in struct af_alg_allowlist_entry which indicates
that  AF_ALG_CRYPTOAPI_MASK should get bypassed?

bool bypass_apimask;?

> With those it will keep working as root.  (And you mentioned in your
> other email it's used only as root anyway.)

Agreed. While I don't know whether others out there using it in
non-privileged mode,
let's be conservative. If something breaks, users will speak up, I hope.

--=20
Thanks,
//richard
