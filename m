Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7053E5564
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 18:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777920210; cv=pass; b=gJtnyucAkoBQj6lGvSPVEltzMMsw7T0CsmeJM0YevMucf2mXmUrHqkr6CIN4RE3Yv993hjPq15c73mznzvSUJ2SmqgcZzywwujtBqNcXajJNwDSVg6m+TFKH6MigppML+45dENMN93uW/3cu5YKrkJX1quZG/R85z8Hs8wwnnRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777920210; c=relaxed/simple;
	bh=dXuLmTysTXnNcBJUB7/WoKpKfGSuJHrE2RPV2+O1F4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pgs7ZYeONog0LMH3pyY+LBGWKDe5qKh/6m+u4xtY3+FrPKlNXuSSYKStm2MFmycA/H8rvM7xfaB7Sr+0t0sosXqyZ0QZSZ856PI3lj5ZfKSVAgczjkslvpU/IYe0ma9QCDtttC7MeycUHOeK5K7Ouqel9q9Ao2qgH74/85cdLA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHiqy1MJ; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHiqy1MJ"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-79827d28fc4so38935567b3.1
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 11:43:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777920208; cv=none;
        d=google.com; s=arc-20240605;
        b=k1Yc6XUaHJ/xUgckjFNsBJc9dRN8IQGMJ4D7EhM4I4PbE+Fm9kYQPNVzt7A932DVAW
         EhZLiOHcpLzAzjeGBUXVSRecpjfKQsPML9UGoo/UfrzYBvtRd0bKH1NvKWpy62PtSDTp
         yt3weR6C31IqKWrqknxc8FeL26xXjjHWpwvv8K4Us35zFHY3UbWr+FyfRHDwbZarkHDd
         QmF6R/K2pOnMLYcAsArm4ljHMAyxtrm+eeJCjQQJ9ff/w0+gjzhiMa0ameXijrUROlfi
         J2x0uW4lAjIwpqQnOGga838t5/cA4Mpi8nWN3sdbRYV0J4a77mep86w66/2BKW2ZPEf9
         SE4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IuIPgS6r0rifEnGxaeEcCc2SLRMUTeJLBlOhRgV//es=;
        fh=VSVgfuQ1jgaZDwmweStEMo3kgDA2zoKHZ+q1RHyDXzc=;
        b=Xmm+m676F1pdeMFs6dt6HB8wL9g5vyQlch5t7Jisz9Z0SVvNPlbEN+C1bRYmpAlntO
         Wu9PSUL6LOQafrL5KjmsV52q+CSiKG5wKhyY4NNdJC0znGpTWdRBvbEtpbjmwV+rCwB2
         CVqciQmrvwIKYKW4z3kgd7LJTsk6otFIK9JIDQGj0NlpWxDy8x0tCAO8/Whz9YNky8MP
         ax5x/C80PBACx/KsLOPZZ6dUAeftc+XQmpN32VCznT37xgU9gYtDC8FkfEDlYfOiICkl
         j5AFuPIvFNTc83QZMV7ncUdRMCYjX/4Sd3zNmbbIrP8VpkXbVG2hexuLqPbk42GgZdvY
         hpiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777920208; x=1778525008; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IuIPgS6r0rifEnGxaeEcCc2SLRMUTeJLBlOhRgV//es=;
        b=UHiqy1MJXET1Ny/it4zuf+mpXnfLUBxHxA7erRXE3stZUlrz+iriXC+FA+Rh4/eWYc
         7mv9JTHBWdASIiVgUufCGVoDnq5RdDGTpBm7gIczfgAZAGwJTwl0hni2Mvzq3XVrGKVO
         eAHmjJeQ/ZP7gBNM0YgNRrRm4q20ZlJEifoh8qfiVu27IavW1jZ3ffaJ6X9Ius6beynR
         MnhA3vJyCOzSDCP9dQ/X9yKFDIsJewBrXUwjOUJxhWRoj3+DsaJxADGRpx1saBCVYC4x
         TeMtNsbc2jXHckw3UFro1Ycmijs0Ood8ZcQmd5uEkdqSsOj6a9u/v7W+tlHNQCfi6Pgc
         75wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777920208; x=1778525008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IuIPgS6r0rifEnGxaeEcCc2SLRMUTeJLBlOhRgV//es=;
        b=msbXyzKdaVJYyXqgKJ3/XBaH0zPiCAkWEBdDInw4AuatZ43tmbwp2cjCsCHAYbCevG
         GcyFl2+BxZHjfodwo1c3o+LK3UaF/17Hgw2HeiNGTIBag3g+SZajBXqdOK0I2mFBco5v
         AwcpV/4FUi2bzgnYohurQ+n6c8l3Q8EgCSVL+R0VUht50SANjIzAwCadz9YJFJXFTSv7
         5CXIIBX0SfnOp2ag9q9H/6KcM6d/am7+FU/WIsN8CdG7XsRAVGavIFwxTsn8xz+cPZfl
         Ejjd3tFQ2xuti/OVUYfF+lN38P41P0+LwucyYsX6CSxHbG+diwz0ZoPobuce+vMD+llr
         k2ng==
X-Forwarded-Encrypted: i=1; AFNElJ9vqit5G+w4lIDSRMElxblNkK5rSueiDN3+9zdgA7lY5FnTzXUA0Whh9V97sppsVb8tJb6mb+LL7hKx9yE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2xlPjIlQ6pVuA/z3ip0ERKW9LroILCN+ieiq+OprqedXjdj5a
	jd7EUjzQjX58239pij3P1H9zlvFTmdHwFib8kUhsUwLHHNkcFsZxUqChzLFKJRXPNVPsXgIgIBj
	238R/1SwGX8NivudK80wolMdJzBPFH9A=
X-Gm-Gg: AeBDiev2J0c7bjL5v21SuP/WnJNUS7wnGW5A2TSyWXqNwQA77YnxQf2wAGt3R9EKhXi
	e+r50p9k3gE5x26qGYQOMDDo7I+xWclIOTlLvv0iNHe+q80YcD6NvfPD+RyLfLFTvmr3li63b0Z
	gz6jrpn2jAO8RmAnM8R3C1jeS1IvDgAjZBrPtkqGGIqBh73wZaPwEE11Su1mTSoJ/xhA3H93nNi
	fOiDDnwoMkbMug/G4Bl1cp5KEgt20y28ZobBlqcpa2CGoKWbzqPVDXR4wRdnDj/wKY7KpHnmyiW
	gcOLXd2N9enjvzHmWrys5rAj+ZLHz1Y=
X-Received: by 2002:a05:690c:f09:b0:7ba:f2f1:86b5 with SMTP id
 00721157ae682-7bd76fa52f8mr115261967b3.14.1777920207396; Mon, 04 May 2026
 11:43:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430160716.1120553-1-tycho@kernel.org> <20260430160716.1120553-7-tycho@kernel.org>
 <DI8PTIGP3I43.JOF10O9FPOMF@gmail.com> <afijY2Q0tEK5BnPs@tycho.pizza>
In-Reply-To: <afijY2Q0tEK5BnPs@tycho.pizza>
From: Maxwell Doose <m32285159@gmail.com>
Date: Mon, 4 May 2026 13:43:16 -0500
X-Gm-Features: AVHnY4LJHvTwYWiJOTHE9vu-AjRcgCN2U31eoyP4_tx7L96iB0QTz9jux9PeDeQ
Message-ID: <CAKqfh0G3=ABoaLWrGvKBWvxZ31dHwfYjhogQrbxhebNqxYfCTw@mail.gmail.com>
Subject: Re: [RFC v1 6/6] crypto/ccp: Implement SNP firmware live update
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Kim Phillips <kim.phillips@amd.com>, Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 4, 2026 at 8:57=E2=80=AFAM Tycho Andersen <tycho@kernel.org> wr=
ote:
> On Sat, May 02, 2026 at 10:18:42PM -0500, Maxwell Doose wrote:
> > On Thu Apr 30, 2026 at 11:07 AM CDT, Tycho Andersen wrote:
[snip]
> > > +   old_major =3D sev->api_major;
> > > +   old_minor =3D sev->api_minor;
> > > +   old_build =3D sev->build;
> > > +
> > > +   mutex_lock(&sev_cmd_mutex);
> > >
> >
> > Why not guard(mutex)()? You used it earlier in
> > sev_firmware_reinit_if_shutdown().
>
> Because this code calls some functions, including
> sev_firmware_reinit_if_shutdown(), that take the lock again. We could
> use scoped_guard() I suppose, I can look at that for v2.
>

Sorry, I should've clarified in my email, I meant why not use the RAII
patterns in cleanup.h like before. Like you said, scoped_guard() is
likely the logical way forward if there's some functions that acquire
the same lock.

> It may be useful to do a larger series where we re-think when the
> locks are acquired here. It seems like only grabbing them at the top
> level entrypoints: ioctl, platform init, firmware update, etc. and
> putting lockdep asserts in all the helpers in the file might be
> cleaner generally.

That's also probably a good idea.

best regards,
maxwell



>
> Tycho
