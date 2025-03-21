Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C84E1EB1A1
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742583959; cv=none; b=jSlEPUmjWitLK1ICZZHefC4E7gPSb5PVDDZtSagjeuUYgUJR+549o81ImItKhRO93q/i1unl6oKUNO60gJdocL01ha4FJjBFNXWFbZKkeCK31/NbgQfRMeuOXSwXQKhiAZYDTKVfQdF7nsgvCfx3x6eg5f236j96amGMXmU5iB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742583959; c=relaxed/simple;
	bh=sPA3YMc7zB5fmsVIwEgENpeTURZ/iV7aheO5rZV+wXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QGETT2CzfwHk0rrVOquxT7oRxGFb5E2+1Dqd3dbctKuHEzdxN/15eo+Q2ad/J4OWH6AcH2B/ZOurIXEuLveTxVfPafijyyuu+Yozp3tvn/op6nvV88XQjS0KGOpkPzWg9tdgHecpQ7uB8DyUJ+PaEC+RXJjBOLd5f07Gdd27Ygw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=K9NoS5ps; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="K9NoS5ps"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e643f0933afso2864603276.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 12:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1742583953; x=1743188753; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nSFzAgQaMCuwvxmSdJkfWwEiaWngP9LwXhsN0dSMzo=;
        b=K9NoS5psehEmohzl7t4icvWFBtV/ap+U7JphJUaRA4IpAsCCUSaxtQKk+4bBvMPHxC
         H/uvQTlLa2qRdW4wEILCs/ovuv4VCJ3E8SWiFhSYB1GSCYN7w/E6G26BymtK1HR4hcT8
         fZsttEvVGn34RBaX9EMYy5fH2y/bPqlf0HLPrI41mSOBKDZ3oOGu6uTJFz5FY+C5CgKk
         3ZHPhEWtjup98VfLeZh4G2XzFoQXlj7rs7tPXb1dIN6PFnlNK581jasfLtDh7NFe4NnE
         tXmC+SkqUIrOF8FjsPYaDHI1xMqh+q27VhBoS19srX480n917T+KCH3HphlM9YtyCgem
         3KYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742583953; x=1743188753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4nSFzAgQaMCuwvxmSdJkfWwEiaWngP9LwXhsN0dSMzo=;
        b=kWBNYH1BlKKiulntoB3sIeYcgKiEScDzvZ135ADE9VI3sRsSknOL9eNqs0+hloUdLU
         rbSwLZj5Z+2CNdkVWC49jEoytDRkMIir6ab2ZlMq4qlkwBTf54u9pRIXaQs3uY1AjNR7
         TuF818uCp/Hz1nOOnnW1ediY2ViBLPxSrY5jLy6nRFMMx75Qd2nWkK0aVLOTTSPvOnUe
         vvfnCrFLdUsPemuqPlMCinunD3vrQ42pP9jKoUCNbmMtUMu4I183qX60zL5/kwlOBFzd
         oDfl+jMqEvay9rmF9ILiQsayruOT5PAtdmz6ojDIzvIRwHdfU5xiz27VaaIU6W0PfA20
         RRUA==
X-Forwarded-Encrypted: i=1; AJvYcCUWQyzosMIfk7C1mEGK4//AEWs62XRbcb734at3d/ZmET5EyfKjzlzv0RZ5itstxSc6m1qoe4AmpD+gZO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YypWvEXjyWoBBMbXnyc+UqSVscJ44TG8N9ZVEWlT92JQqi2dExu
	EYRoPNQiPm5MS5VCWw7jYpFJX1ChjNcH8ycraE7t+rveHf6sdajZpsgIiwn04JZwQ80kGH3dcva
	D9l0Um/uYuo6pjya9z/IIvf3HwI8HS76hHuXx
X-Gm-Gg: ASbGncuWcRPmUDV8RhXbYCZUh8tND7hpmgzUWUO++krSeBBlzBtdNFThF06Lo9VvC7w
	VoTlqDreKRtwWP95JSBzHc6O+7cTndlXdyv0wQ4DsNEkY4FTg2rQXfJBxZEFdbLxUnK1iKPKoy6
	tGUsP0cGyGgTjsMO6RNc9CCBqYhg==
X-Google-Smtp-Source: AGHT+IH/+vybMPgjTy+Q/lR+WQGG9I7BYYRaZ8XGvbeWqhA0zAi7QHXEcXle+vpl3pUGz1AEgz4oOGz9sgmGVmlf3/8=
X-Received: by 2002:a05:6902:4a8d:b0:e66:a274:7fff with SMTP id
 3f1490d57ef6-e66a2748117mr6225899276.21.1742583948895; Fri, 21 Mar 2025
 12:05:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <FD501FB8-72D2-4B10-A03A-F52FC5B67646@oracle.com>
 <CAHC9VhR961uTFueovLXXaOf-3ZAnvQCWOTfw-wCRuAKOKPAOKw@mail.gmail.com>
 <73B78CE7-1BB8-4065-9EBA-FB69E327725E@oracle.com> <CAHC9VhRMUkzLVT5GT5c5hgpfaaKubzcPOTWFDpOmhNne0sswPA@mail.gmail.com>
 <1A222B45-FCC4-4BBD-8E17-D92697FE467D@oracle.com> <CAHC9VhTObTee95SwZ+C4EwPotovE9R3vy0gVXf+kATtP3vfXrg@mail.gmail.com>
 <EB757F96-E152-4EAB-B3F7-75C1DBE3A03B@oracle.com> <1956e7f9d60.28a7.85c95baa4474aabc7814e68940a78392@paul-moore.com>
 <A3A29FB9-E015-4C87-B5F0-190A4C779CB3@oracle.com> <CAHC9VhQMN6cgWbxdAgBNffpCAo=ogGdm4qBGS_kKdDmiT8b3cw@mail.gmail.com>
 <Z92gTQj6QkedbH0K@kernel.org>
In-Reply-To: <Z92gTQj6QkedbH0K@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 21 Mar 2025 15:05:38 -0400
X-Gm-Features: AQ5f1JoCVuy6gH5pZ3qt9eL4_YTiGz_EbkGoV-AHORqyWmdnqKeKo0JNC59Hn0c
Message-ID: <CAHC9VhSi06azJ+b5YgLuDM6xff2401ArMM6LoP0vsqsUgz6VNA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/13] Clavis LSM
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Eric Snowberg <eric.snowberg@oracle.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	David Howells <dhowells@redhat.com>, 
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

On Fri, Mar 21, 2025 at 1:22=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
> On Thu, Mar 20, 2025 at 05:36:41PM -0400, Paul Moore wrote:

...

> > I want to address two things, the first, and most important, is that
> > while I am currently employed by Microsoft, I do not speak for
> > Microsoft and the decisions and actions I take as an upstream Linux
> > kernel maintainer are not vetted by Microsoft in any way.  I think you
> > will find that many upstream kernel maintainers operate in a similar
> > way for a variety of very good reasons.
>
> This is understood. If one takes a kernel maintainer role, one should
> unconditionally disobey any vetting by the employer (even at the cost of
> the job, or alternatively at the cost of giving up the maintainership).
>
> And with you in particular I don't think anyone has any trust issues,
> no matter which group of villains you might be employed by ;-)

Haha :D

> > The second issue is that my main focus is on ensuring we have a
> > secure, safe, and well maintained LSM subsystem within the upstream
> > Linux kernel.  While I do care about downstream efforts, e.g. UEFI
> > Secure Boot, those efforts are largely outside the scope of the
> > upstream Linux kernel and not my first concern.  If the developer
> > groups who are focused on things like UEFI SB want to rely on
> > functionality within the upstream Linux kernel they should be prepared
> > to stand up and contribute/maintain those features or else they may go
> > away at some point in the future.  In very blunt terms, contribute
> > upstream or Lockdown dies.
>
> Could Lockdown functionality be re-implemented with that eBPF LSM? I
> have not really looked into it so far...

I haven't looked at it too closely, but the kernel code is very
simplistic so I would be surprised if it couldn't be implemented in
eBPF, although there might be some issues about *very* early boot
(Lockdown can run as an "early" LSM) and integrity which would need to
be addressed (there is work ongoing in that are, see the recent Hornet
posting as one example of that work).  Beyond that there are
policy/political issues around that would need to be worked out;
nothing that couldn't be done, but it would be something that we would
need to sort out.

However, as I mentioned earlier, with Lockdown already present in the
kernel, deprecation and removal is really only an option of last
resort, and I'm hopeful we won't come to that.  We've seen some proper
Lockdown patches submitted overnight (!!!) and I'm discussing
maintainer roles with a couple of people off-list; with a bit of luck
I'm thinking Lockdown might be properly maintained after this upcoming
merge window.  Fingers crossed :)

--=20
paul-moore.com
