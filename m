Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670823B19AB
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 21:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226957; cv=pass; b=DS5NbcUAzux4sS9swFHT6aENvXYv3T/J9A/aq2A+t8lT8rgiiM1qRITLK8YYYEm9ayrwEc+k14DrpguP44b+8i/ACfc6/vblS9GoAJh6mMDIZbA7sL6vclCA7RgtYk4wTIjgdPJIQ43TpzdYEE3s0qrPufBMLIWbFSOLRgGnOxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226957; c=relaxed/simple;
	bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uuFOtf6bFbZ/1BxZpZO3f9PL3IDpUvSM7enV4S5zDfkpakJEIh/pvaGq6YpfjsDfb76TjxO2BhJLOJ0G+lSHJNm/haL5bp3BvC5ouLTkqWZlg3Supeil6ELucgiZhb3dmuQLnCxq7ikorHdQuVXVd39GB7N4foP2H+EaweX/Gy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cBBOp9lP; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cBBOp9lP"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67bf769704eso115a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 14:42:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779226954; cv=none;
        d=google.com; s=arc-20240605;
        b=j83eo+1TuGQiNiBVN4R7HVwD2Xs6B+X8XqlmszZpFx4YPNbcYXHcPlX2Ly0V7fCmKp
         S3wO//NqIDLpue7PGx9mWxZLAAqfshsGK1oSsuslRPSyDbQc3PIcmcv00bxbvqvdsoFs
         NeY/0Y076qESw7ZRf61B4Ykv77EJLkrikC0kCQJdqzysdg8UA/WN59MfXCNEfB2/ongd
         cliw3aEBEHv4js88iEGnNEZQ8vDYHm97epMbCSDph5PU0opPB50eIMcTpDm3QLT4tEdY
         a54Cl5zAOBru5s8RFy+57Ay3s2f8ADJpuf70ZZ9IX84z+WPb+9KOsnVAv0IpSr9S7AFI
         JTbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
        fh=HaK5aBvtlMQgRokX2eLhp8PVBrqYfX8QMWQnPjWQ7TE=;
        b=f7g0D/oh7TRzfzbBRufkr3275n+oBPgsfF+pl3yKtFUtune0/Hw2EotP0wNjElL/sk
         z8GpMaUsG080ZJPZ/1mnY6yNrJjCi3NeUiyaqZHOFgFQkJKxlkCmVw/5yBiSosSTv49Z
         8l33/q5ynDKwK3Ele6ZZIsTdox3d6Sh3K5vRgpJfH7kqbh+JFaf2BmmaJrRPmM2jTFsq
         SljJVm4LjbD9zhu+a64Rdvj0ThDtjZFgMvIScXWeWc2aHEsxjs426EWzFL6o5znFl6Zi
         FRZAL/HbufzJGDBSFXdWrDUyHGI83pJ+JUQStbQsYiMBOx7aYQfg79IZt8SDAV0dGljV
         H83w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779226954; x=1779831754; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
        b=cBBOp9lPxsBqzp5DiVVxXZDcRjTE3euWHcLy8b7vbCVmNAJKacI97hsJ3Vh0KDFaXt
         NXU/Zw17XqHcSHLDvSXAwaJJyllAMtOnzA54IEMDi5toSkc1FhEXHqZzqiln7NYZ4wvW
         lfDw4ZrKlWmzFMu6D/n8ftMX8TONAUMPAsEN31ppZN2D373vE0vjsNy/4phHOsAWuYNI
         nF/qzfTTzsfvL29YjAa8hB1+SvxRY6O7eKRjW3auOF834Bo2J3b1uCxJC4HpkvPM5oIs
         V7wciD7Ct1uavsVVCtQKUXyo51LalxiQasEvoLneaUrOkZFwJnRtJwnYl4KuZY4B5BFn
         MUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779226954; x=1779831754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
        b=O01/TWgIFVsvCzQmLcb6cxGiGy1sD57het7IGNX7SgUriXGJ/bQr1ysC2yI2fUpYA2
         JHU39qt4w8hOwQI2kfDRYqK4oM0DMltrv4T0MSMmBJI+itduKG0Yb70US3VsqohEw+1W
         ofnwps52Pk8sFRVKIRpTlECAw4JNtdNZO9a/OfZFTjFyOpfmRTTXLuEEmTIgcNxPtGO9
         7UUU675vjYqHYdS+1UEEg1BNX82g07xWzkJgXjYUt2KEYZ1OQLfj3vwETO5eCllF8K8a
         1CGSox2nxviUmFMbo0VIZCDosqswnQk6M1Ap7mwfTKzC54wjKfsHDLNbtAdK9O6gWY7A
         5hrg==
X-Forwarded-Encrypted: i=1; AFNElJ9AetRqCpDEgrELzbzPao4wNn1sXnBhbyjQZedGmz6oDEBxPPRSm0Wzi6s2rj+0edvTy9vHN5m4qkoj77I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0DVfMRDyBdV3u4eKC9Ts755j/7QjBeqyYZrvOv3dijyFr0fHh
	ybVA/Px9k/kKgGkBsnF81AwU3unhW/jHt5YDI2/PcTxlQVqZNWPkxF36FhWJwtmha7BpJw1JVZZ
	5r21OklsDkQCba2RvAbF2bH6mPSJgEP+AvDl9e1jhPZVXpZ9gUzeSVFCL
X-Gm-Gg: Acq92OHbUK3Mxr/kqlTbq7gLoWP23yi0JofVBrQ3eoIXkdIsMmHTmAV9LEIKOzwtA65
	ycw2MnS7D2DKQa2WXnnj6zy5dPbdincT+JyRY1Wv1o38gItGn5A8g9GAoTreq6QTxcRZt2894K4
	+Zdle/GLqaqOrd0phpsCH3uXjMsIlFAWGYQJduQGeDMbNXL5e6M1j3OLnHKucP5Pnhoz9y6S4yx
	OxRH8jNfIIhAP33yuXdtWyyBDqDgeGjZ5PP3VdnG6EhuR31+jOM0pt75r17K252s7ETXgm+5XXL
	Sf4HFwsQ8qkSMZz2X0TQu/NPUIA7VVe2kLMvA2HpIw+5vNg=
X-Received: by 2002:a05:6402:20c6:20b0:678:a5c3:4d12 with SMTP id
 4fb4d7f45d1cf-684985e277fmr173995a12.3.1779226953632; Tue, 19 May 2026
 14:42:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
 <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com> <CAAmtCfMHqdWbYh-Hc5sGbOhXSM-aCA9G0-s64G8FTM+rGEV5RA@mail.gmail.com>
In-Reply-To: <CAAmtCfMHqdWbYh-Hc5sGbOhXSM-aCA9G0-s64G8FTM+rGEV5RA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 May 2026 23:41:56 +0200
X-Gm-Features: AVHnY4KelXMX0Ox3UHP6DtmSDnRxPxmxV49wSNMKd-K67wpQhqz9skVmJZNDODo
Message-ID: <CAG48ez3u1OCx+zCWEs-_gowDmQ=KLbXO2xZ83LCZ1o1gxRT3Ww@mail.gmail.com>
Subject: Re: [RFC] TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 11:31=E2=80=AFPM Ahmad Hasan
<ahmaaaaadbntaaaaa@gmail.com> wrote:
> Thank you for your questions. I'll address each one:
>
> =3D=3D 1. Threat Model =3D=3D
>
> The target scenario is a same-machine attacker
> in multi-tenant/cloud environments where two
> processes share physical L3 cache.
>
> Example: a cryptographic service and a malicious
> process running on the same host. The attacker
> uses Flush+Reload to measure cache access timing
> after every encryption operation =E2=80=94 no physical
> access required.
>
> This is documented with real measurements:
> - Without TID: 78 cycles (Cache HIT =E2=80=94 key pattern visible)
> - With TID v2.0: 286 cycles (Cache MISS =E2=80=94 attack defeated)

So you're assuming that the cryptographic code leaks secrets through a
cache-based side channel? That would be a vulnerability in the crypto
code.

> =3D=3D 2. Why Kernel Module and not userspace? =3D=3D
>
> You are correct that CLFLUSHOPT does not require
> Ring 0. However, userspace execution can be
> interrupted by a Context Switch, which expands
> the timing window from 372ns to 36,640ns =E2=80=94
> making the attack significantly easier.

Why does it matter how many hundreds of nanoseconds it takes to wipe
the data from memory? You can also have a context switch directly
before you enter your cache-wiping syscall, or in the middle of a
crypto operation.

> =3D=3D 3. Why not add this directly to libraries? =3D=3D
>
> No major security library implements CLFLUSHOPT
> after wiping =E2=80=94 not OpenSSL, not libsodium, not
> glibc, not memzero_explicit. This gap has existed
> since Flush+Reload was published in 2014.

I don't think that's a gap, because the standard approach to
mitigating cache-based side channels such as FLUSH+RELOAD is to not
access memory at secret-dependent indices in the first place.
