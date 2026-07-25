Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B98436164D
	for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 20:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785012919; cv=pass; b=kxF6GIxMkUKnrEyInDIjoX8zuvRcWnA9iDcfSVPCsg5vdXhtPPIC1Bm/o0fr/5soY9AYVQFEfa296GSvxNa+rQ8LJTgdY9K6RqbcxrzpqMnpHSKoDQIvlkD01oj/mcRKOyW9sr2rh+JsZjUCCdp4BkpqzushLCtuXrxMXkL41JE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785012919; c=relaxed/simple;
	bh=zw51gC5xIPlAb+ehmicqnY9g7AruYRjvzVknaMunE54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ijN8PG5zPyg5YI2+GUlcwHxXq7cRtNQff40mjO2wXj122Q/1zSB+2W/JgD2k5MHjIEAuz9mp9/M2XIrJoZNn852B5y+Ze7v0GtupBSiiyE7hu40uMD3AY+ELVRXeRsHQcGo3C8Z4YL+1A7U3IKE7FcTd7K+KahxQE+Sl582G0e4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCfA16sJ; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCfA16sJ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8484f229529so1003713b3a.2
        for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 13:55:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785012917; cv=none;
        d=google.com; s=arc-20260327;
        b=H6nC3vv1kG96ysYfHSfnciN19xLkNpApwScAuJ1nw5SoPIUBbNamZkfnx/ivqRwA6s
         GsdQXNnporEFsrplHoPTpz7sHqmjez1gsKIwJCqEYbZWtvbw0u3ww+Oi89+5oPzMXdrO
         cGR0uXucoofyqktle7vv3hubgExYyhSYnZB0WeVq16uaVIWIy2iIkVFkDluE3eTVxjxT
         KAC8psQW1DJMmU+puR8UKUewhFxa8dtkcyl+ZI0PQMXglFX404nAz48PeolYquOxFSyW
         z87gXCoDjcbkzlgHKCrxQWUY6eCZCHrgp3AaDiyCICrTShAIAAJZP8SQWhJnOjS5hGji
         rTSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8WOQSahUV2FdjC/IM2f0n66+R/EWHlwNnk6q/oqvWX0=;
        fh=oPxLHRdqyjxF4C0y10DHLoR/w+Oa2Qpx6174QQ2Sx4g=;
        b=IZyFz2LjHUczFl/eN4LasHnt2heygKvzoB75rqx3esQXnrgZ6wpW+RbuOde+ZQbmGF
         AK7C+prN8NskcdAC3LmbpP8aF3/gHnUxBIZn7vdYn7YqavnnUa4g9DHsWD+gb1v7AmPs
         vWwYCwZVXmqppt1/c35aIlFVwtY3BVDrzMhU5krJhUAEyLLMVwfAXLKtqTpikUf0FclR
         DyCHgP+5MJesWuUAvNu1r0F6mth+Qvmazht376LnPLGG+g1Fv4xtHKC4lDlCSZKqogWl
         IHV6pODDmcT9vcMfhZDqOhJ3cYzFHcfA8PScgs6p7buSbyuPXv6LDrqwIRYq4tYkHPob
         T3cA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785012917; x=1785617717; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8WOQSahUV2FdjC/IM2f0n66+R/EWHlwNnk6q/oqvWX0=;
        b=CCfA16sJBtgz8hldzWHYxUcyEjDqG0Y36DO6tVDS/ExmfNKDZzPZL53IiAy2HXqw2O
         KGAlALuZKD65GL9IxDdiAKuHMignZ6WXOsZx1samvNlbskdHpyC7TijOlka7b7Ab7JlX
         9DOirbvc9OUcRek2FGlvwCYNbjCSoGUKFnIS+mB249msG4ov5+/MS9llmMgoi6gXo4wR
         SQnOgz2SA+68IAreR4Ru1Uk0nfis315U2LA9sR0U72Iezp+sgkabMYRYXpfdgB4JiNMS
         jEuo3pZ0GvvmCxcqlnHbjxszgy/btfDRvWGt+aeO2Q/am25HTFd9D96Xz6Fy0N7YIeZO
         Yw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785012917; x=1785617717;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8WOQSahUV2FdjC/IM2f0n66+R/EWHlwNnk6q/oqvWX0=;
        b=UmtvuDO/JnuCFuhYCZWJwKoMbwxx3LvzsUg4UvHqiG8hrjtA5jF7TW0DQd5MlzU9ga
         c/r0qwsG8cbc61TM30Mj6LqkdS4BetoOR3D7YicauR2vLxWhyLqi+vD1X2N7ZoZb2qqf
         1QRchKCjvtVLnqogyGK4aVcxIO+IUk4KZF+Ac6PMi0iPeulTj++mOmbi+LaWVJZr28ap
         RKyIZ/rUTBHSlshCaztPJYsmZSiiPpmaHPLa8kiKGi3Uz2PZeIBItKYmUmCCFLpgRkTS
         FO1BiqGN6Qr9DRKuJWNWSAYWIAxNWV8pq9f7aQ/qz88yvj91fng9cNLJNkOphrTHkH3B
         D/Qg==
X-Forwarded-Encrypted: i=1; AHgh+RqvsV3u0j/j2gaFnhYJOAKYqI3uE2cJGR8jrFhPSmjUTbeHOfplBnnXq5kBfS99q7fBS+ZxFyEpS2OUGHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfD8jpvOIf/0uaOaKxrDSzrYvv+oJax9zp4Biwuwgr9wF0Q3hO
	xvawNQnvTrbD4Zqc5KvkEfoukSe4r4wQg8VW9unAPR4qqrwVTXK9+Wrwj1qmknV2UPX3xu6J/BN
	uR5oceMYi2QU7Vt3e4P8wItBumUBaCBE=
X-Gm-Gg: AR+sD12RJ4JSMddAn4qwawMjDEZ5CuouWIuoki8JH4h4X0iol12RuuqDq8yaC7BlPIh
	1hhPweKp5UOKr8E3Mn0JoS5MOA4i2OH/5YaeiYnRj5f4hhjAFaJKUFAMxHis4Fy4Lt8SHXf90k5
	AidjEPjzW34OUZ2ZHKnK7z2fIC9GWRrsYuiRx9PIY8PxmuiUjCKrObUexG1RTgi00w41faYiiTK
	ugRbJGT6E6XfwCryYVlMpmslx27H8NzkjZ5/WAaNC2Gu7XUJJXJ6yAdJQFjyQ==
X-Received: by 2002:a05:6a21:4784:b0:3c3:990b:2292 with SMTP id
 adf61e73a8af0-3c67dfe6723mr2903792637.57.1785012916705; Sat, 25 Jul 2026
 13:55:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com> <amOGWwdjnJqyxH5L@codewreck.org>
 <20260724160034.GB2032@sol> <amOTjPW__CNZui3_@codewreck.org>
In-Reply-To: <amOTjPW__CNZui3_@codewreck.org>
From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Sat, 25 Jul 2026 22:55:03 +0200
X-Gm-Features: AUfX_myV9AV5bwxaPxDCds8CpJSSwUUfrEfnR7d5D_zQ_thbtzqC3K-k805u5U8
Message-ID: <CAFLxGvy+ec3nQLrQtwFZgGELhT2pKBDnHdD0pMvEGh-Mf3rjgQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Eric Biggers <ebiggers@kernel.org>, demiobenour@gmail.com, 
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

On Fri, Jul 24, 2026 at 6:41=E2=80=AFPM Dominique Martinet
<asmadeus@codewreck.org> wrote:
> > There's no "tk(cbc(aes))" algorithm in the upstream kernel.  So, it's
> > not possible that this ever worked with upstream.  Given that, there's
> > no regression in upstream for this program, and it wouldn't be
> > appropriate to consider a sysctl knob in upstream at this time.
>
> Bleh, you are correct, it's an NXP patch in
> drivers/crypto/caam/caamalg.c that they've been carrying in their
> tree(s) since 2018[1] and has apparently never been upstreamed...
> [1] https://github.com/nxp-imx/linux-imx/commit/6868c9e49c1854028fb46022d=
aac3b1b10ca2c70
>
> Sorry for not having checked, I was hoping for better.
> (I should be used to it by now...)

Sorry for joining the party so late, you're killing AF_ALG faster than
I can follow all the mails.
Speaking of CAAM, there is a legit usecase which exists mainline. No
vendor patches needed.

You can create a CAAM BLOB (a generated and sealed key) using the
trusted keys subsystem and use this BLOB
later in AF_ALG to perform AES with a key invisible to userspace.

e.g.
kid=3D$(keyctl add trusted mykey "new 32 pk" @s)
keyctl print $kid | xxd -r -p > blob.bin
Then just create a caam_pkey_info in userspace and feed it into AF_ALG
and perform AES with it.

So, pretty please,  if you kill AF_ALG and all this, offer some way to
achieve the same in userspace.

-
Thanks,
//richard
