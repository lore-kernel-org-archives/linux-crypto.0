Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57285377AA6
	for <linux-crypto@vger.kernel.org>; Sun, 26 Jul 2026 07:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785050909; cv=pass; b=CVSluKfOX1Si7UvxpCq+nbA+Hz6yI1faQGD3gDNWeE6BFLunTKfjf8xGMzNZzOlbbgwQpzz5eOaSKM/+IlnXB9+vlh46En4YBTFUDgmZFeqATnlC937SlbqJe+QkS/7BxaPX0/QzIxR3fvN6Nayk/WjBSrjMs9o6lDPxqKxSCQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785050909; c=relaxed/simple;
	bh=YnQSxA6vOc4L3vy7N3SIEFndSmFrtTsw7Yc0V12H9AE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mBtqa/iVUgGZQpoT6XmdCUh3JNEn4iLU4ZbZQ7vKa/K8SAshdrzn7whOG/67JufiKcSkcO9VVbmOgdD86r8mKfjGCl7kjcoVA3uYryrKX1acLEqKoDe2V8XzikEMyIS9uW8EaWEjCQE+0ZEB+/nyAfalPyV7R8XjVSWC0RO7WYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KCgAiTVI; arc=pass smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KCgAiTVI"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cab973140bso24059885ad.3
        for <linux-crypto@vger.kernel.org>; Sun, 26 Jul 2026 00:28:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785050907; cv=none;
        d=google.com; s=arc-20260327;
        b=EKK2Kw09lzf9VtpjXTWGqJBfv3yS4LjgA1IHBqMDQq6/H2FRW5uZvfKiWh4keAOsCd
         o+/ZXtORp8Be5toYMLt1dCnYA8ciTbyR+gXFDg9t8Ocve1nmLbzY42UirWeDqLS9vezH
         kp0JEtdgldXn0Mf+EUyb+9BAolAGPwCzFiaKMBg0FXTqMn7kR4utNBo529et0i0BOL55
         F6DT23HhHeHSIPBNm27F35NGevGTrgt74bXna03JFzrDWjmsfS5S0AhAgWTd7r2ipHHk
         PLnJwEXgb3iMa+k+v8Cd9dCX6BzyYUpm7DIx9U1qN7OoA+2dSMjVQ46ejbxn3uc46Vxv
         JVow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MeZgOjZ9fB6EjuAkf8ccBhVqZofI6hKeYPctz9DlCKk=;
        fh=4Aea/1zTUvOgT3kQQC7pEHhe17JwGbl0oXljVoxyoZo=;
        b=P1snkhg5xjDIKiQtiP5wM9p46lEIn5HaSc0ldC9wFn4d0kQXxVheocrBHvE1xnz8DN
         6SUST7msklnSKeEfhzc4Y0y+k7uPKn0A15sY8QniC30bqAf9MyXl4vQ+h2DsFBRkJNa8
         T97xq/ml+2g0/sbkBE2TX9XQMl/xSR3OAZkY8GWpmnVabC6X3tKsKRuz+ODWeSU9oiXf
         ZD9sXl514vr/x2U8ys6uiy6yGM0KY0VJaK7qsu7fY7xUJ50h/dtBioLtAIRJRGJDM5zy
         YgI+3aLOx8tpeMeHGqLynkYZ8gpu+ilI72DdjslutvaLeu0EOZB6+oKt42ftCmXBQmYR
         SfjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785050907; x=1785655707; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MeZgOjZ9fB6EjuAkf8ccBhVqZofI6hKeYPctz9DlCKk=;
        b=KCgAiTVID2AWkA9m75V+zxXT29r04XQpF7RlSRr4DulTCQlPVuF6g+fhBz5uAEwP88
         3nx7H39EQ46RtQoGay2Ha5WH5RdymQhLFjL3zhPML+a3KwbuH/pIesFHF44W7ZBIcqxy
         9hIgscEaQdiKlFiNXc4aAh/wcgChbti+lWKrJGZBI9XqkJC5F0qhj1flptgZF6qkliOA
         m7zNc7uCQa5ztbZ0RuKzKuDAKO79CRNqO680uD2mPTgKFe5llFI8ptgOrVSOfAEyuQsp
         FHX9q7+Ogsx59azlmplfow0oVmm0OAalcrgLiMgagcZntvjAPGljTNaz2VEatDTwt4bc
         KaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785050907; x=1785655707;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MeZgOjZ9fB6EjuAkf8ccBhVqZofI6hKeYPctz9DlCKk=;
        b=cWB+AlXo62CyrwrO/+x2wAXUwDVu3YBF0rbUp5iRLCv0w4qQstvH1p7My2koRL7Iij
         KiqYW8La3hhOrGyGoga5LhLUJYCKnDJH8Zo+1pMfdWdfftlYdRuQVEq0Jo63AO8ik1Di
         MjVkVwaNZ/2aV3sNTayicACGxW7eYUZKZpSgRS405GOXzKLRrq6SHqHg+j+GM8i+icAT
         tfIDZuYufzTZiHFPa+CbqZrOIOjTcwCl67zH0bcamt6tgOJGy1ZrXx+Y4bw7BPoF8u0T
         5BAmgMM3+RM4gNDTpnZVJr9815yjmtYw/Jyl7Fu39zOa6AlxlUlD7627w8oGJD3/VZx5
         xHBw==
X-Forwarded-Encrypted: i=1; AHgh+Rp+hiSVvEBDxoJ46gKzCVc2HE/YOiC6gFLUVn1+SAuJfcolNJQ/Uvzotpn3h3Y1E4PyLSg5N4xJHRov+Ks=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3rv20eiz3SopHWSxyKzxWVnEorRo2fFT84nkpd4f7dhFA3eSR
	RJuL2VmDuDKiDH4Um5LK+0S/YoF7B89b/JpU82R6MmnI9d+eB7XDw+gIwBPaGY9vDQDQ3TKIAmu
	GcK4vNjgELE05G9L/JGaC0JGj4SQsN2/mRDn152Q=
X-Gm-Gg: AR+sD13JIiCcfv3BzmekldiHtq9+2YRyhD5HrHx5CFSstdNt/2+o2DZBUluewk2Wzmp
	JOPJ1u3njDcxoTGXq2I6YgzpZe8qCfbA6jURKC8Za+CQKN0uHnN/qQlcnJJ7mX86zCOCHT4N5lX
	rFnIi4wEh7QhzLIKClJ7BBfjqSOyKhN23NUOq1NCIkpZuilKMFcUaCLZCCrqHJ4trwWFUSbjCHh
	9TY03s0hh3MX426/2CeqcC8n7ua/3UkYz6SU3jPY/rKbnIbTD/R/nzDE+EK2X5cEgk6h0vL
X-Received: by 2002:a17:902:e804:b0:2ca:d172:7228 with SMTP id
 d9443c01a7336-2cfde7a73a4mr46103665ad.11.1785050907492; Sun, 26 Jul 2026
 00:28:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com> <amOGWwdjnJqyxH5L@codewreck.org>
 <20260724160034.GB2032@sol> <amOTjPW__CNZui3_@codewreck.org>
 <CAFLxGvy+ec3nQLrQtwFZgGELhT2pKBDnHdD0pMvEGh-Mf3rjgQ@mail.gmail.com> <20260725220443.GA41199@quark>
In-Reply-To: <20260725220443.GA41199@quark>
From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Sun, 26 Jul 2026 09:28:14 +0200
X-Gm-Features: AUfX_mzf8K1M0e1Vg7IaGl-nBN4a4aellAj-_sCLX-Ln3es0XP2ZaWEmYseqOmw
Message-ID: <CAFLxGvyBGzfwh61F5YkYqctNPCQJCpFOwTtKfDs4L+iK8WJZpQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
To: Eric Biggers <ebiggers@kernel.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>, demiobenour@gmail.com, 
	Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org, adrian.hunter@intel.com, 
	alexander.shishkin@linux.intel.com, ardb@kernel.org, axboe@kernel.dk, 
	corbet@lwn.net, davem@davemloft.net, edumazet@google.com, 
	herbert@gondor.apana.org.au, horms@kernel.org, io-uring@vger.kernel.org, 
	irogers@google.com, james.clark@linaro.org, jolsa@kernel.org, kuba@kernel.org, 
	kuniyu@google.com, linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, peterz@infradead.org, 
	skhan@linuxfoundation.org, willemb@google.com, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 26, 2026 at 12:04=E2=80=AFAM Eric Biggers <ebiggers@kernel.org>=
 wrote:
> > You can create a CAAM BLOB (a generated and sealed key) using the
> > trusted keys subsystem and use this BLOB
> > later in AF_ALG to perform AES with a key invisible to userspace.
> >
> > e.g.
> > kid=3D$(keyctl add trusted mykey "new 32 pk" @s)
> > keyctl print $kid | xxd -r -p > blob.bin
> > Then just create a caam_pkey_info in userspace and feed it into AF_ALG
> > and perform AES with it.
>
> Well, specifically AES-CBC.  That's the only one that is in the driver.

Yes.

> > So, pretty please,  if you kill AF_ALG and all this, offer some way to
> > achieve the same in userspace.
>
> If needed, "cbc(paes)" and/or "cbc-paes-caam" (whichever name it is
> being accessed as) can be allowed as a special case, as a stop-gap.

Would be great.

> This would need confirmed use of that specific algorithm with upstream,
> which we don't quite have yet.  Dominique had a confirmed use of
> "tk(cbc(aes))", but that has never existed upstream in the first place,
> so it's not something that could be allowlisted upstream.

It's "cbc(paes)".

From one of my demo applications:

struct sockaddr_alg sa =3D {
       .salg_family =3D AF_ALG,
       .salg_type =3D "skcipher",
       .salg_name =3D "cbc(paes)",
};

> You've only mentioned that it "can" be used in this way in upstream.
> Can you confirm that it *is* used, and with an actual upstream algorithm
> name, and if so which one(s)?  And if so, would you also be able to
> share whether this is for dm-crypt or not?  We should remember that
> dm-crypt accepts keys directly and AF_ALG is not needed to use it.

Well, if you require me to point to some open source application, sorry I c=
an't.

But no, the use cases I know about are not dm-crypt.
It's more allowing to encrypt/decrypt data in userspace without being able =
to
extract the key from the device. Since the key is hardware bound too,
it is device
specific and you cannot decrypt on device B what you have encrypted on A, e=
ven
if you share the BLOB.
So, it's more like a building block for a poor man's secure element.

At $dayjob we've been recommending AF_ALG because it's a standard interface=
.
Not like other ad-hoc horrors via sysfs or worse we've seen on some BSPs.

--=20
Thanks,
//richard
