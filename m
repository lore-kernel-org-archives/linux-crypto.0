Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B5A8821
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 00:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765930147; cv=none; b=N7eHnnDNQoBHWAU3p3bwk5w2fzkW/xjlyFMU3Qe1dhL/ebuyNoWg9f3+/sqRV3uDO5Lgdjd2Uh7nIE2rwTF+IB/cy9+CU+sQJJ2i92NHBLZ/qfYad0uR3HrG697qZVo0D8d0evVB2pM/nDVVRF+ji8K9FygtQaUHFki9OFe31nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765930147; c=relaxed/simple;
	bh=8zobOYD4U2IZu/IcNw1UhYqwT+XwT5RbnISKri0zFqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PzKnJ1Zf/1EQVT8p2TgIW56mgpJ5xqKgLGcWS7TsPNHRdnUBldbSfbKEkoE9xxsuv3R+W7yfK7kJkwlihc0onhyNW/00N2Z1gh9kbaY+/fhn2kNeoYPRD1WLS97HMrpBOJ835ejhpl7Dh4R2uniAg1rhdAweLvV6GjdFOyr6/9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eg/lDeOf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tCilhyWL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eg/lDeOf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tCilhyWL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765930144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8zobOYD4U2IZu/IcNw1UhYqwT+XwT5RbnISKri0zFqk=;
	b=Eg/lDeOfRhJvhU2NsNj4cVjtH7IM3ouKh95jxZfUrArUxhnnwPZgHrA8t0uI80W3aL03FT
	R41Fq9YdVPWnNc8wsED7wVCO/JqeIRvhnsolkXdMinFWLpq1wJHMLLUhEPSgikfBOHDB5c
	gevTTqwqS/FdxNFDmAzR4WXTNqR4qK8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-B_4LRKZcOp6M4R4ovDd84Q-1; Tue, 16 Dec 2025 19:09:02 -0500
X-MC-Unique: B_4LRKZcOp6M4R4ovDd84Q-1
X-Mimecast-MFC-AGG-ID: B_4LRKZcOp6M4R4ovDd84Q_1765930141
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59591ff7dc0so74378e87.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 16:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765930141; x=1766534941; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zobOYD4U2IZu/IcNw1UhYqwT+XwT5RbnISKri0zFqk=;
        b=tCilhyWL0xTzKfd3F7LBuD2M3tkMM8K31f1U1Qrl7UvqBcGa5pRiWrvF+OnzuKyVj2
         6A9ScXfzg+hYMyaR4hIOqrBuT7DpNr8FP6Vv4myBeGMCEl+I+WkQesBIwgZ8EOIep5aa
         6WNADDpMiL+WcvPs50kPzz/phHX2iW1yChSllclI8CBa0Zu/q1Ga386c7jVGALVQMvdb
         lwsvOCBG8YhY0XR9LhI5PMcKddWLgQPh5hYS/52wWKdud0pA/g545JsK37ZBb+lZ8Axn
         2ZrwIxVWc7KIBFEx/LyV7T7zgogl7uM9Cz75BVLM3xmiLM9NYNG7Hzl5VTjGqYJ3w7lC
         CU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765930141; x=1766534941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8zobOYD4U2IZu/IcNw1UhYqwT+XwT5RbnISKri0zFqk=;
        b=T2CsTxJLTxB+nGbvI9ZR8aS4gwg/fMiHuOb21IssAMk31rk00gz5XR4jlFu8q7L8Ta
         2rRlZ28a0Yg1BAJsTsq1/QrxrFA4nnv+sA7oPlF7vgeS89Xw+N+cAuX0OI8SXcjCtbIO
         yfRQZIc9ACn/uCeZ2j9a1zY4ShmVlSasYop5SmoLq1h12Sufxasb47nIBsuMMV0nBzPX
         kgQY7j9gpMuSq+gTUamdkW5DBGylpOO5SZ7eAtoeJZDueR6x6ztQyAHRZvTnoolqCRLF
         QjUQEWTUMj5jHuwmyrC6orjlKouyYr28IdrPVgh/W2QHM/AfVi/mBAaE4PGnUvZhYn9S
         fthA==
X-Forwarded-Encrypted: i=1; AJvYcCU96len3b+YWahyZbCuHvnmOvrykXLW+i9mgVJgE2rHKdrfifeA00tBX0Jcf5NORY4igPeOa/lvJ5PY5W0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJglzhWxVCbwM7oJ6I42iHnOhK++TkIAZLEUs82fhcvl9bqDbc
	WdRpV9iC2YVnNkkYiV0rEJ61U1qSldtDuSj2TVZJNMcCj7o53l9+IpKMfEt2s2L8RHI4NVgjK2G
	cP1AhAx9l4RpwxR6i9ykuyMDYQYJc+NsOFmRNd4MvNLV5CIkXetrlHGGXlqVEpjCPHtNQ1kTfHt
	lq9m9oT+KiJDyIxCV+HdIYvrq5PWAvor8GW3OOsmsA
X-Gm-Gg: AY/fxX6nojAnjRn4lnpwSlSrx3p/6PMxdhsyUrHA4gcjfxFcO4Y1zOrY5suIFmnOCsk
	TXv2cV4c/tMdUGAYpXm9J7xyCV6Zco5UZMNyelOzpuWoaRD7N0p4XJEAQoB4NCUvdQukM8e109u
	s25xpGTk7AzvK+EULNmBQJHN0nfEtrWimrikHr1ggAel3ew4xMtic7S5ExsnU2rPji1Oc=
X-Received: by 2002:a05:6512:10d4:b0:598:fbc5:aeaf with SMTP id 2adb3069b0e04-598fbc5afc7mr5165665e87.7.1765930141062;
        Tue, 16 Dec 2025 16:09:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5vz6PJf7q23xZ6gDMOqkMCey44MGj83spbpbX0uyRftW8nwS7rjua0KCcxc/ReO+GzZ4+ZdFjUgTsUb6wMzE=
X-Received: by 2002:a05:6512:10d4:b0:598:fbc5:aeaf with SMTP id
 2adb3069b0e04-598fbc5afc7mr5165656e87.7.1765930140652; Tue, 16 Dec 2025
 16:09:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205113136.17920-1-litian@redhat.com> <20251209225401.GA54030@quark>
In-Reply-To: <20251209225401.GA54030@quark>
From: Li Tian <litian@redhat.com>
Date: Wed, 17 Dec 2025 08:08:48 +0800
X-Gm-Features: AQt7F2r7sjIHhJYn8u10_JDVPCQH3hjWfeyIsntNusdnk53bfMv35yKRtdOuKZg
Message-ID: <CAHhBTWuXQY5CBLTT+-+WsTDw6Pua=Kt-4Mrj6+qiEjKEi+SSSQ@mail.gmail.com>
Subject: Re: [PATCH RFC] crypto/hkdf: Skip tests with keys too short in FIPS mode
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Simo Sorce <ssorce@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 6:54=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
> What problem are you trying to solve?

Eric, as you've said "keylen < 14 check in the new version in
crypto/sha256.c." was forgotten.
IMHO, it deserves recovery in terms of FIPS. And by the time the check
is restored, the hkdf_test
cases failure will likely surface again. Hence the skipping in this proposa=
l.

Li Tian

