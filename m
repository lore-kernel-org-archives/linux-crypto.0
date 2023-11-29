Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="C1PiVOef"
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4703C1735
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 18:40:03 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1cfcc9b3b5cso26127505ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 18:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701225603; x=1701830403; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5x5B0c437a2X9lDq0UQuEQp64iHtOX/XVWyXOOCW84=;
        b=C1PiVOefUlAZHTQ0GuFJuT4q1hAhtdRFNnh1uRC3xtDYnehCo/BAcmzmQ/RFW2Z9tR
         14z5atUH8tfWWmrygjBafEcX0uN0bRTSU/sb0LQv6CRiM/azx4XyM8ZkG18HGOmCQ67q
         5y7MFsvYEcUZ4D/EFM3hjTL6lqFnb565zPwcyLYXUr03cx4Zf58eV44LFL8Zx9EniDrP
         Ey06cEt3wTVD8zfxqAQHE7WbDtKNBNJwLnlzeK7mlSM0cNfyAySsjxGrx2hyNSq1nJBt
         JVD8vUNhCZVH2HrGPnvedfg9NWK0U1wvKz4kpEHtTR4zm8m1Y6mYhIMqSLKSvysmuaSI
         NwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701225603; x=1701830403;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V5x5B0c437a2X9lDq0UQuEQp64iHtOX/XVWyXOOCW84=;
        b=I8q1qklLWV3mw0Gx6DVlrZV57MRG9GVpOADbqJO+LZv6Qj54A1VcddeQ1E7Yq4kwXx
         50PbafPFW0zxHcy011u+SYhh4IS0C4HVauM1wk9yL76dvxeu1f2GOaSTsE0j8+S0BN/b
         XhxFu0oL47bIuvsGcmxnsNHeLDNC6GDVS0E7s9dYqpUIw9uU6SVRmEtXl0UWc3G2uVTW
         BcGyB9KU1V2g+4wiedJU+EOe6iDbV4Z0EY2M4c96pvOIf8YUMjck4ZWWKrEKb8ZvmHNc
         pG2SMErvxkmVDyhPlVAu2ZhNoIVpteT+G+wzvwby4ufJDwj6g2ruL8nus1YHZC4GVET7
         Jisw==
X-Gm-Message-State: AOJu0Yyiwl5V62MBTntJ6ELVmSIrlVd1rgvRFGMWTvSgwF9X0QZzVdlV
	zzDZnkKimmFGaBQRy7FYTZpq5lHg5ykilM0N0Ow=
X-Google-Smtp-Source: AGHT+IHciKY2OrzZ9uzKYCblSTprxoTaxuGcqxj9qIEPOv32IWeYHV5K+GkoXvaXcNdlaGNzpGPu9g==
X-Received: by 2002:a17:902:ce84:b0:1cf:b7ea:fea with SMTP id f4-20020a170902ce8400b001cfb7ea0feamr15805442plg.1.1701225602758;
        Tue, 28 Nov 2023 18:40:02 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:5a34:50a0:78b5:5013:4cf4? ([2402:7500:4ce:5a34:50a0:78b5:5013:4cf4])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090322c400b001cfcd4eca11sm4806771plg.114.2023.11.28.18.39.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Nov 2023 18:40:02 -0800 (PST)
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
In-Reply-To: <20231128201228.GE1148@sol.localdomain>
Date: Wed, 29 Nov 2023 10:39:56 +0800
Cc: Conor Dooley <conor@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 aou@eecs.berkeley.edu,
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
Message-Id: <E78B3BF9-8E49-417B-A89E-05F72690A92F@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-5-jerry.shih@sifive.com>
 <20231128-await-tipper-2094715466f2@spud>
 <20231128201228.GE1148@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 29, 2023, at 04:12, Eric Biggers <ebiggers@kernel.org> wrote:
> On Tue, Nov 28, 2023 at 05:54:49PM +0000, Conor Dooley wrote:
>>> +static inline bool check_aes_ext(void)
>>> +{
>>> +	return riscv_isa_extension_available(NULL, ZVKNED) &&
>>> +	       riscv_vector_vlen() >=3D 128;
>>> +}
>>=20
>> I'm not keen on this construct, where you are checking vlen greater =
than
>> 128 and the presence of Zvkned without checking for the presence of V
>> itself. Can you use "has_vector()" in any places where you depend on =
the
>> presence of vector please?
>=20
> Shouldn't both of those things imply vector support already?

The vector crypto extensions imply `V` extension. Should we still need =
to check
the `V` explicitly?
=
https://github.com/riscv/riscv-crypto/blob/main/doc/vector/riscv-crypto-sp=
ec-vector.adoc#1-extensions-overview

>> Also, there are potentially a lot of places in this drivers where you
>> can replace "riscv_isa_extension_available()" with
>> "riscv_has_extension_likely()". The latter is optimised with
>> alternatives, so in places that are going to be evaluated frequently =
it
>> may be beneficial for you.
>=20
> These extension checks are only executed in module_init functions, so =
they're
> not performance critical.

All `riscv_isa_extension_available()` calls in crypto drivers are called =
once
in the module init calls. Should we still need that =
`riscv_has_extension_likely()`
with a little more code size?

> - Eric

