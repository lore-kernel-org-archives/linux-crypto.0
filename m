Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F309E361974
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 19:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788376508; cv=pass; b=GbtGEtN+pDvPD2rMqYK931XKMZoQ3DRr+oocWDFZN3KBJIoBkPo+j5NHG9X+AbWoPnqjAa3D2k9B5KSy2h+IextZHXxqTSa/eiLDUZVO2rM9l3t1T7fDOWVSLObZnt67YILQTi6jC3bwoMhJVCez2NpayEpvaEKawTj07HZxjmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788376508; c=relaxed/simple;
	bh=JLV8Ofox8i3452kiplk76hZfUPxaEK+vxS1pmKYEFNM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rg9oCNjLralrYh/ExgxPS5G7RRLE6+bzz9dtAYgn05poUjumlYC75BGyNZWZda1/pzyjc54a3vU3IqWokGC9+mMQkt01a9/5GdWrUyOyUqEc+sKY5/BgNrTejXGEskvgBf5Mvr4w1vfc3O6mM1WPsw7FYpZ9qjX6mjnOl5Y25co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Witbb4Sk; arc=pass smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Witbb4Sk"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-46adf49ff3dso833599fac.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 12:15:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788376499; cv=none;
        d=google.com; s=arc-20260327;
        b=qCH8D56hkcRy9fJ5IbcnoGL0WvMMKbxjZKI7/Mq0JFarwbT84K/Hznx316pf+7GTKz
         JmARPY/wE8sKbvftTHpiEW94ISTdDWtjKLZpvhhaoZr53c6LtsgHNwASuGtJdO00ZfG0
         29Zs353fsew0ycKH8jDYS6aFQ5FOhrPFcIjfKToUE7mSONZ/hElQgNo8A2kLfG+Q4Gbz
         oayzmkesdiiOKrIaHD/PnrtHN0WJJFh7XFpkP9pCFjV849L7pvROewLYcwql2UmVgqjy
         rPWRc2mx68Ywod/CT+7NxQT/HkZqgrBTZ1P4UFT+oNGVVTmb8IW2e1iGX7bInZeM7Ksc
         +vQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fhVgVDsfplRoO6QIS0+PaSfH5QyM7tCi3PZGVPNp3Fk=;
        fh=QTCIWmkHenY/NopVzwlddVQ9JHlgQYwehMBbZ3PIrKY=;
        b=XFV5Z0gQe1VubEFlmDtsTbCygkr8Sqcxrm3wbgLGt7odZIC3GBcVLRtJpb1QorpZR5
         F7Unha3R5zBRyoiLfWSREACly4u1/ZRAQhocBaIfEPUfxDEWcqoq903g2ljPPFEVIvoG
         E6QtcnBgI+LX+UDr4st5ZruBc0XZwR8kpboQjQdF0tlT6DegLK2jfW0xiAJUHN3n2gkf
         uK6LoB1XXYl1eCqJuL/R2DIZojjhSFRMi//fowHnAXfdAo1NxoUWyVm+MrxN513/lIOn
         OBJayzFt+ZSODVINaZmIwTfZs/UaQ0OCD2x8Vmcq9M8zqBI0WO20HXd5BxClh+/nNklR
         muRA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788376499; x=1788981299; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fhVgVDsfplRoO6QIS0+PaSfH5QyM7tCi3PZGVPNp3Fk=;
        b=Witbb4Skocb5WQRQSOcB/3AErxnQrFz23C5G/uqNu3pwzdauX5St7OloyoaM36jF7v
         xpwcjnXpXvgbPm/QqMMxe20sfjzKtRICJtUxf/PoZ/AqFBR6no97U2+8dtujOL4KiTjq
         Ld40Tgjo73QX7jLRnMwlbfXgFvSxJ/E7bObYULtmYt4uX1yrU8qnT67twjAkOzDhgoMp
         IvSGNVOm2VMzSLJu6tBQm8/w8IiBxMuV1OjEtsZjoe7VNYuyjxDa8lZ21NvsdmTtMBAZ
         eQKjBMoG3MBCqyedLKrQBEwkKW5z0NYnXhpPgXyTD9jCE9IO+GkvcaR+4Rb6PPK0ARzl
         tl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788376499; x=1788981299;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fhVgVDsfplRoO6QIS0+PaSfH5QyM7tCi3PZGVPNp3Fk=;
        b=cCVdSHzkje0jo2YrU73ksRDxAo1LUY6re8Jzq2WF8jXrYkb5vKaIjk/AKdAz5eVtd1
         h2+ZHifJ4do1rIxSF9W7x2fZJ7oEOn8S5lIpApL5YmGE7DQh3VmKrxtH00tGEzW2yVVz
         8yndY7DaZiXLkBd7ZyHjf5+Mq8FdrNcOzZadmF90Zjngc1QCSvOAol+h2tvl0YzTf/Of
         mujBYL6/xcbQPEEBXP5O6q3obA4Hpq7/RcqcHA8LvXm0176Pj0PllklsVzdD9gPAUxH6
         QI6Vinp78J4f7rpnG3GUyb+2pTLycXbeFZnDkmQ4bqQK1y8YBvCAJzU/XQRs+cB7Pcv0
         1k+Q==
X-Forwarded-Encrypted: i=1; AKwUvBwinPTSwYmapgLhAyZ+Dcfujhxhs9NR7838u3vZHIMEU9vX76Dd9hjG22T2j8fphyLxLvuU0+LXDMiwPfA=@vger.kernel.org
X-Gm-Message-State: AFuF++mKnI6bIknV13Vat0fEV90tNYJ6Jmy//3I4zOXXtDnm/uTbFM57
	xslm2YvAM7ZrhvuZycWWhLcGX1tRVWN0YU8QRFDe0dnLSfdtiiKxcZ/rzlElFmNFhrCBjCTslBp
	djmWYe4G3F6dfcUh1w2NQ3Upqyolcfq8=
X-Gm-Gg: AYBFou2EeFFE9sHt67xmuHOMfIsaJ1ucES2hCkVfp0ZGqmgPzaENyeUieQ8yVoZsdRG
	Lq1HCmmQkW1ll46oHuB8vq2yi2DuqnWu+VPsJoAuE0/zGq2DQyCsqNzesDP9GYXGMtRwq6zkh/v
	lklrlfEkm1BX1bzuRCcxgnN8FlK6i26JYDfR9viVKC+YQfx63hF+POXnvx9zqN6VOTO9yvL11Ap
	xduPFPyf4lSXz4AVNwXv4UIHRisAgva5PcPwMPGnpvJ4lr2BxWRmHv6DH2SmFgAv5jiicloEoOD
	44inOi6XAqsupemRiYUrgFspTYBTOOblpQ18GA6xnKLCbZXOILOtKDLnyW9nrv5BvV8I8nskNal
	gEQoBemSmax2GggmgV8zaW43/i92tLrhjK1QxnhldCR2ehMUg8qeaPCjRxGve4cTZddqebSgC+p
	vRGISuBCD+p2s3s3ETaILTo8UxvWu7aWbkau3LrDIa
X-Received: by 2002:a05:6870:270:b0:46a:e87f:a7f3 with SMTP id
 586e51a60fabf-46f88507af1mr6165405fac.2.1788376499042; Wed, 02 Sep 2026
 12:14:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALAyJWrn7OQyQMd5OPoifn_3qe6iWNf1+xSSg_six-+po9kpvQ@mail.gmail.com>
 <aphXfTJicnEde3R4@google.com>
In-Reply-To: <aphXfTJicnEde3R4@google.com>
From: Andrew Wilson <wizlonex@gmail.com>
Date: Wed, 2 Sep 2026 15:14:48 -0400
X-Gm-Features: AcwNN1UJNnt-8ayL0xjmSoouIWQ2GFKkS-vOs8cL869hId8ajPvh2JfxnCOJoF8
Message-ID: <CALAyJWqXT=LFr2wAi4egPPQX57=NRK5tXJh_t4nOKqrJbfga3A@mail.gmail.com>
Subject: Re: [REGRESSION] [6.12.y] crypto: ccp - Move SEV/SNP Platform
 initialization to KVM breaks SEV-ES VM launch
To: Sean Christopherson <seanjc@google.com>
Cc: ashish.kalra@amd.com, aik@amd.com, herbert@gondor.apana.org.au, 
	stable@vger.kernel.org, regressions@lists.linux.dev, thomas.lendacky@amd.com, 
	john.allen@amd.com, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 1145026@bugs.debian.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sean, Salvatore,

Tested-by: Andrew Wilson <your.email@address.com>

(With strong assistance from Gemini guiding me through builds, module
DKMS rebuilds, and interpreting logs!)

I can confirm that commit 6b748c39d18e completely resolves the issue,
and SEV, SEV-ES, AND SEV-SNP are fully functional on official Debian
packages (tested on EPYC Rome and EPYC Milan servers).

Here are the test results from bare-metal hardware:

1. Upstream v6.12.104 (Source build) on AMD EPYC (Rome):
   * Tested SEV-ES: Functional, VMs launch cleanly.

2. Debian 6.12.107-1 (linux-image-6.12.107+deb13-amd64) on AMD EPYC (Rome):
   * Tested SEV & SEV-ES: Functional.
   [    3.676036] kvm_amd: SEV enabled (ASIDs 16 - 253)
   [    3.690542] kvm_amd: SEV-ES enabled (ASIDs 1 - 15)
   [    3.735896] ccp 0000:26:00.1: SEV API:0.24 build:22

3. Debian 6.12.107-1 (linux-image-6.12.107+deb13-amd64) on AMD EPYC (Milan)=
:
   * Tested SEV-SNP: Fully functional!
   * Host log:
     [    4.678767] kvm_amd: SEV enabled (ASIDs 256 - 509)
     [    4.684694] kvm_amd: SEV-ES enabled (ASIDs 1 - 255)
     [    4.690563] kvm_amd: SEV-SNP enabled (ASIDs 1 - 255)
     [    6.212275] ccp 0000:47:00.1: SEV-SNP API:1.58 build:2
   * Guest dmesg:
     [    0.908804] Memory Encryption Features active: AMD SEV SEV-ES SEV-S=
NP
     [    0.908820] SEV: Status: SEV SEV-ES SEV-SNP
     [    2.109524] SEV: SNP running at VMPL0.
     [    3.439649] sev-guest sev-guest: Initialized SEV guest driver
(using VMPCK0 communication key)

Because Debian builds KVM as a module (CONFIG_KVM_AMD=3Dm), we avoid the
built-in CONFIG_KVM_AMD=3Dy SNP race on 6.12.y, so both SEV-ES and
SEV-SNP are completely working out-of-the-box on 6.12.107-1.

Salvatore: Debian bug #1145026 can be marked fully resolved by
linux-image-6.12.107-1.

Thank you all very much!

Very Respectfully,

Andrew Wilson

On Wed, Sep 2, 2026 at 1:06=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Sep 02, 2026, Andrew Wilson wrote:
> > #regzbot introduced: 3f8f0133a5fc9b32d0c308530320c3f2430ba5ab
> >
> > Hi all,
> >
> > I am writing to report a regression affecting AMD SEV-ES VM launches
> > on the 6.12 stable branch (first noticed in 6.12.97+ / 6.12.101).
> >
> > I completed a git bisect between working and failing kernels, which poi=
nted to:
> >
> > Commit: bb1c84647025 ("crypto: ccp - Move SEV/SNP Platform
> > initialization to KVM")
> > Upstream commit: 3f8f0133a5fc9b32d0c308530320c3f2430ba5ab
> >
> > ### Bisect & Verification Details:
> > * Last Known Working: 8a599f4f74d4
> > * First Broken Commit: bb1c84647025
> > * Tested on 6.12.101: Cleanly reverting bb1c84647025 immediately
> > resolves the issue and allows SEV-ES guests to boot normally.
>
> Can you try v6.12.104 or later?  I'm pretty sure this is fixed by commit
> 6b748c39d18e ("KVM: SVM: Add support to initialize SEV/SNP functionality =
in KVM"),
> i.e. is the same thing as:
> https://lore.kernel.org/all/20260814100652.225499-1-jinpu.wang@ionos.com
>
> Note, SNP is still buggered on 6.12.y if CONFIG_KVM_AMD=3Dy, I'll try and=
 send a
> backport for that soonish.
> https://lore.kernel.org/all/521b22fa-ef09-4449-909f-0120edfc4b24@oracle.c=
om
>
> > ### Failure Description:
> > With commit bb1c84647025 applied, `sev_platform_init(&args)` is
> > removed from `sev_pci_init()`, assuming KVM handles on-demand
> > initialization.
> >
> > On bare metal, the PSP firmware appears to remain uninitialized (does
> > not reach SEV_STATE_INIT at probe time). When QEMU initializes KVM and
> > queries host SEV-ES capabilities, the ioctl fails with -EPERM:
> >
> >   qemu-system-x86_64: -accel kvm: sev_common_kvm_init: guest policy
> > requires SEV-ES, but host SEV-ES support unavailable
> >   qemu-system-x86_64: -accel kvm: failed to initialize kvm: Operation
> > not permitted
> >
> > ### Hardware & Environment:
> > * Tested on: AMD EPYC (Rome / Milan) Supermicro platforms
> > * Kernel: Linux 6.12.101
> > * Hypervisor: QEMU / KVM
> >
> > I have access to Naples, Rome, and Milan test hardware and am happy to
> > test any patches, provide dmesg traces, or assist with debugging.  I
> > am not a tech-expert of any kind, but I have time to do some testing
> > if it helps.  THANK YOU for the great work.
> >
> > Original Debian bug reference:
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1145026
