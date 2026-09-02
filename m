Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C736E4AD4BD
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 17:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368769; cv=none; b=VLTQ0gr+wMgDeN7rOhuqKM5AcHAVOmcYhGEfhb9thXPc85vqNMhFjsc2yFemQyYsSPLEZ0af3m1eKYGL5eIupUaQ+z9FeMpeMzvIdGcK3jgxccpKxtBPuRhTwb/mLV0TNXGZ4j67GRGe4m5cBQU7OpoMSCUhtgtcx45+DNfLGPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368769; c=relaxed/simple;
	bh=1qyWm9FBS4lwMn+l0z/+FmSGpRC7Wsn68Pil4y+CNuo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b6R/QBTO3uzJEQAiZubvJtSU0gU3BiF/mkg6jR6k/bTCOKKG/2sp4b6G9LIifgtxTpsKaBIEpP8vG6xwpyYuf8ld6VOioAxAdGSnvcM5WDGQM3tMjRZm2VK7MVRa2pzq5lt0JRoKnYa+ngXNnoPo9Mgkrk2Tnhh225tMqF8wLEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=okGfq5qS; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="okGfq5qS"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1bbd7d6e6so1527735a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 10:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788368767; x=1788973567; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2OU53ojU8l8wGUtd3KV+CqsYwkI7GFM3tHWbQYKqcr0=;
        b=okGfq5qSR52Eg5Qzuw8Iwhb5JA/lUy8KYG36TZcZ8Ai04BHIS5kobDHEXzv8p7fmM5
         hYSD49TMlL1XiRpOWmbzOD8wSaUqmdQ6K353PsO/IFIOfZjxR7hWYPfuEgJNQpH49Iwr
         gWuEyD/Mq+NqZ3gSCHzoLjr9KNbV+NIV6NgUVH8tTvpN0CG1BnrhafdfjAOQrrqlk85i
         l+lpPC3A10Fz8TLbXTnB+bF7/I0s5VuqXUo+49UvdBeH91WtZeB27jYb7exC7pwNYxgv
         5DduiPbeuYxm+OXCyZGg4ofXLWJ+xKONEpKKcOBZHQ0/yfBlYMhERfNguGU00Nx8T9ua
         J47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788368767; x=1788973567;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2OU53ojU8l8wGUtd3KV+CqsYwkI7GFM3tHWbQYKqcr0=;
        b=pMG8kQk3q2UZhoyjMIP0AwbokLNoE6hh2hXBMCAOJiT9qwUE5X+PGhut09anxwp4vC
         /qzw7sAn+ZomSvASNvrW3W2V9g4ifhJxwpweO351Fbuk9QwhSeTz/okecmQfI34sju0+
         6LXw7JheWLDgC9CX4zbPj4OF6xLA1Sp90al5mNPpye80Hv9tpiCoZrCV/Z6uz2wtyYkb
         hFJCqvL/Im+SQBwGBzYOlYzNfU+0uwAEU6WwcAvQKsalMI0Isn4MNLOK5oVrbAN7W46Y
         +oIjXw1j712PULrDNXN9fL/UE8D9WFcde/wn31Pfx6rUE2ixtibG/uZ8lLKcl2jx9ox7
         aGUw==
X-Forwarded-Encrypted: i=1; AKwUvBzg10wPOcuN/5DSSyh/8ijDjh+Uso3GBRaFjet2lf89ig7mmnpxPOgtcFiNIXNVRx4qdV3P73ImJL9v2DE=@vger.kernel.org
X-Gm-Message-State: AFuF++mVzN7a28x4bgpfYfodvAGabMc3pfxBH8wuPM0P5SDcf/wdTnWm
	tSodfISpCBBcFyiAXQYYJz9cBYWHnkT5Z0Z8ZwBvd7Jpoi8lK3QX0XdR1lYSPIlh6KcutpfVOKl
	kO9mGSA==
X-Received: from pjbie23.prod.google.com ([2002:a17:90b:4017:b0:398:d6ef:84d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c106:b0:380:f85c:94b4
 with SMTP id 98e67ed59e1d1-39aedf1a98dmr10201213a91.7.1788368766542; Wed, 02
 Sep 2026 10:06:06 -0700 (PDT)
Date: Wed, 2 Sep 2026 10:06:05 -0700
In-Reply-To: <CALAyJWrn7OQyQMd5OPoifn_3qe6iWNf1+xSSg_six-+po9kpvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CALAyJWrn7OQyQMd5OPoifn_3qe6iWNf1+xSSg_six-+po9kpvQ@mail.gmail.com>
Message-ID: <aphXfTJicnEde3R4@google.com>
Subject: Re: [REGRESSION] [6.12.y] crypto: ccp - Move SEV/SNP Platform
 initialization to KVM breaks SEV-ES VM launch
From: Sean Christopherson <seanjc@google.com>
To: Andrew Wilson <wizlonex@gmail.com>
Cc: ashish.kalra@amd.com, aik@amd.com, herbert@gondor.apana.org.au, 
	stable@vger.kernel.org, regressions@lists.linux.dev, thomas.lendacky@amd.com, 
	john.allen@amd.com, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 1145026@bugs.debian.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 02, 2026, Andrew Wilson wrote:
> #regzbot introduced: 3f8f0133a5fc9b32d0c308530320c3f2430ba5ab
> 
> Hi all,
> 
> I am writing to report a regression affecting AMD SEV-ES VM launches
> on the 6.12 stable branch (first noticed in 6.12.97+ / 6.12.101).
> 
> I completed a git bisect between working and failing kernels, which pointed to:
> 
> Commit: bb1c84647025 ("crypto: ccp - Move SEV/SNP Platform
> initialization to KVM")
> Upstream commit: 3f8f0133a5fc9b32d0c308530320c3f2430ba5ab
> 
> ### Bisect & Verification Details:
> * Last Known Working: 8a599f4f74d4
> * First Broken Commit: bb1c84647025
> * Tested on 6.12.101: Cleanly reverting bb1c84647025 immediately
> resolves the issue and allows SEV-ES guests to boot normally.

Can you try v6.12.104 or later?  I'm pretty sure this is fixed by commit
6b748c39d18e ("KVM: SVM: Add support to initialize SEV/SNP functionality in KVM"),
i.e. is the same thing as:
https://lore.kernel.org/all/20260814100652.225499-1-jinpu.wang@ionos.com

Note, SNP is still buggered on 6.12.y if CONFIG_KVM_AMD=y, I'll try and send a
backport for that soonish.
https://lore.kernel.org/all/521b22fa-ef09-4449-909f-0120edfc4b24@oracle.com

> ### Failure Description:
> With commit bb1c84647025 applied, `sev_platform_init(&args)` is
> removed from `sev_pci_init()`, assuming KVM handles on-demand
> initialization.
> 
> On bare metal, the PSP firmware appears to remain uninitialized (does
> not reach SEV_STATE_INIT at probe time). When QEMU initializes KVM and
> queries host SEV-ES capabilities, the ioctl fails with -EPERM:
> 
>   qemu-system-x86_64: -accel kvm: sev_common_kvm_init: guest policy
> requires SEV-ES, but host SEV-ES support unavailable
>   qemu-system-x86_64: -accel kvm: failed to initialize kvm: Operation
> not permitted
> 
> ### Hardware & Environment:
> * Tested on: AMD EPYC (Rome / Milan) Supermicro platforms
> * Kernel: Linux 6.12.101
> * Hypervisor: QEMU / KVM
> 
> I have access to Naples, Rome, and Milan test hardware and am happy to
> test any patches, provide dmesg traces, or assist with debugging.  I
> am not a tech-expert of any kind, but I have time to do some testing
> if it helps.  THANK YOU for the great work.
> 
> Original Debian bug reference:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1145026
