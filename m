Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D647229B768
	for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 10:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750846167; cv=none; b=bNYjz9KPMSXRVeB6vvVRxnak/LjyMTN+jipM9KV8NClHRHsLL5KVQqc3lGjnEh7YUKI2H5J0zTIApxhzzEFpIudgoccZW1mrdeeWfyitBkK5pgKtuNkL+QD8NoUXOEhlU9sEcMG6Reu8ss/iA7ihT5Ncmo5yy/MbBkaEKNwb3C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750846167; c=relaxed/simple;
	bh=oI2RpGynwZKHg1r8I3RrnIuamp73/gAftLmPz5TS9m8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=r3y7Gbieq8+j9El3oqYcFjt2wehZyCMlbG6yYu6ipj15p4FJGbDFQ85l8+t3s83sQ6IOgLTiOzyR8JAxCDbgHco1iEV9N6ACBTW4Syd8kB0odoJfS5JVLY0UDpz5MPTGgNeYrtr+D5kjeOozlWO6EKQj4Z1luj9XGLn2r/Kblw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=H1QYt0eu; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="H1QYt0eu"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-70e3980757bso7251857b3.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 03:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1750846164; x=1751450964; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CEiCVSN83PBGlTUO/aKPbvLxDE47drJugzRrPtglAog=;
        b=H1QYt0eue7lJmPmD4cBXFZOzdRrSG3BWGzBn/kCLiSJ5t90HWfewwUpIUnAIWxLiYV
         ph1BAls97zuYe1+dITnmkxaiJZOhBYYLuaIZuDqRriEMJnNzIkCXxNLa6AkNh2ryRYr0
         9YHGjNNIglnHoCUjh9m68FSrKUyXmy7tDaxuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750846164; x=1751450964;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CEiCVSN83PBGlTUO/aKPbvLxDE47drJugzRrPtglAog=;
        b=BLv/m6dFqTegw8MkajAvZgPmq5y0PDuUkUKiB+O3IjeuI+gKna2mEbAKWTbLdeOpP8
         GFoL/az2Hh4DwvwM8ncArh/S74Ydv+oORCUo0+KOTT5x3aTBr9iVokm5qkZExGrhcfVZ
         LZzfrEnZe07bdQHqDSnYA5+x7Y9GhVgBza+bIf7Js/dDI26YELiovAqQxBGZgS7txY1x
         MRsFfJNZ2YEsyUDaRTbywvz91tQbp+WlbqUZ+1lhc2BGJrjeMIvX1ZyLxf2Ez4gkOIUQ
         6ln9ObhutUuedAlUOz1kEpqcHJQrzedy1UhBfTyoaDH03BQawtjtZx67xsfY/DLhqZLb
         3Lng==
X-Gm-Message-State: AOJu0YweFT0OOBhNKaEj2cqL+nxvvNC0bCJc5df1dINGJITCnv3TKxib
	dc9SHaNMsglQhx8u8sqAp4DV/ulfJcEz5D1glaGuGLuk3GIMUuyIIvPXS2OJOSvz/U5RXXt9H8Y
	mXhqd0qz4vmKvZBSZz8iSX6pafcSNBOc0cH0rjzVNg65X/U1z+jxaNA0=
X-Gm-Gg: ASbGnctONQkXZWgcdddrnQjbhlxbt1KkV+A0s/F3JD+8ssb5J0ToXE3MlJqSVTavSZL
	5PoFf7ZaUN6HfVbZY0EFkK2BEvf9vkHt+Ft7soWcAEkwTWodsZB7UfwQiSAqIjvyAXRRuAsN5M9
	jjmqLVOD7FUPQyf4XNfe/lxaixifeqxTD9svap5Q8R1b42
X-Google-Smtp-Source: AGHT+IE1aUXHjwmMi7BZlk2A1yC70HJ9346ZaqdzowkQqD6P3DZhjnGW71Ddup7fmEocAbmHGGMMkpesmS7qjX9YHFU=
X-Received: by 2002:a05:690c:a0a8:10b0:713:fe84:6f96 with SMTP id
 00721157ae682-713fe847182mr50071817b3.14.1750846164592; Wed, 25 Jun 2025
 03:09:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Wed, 25 Jun 2025 15:39:13 +0530
X-Gm-Features: Ac12FXwGQwKxnCuKXoH8hLW5xS3SXOk0DTiG9EfPSUeET8XWdVLzvSbULeoPDc4
Message-ID: <CALxtO0mo4Xp3=RfcHZwmqsD=YsNYMrDmrTtXJ1VcnHNvWzaUkg@mail.gmail.com>
Subject: cmac-sm4 & xcbc-sm4 issue
To: linux-crypto@vger.kernel.org
Cc: Aditya Venkatesh Kulkarni <adityak@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"

Hi,
   On switching to Linux 6.16-rc1 for my SPAcc driver testing. I see
below failures in CMAC(SM4) & XCBC(SM4).

alg: hash: failed to allocate transform for spacc-xcbc(sm4): -22
alg: hash: failed to allocate transform for spacc-cmac(sm4): -22
alg: self-tests for xcbc(sm4) using spacc-xcbc(sm4) failed (rc=-22)
alg: self-tests for cmac(sm4) using spacc-cmac(sm4) failed (rc=-22)

On cat /proc/crypto, I dont see the CMAC(SM4-generic) &
XCBC(SM4-generic) ciphers listed in spite of me enabling SM4 support
in the kernel config. Am I missing something?

To test, I found a work around by doing a dummy transform alloc (&
freeing it) for CMAC(SM4)/XCBC(SM4) using
    struct crypto_ahash *tfm = crypto_alloc_ahash("cmac(sm4)", 0, 0);
The above call registers cmac(sm4-generic) & xcbc(sm4-generic), which
gets things working for the SM4 ciphers on hardware. That happens
because the generic ciphers get registered after dummy transform
alloc.

Appreciate some help on this.

Warm regards,
PK
