Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D2082C60
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 02:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741140585; cv=none; b=VOIhyoi9ArAaJkYhzgn1j2d1fE77oe77/jijTyp6i2pE6v96N+M0Km7blOosm1VkwkPjN8qB0jhZgLyJetLSenZHw2FYoiCt6P0v+y8eN5EYcVURuUuUQOpzkkvreWX+7uV/1kdYdz9eDRHHSaOEPAmdBFfwfxU1lrj5JQX+1jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741140585; c=relaxed/simple;
	bh=tidJhtS8nB1+vyh1mXlU5JZOg/srSm7vJYrEXQQPwpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZOF8WCc3vRptn6xvelxG5HAsPFj5EYa0/fqpeaieHfBXisAsPrv3zOyd9PKUgCEGtZ3VlJRPXPadUv9TuozknM8kAxC5QVWl1KmbhWfEQRwDIxj5z5goJ1jRRU8n/pl2x1ffEwSmGaZ22kVwUH6devRl6/XUsr3/BZZQAB7QXGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=BPSHIoGK; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="BPSHIoGK"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e46ebe19368so5212423276.0
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 18:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1741140583; x=1741745383; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBsJzyYcy3BiP3BQcSuhcygx+r2ifnn1+EVnibgULbQ=;
        b=BPSHIoGKg6Eis7EI3Qo3uva6NWIGcBr+UqcKUeFRvp6BSXRxf0h0UjKMYZZ2Rzjf2C
         1XojQFRMNbeHuqwwneMlNqepMPvIUD0H9N4t+EGIdit7egOKDgjX3ZMGJxEBBAHfLFH7
         xNGWEmcmieZv+MJscdUYDpThmgOs2FViuBmXZDW17vhVRlMtwTk1gsyEdeoJRVNd/0vb
         TZTWkITcW4GJdi3KqjfrP5teSDcuEksyqAgO61cpP53iQNjyKHBAqt3S3fXEHKIrgrfG
         MmxEygN5VofdT7RhdTPwymzwzDPpeRP28pLBQtBZFMgzTPT+HxOs+3c2uyct/2F1zyo+
         8uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741140583; x=1741745383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBsJzyYcy3BiP3BQcSuhcygx+r2ifnn1+EVnibgULbQ=;
        b=hIdyfQEPFAl3fZYZVFqzS0OfOiaD/X4HoHDzXzPIEmJfOWxg3dZ38SnjM7RsocyKYB
         uN+E9pTc1XMGhjgcn/W2F/Zz8myaJt2sHg2yicDB3YW+lyXX0WV4ZO2ARHCkrl6eHYHT
         EmzzScigzXAV17o/6VY65k4qecnTgA6d0sgeUXy+Wx1XwlaJy6S7zQkAEkQt1oZzSwLc
         wO0dycUcM/dFI6yAfP7uoMOf1l3eL1/eciVycsaK5rkasnE4XnZibjXOVVpYMDYWIQ4f
         k1skcpFA8Sut6kDSnswuXItD7A8A56aaY6sqqohdJVigaQOHOmK1hLm9DT5LfalUdkHy
         Yg7A==
X-Forwarded-Encrypted: i=1; AJvYcCWwKQdwW2T07Z1VOcgIPHsUT2GyuTmB2AXD4tY/6PSUPbAe+0BM+8ckGUaZDkzGDAYA/OYnDZvQLI30mxE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw00iFJ/Xw7VUFIkMVK2MwJDaJFn0tKtducLH0v0I0x933gQh9n
	0mj41Rarw/YVM/9t1m1zkhFScz6ZQRjpMOCeAva9TdQGUywlaNi0kPevaoTHf8dVHBH7FdXhshI
	lwcHQeM3eK029KRf7nexvKhgkdhlWxawQBl5zzLp4JElHbzOoaA==
X-Gm-Gg: ASbGncsLzrIQYjbl2gZu0bKcp4xJcx2ry4WR6APuplXZ0VlWLpzhOxBBZ16i3KP4Op9
	WhU0TFZSuXpQCS7tW4eJWSfAb9aRdmMM6bdFqGd9puwN6q0uNoarGs3edZWNeG+7kKB3+UJfnnm
	eaJXsDEwmmNaKuwMlltesvv3hWWg==
X-Google-Smtp-Source: AGHT+IFvsgaG60BSRgmnOTdmRUFDKZzTQr16jygCeGnDYSUEz+vIETg6qS7cVR88bPdYgzRLNCq1mEwjObGFbyN32pc=
X-Received: by 2002:a05:6902:1b8e:b0:e5d:d81a:7de9 with SMTP id
 3f1490d57ef6-e611e1cfe4cmr2007195276.26.1741140582648; Tue, 04 Mar 2025
 18:09:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241017155516.2582369-1-eric.snowberg@oracle.com>
 <c490397315c2704e9ef65c8ad3fefedb239f1997.camel@linux.ibm.com>
 <72F52F71-C7F3-402D-8441-3D636A093FE8@oracle.com> <CAHC9VhRHEw5c+drC=aX4xTqWoQJJZ+qkJ7aHUT5dcu+Q5f7BqA@mail.gmail.com>
 <CAHC9VhSJpnaAK1efgs1Uk0Tr3CaDNR1LiDU-t_yDKDQG6J-74Q@mail.gmail.com>
 <E20C617B-EA01-4E69-B5E2-31E9AAD6F7A2@oracle.com> <506e8e58e5236a4525b18d84bafa9aae80b24452.camel@linux.ibm.com>
 <CAHC9VhTsZntLdGBV7=4suauS+rzSQv1O4UAoGcy2vEB02wRkoA@mail.gmail.com>
 <c580811716f550ed5d6777db5e143afe4ad06edc.camel@linux.ibm.com>
 <CAHC9VhTz6U5rRdbJBWq0_U4BSKTsiGCsaX=LTgisNNoZXZokOA@mail.gmail.com>
 <e0e7c0971d42e45c7b4641bd58cb7ea20b36e2e1.camel@linux.ibm.com>
 <CAHC9VhSzc6N0oBesT8V21xuwB11T7e6V9r0UmiqHXvCg5erkVA@mail.gmail.com>
 <a1d6ce786256bbade459f98e0b4074e449048fee.camel@linux.ibm.com>
 <CAHC9VhT27Ge6woKbBExu2nT_cQE79rG+rrgp3nDYjvjcztVQXg@mail.gmail.com> <049a04b2e07e9e984ada32277cbbde42bdf7bb1b.camel@linux.ibm.com>
In-Reply-To: <049a04b2e07e9e984ada32277cbbde42bdf7bb1b.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 4 Mar 2025 21:09:31 -0500
X-Gm-Features: AQ5f1JqHaWlgDoybOC3YJmZeCzWGFPhY04gpucYFS8pIdZ6epVCXdc0KZEkVO9k
Message-ID: <CAHC9VhRrko_CdZJg81=s-ShGfusaJqhvrX8+R6STPbMhpnEwCQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/13] Clavis LSM
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Eric Snowberg <eric.snowberg@oracle.com>, David Howells <dhowells@redhat.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, 
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	Ard Biesheuvel <ardb@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	"casey@schaufler-ca.com" <casey@schaufler-ca.com>, Stefan Berger <stefanb@linux.ibm.com>, 
	"ebiggers@kernel.org" <ebiggers@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"keyrings@vger.kernel.org" <keyrings@vger.kernel.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, 
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 4, 2025 at 8:50=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com> wro=
te:
> On Tue, 2025-03-04 at 19:19 -0500, Paul Moore wrote:
> > On Tue, Mar 4, 2025 at 7:54=E2=80=AFAM Mimi Zohar <zohar@linux.ibm.com>=
 wrote:
> > > On Mon, 2025-03-03 at 17:38 -0500, Paul Moore wrote:
> > > > On Fri, Feb 28, 2025 at 12:19=E2=80=AFPM Mimi Zohar <zohar@linux.ib=
m.com> wrote:
> > > > > On Fri, 2025-02-28 at 11:14 -0500, Paul Moore wrote:
> > > > > > On Fri, Feb 28, 2025 at 9:09=E2=80=AFAM Mimi Zohar <zohar@linux=
.ibm.com> wrote:
> > > > > > > On Thu, 2025-02-27 at 17:22 -0500, Paul Moore wrote:
> > > >
> > > > ...
> > > >
> > > > > Ok, let's go through different scenarios to see if it would scale=
.
> > > > >
> > > > > Scenario 1: Mostly distro signed userspace applications, minimum =
number of
> > > > > developer, customer, 3rd party applications.
> > > > >
> > > > > Scenario 2: Multiple developer, customer, 3rd party applications,=
 signed by the
> > > > > same party.
> > > > >
> > > > > Scenario 3: extreme case - every application signed by different =
party.
> > > > >
> > > > > With the minimum case, there would probably be a default key or s=
ets of
> > > > > permissible keys.  In the extreme case, the number of keyrings wo=
uld be
> > > > > equivalent to the number of application/software packages.
> > > >
> > > > Perhaps we're not understanding each other, but my understanding of
> > > > the above three scenarios is that they are all examples of signed
> > > > applications where something (likely something in the kernel like I=
MA)
> > > > verifies the signature on the application.  While there are going t=
o
> > > > be differing numbers of keys in each of the three scenarios, I beli=
eve
> > > > they would all be on/linked-to the same usage oriented keyring as t=
hey
> > > > all share the same usage: application signatures.
> > >
> > > Yes they're all verifying file signatures, but the software packages =
are from
> > > different sources (e.g. distro, chrome), signed by different keys.
> >
> > Yep.
> >
> > > Only a
> > > particular key should be used to verify the file signatures for a par=
ticular
> > > application.
> >
> > That's definitely one access control policy, but I can also envision a
> > scenario where I have just one keyring for application signatures with
> > multiple keys from multiple vendors.
>
> Having a single keyring with keys from multiple software vendors is the s=
tatus
> quo.

A single keyring with keys from multiple vendors does happen today
yes, but there is no separation based on how those keys are used, e.g.
separate application signature and kernel module signature keyrings.

> > > Clavis limits key usage based on LSM hooks (e.g. kernel modules, kern=
el image,
> > > firmware, etc).  It's a good start, but even this probably is not fin=
e enough
> > > granularity.
> >
> > Which is fine, but like I said earlier, it makes far more sense to me
> > to move towards usage oriented keyrings and then apply whatever
> > additional access control granularity is required to meet a given
> > scenario.
>
> Since you didn't agree with my example of "usage oriented keyrings", plea=
se
> provide an example.

I have.

--=20
paul-moore.com
