Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3A34FD78D
	for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784252; cv=pass; b=St/OCJTYgrgmrAVE074LX+NrQzkDGimATm0Lhq9pjLjij/pepmmU2t+SW/2DOzuAT/o0RZaStltDlg8y4dUCTVo3SlyO0/sdnK6w7IECcqWuGMMKEyaEdVd+qjyBlZ0RK2IYy/TtCKMbP+3tt0sn5qAbkObDKS4dcrTBjyzckn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784252; c=relaxed/simple;
	bh=WTSCqcU3j5xCZOTesB/9TxVC77h8Ggh4QttO/MJod9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SqdmqDa/4m1aS5MijW+IoTWTjPJLuhRVqfghyF7Er35M3BHDLDOzyJjfEk3ya/29BSSmuoLW7SbHkn1MuSluQxastfnRHG+BXdOEXoTWcu3vdKto470RKrAvoVux+5+9aHIS9Rl/VsfEnq0dMLwAsaj7hzM5MrlnXhJSqtm/Yso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLGlG8BX; arc=pass smtp.client-ip=74.125.228.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLGlG8BX"
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aae359e2c0so8424108a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 09:04:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790784245; cv=none;
        d=google.com; s=arc-20260327;
        b=PT0CxOrdT6/kPb66nqtbm9ND4u2H9m22JvT3YTQIF6GyYBmnU9CL4S9G/DbA4O3QxY
         NMhNam7UJsiOG5yl5gfgKL9C8ywuBwO7mMbXVuiAFVelNAT8mChAwUxIut0BYs/V6mea
         VXikJtBjM7u03hgLn8OCyD4QOXA8W5Nu4IBbSPRdTi1w31IeiCtlEl7uBZ1kZ6h/ELqK
         o9bL6q+V6N3wAsE1T7WtinNLLUzWEX4k6wDNZscTOD1s/u1KWqig0k84UuopTWv7h3dv
         SuXYFIkfT5/0ix1jWqKWwUY3Zqzcp1orukN7mKSO3a6KyOCN0G86uYBpccmTwT+XPsEE
         Pf2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R94s1y22nYOZdwT3AqHQhb+4sI67/SO/EEn0axk/2yM=;
        fh=8vo3U88qc79slqfQz0YnesgPSgermvgXE2d6eDpDZtM=;
        b=b4zag598HP8UNyQlZnEzTI1wTnnhPyxsWvMSWOVSBtLQmHzblg7LsZbqvhs9HS7q1o
         fXQVaCYC4lKVUwDKxm3aoSSoVuTpa81NJLQUpXW02TgVze8WjpXW8Dzmg5ksn/mBzWiK
         3ejeG1TQC80caHyFGHV58aAJsdaF0Aevj9mQpZ1qF+Oos8a6g9HeSuE9m/3qpGtICxHU
         eVe2p8nQkwfBVP+2iHWz3IWhOBhaKGcGZP9vm56Kj0FQOXd0fhAGf0yKtS06SrBa1djE
         JfYEylU9+6/ey0mTWXndAl0EwtEhZHICIu5LIT4uF5an1EZ54vGI4AIjxToJJfJNBRU6
         4IKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790784245; x=1791389045; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R94s1y22nYOZdwT3AqHQhb+4sI67/SO/EEn0axk/2yM=;
        b=FLGlG8BXIOypDe46MSS8juUIya399x0t9EE5XYXn0fFaRV8zprPeBZpEN/sqYAFe8O
         zvYRy+cNJtVl7VmljvH37u/Yot5LGFteMyJ74n/TVU6grKoJ0zHTYPrFnbMFNnKFAi6w
         8yj+BR1I1ji5DoEdwS/hkZmVM2sp7VIdPq+qYVD/3is9tB3afJgZQ3Wdx5I6fBfjViy+
         Ucw2iSCoizhGDn9hI/b6zEYRUeO4yBaycPNznGLFDzNwDsQ++46Ns/bqydyC5UUrOz7k
         nq7c27sWF5LpbHAWjUOFRldbL4jrzvwPAId6E8WsZDwdu1Pnw1ltLwwCSBBkZNikHzhb
         LjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790784245; x=1791389045;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R94s1y22nYOZdwT3AqHQhb+4sI67/SO/EEn0axk/2yM=;
        b=kKHWnSlFtSEc7psO953fYlYJ7z6X32y0+FgmoUDj3SOkgDCFApJi1XcREsiuJSRKKf
         oLR6Ah4Omk34g81NgoNlyCDBGJzMPRfDgNn4E5DMjxcDCBgSeDwvwa59ex7LOKczd7Gg
         9i3pLYU1cbXH4VRIb0UtqYX/m7xBFu7d+pwyTT6a1X+HF4znQFLqXmuX4yMsrioFHAPV
         Y1gZ6v94LLy1ZfbluCnK/9fR3WWPe5RtH3YuquefXoWUP3lwLGUpxIid/oJhjaY3CCPB
         HR3noIyBmsvpVNZiobiA26hZg+OTGadvCyRLUDmjVLyVbyEr+9Dof04sEX9qb1W/3jPC
         5EJg==
X-Forwarded-Encrypted: i=1; AKwUvBxg6YrVSQ34jaIxf6TrvostxElcdGsr4W7b3QL5CEVoCNf9aAg/HmsWpOQa/1kjuzb+pkh7bU6Zmz7P2x8=@vger.kernel.org
X-Gm-Message-State: AFq9FYLFdex1Msv7RsPNcJ2NSOf0hsBTFCVpnoIOUxxyVtWQwZGNFEQY
	CAKnbfHyrX/y89FrsuUWIvyCxgb+7ChlUgL3miwqQ23Z0Nkq49eiX4syLxGSIsx0kkzUV2mYsRF
	IT2ijI28hZVb+YMaMYy+wMcRtoy4J9OlGBfW8
X-Gm-Gg: AYBFou38jlyRH3w8IhNgFFmVFnhJlo2gz8IuVAC8D5ypaLFz1RrgoX/YCFbVW5HQKvI
	YHJqyEpgaAlz71/pOsCfgcIUM4LY72MbLZBy3VfiRR1vtK/zeSGqo+V6ti5S8ou2TbtppK0K8H1
	0+JwftT8mVcI8fqd8kIikokSA0o1P/YONkxG6oMrc/YquxlEmy4FhHUzKYP/AmU22AGaJSdtvBb
	E8BOBncZ4NW84E3FSZW8KaCPBGAwLAx3g8pFivnQukCZig+jQGLT7xtFtnwGPZAgmBFHRbKmx0P
	m0dOi8vBBvj/V322CV7SwY5IhLf0tDUB874DLZuxZagBqYxSo69Qm/t3m87/nO7RYDwjG2+elrr
	aiUv0oi4bdX83IIBkxQSNS9bpXJEeFQpMObAL/Nm8
X-Received: by 2002:a05:6402:3550:b0:6aa:f1d2:ddc4 with SMTP id
 4fb4d7f45d1cf-6ae1992db87mr1462815a12.28.1790784244589; Wed, 30 Sep 2026
 09:04:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260929222752.36427-1-ebiggers@kernel.org> <322e5255353e3a5f9e3840a496018edd980fb016.camel@itx.no>
 <1f85bdb9614365fedda81fb649147da48bf7be13.camel@physik.fu-berlin.de>
 <25c7a7c7bbe3c7f70fca559867e0883b9e4dc48d.camel@itx.no> <3ea57d640ac7409fa37b15ec9e3f49126347e432.camel@physik.fu-berlin.de>
 <8d3d3142d1ac323695a3ea2d5b3e2a10d2a129d6.camel@itx.no>
In-Reply-To: <8d3d3142d1ac323695a3ea2d5b3e2a10d2a129d6.camel@itx.no>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Wed, 30 Sep 2026 18:03:52 +0200
X-Gm-Features: AclHuK_BOLFZd_UzRzzswj2no7AD_sToBZdg182Vb5qszuJiuseE6gZyCLri0QI
Message-ID: <CA+=Fv5R0F5YNgORUx1c8YWzyFcS6wqVtmzQUXaS3vuLHYwBndw@mail.gmail.com>
Subject: Re: [PATCH v3] crypto: aes - Fix undesired override of some optimized
 AES modes
To: Stian Halseth <stian@itx.no>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Eric Biggers <ebiggers@kernel.org>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 30, 2026 at 4:52=E2=80=AFPM Stian Halseth <stian@itx.no> wrote:
>
> Hi Adrian,
>
> On Wed, 2026-09-30 at 11:27 +0200, John Paul Adrian Glaubitz wrote:
> >
> >
> > > The T2 and T3 has a separate crypto unit, but not supported here.
> > > Support was removed from the kernel in 6.14. Haven't tested it, as
> > > I
> > > don't have the hardware.
> >
> > Why was it removed? I'm not happy about such removals as long as the
> > hardware is supported.
>
> Looks like there were issues that prompted the removal:
> https://github.com/torvalds/linux/commit/9cda46babdfe
>
>
> >
> > > Also worth noting, it's only used when the firmware lists the
> > > machine
> > > description's hwcap-list and the CFR has its bit set.
> >
> > Is that not the case by default?
> Yes, on real hardware. Just mentioned to clarify that it doesn't cause
> problems on hardware that doesn't support it.
>
> > > I have no idea about Fujitsu's SPARC64 X family.
> >
> > -relocatable-kernelI think SPARC64 X is not supported by the Linux kern=
el at all, is it?
> >
> There some chip detection for it, but I've never tested, or heard about
> anyone actually using it.
>
> sparc64: correctly recognize SPARC64-X chips
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D76950e6e54ccfc98a25b501dbb1bc879cce1aa29
>
> cpu hw caps support for sparc64x:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D4e96377983d2e060dd89703f1846ad920af9e17f
>

I while back I got a hold of a Sun/Orcle M3000 box, there wasn't that much
missing in the linux kernel, and some hardware manuals available online
gave me the missing pieces. I have an experimental kernel running now
with gentoo user-land installed. The box has been running stable for a whil=
e
now during normal load (building stuff with emerge). I'm doing some final
cleanup work with the patches now before I send them out.

Some details below:

m3000 ~ # cat /proc/cpuinfo
cpu : Fujitsu SPARC64 VII / VII+
fpu : Fujitsu SPARC64 VII integrated FPU
pmu : (null)
prom : OBP 4.33.5.d 2012/07/18 06:55
type : sun4u
ncpus probed : 8
ncpus active : 8
D$ parity tl1 : 0
I$ parity tl1 : 0
cpucaps : flush,stbar,swap,muldiv,v9,mul32,div32,v8plus
Cpu0ClkTck : 0000000000000000
Cpu1ClkTck : 0000000000000000
Cpu2ClkTck : 0000000000000000
Cpu3ClkTck : 0000000000000000
Cpu4ClkTck : 0000000000000000
Cpu5ClkTck : 0000000000000000
Cpu6ClkTck : 0000000000000000
Cpu7ClkTck : 0000000000000000
MMU Type : Fujitsu SPARC64 VII (experimental)
MMU PGSZs : 8K,64K,512K,4MB
State:
CPU0: online
CPU1: online
CPU2: online
CPU3: online
CPU4: online
CPU5: online
CPU6: online
CPU7: online
m3000 ~ # uname -a
Linux m3000 7.3.0-rc1-m3000-rfc5 #2 SMP Sun Sep 20 18:04:02 CEST 2026
sparc64 sun4u Fujitsu SPARC64 VII / VII+ GNU/Linux
m3000 ~ # cat /proc/meminfo
MemTotal:       16595712 kB
MemFree:        16337304 kB
MemAvailable:   16440248 kB

Regards

Magnus
