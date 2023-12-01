Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="K9gFhz8Q"
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA0713E
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 18:09:48 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5c632a97786so48066a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 18:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701396588; x=1702001388; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZARUzLOCPbgkdrEMse1VgYWmJt+Qe6ydA0SeWnrZFk4=;
        b=K9gFhz8QY0cvt1mt2tGSzYFp053wIkTePGGFlpUGikKYuPxdpO+ajWDIpFtBK/MDGv
         HQqoUtdtONom96jUqC3Sg3LyDKRrPC+E7VwOklnpr5p3GVZuZs+thXf1RU1Av1+vozwz
         EMahE4kwwUxf2YFHIVuLS//Vpax0NeDx6+8oAOSAtUfOhzWLbw8/1nEondWYBYw1BZk4
         WONFRBRZWhOgrT6cRLNFSwfumWyZt77ZRaSYGcxN+5Woj3qZgkTdXeZQQXnccmyS31ZR
         pxXhq1ZA32iRe3Bvrf/oJSWZvGhCPGTnUWQ5zEVxpoZPInw1DE9aogLTA+F7FufndDec
         mJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701396588; x=1702001388;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZARUzLOCPbgkdrEMse1VgYWmJt+Qe6ydA0SeWnrZFk4=;
        b=nEHOWEnEWOlpXyXVCPsBuEimz/oZ+8R6iVJo59SbGj0m2Jbh2r3QRwHZZRTrmzv0Z0
         d9LqUxhI/ETi82e7s5dD1ajJxkXe8ySGl9MujlPqZy+V7i6eGECicJnoQmF9/2RXRBJA
         hZsAwjosZr28moxZAZOpMS+cAIiClJqWUvknHGq9WuVE01Lazjzlqb8EtCdLOGxDhbtQ
         LLcUhJq74Bm6oviM9csESfXbGFqCCg1nORb42uRReIAfvG88c11jE4vXubTLNLL9mgv7
         4fElA3xEcrg9IDucrh5EynRYS0ak7U3PmOtI9uz4k7NwQsHCtqCKSzjGRKRjPr2c2Syj
         3l4g==
X-Gm-Message-State: AOJu0Ywj9YvzlUVYSJ4VnghSqSRiM5xsilLcf2nuRJu/tq0UPCD3fm7y
	NliueF5Il7Tli6t5bPhzCpI8kA==
X-Google-Smtp-Source: AGHT+IFrFltqEh9QH9Yno5D9numI3ZTsffVOt7/NhqriRU6xzwbOediCIeDoxAviM9Lpx+G4Hg5LGg==
X-Received: by 2002:a05:6a20:8409:b0:18b:8dfa:88e8 with SMTP id c9-20020a056a20840900b0018b8dfa88e8mr25889206pzd.43.1701396587726;
        Thu, 30 Nov 2023 18:09:47 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:83aa:9da8:481:b9cc:c515? ([2402:7500:4ce:83aa:9da8:481:b9cc:c515])
        by smtp.gmail.com with ESMTPSA id e12-20020a17090301cc00b001cc436e9806sm2092007plh.81.2023.11.30.18.09.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Nov 2023 18:09:47 -0800 (PST)
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
In-Reply-To: <20231128172204.GB1148@sol.localdomain>
Date: Fri, 1 Dec 2023 10:09:43 +0800
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 Albert Ou <aou@eecs.berkeley.edu>,
 herbert@gondor.apana.org.au,
 davem@davemloft.net,
 conor.dooley@microchip.com,
 ardb@kernel.org,
 heiko@sntech.de,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9F698DA6-51EB-4819-AE5C-1E6B145B4EF2@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-6-jerry.shih@sifive.com>
 <20231128035814.GH1463@sol.localdomain>
 <56F07E23-CA7D-466B-84C7-643F2839E199@sifive.com>
 <20231128172204.GB1148@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 29, 2023, at 01:22, Eric Biggers <ebiggers@kernel.org> wrote:
> On Tue, Nov 28, 2023 at 01:38:29PM +0800, Jerry Shih wrote:
>> On Nov 28, 2023, at 11:58, Eric Biggers <ebiggers@kernel.org> wrote:
>>> On Mon, Nov 27, 2023 at 03:06:55PM +0800, Jerry Shih wrote:
>>>> The `walksize` assignment is missed in simd skcipher.
>>>>=20
>>>> Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
>>>> ---
>>>> crypto/cryptd.c | 1 +
>>>> crypto/simd.c   | 1 +
>>>> 2 files changed, 2 insertions(+)
>>>>=20
>>>> diff --git a/crypto/cryptd.c b/crypto/cryptd.c
>>>> index bbcc368b6a55..253d13504ccb 100644
>>>> --- a/crypto/cryptd.c
>>>> +++ b/crypto/cryptd.c
>>>> @@ -405,6 +405,7 @@ static int cryptd_create_skcipher(struct =
crypto_template *tmpl,
>>>> 		(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
>>>> 	inst->alg.ivsize =3D crypto_skcipher_alg_ivsize(alg);
>>>> 	inst->alg.chunksize =3D crypto_skcipher_alg_chunksize(alg);
>>>> +	inst->alg.walksize =3D crypto_skcipher_alg_walksize(alg);
>>>> 	inst->alg.min_keysize =3D crypto_skcipher_alg_min_keysize(alg);
>>>> 	inst->alg.max_keysize =3D crypto_skcipher_alg_max_keysize(alg);
>>>>=20
>>>> diff --git a/crypto/simd.c b/crypto/simd.c
>>>> index edaa479a1ec5..ea0caabf90f1 100644
>>>> --- a/crypto/simd.c
>>>> +++ b/crypto/simd.c
>>>> @@ -181,6 +181,7 @@ struct simd_skcipher_alg =
*simd_skcipher_create_compat(const char *algname,
>>>>=20
>>>> 	alg->ivsize =3D ialg->ivsize;
>>>> 	alg->chunksize =3D ialg->chunksize;
>>>> +	alg->walksize =3D ialg->walksize;
>>>> 	alg->min_keysize =3D ialg->min_keysize;
>>>> 	alg->max_keysize =3D ialg->max_keysize;
>>>=20
>>> What are the consequences of this bug?  I wonder if it actually =
matters?  The
>>> "inner" algorithm is the one that actually gets used for the "walk", =
right?
>>>=20
>>> - Eric
>>=20
>> Without this, we might still use chunksize or cra_blocksize as the =
walksize
>> even though we setup with the larger walksize.
>>=20
>> Here is the code for the walksize default value:
>> 	static int skcipher_prepare_alg(struct skcipher_alg *alg)
>> 	{
>> 		...
>> 		if (!alg->chunksize)
>> 			alg->chunksize =3D base->cra_blocksize;
>> 		if (!alg->walksize)
>> 			alg->walksize =3D alg->chunksize;
>>=20
>> And we already have the bigger walksize for x86 aes-xts.
>> 		.base =3D {
>> 			.cra_name		=3D "__xts(aes)",
>> 			...
>> 		},
>> 		.walksize	=3D 2 * AES_BLOCK_SIZE,
>>=20
>> The x86 aes-xts only uses one `walk` to handle the tail elements. It =
assumes
>> that the walksize contains 2 aes blocks. If walksize is not set =
correctly, maybe
>> some tail elements is not processed in simd-cipher mode for x86 =
aes-xts.
>=20
> With the SIMD helper there are three "algorithms": the underlying =
algorithm, the
> cryptd algorithm, and the simd algorithm.  This patch makes the =
"walksize"
> property be propagated from the underlying algorithm to the cryptd and =
simd
> algorithms.  I don't see how that actually makes a difference, since =
the only
> place the skcipher_walk happens is on the underlying algorithm.  So it =
uses the
> "walksize" from the underlying algorithm, right?
>=20
> - Eric

Yes, you are right.
I re-check the cryptd and simd cipher flow. They use the underlying =
algorithms.
So, the actual `walksize` in the underlying algorithm is set by the user =
in
skcipher_alg def.
The x86 aes-xts works correctly for both cryptd and simd-cipher case.

This patch becomes fixing the `walksize` display error in =
`/proc/crypto`.

The aes-xts skcipher_alg def:
	...
	.ivsize =3D AES_BLOCK_SIZE,
	.chunksize =3D AES_BLOCK_SIZE,
	.walksize =3D AES_BLOCK_SIZE * 8,
	.base =3D {
		.cra_flags =3D CRYPTO_ALG_INTERNAL,
		.cra_name =3D "__xts(aes)",
		.cra_driver_name =3D =
"__xts-aes-riscv64-zvkned-zvbb-zvkg",
		...
	},


Without patch:=09
The original skcipher:
	name         : __xts(aes)
	driver       : __xts-aes-riscv64-zvkned-zvbb-zvkg
	internal     : yes
	async        : no
	...
	walksize     : 128

The async skcipher registered by simd_register_skciphers_compat:
	name         : xts(aes)
	driver       : xts-aes-riscv64-zvkned-zvbb-zvkg
	internal     : no
	async        : yes
	...
	walksize     : 16

	...
	name         : __xts(aes)
	driver       : cryptd(__xts-aes-riscv64-zvkned-zvbb-zvkg)
	internal     : yes
	async        : yes
	...
	walksize     : 16

With patch:
	name         : xts(aes)
	driver       : xts-aes-riscv64-zvkned-zvbb-zvkg
	internal     : no
	async        : yes
	...
	walksize     : 128

	...
	name         : __xts(aes)
	driver       : cryptd(__xts-aes-riscv64-zvkned-zvbb-zvkg)
	internal     : yes
	async        : yes
	...
	walksize     : 128

