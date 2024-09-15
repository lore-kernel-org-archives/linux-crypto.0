Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C3E1CF93
	for <linux-crypto@vger.kernel.org>; Sun, 15 Sep 2024 07:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726384287; cv=none; b=P1DmLVsZHmrieyeZ1qaYuRo8pgNQOSvBXaZHDOdBTiKaE8dpySUdtC1DTZ6kw5NZz/pY6GHNcg8cb0HO8bVaxYGnR7BmrWO5FLmpPOlVNybRDAEX8gC1rDocTh/96TNhALlYssgJ0j8AcF9rmXjxbRA5ZMSuHmrZ6sAOpz9bxyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726384287; c=relaxed/simple;
	bh=xjWojUc1mLB5ktKYpFXYU5sO8vFqeC4TxRTtvNAcNTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GOt2XmaLd+bUPT4lH4h+d9IjJ+299zhUK4sLltaOdXJ5tkKc7efB8/p8Vl8vwVR9+g1wJYbaWLtZQQtxlK6HY0o+MLp6HfS+S4LDOqCHW57dkFuVrgCQ3V/9z4SjlIP8BoZRlKjUAh1SLtnHUuMwT5vvxGIQziwMYEXCEYVft9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g7MfO1ZT; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g7MfO1ZT"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9018103214so481314166b.3
        for <linux-crypto@vger.kernel.org>; Sun, 15 Sep 2024 00:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726384284; x=1726989084; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Yc55qxpiIVFj7PWD1KIvBrEfXf3cIQSNj9lFEjAYl9E=;
        b=g7MfO1ZTCqtEcsI2uxXwQYB41trv/aYnxKEeu/ZUWPq9H1MbiarpVfCXhjRQ4/cdfr
         a70CAIBqKCYm/2/woaPgbGTv3FMv6GVEpbrAcXvkH/UWoTmjiF8xWaSWZYYtoxxy9IPj
         h0R1zuhcy2MZg3z2EFD1uLOkeOSKPEOtpIBa8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726384284; x=1726989084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yc55qxpiIVFj7PWD1KIvBrEfXf3cIQSNj9lFEjAYl9E=;
        b=vq0KovkfJPKCe1WIgEhs+26inDTdS+XJvjug4iIIf7TT+IS/onqs9Cu+SmYFbbiLjB
         xgHpaWspkH7sFvGeit6XxMRqDoDOsNW6pYuBmvxRbv7b+yJthrkbDus7RI4yg1fa5aWm
         K461j1NF0zx20K0ZzNCkNydxS0IoGbw85lxbwptJon0AKbXHkqJlTSBcadymVC5oQoM5
         wDf+EyX3p+uH/uMM+bRuBHveGwIhB0aIb5BqbNTPp/PpQDG/YsfnTu1Q0MNc6X4mZs+o
         iT6GYrbAXxjzkCC8fl7OGjniW7cNS909BeSjanOaHLDOWUgGMTce3FQ4yWu4KNO53BmW
         QPUw==
X-Forwarded-Encrypted: i=1; AJvYcCXc9De1CTqqbgLKbAg2ZFGyeOQgVQsauHxHuhd3XS8zl2d/p2cd9UoqWWhZNZNOGoc5Tda6iND7XE87n3Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfVTf7YnbNtoyOwOSB5hZK8vGrCswCFLRG7LTiiicQeKdl+cjJ
	iRAghq3UYNTETydpR/iV+Wb3l3nIMYTcY1v2YzVa++WlV6aklUesUJYcCfmpz53Ij48LjCyssI+
	LdqytXA==
X-Google-Smtp-Source: AGHT+IFw3nfYF26K5GAlbscuvYBbTRdHz+04d6OFW8a/lXTqVCtAsYmnEPIBOC48k4Nji4mbURHgag==
X-Received: by 2002:a17:907:d5a1:b0:a8a:715d:8739 with SMTP id a640c23a62f3a-a902964cf9fmr1015941366b.53.1726384283949;
        Sun, 15 Sep 2024 00:11:23 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c42bb5ee43sm1359813a12.50.2024.09.15.00.11.21
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Sep 2024 00:11:23 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5c42bda005eso1281960a12.0
        for <linux-crypto@vger.kernel.org>; Sun, 15 Sep 2024 00:11:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUUlxZRGcBerP1sPHc7wx2OZ8DjHUZiNHlmTTrZGzAyva0RIzISadS3Cw90g7o60n1ilasWzdhY8pvbO1Q=@vger.kernel.org
X-Received: by 2002:a05:6402:5193:b0:5c2:7002:7cf8 with SMTP id
 4fb4d7f45d1cf-5c413e1f43bmr8669748a12.17.1726384281208; Sun, 15 Sep 2024
 00:11:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZuPDZL_EIoS60L1a@gondor.apana.org.au> <b4a3e55650a9e9f2302cf093e5cc8e739b4ac98f.camel@huaweicloud.com>
In-Reply-To: <b4a3e55650a9e9f2302cf093e5cc8e739b4ac98f.camel@huaweicloud.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Sep 2024 09:11:04 +0200
X-Gmail-Original-Message-ID: <CAHk-=wiU24MGO7LZ1ZZYpQJr1+CSFG9VnB0Nyy4xZSSc_Zu0rg@mail.gmail.com>
Message-ID: <CAHk-=wiU24MGO7LZ1ZZYpQJr1+CSFG9VnB0Nyy4xZSSc_Zu0rg@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] KEYS: Add support for PGP keys and signatures
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, dhowells@redhat.com, dwmw2@infradead.org, 
	davem@davemloft.net, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org, zohar@linux.ibm.com, 
	linux-integrity@vger.kernel.org, roberto.sassu@huawei.com, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Sept 2024 at 10:30, Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> On Fri, 2024-09-13 at 12:45 +0800, Herbert Xu wrote:
> >
> > Does this address Linus's objections? If not then we cannot proceed.
>
> I hope to get an answer from him.

So honestly, just the series adding pgp key verification I have no
objection to. The use case where some firmware uses pgp to validate
allowed keys in EFI variables etc sounds like a "ok, then we need to
parse them".

The objections I had were against the whole "start doing policy in
kernel", with what sounded like actually parsing and unpacking rpm
contents and verifying them with a pgp key. *That* still sounds like a
disaster to me, and is the part that made me go "why isn't that done
in user space together with then generating the fsverifty
information"?

The argument that the kernel is the only part of the system you trust
is bogus. The kernel does nothing on its own (apart from device
enumeration etc of course), so if you have no trustworthy user space,
then you might as well just give up entirely. At a *minimum* you have
initrd, and that can then be the start of a chain of user space trust.

Parsing rpm files in the kernel really sounds horrendous. But that
doesn't mean that I hate *this* series that just adds pgp key handling
in case there are other valid uses for it.

But maybe I misunderstood the original suggestion from Roberto.

              Linus
