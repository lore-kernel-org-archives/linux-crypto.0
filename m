Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E506A183CC3
	for <linux-crypto@vger.kernel.org>; Mon,  2 Jun 2025 06:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748847017; cv=none; b=DIQNKXc7acsdItcmsLKZzAGL8MVPYJX7fzzYJp5ZAw3sqONB6R6Xm+g4Z72wgzWM3XFAtKR+PXwKRSVEbNN90NILruFxcKB3i1S0llJrRU9UXI4GGZU15+8cEsl55xuLI/rZ23eNHQgphkJI7Sw/CXl9v2RyGhxPlICzIxwcnkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748847017; c=relaxed/simple;
	bh=USY+Knj3Gn6M4UyCoMEuT925F5VZ0aIxGsAN793hFfA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Om9qszgMZ+uNsg0U58mrsMHZpKy8rbMejx738FgBp05HCjx1JbUUBXkp9mKawYjDw1VdOMOFBMRWxJr3r7PUJEFZEiSt7So/LtRGqpP3IWF/ljtAOUxXiomZdkTFFER/+PdKdVWnloPTAVixLqDEFp2l0Xcu2LK6+8IqAN/LOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UX9hToTq; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UX9hToTq"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a374f727dbso3447351f8f.0
        for <linux-crypto@vger.kernel.org>; Sun, 01 Jun 2025 23:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748847012; x=1749451812; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SK0IyySBRZW3kx89rtPTvWUvyucit05wnIbR/YG6Fpo=;
        b=UX9hToTqmVWmGmWGjkFtBxBJScqwkgix4XoHn5ryQZvoYdSkYGfcfeArOVOOAtEM+Z
         Cm51o7BNSqTMvAM8RvqruRIhApj8U9icEMUIpocLz3L2MTZcuQ3hL9e+W2Fks0Qz7RG7
         kiaUE3gtK9wuUYOOVlqW6b4Fxmh4q5T9Hctwv5QYcj1rcLz8wRppqTHC+2QdrmKZtXSL
         gY0NUQrua0qKxhzr251j2uKSIZtijh6dc3HuCESz+39bvRLU6A1EqkPpJWQFbcwPytgM
         Ct7bECSS7h/NdRk2hq7pwSJqrS7MXrj7W/GLplE6e7YDzubFEBzQyXVZ/jz54QzmOt+z
         NHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748847012; x=1749451812;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SK0IyySBRZW3kx89rtPTvWUvyucit05wnIbR/YG6Fpo=;
        b=BYplOG113qL2y/PqwZ1bugdup7PMIrlW93kO29bzb2WAPyx0KgI32AbWYSLcLcJa0e
         CBNh3c8mlVegj30xgaoBytbvgHBEc1g1Lna6/MAdRmmFDNA/0LM6BaCEcyi0E/FAPpzq
         K+Fj5OxFBSo4EVKwqkDzYkNTqZGo4BlnS8EGdPkvLEmoBJRmxfR/I5S813RR/xU9zI9/
         7U10BBkobm9cbiCRHNuP7Tdt5WQIr0piizuUND7rL/ou7PW+LsRCIqzIutQMYXxdt1hB
         17NYHInNBo2ZvdyIwmVtwn79kaY+t6CGOeQ68InNRZGTEfbMdRAPjLcG6cz+38kZKk29
         rlyg==
X-Forwarded-Encrypted: i=1; AJvYcCXxhGVk8YXP1IGqeWjyPhTqnyewRVVbOAiuqg4wQxAb+/l38KE82FO5PgOmNc0Kil7GwSTRxtsiLOUHiPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuvOJHGuiFNbL+InKUs3EX328ypQj/C+aCdd4oRn1IT8sXIRw0
	sbXXpns6YocSQ2JZtPxf8Lfvyjsc0YFGwzqbZmxTOdhkxfvHLwnkHjPV7aPGs4KOhlw=
X-Gm-Gg: ASbGnct3peGWFexU/CVqGvvf214+kC6IuLxsoGH2eQ1Jfqwr3EXHC+UlGV1Q+8CWWE4
	ZWNLbQ0Tr+0M2Hr03I+d0T3l+1vMjZsekiX29YbFuh4eaf6ldAj/PdN/ejm3LZ9MXXg5CaLWF/S
	as0oNIpmTmpxb91dR3ENEDMu/rtYL6aXCW/L+PXRMdJq1ZF3Js/V1Evol/MUMopBinyU4ONABKs
	sYqtbnNMspvqvXdh3D5SzEr0DXe+Xl7M7Qcw9UzNCyp6MSkII8941RbfbPNkiS3umvcUBA615gR
	+TB9N8iewSLeE8vmJlCJteMyUVthM9n17y8DUUX23uYm06ze/e8o+aU=
X-Google-Smtp-Source: AGHT+IEZR8tQifVwfY35OyZRO4tFwJdgXpdkuSPBQCXC2PRdUrJ5MhzKClOt7HCXAkUO8ONJz6PuGg==
X-Received: by 2002:a05:6000:2888:b0:3a3:760c:81b7 with SMTP id ffacd0b85a97d-3a4f89df572mr8120211f8f.57.1748847012124;
        Sun, 01 Jun 2025 23:50:12 -0700 (PDT)
Received: from localhost ([41.210.143.146])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a4f009ff11sm13526519f8f.86.2025.06.01.23.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jun 2025 23:50:11 -0700 (PDT)
Date: Mon, 2 Jun 2025 09:50:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Harsh Jain <h.jain@amd.com>,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	mounika.botcha@amd.com, sarat.chand.savitala@amd.com,
	mohan.dhanawade@amd.com, michal.simek@amd.com
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Harsh Jain <h.jain@amd.com>
Subject: Re: [PATCH 3/3] crypto: drbg: Export CTR DRBG DF functions
Message-ID: <202505311325.22fIOcCt-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250529113116.669667-4-h.jain@amd.com>

Hi Harsh,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Harsh-Jain/dt-bindings-crypto-Add-node-for-True-Random-Number-Generator/20250529-193255
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250529113116.669667-4-h.jain%40amd.com
patch subject: [PATCH 3/3] crypto: drbg: Export CTR DRBG DF functions
config: s390-randconfig-r073-20250531 (https://download.01.org/0day-ci/archive/20250531/202505311325.22fIOcCt-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project f819f46284f2a79790038e1f6649172789734ae8)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202505311325.22fIOcCt-lkp@intel.com/

smatch warnings:
drivers/crypto/xilinx/xilinx-trng.c:368 xtrng_probe() warn: missing unwind goto?

vim +368 drivers/crypto/xilinx/xilinx-trng.c

940a39f34689c6 Harsh Jain 2025-05-29  334  static int xtrng_probe(struct platform_device *pdev)
940a39f34689c6 Harsh Jain 2025-05-29  335  {
940a39f34689c6 Harsh Jain 2025-05-29  336  	struct xilinx_rng *rng;
bf8ac5fe42abd6 Harsh Jain 2025-05-29  337  	size_t sb_size;
940a39f34689c6 Harsh Jain 2025-05-29  338  	int ret;
940a39f34689c6 Harsh Jain 2025-05-29  339  
940a39f34689c6 Harsh Jain 2025-05-29  340  	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
940a39f34689c6 Harsh Jain 2025-05-29  341  	if (!rng)
940a39f34689c6 Harsh Jain 2025-05-29  342  		return -ENOMEM;
940a39f34689c6 Harsh Jain 2025-05-29  343  
940a39f34689c6 Harsh Jain 2025-05-29  344  	rng->dev = &pdev->dev;
940a39f34689c6 Harsh Jain 2025-05-29  345  	rng->rng_base = devm_platform_ioremap_resource(pdev, 0);
940a39f34689c6 Harsh Jain 2025-05-29  346  	if (IS_ERR(rng->rng_base)) {
940a39f34689c6 Harsh Jain 2025-05-29  347  		dev_err(&pdev->dev, "Failed to map resource %ld\n", PTR_ERR(rng->rng_base));
940a39f34689c6 Harsh Jain 2025-05-29  348  		return PTR_ERR(rng->rng_base);
940a39f34689c6 Harsh Jain 2025-05-29  349  	}
940a39f34689c6 Harsh Jain 2025-05-29  350  
bf8ac5fe42abd6 Harsh Jain 2025-05-29  351  	rng->tfm = crypto_alloc_cipher("aes", 0, 0);
bf8ac5fe42abd6 Harsh Jain 2025-05-29  352  	if (IS_ERR(rng->tfm)) {
bf8ac5fe42abd6 Harsh Jain 2025-05-29  353  		pr_info("DRBG: could not allocate cipher TFM handle:\n");
bf8ac5fe42abd6 Harsh Jain 2025-05-29  354  		return PTR_ERR(rng->tfm);
bf8ac5fe42abd6 Harsh Jain 2025-05-29  355  	}
bf8ac5fe42abd6 Harsh Jain 2025-05-29  356  
bf8ac5fe42abd6 Harsh Jain 2025-05-29  357  	sb_size = crypto_drbg_ctr_df_datalen(TRNG_SEED_LEN_BYTES, AES_BLOCK_SIZE);
bf8ac5fe42abd6 Harsh Jain 2025-05-29  358  	rng->scratchpadbuf = devm_kzalloc(&pdev->dev, sb_size, GFP_KERNEL);
bf8ac5fe42abd6 Harsh Jain 2025-05-29  359  	if (!rng->scratchpadbuf) {
bf8ac5fe42abd6 Harsh Jain 2025-05-29  360  		ret = -ENOMEM;
bf8ac5fe42abd6 Harsh Jain 2025-05-29  361  		goto cipher_cleanup;
bf8ac5fe42abd6 Harsh Jain 2025-05-29  362  	}
bf8ac5fe42abd6 Harsh Jain 2025-05-29  363  
940a39f34689c6 Harsh Jain 2025-05-29  364  	xtrng_trng_reset(rng->rng_base);
940a39f34689c6 Harsh Jain 2025-05-29  365  	ret = xtrng_reseed_internal(rng);
940a39f34689c6 Harsh Jain 2025-05-29  366  	if (ret) {
940a39f34689c6 Harsh Jain 2025-05-29  367  		dev_err(&pdev->dev, "TRNG Seed fail\n");
940a39f34689c6 Harsh Jain 2025-05-29 @368  		return ret;

goto cipher_cleanup;

940a39f34689c6 Harsh Jain 2025-05-29  369  	}
940a39f34689c6 Harsh Jain 2025-05-29  370  
940a39f34689c6 Harsh Jain 2025-05-29  371  	xilinx_rng_dev = rng;
940a39f34689c6 Harsh Jain 2025-05-29  372  	mutex_init(&rng->lock);
940a39f34689c6 Harsh Jain 2025-05-29  373  	ret = crypto_register_rng(&xtrng_trng_alg);
940a39f34689c6 Harsh Jain 2025-05-29  374  	if (ret) {
940a39f34689c6 Harsh Jain 2025-05-29  375  		dev_err(&pdev->dev, "Crypto Random device registration failed: %d\n", ret);
bf8ac5fe42abd6 Harsh Jain 2025-05-29  376  		goto cipher_cleanup;
940a39f34689c6 Harsh Jain 2025-05-29  377  	}
bf8ac5fe42abd6 Harsh Jain 2025-05-29  378  
940a39f34689c6 Harsh Jain 2025-05-29  379  	ret = xtrng_hwrng_register(&rng->trng);
940a39f34689c6 Harsh Jain 2025-05-29  380  	if (ret) {
940a39f34689c6 Harsh Jain 2025-05-29  381  		dev_err(&pdev->dev, "HWRNG device registration failed: %d\n", ret);
940a39f34689c6 Harsh Jain 2025-05-29  382  		goto crypto_rng_free;
940a39f34689c6 Harsh Jain 2025-05-29  383  	}
940a39f34689c6 Harsh Jain 2025-05-29  384  	platform_set_drvdata(pdev, rng);
940a39f34689c6 Harsh Jain 2025-05-29  385  
940a39f34689c6 Harsh Jain 2025-05-29  386  	return 0;
940a39f34689c6 Harsh Jain 2025-05-29  387  
940a39f34689c6 Harsh Jain 2025-05-29  388  crypto_rng_free:
940a39f34689c6 Harsh Jain 2025-05-29  389  	crypto_unregister_rng(&xtrng_trng_alg);
940a39f34689c6 Harsh Jain 2025-05-29  390  
bf8ac5fe42abd6 Harsh Jain 2025-05-29  391  cipher_cleanup:
bf8ac5fe42abd6 Harsh Jain 2025-05-29  392  	crypto_free_cipher(rng->tfm);
bf8ac5fe42abd6 Harsh Jain 2025-05-29  393  
940a39f34689c6 Harsh Jain 2025-05-29  394  	return ret;
940a39f34689c6 Harsh Jain 2025-05-29  395  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

