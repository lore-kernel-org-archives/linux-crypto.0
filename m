Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWjOgyq5"
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2169D7
	for <linux-crypto@vger.kernel.org>; Sun,  3 Dec 2023 09:01:39 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-a1b03886fd7so93993466b.2
        for <linux-crypto@vger.kernel.org>; Sun, 03 Dec 2023 09:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701622898; x=1702227698; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzuNvt1M83C1nZ2ailqYr8YmM+HGUOe16GkYorpbLx0=;
        b=LWjOgyq5bDbzyM4enK+/trrVEXOM5NMrZB36+8UvpyW3sUKCxB3R8SO6hKjaENVbGa
         Hv+8HTICx/JSkh3y0P4eY5bfHwafK7KiekmSOOp0nSlFhRXFATxTuhzbewCIM3KvHUPr
         eManQ7k1zP3uidmuoF4dyJHxbqP01Z+g3kX9B3ZXhoiVX8xP+9l46PJNtnR3vk6QPP+o
         +x44Am7g1VeXa2dwV94lsP7BHFYfzWTfHyFnRbUuksnpfd+N3TPRHYszNg0ldbbgisiK
         0mhHaJnRKysczxJKYOr/qqFciwrozpfuoh2KRF+wP1PdEI66ZXD549o43SEBCc0Ud6/5
         94uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701622898; x=1702227698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzuNvt1M83C1nZ2ailqYr8YmM+HGUOe16GkYorpbLx0=;
        b=On7E2deXC0krGE881oKjNlOgdYwWVjIcZj6NN34YT8gT/f/BV7tk7oEzSW0RtCWP2A
         HfsP09/4QZbzJ9wyHst1sXK256INCNHGvnScwkwUm8GREtEUw5y1XIm4kOFwF+UUgZLt
         LSNzuK0zeNc4cqoj4UA/Nv/5xM9la72PnUd5hyglhpGbBv0lBIaoh5T41wRlRzSNhsbl
         4McaTKrS0ZM15mkbOqWWVb+AGo2LWilVKi5JQhu0wb1HBMHq8AjV5zv/kmvyPv+hpvgT
         x7+SDOOd4Z33jj2pof56CKu045JG6/lm8uklKfCXdGtB3ujyY3oGL0LeCggEoaleWT0L
         BvYQ==
X-Gm-Message-State: AOJu0Yx0MHAwWm+kpsmxHNihJnObRN64gMIe0p4gsPZI59tOsxjXvbvk
	ad86+6U924Xh4g0YmCFne1yUjGDf9v7XKBsft5U=
X-Google-Smtp-Source: AGHT+IFGRfJA6vGF4av1eLxwU3W7g2Js190Id7mzSP/GKPFCqEGGZt4G5+O1IszyNsyfe9jADDoKeynZS4hp2WOF4Hc=
X-Received: by 2002:a17:907:12c6:b0:a19:a1ba:da55 with SMTP id
 vp6-20020a17090712c600b00a19a1bada55mr2035935ejb.124.1701622897981; Sun, 03
 Dec 2023 09:01:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD14+f2AVKf8Fa2OO1aAUdDNTDsVzzR6ctU_oJSmTyd6zSYR2Q@mail.gmail.com>
 <5a0e8b44-6feb-b489-cdea-e3be3811804a@linux.alibaba.com>
In-Reply-To: <5a0e8b44-6feb-b489-cdea-e3be3811804a@linux.alibaba.com>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Mon, 4 Dec 2023 02:01:27 +0900
Message-ID: <CAD14+f2G-buxTaWgb23DYW-HSd1sch6tJNKV2strt=toASZXQQ@mail.gmail.com>
Subject: Re: Weird EROFS data corruption
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, 
	Yann Collet <yann.collet.73@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gao,

On Mon, Dec 4, 2023 at 1:52=E2=80=AFAM Gao Xiang <hsiangkao@linux.alibaba.c=
om> wrote:
>
> Hi Juhyung,
>
> On 2023/12/4 00:22, Juhyung Park wrote:
> > (Cc'ing f2fs and crypto as I've noticed something similar with f2fs a
> > while ago, which may mean that this is not specific to EROFS:
> > https://lore.kernel.org/all/CAD14+f2nBZtLfLC6CwNjgCOuRRRjwzttp3D3iK4Of+=
1EEjK+cw@mail.gmail.com/
> > )
> >
> > Hi.
> >
> > I'm encountering a very weird EROFS data corruption.
> >
> > I noticed when I build an EROFS image for AOSP development, the device
> > would randomly not boot from a certain build.
> > After inspecting the log, I noticed that a file got corrupted.
>
> Is it observed on your laptop (i7-1185G7), yes? or some other arm64
> device?

Yes, only on my laptop. The arm64 device seems fine.
The reason that it would not boot was that the host machine (my
laptop) was repacking the EROFS image wrongfully.

The workflow is something like this:
Server-built EROFS AOSP image -> Image copied to laptop -> Laptop
mounts the EROFS image -> Copies the entire content to a scratch
directory (CORRUPT!) -> Changes some files -> mkfs.erofs

So the device is not responsible for the corruption, the laptop is.

>
> >
> > After adding a hash check during the build flow, I noticed that EROFS
> > would randomly read data wrong.
> >
> > I now have a reliable method of reproducing the issue, but here's the
> > funny/weird part: it's only happening on my laptop (i7-1185G7). This
> > is not happening with my 128 cores buildfarm machine (Threadripper
> > 3990X).>
> > I first suspected a hardware issue, but:
> > a. The laptop had its motherboard replaced recently (due to a failing
> > physical Type-C port).
> > b. The laptop passes memory test (memtest86).
> > c. This happens on all kernel versions from v5.4 to the latest v6.6
> > including my personal custom builds and Canonical's official Ubuntu
> > kernels.
> > d. This happens on different host SSDs and file-system combinations.
> > e. This only happens on LZ4. LZ4HC doesn't trigger the issue.
> > f. This only happens when mounting the image natively by the kernel.
> > Using fuse with erofsfuse is fine.
>
> I think it's a weird issue with inplace decompression because you said
> it depends on the hardware.  In addition, with your dataset sadly I
> cannot reproduce on my local server (Xeon(R) CPU E5-2682 v4).

As I feared. Bummer :(

>
> What is the difference between these two machines? just different CPU or
> they have some other difference like different compliers?

I fully and exclusively control both devices, and the setup is almost the s=
ame.
Same Ubuntu version, kernel/compiler version.

But as I said, on my laptop, the issue happens on kernels that someone
else (Canonical) built, so I don't think it matters.

>
> Thanks,
> Gao Xiang
