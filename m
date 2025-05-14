Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47ED202C2A;
	Wed, 14 May 2025 05:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199577; cv=none; b=YHkKRkdMbpauyGds6+qd2IMdNVC9Qcw4JkzwgdUk7YRusLrbwgd2GUaFYOSRukt4ZQx6bQVUr/pUf3nyK3dOp1VNhvmS/eIx3ujWhg3KZ/lnRzd0cN+SdvrTGwU7awqsHopDghiBjvyorTdJxBPENyO3/PDUcVI1D0lVk+p7YHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199577; c=relaxed/simple;
	bh=yUG8ONjOe4LwcmpGH9v/45YXrb92a0dsHUD1DMtRqgc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BjRlAJWlB2X6kUCpjOqZTMDluv5rPWwjsOOBq0kMzMi3EzxSAZTVZaCIICtvhBV4ee6MjysKWVzFOPLR/FpA8I+pDWHSmSfTjXvytAtGbf27hoLhnWqxv1v4RydhJIQOTnlYq0cfW6OgAm1cVi/hG1YL54n09NnBHlaHpbcQ0z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ERvyXj03; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ERvyXj03"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so68032845e9.3;
        Tue, 13 May 2025 22:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747199574; x=1747804374; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ccAXzQ7Hj2l1zKP83Bp1shjlWNHgYOcGKTaM8SjJfbs=;
        b=ERvyXj03jeNUrtEQZx/jmiJsgYp6D/B7KzejNBzdgIp2Mw/h9gegTk0pmapkhUMqz2
         4qDVqBFnV3bIDKdAMCztG9HlggFn3f91yDBCa5xeejCVV0MKnC6bIxPFQI8060grI3As
         jidD78SSPJR4Nbx4y9FdkZnBQ6ymM9jlsSdaTjNc8kYund5wS5SEIHo0DCObZ3ctJ+xG
         Jp51utAqCiJDNZLeKkJgsXmRPW+bIz3YDc33C0Rsvfo7CAEDdwaZY+N6cUhEA75aY6NJ
         BTErzuX6i1QVHqBLJ7GTFDEYlKL69FglhBhvq7EAI0Y02cLhypPxFesAs2HBOfYUV3xB
         6MxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747199574; x=1747804374;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ccAXzQ7Hj2l1zKP83Bp1shjlWNHgYOcGKTaM8SjJfbs=;
        b=OIgNgDSATBfItz8v4pMyUerrScKwZp0tE7Npud2WLvi5IB7AmzKClNCU/MiJU6zdne
         tCW8BWCSy6QcX5427+8I8Fyx9kbzpVhwLgX6TutkOklCqnRtCozD0742QOTO+LtZOWAy
         puXGCymrO/iaTv4NHwsLrY9Z3u1hS1r2aiNuIucIav8Byz9ojWAu9XurwORi+lcUChe1
         +ff7YrVNqWWx0XM2KQDT73n4oC0nCZXKeO6x3dxbh2eXNFHUDw6OiUGTNmzIAD/cdEWl
         Pjs8hc3SwZ5h9JBj2OnfNVpbDNGBHXIGqh3sBUeiOuukQpaR/78RGBmf0VqohsNocXTr
         EXCw==
X-Forwarded-Encrypted: i=1; AJvYcCWCag/coQlLxGy9lwjIpGXJ4myxlpZGniv7cN8lq2PhafP69NdXb8iY5WIphpaqN/OpKZtw2GyUN/TWKPg=@vger.kernel.org, AJvYcCXto5VaI+CvJUAiucboCTqOUXIIRMgQ+5xcRtUxjRaqexVShlIehc6WZ9DYVP6eVZoJPEtjtqzEAxp00Q2b@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4fipg9Afl9t+Kjmjej0Yja0zAjg+3kIAQnwD2VkGkJeBz70v8
	57jCLzGY8tQemSgBLZyLRAiQgT4xmtXidJ9MaKpy1K79jXQzfjVE
X-Gm-Gg: ASbGncugRuBztxXatI32FilkCchX0ULP7wYBws9mVyTmOtRzdOk2cjypNLBuJWXf1le
	SjJoJSbwmmmde5UKtw2LRZEZhbI7UsR2v4QXwkTTg7PJkj892NWuWqKLG4Gax5M7nNehr50NAIT
	LUrBtHlbJemFeEkROnCYmUyLokRxaCz3GeP7a87GagRmo7TJ4MWlvLVr2FycRYGVUlFQ3CdHKm7
	/iOcgcYiWgTP6yr/RcVqG3kfoQIRc+t1mMNimneMjTejXd/LY5u6tnlclCG4jK3kNgDjfmUbw8c
	E0UAAtS1TO3giV2sToJ9RSs0jMPYHIN78QHf4TzNTBE5zmL2cgBb3oIp3mLhV+qFVhs1JGMJ46W
	1GySLoLSAp9avtEdR5mJgDnvMuseT6BhH
X-Google-Smtp-Source: AGHT+IEz8NL5ChkEQch25k/avcSb+ro7yC4An0ceFXjPtSS6PO6SClvUvx1aOjHJkqF+FfK7lsjm4w==
X-Received: by 2002:a05:600c:1986:b0:43d:7588:6688 with SMTP id 5b1f17b1804b1-442f4735b63mr6963485e9.12.1747199573832;
        Tue, 13 May 2025 22:12:53 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:a31b:44a3:4e3a:b121? ([2a02:168:6806:0:a31b:44a3:4e3a:b121])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f39e84d3sm12939905e9.32.2025.05.13.22.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 22:12:53 -0700 (PDT)
Message-ID: <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
From: Klaus Kudielka <klaus.kudielka@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
 	linux-kernel@vger.kernel.org, Linux Crypto Mailing List	
 <linux-crypto@vger.kernel.org>, Boris Brezillon <bbrezillon@kernel.org>, 
 EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>, Romain Perier
 <romain.perier@gmail.com>
Date: Wed, 14 May 2025 07:12:52 +0200
In-Reply-To: <aCMOyWVte4tw85_F@gondor.apana.org.au>
References: <aBt5Mxq1MeefwXGJ@Red> <aBw-C_krkNsIoPlT@gondor.apana.org.au>
	 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
	 <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>
	 <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
	 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
	 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
	 <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
	 <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
	 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
	 <aCMOyWVte4tw85_F@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-05-13 at 17:20 +0800, Herbert Xu wrote:
> On Sun, May 11, 2025 at 06:39:43PM +0200, Klaus Kudielka wrote:
> >=20
> > Here the log after modprobe, with the new printk patch:
>=20
> Thanks.=C2=A0 I'm starting to get the feeling that the partial hash
> is corrupted.
>=20
> Please apply this patch on top of the printk patch to confirm this.
>=20
> Cheers,

drivers/crypto/marvell/cesa/hash.c: In function =E2=80=98mv_cesa_ahash_comp=
lete=E2=80=99:
drivers/crypto/marvell/cesa/hash.c:403:25: error: implicit declaration of f=
unction =E2=80=98HASH_FBREQ_ON_STACK=E2=80=99; did you mean =E2=80=98SHASH_=
DESC_ON_STACK=E2=80=99? [-Wimplicit-function-declaration]
  403 |                         HASH_FBREQ_ON_STACK(fbreq, ahashreq);
      |                         ^~~~~~~~~~~~~~~~~~~
      |                         SHASH_DESC_ON_STACK
drivers/crypto/marvell/cesa/hash.c:403:45: error: =E2=80=98fbreq=E2=80=99 u=
ndeclared (first use in this function)
  403 |                         HASH_FBREQ_ON_STACK(fbreq, ahashreq);
      |                                             ^~~~~
drivers/crypto/marvell/cesa/hash.c:403:45: note: each undeclared identifier=
 is reported only once for each function it appears in
drivers/crypto/marvell/cesa/hash.c:405:25: error: implicit declaration of f=
unction =E2=80=98crypto_ahash_import_core=E2=80=99; did you mean =E2=80=98c=
rypto_ahash_import=E2=80=99? [-Wimplicit-function-declaration]
  405 |                         crypto_ahash_import_core(fbreq, &state);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~
      |                         crypto_ahash_import
  CC [M]  drivers/crypto/marvell/cesa/tdma.o
drivers/crypto/marvell/cesa/hash.c:407:25: error: implicit declaration of f=
unction =E2=80=98crypto_ahash_export_core=E2=80=99; did you mean =E2=80=98c=
rypto_ahash_export=E2=80=99? [-Wimplicit-function-declaration]
  407 |                         crypto_ahash_export_core(fbreq, &state);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~
      |                         crypto_ahash_export
make[9]: *** [scripts/Makefile.build:203: drivers/crypto/marvell/cesa/hash.=
o] Error 1
