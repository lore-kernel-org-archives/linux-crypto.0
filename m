Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDA7233141;
	Wed,  2 Apr 2025 06:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743575480; cv=none; b=uqTOHhsoYGFdaPYqEPc7CRc9FlyJKMa36F9I4DhavP3ftCixfsAh3KWt0IWTIAu0wgf77zl/qNXYQ5kT1KxtcQ2cCIr1A7WWjIkU7EFEVJN9OqB0R+UHAbtf8qNoewZRswWhiFsYYcxmhyCIvDLF9Ei4TGXY784ajFGVuAVg9uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743575480; c=relaxed/simple;
	bh=wTRnLvllekj2uyXJ3rQ+kbFGWy99udeTw7V2GSDXi2g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Auc39yLPD/hOXqhB02Ve/k/UA8wi0mX6HWsDipDG4KEtRUPboKY5is+7kaMqUKd3+reezBsX0vnMnpKjOYbYtD3qGwTm0DJQP3CcQdrn+0htOQ278N24vIgeKcThuKZaz1INhbNIOSmvmCj22M7pcaQS8/RPnmgCWY6UvqSxYaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZL9b4Rv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZL9b4Rv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3683C4CEEA;
	Wed,  2 Apr 2025 06:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743575478;
	bh=wTRnLvllekj2uyXJ3rQ+kbFGWy99udeTw7V2GSDXi2g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZL9b4Rv8HqCg9xuxwFoBF/DZ9EOL2E02p0ZAVBKJUOreW7SE4ycLwZ/+ExZMm4B7C
	 OX6PgQq89TsCjtM8BanxBpgPI1Rz/Z0UExSd6aCk0Zw/z9edRjOJrtbr+bI/qCFHcQ
	 cxZEOWeNPAUzasy8sOIW7gWhxj6GrQxzXOJamJURsJwW0w6+/wUDVrPdKmkKX+/bqE
	 RFzT9E0SWyNq9YQmCrkZzaDeEPYk24eimnde14HoXA5wl7wc2NgKNU+0hiAHZxqADj
	 W3kmRYxOoSXAJ0kIjLYDJn+E6Bf3xCoF2v7MHZogKuYfkAPfHfI7hlVtYbbcKkckLt
	 awFT3fQrT2bmQ==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-54298ec925bso9554116e87.3;
        Tue, 01 Apr 2025 23:31:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUWi/bj6pl/stzTopQvdnFfCcY4uNyJIFWBuVSOY47pAL2bAS4bdvRD+mPckHneAeJicg168xuh+okoPqwK@vger.kernel.org, AJvYcCVR3SFImhxpTZEe3C2kObFAZBn6vQrEM4/N8s//Qf2XcHIC8resV0MhQ+sPURikY7G7Qsc9jk84/m8Mh+A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/MrN7+JAqQB++uAxsoJWHvh4jipOUV8+GA7vhq0zdczKjDH+K
	Uoh8w48DktcKrV0FO6z/ghMU7YmAUezQ+jmdYBqNbdyM3hJ/DtFWcBd2IwIXOKeKSvwncgJ+6Ve
	Hy6WfQMS/g4+0AjTUVeZcCk3f1Lk=
X-Google-Smtp-Source: AGHT+IE5LxzI60q6ruFDhueOS9TfBE98w1ZvLcYf/IN3NnAdnzkFpXGfQUPLHTIHNzf3gzy7Wrh4oQrvxZW8y5QbPno=
X-Received: by 2002:a2e:be8e:0:b0:309:17:750d with SMTP id 38308e7fff4ca-30de02fc9femr54109761fa.27.1743575477203;
 Tue, 01 Apr 2025 23:31:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250402002420.89233-1-ebiggers@kernel.org> <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
In-Reply-To: <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 2 Apr 2025 09:31:06 +0300
X-Gmail-Original-Message-ID: <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
X-Gm-Features: AQ5f1JqqAzenV2yTjrUvtmUsZGw5uJ1-tpsRupyOXkxA8F4tKzNt1wDiKA4PepE
Message-ID: <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Apr 2025 at 06:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Stop wrapping skcipher and aead algorithms with the crypto simd helper
> > (crypto/simd.c).  The only purpose of doing so was to work around x86
> > not always supporting kernel-mode FPU in softirqs.  Specifically, if a
> > hardirq interrupted a task context kernel-mode FPU section and then a
> > softirqs were run at the end of that hardirq, those softirqs could not
> > use kernel-mode FPU.  This has now been fixed.  In combination with the
> > fact that the skcipher and aead APIs only support task and softirq
> > contexts, these can now just use kernel-mode FPU unconditionally on x86.
>
> Nice work!
>

Yeah good riddance.

> So which platform still needs the simd wrapper? I believe arm/arm64
> have both been fixed but we haven't finished removing the legacy
> simd code yet? Ard, would you be able to spare some cycles and
> finish the removal of simd on arm?
>

Removal of what, exactly?
