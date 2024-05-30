Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D306418398B;
	Thu, 30 May 2024 10:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717065053; cv=none; b=ZKTfrQiujNOG9VRlpbZMjZyiGdPLeI3VldJkSDv91L+iYiTQaJMZdMYa++kSAPW24D86EGT1XuuRUuW2RJ/KM8dKK0wGPYvmCmby4S/WY07mCaJybZpIsB/lMQi7t0kosrEa8ybdcD96OMsMDKgkM+gtT1Mkr2jEnspNjPhrAZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717065053; c=relaxed/simple;
	bh=rW4jn5kjmnKzA8brQFRHHBZw4D5yx8NGw16n6wCqrGU=;
	h=Content-Type:Mime-Version:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=NclMG8Y2nvQ//Musm5QAYxzRpdF8qjMJfH+90HQsNimZCOObaTQsK479PmixF0vQ3WFwaVSBZBTmhQ3nMNZfE0d6D9392taKGoy0jzEru7xfvZIypKCNFsEJ39zhe6YqmUG4lGujTFD/wYPFkaeEl3R1uR2cAWHPc20iI3rMMF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=loNMSFjk; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="loNMSFjk"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52b7db60003so759367e87.3;
        Thu, 30 May 2024 03:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717065050; x=1717669850; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rW4jn5kjmnKzA8brQFRHHBZw4D5yx8NGw16n6wCqrGU=;
        b=loNMSFjkZF6+s4qu62M9Ag/5cYjYiadzZGyYNULUjURD864pP3vGjgJBhXQyluj/0X
         G4NSc7vO0/GG6WhTsFIpqMriGl/13aX/23BQcqTiu0jAYqpgjlcSy5Qh8TEtLzGRnUGX
         /b0j8id+GBMSinknqYa6gaHfniWFfo5x3GzpvFP5k7Hm3w0XXcp5+0OXq+s0cM8NgSIC
         k1UfSau73wyL0VEVOvgdW+Z9rvQWWLieSzS+Cx7LUYYm7+gCscTc9ZI05v8fViIjvmqw
         9itxV6ABBqftZw4p9PQH29nRv9QOnLo9VlsbeOtPWI6e0OQ1BhL6U1V8gP+7NhE3hm+g
         7UfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717065050; x=1717669850;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rW4jn5kjmnKzA8brQFRHHBZw4D5yx8NGw16n6wCqrGU=;
        b=kFoSHz1SNszHOFYBOEFy5NcvNpHqsLPZXcLDvAjPBaVC6ofmYsyYKTEL1iAeTSBXBW
         IM1/WESY5gT6K29ygGgDH94JuJQusFrQad+D0kY1ISrGoQOScnPOUOoCoGLRYXmK7SSZ
         TAYyWuaeUZJrJs5yZD7oEzED231CK3ETdy65hclMDDmUG9N7jZJhDsOdMyw5t3qqy7AX
         Ab4Cb80vEseSBbHTeDLRnS8rm5eMFQ09uCq9LQXM5gbuq71Y2hXr2z/EA4v6LK5/xjJZ
         VJoh+8GZVD4fVHctdIlpoFfsFOw6996zdzU8DreQdVf4N2sV5GOFigaUAmPWj01tu3qQ
         1tlg==
X-Forwarded-Encrypted: i=1; AJvYcCVs6xKwNA7LMNyt9AOWMs5MQhyDH20PJFq2w+qv80KNTUIghwFDDBs9x9GXppdavXI3dYftagOcvQIb/V1Ob/PgkavknyYtf86trcrGAi9TToS9DZnpc+Wxm2az1lgO3nzVnQpmOqiyOBbCb05jObNB8CdwLr2UgFYnKn41Qu5AMFynOrYfgwDb85Q=
X-Gm-Message-State: AOJu0Yyjv9xVixhD+QT1E3XQqhG5x9Sdm1R68oVJpsg8ZYmWccTsr4kF
	K+S83ULEeBp4EFs/9z6z87yxOIQO6T/qTVmLCo0MHIQje8nRVkU3
X-Google-Smtp-Source: AGHT+IHbw+XCiEGggxSdTfjisZtE+HV13QFVVvVE1JOXajiAK7lcEZsKf7DsU6pcJz0lHgDK1vPEQQ==
X-Received: by 2002:ac2:43a1:0:b0:51c:d05b:6b8d with SMTP id 2adb3069b0e04-52b7d4263b2mr1846653e87.23.1717065049710;
        Thu, 30 May 2024 03:30:49 -0700 (PDT)
Received: from localhost (p200300e41f162000f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f16:2000:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5296f410fc1sm1502371e87.117.2024.05.30.03.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 03:30:49 -0700 (PDT)
Content-Type: multipart/signed;
 boundary=432b71ef613f91233681e8ff6b308ab1f6a32c4fb336c68c48fb0ae1b4d1;
 micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Thu, 30 May 2024 12:30:48 +0200
Message-Id: <D1MWRDJ06QSQ.5HMWERLERPLY@gmail.com>
To: "Akhil R" <akhilrajeev@nvidia.com>, "Christophe JAILLET"
 <christophe.jaillet@wanadoo.fr>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 "Jon Hunter" <jonathanh@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
 call in tegra_se_remove()
From: "Thierry Reding" <thierry.reding@gmail.com>
X-Mailer: aerc 0.16.0-1-0-g560d6168f0ed-dirty
References: <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr> <SJ1PR12MB633943D654272A0612695F1DC0F22@SJ1PR12MB6339.namprd12.prod.outlook.com>
In-Reply-To: <SJ1PR12MB633943D654272A0612695F1DC0F22@SJ1PR12MB6339.namprd12.prod.outlook.com>

--432b71ef613f91233681e8ff6b308ab1f6a32c4fb336c68c48fb0ae1b4d1
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Wed May 29, 2024 at 8:53 AM CEST, Akhil R wrote:
> > The only iommu function call in this driver is a
> > tegra_dev_iommu_get_stream_id() which does not allocate anything and do=
es
> > not take any reference.
> >=20
> > More-over, what is freed is "se->dev" which has been devm_kzalloc()'ed =
in the
> > probe.
>
> I did not completely understand what is being tried to convey here.
> If I understand it right, iommu_fwspec_free() does not do anything
> with the "devm_kzalloc"ed variable.=20
>
> It would probably be a good idea to remove this line from the commit mess=
age.

Yeah, I think that's a bit misleading. What iommu_fwspec_free() does is
get the iommu_fwspec from the passed-in device and then frees that
iommu_fwspec.

That said, as I was looking around I didn't spot anything that was
calling iommu_fwspec_free() in any of the cleanup paths, so either I'm
missing something or it's a real memory leak (though perhaps one that we
are ignoring on purpose because these are usually attached to devices
that don't just go away).

Thierry

--432b71ef613f91233681e8ff6b308ab1f6a32c4fb336c68c48fb0ae1b4d1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmZYVVgACgkQ3SOs138+
s6E2HxAAuli1khZJ9nZCFGOj9+lAW2lbumnnvQ85exAHuhwyA6rr/bsLI5sQbQ/K
Km/xVh28quZkpsmwx+q1LmLrHg9FVbX18QvRtZc7qQeWcV32dTJXOZ4KnAQJdQGL
Jn7mlbh850HJrGZsFv529irOZupkSF1fwJl4rb4iEMdlZPIgC/LjSzSrZ/MZkfLN
dQChxDuNs/d7CXIASvzamq6pZiHJ4iNG1e1fqZZw3Nl10gGKwFWYeEjryYrY6hsx
Niw+oP7cicqmfciR+eQQ67KZj8o0J0c1JcxXCeXSBhxbSakVrcXqNAYNFEGhvtXu
1Slk/zgjmbrXdd1jgx+U0+95GjcCDq9DABmKVsv3ilzrMqDWAL8jVHhtI9rqbPA1
IxUgAqhNkadrb7wPqHrlqu8c3qwRupvMnCT5Eda6Nxr6BFwfNqnsj42zTDIIBoVl
ammjk4uxt0HEqrHzrueowXN/rrgNKVIZQjbBKVglE78WidJbGON3MfT5W68wO0Vv
TRzajZn9fhs6TUc6/AKqgmIeD1CeuNEmCWUGtsZm6JuNh71OQNVS9/5BYEFOC8oJ
M2/knQPUleCk6GKhsSIGVd2bRfzWZJsWPciTSLJoMI4jb0hSh7xlKYI8bYDD0j0R
bCkE4jndIqvW/GT82ewQ0mU+4d8t1pBvPrIIubrxKiZdSnSwDZI=
=DssT
-----END PGP SIGNATURE-----

--432b71ef613f91233681e8ff6b308ab1f6a32c4fb336c68c48fb0ae1b4d1--
