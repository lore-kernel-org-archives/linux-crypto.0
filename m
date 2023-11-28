Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Hy07jg0M"
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA1B1AE
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 20:22:32 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-2839b418f7fso3919546a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 20:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701145352; x=1701750152; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgMs+FA2uRdRydo7QTTHxfVxYoJ/VeG+Rds1RS5XwD8=;
        b=Hy07jg0MuqnwNm4DA0cu4x/ElnfhbU7e/LQMQu1j4EHx18FAnCCB2L9oTvhfegZAnU
         Ai1bHebbmbMDlUTfED53lkCoT5BDlYlYpmhi7XWYKBm0KDk5PGRNlgiCMVpomEf2xWcS
         prlldTU+IHVZvxG/UG8EJmO4hppsKYEcvYXyul0ThdiSq8fjgMfJVIUkbxVdqBpbvL1O
         psnc7u3jKLMe5J5aGHF6IyG0wrONPvb+0WL3HfHoD510tKHEBNuzbl82ASNn4grryNp4
         y5uyKpiRR/Ic62yjQpYZH4+3bGAQiM8JfeotD3SLwAa353SPgwCIjzasdYRsopvNH7KH
         qvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701145352; x=1701750152;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgMs+FA2uRdRydo7QTTHxfVxYoJ/VeG+Rds1RS5XwD8=;
        b=br0Rf+wJRTbepwaVnrMpM7IQsCz6WxaQSMFSlnNDIKjRnvVvzDz1LC8ThV5gSgBEEB
         6Bhc18nurUDjdjitRenoWuSYan5ZE0wJdFmv7g3MMhOw3bCKZaGx6OukVYT5OwH/deyQ
         CMsE3vk2hDZiirtK/bCVZivkGTkqybehKHuhjLYJchLhrwogff1nN+IiCGDbLv63BuEJ
         fex+P4XcMmnoTqGvm+9DsdHfS1qbZ0XU0PErYWsNnxbAQyyrmXYCJhb46TgFMsbzN81t
         AXKThYNngKl/UDaPNHGJAwLmMF/HPhgRuTHLzU3F75mH6huO2RpkQN40a3eMl6bDmd/U
         +Z9g==
X-Gm-Message-State: AOJu0YxO6oEwqMwL+55RkaNm2/d6rYoke6nmaoqLqkXSCVq8BMGIuOQW
	c2xHTJEEcmFZhfIcgl6v2exERCbwCLvECNzzi5w=
X-Google-Smtp-Source: AGHT+IHHG3HHcqIdeyqhTum97P/I46I9Hh5VumkUxPbdNd8VW8kcRCxRWILwSKP5Mcr6OJhpTLtfqQ==
X-Received: by 2002:a17:90a:190e:b0:285:8cb1:7f53 with SMTP id 14-20020a17090a190e00b002858cb17f53mr12960246pjg.31.1701145352037;
        Mon, 27 Nov 2023 20:22:32 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:8338:14c0:b892:2482:e230? ([2402:7500:4ce:8338:14c0:b892:2482:e230])
        by smtp.gmail.com with ESMTPSA id pm18-20020a17090b3c5200b00285e53d90cesm1567515pjb.26.2023.11.27.20.22.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Nov 2023 20:22:31 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v2 04/13] RISC-V: crypto: add Zvkned accelerated AES
 implementation
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231128035630.GG1463@sol.localdomain>
Date: Tue, 28 Nov 2023 12:22:26 +0800
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
Message-Id: <8BE5BD19-7401-455D-838B-56264F78471B@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-5-jerry.shih@sifive.com>
 <20231128035630.GG1463@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 28, 2023, at 11:56, Eric Biggers <ebiggers@kernel.org> wrote:
> On Mon, Nov 27, 2023 at 03:06:54PM +0800, Jerry Shih wrote:
>> +int riscv64_aes_setkey(struct crypto_aes_ctx *ctx, const u8 *key,
>> +		       unsigned int keylen)
>> +{
>> +	int ret;
>> +
>> +	ret =3D aes_check_keylen(keylen);
>> +	if (ret < 0)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * The RISC-V AES vector crypto key expanding doesn't support =
AES-192.
>> +	 * Use the generic software key expanding for that case.
>> +	 */
>> +	if ((keylen =3D=3D 16 || keylen =3D=3D 32) && =
crypto_simd_usable()) {
>> +		/*
>> +		 * All zvkned-based functions use encryption expanding =
keys for both
>> +		 * encryption and decryption.
>> +		 */
>> +		kernel_vector_begin();
>> +		rv64i_zvkned_set_encrypt_key(key, keylen, ctx);
>> +		kernel_vector_end();
>> +	} else {
>> +		ret =3D aes_expandkey(ctx, key, keylen);
>> +	}
>=20
> rv64i_zvkned_set_encrypt_key() does not initialize =
crypto_aes_ctx::key_dec.
> So, decryption results will be incorrect if !crypto_simd_usable() =
later.

Will we have the situation that `crypto_simd_usable()` condition is not =
consistent
during the aes_setkey(), aes_enc/dec()? If yes, all accelerated(or HW =
specific)
crypto algorithms should do the same implementations as the sw fallback =
path
since the `crypto_simd_usable()` will change back and forth.

>> +static int aes_setkey(struct crypto_tfm *tfm, const u8 *key,
>> +		      unsigned int keylen)
>=20
> It's best to avoid generic-sounding function names like this that =
could collide
> with functions in crypto/ or lib/crypto/.  A better name for this =
function, for
> example, would be aes_setkey_zvkned().

Thx, I will fix that.

>> diff --git a/arch/riscv/crypto/aes-riscv64-zvkned.pl =
b/arch/riscv/crypto/aes-riscv64-zvkned.pl
>> new file mode 100644
>> index 000000000000..303e82d9f6f0
>> --- /dev/null
>> +++ b/arch/riscv/crypto/aes-riscv64-zvkned.pl
> [...]
>> +L_enc_128:
> [...]
>> +L_enc_192:
> [...]
>> +L_enc_256:
>=20
> There's some severe source code duplication going on in the AES =
assembly, with
> the three AES variants having separate source code.  You can just =
leave this
> as-is since this is what was merged into OpenSSL and we are borrowing =
that for
> now, but I do expect that we'll want to clean this up later.

Do we prefer the code with the branches instead of the specified =
implementation?
We could make AES-128/192/256 together like:

    @{[vaesz_vs $V24, $V1]}
    @{[vaesem_vs $V24, $V2]}
    @{[vaesem_vs $V24, $V3]}
    @{[vaesem_vs $V24, $V4]}
    @{[vaesem_vs $V24, $V5]}
    @{[vaesem_vs $V24, $V6]}
    @{[vaesem_vs $V24, $V7]}
    @{[vaesem_vs $V24, $V8]}
    @{[vaesem_vs $V24, $V9]}
    @{[vaesem_vs $V24, $V10]}
    beq $ROUND, $ROUND_11, 1f
    @{[vaesem_vs $V24, $V11]}
    @{[vaesem_vs $V24, $V12]}
    beq $ROUND, $ROUND_13, 1f
    @{[vaesem_vs $V24, $V13]}
    @{[vaesem_vs $V24, $V14]}
1:
    @{[vaesef_vs $V24, $V15]}

But we will have the additional costs for the branches.

> - Eric



