Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="jrl1bmce"
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FEE182
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 00:57:43 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6cd89f2af9dso2167878b3a.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 00:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701161863; x=1701766663; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTYsamGNaQ8fRNjNMaxridTGMNfJmuFsAlfcl9yavQs=;
        b=jrl1bmceyHOFSDtvQApVUTf5TVwt6J7Mv/Mq6VjJic6wS1BHy8agCIMRXABStPzYOw
         WmGDF2ELP6qmx6LyxcP+KwWnLsahstorvThiBWPTRZGDOrQNF1rg3Irv0yS0JxZpAzVK
         +0uo5DLXF828BUL6NXVFSIssdFrHdF09t+NwEQ0zNYo9VXWOAMrrm1TgOoRgreRtRcF2
         CIk7oAr2rjiSDFZU/pTD6x+OGzyH1/7K01yTO2VDaNV5kn5q7xr97kgu5fvPJz7EVVNI
         tPP0pw6WF8zTDk/rJtadRqtw+LHUaHM5rrz1+FTZCKHQfxK87KOiHxJ1vUbpEUr2IGFg
         /m3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701161863; x=1701766663;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BTYsamGNaQ8fRNjNMaxridTGMNfJmuFsAlfcl9yavQs=;
        b=MZvIDCHehmoTaweXcBAK/SPqh8S/sKFGlWonMdhcDMthETTE8ONvWeGm0zuzptISbH
         lRXsf7AmiGwI1Aats/y4OAmNGvRferib4oB0gWGSoHpDFwfAdLw5gNsq8kQD0mSqJ75M
         LsQGzE7T0qo8I9lJ8QfdbdY0CIDqfeMk8qrnUx6OubdHSwFJBhZ+ol460OtsBEGlK2In
         L2B7DQLShhnVzcpE3fbh/V7yYnEcSbAYCTnsAOK8sKnovcwz2YX2Ird1aogdlcQF6sI9
         hP6Q6hqlZCW1nGmdWHecRGx6CtCU+dJ8RAjaiTpUPvX+WidWyTfJNxuiY+kN4+Yr/PG+
         17aw==
X-Gm-Message-State: AOJu0YxC+l5pHXf0qwuEhk/BXtCAVsAL71VeRiu28tmB7bwAD1cQmk+I
	JOoeJ3OBwpQ6z2W3XCCTumlOWw==
X-Google-Smtp-Source: AGHT+IE/fng9QOuiUZBluDfizhRPgWmYcOqQIfRFSizRR9MTI4Ihwkn53PdiTZ2Of0dfq0nFdnkdKA==
X-Received: by 2002:a05:6a20:5650:b0:18b:9053:d865 with SMTP id is16-20020a056a20565000b0018b9053d865mr15666672pzc.42.1701161862894;
        Tue, 28 Nov 2023 00:57:42 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:8338:14c0:b892:2482:e230? ([2402:7500:4ce:8338:14c0:b892:2482:e230])
        by smtp.gmail.com with ESMTPSA id g8-20020a056a00078800b00694fee1011asm8522232pfu.208.2023.11.28.00.57.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Nov 2023 00:57:42 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v2 13/13] RISC-V: crypto: add Zvkb accelerated ChaCha20
 implementation
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231128042503.GL1463@sol.localdomain>
Date: Tue, 28 Nov 2023 16:57:38 +0800
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
Message-Id: <3B3784E0-0DE2-4A99-878E-657BB0E0765D@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-14-jerry.shih@sifive.com>
 <20231128042503.GL1463@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 28, 2023, at 12:25, Eric Biggers <ebiggers@kernel.org> wrote:
> On Mon, Nov 27, 2023 at 03:07:03PM +0800, Jerry Shih wrote:
>> +config CRYPTO_CHACHA20_RISCV64
>=20
> Can you call this kconfig option just CRYPTO_CHACHA_RISCV64?  I.e. =
drop the
> "20".  The ChaCha family of ciphers includes more than just ChaCha20.
>=20
> The other architectures do use "CHACHA20" in their equivalent option, =
even when
> they implement XChaCha12 too.  But that's for historical reasons -- we =
didn't
> want to break anything by renaming the kconfig options.  For a new =
option we
> should use the more general name from the beginning, even if initially =
only
> ChaCha20 is implemented (which is fine).

I will use `CRYPTO_CHACHA_RISCV64` instead.

>> +static int chacha20_encrypt(struct skcipher_request *req)
>=20
> riscv64_chacha_crypt(), please.  chacha20_encrypt() is dangerously =
close to
> being the same name as chacha20_crypt() which already exists in =
crypto/chacha.h.

The function will will have additional prefix/suffix.

>> +static inline bool check_chacha20_ext(void)
>> +{
>> +	return riscv_isa_extension_available(NULL, ZVKB) &&
>> +	       riscv_vector_vlen() >=3D 128;
>> +}
>=20
> Just to double check: your intent is to simply require VLEN >=3D 128 =
for all the
> RISC-V vector crypto code, even when some might work with a shorter =
VLEN?  I
> don't see anything in chacha-riscv64-zvkb.pl that assumes VLEN >=3D =
128, for
> example.  I think it would even work with VLEN =3D=3D 32.

Yes, the chacha algorithm here only needs the VLEN>=3D32. But I think we =
will not get
benefits with that kind of hw.

> I think requiring VLEN >=3D 128 anyway makes sense so that we don't =
have to worry
> about validating the code with shorter VLEN.  And "application =
processors" are
> supposed to have VLEN >=3D 128.  But I just wanted to make sure this =
is what you
> intended too.

The standard "V" extension assumes VLEN>=3D128. I just follow that =
assumption.
=
https://github.com/riscv/riscv-v-spec/blob/master/v-spec.adoc#183-v-vector=
-extension-for-application-processors

-Jerry

