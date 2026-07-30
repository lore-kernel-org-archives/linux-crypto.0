Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688363346A6
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 07:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397170; cv=none; b=emnN3lm24dpeKfHn8xlQUptpFINC6IKUZGSOOyBpqOX0le+z4o350hXGd96DW44wlyJPfU0OHkgAAzDXJ/UbArVCSUCnNvhBoy06sLxC8tCXHO/F3PNmJoFgipvCm/jfEFpIxw9GrDRgchxQhX6Oc0htafJL//mjOfb0y/8PwD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397170; c=relaxed/simple;
	bh=GzQ8tZkjY4CG3k8HhUv41Mz9Jbkz1YGcTaTDIUR4nMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jtw/eqbxlq6AM5DZoZdBdz31iWDeMm1s3LkIX0eUcF3MSLvVwfH9LLQgex+B5R0nZCth9LNJ/+lo1vwbV8AA0kN0v7qhCBhrDL2+uXQMG9yu5XiwgTOlbbihWHO52dILWpIAvlRqLTWvjhqvJ/RQzDcxLFs7AGgPX1m5zY17hPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=WFmcdVXt; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="WFmcdVXt"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47f9ab7ee38so1095906f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 00:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1785397166; x=1786001966; darn=vger.kernel.org;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GzQ8tZkjY4CG3k8HhUv41Mz9Jbkz1YGcTaTDIUR4nMg=;
        b=WFmcdVXtregZZMflf8bSm7x7semhuEZodWOJ+P/4dvH3jtXXZmj0T4UeXSHJSNJebO
         aat7iHGZX1JWTuOWeiJEfd4XlNGSl4/z9WSGXlEx/piot9Sxh3JAZHNHVPl9LneuxHH2
         bdwzvNxWS2lLDggBx8r112QvYbA5P/rl0ATta2TCxWm9849CIW+JdUORbLRxpfJIHKrl
         GWKCPeJeGxV+I3UQx2rgaq48YUJqFAQHssHyczPY5iOcPJjqRuHPiX3TVKuZFfYQB0uR
         iIryfYTBJOBTI50xxgri1PXuDT2jEtaS/UNyvNHDcUoqguKZ+JcySgC0S7tMiI4ihX4G
         zqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785397166; x=1786001966;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GzQ8tZkjY4CG3k8HhUv41Mz9Jbkz1YGcTaTDIUR4nMg=;
        b=coEtj6RCiIL/6LVLB7WGIuDK4uU/gm2fwdOe4zXBZjZKXlPbb6OcGSGidwY2a1/qcn
         tZY1+ekyu0+/WfSL/ACopU8c4gI2ILyRrszW48DJFpYwqRWJWMVRk9R7DkyKdRCiIWRY
         /cJRdF2KX0HcjKKnb4PEYAeLnHoyn+XQCtGM10q7VBMUDzD0Oo7luVU5jBUs08eTbMFu
         PMOqp+/Ddrj4jyZ6Y4PO6zmJ8i8Ys4vQvpSSHkE0B64v9W8sUNgVp2Ajcp29hVdvWhOC
         SL2w8OXzsZhq9M277WAv+D8zPqzL4/mlPg6zF55OG+GEmMe0cpnPByB2ClmRqJ4uBZfb
         RI+w==
X-Forwarded-Encrypted: i=1; AHgh+Ros7qfRNMZtqFPSdrIjfeWcNajZgFfvbY+AdQ0gRmRvPBTJt2b5C/QniQTM5n44/9afxv7MvltdedmkRuo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLCFgoaSzRrkR6D9bOEIuP7l2LkRl0tAKxM2jjkXsMLOKa/+Tz
	rXV5oKywuUseMp9QDm1Kw5+q+NPh9igSHVLENK3xJQJsf8hArNvmh8iFd23xJWSkGoo=
X-Gm-Gg: AR+sD127PGin4ku7AdDKORw1bTnvl6VNU+ANpUyBlVKxojVt60lQ+pykr6z/GH0yF++
	O0Yq2oqF1999DzBDdgd55H/I6D0RWDXBpEZUS59A77JsBvJ8Td8xGAzWS3YQcyLislCv8eFSu0Q
	muK2JkbnUBaiPHiDnRYBtvAuGr2tKYZFD/GHY4g4P6F6J8ZFXILcCse7sx4jFYxF6rAbnMG26k9
	HRNw2SP5A4CQb2sJ3qPHvNcjwUIOeFVLVaaKXf+EuY24NKHTGh895EwreJ13R6YAW1qms206o5K
	Gm5Ovm/GYm2GLlWeh9MyOGaHEw4DvWzA0hf49z5aTU5C3LS6A/XE3uDvlh8a3UXNzkwO9KU1trn
	lgxmxPoh5k8lPpqa2F5zp9VsrclnHdyW6qepoxcJUCRXFqrHy15bCH4l8lDaKyO69XYDe1d4ddt
	E46qiQ0uWzzM1Q6CrfaEd3kBzaFjxmxV3zNwbvcidB8krzwo/xoa25ZNN+HQ4zFg==
X-Received: by 2002:a05:6000:2910:b0:474:530:9d with SMTP id ffacd0b85a97d-47fc81f5604mr2040628f8f.13.1785397166389;
        Thu, 30 Jul 2026 00:39:26 -0700 (PDT)
Received: from somecomputer ([82.150.214.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc893fe58sm6278715f8f.31.2026.07.30.00.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 00:39:25 -0700 (PDT)
From: Richard Weinberger <richard@sigma-star.at>
To: Richard Weinberger <richard@nod.at>, upstream@sigma-star.at
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 demiobenour@gmail.com, davem@davemloft.net, ebiggers@kernel.org,
 upstream+linux@sigma-star.at, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: af_alg: Allow cbc(paes)
Date: Thu, 30 Jul 2026 09:39:24 +0200
Message-ID: <5372653.jyWNHgNrjM@nailgun>
In-Reply-To: <amr_LZMjwUCl_QpH@gondor.apana.org.au>
References:
 <20260726192716.2351505-1-richard@nod.at>
 <amr_LZMjwUCl_QpH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Donnerstag, 30. Juli 2026 09:37 'Herbert Xu' via upstream wrote:
> This does not apply against cryptodev.

This is not material for next/7.3, this is for the current release cycle.

Thanks,
//richard

=2D-=20
=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8Bsigma star gmbh | Eduard-Bodem=
=2DGasse 6, 6020 Innsbruck, AUT UID/VAT Nr:
ATU 66964118 | FN: 374287y


