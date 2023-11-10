Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4454B1FCB
	for <linux-crypto@vger.kernel.org>; Fri, 10 Nov 2023 07:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ge5fuSoO"
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE388254
	for <linux-crypto@vger.kernel.org>; Thu,  9 Nov 2023 23:05:38 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6bb4abb8100so1578998b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 09 Nov 2023 23:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1699599937; x=1700204737; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XUDU8jgptAxW+fbE2XJsHM9R/m1WuxaBgSA3vJN2eHc=;
        b=ge5fuSoObGcu7H2HxOmot+bxPZhuxk4kot4v2LyputHTWYK/drvtZtO4ypto+P8/vn
         ESzbe/fGOrKRKenBNkORqnVngBs2fEHYbLTXVrFKwo8KcPvEZKPrwVAMvUqlnYzMMa6U
         6Bmox/YylFPTxxiTdASo2eBxpuFWQe9tdII3tFo/NkPhTEE9JWW+CAtYp8CUw4cF361z
         3qiEmjtfqNFM/RDptxc7VMy0fzf7knGVEyPs3ScqM7JcJpLuPoLZya5v6DvCDYg4+Wdl
         lwezlhmmcw3CQRWy9m1bxRPEahF6c56Hk53wr3WLG6luQEDJ2WKPbwd0nSRrX6kjXbLK
         Nkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699599937; x=1700204737;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XUDU8jgptAxW+fbE2XJsHM9R/m1WuxaBgSA3vJN2eHc=;
        b=VW6VL8i7ShUkiEy+AEDZ3NX6c6WC2aHsDC2g7sqrnqgTy1Cb7wTymOMU5bz0ExlNmS
         D3uLhQVneMI696tKe2/PIkeS71vFLjyA5snHWca6CoByO9ghpybbzyeQYK5hoVRYWGZZ
         iTLSathoe5ilvFhPKKjduwYuuJygzDxRpmj0j1VgvTWSwgGD6f2klaEGatja8E5Zk9B+
         1Tvq7w+DhzfNZS3gImHLeK5AdioiFzK6ZrZnEnPpD6xiBzwVNoaQNTM9rRWOpMC+egIC
         t84HQZnJwQfdauKiz+EfjGXXKA2xEV/7vvP9TjKKaZiNUxp8g/hFChRbWK8rjiFt7/8N
         S6MQ==
X-Gm-Message-State: AOJu0YwnkCC+odcggs+B27n7WWRfAiYk4403XgTvgbouSbkbNl1pHBA6
	50oKP8DHKXjEKXcvix5i0GZ+3RrX7tG7P2lSpJl7dg==
X-Google-Smtp-Source: AGHT+IHRC6A0RYIZ+hAK7pADe4iS4Ng9L/OaXImZUunvvqSvdYwesELoXVdLs1NatCPZXbqISvIX0A==
X-Received: by 2002:a67:e0c6:0:b0:45d:9376:a873 with SMTP id m6-20020a67e0c6000000b0045d9376a873mr7001350vsl.29.1699589176700;
        Thu, 09 Nov 2023 20:06:16 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:aeef:99fc:78aa:eebe:b7e0? ([2402:7500:4ce:aeef:99fc:78aa:eebe:b7e0])
        by smtp.gmail.com with ESMTPSA id w13-20020a170902e88d00b001c627413e87sm4301587plg.290.2023.11.09.20.06.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Nov 2023 20:06:16 -0800 (PST)
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
In-Reply-To: <20231109080549.GC1245@sol.localdomain>
Date: Fri, 10 Nov 2023 12:06:10 +0800
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
Message-Id: <CF7F714A-CAC1-41C4-A43A-DA1273111492@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-7-jerry.shih@sifive.com>
 <20231109080549.GC1245@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 9, 2023, at 16:05, Eric Biggers <ebiggers@kernel.org> wrote:
> On Thu, Oct 26, 2023 at 02:36:38AM +0800, Jerry Shih wrote:
>> +# prepare input data(v24), iv(v28), bit-reversed-iv(v16), =
bit-reversed-iv-multiplier(v20)
>> +sub init_first_round {
>> ....
>> +    # Prepare GF(2^128) multiplier [1, x, x^2, x^3, ...] in v8.
>> +    slli $T0, $LEN32, 2
>> +    @{[vsetvli "zero", $T0, "e32", "m1", "ta", "ma"]}
>> +    # v2: [`1`, `1`, `1`, `1`, ...]
>> +    @{[vmv_v_i $V2, 1]}
>> +    # v3: [`0`, `1`, `2`, `3`, ...]
>> +    @{[vid_v $V3]}
>> +    @{[vsetvli "zero", $T0, "e64", "m2", "ta", "ma"]}
>> +    # v4: [`1`, 0, `1`, 0, `1`, 0, `1`, 0, ...]
>> +    @{[vzext_vf2 $V4, $V2]}
>> +    # v6: [`0`, 0, `1`, 0, `2`, 0, `3`, 0, ...]
>> +    @{[vzext_vf2 $V6, $V3]}
>> +    slli $T0, $LEN32, 1
>> +    @{[vsetvli "zero", $T0, "e32", "m2", "ta", "ma"]}
>> +    # v8: [1<<0=3D1, 0, 0, 0, 1<<1=3Dx, 0, 0, 0, 1<<2=3Dx^2, 0, 0, =
0, ...]
>> +    @{[vwsll_vv $V8, $V4, $V6]}
>=20
> This code assumes that '1 << i' fits in 64 bits, for 0 <=3D i < vl.
>=20
> I think that works out to an implicit assumption that VLEN <=3D 2048.  =
I.e.,
> AES-XTS encryption/decryption would produce the wrong result on RISC-V
> implementations with VLEN > 2048.
>=20
> Perhaps it should be explicitly checked that VLEN <=3D 2048?
>=20
> - Eric

Yes, we could just have the simple checking like:

  riscv_vector_vlen() >=3D 128 || riscv_vector_vlen() <=3D2048

We could also truncate the VL inside for VLEN>2048 case.
Let me think more about these two approaches.=20

-Jerry=
