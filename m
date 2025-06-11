Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EAE1B4F1F
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 15:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749657263; cv=none; b=uDohbCya/35Caf8ycsRZ5Mm/ijCCWff5asvPROmKCETAhBHHE5mD76qb10LoayeRkqPiD7Q954gl0P+3BtMSoG7fHe2ynrYhcA5L2hDugeMxetns2NGZJhyuXveWcBvN2ShQBneQpco3uZMjTmmVV228OalfAjes5Tkr11v0NAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749657263; c=relaxed/simple;
	bh=MNJifaaW2DKC7Ep+EbGEsZeWuZtW79t5zkE61iueUzQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YovZbJjkwOESNqE8p/hnNBrIPyD0mar2+zOOJqW7OHgDruPXgFe+cKvXQ3fylIVOFKoqRK4fkWzT26SdEnJGogYvLtoRZ8uOClPXttvAb374BtE1CDkEavTBT9rrtzf/PcyagyxrIWognlxsNF/WX6/nVYgrhII+2z40+YzTPnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=VoQZRUnc; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="VoQZRUnc"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-710e344bbf9so63278457b3.2
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 08:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1749657261; x=1750262061; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBhZQu6BqagB3PC5bDYHjkHrfQ+2AWYQFfsjZus8X6I=;
        b=VoQZRUncykxaGZ7NsMVcqtrTcp5nmfGaQziEJb32XqsWTZI6DGMxeVHR1blITt+Qqs
         F4ZIMuJCaM4dIVkrt1JLT6ircWVM4EmwCb32sw80IEIvBznEZ+gNvVax6xGMEsXWgvEB
         e5AHBdIrSwkRtkYcnPm514FFcCfdtbf3xCt0N4er71YLh31wmQS3O8FPjGaM5JI2c/nA
         fIwMS2I5G6xhiEDD/vAZtQKVLzpB0v1l7d0cHEWOMvqaMKYd2Wp+f8F8pPZYKTdolany
         NmSD6Pf7L8yUSJhryERsnSG/SXuFJ6HeKKqIgpj1Rt0a2/R9t/igWvnflEDMXU8BvDcW
         BClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749657261; x=1750262061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dBhZQu6BqagB3PC5bDYHjkHrfQ+2AWYQFfsjZus8X6I=;
        b=UQXEFoS2u9abhtvr6KsUQZVO+VyM0PUHd27xXV2Y9PJjKi1gkbUPExF2GsuTN/cQMS
         fVpyJ7ej+LJTh6qodUPGFl3YH7ifWFSEBmsnL8zzx4SUtny4/ygiCpsau5TxkMK8TIgX
         8tHoTwNT1OllgOUkOWRjJc4keFjLljWZXdPCrXlHlj9tTl5a+dAgFSUYsaXxnaB/YIH+
         Hvv2wUwAu/obbITb8mlFqn4/AmDMlEp/seSF33jET1bF81X8wD5ZCBh5fuL7db7AJxRY
         PHLbjH7DnhM+5AtxgsVCV3mWw32sCB5SYy8L4EgdnIw9t3S15stTPlf4URGOJHWXBaW1
         h13g==
X-Forwarded-Encrypted: i=1; AJvYcCUcvAQq+YDqjw13UwR+hBKAfpuOTFSZugqWOf/1vMIsGa0gU/Vp/pSIRjIiPPuVrnstcLgPuNZXgP2QHr8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQxhdRRaNTSEkuqEX2KlQ+pzsbRLNRBLInwGvwbxHIZJkQIWpp
	ezSJ+wNZ/4fA7Pf3xiONwzvqZ6F32ZqAHRO3qXpPDnDfIh4OwUCFK3FCLOp5U4UlmfgChjzbAp5
	kE4Gn7DHxqpfVjp8nrdd7ezltnAemVsf5MA3FcGul
X-Gm-Gg: ASbGncuyuni20ONpf6xC2p9P9lDKlx5EdTQ61o67II1H4PdDKzUynpSo3XMaEoTSC9p
	jmj/ttGVqgPn/jrgHSbW+zhVgwOTtPPMmbdYZZ4XPOf0vzQZ7DAEaoUH+B/mi2hUdO0u190Q4Yr
	JQWXbb6EY6JRn0XaMgarKqbmzcTOD65YpULV1kBDKR3Ec=
X-Google-Smtp-Source: AGHT+IEn+kC/BZ+RXwGYxRkP+XLD0tGlRkO0idFv9DQonG8a7gWIJr8vGNDUYR6rx6ZmmovcVVyDmS1thVUaW8UvqdA=
X-Received: by 2002:a05:690c:f8c:b0:70e:7663:8bb4 with SMTP id
 00721157ae682-71140adb8bamr52684357b3.25.1749657261129; Wed, 11 Jun 2025
 08:54:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <301015.1748434697@warthog.procyon.org.uk> <CAHC9VhRn=EGu4+0fYup1bGdgkzWvZYpMPXKoARJf2N+4sy9g2w@mail.gmail.com>
 <aElIgixaHGuHEnb8@gondor.apana.org.au>
In-Reply-To: <aElIgixaHGuHEnb8@gondor.apana.org.au>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 11 Jun 2025 11:54:10 -0400
X-Gm-Features: AX0GCFs9HQfkD829H3Li4br3UccO43H5X5WtKEy278IEIzt6bh6uwIsmTEf8mkI
Message-ID: <CAHC9VhT9k9+DWh14HEnv6V1T3=hDJFY-fOcE-nexPFv0jdL04g@mail.gmail.com>
Subject: Re: [PATCH] KEYS: Invert FINAL_PUT bit
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org, 
	Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025 at 5:12=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
> On Tue, Jun 10, 2025 at 08:22:59PM -0400, Paul Moore wrote:
> >
> > It doesn't look like this has made its way to Linus.  David or Jarkko,
> > do one of you want to pick this up into a tree and send this to Linus
> > properly?
>
> I can pick it up for the next merge window.

Great, thanks Herbert.

--=20
paul-moore.com
