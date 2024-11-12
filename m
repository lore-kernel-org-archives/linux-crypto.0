Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEC61C9B75;
	Tue, 12 Nov 2024 19:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731440015; cv=none; b=HYTwC5N+DXr8A/Rrc9yROIBJQgE+84x0LYVcrUHkRriUoYlhrAvle+xiLmyov53q2Mqb9aFBLijRpc5Qnh5aG4nzvqSPJn+33O5JLPzu+u2cubE2K3YMTbeHZwURO4+jFeqGZ8lrarr29DLLwKSOjUqNO//waV99WhYkB1ZOFn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731440015; c=relaxed/simple;
	bh=w3qyNX2H2QrqWPTFq2goSgvfzakUeX76kymsrd5YQ+8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y2FyxS5dZPAQu+YBvelCAbivWht67RcbyNeIIAoDEV82FdBDhk64pzb3kxaFGYeBwmTWEWdG2zdKTFeR14pTpwAcoNDpfeD50wJ7t9wh1ayYWo4HO2Mfsw4Ey2Sy/O8YNw+c1PO/zFDQE4gAydwN10RUDTCuPbVBBWL9Wf7tLcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RsNvqSy9; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RsNvqSy9"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3807dd08cfcso5684917f8f.1;
        Tue, 12 Nov 2024 11:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731440012; x=1732044812; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MkG1N8cbWQJiTBQoEK9Xgl0+1bD42d7g9R0q75SLLTI=;
        b=RsNvqSy9hIpaU0tLrpz3+/5OtE38B443r5yXSCINnNHM1/tS2tGKfOMqGiuFvpyLIx
         1QJDg2APcE3tze3wCPe7w1HyZ49CVEpHuy3qTXdzuMupL5R/qpQnofLDPA9h6yJ3onf5
         hMFVNrGhtnTJ5/e9nPxTY5XkvsbaZ2GpjcGJgk+LhQhmlhn1ilggkgyKW3ythrZn9xCL
         zxTO0lxfVAO1ww0ELUmiznrP2GmBFjj0uI7f69yg9htS8I6hRwu0LUPpV8+11QpVtb8W
         3XyBiFV5bsIt1XIhgVZr4Xpi6oNj98E6zZnkR6+iEFmvRRS5R2On/2Lgi+APB/dG9Xfk
         874Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731440012; x=1732044812;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MkG1N8cbWQJiTBQoEK9Xgl0+1bD42d7g9R0q75SLLTI=;
        b=SuJdVAK4lLHX1jTsKezY7bkxBU9L5CdFsw/1AyN1oaU0aSK6SwQ9RNtSRYdsVHOZj7
         BaYYHGoaEjaWyBDLKzUGDR1MSSoy8MaZ/UwZIL1yNZ6jjenOuUxRJ9V/2xcZgaQRLeJd
         MYq40iVhqfkAZ2flAkbYKqK89tmORterKguDeBPsdZo7p8a2TmeoIorQRtBqnCqAXt3U
         Ucsh3VyCf3JGAvfDP13EDVNnjO31Y2xyRJ6bwfyvcf2nbr82N63303Lm8uEUjV64ov4b
         JNKA/N6KRny5F7kkKcXfBSHHD1nnmel/1kMadN4aFwwvwJVZWhXQ1Ij3mF0e/3DkINnn
         z+Cw==
X-Forwarded-Encrypted: i=1; AJvYcCVqrm0/QI9UjRcNcYdAcz+xECD04proEZGIqTbiaKyANwoTpNeUQL2Lf+FPl9GZZe6lkH2HTkiIFV9p7Ynn@vger.kernel.org, AJvYcCXfaJ2Wc2uYI0Bwe7ciXpuv39F0Lx8iWVvdLgrllOgz2oitZ95NNkWbwTiHljsTqWvPq+6gpxt8ppY0iHw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUZoMmt3WOMFcv4UaSh0XaUKxYtetH5bQLUl8sMyQ3K/B1F6YD
	CiXnTa5SJT9K5TevwVTCMFsSfZQ9utbSMSzr18dffpYBtc7cK+y5
X-Google-Smtp-Source: AGHT+IFgwJTM/IhHEee60zDBS47L7kN9Q+Blkkfv/LqE5sDW9xPQbyIZlnwpmejRlJMCXXh5lsQYKA==
X-Received: by 2002:a5d:6d05:0:b0:37d:4c40:699 with SMTP id ffacd0b85a97d-381f1866b54mr19287446f8f.5.1731440011720;
        Tue, 12 Nov 2024 11:33:31 -0800 (PST)
Received: from ?IPv6:2a02:168:6806:0:b26f:1170:8ac9:f3c9? ([2a02:168:6806:0:b26f:1170:8ac9:f3c9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05e6042sm219502705e9.44.2024.11.12.11.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 11:33:31 -0800 (PST)
Message-ID: <3f14a6d189b65182ed502d534a49ae289e12dcb8.camel@gmail.com>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
From: Klaus Kudielka <klaus.kudielka@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org, Linux Crypto
 Mailing List <linux-crypto@vger.kernel.org>, Boris Brezillon
 <bbrezillon@kernel.org>, Arnaud Ebalard	 <arno@natisbad.org>, Romain Perier
 <romain.perier@free-electrons.com>
Date: Tue, 12 Nov 2024 20:33:30 +0100
In-Reply-To: <Zw-NJwLXXQ0DwR8b@gondor.apana.org.au>
References: <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
	 <ZwZAExmK52txvHE8@gondor.apana.org.au>
	 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
	 <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
	 <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
	 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
	 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
	 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
	 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
	 <2ae8006f3cfc40ae66b34659365596ac8507d1da.camel@gmail.com>
	 <Zw-NJwLXXQ0DwR8b@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1-1 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-10-16 at 17:53 +0800, Herbert Xu wrote:
> Alright, so next I'm going to try to make TDMA entirely single-
> threaded and see if that fixes it.
>=20
> Thanks,

Hi, since this was marked as "not worth tracking*, here a summary of my und=
erstanding

- hardware: Turris Omnia, Marvell Armada 385 (same behaviour on 2 devices)
- the crypto self-tests on the hash algorithms provided by the  Marvell CES=
A
  driver fail randomly (1-5 failures in 90% of the boots, rarely without fa=
ilure)
- this is likely a bug in the driver, which had been hidden for a long time
- it is now exposed by parallel invocation of self-tests, introduced in v6.=
12-rc1,
  commit 37da5d0ffa ("crypto: api - Do not wait for tests during registrati=
on")
- to be safe, the algorithms in question (6 in total) have been set to prio=
rity 0 in
  commit e845d2399a ("crypto: marvell/cesa - Disable hash algorithms")
- so, there should be no immediate harm by wrong hashes (at least in 6.12)
- there were backport patches floating around, but as of today they have no=
t
  been picked up
- no fix to the Marvell CESA driver has been found so far

Consequences

- I have decided to stop using the Marvell CESA driver on my production dev=
ice
- I can easily run test patches on my spare Omnia, if that helps finding a =
fix
- I imagine more users will run into the failing self-tests, as soon as 6.1=
2
  hits OpenWRT's mvebu target

Best regards, Klaus

