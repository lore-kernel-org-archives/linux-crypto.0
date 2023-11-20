Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Va+2qlGg"
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7331A1
	for <linux-crypto@vger.kernel.org>; Sun, 19 Nov 2023 18:55:46 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-5a9bc2ec556so2186400a12.0
        for <linux-crypto@vger.kernel.org>; Sun, 19 Nov 2023 18:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1700448946; x=1701053746; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQLpISrSuWQBWBAvuQbodwZBDAWI6iXmTyJBLfM/8EA=;
        b=Va+2qlGgfHeXJry07RcSqdKxGcHU6vSJ0KARWOExaC+NF96HGf3zGrhH8m6EaRyiI0
         MSIH1GeFEhVxTcjU1sYI8gnjE0kAeYwNPFvu5D9Mc/+7RKa/SDc+ku/dGqgVgzdRAroJ
         I5EduSEpISjBCYIhJoH0ttgi8A0RXhoUeLlOmR4A8w+9wkN5WDAR0EFXuG+oF6tyQDz1
         6r5sunZnoXyehyYCOx7VPpNw/iKSyTcY0HhqthJLdnmXtnzdtVlU7Ir22RgQoarwvv7Z
         LwGjs3cSWoYKA7drcl6w9rbEEHIYAHYmVrNzhuX5T8urXzifF7AMcEkz0s9tGAEzCXjo
         nxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700448946; x=1701053746;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CQLpISrSuWQBWBAvuQbodwZBDAWI6iXmTyJBLfM/8EA=;
        b=NkB9tWPrHQxmloN1I0iLlclo6a08aLJtySHb9kQFxRmNrSWXy271Y/fLu7ADJ03Ncg
         Xu1TIXx/rtQYC5zm5esotfPZ23YVSpDijpOi8IMrl4fpwAl+ec7xBiOyysW1xsU+ct2+
         CPgzW3WHO2/uejIWNpw/nscMXGk670JFbkyaNXetHsCJXPbozsZFFH4OrMTdi1N3+3U8
         jfyCkv+eo/Jzbt24CC7mknA4X94xPd11tgog+SKtnCzLewy4ttzA7zwfIqfa3GAC0L5P
         IlH+ta4W7UL/byzjkCzzWiNMWuzdhZgOFf/FOqIb2X6RAnhVT9N6U+EiEY6EMiaxY7Sg
         vbXA==
X-Gm-Message-State: AOJu0YwH2gRqOxSqNe5nrVUEYXfLlYvaXBaSBfzIvr3BkXwYA+ZnuREH
	sN9HM1/XZobxUfEPuZGKZpe0WQ==
X-Google-Smtp-Source: AGHT+IEw6BVjKQe+wHImLyjUr3AymFfea4UwO2aOMC/OMRsrnoV+SV3vD2csl5EOmm9ds1wLTdzCfQ==
X-Received: by 2002:a05:6a20:2d1e:b0:187:a119:909d with SMTP id g30-20020a056a202d1e00b00187a119909dmr4195928pzl.13.1700448945925;
        Sun, 19 Nov 2023 18:55:45 -0800 (PST)
Received: from ?IPv6:2402:7500:5d5:bc21:3420:fefa:20d4:2a2f? ([2402:7500:5d5:bc21:3420:fefa:20d4:2a2f])
        by smtp.gmail.com with ESMTPSA id y12-20020a170902ed4c00b001cc256ce1besm4928265plb.138.2023.11.19.18.55.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Nov 2023 18:55:45 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH 10/12] RISC-V: crypto: add Zvksed accelerated SM4
 implementation
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231102055848.GI1498@sol.localdomain>
Date: Mon, 20 Nov 2023 10:55:41 +0800
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
Content-Transfer-Encoding: 7bit
Message-Id: <078F58E9-7CCF-4A59-BD29-8E87F9EE434B@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-11-jerry.shih@sifive.com>
 <20231102055848.GI1498@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 2, 2023, at 13:58, Eric Biggers <ebiggers@kernel.org> wrote:
> On Thu, Oct 26, 2023 at 02:36:42AM +0800, Jerry Shih wrote:
>> +struct crypto_alg riscv64_sm4_zvksed_alg = {
>> +	.cra_name = "sm4",
>> +	.cra_driver_name = "sm4-riscv64-zvkb-zvksed",
>> +	.cra_module = THIS_MODULE,
>> +	.cra_priority = 300,
>> +	.cra_flags = CRYPTO_ALG_TYPE_CIPHER,
>> +	.cra_blocksize = SM4_BLOCK_SIZE,
>> +	.cra_ctxsize = sizeof(struct sm4_ctx),
>> +	.cra_cipher = {
>> +		.cia_min_keysize = SM4_KEY_SIZE,
>> +		.cia_max_keysize = SM4_KEY_SIZE,
>> +		.cia_setkey = riscv64_sm4_setkey_zvksed,
>> +		.cia_encrypt = riscv64_sm4_encrypt_zvksed,
>> +		.cia_decrypt = riscv64_sm4_decrypt_zvksed,
>> +	},
>> +};
> 
> This should be 'static'.
> 
> - Eric

Thx.
Fixed.


-Jerry
