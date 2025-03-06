Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B08327CB06
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 22:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741300752; cv=none; b=W+bxKriExh+nixdvKuSRbr7Fl3CqLH1sNqgCXJM3G3NGqMYaqKKp+tPjmeezXqJepnTLKhGwj7JiYlRm9/KaD9NBxzOgu+asyOaCa5RebiHKjSJ+kZn1QWtuUizWHXUafFxA9Ns8q+hd76xlpQ5dTrzy5jUKYHXaNquWYsmKT1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741300752; c=relaxed/simple;
	bh=hPzh7ssBwl1dUtDKNrXIa7KqEjktBsI9Rm9Oh1CqqTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t81OI3aKYHjoQPKaeOhwY31TzHc8izO7CPHzyDs1ylP6S6Lm+Efr7NAg9IEPkCqQ5+qQGxuHHv5j24aZTIjTyGFlReqH9qCpB8DAccXqu/4WXjifHurK6CnVWJQw81wi8sr+GXNj7N1aU2jIPiLHQaynuNqtoBJYoM//II3RTK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=JuWR+waS; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="JuWR+waS"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-223959039f4so24970985ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Mar 2025 14:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1741300749; x=1741905549; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h+DEPeF6tUdrf5sYZTIAFqaj+xuuM1BUFzIBk9RHTI0=;
        b=JuWR+waSQMkH0iH3cMQ8qbklxMWjjNbG5WZtfi1bNNl90Y3xWsDVNKguvHcHpxO2s0
         NtRs/Ca6VESVIgbSXPhjBjiGouvuffkk0jnWfZcxQxEYP+e+WsE7t+rsFqcxYltcidgS
         CXjJZNfvPtcVamKMo/2+4hTPxhuLD48IlV3qbSxylIKiXlMkL1n+KiErrCc3UnMGd/s+
         PtQUhsVFNzGwTqD3WjpIH4JQsakyJ1vm56WqFe/XEaFBdjkS1s+6StUmnASgR4XItV7r
         nnMXJav+TuYEuPNI1srTJ+HHpWB3NYnJiwHaY+wX4SxUzXVblYqLSPsKpDNQLYW6ndrs
         iGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741300749; x=1741905549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h+DEPeF6tUdrf5sYZTIAFqaj+xuuM1BUFzIBk9RHTI0=;
        b=BNMIpmVqDkHMgvOX8HdLQDvAnSBAHIq2Xl14iaMi1od9aD9K/SBOqmlFICLDQKfhrg
         J+P0uRWGk0fBwWg1YG+7xfGV63y/X3OdPJcA7MI3lLz6TD3OcChS6HSI8kKM01y2ahx2
         a31M/luEJNyZwdfZv05mk/lQkFQduhUYTtbZwDOEdX5UPzSf1nMLc48xubiQ3rtk6dyE
         T1tYQXQ8zWzSxbn99Ga/We/0yXH2nWGFfLPv7kL1rPa/Z0+WVnks8S8mO1btQsJyCiwR
         PRgJ3MyCKbdkm9iuHlfivA245c5VDom5HnjfHuupRF5Qbmd6bjSgchpn4MinxRidvN6W
         ARog==
X-Forwarded-Encrypted: i=1; AJvYcCV4AClYUNvguhU4Z6DCDd1maz1cxDESBmuDDNLc0z7te9nHHNr+RjF5yTokUCu/EwgPFHkZdGZ3iRXxQ1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv1//Tat17zmR4P6fuha6xQQ6SmVR3/Tqp0MrtcHDmpZ7VwRBT
	5JIBm5G1bCWYxQhCG+bFXyxBgWgGMUZEHXOsjSylJPddg9EPgswfk7xKeqc9l99X/y4tTyZMcDd
	+MK9SyBh6j7a0B5daCTWy0g0WhjqLHLk6o1knEA==
X-Gm-Gg: ASbGnct/ZKJwvdl6wb3OQiR1EdDpfQNCSCPR9v0atJcguT7Pz63cmtrXFYwEhCu1XHg
	4E/bORzzO5qCB3MTKD5BJbdUZox3cLSfD/kS5VCREBnOm5R8yrOrDfeJt0f1Gpkj+SuioY+4h4u
	iav19386YFpVrmTvWd6v0XTyQN5a+SG5UQ2u5UxY1ffCLMPcZZHcEKp+/IO/k=
X-Google-Smtp-Source: AGHT+IGXTvH+QOSG/rW5XS7z1aEK3pcaK2z1twmViFnZzxKB7GeXwBWo4+UDouBTG979vA3+Yhzz/ndkDjnQ6YGlo8g=
X-Received: by 2002:a17:903:1b63:b0:224:1005:7280 with SMTP id
 d9443c01a7336-22428bd57a2mr18397955ad.38.1741300749421; Thu, 06 Mar 2025
 14:39:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <90c171d5beed08bcf65ec2df6357a7ac97520b91.1741194399.git.lukas@wunner.de>
In-Reply-To: <90c171d5beed08bcf65ec2df6357a7ac97520b91.1741194399.git.lukas@wunner.de>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 6 Mar 2025 22:38:58 +0000
X-Gm-Features: AQ5f1JoJa6SipvivxSs9TwSia_gUcfciKY7Kxc9Vy9q0r_E9yeTQv3AQR3ZIAAY
Message-ID: <CALrw=nG-NP=XAUD3V5O44j3fbea0-zhKJM1tgOmwN8yyQMYu-g@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add Lukas & Ignat & Stefan for asymmetric keys
To: Lukas Wunner <lukas@wunner.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	David Howells <dhowells@redhat.com>, Stefan Berger <stefanb@linux.ibm.com>, 
	Tadeusz Struk <tstruk@gmail.com>, Tadeusz Struk <tstruk@gigaio.com>, Vitaly Chikunov <vt@altlinux.org>, 
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 5, 2025 at 5:16=E2=80=AFPM Lukas Wunner <lukas@wunner.de> wrote=
:
>
> Herbert asks for long-term maintenance of everything under
> crypto/asymmetric_keys/ and associated algorithms (ECDSA, GOST, RSA) [1].
>
> Ignat has kindly agreed to co-maintain this with me going forward.
>
> Stefan has agreed to be added as reviewer for ECDSA.  He introduced it
> in 2021 and has been meticulously providing reviews for 3rd party
> patches anyway.
>
> Retain David Howells' maintainer entry until he explicitly requests to
> be removed.  He originally introduced asymmetric keys in 2012.
>
> RSA was introduced by Tadeusz Struk as an employee of Intel in 2015,
> but he's changed jobs and last contributed to the implementation in 2016.
>
> GOST was introduced by Vitaly Chikunov as an employee of Basealt LLC [2]
> (=D0=91=D0=B0=D0=B7=D0=B0=D0=BB=D1=8C=D1=82 =D0=A1=D0=9F=D0=9E [3]) in 20=
19.  This company is an OFAC sanctioned entity
> [4][5], which makes employees ineligible as maintainer [6].  It's not
> clear if Vitaly is still working for Basealt, he did not immediately
> respond to my e-mail.  Since knowledge and use of GOST algorithms is
> relatively limited outside the Russian Federation, assign "Odd fixes"
> status for now.
>
> [1] https://lore.kernel.org/r/Z8QNJqQKhyyft_gz@gondor.apana.org.au/
> [2] https://prohoster.info/ru/blog/novosti-interneta/reliz-yadra-linux-5-=
2
> [3] https://www.basealt.ru/
> [4] https://ofac.treasury.gov/recent-actions/20240823
> [5] https://sanctionssearch.ofac.treas.gov/Details.aspx?id=3D50178
> [6] https://lore.kernel.org/r/7ee74c1b5b589619a13c6318c9fbd0d6ac7c334a.ca=
mel@HansenPartnership.com/
>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  MAINTAINERS | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8e0736d..b16a1cc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3595,14 +3595,42 @@ F:      drivers/hwmon/asus_wmi_sensors.c
>
>  ASYMMETRIC KEYS
>  M:     David Howells <dhowells@redhat.com>
> +M:     Lukas Wunner <lukas@wunner.de>
> +M:     Ignat Korchagin <ignat@cloudflare.com>
>  L:     keyrings@vger.kernel.org
> +L:     linux-crypto@vger.kernel.org
>  S:     Maintained
>  F:     Documentation/crypto/asymmetric-keys.rst
>  F:     crypto/asymmetric_keys/
>  F:     include/crypto/pkcs7.h
>  F:     include/crypto/public_key.h
> +F:     include/keys/asymmetric-*.h
>  F:     include/linux/verification.h
>
> +ASYMMETRIC KEYS - ECDSA
> +M:     Lukas Wunner <lukas@wunner.de>
> +M:     Ignat Korchagin <ignat@cloudflare.com>
> +R:     Stefan Berger <stefanb@linux.ibm.com>
> +L:     linux-crypto@vger.kernel.org
> +S:     Maintained
> +F:     crypto/ecc*
> +F:     crypto/ecdsa*
> +F:     include/crypto/ecc*
> +
> +ASYMMETRIC KEYS - GOST
> +M:     Lukas Wunner <lukas@wunner.de>
> +M:     Ignat Korchagin <ignat@cloudflare.com>
> +L:     linux-crypto@vger.kernel.org
> +S:     Odd fixes
> +F:     crypto/ecrdsa*
> +
> +ASYMMETRIC KEYS - RSA
> +M:     Lukas Wunner <lukas@wunner.de>
> +M:     Ignat Korchagin <ignat@cloudflare.com>
> +L:     linux-crypto@vger.kernel.org
> +S:     Maintained
> +F:     crypto/rsa*
> +
>  ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
>  R:     Dan Williams <dan.j.williams@intel.com>
>  S:     Odd fixes
> --
> 2.43.0
>

Acked-by: Ignat Korchagin <ignat@cloudflare.com>

Regards,
Ignat
