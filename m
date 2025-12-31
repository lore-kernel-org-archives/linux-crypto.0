Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B539224244
	for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 05:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767157263; cv=none; b=XoPLyU+NiY+HdxWuEfIqJ63JvZdnnxrw7sb0idJkuZO21mYuhvjTfV+agaXAkHxsNz49slOH/FuG/XFme8VrwmEJLs0Q+B0A/FA8sQa07FKPafwhvhe9XtGuPN3XNTtYdbM/DyOVr4VbcIEE9SOPzGNUkNHJIoWTGGt5DetKNdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767157263; c=relaxed/simple;
	bh=VBLFcK2Z/i1v4Q6q9DBdSOiL2LU92Q5sEB08HQF0mEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GEr/vrkfgsUO90piwTJsBCmVwENcBced142pi7MUErU5T6fFKKpXf0GxBmFFXesEFVud1UF9M6dFqESDt3KtYYCuGAzezpM09Ldt8/RrEaEfsSb668kF7/Ly8O/PYIE5TZx3emsyJ/smJGXEha1iLlj+mLCHBW96v3GIa0UMV3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org; spf=pass smtp.mailfrom=quora.org; dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b=DAjOGPuz; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quora.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="DAjOGPuz"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34ccdcbe520so6108627a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 21:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1767157261; x=1767762061; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vILZq3yFlzvw/Wkw3qG58Pyg/FPe3qSBf5TB1FRbsr8=;
        b=DAjOGPuzcM4c1JFLq4fxVER/6M0RUqnfGu2a3tllgKobb6KrnG7e4pt8WuJ+N0PCNd
         xto1SZb+gbFX2x2Vo4CLbGZ+NrnxdSTk9cfjTQV4qKoPWgK4xCDU53e7+qoBO2EnzN3Q
         2o7EJIGFb4chr/a6nh0ctp9EbRcXEcqeHlbmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767157261; x=1767762061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vILZq3yFlzvw/Wkw3qG58Pyg/FPe3qSBf5TB1FRbsr8=;
        b=lNOHheFv/bmTVDwkeySwLoKG/TcZpfWetiyUVSeb5YUrGkP7NQfToEYJ7sKRxiVbd4
         W3H194uFM2oUnCUwd3vvRW7xiRD7GPaukETL2uKvszcgSWUwgS31C1Ct4uEmdjXBtH8W
         8NUO6bthjdb4vmAt3f+sCp82IQ/q7taMxOkmA42Qp8s/DzArkb0nsOh2Vii2J8qT2SLE
         FB0HhoDSSb4Lf1aOBa28aRsvbBt1CTtTwF2wqFlCeY+gdrjqGUXcKQV8NnURr2X5AVtP
         ogcuzRVWoB1sCbz/kTQPw531alvk5GlnrVOrTKH8fYsWd0iwVfnACrE6h77eHLAl1e/F
         w2lA==
X-Forwarded-Encrypted: i=1; AJvYcCXp4TQKdeOZwcHQIKOAyAi2TuB1kX5J8M+L0GfivO2iaZls/lOJFmN+TapKgzJA9PsxkXfPo2QAqYBMCLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZP1Zvn7x7NiCLK6ZbGFJvJ2Q4PXjgSoCkmu81x2G9L1xpCWjd
	Gl5WGSWEOj7R3LM5pTr2uHOuCtFSSkhjwQRUYp8Wos13Z9Dl7X3pTnnBx9LD2NyCfKQbKyCTyN6
	TMfAvt9flkEDTigomRwKA1bf2tG+OhPMi3eG2HRu/QQ==
X-Gm-Gg: AY/fxX5rH5IS2BdhfEhE+N6HrX0BPX7VLAMmLaUIkyaplv/zKNQsHt9GgRXBV+rTDcT
	hyK+JGoVzaw9pka4oHywS7xun8Lh0vSV2aYOe5faNjkpj3+uQpbPbKrUQ/bXR0PwIDnyj+UYQbb
	xMKDlPXjjlzf7yfXTc1DZaiwjgXnte0dMS30mQ24mRZhhDFu63uJmCU+/mgSd4vV/E2BAUhC6FO
	xyeEU8+wudJ00Y2VRrz4lWz6wD/RZq1esJ+Ljg5TeSkQk3zuzHVfxAZQ72PyGls4cwMIZgCNqvP
	2YSbWOnVFNzbOaWHeBlE6Ri6Nw2cGV06w9Jp7dC4IPRcXMnPNeLGXrT24MElxy6HlkkrnIMezs4
	2jrDxpbRA+yw0+SKqXWSapD5aFScVMG7O7C/LJM5X2vgsgoyHCFlGKm5PLAO4ISv4XWEQsudRZg
	o1sKKekGUV4LZyrR6sSayB288GoYCNAzuGGbEQO9hUJ7xsWEs=
X-Google-Smtp-Source: AGHT+IGGjMZmA3W6Y87SsNuSW7ceZtn070YayGHBvn8dSx3+9rA7ugiw0gFrN5LfWNW1AEidn5d81vbwBN48C3lNPDs=
X-Received: by 2002:a17:90b:4ccd:b0:32e:3592:581a with SMTP id
 98e67ed59e1d1-34e90df6ab4mr31867856a91.17.1767157260914; Tue, 30 Dec 2025
 21:01:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMVG2svM0G-=OZidTONdP6V7AjKiLLLYgwjZZC_fU7_pWa=zXQ@mail.gmail.com>
 <01d84dae-1354-4cd5-97ce-4b64a396316a@suse.com> <642a3e9a-f3f1-4673-8e06-d997b342e96b@suse.com>
 <CAMVG2suYnp-D9EX0dHB5daYOLT++v_kvyY8wV-r6g36T6DZhzg@mail.gmail.com>
 <17bf8f85-9a9c-4d7d-add7-cd92313f73f1@suse.com> <9d21022d-5051-4165-b8fa-f77ec7e820ab@suse.com>
In-Reply-To: <9d21022d-5051-4165-b8fa-f77ec7e820ab@suse.com>
From: Daniel J Blueman <daniel@quora.org>
Date: Wed, 31 Dec 2025 13:00:49 +0800
X-Gm-Features: AQt7F2qT5oHGObC_DYrjXo69zJNwTh7g0QjrZk2RyITMANLNzXLeFHGvNjhYFew
Message-ID: <CAMVG2subBHEZ4e8vFT7cQM5Ub=WfUmLqAQ4WO1B=Gk2bC3BtdQ@mail.gmail.com>
Subject: Re: Soft tag and inline kasan triggering NULL pointer dereference,
 but not for hard tag and outline mode (was Re: [6.19-rc3] xxhash invalid
 access during BTRFS mount)
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Linux BTRFS <linux-btrfs@vger.kernel.org>, linux-crypto@vger.kernel.org, 
	Linux Kernel <linux-kernel@vger.kernel.org>, kasan-dev@googlegroups.com, 
	ryabinin.a.a@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 31 Dec 2025 at 12:55, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2025/12/31 14:35, Qu Wenruo =E5=86=99=E9=81=93:
> > =E5=9C=A8 2025/12/31 13:59, Daniel J Blueman =E5=86=99=E9=81=93:
> >> On Tue, 30 Dec 2025 at 17:28, Qu Wenruo <wqu@suse.com> wrote:
> >>> =E5=9C=A8 2025/12/30 19:26, Qu Wenruo =E5=86=99=E9=81=93:
> >>>> =E5=9C=A8 2025/12/30 18:02, Daniel J Blueman =E5=86=99=E9=81=93:
> >>>>> When mounting a BTRFS filesystem on 6.19-rc3 on ARM64 using xxhash
> >>>>> checksumming and KASAN, I see invalid access:
> >>>>
> >>>> Mind to share the page size? As aarch64 has 3 different supported pa=
ges
> >>>> size (4K, 16K, 64K).
> >>>>
> >>>> I'll give it a try on that branch. Although on my rc1 based developm=
ent
> >>>> branch it looks OK so far.
> >>>
> >>> Tried both 4K and 64K page size with KASAN enabled, all on 6.19-rc3 t=
ag,
> >>> no reproduce on newly created fs with xxhash.
> >>>
> >>> My environment is aarch64 VM on Orion O6 board.
> >>>
> >>> The xxhash implementation is the same xxhash64-generic:
> >>>
> >>> [   17.035933] BTRFS: device fsid 260364b9-d059-410c-92de-56243c346d6=
d
> >>> devid 1 transid 8 /dev/mapper/test-scratch1 (253:2) scanned by mount
> >>> (629)
> >>> [   17.038033] BTRFS info (device dm-2): first mount of filesystem
> >>> 260364b9-d059-410c-92de-56243c346d6d
> >>> [   17.038645] BTRFS info (device dm-2): using xxhash64
> >>> (xxhash64-generic) checksum algorithm
> >>> [   17.041303] BTRFS info (device dm-2): checking UUID tree
> >>> [   17.041390] BTRFS info (device dm-2): turning on async discard
> >>> [   17.041393] BTRFS info (device dm-2): enabling free space tree
> >>> [   19.032109] BTRFS info (device dm-2): last unmount of filesystem
> >>> 260364b9-d059-410c-92de-56243c346d6d
> >>>
> >>> So there maybe something else involved, either related to the fs or t=
he
> >>> hardware.
> >>
> >> Thanks for checking Wenruo!
> >>
> >> With KASAN_GENERIC or KASAN_HW_TAGS, I don't see "kasan:
> >> KernelAddressSanitizer initialized", so please ensure you are using
> >> KASAN_SW_TAGS, KASAN_OUTLINE and 4KB pages. Full config at
> >> https://gist.github.com/dblueman/cb4113f2cf880520081cf3f7c8dae13f
> >
> > Thanks a lot for the detailed configs.
> >
> > Unfortunately with that KASAN_SW_TAGS and KASAN_INLINE, the kernel can
> > no longer boot, will always crash at boot with the following call trace=
,
> > thus not even able to reach btrfs:
> >
> > [    3.938722]
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [    3.938739] BUG: KASAN: invalid-access in
> > bpf_patch_insn_data+0x178/0x3b0
> [...]
> > Considering this is only showing up in KASAN_SW_TAGS, not HW_TAGS or th=
e
> > default generic mode, I'm wondering if this is a bug in KASAN itself.
> >
> > Adding KASAN people to the thread, meanwhile I'll check more KASAN +
> > hardware combinations including x86_64 (since it's still 4K page size).
>
> I tried the following combinations, with a simple workload of mounting a
> btrfs with xxhash checksum.
>
> According to the original report, the KASAN is triggered as btrfs
> metadata verification time, thus mount option/workload shouldn't cause
> any different, as all metadata will use the same checksum algorithm.
>
> x86_64 + generic + inline:      PASS
> x86_64 + generic + outline:     PASS
[..]
> arm64 + hard tag:               PASS
> arm64 + generic + inline:       PASS
> arm64 + generic + outline:      PASS

Do you see "KernelAddressSanitizer initialized" with KASAN_GENERIC
and/or KASAN_HW_TAGS?

I didn't see it in either case, suggesting it isn't implemented or
supported on my system.

> arm64 + soft tag + inline:      KASAN error at boot
> arm64 + soft tag + outline:     KASAN error at boot

Please retry with CONFIG_BPF unset.

Thanks,
  Dan
--=20
Daniel J Blueman
