Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="VnvqGzM1"
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D2A10E4
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 23:16:58 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-58d533268e6so1705417eaf.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 23:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701155818; x=1701760618; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hGy46pUf93WoDJ7rnnE2nED/iyelB1yhgDX8ASNQ7E=;
        b=VnvqGzM1DoJNEubPnROwF86hlxKEiEWVfnKtU35EpW3SwaDsQl00Vg4Q+3ei3FLYQL
         0IxC9bwYlWUizFMOJLbamv7xSQHZsJId4jdCNCSBrS2+nmRZ6EmiQxMDtxNB2mZ4w0kG
         CGKK+qbBS2n6W5CN1sfXbfK1Zc2Ew/UrEw536CDfeVOY/C5SxTnYDfWGnv/BHju8hzBJ
         H7qzYo3ZaDvnjhksHFSyBTx3hljMmgvCCa6i8vTUxVcHu+soTp2u5GNI4QtMsPrz5/xe
         0V194CeXMZ0ANSL2sAKQOOpdXK74z8Huy+zSLr04f7AAUyXZlQyOBuUYjsPDyj6HQOmo
         /0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701155818; x=1701760618;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1hGy46pUf93WoDJ7rnnE2nED/iyelB1yhgDX8ASNQ7E=;
        b=fTnDo0LgNC0BGi1/k/zNA9CFfMOaHdLDYGOzTxvdoYnpaeNefKdB0Vap6bWMAzIDnH
         KeT5+Sk440A3LLRaVur4c01iKr9YCijOtTe7mwRm23zwnsDeQ8fJGHkACz4FfQVSbFSz
         TN2U2StDCuGJV6EmJel97ZSY/VGT4VJL7W3bP0s8MKIlJdftVzu4Ohbae7T/DYBjIl+W
         P65+8niDl7E5FyahMu1uZdMOvFzdETXOM8EQ4CLlLBPzb74YevxsHbG9rv/TiKTha3tz
         iAhPu0QQe9pHOsefDOtNGl8vNedytvy3QCWUmL5/6jUxx+KRF4CiCxEmsvgYOPG7JtB7
         W5Gw==
X-Gm-Message-State: AOJu0Ywt0ifkIX35mjVqb7sMzV+S5asiQZtyl6vCB3vKbjbdQq0OXPBk
	55n9vVYTQTHoAdy7NLMAF6cXTVRpdnv4NGtzKrc=
X-Google-Smtp-Source: AGHT+IFgwFw7npmV6jjE0YipeNTQs2cwOSwYlG2/9Hv4A2Hr9ObLQntqtxAzF+6fw3EgWDGHIqkZ2Q==
X-Received: by 2002:a05:6358:52c6:b0:16b:c479:d6c1 with SMTP id z6-20020a05635852c600b0016bc479d6c1mr17221034rwz.9.1701155817816;
        Mon, 27 Nov 2023 23:16:57 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:8338:14c0:b892:2482:e230? ([2402:7500:4ce:8338:14c0:b892:2482:e230])
        by smtp.gmail.com with ESMTPSA id n7-20020a634007000000b005c2185be2basm8957980pga.54.2023.11.27.23.16.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Nov 2023 23:16:57 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v2 09/13] RISC-V: crypto: add Zvknha/b accelerated
 SHA224/256 implementations
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231128041235.GJ1463@sol.localdomain>
Date: Tue, 28 Nov 2023 15:16:53 +0800
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
Message-Id: <51190E7A-25BD-4D9A-AADF-02FE2A280508@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-10-jerry.shih@sifive.com>
 <20231128041235.GJ1463@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 28, 2023, at 12:12, Eric Biggers <ebiggers@kernel.org> wrote:
> On Mon, Nov 27, 2023 at 03:06:59PM +0800, Jerry Shih wrote:
>> +/*
>> + * sha256 using zvkb and zvknha/b vector crypto extension
>> + *
>> + * This asm function will just take the first 256-bit as the sha256 =
state from
>> + * the pointer to `struct sha256_state`.
>> + */
>> +asmlinkage void
>> +sha256_block_data_order_zvkb_zvknha_or_zvknhb(struct sha256_state =
*digest,
>> +					      const u8 *data, int =
num_blks);
>=20
> The SHA-2 and SM3 assembly functions are potentially being called =
using indirect
> calls, depending on whether the compiler optimizes out the indirect =
call that
> exists in the code or not.  These assembly functions also are not =
defined using
> SYM_TYPED_FUNC_START.  This is not compatible with Control Flow =
Integrity
> (CONFIG_CFI_CLANG); these indirect calls might generate CFI failures.
>=20
> I recommend using wrapper functions to avoid this issue, like what is =
done in
> arch/arm64/crypto/sha2-ce-glue.c.
>=20
> - Eric

Here is the previous review comment for the assembly function wrapper:
> > +asmlinkage void sha256_block_data_order_zvbb_zvknha(u32 *digest, =
const void *data,
> > +					unsigned int num_blks);
> > +
> > +static void __sha256_block_data_order(struct sha256_state *sst, u8 =
const *src,
> > +				      int blocks)
> > +{
> > +	sha256_block_data_order_zvbb_zvknha(sst->state, src, blocks);
> > +}
> Having a double-underscored function wrap around a non-underscored one =
like this
> isn't conventional for Linux kernel code.  IIRC some of the other =
crypto code
> happens to do this, but it really is supposed to be the other way =
around.
>=20
> I think you should just declare the assembly function to take a =
'struct
> sha256_state', with a comment mentioning that only the 'u32 state[8]' =
at the
> beginning is actually used.  That's what =
arch/x86/crypto/sha256_ssse3_glue.c
> does, for example.  Then, __sha256_block_data_order() would be =
unneeded.

Do you mean that we need the wrapper functions back for both SHA-* and =
SM3?
If yes, we also don't need to check the state offset like:
	BUILD_BUG_ON(offsetof(struct sha256_state, state) !=3D 0);

Could we just use the `SYM_TYPED_FUNC_START` in asm directly without the
wrappers?

-Jerry=
