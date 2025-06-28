Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE3620E033
	for <linux-crypto@vger.kernel.org>; Sat, 28 Jun 2025 02:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751079351; cv=none; b=LiDJNoFAT1DrzbUsDAnnhFN0NM52gCzkeMZBk2AJq35UBlVCKIrmKgm6lvHHiizzL/6c1HIoPW3kDsVhEUCLl5UP4sA3P4I7k+FSUQrRdlB6Rot4FqVZMK4x9tE8bH82Pzep3EfMJOz5KYs7TaKmQOQXOAQWpaxLeASGhrpgLrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751079351; c=relaxed/simple;
	bh=KbfRmXC4NTNauZOUB9GD+mVCeRsqTlS05VgQMq21mdQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I+tjlx635NOkrDSMOi1heR2/UT1t8ZOHm7OuHimBkV8XWt69ISrNsLUu8ivN+7JlNcfmdMDKmAG5UXZtEtyprscNx6EmdBYtLMXqzZ3ck2PDhtuohGd+5zzRFoxFo7EuSTMiVgjksQvrhZFZgdH6gMyJU3Aw9tiXnZfp6ZDzudc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EcHca1wg; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EcHca1wg"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-60867565fb5so4714147a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 19:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1751079348; x=1751684148; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vCBwF/dyDWbSKrtKSs8jNwvCbb36MAxnZBMIIhEp6cI=;
        b=EcHca1wgzOiJS/SVWo+M0KxzFNufUtJvU0//bNuiClOi7Wvj42glBla9xVCBNKcZi0
         pn95fQTu9dZbKLipC3Rl3damj21jFWOFIlOZH4w2kEYf94Wak0zEYw31ew0WqKTF2aal
         2aRXkdVDe1Ud4J7YYeJCh4An2QUDES1pBXWoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751079348; x=1751684148;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vCBwF/dyDWbSKrtKSs8jNwvCbb36MAxnZBMIIhEp6cI=;
        b=pC72TVkFL49ONlzQIlQoKFum7xRE6GvaNGNjK5CUr124XyD6tGIUpHqNLFi0sxlXhq
         pysEXB2iGtRQ9EBrfOCRDFOuC8OC/+8sAY9yx4RlO3XvTLS2sZhpQ9fyG+Kn1ako7guW
         v2eGRo4RbbQQV0Ds8iWYBVRgxDs+RDp6ibidSUs8G3Mi6kCBMnVLRaWs4agFmR20sJJ6
         IcgGiLY2yXEzpjtXMHEtC/eK0EXe6v+VVyeOKq/I1ZKG7L1mdARwMaV5d38JLFS/rjqx
         CD1w1PbUAbY1rkoyJjZ3lXhw87to8fxdnHvptuSH7WR/XNae8aizaow96x94b8N1KTOf
         yCPg==
X-Gm-Message-State: AOJu0YwM0bJvqFbILBxr/a8LUaqN7qCAUDZMnv/R4VTIS7fiN+sgiM8i
	fJUzEVvEnBLRxmkHb8GK6utc4WCu2CKjgivFbkLJKFuYrWN7lRXJyeo/nGodkX5IHdkn3UK1ppW
	0XOKBd1PFKw==
X-Gm-Gg: ASbGnctX826piQbcVPbaFtPispsiHPLR2H6NSOAe1Eck53wkK8DJv4OXdlSL1+0+eYz
	pMGG2tC38pjQCmP9Q3+S8DwU2LgFHDWcJysdtmC2rcZHH3qTR+WaepQqgZNx5Vws3nLISLia4Eb
	yFG0goIOugTqGZnc/vBGRSiSzMSfaBcWERO1mKb0NAAJKQm5vSivFSBmABHnicAWeSPCpLSD41V
	vUjCXPnxhicQYRcIFQshrExr6krkp9z8to2ENTj3eGzxsjGtH0gPVjoByfkoGZY13juqO3pgicm
	5ohg3Dzmcg49EKSDf6qJNg596hBCCpQcQ9pqJzdN1E0QQcmiNr6Upfe8mkZLA9sQhUkhXDLxJbK
	ivmG4r4qxLGgPuRtiC7kM4DBY4EcR98bCjeRLWN2NqZz8Xts=
X-Google-Smtp-Source: AGHT+IE3nEQCvFJxL3vvnvCH6knTXFg0jIp/niQ6RviNTRgptEar0K86XQm9BBPrOFmt8SweJl6MQg==
X-Received: by 2002:a17:907:a90a:b0:ae3:51c5:8d35 with SMTP id a640c23a62f3a-ae351c58fd4mr526631666b.48.1751079347648;
        Fri, 27 Jun 2025 19:55:47 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c015b8sm230218166b.78.2025.06.27.19.55.46
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jun 2025 19:55:47 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-60c60f7eeaaso4620970a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 19:55:46 -0700 (PDT)
X-Received: by 2002:a05:6402:3484:b0:60c:44d6:2817 with SMTP id
 4fb4d7f45d1cf-60c88e17023mr4811505a12.20.1751079346498; Fri, 27 Jun 2025
 19:55:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250627181428.GA1234@sol> <CAHk-=wiT=UUcgCVVo5ui_2Xb9fdg4JrPK=ZqpPxDhCgq9vynDg@mail.gmail.com>
 <20250628011834.GA1246405@google.com>
In-Reply-To: <20250628011834.GA1246405@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Jun 2025 19:55:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgVCdMX_KODjSaMD4hXwd6o7R83vM+i19b9M-nXW8Fe+A@mail.gmail.com>
X-Gm-Features: Ac12FXwe-leVLRXXPSsAQJY65WNZMY2oAHPhDoNGg64tIEkUqJ2tjXfK6FvYKHg
Message-ID: <CAHk-=wgVCdMX_KODjSaMD4hXwd6o7R83vM+i19b9M-nXW8Fe+A@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto library fix for v6.16-rc4
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Jun 2025 at 18:18, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Purgatory actually gets the generic SHA-256 code already.  The way it works is
> that for purgatory lib/crypto/sha256.c is built with __DISABLE_EXPORTS defined,
> and that file detects that and disables the arch-optimized code.  The
> arch-optimized assembly code is not built into purgatory.

Ahh. I completely missed that odd interaction with __DISABLE_EXPORTS.

             Linus
