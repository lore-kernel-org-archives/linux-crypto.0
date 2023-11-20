Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="EC+qeQww"
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D2BD4F
	for <linux-crypto@vger.kernel.org>; Sun, 19 Nov 2023 18:36:47 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1cc3542e328so28160485ad.1
        for <linux-crypto@vger.kernel.org>; Sun, 19 Nov 2023 18:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1700447807; x=1701052607; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Zq4RPXM6eCo+MpwtSfj3ACqp+KpQugLsNlxVZl0DlA=;
        b=EC+qeQww2Qbz1pVNrG7CDHkr29EqOhCoUDUtrGFLYnBSZtA7a6YnbWwkknY1qDfb8f
         m5A263wA3nuUQoZoNZU4ccXDVu3eyasp3WuEps5w0LDViM4avcuN66e7Wf7WmdlJN7kv
         +U2MoY58R2xf7k4IkuZnVigCINhxIpjCnqIGph9qMzNdYrrQt8dE/nm5xDeEtRJPSXws
         QBKzFCK/hMMU6Vj9hKpVM08Z6baaveeuC+TW5iZGo7XYiQAjIw5MOOh51qQHX5B8yA++
         xudu3M6K9zruEG8bJ2AtPOaBLn0iJI8OvdEoqJFAw1C5ctjQpXjSpTCcULUxoS0n4ZS/
         f98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700447807; x=1701052607;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Zq4RPXM6eCo+MpwtSfj3ACqp+KpQugLsNlxVZl0DlA=;
        b=WAVP9beBVKEeP3046qJwVgN78b13fdQuTypa9wqH3kvB8H6l0fLWeiGEA1qmdd6/S5
         3W2OOFyCCN01Lsqnvkk3MOzN6NA/eYFiHP/W3Lc/9AgFILc5zJbNmEB6GfHrT8yPTowf
         qH/t0QoUSkQ9WnWRkzJqndepA83hM7glyf5AhJv0EsldxpW9H2yoBFHKIKMsMKS+ipU+
         H+caPWd0+ZOrVoWGmUsbBRrCsf4XclgOVt7f6hOwN0/8567vcvfDsmn7rVtWdHLFyvA1
         lXqSCqwpuaAwKWxy3Z78C/PmHG7we6JPUD2xAPxtvEZ8YZB8wgdseyzU1muSbQz/3wmS
         RCTA==
X-Gm-Message-State: AOJu0YzGOpmQt/p7asDajOJhAIoRoAVA3Y4AV+tC5BtKit2rcHAO+TEB
	4/784KFnuTIrgB3OmuAy6d/8IQ==
X-Google-Smtp-Source: AGHT+IEKO8u8O27bTQGYqNJmwiQ/UY61Ih/6GCQAtHUfSm8QYLvQjd6X/hM7S5g2BeKD4AKKFk1lQw==
X-Received: by 2002:a17:902:a5c9:b0:1cc:60ca:8f24 with SMTP id t9-20020a170902a5c900b001cc60ca8f24mr4758601plq.45.1700447806758;
        Sun, 19 Nov 2023 18:36:46 -0800 (PST)
Received: from [192.168.244.11] ([49.216.222.216])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902eec600b001bb1f0605b2sm4939926plb.214.2023.11.19.18.36.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Nov 2023 18:36:46 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH 06/12] RISC-V: crypto: add accelerated AES-CBC/CTR/ECB/XTS
 implementations
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <CF7F714A-CAC1-41C4-A43A-DA1273111492@sifive.com>
Date: Mon, 20 Nov 2023 10:36:19 +0800
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 Albert Ou <aou@eecs.berkeley.edu>,
 herbert@gondor.apana.org.au,
 davem@davemloft.net,
 andy.chiu@sifive.com,
 greentime.hu@sifive.com,
 conor.dooley@microchip.com,
 guoren@kernel.org,
 bjorn@rivosinc.com,
 heiko@sntech.de,
 ardb@kernel.org,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B4290995-3983-41D8-991E-ABA2213656B1@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-7-jerry.shih@sifive.com>
 <20231109080549.GC1245@sol.localdomain>
 <CF7F714A-CAC1-41C4-A43A-DA1273111492@sifive.com>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 10, 2023, at 12:06, Jerry Shih <jerry.shih@sifive.com> wrote:
> On Nov 9, 2023, at 16:05, Eric Biggers <ebiggers@kernel.org> wrote:
>> On Thu, Oct 26, 2023 at 02:36:38AM +0800, Jerry Shih wrote:
>>> +# prepare input data(v24), iv(v28), bit-reversed-iv(v16), =
bit-reversed-iv-multiplier(v20)
>>> +sub init_first_round {
>>> ....
>>> +    # Prepare GF(2^128) multiplier [1, x, x^2, x^3, ...] in v8.
>>> +    slli $T0, $LEN32, 2
>>> +    @{[vsetvli "zero", $T0, "e32", "m1", "ta", "ma"]}
>>> +    # v2: [`1`, `1`, `1`, `1`, ...]
>>> +    @{[vmv_v_i $V2, 1]}
>>> +    # v3: [`0`, `1`, `2`, `3`, ...]
>>> +    @{[vid_v $V3]}
>>> +    @{[vsetvli "zero", $T0, "e64", "m2", "ta", "ma"]}
>>> +    # v4: [`1`, 0, `1`, 0, `1`, 0, `1`, 0, ...]
>>> +    @{[vzext_vf2 $V4, $V2]}
>>> +    # v6: [`0`, 0, `1`, 0, `2`, 0, `3`, 0, ...]
>>> +    @{[vzext_vf2 $V6, $V3]}
>>> +    slli $T0, $LEN32, 1
>>> +    @{[vsetvli "zero", $T0, "e32", "m2", "ta", "ma"]}
>>> +    # v8: [1<<0=3D1, 0, 0, 0, 1<<1=3Dx, 0, 0, 0, 1<<2=3Dx^2, 0, 0, =
0, ...]
>>> +    @{[vwsll_vv $V8, $V4, $V6]}
>>=20
>> This code assumes that '1 << i' fits in 64 bits, for 0 <=3D i < vl.
>>=20
>> I think that works out to an implicit assumption that VLEN <=3D 2048. =
 I.e.,
>> AES-XTS encryption/decryption would produce the wrong result on =
RISC-V
>> implementations with VLEN > 2048.
>>=20
>> Perhaps it should be explicitly checked that VLEN <=3D 2048?
>>=20
>> - Eric
>=20
> Yes, we could just have the simple checking like:
>=20
>  riscv_vector_vlen() >=3D 128 || riscv_vector_vlen() <=3D2048
>=20
> We could also truncate the VL inside for VLEN>2048 case.
> Let me think more about these two approaches.=20
>=20
> -Jerry

I use the simplest solution. Setup the check for vlen:
	riscv_vector_vlen() >=3D 128 || riscv_vector_vlen() <=3D2048
It will have a situation that we will not enable accelerated aes-xts for =
`vlen>2048`.
I would like to make a `todo` task to fix that in the future.

-Jerry=
