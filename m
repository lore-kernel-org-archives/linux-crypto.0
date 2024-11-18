Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6290517BA3
	for <linux-crypto@vger.kernel.org>; Mon, 18 Nov 2024 21:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731964299; cv=none; b=lhXGNil7j/y//moruKWAWJ0CmCdAQ6H6zViw9nMkx7VpZG8a4bmcmRt0rhTyWhcqu9sR98d6XMccrid6iEUN7FMU7oad6LBxpwxHLmIb/PXILttuh6nrN42LFYOk4e1TVMNjiWa9u0mRyx9OVJHl3LJlcKtWR6v+XFc9fiPO5Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731964299; c=relaxed/simple;
	bh=kOtbBNCp3adRdpZWBVL8ZYPAf25Rxnm6dJsLV/xVdFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m/XE9dEcD6O2Vfm4N4KrV3mINgatqxsr5Z9Nz/bD3tz2tvFXOXkfNu4j60Oh7vx927G0ZF+JBLwQb4IMub8MtjYZk/6ZDtNNXuUvx36av7pXvZIG4VM3kKFr1LwiuG3MbA5dFCU+BKd4LlZ92ORBN9DFE6MsJlvWT2yajoCTMp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C3uFW10U; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C3uFW10U"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-723db2798caso3776563b3a.0
        for <linux-crypto@vger.kernel.org>; Mon, 18 Nov 2024 13:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731964298; x=1732569098; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H7k2EW5cdsUTHpPPztp1rk43rNU6spLTObxaJJEp80E=;
        b=C3uFW10UovSVbVVRjM2IHQoZ8puwQYOAgO/BkybiRrjerJw1IRYQPaCS+5T2guznLs
         0XbQK6F7PFFqcRV3My0nUwkaO6F41OhIb20TpdFNiNtnNzGcPthnanD9CT6RO04DojPx
         zz16GKTnj7k7S/AqxkwjMHQDl9DDZKcRmYBX2hWKYwjpbTZE4UwE6hH8g8ar0J+TeZTr
         LJacYyio+1ELS1t4VggNHa5EXrIOn8EWSxUD5a4Nh1yV0oRDEbqRIXWlRhLix/yu7/X/
         KoZZIVf8A/81XXZjyL9Y0alTNfg3duziiqwkPo65GlxFY7UZw5iaNnGUUVm9Q/b+pmkC
         VrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731964298; x=1732569098;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H7k2EW5cdsUTHpPPztp1rk43rNU6spLTObxaJJEp80E=;
        b=odHBq5ohdGMdI46Bd7d99BbXDx786B8xQQQBrXAi6ed5b25wgVg/Hptp6wAKIb2r8O
         peZVqXOzyZc1TLKHx/U3WMeI82L0/CCx4/pv45A/hp5A50lPeWGvGtk5sjYnvVWcIuCl
         Fu2M13KyUZZuHb2OSaydTMJJ0+qVtFOi05cGKhCo7GSkMH9v3vUrYcv01SUMvxeGYv0N
         sfAXXhL//w3wc8AwWCA/eVx9mVHaWI0bFsGOQYecdHK1/eCZkZwndHSMNWWrAick0uZ9
         HShkSRGnMFD8LmZpzm5zW/+GUz5Iw2lleiN9+fnYv1NhfSfhcNUCgVME9q1Bagji0IOV
         X39Q==
X-Gm-Message-State: AOJu0YwyBLgRH/VLHEhc6uLTuLHkNwsxjR0dNJMKmVbnAGkleYg7hhLM
	7/gx0NPdgHTm54lwaMMaG7T8UxqSURMnFOgU0qoFRLyFKhKoSTGfxiqdPMtBetTvZs0hN4LdPbW
	2s8/ME+IfxNyfS0Ob/mvSeObSRew=
X-Google-Smtp-Source: AGHT+IHY//0ZFa36vru0/Q3IjGuPOl39iHO7rgTwF7sczen/B8BOY1WzmuUuBBiwLDkDb0+Na9JfFmDPUg+gPRuSip0=
X-Received: by 2002:a17:90b:3881:b0:2ea:7329:46 with SMTP id
 98e67ed59e1d1-2ea73292425mr6553589a91.5.1731964297601; Mon, 18 Nov 2024
 13:11:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO18KQgWZ5ChFf3c+AgO9fneoaHhBEAOcfUmRFw80xLnE68qWg@mail.gmail.com>
 <ba984939-ab50-4450-a3c6-7b8845de1ad8@amd.com>
In-Reply-To: <ba984939-ab50-4450-a3c6-7b8845de1ad8@amd.com>
From: Jacobo Pantoja <jacobopantoja@gmail.com>
Date: Mon, 18 Nov 2024 22:11:25 +0100
Message-ID: <CAO18KQhxrXGPoBgnkVoxfRvav5M25Bx5Ymdyo3Vbg0SB5Zqp_A@mail.gmail.com>
Subject: Re: CCP issue related to GPU pass-through?
To: Mario Limonciello <mario.limonciello@amd.com>
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks for answering

On Mon, 18 Nov 2024 at 02:20, Mario Limonciello
<mario.limonciello@amd.com> wrote:
>
> Hi Jacobo,
>
> On 11/17/2024 11:42, Jacobo Pantoja wrote:
> > Hi Mario / crypto mailing list:
> >
> > I'm trying to pass-through my AMD 5600G's integrated CPU; I can do it
> > easily with Linux guest, but I'm being unable to do so with a Windows
> > 11 guest (which is my end goal)
>
> What do you mean "pass through the CPU"?  What exactly is "working" with
> Linux guests and what exactly is "failing" with Windows ones?
>
> Is this related to passing through the graphics PCI device from the APU
> and having problems with that perhaps?

Yes, sorry, it's "GPU" pass-through. I typed it right on the subject
but not in the body

> > I've noted in my dmesg the following line:
> > "ccp: unable to access the device: you might be running a broken BIOS"
> >
>
> Are you trying to pass through the PCI device for the PSP to a guest?
> What is your goal with it?

Just want to pass the GPU, nothing else

> > Tracing it a bit on the internet, I found a couple of fwupd commits
> > done by you stating that in some platforms this is expected (e.g.
> > 0x1649) [1]
> > Comparing, in my motherboard I see that the Platform Security
> > Processor is 1022:15DF, being that last number in the same code you
> > applied the patch... but I cannot understand whether the ccp message
> > is expected on this platform (chipset is B450, if it adds info) or
> > not; and if this could be related to the pass-through problems.
> >
> > Any hints would be more than welcome
> >
>
> Those messages are referring to some cryptographic acceleration IP
> offered by the PSP on some SoCs.
>
> Not all BIOSes all access to it and it really is a case by case basis if
> it's expected behavior or not.  When it's not accessible that "just"
> means that you can't use that acceleration feature.  There are other
> features the PCI PSP driver exports such as TEE, security attributes,
> dynamic boost control, SEV etc.  Not all platforms support all features.
>
> If you're just shooting in the dark for your issue based on the warning
> about the BIOS not offering CCP this is probably the wrong tree to bark
> up.  If it's actually related it would be good at least for me to
> understand what that message has to do with a Windows guest.

I'm just trying to discard potential issues in trying to achieve the GPU
pass-through. I'm pretty sure it is related to the way the GPU driver
starts the hardware in Windows, because when the guest is Linux,
just passing through the VFCT ACPI table is enough to get the GPU
working. But in Windows there's something different and I was wondering
if this CCP "issue" could be somehow related.

But I get from your message that this is most likely unrelated to my
GPU pass-through problem.

Best regards
