Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37D51DE896;
	Mon,  7 Oct 2024 20:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728334625; cv=none; b=HOZ19jStfAkKOndbGRt9xjMp4Epv/Mru1sG8hU7ww6SMJpwih9lJ93U3rGBggNomOdgA2QF+UQKjx4ge8q2pCmsyQYTqd7QjqlQwyaSzro6J9/qiYwhFCY9eyqRX0UeW0dzqwYRgkzufNPtOB4rSqovSZXOZ2a8cyFngVqE9cK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728334625; c=relaxed/simple;
	bh=wBttk45YYdLCTY9Y4llZCM/p/0fj5uFII6lbG3KCAlU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vep62NAKV7jR3xYvkulC6iQnHBpPgfb2zIpkX4RF7aAyhe4jN0oCrDW+r7pVp6JU4TbhL6pcYka8Mg2Gk5yfWvpLWK8Isd5uHqHPTIP04m8UTfuxY9WiiyoDXIpAnxdKkNc1sdhRkwlRVlTe1Cw0z6lnwHQFzKWeASx7zX/LQkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lx1sOjAN; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lx1sOjAN"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42cde6b5094so49569885e9.3;
        Mon, 07 Oct 2024 13:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728334622; x=1728939422; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wBttk45YYdLCTY9Y4llZCM/p/0fj5uFII6lbG3KCAlU=;
        b=Lx1sOjANlLikSyB14c5NgFosCGPUFkJjiexlJDygFAachB4agrug7UTD6gRCKOSCm5
         O4zX6xo7Ztjs5b6VmhmIR24zSAWfjoo3NuGfRd6N72w/cPNJsY1WpamQiO8Rg9J7fdny
         iquUPXX7K1C7jHY+VMtahiJS3FIp+s5nZ4Isi/iXPXqWBAxO8btS6agjBUNTm3e6ous1
         iHP4Q6YNBYlDQkPigd46KDD8bj4S0eGsli5FDY+iUFZrrOlNACgx9oqmQq0q6JFIiuMX
         p3l1cS9CidKDT8M75a33oGHKgmrQbba3t60RNnWOljs0Ozlfda0VPWeTIjwu9V/Wf6J7
         3eNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728334622; x=1728939422;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wBttk45YYdLCTY9Y4llZCM/p/0fj5uFII6lbG3KCAlU=;
        b=DIk6fbpFW5qRtslFxzuQ2ND8/UBPPLKDfJQJH7ioWgjaJ5t2WwvOE0WNOQLBGVMHsX
         wew3I0npIUeQNlUlKzM531P4mdjKnN94S0liazi9BrElhDv8KEAF41vI4KJdtRwpdbIs
         LA2DAW2MgZJ23Ru5+sz9WBCEUJaOZiGCnxUyYVJcLhXqBWyoQCcVyIMyinHletylcNp5
         Ih/hgiQkRwi+LVVyZWMciXM+yM85FjqPoDS3OhOO5ghMmEJiMNhhpI7TSIKJm+05v7og
         wYItjz+H8Y5nUG9HGAPUf/dn+66NBk/vBL5IoEU8txu+La0jPJ0GX0LpFbL+qOrNnUr3
         GC2g==
X-Forwarded-Encrypted: i=1; AJvYcCWHOAsu13grXitmB4/SgN3FNUer1EdoZXsnq2W9J1HeDKXqsR2JlgoYEKu4Ip46HBshvPVfRyZs29Rogjm6@vger.kernel.org, AJvYcCX2F6vBcWDDI2eId87PPFvDzo93qJ5HmT3i/75WMbadpFffYxksfxB6MaUmFLFyIvBp0C8AYsr8UtWD+os=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTqJTc0grZSGH6BPb15fH7JDcHUZbk3Vpw2iDD6XfObEk775xK
	xW3PmsCvfNGFPrQaaoh47UkUoBXp8vwzmcfgltvOQPVCLGXlk5r0nf1EkA==
X-Google-Smtp-Source: AGHT+IE7rA8so9eZhPhtCaaBVGih6XRy6e/WoLDVSBbTQmKsjmosJ1tzAUfVgshUqQwXRl8skik0LQ==
X-Received: by 2002:a05:600c:44d6:b0:42c:c401:6d86 with SMTP id 5b1f17b1804b1-42f85aea06fmr93438605e9.27.1728334621763;
        Mon, 07 Oct 2024 13:57:01 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:55c3:7d48:ce29:8f59? ([2a02:168:6806:0:55c3:7d48:ce29:8f59])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d1697024fsm6460391f8f.95.2024.10.07.13.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 13:57:01 -0700 (PDT)
Message-ID: <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
From: Klaus Kudielka <klaus.kudielka@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org, Linux Crypto
 Mailing List <linux-crypto@vger.kernel.org>
Date: Mon, 07 Oct 2024 22:57:00 +0200
In-Reply-To: <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
References: <ZwJUO5Nz3S7EeqO6@gondor.apana.org.au>
	 <1fc4db6269245de4c626f029a46efef246ee7232.camel@gmail.com>
	 <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.0-1+b1 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-10-07 at 16:27 +0800, Herbert Xu wrote:
>=20
> I see where the problem is.=C2=A0 Unfortunately this is not a regression,
> but instead we've managed to identify an existing bug.
>=20
> The cesa driver is buggy when you invoke it in parallel.=C2=A0 This
> would've previously resulted in incorrect hashes being produced,
> which would not be easily discoverable (networking users would
> simply retry if they hit this, while storage probably doesn't
> use these algorithms at all).
>=20
> What happened here is that the new async testing launches all
> built-in algorithm self-tests at the same time and in parallel.
> Previously self-tests of built-in algorithms were launched one-by-one
> so there is only ever one test in flight at any moment.
>=20
> This causes the cesa driver to be invoked in parallel, thus
> triggering the buggy code where two hash requests would be submitted
> to the hardware at the same time.
>=20

Thanks a lot for these insights.

In other words: The driver API explicitly allows parallel invocation,
but the driver lacks serialized access to its own hardware resources?

> So I think it's a good thing that the self-test has managed to
> discover this by itself and the result is also harmless, the buggy
> algorithms are disabled.
>=20
> I'll try to fix this but it's going to take some effort and I'll need
> your help as I don't have the hardware myself.

I would be happy to support development of a fix, by testing on my
spare Omnia.

If the above is true, the only other option I see is to declare the
driver BROKEN, since existing CESA users are likely sitting on a time
bomb. Some file systems do use hash algorithms, as far as I know?

Thanks again, Klaus
