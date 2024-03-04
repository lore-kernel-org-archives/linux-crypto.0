Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1A94C64
	for <linux-crypto@vger.kernel.org>; Mon,  4 Mar 2024 05:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709530742; cv=none; b=htlPiRt+MT7BQPbYWzteoLX3oBCKEiKMoskn4xzazEKVQCFklDR+1D3/gqLuOmRZPyw+1TR2ttUF4Ih+4WP7zp25HeM1drLrKrRHAtHr+Wk7X0u/lm8ObIY8sa+sQpIp+PwQ6iEKQq6gdHsGs9M4Lavc0fWC9tcrBmdi4zbqEyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709530742; c=relaxed/simple;
	bh=IGMpVOaDuul+6Yn30cVRBhndZAfKwj/zXJ64LiBFh48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bfwlH+XqBKb0ygYvHBJF87b5+GGrkFMBPfQkrMFv9fli7hhu8p8VIZP5OHHgMZ8co4AmDieNEbqyfPzr91GuFnjNNAcrvlFy+y1v6ZZEwcAqQzNRXDz428iVdmkMupJqllslQdcXcnnvNqzZobOOUzVS5bVTZpaHLQUImqL/7lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gKziHclK; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gKziHclK"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-21edca2a89dso2145390fac.3
        for <linux-crypto@vger.kernel.org>; Sun, 03 Mar 2024 21:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709530740; x=1710135540; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGMpVOaDuul+6Yn30cVRBhndZAfKwj/zXJ64LiBFh48=;
        b=gKziHclKL6kRKHhUUHtp5D48eFsgV9fGEPFXx1fdSSTP5d+s1vm7Mj29IWn4P0mOyj
         ZMKAIUnEKELZkoD1TD9sHp/lZXq190sCyteTM0qF2s33698XFrYhkm3TURwLVeY6RU5I
         LFg6gajC86Mpjnh10ucoqIuQQvQXEM0KSOpQzNS2a+IiTMyBXDkIxXFFSC3zP1y62gaP
         qK6mU0ner9CTCFBB2LDAym4RUuYJUrDNMwyoVMl46IlOMG1T2LrwLcPEfBMWgOuiu3mT
         IV2wDQfBmj8lpo2c63omVSIx6xouDfOeokMCiC0Fsv6MjhgNbS0dtqbS/MTpsmgX2cnW
         MXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709530740; x=1710135540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IGMpVOaDuul+6Yn30cVRBhndZAfKwj/zXJ64LiBFh48=;
        b=QmltAUG2jVWBGTENkAgAF1bOTkNqXtheeo2X1cO33sqHb5SrtmDx24ftjWMSEHSIq9
         gjfoOO0IetPv1KOkJLwvucYSh5zdlR1/LvypuvN97FUHPH9i1p5gTWe/y5dBLDyCfzJo
         /2+CpwYrgYtulODlPimm65svuEkZVsDo7DK7YdOgwJHbcHwCL80ZcoK2nzPMzHnUo7Ut
         Rs0foCAx2kXA1XwIOKz8pJaDeoBIf+uiOnAMJUE8zx/PGW3IJ98PYw6wCL+xcBzj9Xus
         k4p+fLXU0+kH3L5Vhl/Q1bGl+gcs3q/JcG6jLf0T5jFBFKBaOScgZJ235jz2NgL7oBVs
         QfCA==
X-Gm-Message-State: AOJu0Yzlk2L+LlE5j8lEEprEorfI0OwhLCDRUrVGO1UZId9wSDZYa3Eq
	EW+ciNQgyZSmRPrJc/ktRZhm7mIIVGxURYerp+d1Rh8bgh2G/GLORz0oGRieeSR/Iczo4jzC4sY
	SJCxplhlT6fZZDoV+WhxqD9MfEabzgsfjwQ==
X-Google-Smtp-Source: AGHT+IHnmDtbctXAiyWMPBCWDvaXeE0sMDe32eReEpD9OvzX4JJe6lpujWY76gROCcsqAhHrXX+pOCJj/HZ1TCmSOIY=
X-Received: by 2002:a05:6870:7b50:b0:220:c3b8:16a5 with SMTP id
 ji16-20020a0568707b5000b00220c3b816a5mr8097354oab.26.1709530740478; Sun, 03
 Mar 2024 21:39:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALq8RvJDQ9U4x_Beew0jGQqSQtm3TGXh9m5aSvrzPZeft0h0Kg@mail.gmail.com>
 <82a5cacf-73f5-44e5-ab65-0ff9554037b3@linux.microsoft.com>
In-Reply-To: <82a5cacf-73f5-44e5-ab65-0ff9554037b3@linux.microsoft.com>
From: "Jayalakshmi Manunath Bhat ," <bhat.jayalakshmi@gmail.com>
Date: Mon, 4 Mar 2024 11:08:24 +0530
Message-ID: <CALq8Rv+i9omudxjB6B2tP4ij+-onKuZ4s2cju62rX6Hf=FhzEg@mail.gmail.com>
Subject: Re: https over ESP is not working in kernel version 5.10.199
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Easwar,

Thank you for the response. In ourcase 5.10 is the identified the
kernel for the products to be released.
6.6 is not a feasible option.

Regards,
Jayalakshmi


On Fri, Mar 1, 2024 at 10:29=E2=80=AFPM Easwar Hariharan
<eahariha@linux.microsoft.com> wrote:
>
> On 3/1/2024 4:35 AM, Jayalakshmi Manunath Bhat , wrote:
> > Hi All.
> >
> > On our device I am able to establish IPsec IKEv1 rules successfully on
> > kernel version 5.10.199. Ping, Telnet, http (port 80) etc works fine.
> > However when I am trying to https to device, operation fails and error
> > is in xfrm_input.c and error is
> > if (nexthdr =3D=3D -EBADMSG), nexthdr is EBADMSG and the packet is
> > dropped. I do not understand why https fails.
> >
> > Have any of you come across this error?
> >
> > Regards,
> > Jaya
>
> Can you try with a more recent kernel? Try mainline, or a recent 6.6.* st=
able kernel.
>
> Thanks,
> Easwar
