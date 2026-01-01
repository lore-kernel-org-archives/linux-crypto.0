Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791F11CFBA
	for <linux-crypto@vger.kernel.org>; Thu,  1 Jan 2026 06:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767247393; cv=none; b=GzoDbH6/N9g6pMf3uLnSh+Tfw9dxuHo5540Az5qf1xCmdQIA/nRocAbeRvOi/uGQPK7juzzOJbF+ICsh8nRDmsiXQLpJPOEbwhuG1734+2QDS/7W0H5FKrZHTCd/X/2BJB+OwvhZ7b7SO6YYUuGWTGpmQ9PUOgaMu0PkRvG4WHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767247393; c=relaxed/simple;
	bh=0dR6nAO5UVau9So2ROQaet7X7J2iYaE4uILaMtmcScI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eYkJwnDsW3x2rjcis09u3lDDZ04cMWWE8luQ6T5R2mFIs0li481CJvR5idLYvzEyt0OOdQvrsJ/fanwXRxpEO04likgn+9g4U6xij/SX8BBB7/N7BuIifOfpb3x76B5wQA3rIQUkwE2JcyOWqDF73MKvycTbS9GxszilPi9DJMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org; spf=pass smtp.mailfrom=quora.org; dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b=HJErDGeR; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quora.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="HJErDGeR"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34c30f0f12eso7693789a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 22:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1767247391; x=1767852191; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3n4zjBn1TeFMxajGcpKV8firhWdO0dTEBSF+Bk4yMKc=;
        b=HJErDGeRduTSj2nAxK1unCJAJThs4uHiL7bmZRYD0cfF05jfuw/ei0BVoaOWT5Mdrn
         Hh44goXOq/1YgNRwbD18b7JYhHms/DknI7xpCoZeqoj60zcKd9JXOe2o3QsYuyu2OcA0
         JRXdax4Ay5QhSnsuOzkfx/2rxKdyZ7pBQUwgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767247391; x=1767852191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3n4zjBn1TeFMxajGcpKV8firhWdO0dTEBSF+Bk4yMKc=;
        b=Xec91FOAPyZvE+pzuXqVxJAOMczEzlQDdfMlTBvJ8bR4wouoRZeCjkNK4jVWPGNWrX
         /LLRR4vOJXxac06UI7cmMOZUYIIKaBPlYh1G+goh84OoDmrF60UB4jsIEIRC5o32yl2g
         Pj8P7PZH5snY4MUUeb9ELFHuevVpuyt4AMAt2gwEQziFCKN2zKp1wJkibCHvBXCgp2Es
         WDKQBpGRm3xZS/aH0kxRk/t728Tp8LXRjxHLF6cc5CFhEPTqryXzJWgXXf0YOlvSupgS
         skHMNXFivmeVGzch5QcyaXFwL7TzKjo4bCe7RvuKGSM8IrN0VOp+XXxhp0meXZuPMwhN
         MDaA==
X-Forwarded-Encrypted: i=1; AJvYcCUdIfoFO1WPaPyVy+N2m/N1CD1QwB+0WIsB62AhWTLp7b1hSFFSm1Ja72sMONoji9Nacykiez0GkZE1jEk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4BS/gI2vgjqVQV7YnF6CbJWQMsV4bSl+DQAEXqP1xMEpeAls3
	uksmy9Gh7MZuXvkyIIA8L5s/l00EjCR7sIUnNJ69crlsT9xl56+AweDxYMeN3PFFBkJ0E8vdVfX
	4Nb9bfQiowGJF+htdPsufR+j7DMrus9LTz5bYFIafjQ==
X-Gm-Gg: AY/fxX6TmN/b/gMglzKHzVru0bVzTrJkHHx9Q4CRfAqvBIPDFABKwMKLFUa8pRdotYV
	YEm5bhuodTxqYQmA0DnXrV2Y1Kdoolkrp5GpopLoDgziEydRgF7iEHlKMdie978tBJngg5fb9dV
	rnV1zQ8jgN8YRALNapx3PKFFUGrbHgTHcXZXiOKz3/54ZIsPRfyaqdVmTBlI7FyncJl95AMUKhV
	W2VBWrHgsoZq0zcBgPd7NfAGUWU6rDXrZCDFmm2rdYXOBDg199C/EfzIPFtNa5vOaZ0Kze+h92o
	wPz6vSbVJUMdXoSvMO8C5mX8tKKyNYQ4fxSQVqnMN40f2DRaEBcu279LjPS8QzalZnYKbSP/6J5
	gX5Nd0TfQXGza55KefgLQLdedm8uwbIMQG16LH10BKNnKIjtjC7xY+uggOe42QbRjUQ2NwhrSz5
	nVnf8WUq++PBfX9fvsxWsbhtDCuXY8S5H8cfpiq9AIkdCZxrA=
X-Google-Smtp-Source: AGHT+IHIG1yacx+eFC2WuxM9QR7ozXTD2O1ayisfrkDl7miAygElqUj/Zg0fBuSpnK761YWUpYDp6ew8Swxj19thYks=
X-Received: by 2002:a17:90b:51c8:b0:340:bb64:c5e with SMTP id
 98e67ed59e1d1-34e9212a206mr33236538a91.14.1767247390713; Wed, 31 Dec 2025
 22:03:10 -0800 (PST)
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
 <CAMVG2subBHEZ4e8vFT7cQM5Ub=WfUmLqAQ4WO1B=Gk2bC3BtdQ@mail.gmail.com>
 <eb8d0d62-f8a3-4198-b230-94f72028ac4e@suse.com> <03cb035e-e34b-4b95-b1df-c8dc6db5a6b0@suse.com>
In-Reply-To: <03cb035e-e34b-4b95-b1df-c8dc6db5a6b0@suse.com>
From: Daniel J Blueman <daniel@quora.org>
Date: Thu, 1 Jan 2026 14:02:59 +0800
X-Gm-Features: AQt7F2pcqwrmBNaCtvu-Tp6iGTovd8mXiNWc6H9351vRIZzSvut2G_lxtlrMnfM
Message-ID: <CAMVG2stGtujhT-ouSjJ6Uth0wxH0qAvcwE5OQTNpHJiFtpS0Jg@mail.gmail.com>
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

On Thu, 1 Jan 2026 at 09:15, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2025/12/31 15:39, Qu Wenruo =E5=86=99=E9=81=93:
> > =E5=9C=A8 2025/12/31 15:30, Daniel J Blueman =E5=86=99=E9=81=93:
> >> On Wed, 31 Dec 2025 at 12:55, Qu Wenruo <wqu@suse.com> wrote:
> [...]
> >>> x86_64 + generic + inline:      PASS
> >>> x86_64 + generic + outline:     PASS
> >> [..]
> >>> arm64 + hard tag:               PASS
> >>> arm64 + generic + inline:       PASS
> >>> arm64 + generic + outline:      PASS
> >>
> >> Do you see "KernelAddressSanitizer initialized" with KASAN_GENERIC
> >> and/or KASAN_HW_TAGS?
> >
> > Yes. For my current running one using generic and inline, it shows at
> > boot time:
> >
> > [    0.000000] cma: Reserved 64 MiB at 0x00000000fc000000
> > [    0.000000] crashkernel reserved: 0x00000000dc000000 -
> > 0x00000000fc000000 (512 MB)
> > [    0.000000] KernelAddressSanitizer initialized (generic) <<<
> > [    0.000000] psci: probing for conduit method from ACPI.
> > [    0.000000] psci: PSCIv1.3 detected in firmware.
> >
> >> I didn't see it in either case, suggesting it isn't implemented or
> >> supported on my system.
> >>
> >>> arm64 + soft tag + inline:      KASAN error at boot
> >>> arm64 + soft tag + outline:     KASAN error at boot
> >>
> >> Please retry with CONFIG_BPF unset.
> >
> > I will retry but I believe this (along with your reports about hardware
> > tags/generic not reporting the error) has already proven the problem is
> > inside KASAN itself.
> >
> > Not to mention the checksum verification/calculation is very critical
> > part of btrfs, although in v6.19 there is a change in the crypto
> > interface, I still doubt about whether we have a out-of-boundary access
> > not exposed in such hot path until now.
>
> BTW, I tried to bisect the cause, and indeed got the same KASAN warning
> during some runs just mounting a newly created btrfs, and the csum
> algorithm doesn't seem to matter.
> Both xxhash and sha256 can trigger it randomly.
>
> Unfortunately there is no reliable way to reproduce the kasan warning, I
> have to cancel the bisection.

This suggests the issue only reproduces with particular
struct/page/cacheline alignment or related; good information!

Dan
--=20
Daniel J Blueman
