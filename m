Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHeOGC3J"
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE1CCD
	for <linux-crypto@vger.kernel.org>; Sun,  3 Dec 2023 09:32:16 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-a1b22a31649so84137766b.3
        for <linux-crypto@vger.kernel.org>; Sun, 03 Dec 2023 09:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701624734; x=1702229534; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1p8xwvjykJ1KZRdzNx19vS2jHg0/UOJdCMHKZdpDhKc=;
        b=AHeOGC3JGUwCR3gG48asvECb3schd9HBPVxHfptMLPMzwSZxrDOFVb2L3m0Km34wTg
         Vy4Du3sUMAt5AnxxkB6EQ+/rgsHgr01KPK9/2hYtjq/sB1anOn2C+VOtQCFfeWZ/nKe6
         aq5n0X/l6PIW2giDq+OtGCG7/4HT+u5q9AB2u4pTFv5esuy8nhltCa1okVw/HIr5tSmY
         JVPVZz/uli/O7n0EKSCOafl/OsH75gtYhqLQoj3FyiQto17Y6cb1NV0CxIFmJHAUzNlW
         wKcD6CkJ60qzO2IROcFHDI/cL53OIOkaD1XiJCTDtHP5Mdl7YN7ZwgSypxgHAszQ6Hn5
         V2Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701624734; x=1702229534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1p8xwvjykJ1KZRdzNx19vS2jHg0/UOJdCMHKZdpDhKc=;
        b=vmZ8sV6UDiFpRtereIXqcquwAXKjRLYQWGfvKudRuPpX4bv0Kj6jIh5clg2loy+vwN
         x8HM0+OvVo8LtO0rqHVVhl3LzU/p0IoLZr3P5oxu+1i9rB94oHo11D5lH9Bp8i9PW4ym
         HrpaKD4gms6R4MZ7FrHgrxSDCnMVGF0cS7H82WP+njmcITfMN7oQgikrlNxQ5iTxQh6b
         l4cPaEUfjnac0qTrvpQkSSUvYwIRTYKRf42/WwzK4Zsl3QVewPKQtU+JbiSDk4YlEB0e
         TbaseEFNrQSHI7+ZUkiH2+BqjPz+gRQ6oBeVsVUMRh3U0MPOHpvz0PX43rarYEcEeZ+D
         0XIQ==
X-Gm-Message-State: AOJu0YwwtaP8UGIRiyTZPEDBhP9B0swOcVUT8AiOA4YiyEckYowHbjDY
	j71myhQ4DB3Jgc8+9kXBtjzy+L0U+t3/OL4WCSpCCdVNjYWk/g==
X-Google-Smtp-Source: AGHT+IFkqs0+qXxcb7yc+NPy0ORQdgHGpVNo+d/A7Zys0n6CGax9JnRVG4tP1V/BHxTyVjJa77MxCzciwPA8zumuGPI=
X-Received: by 2002:a17:906:538e:b0:a18:ae8c:4b44 with SMTP id
 g14-20020a170906538e00b00a18ae8c4b44mr2505854ejo.27.1701624734246; Sun, 03
 Dec 2023 09:32:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD14+f2AVKf8Fa2OO1aAUdDNTDsVzzR6ctU_oJSmTyd6zSYR2Q@mail.gmail.com>
 <5a0e8b44-6feb-b489-cdea-e3be3811804a@linux.alibaba.com> <CAD14+f2G-buxTaWgb23DYW-HSd1sch6tJNKV2strt=toASZXQQ@mail.gmail.com>
 <649a3bc4-58bb-1dc8-85fb-a56e47b3d5c9@linux.alibaba.com>
In-Reply-To: <649a3bc4-58bb-1dc8-85fb-a56e47b3d5c9@linux.alibaba.com>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Mon, 4 Dec 2023 02:32:02 +0900
Message-ID: <CAD14+f1u6gnHLhGSoQxL9wLq9vDYse+Ac8zxep-O2E8hHreT2w@mail.gmail.com>
Subject: Re: Weird EROFS data corruption
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, 
	Yann Collet <yann.collet.73@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gao,

On Mon, Dec 4, 2023 at 2:22=E2=80=AFAM Gao Xiang <hsiangkao@linux.alibaba.c=
om> wrote:
>
>
>
> On 2023/12/4 01:01, Juhyung Park wrote:
> > Hi Gao,
> >
> > On Mon, Dec 4, 2023 at 1:52=E2=80=AFAM Gao Xiang <hsiangkao@linux.aliba=
ba.com> wrote:
> >>
> >> Hi Juhyung,
> >>
> >> On 2023/12/4 00:22, Juhyung Park wrote:
> >>> (Cc'ing f2fs and crypto as I've noticed something similar with f2fs a
> >>> while ago, which may mean that this is not specific to EROFS:
> >>> https://lore.kernel.org/all/CAD14+f2nBZtLfLC6CwNjgCOuRRRjwzttp3D3iK4O=
f+1EEjK+cw@mail.gmail.com/
> >>> )
> >>>
> >>> Hi.
> >>>
> >>> I'm encountering a very weird EROFS data corruption.
> >>>
> >>> I noticed when I build an EROFS image for AOSP development, the devic=
e
> >>> would randomly not boot from a certain build.
> >>> After inspecting the log, I noticed that a file got corrupted.
> >>
> >> Is it observed on your laptop (i7-1185G7), yes? or some other arm64
> >> device?
> >
> > Yes, only on my laptop. The arm64 device seems fine.
> > The reason that it would not boot was that the host machine (my
> > laptop) was repacking the EROFS image wrongfully.
> >
> > The workflow is something like this:
> > Server-built EROFS AOSP image -> Image copied to laptop -> Laptop
> > mounts the EROFS image -> Copies the entire content to a scratch
> > directory (CORRUPT!) -> Changes some files -> mkfs.erofs
> >
> > So the device is not responsible for the corruption, the laptop is.
>
> Ok.
>
> >
> >>
> >>>
> >>> After adding a hash check during the build flow, I noticed that EROFS
> >>> would randomly read data wrong.
> >>>
> >>> I now have a reliable method of reproducing the issue, but here's the
> >>> funny/weird part: it's only happening on my laptop (i7-1185G7). This
> >>> is not happening with my 128 cores buildfarm machine (Threadripper
> >>> 3990X).>
> >>> I first suspected a hardware issue, but:
> >>> a. The laptop had its motherboard replaced recently (due to a failing
> >>> physical Type-C port).
> >>> b. The laptop passes memory test (memtest86).
> >>> c. This happens on all kernel versions from v5.4 to the latest v6.6
> >>> including my personal custom builds and Canonical's official Ubuntu
> >>> kernels.
> >>> d. This happens on different host SSDs and file-system combinations.
> >>> e. This only happens on LZ4. LZ4HC doesn't trigger the issue.
> >>> f. This only happens when mounting the image natively by the kernel.
> >>> Using fuse with erofsfuse is fine.
> >>
> >> I think it's a weird issue with inplace decompression because you said
> >> it depends on the hardware.  In addition, with your dataset sadly I
> >> cannot reproduce on my local server (Xeon(R) CPU E5-2682 v4).
> >
> > As I feared. Bummer :(
> >
> >>
> >> What is the difference between these two machines? just different CPU =
or
> >> they have some other difference like different compliers?
> >
> > I fully and exclusively control both devices, and the setup is almost t=
he same.
> > Same Ubuntu version, kernel/compiler version.
> >
> > But as I said, on my laptop, the issue happens on kernels that someone
> > else (Canonical) built, so I don't think it matters.
>
> The only thing I could say is that the kernel side has optimized
> inplace decompression compared to fuse so that it will reuse the
> same buffer for decompression but with a safe margin (according to
> the current lz4 decompression implementation).  It shouldn't behave
> different just due to different CPUs.  Let me find more clues
> later, also maybe we should introduce a way for users to turn off
> this if needed.

Cool :)

I'm comfortable changing and building my own custom kernel for this
specific laptop. Feel free to ask me to try out some patches.

Thanks.

>
> Thanks,
> Gao Xiang
