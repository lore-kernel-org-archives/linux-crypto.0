Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC625207A0A
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 20:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733259352; cv=none; b=rifuvrJvmb85S9A6MCaaM9E//tBC80qMJupwhoux+jyGjnFB0obiknQ1uD06x3a3RDSL087SCNa2cAC0dwrADlwQ4+jpX2b9UglZbSaMyCywBPTspEVd/ugxRSZpwi3Hffw/roxc02BvWm9lrO3oCvQmbvlojy8kNico3pIbAns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733259352; c=relaxed/simple;
	bh=eLcYDxcnynl1D64i+3DMguwY4XPCJg81k3dnaDdJIbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jB/0esxYvnfMejJQ2/oG8iq8HuDx6jDpA4pn1jHGy26LTD2eF3auCE4vbjaS4QeeSmmdhNlHwJE++pliZAhQFHH/uMvtMDTPC26Jq7GC6MLJ8ZtyWpngqQ9TpkDR97aemvbHMy5j9S8rukvcmNJP0dRp8AZGUWC4S7Y+6pNbVVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=LAy3oHOW; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="LAy3oHOW"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2ffc1009a06so89054041fa.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2024 12:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733259349; x=1733864149; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itGnniQM+p/vJK3/mgQYD2qiAW1SyPNKjRN6TdQ/bi4=;
        b=LAy3oHOW7689Xu8hkfLCcn/zdcmseTsoMEnlCZ55MSsgTS7beqYRu9VZKYxsFKtIjj
         FozwZoBjThDrIw0DMmLViENMn34PLHJZ7FG4MaPOFBQgyzLoQthiRq2AHWqfGri4Qrwt
         NIQdwjswkT+lLmXOLWsbXiqpaTavzzp7uWpkbrvCCYsNc6pdwrrBTBn8eXCmGuqUs6uY
         f7IO756gTnoHWjbL6JttF0Kah6WP1hgIN30nZPCqZBkF+FHU52CuTrb02Jj+tTdCiYoV
         3gig1jSpXZgdmASm/jh9nv6YuoGIB051fVOFwq2R1nGu2res8qWcKFtehClksOvU8umq
         1ULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733259349; x=1733864149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=itGnniQM+p/vJK3/mgQYD2qiAW1SyPNKjRN6TdQ/bi4=;
        b=SH3x34BciT6m9/NdhoHnKacmtA6I+NMq7ncZ0jxxt5j3i2fjr3ey3XCaJSyZx9Dz09
         a32FCS+ImUo2TuYEdT0D+ZzjvTlpLcRuIg6xoz9RHSn4nuStvlVbUP6hGNRBfDbRYduh
         PILVT92Pq5qwG1PZ78Q3w9jT9vKUSUHbTnNa5RBmYfni6eQYTxyB6OiO4V64ftGC6r0+
         xo4cER6IMB4ekuzshwqU4vzSxvBcRxiwfua5yuo8sNbz6mtJA05WdTI4ZbvM6gpa1EpD
         fRtNlStb9efOGOKc1u3tPhyhzxld3ZPGguPNim3EpNg2cVLhO2bgO2Y21kbnDtySLuwB
         Zs6w==
X-Forwarded-Encrypted: i=1; AJvYcCVuV77hSW//hR5w3yBu5T2qIHZs3YN14YttkZ0RbmjhfQYF2itstUXHqxErQBdLTkGq7bsPf+bIcuxJpcM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyij/yWXmOT9Bmx1qlhOtFeYObWVKBjjI2sZFiQkEwMKjfMF9Po
	9UNBdWAqwxT3BTYuqX0e9cwbok1AI6R9JPNb3LtwOK0FUHg8aphtznnV9nW6+XnZxI0pJPPAOBN
	pTyNCs4+/v1z3BK+8wxUtsXNstVc1cOGD05DXLg==
X-Gm-Gg: ASbGncttN9KPnJL8SLZsLTAYdn5fBUwQfCgW4kB/rHp3f7JKvT8q4wp678eap/rzGES
	4KeBmv9b6arrHyxpOU2savZjYG1SMYUU=
X-Google-Smtp-Source: AGHT+IG067Jk4LL3da1h5lHM6wFo0Vn15+FnIBImO91v0eGyNeKMO06aLWq6wdCh9MkvyOn+7a+4HaMe26FA43Y2k1A=
X-Received: by 2002:a05:651c:19ac:b0:2ff:c8a1:c4c9 with SMTP id
 38308e7fff4ca-30009c46233mr36458081fa.1.1733259348900; Tue, 03 Dec 2024
 12:55:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203-crypto-qce-refactor-v1-0-c5901d2dd45c@linaro.org> <20241203173503.GA1510@sol.localdomain>
In-Reply-To: <20241203173503.GA1510@sol.localdomain>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 3 Dec 2024 21:55:37 +0100
Message-ID: <CAMRc=MfGWOPogAqpC6vifQC3BYfSVqpVC80X1SL9XWypPLZPzg@mail.gmail.com>
Subject: Re: [PATCH 0/9] crypto: qce - refactor the driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 6:35=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Tue, Dec 03, 2024 at 10:19:28AM +0100, Bartosz Golaszewski wrote:
> > This driver will soon be getting more features so show it some
> > refactoring love in the meantime. Switching to using a workqueue and
> > sleeping locks improves cryptsetup benchmark results for AES encryption=
.
>
> What is motivating this work?  I thought this driver is useless because A=
RMv8 CE
> is an order of magnitude faster.
>

We'll be extending support for this IP with some additional features
soon like using device unique keys etc. This is just some refreshment
of this module.

Bartosz
