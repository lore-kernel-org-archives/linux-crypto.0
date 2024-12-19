Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C04C1B2190
	for <linux-crypto@vger.kernel.org>; Thu, 19 Dec 2024 23:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734649990; cv=none; b=rECcH2aX8Lm0SaLTuAbi0nHvX2HTnRApBt3JunP/hudmlopyCKfHz5ntR/ImB4WzqCg1UwLma9phrmaiiLpKmpBzaAK2r1YYsNA9dZRwiQ3pNcT1Ly4x9G8wVxjeEGCtexmgpqlhkp9uSAVhraN657aEZpZqbLEJro7xOEmcMtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734649990; c=relaxed/simple;
	bh=vfTOYxh/W8fA0AZ1VgdPTr352ErbEQpVq+gf7IEjRQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bxZC4eOJr7UExCCerJRaZoczcmbL6BrNuI/R9mfeP+NTsbnBBtHAbuD49qqwA5EpXUHuDO6lCpOpkRKNjxfgpUJ/J2tkR/ls8A/WZw4vWaNnjuOerWTAjL02B1TS8dQYJMYCLOGJ6Y5MlwpKTgCkaL1BbTfdIK+u4hbxq5Imcy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2sBXEQSz; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2sBXEQSz"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9e8522445dso264149366b.1
        for <linux-crypto@vger.kernel.org>; Thu, 19 Dec 2024 15:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734649985; x=1735254785; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mD4Thd4KkzdBJGBYH3K6zTCq+7QOeoHZ6dpA6P0m5yE=;
        b=2sBXEQSzkxwuuzbJJeJ9yEuAoHjPKcgmEW1neHGsAG2gi+tcr4kwD7bjgy+cXOgn5m
         liU13Q5WzX0S+rs4bS4I7PSzefTtraxTTH0qttxou7ot4xGjcIksnzFaBXryXNS/aQ1U
         g9NBaxZoVawvHlnw/+guvKWMyk1FtSHhjdjWNexCTHfwk4fb7++uVw+Wk3YYkaWijgb3
         MO2DJkUEnuH07XvqLJ4/Jmo4vx23vp2LBeTG3SLWFeqTww7eUsKij7vnurHACrKMDnuw
         D69kunSMdxE9MUxG+50Lhe9eR0l0rEnMdlVWn4CZilKaZXXT0SiEiEoikPlnjpt7B2KW
         0QMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734649985; x=1735254785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mD4Thd4KkzdBJGBYH3K6zTCq+7QOeoHZ6dpA6P0m5yE=;
        b=auhomGSfOFpihBYKqbfMCczQM6ItipJroqSryDqz1+/zYtuny0W/C5akME7UY5B15S
         fkPbqgvc9qv//3D30jt8LxsnVG6Mcz2MmUHKKZ7QlA+9UTct3Ik+jUcEKXFtJPYqd1Vb
         kxB5GfVNrD9Y4ozLMqwS/cgX7445Aj5bMvsOOiwioRC3ozNekNSk4ms+pnZL8RawcPfn
         TZeuvVN7AhJXq91lGI9ZgAlEk3Fh4KsjlS1Z3pxfRKYaNuhFFHR4j2TajpsdB5ysxJTK
         RKBN8HR+nI9rutWHqQcMRzZ2GvLBFuzrgRzL6rewF98lCS5iUNh1Q6tcjzmV/yIrouvP
         6HxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWULWgZiR0cfYPxDmPlhdtb2YAK4N3OjFONB3nxDYJUMzWbsbimeDj+C5i2WsnB0B3wNU4hej1TT/ykHGw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9ypkkfevEUhlj7D4JngA/6PjJKELeeRoN2l+xcmHyTYei1HME
	yIlAoE71KWZYRjeZ5A2FEqy5UZXf3VOB3J2WP4/qWTznOX2oL+aldIBJHLl8xHygVlzwGR4zlpP
	65b7z05aBweSIpKjlDHxq/0BMd7EuWF99wF9b
X-Gm-Gg: ASbGncsTmorxUnM4IY9/9uLCJZlLLqzwfDotMn+IqHoFIRA8fLAWm5bZ3avaTaxSP8P
	Qn1ClNeGy9NbdlpM7SbwTH7qS6d70dRMA6waCnbAuL75wDGZSbolb7jld4flUFGw=
X-Google-Smtp-Source: AGHT+IGAap4dLIZqyAkAJDuWCVAogXcnseA3ZJrMdxYOYUi/GG/q1lfxHW3tUgVkG41qVSJO7JW5GjpL+2yAH21h7CY=
X-Received: by 2002:a17:907:3607:b0:aa6:88f5:5fef with SMTP id
 a640c23a62f3a-aac2c9948d6mr45830866b.32.1734649985445; Thu, 19 Dec 2024
 15:13:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1734392473.git.ashish.kalra@amd.com> <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
 <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com> <Z2HvJESqpc7Gd-dG@google.com>
 <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com> <Z2MeN9z69ul3oGiN@google.com>
 <3ef3f54c-c55f-482d-9c1f-0d40508e2002@amd.com> <d0ba5153-3d52-4481-82af-d5c7ee18725f@amd.com>
In-Reply-To: <d0ba5153-3d52-4481-82af-d5c7ee18725f@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Thu, 19 Dec 2024 15:12:54 -0800
X-Gm-Features: AbW1kvZoEAvkgy4KZcubE0kRWNzUwRqTCGcArrMk-RXVnif4_hRKzZpl9mHjKHc
Message-ID: <CAAH4kHYE6WQ3NXm9iwcf1FJo8SioZCU7iyU6=9omQ8YQb+czCA@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2024 at 2:04=E2=80=AFPM Kalra, Ashish <ashish.kalra@amd.com=
> wrote:
>
>
>
> On 12/18/2024 7:11 PM, Kalra, Ashish wrote:
> >
> > On 12/18/2024 1:10 PM, Sean Christopherson wrote:
> >> On Tue, Dec 17, 2024, Ashish Kalra wrote:
> >>> On 12/17/2024 3:37 PM, Sean Christopherson wrote:
> >>>> On Tue, Dec 17, 2024, Ashish Kalra wrote:
> >>>>> On 12/17/2024 10:00 AM, Dionna Amalie Glaze wrote:
> >>>>>> On Mon, Dec 16, 2024 at 3:57=E2=80=AFPM Ashish Kalra <Ashish.Kalra=
@amd.com> wrote:
> >>>>>>>
> >>>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
> >>>>>>
> >>>>>>> The on-demand SEV initialization support requires a fix in QEMU t=
o
> >>>>>>> remove check for SEV initialization to be done prior to launching
> >>>>>>> SEV/SEV-ES VMs.
> >>>>>>> NOTE: With the above fix for QEMU, older QEMU versions will be br=
oken
> >>>>>>> with respect to launching SEV/SEV-ES VMs with the newer kernel/KV=
M as
> >>>>>>> older QEMU versions require SEV initialization to be done before
> >>>>>>> launching SEV/SEV-ES VMs.
> >>>>>>>
> >>>>>>
> >>>>>> I don't think this is okay. I think you need to introduce a KVM
> >>>>>> capability to switch over to the new way of initializing SEV VMs a=
nd
> >>>>>> deprecate the old way so it doesn't need to be supported for any n=
ew
> >>>>>> additions to the interface.
> >>>>>>
> >>>>>
> >>>>> But that means KVM will need to support both mechanisms of doing SE=
V
> >>>>> initialization - during KVM module load time and the deferred/lazy
> >>>>> (on-demand) SEV INIT during VM launch.
> >>>>
> >>>> What's the QEMU change?  Dionna is right, we can't break userspace, =
but maybe
> >>>> there's an alternative to supporting both models.
> >>>
> >>> Here is the QEMU fix : (makes a SEV PLATFORM STATUS firmware call via=
 PSP
> >>> driver ioctl to check if SEV is in INIT state)
> >>>
> >>> diff --git a/target/i386/sev.c b/target/i386/sev.c
> >>> index 1a4eb1ada6..4fa8665395 100644
> >>> --- a/target/i386/sev.c
> >>> +++ b/target/i386/sev.c
> >>> @@ -1503,15 +1503,6 @@ static int sev_common_kvm_init(ConfidentialGue=
stSupport *cgs, Error **errp)
> >>>          }
> >>>      }
> >>>
> >>> -    if (sev_es_enabled() && !sev_snp_enabled()) {
> >>> -        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
> >>> -            error_setg(errp, "%s: guest policy requires SEV-ES, but =
"
> >>> -                         "host SEV-ES support unavailable",
> >>> -                         __func__);
> >>> -            return -1;
> >>> -        }
> >>> -    }
> >>
> >> Aside from breaking userspace, removing a sanity check is not a "fix".
> >
> > Actually this sanity check is not really required, if SEV INIT is not d=
one before
> > launching a SEV/SEV-ES VM, then LAUNCH_START will fail with invalid pla=
tform state
> > error as below:
> >
> > ...
> > qemu-system-x86_64: sev_launch_start: LAUNCH_START ret=3D1 fw_error=3D1=
 'Platform state is invalid'
> > ...
> >
> > So we can safely remove this check without causing a SEV/SEV-ES VM to b=
low up or something.
> >
> >>
> >> Can't we simply have the kernel do __sev_platform_init_locked() on-dem=
and for
> >> SEV_PLATFORM_STATUS?  The goal with lazy initialization is defer initi=
alization
> >> until it's necessary so that userspace can do firmware updates.  And i=
t's quite
> >> clearly necessary in this case, so...
> >
> > I don't think we want to do that, probably want to return "raw" status =
back to userspace,
> > if SEV INIT has not been done we probably need to return back that stat=
us, otherwise
> > it may break some other userspace tool.
> >
> > Now, looking at this qemu check we will always have issues launching SE=
V/SEV-ES VMs
> > with SEV INIT on demand as this check enforces SEV INIT to be done befo=
re launching
> > the VMs. And then this causes issues with SEV firmware hotloading as th=
e check
> > enforces SEV INIT before launching VMs and once SEV INIT is done we can=
't do
> > firmware  hotloading.
> >
> > But, i believe there is another alternative approach :
> >
> > - PSP driver can call SEV Shutdown right before calling DLFW_EX and the=
n do
> > a SEV INIT after successful DLFW_EX, in other words, we wrap DLFW_EX wi=
th
> > SEV_SHUTDOWN prior to it and SEV INIT post it. This approach will also =
allow
> > us to do both SNP and SEV INIT at KVM module load time, there is no nee=
d to
> > do SEV INIT lazily or on demand before SEV/SEV-ES VM launch.
> >
> > This approach should work without any changes in qemu and also allow
> > SEV firmware hotloading without having any concerns about SEV INIT stat=
e.
> >
>
> And to add here that SEV Shutdown will succeed with active SEV and SNP gu=
ests.
>
> SEV Shutdown (internally) marks all SEV asids as invalid and decommission=
 all
> SEV guests and does not affect SNP guests.
>
> So any active SEV guests will be implicitly shutdown and SNP guests will =
not be
> affected after SEV Shutdown right before doing SEV firmware hotloading an=
d
> calling DLFW_EX command.
>

Please don't implicitly shut down VMs. At least have a safe and unsafe
option for dlfw_ex where the default is to not destroy active
workloads.
That's why the 2022 patch series for Intel SGX EUPDATESVN on microcode
hotload was shot down.
It's very rude to destroy running workloads because a system update
was scheduled.

> It should be fine to expect that there are no active SEV guests or any ac=
tive
> SEV guests will be shutdown as part of SEV firmware hotloading while keep=
ing
> SNP guests running.
>
> Thanks,
> Ashish



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
