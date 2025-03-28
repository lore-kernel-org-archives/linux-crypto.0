Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12A41E833C
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 10:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743159385; cv=none; b=oiYssg9nufnKt2/o7YrSehjhJ3NPK13O/wfWlh+12L87Rdkyh8SCXhvaGVoVx4T6ezFErC8YP4/JNJi/J+KEKpi9GR/c0/CthTy74Q85Gvhzy+F+gaaAQTzDruB8VEfDUzPZU7JUb4YsXFvb1vJLr0yPWdTh/s2TY/2Wx+QLUwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743159385; c=relaxed/simple;
	bh=uMI0AbkJYWx6k9EPEVYiA3DOrPTbKHoMPRjf3QRXAbk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bzpPwNrVsCf3RaSHHiiY3JBcfyUXLvCC2JeZAubMk+NG0C/NO/0YDuLRjpsXufqliH/Sg86S4SvPKebm8Jll+FF/OB728AHBvCPIkvHJSUkbwYx82t24yih253el6qRPxtVCB7oQZOGkjvIcBHnQMLyR12J285YGh7mznDKSDss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=Vu2eBr39; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="Vu2eBr39"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54298ec925bso3033265e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 03:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1743159382; x=1743764182; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olAaZIH94fzyjQz1l87PqHBxlGfOGj7K9uZAhtIX1OA=;
        b=Vu2eBr39qL9BMshmdiNmmS/mwhGUz/y7RmgcPl7Uzi32jX/9oJxhZOthKpzByy41r9
         Vi6/B2U1MGHnk2SiD0QCFaQJwgdTjEBss8XKtS5S1DF0pRTZ7tbRruFM6d78pxjS0zBu
         UnWBPgFv8GGDfuLgDO/gAQN6RJOyOo/NsyeVXeBv2SLruvSynYBohnCCac35XchCfmTA
         aL/LFH/7FvrxfgI8Dazws0iYu8ZzOazp2qIor0DuzldVMeGaD66DM8ZOAzyXGDCH3HKL
         Ptfh463M6V2ipLKO9g4d9tOI6B0Oz9K12iZZWaHCp82t7Mrr4GNN8Ih0G3vB0cp40bS7
         ckMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743159382; x=1743764182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=olAaZIH94fzyjQz1l87PqHBxlGfOGj7K9uZAhtIX1OA=;
        b=n9BTumNqkoonrLh8XIFpV5nO1XUgKdxc6T/tdNBJDFQ9DzUjFtz9f0eE6/iqKHvpi2
         Hb8HE/6R9mdlqmtk4UZY7eV9JIvVc72DPe+Ba4h80pPyOYoy+RMt6NtOfMHwKJBVr9L3
         kbAnLjXoB4pCM9CoA/7i14WcsKhfhIqJMdAQv6Sgb4S2SDeP54k2r2RjrH+X9D/Y4lcb
         N9Qa+ocKzE17ZMsGwtcT3uoJgunKHvQhykaDVPGJBbvOKRbu8ltNChcva+HZMYKrhTEJ
         Z9rzXmtSKnMb71u96qhrdiE+/UBEnhsGPMoDJlL/3QpxNrtttQhFMzLR9/JExW+ybppc
         tLeA==
X-Forwarded-Encrypted: i=1; AJvYcCV6BIJKpGgflaQwCDklQP99wc6nkIOyXglqG30pWHDq6GVMrqAJPxzIntfpvMK80xQaRtdFCt1WzJaoS+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzszXT+n6XizGTmqgEtgus4Jujd3R4cOyJ2caOklacYFHfZ2suH
	uJHRCHkp7RtWAglSAglIgl+0DBXAZ0FK8f27kGZ+CflmxeJnJuGX6WJe6GFAWpFM70lzCa8yj6D
	9X8AX1FsndcxtfGyM55ObXI/qphGniQwMaVAE9A==
X-Gm-Gg: ASbGnctPZou1p6NfkYJQVnzRllvXasP4VB0RhHCZ5evBPJtobOEnbeowLUmK/aw/u/3
	nuCykE+jOnvtclCWcZTAkkiJqcoYMNO+hoJ/gWOMaZA0mYC8e7FtQSWeAnMfb609nZ1SMC0m9Hs
	LXdsgFM5wB3R1FilV0n56caGfUDdaxnl9Rpi2EzirK/n4+vNert+PyATisTg==
X-Google-Smtp-Source: AGHT+IG6qEMn4qg6ENDbUAQbjwJMxqKnwp8APlPJPAz0/cgb1CSsy8tzKsGCpNTUBhVUaoe/8Dw3udJ1/fjM116S5qg=
X-Received: by 2002:a05:6512:ba8:b0:545:f1d:6f2c with SMTP id
 2adb3069b0e04-54b011d5675mr2814281e87.18.1743159381664; Fri, 28 Mar 2025
 03:56:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMRc=MdO=vPrvvonJPJ=1Lp0vFTRBtsEBUS5aqWp4yMqUtgfzw@mail.gmail.com>
 <20250326165907.GC1243@sol.localdomain>
In-Reply-To: <20250326165907.GC1243@sol.localdomain>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 28 Mar 2025 11:56:09 +0100
X-Gm-Features: AQ5f1JrrVuMT4qoT68KP0RJ1gGvhtPtOME7bP16opGo20S2NgsR2FHybwv0v3Bw
Message-ID: <CAMRc=Mfse2N-X9CNnpct211nfDNu4FewQ9qqnNQeqK=eQXoZGw@mail.gmail.com>
Subject: Re: Extending the kernel crypto uAPI to support decryption into
 secure buffers
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <kees@kernel.org>, 
	Jens Wiklander <jens.wiklander@linaro.org>, Joakim Bech <joakim.bech@linaro.org>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Daniel Perez-Zoghbi <dperezzo@quicinc.com>, 
	Gaurav Kashyap <gaurkash@qti.qualcomm.com>, Udit Tiwari <utiwari@qti.qualcomm.com>, 
	Md Sadre Alam <mdalam@qti.qualcomm.com>, Amirreza Zarrabi <quic_azarrabi@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2025 at 5:59=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Mar 25, 2025 at 09:23:09PM +0100, Bartosz Golaszewski wrote:
> >
> > There are many out-of-tree implementations of DRM stacks (Widevine or
> > otherwise) by several vendors out there but so far there's none using
> > mainline kernel exclusively.
> >
> > Now that Jens' work[1] on restricted DMA buffers is pretty far along
> > as is the QTEE implementation from Amirreza, most pieces seem to be
> > close to falling into place and I'd like to tackl
> > e the task of implementing Widevine for Qualcomm platforms on linux.
> >
> > I know that talk is cheap but before I show any actual code, I'd like
> > to first discuss the potential extensions to the kernel crypto uAPI
> > that this work would require.
> >
>
> What would you get out of building this on top of AF_ALG, vs. building a =
new
> UAPI from scratch?  There seem to be an awful lot of differences between =
what
> this needs and what AF_ALG does.
>

I don't have much against building it from scratch. If anything, I
would love me a green-field kernel development instead of tweaking
existing code, it would probably make the work much more enjoyable.

But if I'm being honest, it's hard to tell whether there are more
differences than similarities. A big part of the existing crypto code
- especially the driver boiler-plate - could potentially be reused as
could the existing netlink infrastructure for setsockopt() and
write().

That being said: if I were to design a new interface for this, I would
probably not go with netlink and instead provide a regular character
device (let's say: /dev/secure_crypto) with a set of ioctls() for key,
cipher and general management and support for write() for data
decryption. IMO socket() interface is so much more clunky than
chardev.

Bartosz
