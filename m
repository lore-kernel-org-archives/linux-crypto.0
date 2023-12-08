Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="UMJjJUs5"
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00579171C
	for <linux-crypto@vger.kernel.org>; Thu,  7 Dec 2023 20:18:44 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5c664652339so1314650a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 07 Dec 2023 20:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1702009124; x=1702613924; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R5Tnty8uGnrsIVXtmr+TvgEkcR6UqhS9WZGqa9cLAzU=;
        b=UMJjJUs5zN4ZD9xrC8PvcPqrsXHoXvrBCm4jrddzgnKeFOmXi9ivbn+7ldA6gJ/SnU
         Tmfk0jzvEC44Su9lU/j+abLVxsgbV6UXvp9suAW1Fjnru8ET/ztmZ/iR4sz4pW+PguXm
         if2Aj27cDUn8YINGO1UHpCwfhPls8XXDLvn0aR+dWo6diTYnEYKKxKHwfwwNAGWdCPkr
         oqpWQa4NSQ0cfO+0H1JjcXdP8oTY729u0otwFDKYI+wWjqK2CbYFjbtq5/Uhx1+NvbsF
         Nm71oELv6uKInx6I+WQq10JLmuNcgz2qbGzr2BxmaqW8J1JX6np67Z8Ysg6kJ+0+ZhsD
         TbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702009124; x=1702613924;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R5Tnty8uGnrsIVXtmr+TvgEkcR6UqhS9WZGqa9cLAzU=;
        b=mH9X5uZQv0nyNh/pNkFfCGNOdqyiohrQZJIABV7MW6dIzNO6MOXvKN0QoCQ+HpXelL
         psvRROqezvpE0o90w9/BD4RnqGn4SPWJmwS26hWqLhlG7pX4Y3GdVhJQV5xv4Owrd6X3
         QT6BACu6q1H7k8anc5qBbOb6O9nzFgHcpBxmnp/onF5c4IeTMCUdf7o0lWuXHuHPgBwj
         KT8vNz5jamVIFnElB8ELX2fJJaROWd2hbFwV75Q0rYF3XTzDk0WbiVCOL59qY9FgKUBz
         dMnk6NTDyj8Av2ijpgmDiILcFQUghOR+TT5HPcTGkuK7qj0acenGc6ZeVX4u0g7pzhdw
         sYpQ==
X-Gm-Message-State: AOJu0YxwGobd+Zi2ZWGZX5V6O8tytFbeUKq8IgD2TvE1qXxzEzicBLpk
	oGKNidiVJMlIwmMARaJytFqPJw==
X-Google-Smtp-Source: AGHT+IFp9iNb7QqJ7wb16q4wxd1kROAdjldRBrd9Y5SAmktLgQrezvI5AuaKkgiGqBj1DHg2d5+eYA==
X-Received: by 2002:a17:90b:3b44:b0:286:815b:8c75 with SMTP id ot4-20020a17090b3b4400b00286815b8c75mr3090891pjb.16.1702009124417;
        Thu, 07 Dec 2023 20:18:44 -0800 (PST)
Received: from ?IPv6:2402:7500:4d5:3ce7:e047:b0e5:91bf:940? ([2402:7500:4d5:3ce7:e047:b0e5:91bf:940])
        by smtp.gmail.com with ESMTPSA id dw8-20020a17090b094800b0028862dc530bsm2235275pjb.25.2023.12.07.20.18.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Dec 2023 20:18:44 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v2 05/13] crypto: simd - Update `walksize` in simd
 skcipher
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <ZXKV/nLAQpUx6AX0@gondor.apana.org.au>
Date: Fri, 8 Dec 2023 12:18:39 +0800
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 aou@eecs.berkeley.edu,
 davem@davemloft.net,
 conor.dooley@microchip.com,
 ebiggers@kernel.org,
 ardb@kernel.org,
 heiko@sntech.de,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5684F139-A0DE-4A9A-B937-9DF5130E5BD7@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-6-jerry.shih@sifive.com>
 <ZXKV/nLAQpUx6AX0@gondor.apana.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
X-Mailer: Apple Mail (2.3445.9.7)

On Dec 8, 2023, at 12:05, Herbert Xu <herbert@gondor.apana.org.au> =
wrote:
> On Mon, Nov 27, 2023 at 03:06:55PM +0800, Jerry Shih wrote:
>> The `walksize` assignment is missed in simd skcipher.
>>=20
>> Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
>> ---
>> crypto/cryptd.c | 1 +
>> crypto/simd.c   | 1 +
>> 2 files changed, 2 insertions(+)
>>=20
>> diff --git a/crypto/cryptd.c b/crypto/cryptd.c
>> index bbcc368b6a55..253d13504ccb 100644
>> --- a/crypto/cryptd.c
>> +++ b/crypto/cryptd.c
>> @@ -405,6 +405,7 @@ static int cryptd_create_skcipher(struct =
crypto_template *tmpl,
>> 		(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
>> 	inst->alg.ivsize =3D crypto_skcipher_alg_ivsize(alg);
>> 	inst->alg.chunksize =3D crypto_skcipher_alg_chunksize(alg);
>> +	inst->alg.walksize =3D crypto_skcipher_alg_walksize(alg);
>> 	inst->alg.min_keysize =3D crypto_skcipher_alg_min_keysize(alg);
>> 	inst->alg.max_keysize =3D crypto_skcipher_alg_max_keysize(alg);
>=20
> Sorry but this patch doesn't apply any more now that we have
> lskcipher.

The lskcipher is merged in kernel `6.7`. I will rebase the v3 series to =
`6.7` later.
Link: =
https://lore.kernel.org/all/20231205092801.1335-1-jerry.shih@sifive.com/

Some dependent patches are not applicable to `6.7` now. I will check the =
status for the
dependent patches.

-Jerry=
