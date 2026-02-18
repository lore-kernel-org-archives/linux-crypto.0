Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB523019BE
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 20:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771446855; cv=pass; b=tpIFKg+Vk3HDmg+rnIYWSQkAhgykvs/5jPOw6Q/syIoAr2gdF+W8B5ksueR99VVc2Gsx7zzsfgsKZXjZ10p3FxH4IlJMZ+HRQ6vY3Cd9ApNLCk9Rz/2Is/jJlQBXszPyiBhKxVwUdETm5Hhv+JheCrz5wMFybiGhe5P31ZDhz7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771446855; c=relaxed/simple;
	bh=7C5a/FWuVnB5cGwTAOV2Br2wE+JlZH1M0yzztc2OQnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YNss5VHtDkcLWQXZJVCfzpVy9IgxRehbvH1Ix/bgM0SjXPG/xOEyctdGIY/P4Q99ipfE0Bpk6IOpcb2c2DAPkC2k0GWkf6LWreMzI1nGBbqpsGCd3vec8K7CXP6C/AGvkwFq77+ItBKBhgaBnmseEtIVxfqV1E2EPGQziBHdJoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=Z4MERPRO; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="Z4MERPRO"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3870c7479c0so2641031fa.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 12:34:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771446852; cv=none;
        d=google.com; s=arc-20240605;
        b=jNB7T74aVYvqKKFoK7ZleSf7MV4NwHGuHtgZaRaPYwQmD6HWgL44e8yoeWeKrotUR3
         y9FkkNzTkNNHV0haWywYtt/htmKIgwEmILw4vO48ytyWKTQ/lcLKmGA6WATjcVOSwjxH
         lMNxezTGvUEBX/wNoJM7q2WvY0JtfC2COBmjyWH9vDAyd9f/FNCfIGCalEzVFJskRG4a
         57DFqjt0t5O+j8CewAo2N8zhhBn65UX4CFmmLDvGsMwKsTP8B21dCkE1GHxiAqVZZNhX
         19pj/xWHyEKTT++csr2+xc/X9Y9CnSkqhq2yLLHPjjPZklUJLXY/CWlD5h+Rh4EyHH+m
         ircw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6AtdZqt2ARoYJJMPe919rNdJ3JohEndwFbHKNaMS4Pw=;
        fh=XlcB3R7H5c0ED4/irVYoh78Zg3DCZdkEn5QGzC095aA=;
        b=cjCy0V9/pJFr9/Jzvhmh9EdQJGF7Wbcvrh40BNs0xwb/hxwYAFZHSUQBD8NGxrjg6L
         oM4o6JtWeoCWlpQ/k/zvTl+WeaZlQeU/KbbMDegKK+RhsK9yA7IzkpJ6go+W6SWhcb/J
         eX/GF8MjVtEM2dRve+aiAT8KogkWZ46U4t1mmSX/IIeT3hLrlYCBi5YfvUMzr1TS3q/x
         39bAjcY26i5tNBcawUcGAV4bLdOIdKADAt7q4sObXjkzPB/ia2yz+KLgo6ljHpoBKp2J
         cEu1He5jv+SNMOOPIu5MBpEZ9VwvLVP7C0AqwePXN7LinXtFzvDTPNthJDqYQlgbauR6
         bYPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1771446852; x=1772051652; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6AtdZqt2ARoYJJMPe919rNdJ3JohEndwFbHKNaMS4Pw=;
        b=Z4MERPROgc9FSVfsG/kG3t98pIsPZiZa2ci+uYC8QxNYZkIennmepWfaiy7Su18KK4
         XL22ZPuUBe0n4IDEa5pCurRylazjGAVX1OmmoNEjfSxpevk9PQUIMFk5G6kXLbqdjiOO
         fqYt3arXfK+vc7SaJ/DL7BwDklV9pbrB8HHrXjb+oweXnLTx4Cdk5LXocPhK7369V3HC
         aBoWerMPnojZBqm+P7TfDpbyBsNBRPoofMPIJsdtWxi+ymZYmqEnYt2BJKtIS6s8nGkP
         h+gbveSCj6t3jiYDKFzSlZTqUuiFL/tNzrF6CYvIzH75E4v/8g0KMg91glEciuzyaGGt
         Ltkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771446852; x=1772051652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6AtdZqt2ARoYJJMPe919rNdJ3JohEndwFbHKNaMS4Pw=;
        b=BKtqLuSM8P6YNsFeXEZVGoLAT5e97qABargVEtIfK6bm76PVxb+u+kejkG7974Dlvh
         1i8anOqmkKld5F2uDqzGv9y8VggSxPmvpFF47n5ITL74QoNh9qZbRig9zFeX7K9UyT6u
         NZROzt3KKPzUJSUpVLk9WNSgSzYWwSLo1m+Ncod6SphLWck8SPJRnWeji8BDhuMIIi2h
         BGyIbkbK6MlpTvIVOEYpBL66lGyYQeqG2pZQlvQdta4ha6/pbK/RLr4kkClh/Jg1FNqw
         Zo6ysWdTztZj4Be3430lZAhFnoQ5M1TPYheeoa0OItUp7GoMJocHx3HxiIFjJ848vGXN
         KQ4Q==
X-Forwarded-Encrypted: i=1; AJvYcCW8VpRZKN8nZNbsEtQRKSJkMl162na8BFVbsBO+Gk4o0MfSka7R9MMXFWDWsPHHZ0hDExdVjQ60At8tqWo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6SsZsHv/vkDSS7EJKolDwb26zCsp2IGvAVNYRa6cIPnMwqK4W
	tDVErA/0Ar4OOdTqmsAcHLWOtWcIRNVRx0Zg68tg/4+oraAPcvq7xOk6tEdFNOMcUQvC6kqAhnS
	193MNB8WHHHoP3G6eCq1oNFNvfpQTY4QM60V2wCTK
X-Gm-Gg: AZuq6aKb5w/7L+NGLpPMzkylxaDgF7nXwBulh2vNSCnGp/erGW5iN5l6rq7aO2Pl7aN
	xlA6kWeiMaw+qDZBd8ue4JNOlZK1GxEQUnfdEIGkDiuUjjJYapMyShXQNHF0Hs9yGd6raoW33qn
	hDxkD3lYru+k/6Bb2cMlN2DNtamYHomJtrkIj92XJRM5RTrKdAsuM2Lgo76xlaDD5VsZEUtVXMd
	/PKgAWaRPmsvuvDxUQgz0x/95TlRCDY3pqVMX7O+Uqwozi7ywiD4mpnojT+VvVdpSTlJCdCRH5l
	Xygc
X-Received: by 2002:a05:6512:1284:b0:59e:63b7:585e with SMTP id
 2adb3069b0e04-59f69c68122mr5099221e87.36.1771446852112; Wed, 18 Feb 2026
 12:34:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215233316.1076248-1-ross.philipson@oracle.com>
 <b5f2b5a5-b984-4ed3-a023-c06d634f9146@app.fastmail.com> <1ffd3cb5-2c76-4371-a067-3e4849907d80@apertussolutions.com>
 <49d169bf-0ad2-49be-b7d7-fceb9e7f831a@app.fastmail.com> <CALCETrUE8c-dxRWhtHKz_PojwZuWMXJSzOsFQf2vt5LS3ATwpA@mail.gmail.com>
 <1BBD7449-8420-43FD-930B-A4E1BA38FFC6@zytor.com>
In-Reply-To: <1BBD7449-8420-43FD-930B-A4E1BA38FFC6@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Feb 2026 12:34:00 -0800
X-Gm-Features: AaiRm52O5CUthtEuekouveR3oQDy41lsj_ZjT1TsYC4xSgI6Vkc6OZxoV-XcGok
Message-ID: <CALCETrWzG1Mjb-RcwLQ5-tGFZ15WKHjZbqtLvyif+UPuVKJ_5g@mail.gmail.com>
Subject: Re: [PATCH v15 00/28] x86: Secure Launch support for Intel TXT
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Daniel P. Smith" <dpsmith@apertussolutions.com>, 
	Ross Philipson <ross.philipson@oracle.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kexec@lists.infradead.org, 
	linux-efi@vger.kernel.org, iommu@lists.linux.dev, dave.hansen@linux.intel.com, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	mjg59@srcf.ucam.org, James.Bottomley@hansenpartnership.com, peterhuewe@gmx.de, 
	Jarkko Sakkinen <jarkko@kernel.org>, jgg@ziepe.ca, nivedita@alum.mit.edu, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, corbet@lwn.net, 
	ebiederm@xmission.com, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	kanth.ghatraju@oracle.com, andrew.cooper3@citrix.com, 
	trenchboot-devel@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2026 at 12:29=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wro=
te:
>
> On February 18, 2026 12:03:27 PM PST, Andy Lutomirski <luto@amacapital.ne=
t> wrote:
> >On Thu, Feb 12, 2026 at 12:40=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org=
> wrote:
> >>
> >> On Thu, 12 Feb 2026, at 20:49, Daniel P. Smith wrote:
> >> > On 2/9/26 09:04, Ard Biesheuvel wrote:
> >> ...
> >> >> Surprisingly, even when doing a secure launch, the EFI runtime serv=
ices still work happily, which means (AIUI) that code that was excluded fro=
m the D-RTM TCB is still being executed at ring 0? Doesn't this defeat D-RT=
M entirely in the case some exploit is hidden in the EFI runtime code? Shou=
ld we measure the contents of EfiRuntimeServicesCode regions too?
> >> >
> >> > Yes, in fact in the early days I specifically stated that we should
> >> > provide for the ability to measure the RS blocks. Particularly if yo=
u
> >> > are not in an environment where you can isolate the calls to RS from=
 the
> >> > TCB. While the RS can pose runtime corruption risks, the larger conc=
ern
> >> > is integrating the D-RTM validation of the Intel System Resources
> >> > Defense (ISRD), aka SMI isolation/SMM Supervisor, provided by the In=
tel
> >> > System Security Report (ISSR). Within the ISSR is a list of memory
> >> > regions which the SMM Policy Shim (SPS) restricts a SMI handler's ac=
cess
> >> > when running. This allows a kernel to restrict what access a SMI han=
dler
> >> > are able to reach, thus allowing them to be removed from the TCB whe=
n
> >> > the appropriate guards are put in place.
> >> >
> >> > If you are interested in understanding these further, Satoshi Tanda =
has
> >> > probably the best technical explanation without Intel market speak.
> >> >
> >> > ISRD: https://tandasat.github.io/blog/2024/02/29/ISRD.html
> >> > ISSR: https://tandasat.github.io/blog/2024/03/18/ISSR.html
> >> >
> >>
> >> Thanks, I'll take a look at those.
> >>
> >> But would it be better to disable the runtime services by default when=
 doing a secure launch? PREEMPT_RT already does the same.
> >
> >So I have a possible way to disable EFI runtime service without losing
> >the ability to write EFI vars.  We come up with a simple file format
> >to store deferred EFI var updates and we come up with a place to put
> >it so that we find it early-ish in boot the next time around.  (This
> >could be done via integration with systemd-boot or shim some other
> >boot loader or it could actually be part of the kernel.)  And then,
> >instead of writing variables directly, we write them to the deferred
> >list and then update them on reboot (before TXT launch, etc).  [0]
> >This would be a distincly nontrivial project and would not work for
> >all configurations.
> >
> >As a maybe less painful option, we could disable EFI runtime services
> >but have a root-writable thing in sysfs that (a) turns them back on
> >but (b) first extends a PCR to say that they're turned back on.
> >
> >(Or someone could try running runtime services at CPL3...)
> >
> >[0] I have thought for years that Intel and AMD should do this on
> >their end, too.  Keep the sensitive part of SMI flash entirely locked
> >after boot and, instead of using magic SMM stuff to validate that
> >write attempts have the appropriate permissions and signatures, queue
> >them up as deferred upates and validate the signatures on the next
> >boot before locking flash.
> >
>
> *If* a physical EFI partition exists there is a lot to be said for this a=
pproach.
>
> The only issue with this that I can see is for things like network or CD/=
DVD booting where there isn't necessarily any EFI boot partition, it might =
not be writable, or it might not be persistent (e.g. http booting typically=
 uses a ramdisk, like the old Linux initrd.)

Hmm, I guess my approach is a 100% complete nonstarter for installing
Linux from a CD, and it's really not awesome for installing Linux from
a USB stick.
