Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="fiyXQpLW"
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F16E122
	for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 18:50:09 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1cfabcbda7bso12748725ad.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 18:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701053409; x=1701658209; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJDYU9ePuMyONSdH/Hmp5teasBzIstryZsSquW0uRgs=;
        b=fiyXQpLWb1q+LhqAIJFioDrxi+3PIXBtbT3u7D8fFGO0jYwGpTCiG18LVjxnP6xN7+
         +clcWX5Q1mzkGQ2YTq2zhUBZziQe1B0GMhH/KFnYZ1xhwZUi6ts/YdO+RQCdn06/MM/T
         LfUSNYm9BuWuWHQQgnCXaRI0klR9z6nmOtSojS841q+CSJ+eFvwComBPBDCA+oBU7BAX
         wlxAF9S+unJoux/3VuOgYJSsAZnuT2QBF/zQgJ4acO+UosIHUDVvxbqJajjaaxyRhd+4
         E82KFtEPdMc5yX2nfIQjoKSKIQcMOi6xhKVn3y+43r8rgxl0an7ID/5n/7eHSx1zPC3S
         cHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701053409; x=1701658209;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZJDYU9ePuMyONSdH/Hmp5teasBzIstryZsSquW0uRgs=;
        b=qLiwbsqTloeHF93Tjr+EgcZbOb4Ozh3tE+eII6mKmBvZ3FDmudn2R9S4Auk0l9/JpA
         QHJhBsjGXaabXuRbvHT9rZo+qXtigFgfFauifur2D5zPLM7UAUvaNK5jUrDUIzW6Nw59
         aegXtj6m/i2DO8larfAAZNXd8Jj/1GBqvW4PIFkJEm3cgQnKPN61SKksMq5sbhKId1EG
         sKMqtmMUpovLSBx/1itOGwMMa4iH/ncmw87dIGTeHSdJXI6nL3Jl3SKkz9z5KLeEhJpk
         YWhj9cHszO+6Kvsyzd74LxpCEa0tqjDeioXJ5biuvsP0cF7IxcIG7CJ8SUvr18ay1UsY
         HVoA==
X-Gm-Message-State: AOJu0Yy9G90t9WoZnySeSxdwnUJaYdCyzYRYmwTDkWddjMDjRhatZ9AC
	KZmoLpmX6E5a+Cen1RkmYuR6MQ==
X-Google-Smtp-Source: AGHT+IE6Byv2GXYDkP+I0VNXSKjtXLqAjEy3RG6g235VNudLgF/NCLhIFFJiZRP/ESQyACaudebM8g==
X-Received: by 2002:a17:903:2585:b0:1cf:68c8:7a18 with SMTP id jb5-20020a170903258500b001cf68c87a18mr12143435plb.14.1701053408996;
        Sun, 26 Nov 2023 18:50:08 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:95c7:2856:b238:775:b338? ([2402:7500:4ce:95c7:2856:b238:775:b338])
        by smtp.gmail.com with ESMTPSA id o4-20020a1709026b0400b001b898595be7sm7028182plk.291.2023.11.26.18.50.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Nov 2023 18:50:08 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH 09/12] RISC-V: crypto: add Zvknhb accelerated SHA384/512
 implementations
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231122013210.GH2172@sol.localdomain>
Date: Mon, 27 Nov 2023 10:50:04 +0800
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
Message-Id: <9BB2B250-8A35-4116-A43B-55FC477A5B06@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-10-jerry.shih@sifive.com>
 <20231122013210.GH2172@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 22, 2023, at 09:32, Eric Biggers <ebiggers@kernel.org> wrote:
> On Thu, Oct 26, 2023 at 02:36:41AM +0800, Jerry Shih wrote:
>> +static int riscv64_sha512_update(struct shash_desc *desc, const u8 *data,
>> +				 unsigned int len)
>> +{
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * Make sure struct sha256_state begins directly with the SHA256
>> +	 * 256-bit internal state, as this is what the asm function expect.
>> +	 */
>> +	BUILD_BUG_ON(offsetof(struct sha512_state, state) != 0);
> 
> There's a copy-paste error here; all the 256 above should be 512.

Fixed.

>> +static struct shash_alg sha512_alg[] = {
>> +	{
>> +		.digestsize = SHA512_DIGEST_SIZE,
>> +		.init = sha512_base_init,
>> +		.update = riscv64_sha512_update,
>> +		.final = riscv64_sha512_final,
>> +		.finup = riscv64_sha512_finup,
>> +		.descsize = sizeof(struct sha512_state),
>> +		.base.cra_name = "sha512",
>> +		.base.cra_driver_name = "sha512-riscv64-zvkb-zvknhb",
>> +		.base.cra_priority = 150,
>> +		.base.cra_blocksize = SHA512_BLOCK_SIZE,
>> +		.base.cra_module = THIS_MODULE,
>> +	},
>> +	{
>> +		.digestsize = SHA384_DIGEST_SIZE,
>> +		.init = sha384_base_init,
>> +		.update = riscv64_sha512_update,
>> +		.final = riscv64_sha512_final,
>> +		.finup = riscv64_sha512_finup,
>> +		.descsize = sizeof(struct sha512_state),
>> +		.base.cra_name = "sha384",
>> +		.base.cra_driver_name = "sha384-riscv64-zvkb-zvknhb",
>> +		.base.cra_priority = 150,
>> +		.base.cra_blocksize = SHA384_BLOCK_SIZE,
>> +		.base.cra_module = THIS_MODULE,
>> +	}
>> +};
> 
> *_algs instead of *_alg when there's more than one, please.
> I.e., sha512_alg => sha512_algs here.

Fixed.

> - Eric

