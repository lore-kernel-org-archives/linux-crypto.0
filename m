Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE991B85D5
	for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2024 05:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727241429; cv=none; b=BR6qbX3HTqSFqpNm6SQR6VZ408lz8M4Zx/oSDrOpz6E4UNj+sUJ93RJgQf7Jhckk4p2Wregyt1M7xkHQw9wtu37BCPczoJpv32B5sfqkGU597MwhqarH53PU79JkQZZ9TElGtKx1xPUXzf33PJY/kRp43JMVeeNzXnocroGhttA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727241429; c=relaxed/simple;
	bh=HQU/WG6KkySWXTMFRaufyAKgOd2znLxvBBJ6bEgDHmI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qjsj8N4utOY9/lVATeGnCZKZiBQmaTfk3JEDeRZgB8Yi9nebCzFGraJE+CCpIB6f5MwjOKjGsdEH9fkGo+Xk1wf3qv7GJQIWum669knr1jPV6MSX2eaYomEkaM2D4d/V640zfYn/cEIrhDzORz6vqDx9hjIhdVC0XyZ4OpxiY5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K0yxIAJm; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0yxIAJm"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2f762de00e5so64383321fa.3
        for <linux-crypto@vger.kernel.org>; Tue, 24 Sep 2024 22:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727241425; x=1727846225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fhk7AtsWhDFuPmtNUlDKn6sBuzOpIwa/342Zs5QfOV8=;
        b=K0yxIAJmb47eG/gvhR2UJb3dCj7eWwGvSXRAapndgl/4Xm33s3Dt1TovujbU63UC2x
         jYawIsF+qWrk/HGkHpGEeiPlFPsMHS5lVbvHuoiMPxMi2RAA6Vt7zuv8QJDjwqMQo7/Q
         hi0WYKGMkMr+eT7TnWjRQBBo7SxYnw5+pr96W9DqDVd62Gx1gieLHofR+9mSQlktDqj/
         M71KUz/gNJnMBwUf+JAFkeWgLSfjV5v72jen8QbDroGrh9q5zKmhKoDiXB/1aSSIMixr
         AmiAyMJ8K8p7p3kyL5GPJXy9GCPh/6AJ0aDQfesaQxk0yLWl5G3MfYXkiS/udQBkLx0O
         enVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727241425; x=1727846225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fhk7AtsWhDFuPmtNUlDKn6sBuzOpIwa/342Zs5QfOV8=;
        b=nLqe1nmWnHofCEeRkE1Kmtp1G1nkiMsRrQ9FQ58V6RXAOjIXV4qkRWB5QSxRRCoeDI
         z07SMP5on0PVJ1SRWx5g30BG0Fgh0d+l/bv/wGt9OC+CPrvHxzMDGiISyA6E71SEdSda
         8EV9FoIL5W/odUW1uBqOoNDluGp1WNq2lKnvBz2exnDiXCimlTA/E5Y3wHvdkQP3HSBt
         nhNQYEf52pJIwyf0Q6ePdmxSWjDqlqBPsTt4HRwjaDbmDubE+r6VWyN/QBTX+c5s5PhO
         bI/TIPDrKDKTxYrfD7JoGPRkv7hiTWzmUPfYCcf7xZZRfXN3BLOTQ94JeLJWOui7Ykx2
         xqQQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3vESvBYQ1m8D74DlnuybRBuLSjj5PxW2oCgf+qhMDqYNQ4Si02iHphrCh8D3jcCKOnMaSPvV4Xdx1Di8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDIy5UVh1W6Ri4TO7e7B5q/B5H4H+Svi1jKNJcKlBZz0ChzXBw
	a5s0MYa6UNfDBYABRbiE50p8tnT9iT4AkdnXJ8eWabRl5NSf+L1KGah771XOHKEgFOsEIy7BEs7
	oG4rtGGBmsaW6d8bs3f3+GbZH128=
X-Google-Smtp-Source: AGHT+IGqOkO2Qu6fsaOBmWQsbCFOHGqXBfN3Fp8XDXFwv6eHmGAFcrJqmt/lgBSnyz4faQZjsezqGiYZ5/Ct9HNLqkc=
X-Received: by 2002:a2e:b88d:0:b0:2f6:62a1:25fe with SMTP id
 38308e7fff4ca-2f915ffa498mr7963691fa.23.1727241425070; Tue, 24 Sep 2024
 22:17:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFXBA=kKHa5gGqOKGnJ5vN=XF9i3GB=OTUZZxbfpU5cks=fW3A@mail.gmail.com>
 <20240924225739.GE1585@sol.localdomain>
In-Reply-To: <20240924225739.GE1585@sol.localdomain>
From: Harsh Jain <harshjain.prof@gmail.com>
Date: Wed, 25 Sep 2024 10:46:54 +0530
Message-ID: <CAFXBA=k8s5Oi8D3RP59bPoDr9tTd2+E9jK9smadtQhzEkYXeuw@mail.gmail.com>
Subject: Re: HASH_MAX_DESCSIZE warn_on on init tfm with HMAC template
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>, h.jain@amd.com, 
	harsha.harsha@amd.com, sarat.chand.savitala@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 4:27=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Mon, Sep 23, 2024 at 12:39:11PM +0530, Harsh Jain wrote:
> > Hi All,
> >
> > We have observed self test failure with hmac(versal-sha3-384) in
> > init_tfm callback.
> >
> > [   14.672021] WARNING: CPU: 1 PID: 578 at crypto/shash.c:495
> > crypto_shash_init_tfm+0xac/0xd0
> >
> > In init_tfm ("versal-sha3-384") we increase the descsize with
> > crypto_shash_descsize("sha3-384-generic") . When HMAC template is
> > enabled, it add 8 more bytes in descsize and reports warn_on because
> > descsize is 376 which is greater than 368 (HASH_MAX_DESCSIZE).
> >
> > HMAC            versal-sha3-384         sha3-384-generic
> >     8         +              8                 +            360        =
   =3D 376
> >
> > What should be the preferred fix for this.
> > 1. Increase the size of HASH_MAX_DESCSIZE macro by 8.
> > 2. Register "versal-sha3-384" as ahash algo.
>
> There's no versal driver in the upstream kernel, so it's not entirely cle=
ar what
> you're talking about.  But if you're just adding a new SHA-3 implementati=
on it
> should use 'struct sha3_state' as the descriptor context, like the other =
ones.
> For HMAC that gives 8 + 360 =3D 368, i.e. HASH_MAX_DESCSIZE.  The extra 8=
 bytes
> that you're somehow adding to get 8 + 8 + 360 should not be necessary.

Hi Eric,

Yes, Versal version not upstreamed yet.
Upstream driver's algo name is "zynqmp-sha3-384" in
drivers/crypto/xilinx/zynqmp-sha.c. We allocate fallback which adds 8
bytes and HMAC
too adds 8 byte.

Thanks.
>
> - Eric
