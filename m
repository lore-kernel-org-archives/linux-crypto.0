Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="nbfwNWSo"
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06732C4
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 21:38:35 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3b2e330033fso3191957b6e.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 21:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701149914; x=1701754714; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+3smZGD6pLNRGkaXwEXKVlmQX+QFLadDCcT3fwIXSsw=;
        b=nbfwNWSoboTplLxvdYf114aUHYh0v2VFFkU+CLo3nXdQxi6lL2B3xq/q1CixUJyN4i
         I8Ix2Uem4kIFVGyW/zVshhU1DO3z0TurBLEsWa2/+bivLKz9Te8uPiVqDvA/A1wsJTPn
         uuG+2PzXKNsx2JhxxSDizCl5umvE2fNaCrNLGLih0mOqJhmDifeQUK9+FpoRWRQOlU1F
         ltfkVTp00e4X0tCgxVgHDR/v1LHw40FJEGNCu/vAwV23UtFwTvCnK0s00Qlh7ebVTm/u
         s39uMjAdUAOj9y1U+pwSIaWqtcDDSfz2z6w3uCYXo/1+OFdj85qGmjnNeWWozfrMmwnx
         Gcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701149914; x=1701754714;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+3smZGD6pLNRGkaXwEXKVlmQX+QFLadDCcT3fwIXSsw=;
        b=qB56upXj4b9Ig7BeneRCftr2/jy6b2RaUWWbGAgvLvQTa3ktgmajjWm5ZWgScKFgnb
         +xoRerBxNevAcxtuiEBMo77VKOtD+DdnqRdUsJarGadvD/fyh7fj+AGHUi61pL8cnaOu
         UOlb+bmqbl1Pl4nm0AuZSDp8D8DnvoDrBGmC/8HEb+5CoYhyzD8tbRzW6HkqyIgadxy1
         JLvs42yh5HEkf5WzZ11A9FXt/vp3dPASXEIueEty/BIsBowIJiVBpZOUl+qHGmA3vh/H
         7m50fDKPt6O3sF/OR7ql9PKes0l4wK2VLWyC6m1wgVhIfDGj8yew4Ya8gQI9pDVuxB1u
         ofzg==
X-Gm-Message-State: AOJu0YwduLbXQrByqvxTvzie93PjVDTY3CM5SNTpBmMZAIHkX2HZI0D9
	pVYxCc5kFSHIe0ViHdBvLqFCjw==
X-Google-Smtp-Source: AGHT+IEwY+qDOH5RdVmpp3afIODK9OZ2MAKzfbsV5gxBTlRaiFetM3EKZhzvR/gD6Q8ZvgHWcrukkA==
X-Received: by 2002:a05:6808:1901:b0:3ae:5e0e:1671 with SMTP id bf1-20020a056808190100b003ae5e0e1671mr20436537oib.4.1701149914332;
        Mon, 27 Nov 2023 21:38:34 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:8338:14c0:b892:2482:e230? ([2402:7500:4ce:8338:14c0:b892:2482:e230])
        by smtp.gmail.com with ESMTPSA id r10-20020aa78b8a000000b006cbb3512266sm8087953pfd.1.2023.11.27.21.38.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Nov 2023 21:38:33 -0800 (PST)
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
In-Reply-To: <20231128035814.GH1463@sol.localdomain>
Date: Tue, 28 Nov 2023 13:38:29 +0800
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
Message-Id: <56F07E23-CA7D-466B-84C7-643F2839E199@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-6-jerry.shih@sifive.com>
 <20231128035814.GH1463@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 28, 2023, at 11:58, Eric Biggers <ebiggers@kernel.org> wrote:
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
>>=20
>> diff --git a/crypto/simd.c b/crypto/simd.c
>> index edaa479a1ec5..ea0caabf90f1 100644
>> --- a/crypto/simd.c
>> +++ b/crypto/simd.c
>> @@ -181,6 +181,7 @@ struct simd_skcipher_alg =
*simd_skcipher_create_compat(const char *algname,
>>=20
>> 	alg->ivsize =3D ialg->ivsize;
>> 	alg->chunksize =3D ialg->chunksize;
>> +	alg->walksize =3D ialg->walksize;
>> 	alg->min_keysize =3D ialg->min_keysize;
>> 	alg->max_keysize =3D ialg->max_keysize;
>=20
> What are the consequences of this bug?  I wonder if it actually =
matters?  The
> "inner" algorithm is the one that actually gets used for the "walk", =
right?
>=20
> - Eric

Without this, we might still use chunksize or cra_blocksize as the =
walksize
even though we setup with the larger walksize.

Here is the code for the walksize default value:
	static int skcipher_prepare_alg(struct skcipher_alg *alg)
	{
		...
		if (!alg->chunksize)
			alg->chunksize =3D base->cra_blocksize;
		if (!alg->walksize)
			alg->walksize =3D alg->chunksize;

And we already have the bigger walksize for x86 aes-xts.
		.base =3D {
			.cra_name		=3D "__xts(aes)",
			...
		},
		.walksize	=3D 2 * AES_BLOCK_SIZE,

The x86 aes-xts only uses one `walk` to handle the tail elements. It =
assumes
that the walksize contains 2 aes blocks. If walksize is not set =
correctly, maybe
some tail elements is not processed in simd-cipher mode for x86 aes-xts.

-Jerry=
