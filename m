Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E8937C0F8
	for <linux-crypto@vger.kernel.org>; Sun, 26 Jul 2026 07:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785051068; cv=pass; b=QsmouZuPyXCsMnRqHalBokt6sn486S34wjVOjhJQYN1NlguoBeMNEZG31nZDxXtWAg9Z3Di5GLfrQJBVOdDrE5s2zttLZUFrY0B1bjTkc9vCEZ7/owNV3XOG6LNNnrBG883FpWnF6msZkOvnYPL4kO3NR84TZ47rCJL+FMeCcHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785051068; c=relaxed/simple;
	bh=i0lh72d2nmu3uu3VDQoHujJQG0QNixt9o8QmQUrkaDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CHecj8tBUd0whn9Qmyz2+UosVT8wGqxXxLXvgpTw1daq2FiZOFYRWBSeGrNDxX/xBpC5bnTN3uv2+ptjg9KWWyxWnQUF2bT4LQ/E9yA5yHAfKCg9m+pKKlSrGPvGzlxvERekuBWhJy3bWGSwTrpDKfItLZJ+qeW7gVtkFb2WB4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZrK5Lp6W; arc=pass smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZrK5Lp6W"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso1761831b3a.2
        for <linux-crypto@vger.kernel.org>; Sun, 26 Jul 2026 00:31:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785051065; cv=none;
        d=google.com; s=arc-20260327;
        b=dgFDwqNf5kTIRS2mvNbt10s5l8b+h0liYLfdLckYM3uro/c6XsybFc8BnVo4VgJABJ
         34BoOyJv06tQamzBmbcnmcUPaZU8Xv3G3g03wVZ91tlibp3RystG+8+Kqd9jm3sQg7JC
         dRpnDHVAl0a3BXoksq0cpNrQnoB/IteioGP2aRGn28Yeov3lozISxcScjK7859Y0II6B
         a80d3VO929EgCqir/2efedHoCH7rd1purYQZRFRlINCBCrHzL7NnmmcdYNF+hdtD5jYK
         59NPUZmBeLhfg1kC5Z9OgQwNgMNVmQ5+8V12dk/TZnvOaPSGU+mKgSZM6sutn6rAxmkt
         ePJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LZTVSxKYFzxJZaYDAFPYkohl9eRKYUawYCXhr4l0HQQ=;
        fh=SYdZk1TxW6sCDJ7pU08FGloJp78B6rso39fJIKlfC2I=;
        b=mvt8I/mgJBuyj/8OZxmaXRZeqBBn7xXrYV1kPj7+VFnqRaGLEoSuIJZO+TusZL0Rbn
         SIJSy9rcUwr03utDVzPPclbRsu9xSDbM2pNY95SqCyU/d6fPY4/qK/QWAesT+waijc+k
         yKoVDlETC2mVYDRgsneRQ2b8Qs682gDbuE8wg3DTbywhy9EcQD1tttmvEXinoGq6NvsD
         M0uwdKXyom2zX20N7oMsWh6kMjQsXrmAppxn5VWIEmt5lyf5Dx7bUFwRK/jQnXRrxtfs
         TnGRLbSjA1Au/dQ4TAVj8RYzvyy0tC2rUG/RnOpFb1XY5aLKcDSMB4MIps0S5VrwKEmx
         GkTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785051065; x=1785655865; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LZTVSxKYFzxJZaYDAFPYkohl9eRKYUawYCXhr4l0HQQ=;
        b=ZrK5Lp6WqJQ4AYEUExlJ96qEozJu712C5w53xvpoTOGRL96QqYfaHp2RmF753iN5bo
         SpbMiuR/Rrr6NF/cirypL9oH5ccFJu5bTk5LzZmmXhUqeg7FVeM4fTLlYxpoITkSGNR3
         I2Um1YzhaO7tB+9iew+TAmbV46K8WlZPKgh13IKI/eze+xalGjRmg2DPm7Yb1PTuegy/
         MxmXX75YGz7gvyBYyFHTMjrtevUQ63b9cQ+XCIYw2mH1awAMLl2FHoDGAuf6Q59GTmyB
         e/a4KhMt4VrfzGIH4psfiIcGyicDjqv+g4+ML8pvR1lnV4M+UuNinfYSKlsY9SespX06
         E0fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785051065; x=1785655865;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LZTVSxKYFzxJZaYDAFPYkohl9eRKYUawYCXhr4l0HQQ=;
        b=QKyG/x4EsPbRQSIE8TgOTuOAsKfwd1uF1SvWI/V6gUDsj/VPEPVR820mHqGIm9DaU/
         uaN1JZupEFpdoMlNt4imw9Wu6D7wJYVyH0qpLsM2aTDGvEQemnAqaqWGHfg3ch/HQ+0J
         R07Opu1nEXN50P6a3O8SmAIrgf6pwO5V2AtA5E5EiO4z9WGCqgO5/GvdVuDO+QIUZPdY
         uxGMsQOJ0d1ipDG82HAr1kuISwUtdlcjcbeNXzGXs3g10vTuhuWo7KwcOMvdZoUoJbpP
         JhkpWwVEfi7V8vZgG/yR3KQPKjDZwwBf1Lt0dMt1t2MEpTMzmKOGJPbkhb6cSaFmsA3A
         hSdQ==
X-Forwarded-Encrypted: i=1; AHgh+RrpFs2ubdpDQ2QLCSgm2vqtAizQqYzE9gHxO45dgar0v9Cf+zmyohs13Xf+zCTmv9N4mhVMXNBrCRGFJAM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUOEAcLznzsPEylrXt0AJdE/coCFOiHanWOS40a5/QLipIdzQR
	n2ySXNbsoPXY2UZCOFCxOaGWv+raBmD6LfMCGoy1NjMqNnfEvLR+fHkZlhN7Hjkj1HN3Yrojyys
	Tatpgefp3EHwU7Q3iidKyd8GEHkEDynC1+fPY
X-Gm-Gg: AR+sD13RgGsGPGoTHUgMdca52Sv4SX130T5aUJ9rwmvd3Ny0MGyy5ETLoBfriTULyPp
	4O7H4Bc9lrRg7xbh3Smb10dLgXXFEovmH3RO1CExUkV4qcREp5aSYX/gqrnzP2TcyWvK5Yiptnd
	HfukArhB+WcKPZNKGjjW8SmrkP4miwVj/SbfH3aBxd3Ex2hpKnW1Kf6gKDU6DmIZsjHiIbC/LTo
	WGhup+2FIv6NpCAD9uU8bw4ZEerF+xU/ZNygH94a/HiocLX8e2m2MmNVcVLUQ==
X-Received: by 2002:a05:6a00:4213:b0:84c:4d9a:ae42 with SMTP id
 d2e1a72fcca58-84e59498487mr3719808b3a.27.1785051064667; Sun, 26 Jul 2026
 00:31:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com> <amOGWwdjnJqyxH5L@codewreck.org>
 <20260724160034.GB2032@sol> <amOTjPW__CNZui3_@codewreck.org>
 <CAFLxGvy+ec3nQLrQtwFZgGELhT2pKBDnHdD0pMvEGh-Mf3rjgQ@mail.gmail.com>
 <20260725220443.GA41199@quark> <20260725230922.GB41199@quark>
In-Reply-To: <20260725230922.GB41199@quark>
From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Sun, 26 Jul 2026 09:30:50 +0200
X-Gm-Features: AUfX_mwtxGS7a6c5QzhlmY01HvejyEPiuukikmfTBc_9wA_H1fyNyxlq8igMsLA
Message-ID: <CAFLxGvzT7jO+dxLSUgw0SOViuV7suY+Tz8m-RE6DBVfF-WbRUA@mail.gmail.com>
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

On Sun, Jul 26, 2026 at 1:09=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
> > You've only mentioned that it "can" be used in this way in upstream.
> > Can you confirm that it *is* used, and with an actual upstream algorith=
m
> > name, and if so which one(s)?  And if so, would you also be able to
> > share whether this is for dm-crypt or not?  We should remember that
> > dm-crypt accepts keys directly and AF_ALG is not needed to use it.
>
> We'd also need to know whether the user (if there is one) requires
> unprivileged use.
>
> Hopefully not: these sorts of hardware crypto drivers have lots of bugs.
> Indeed, the CAAM "cbc(paes)" doesn't validate the key length correctly,
> leaks DMA mappings, concurrent requests race with each other, etc...

Uff, you're right. There are some nasty bugs.
I guess nobody noticed so far because the algorithm is only used a few time=
s
at bootup (as root).

--=20
Thanks,
//richard
