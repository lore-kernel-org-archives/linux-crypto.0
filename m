Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F165E318139
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779209277; cv=pass; b=Ri9Vuv98EeHy8UhOYFzuS1oXRO9TT3eCHwBW55fRs+UTj7mioeZJXgGakp5lAy3uz/Qmjk38yHiBs1wmRiVpBqAoiJRctHfvxwhQrmKzZGP5Y6LKpiOX720K+wz9MarJC6QG/Sk+wgvLLxc0mNj87QhmCjUQl6uH4+YX4evAL0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779209277; c=relaxed/simple;
	bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MJyiLPC7xbGlC40k4ca29zz3awDSYyq4dK8XgzHKtI0zNOCfqWePmHWVRHZ6/wZbfMPbhFNHpkzFiZYArORMmZl/uaY0BNjyKso3q8yr1btyTbE7xYJyPFzqJOz2zvWkwH4GdOLjFqztvijoxxgjITH13dYFLU1daGZYqpJEMtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qCDj36xB; arc=pass smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qCDj36xB"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12c8d0945b3so98c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 09:47:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779209275; cv=none;
        d=google.com; s=arc-20240605;
        b=jsAJ+OsfSbbJ18bO/Jpuf+mrvGLmxIpCs4vFNxfiadKVOoeHqUcLKjVR/UBUYShH30
         7IqvHYSyVfBqXzuBK70izcQtvp5W++SLRkDz6DQQdiSIu/5IhD1VfrWPgN1U4iIsR8e0
         p/N5DCVWgzsdguQoVTRoi2t/VKHpDg2hpucsS/2eD+P15HIRooYEiqQaaP22Tt3kI+VG
         I8Ix9GoebgcZBI1wwhJeBws8LZNyyhrNsVf7/sS63c2KQFsbKkN24umWIJun+aexcT7U
         i4PZqxC/jBzQJkeXayQQ+I/Ef5onBce8UHgDVVzeWGbY4V9GdkZNWBioh/7UWYnO8VL7
         hRVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
        fh=cSwSzG4C7qlKSB+jeLcaDv8noM2EPmtN6eGmQlf/gpg=;
        b=DgNKaAMmZ+5oZBHHK3TNfg/9xMNu/fPi8GMVhOOE0THWuVvzelq5e7zRSOTvoZmmcb
         xJxR2aVK3moenxniTq5V2XeT0MkijuIDkLgXFWEg+Yab+PrvCiR4qh8vSppvZvuRp3wy
         jVXk1ZwDYbJF9LbcmFgD8oR1ekZf2ppBDCTyL2TcynGv+hvSQiBk9A3nculRgGNepNvG
         xh91FgApBtUm278Ow0zcMlB+imVZvSJzyxkZF8dqug/GjgcjEitChr47h+1GUEZRYxGB
         qTrikgAyYNI+hX4Qif+K0iNH/e3uqYuWQLW2JUnzNcubodgtumCfJ2GMZXv+KGFRTsuK
         /MTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779209275; x=1779814075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
        b=qCDj36xB+gWsx5I++4gl23aTy/IsknfkUlDdViRQo5wucJqQ8XdghhD+kLpe7INyJX
         D5hDNw4zhXmqyvnDQ+SLTsfjy3d+aAzPtHK4Hf/yZvzw4vcTdOfCgbx45BElKmR12hfX
         pu5c2HaqaT73C2IpAxqMFMcZNTBN0dPwrTcBUBQ9H3m6bZt6mx/YJhlrLDFNw5Cvbfji
         jvAUMXhEKAap1D9lrGHZsUO74k7gq02nBUlPXXnPBlgSayaJKDgXw3EWOzWfApAElNs6
         BfzZRPCYgAd0MgV4u2ao7+QnmxOz2O+5xUIt6DXaGaTbjbG45iFgS0OcpDl/H5i84vQ9
         f0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779209275; x=1779814075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
        b=k41QItOMJLk68B7SwGQBoxhnkdq9u/m/Dgba9Bzi/agroHHRDdwR4qYW9tLcMB7XRE
         ygteL/hrz56KE9Y5AKQO6mTmzC5RavjF/Aa6g92oWlHhSdAwydtdMlUJ5wfXfkoxE3V8
         pqUAtPoDi3vJJGBi7AQ+et0d2/EhX4Zz9oowMYi/SUUyf0oDQHuH2EPjIIh+I7uf+2PW
         aYKpimn5qAbeUQ8Z9pL1UeQDmCppjpt1sZBCUNIEXn2zOmIn4wqkth6b8PTQpkgaQbvo
         am90zukzud4c86JMo4mZXuN6uFvThuozzzzhSSkcQoZEHVsh5bfm2So9TnZCjq9N2CgF
         gbjA==
X-Forwarded-Encrypted: i=1; AFNElJ+tkr+JaPWOb62cDtNcM39T2DZVbKPBACJDYTKnCZSMUz+3vj9LoDD55/sX8x+24kVfzTys7r+4YwDBtpE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNhogTVj3/L82YSYCZaLXgPXm6v86scBGR4uJc/Kq+IMe7z5bm
	ewb+buTkJUMs/gcRzLtANSJFXJYwdf/010hPS8G5WP2w1pAY6LemNKtgs+AFRshBEPEsdmnPF1b
	k89Ok+wLqK8AKMv6Fx5UNbgpuuNwS0ezMtqiGfyxg
X-Gm-Gg: Acq92OH0bElI38qm/g8n4fqrxzUEhY1xJ2MBgL0+hB3yDlnNkJZJJ0AXmqgGyasjFQI
	XCeDEjwyFkiTv9aL2qSb9yr04betB90dDGgyZRF2y5TA3GTJPKjUbMyaqHxu9kwm/BQMvnVyMLD
	9Er7XTHZLNv1Z+bSfhBFIC611j29PMaGFaWFRPa+XqVKwqJufz5gIKClYxYUwulWllkmOAdtCOA
	TeaKb1cnzqUxd6co91DzRR7QX9fqXgwrX+/Ahuje/9KKT5CQKsrkEpzwv5jpqer9brhPQamIs/p
	ZVWrMY8++lrzMOteuSn2Yo4/aZobb179HR3gpBwoFlsbUE67
X-Received: by 2002:a05:7022:41a3:b0:12c:2ed4:6314 with SMTP id
 a92af1059eb24-13557dcef85mr326451c88.1.1779209273823; Tue, 19 May 2026
 09:47:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
In-Reply-To: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 May 2026 18:47:15 +0200
X-Gm-Features: AVHnY4LvG4Du5d39_T67NOwKnozMptM-y7xFRUTkKn7VXkYMQfWRo6DTkXiA7Lg
Message-ID: <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com>
Subject: Re: [RFC] TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: Ahmed Hassan <ahmaaaaadbntaaaaa@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 11:47=E2=80=AFPM Ahmed Hassan
<ahmaaaaadbntaaaaa@gmail.com> wrote:
>
> Hi kernel developers,
>
> I am sharing TID (The Instant Destroyer) v2.0, a Linux kernel module
> written in C that addresses a specific gap in existing security
> libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)
> flush CPU cache lines after memory zeroization.
>
>
> =3D=3D Problem =3D=3D
>
> Standard zeroization functions (explicit_bzero, sodium_memzero,
> OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do
> not evict CPU cache lines (L1/L2/L3). This leaves residual key
> material measurable via Flush+Reload (Yarom & Falkner, 2014) after
> data use ends.

The thing you're talking about isn't really related to the
Flush+Reload side channel attack, right? You're just talking about
flushing cache lines.

In what threat model would this be an issue? Normally, the goal of
memory zeroing is to ensure that sensitive data is wiped before an
attacker has a chance to physically pull out the RAM from a machine
and plug it into another device that can reveal RAM contents, or
before an attacker gains physical control of a locked device and can
connect malicious peripherals to it, or such.

So for this to be an actual security problem, the device would have to
keep running in a sufficiently high power state that data caches are
not discarded, and at the same time not perform enough memory accesses
to cause this memory to be discarded...

Assuming that this is an actual problem, why are you using a kernel
module for this? At least on x86, CLFLUSH is unprivileged, so crypto
libraries should be able to just use that directly. (There is the
caveat of what happens when the kernel migrates pages or kills a
process, but that's a larger problem.)
