Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7ED21A45C
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741354672; cv=none; b=CrK6X6K8PQaKJi2jFC3UxNqVWNka+cMnxbDgQ5jsO4zj4y5qGM3p/2pxXrLiqkkUte0SDTPG8Dsq6wnizFkjmaukmmActzINqAFALvXjaCj7zBC5ek2vckUgLSoYomWM2P44UVLD3tZYMu0sdl+eU6KX/6ie6AlKR2HMwPE8n3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741354672; c=relaxed/simple;
	bh=yhAiG+qi3GeaVQhP5HW92YO4rjUq5KzIddSEtmQYAwo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cMBa4NKDvjaiGlOrhg8yp+6ThZyp7rvsfTv3EZarTDK77uEsP339J8sdAQUNOL1Fd0zZjsceyXwFHr0wG1SawzkESyLS8XeXyGNO/UOq0Al05/XLlziQpQUFrV84ucwItEnI5dS3qE4VL7ho0eKJegbipfJHOr/JTFu04dU2r/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=irJauzcN; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="irJauzcN"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5439a6179a7so1832535e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 07 Mar 2025 05:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1741354669; x=1741959469; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhAiG+qi3GeaVQhP5HW92YO4rjUq5KzIddSEtmQYAwo=;
        b=irJauzcNX9RDwDK9m+6GWPRDXgRBdNV8bbXKLyQZoDe2uDbJ2TF+W7sp047ao4GAOV
         vEA0K+KD3zb/BnhJXXcQrFXHTI6nE9ht+9vhHBfoLTg7perJFZ7rCaqkKsUgVRJVG4Ar
         VhvnLjqGmVZNL1By4jKht4tITJrB2X0q7NgBjPP8n0N6bqETEe0eDK8bb0wfwDzVsR7s
         t1rCH4GmTFB+VDMhcYOpSi6zK/D5R4vwuw73GUN6biYbuSZ2eWfXe8PXbceQxMmTZxx8
         kEs2icMEbbE3R8IXT46WkoUC/Z9T/Z8ZhQmydwhjlUI7PsWngT0xnNwN+547VQCNCfVK
         H50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741354669; x=1741959469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yhAiG+qi3GeaVQhP5HW92YO4rjUq5KzIddSEtmQYAwo=;
        b=MvsT49bPnSAYQXHbrpXpV/GGrvuALXMqzmIrla1fwEo9K2apB/PT2KObSN1FC36fgc
         ZAYu7KZ/mAZAjD6BDgliIseDfhLWSeVjlbJtW2TdxoJqOlA0lQkwGwwcsKyId8IISxR2
         9DIwhscC+bf8+9Vy3hkFft9uHYgFVJiZFelZ6Q7e2y2/2JxkhghnQbseg5RO789itoxL
         Zwgqf0CUNk2lBD8pwadY8u5MmV92s1/JiHiF6ZhZ3d8VQ1fUYp0E5bs7YZqIh8/i1yDu
         sput3dXvqxSEeC1fQP9KRRQgCIS1LQqMuiuHTvR7U7mtvAMKwArzrsGfwjt+6wyfQZoG
         hvFg==
X-Forwarded-Encrypted: i=1; AJvYcCV+eozRTYnLsIxfdsDn7rL+70mBQ6jL4Wbv3/VWiOzhoQTunhVr3LCLDspj4lVM0dJzBBnYXIdwgsIGXoE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ/hOatQT/J5wifspZZFeCsO3R7V36uAzIhCe/Vz8Jg/EpOlCV
	DwtSR0f8q6SKgNklnxC1mbHfmUtk3nBBYAJqoEgXBRF2GZ1cDC7nNX1M30RXbope8ItxC7ZQtpK
	tZV1QplDNm3DXUkDNP5ngZ81zPuq9tSA2PBIyHw==
X-Gm-Gg: ASbGncs2yirwf3E/D4QwhsrF7wesl6YIVU+vJX0qzXzTmy7MYHEMx1Lt6kM5ZQ0YKxu
	BhLoPpZsYCpOHjeJ/szEHzChrKUC2t+Dab8tpJ36jSaDxo1pjJ+nUUgipdq6Zy0gH1kg3xUZSNl
	fN9unCWYMRQKCVZz2qxhDGvsBxY8F2oTsyYaSQrs6L4zXMdAPKKAa6/ItW
X-Google-Smtp-Source: AGHT+IGzkNoMHjmvOj1hQqXkv2F5z2g3i4Jr8kD59wAfvhlOi53g3cqwXoU/0aqTwNXIKKE8Ssj4pheG14cvE/77p9o=
X-Received: by 2002:a05:6512:3048:b0:549:5769:6af6 with SMTP id
 2adb3069b0e04-549903f6a2dmr1550533e87.9.1741354668560; Fri, 07 Mar 2025
 05:37:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250115103004.3350561-1-quic_mdalam@quicinc.com> <20250115103004.3350561-4-quic_mdalam@quicinc.com>
In-Reply-To: <20250115103004.3350561-4-quic_mdalam@quicinc.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 7 Mar 2025 14:37:37 +0100
X-Gm-Features: AQ5f1JpFjLgvIBX6jbFKPzEzBuYS5kNiIudISoUHjkmPBU-Dykoze86uPUbnTss
Message-ID: <CAMRc=Mc641VWZp_2cMxrvs2ErwwkE04903GZ8BzDAZg3+H19NQ@mail.gmail.com>
Subject: Re: [PATCH v6 03/12] dmaengine: qcom: bam_dma: add bam_pipe_lock flag support
To: Md Sadre Alam <quic_mdalam@quicinc.com>
Cc: vkoul@kernel.org, corbet@lwn.net, thara.gopinath@gmail.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, martin.petersen@oracle.com, 
	enghua.yu@intel.com, u.kleine-koenig@baylibre.com, dmaengine@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	quic_utiwari@quicinc.com, quic_srichara@quicinc.com, quic_varada@quicinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 11:33=E2=80=AFAM Md Sadre Alam <quic_mdalam@quicinc=
.com> wrote:
>
> BAM IP version 1.4.0 and above only supports this LOCK/UNLOCK
> feature. So adding check for the same and setting bam_pipe_lock
> based on BAM SW Version.
>

Why do we need to read it at run-time if we already know the version
of the IP from the compatible?

Bartosz
