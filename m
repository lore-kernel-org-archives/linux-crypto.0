Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83EC291162
	for <linux-crypto@vger.kernel.org>; Wed,  7 May 2025 23:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746660112; cv=none; b=mt30UY8CfUf137jc0fYD/tJbV09WqmLzo6yAyIGzm2rmYPKtibVBZKzFLYKEcfe1C4LKOEPZu1xnkAtX1jC+LLFuYVfHYCgo64+uSY7qP6Fn5shE9aKEfnvxn0CPB/URzujtR51Jog6Q7dv4OJ++F5a9UOmgNmBjmSOguj0p24Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746660112; c=relaxed/simple;
	bh=bamgXzYV0UnQ2r1ph7sXoh7QCDp4e7MSXHZ/X1OQN2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BsHxDQOctzzrBHAIMpT1zcTW0cMA4KF0qRAK+2Lce9VH+ECbHehgYPupA+Kbr7a2zsuFUBIH7vZiymIIPMI5Jjp+CN71qQMlzx9HG1gldo4HYSNxxheNCzjQfn8zt+GmmTqLXS86PmTj37DnFUNP9ai1BI6Q9pJiq/EVhVINtAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Dufagjjm; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Dufagjjm"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-70960e0b4d5so3456707b3.0
        for <linux-crypto@vger.kernel.org>; Wed, 07 May 2025 16:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1746660110; x=1747264910; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eiS55CU6GCzTdVaqv+v/fNQZYBIDDl972AoagHBKWUg=;
        b=DufagjjmqAeKn6K4RZUlzNzx51kuZ50HrbTQHDXajJrHVRHUeR6fKn3zTLYLi/UCPR
         mE6b2CZ9rsolEuvCNLhwPsyAh00f3244hhKbawmkrGiapbDzhPZYmI4ykn/ofb7pG6Av
         oaUGSKpVNTN7Mpfa28SP0p1z6EvxK5tOtX8LTG9nHHdVHUfLa3wAUfzxqDtJ2jJEVgpc
         gahKKHrGXYhkc+mTeMCqEBG7Bo+n0eRwzpTM4Lh211Qg1micZp+mCnzBzIZAjrIvlynn
         IItkJ4fD350/B2CnYbJJRm7CWugTKWOEcj5iPL3JNZhYDu66nxRkx56+PD0qAHW/1jZ3
         jjvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746660110; x=1747264910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eiS55CU6GCzTdVaqv+v/fNQZYBIDDl972AoagHBKWUg=;
        b=NblPzDxpRMliij4Hx0VaWdSapyZHg3v7R16JLcQIfiOwNgEc8Fg33m5d55uu5o2iOQ
         eYMJZ9gcj055q6R8sBxYl+ycgJcfuYu8luS9VSySzUspsVOMJ/jVVohz7FQDvRMUIFVR
         UU2PYRZkn1beq+SlGpxwwLHDBaQv2qcZZmrDKE7aGp8c7qdHvFTHcGft/WCW3aBDvZAc
         Q0oovG7UGZRfhZSA6BuvkLV4YBzKCpKU0Kbc9KDgOCrIe9QNlvXl7I4VW8Ov0B87JCBS
         S86l4kWJuJpZ9KBj/QcxJAfLrUMQ7+kQNTw7LXftujP0magXdZ0Uaa2JeKD3yeBE3bz+
         C13w==
X-Forwarded-Encrypted: i=1; AJvYcCVvOffvhm6r7OsuhlI4apku9KKLt8gAjPlT+BL4TkDXg/GJ4LFf+A572LaCGXyurRxYK9qZnvP3cZA4UZM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6UBkIYN0V39k3xX3BLxcAtvQqe32E9YsFksyWR4sZKzfs3pe8
	hDGw8iu+15QW6kHDf70r5hvgJkfI6wZpammhcI09HbUEx34J/6cILcjIVHsK4OyyAVz/DDka6Zf
	aJIT9OOZC37jcM4o8326X+LG7tZZE7nusy5tX
X-Gm-Gg: ASbGncsqWsy7Jie+PewTJ9eDz7CKF1I1UHfSF0ReqGCNliKRODAsx7lm4lI3Oa4kmbA
	/j3/oc91dXRTeMmz/gc+zdPzSA2QuZXrCaOaIKf5LuJADLZDSphr6V9aQWDr98BwQCX+pnXJToW
	cokfjZWYN/I7RUng86x4jhpMjFO/W2OpDR
X-Google-Smtp-Source: AGHT+IEdiurNMDjEEGPDbl4FsASjSKl1b0yzZP+/scZr6xyvlLkYWyw7qnY1iU3gzpVhfzU/6D0/RDhTUKWUSun/1+U=
X-Received: by 2002:a05:690c:6f11:b0:708:a778:b447 with SMTP id
 00721157ae682-70a1da3a702mr73951417b3.20.1746660109690; Wed, 07 May 2025
 16:21:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502184421.1424368-1-bboscaccy@linux.microsoft.com>
 <20250502210034.284051-1-kpsingh@kernel.org> <87o6w7ge3o.fsf@microsoft.com>
 <CACYkzJ7Ur4kFaGZTDvcFJpn0ZwJ9V+=3ZefUURtkrQGfa68zLg@mail.gmail.com> <5dbc2a55a655f57a30be3ff7c6faa1d272e9b579.camel@HansenPartnership.com>
In-Reply-To: <5dbc2a55a655f57a30be3ff7c6faa1d272e9b579.camel@HansenPartnership.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 7 May 2025 19:21:38 -0400
X-Gm-Features: ATxdqUHVijVfp4d_bipTBtoKTZV9oFot2QZoyM5v54DevQVu2k9jVQgfjdqjmrE
Message-ID: <CAHC9VhSPLsi+GBtjJsQ8LUqPQW4aHtOL6gOqr9jfpR0i1izVZA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introducing Hornet LSM
To: KP Singh <kpsingh@kernel.org>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Blaise Boscaccy <bboscaccy@linux.microsoft.com>, bpf@vger.kernel.org, code@tyhicks.com, 
	corbet@lwn.net, davem@davemloft.net, dhowells@redhat.com, gnoack@google.com, 
	herbert@gondor.apana.org.au, jarkko@kernel.org, jmorris@namei.org, 
	jstancek@redhat.com, justinstitt@google.com, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org, 
	llvm@lists.linux.dev, masahiroy@kernel.org, mic@digikod.net, morbo@google.com, 
	nathan@kernel.org, neal@gompa.dev, nick.desaulniers+lkml@gmail.com, 
	nicolas@fjasle.eu, nkapron@google.com, roberto.sassu@huawei.com, 
	serge@hallyn.com, shuah@kernel.org, teknoraver@meta.com, 
	xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 7, 2025 at 1:48=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> I'm with Paul on this: if you could share your design ideas more fully
> than you have above that would help make this debate way more
> technical.

I think it would also help some of us, at the very least me, put your
objections into context.  I believe the more durable solutions that
end up in Linus' tree are combinations of designs created out of
compromise, and right now we are missing the context and detail of
your ideal solution to be able to do that compromise and get to a
design and implementation we can all begrudgingly accept.  In the
absence of a detailed alternate design, and considering that BPF
signature validation efforts have sputtered along for years without
any real success, we'll continue to push forward on-list with
refinements to the current proposal in an effort to drive this to some
form of resolution.

> I also get the impression that there might be a disagreement over
> scope: what seems to be coming out of BPF is that every signing problem
> and scenario must be solved before signing can be considered
> acceptable; however, I think it's not unreasonable to attempt to cover
> a portion of the use cases and allow for future additions of things
> like policy so we can get some forward motion to allow others to play
> with it and produce patches based on their use cases.

Beyond any potential future updates to Hornet, I just wanted to make
it clear that the Hornet LSM approach, like any LSM, can be disabled
both at compile time for those users who build their own kernels, as
well as at kernel boot time using the "lsm=3D" command line option for
those who are limited to pre-built kernels, e.g. distro kernels.
Users can always disable Hornet and replace it with another LSM,
either a BPF LSM or a native/C LSM, of their choosing; the LSM
framework is intentionally flexible to allow for this substitution and
replacement, with plenty of existing examples already.

--=20
paul-moore.com
