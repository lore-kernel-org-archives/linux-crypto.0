Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEB61422C7
	for <linux-crypto@vger.kernel.org>; Thu,  3 Oct 2024 11:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727954871; cv=none; b=EkKOgtpJT1ffdRsWqb1TucN2J4jmGgZsG22Tb6oqfuVUJ0jfVC3bSrvdQaxXKrUwTrYFU/6J5/vSqU/QP4hGpr61K5lZXo0ecwzYdZjo5rmzclSamDVJdcAuRiq/984S+om6xI6y+iCfVefZuc98PXRQCIOal1JLMTIaf76X6GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727954871; c=relaxed/simple;
	bh=Z/wE6vlPIxBH6LaOzwO/7U3nnPDqtFz/6PyjY83CPvw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=VaKDTmXaBg8RtXipHdzXGnr5h1HgwIZEUv+ItgmdGNaiCP59QhAHldhZ3TU6kmMqocXSrOnfz9PKIV/xND+jHvfvDll2SLEDYUjJrQEOxaQc5GFNJZ+P0eo/hJIhlQcziT0iTdjnitp9ykRdpOTJBPgGWaqwAMltzME8+5QK7VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oqhugZGa; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oqhugZGa"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42cbface8d6so10845825e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 03 Oct 2024 04:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727954866; x=1728559666; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qem65KOW9h0XHEqIvrOXeHfZuZNWOf4NfsS3cuje4Uc=;
        b=oqhugZGaoE94ortBzoKl9f+2yjZyJrRePFVcOmvMmhyWHvtRPMHjf55Y2bHEib6NM3
         yMG545/KQkPqNRPS81R6gMhg9p6Br/YNNvxYpIuqwDRAZTTA7pzAqmxR7agc/eDsm/SP
         aBtDAcz2CJTLssTTy4NW1T0MfwGGmQYwwM8DzQCc3DkJQgnmQgfKyxX+75bS1yllo/mq
         oFxIg1wyU/nAMgNetmcX6Cz/tDBDessNMCSF6rphUr22IGv8D06otdKaT5hTnbjhLRAT
         FpMCHLF83WQcaNsTzyoWe7jwO7w5jHxWEsf8tDj0nHohG98rVcDXB/Ke6SDumrOgbe27
         5hkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727954866; x=1728559666;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qem65KOW9h0XHEqIvrOXeHfZuZNWOf4NfsS3cuje4Uc=;
        b=fMdEhZIeP6mmtjLTTmrV6E85ceN+N0v9dmeorthhPZK4gWuC42f3G3wc0XkQJPRGZS
         5ULx46saOsM1TDTGnDcQvCV/RN9vwZf2fpv5jvjYHpmgUJKX4cZjcPlYdpnOW5wQKCQo
         4JVFRQUjHOJNJPigII2Wr+2vyX/bOCmeBJ3LE5YbKRcwtXKQjOovcPgyePTBkpZv19i1
         wCOTMJnAz7Oibo2q2Qw3QY/uzVOReo27qXGnQx5X741JrNdG3cGeUnZt/+kDe7wantYU
         SqB/DItUYD6Ean84m2vpqL3W4DXpIMOWJY9cNS+ZKZ5pDVHTktb34UMSkc0PytNEGZfV
         X74g==
X-Forwarded-Encrypted: i=1; AJvYcCVoUuwoRQrYv9H6i8JuRs4LsK3tXiruqI7/0LQhamg5E3epTeCR6b67Fo3gIZQCksl9DC27EOeqrsgXaFU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYBeiJHjxy2svMwhxDIF6ywmwu3Xm3wMrGTPruyGeBpkiufxpa
	XPKbkH8iHHsJv9A5O4+ccHmQ/FCXpAnbNxRpRekSMwBUNqPI92T6srUxKCtggJs=
X-Google-Smtp-Source: AGHT+IEEmiRO7XNga2R0AbTWwcKrW4gQGuckB9cWDC35qKZ6RovrhXFw2RQNIFfDGFsMFgKWwBKiFg==
X-Received: by 2002:a05:600c:3581:b0:42c:b508:750e with SMTP id 5b1f17b1804b1-42f777ba30cmr58372725e9.11.1727954866397;
        Thu, 03 Oct 2024 04:27:46 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f79d8d3bcsm42549325e9.5.2024.10.03.04.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 04:27:45 -0700 (PDT)
Date: Thu, 3 Oct 2024 14:27:42 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Rosen Penev <rosenp@gmail.com>,
	linux-crypto@vger.kernel.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rosen Penev <rosenp@gmail.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] crypto: cesa: use enabled variants for clk_get
Message-ID: <7f2b38c2-f9bc-4030-8cb7-6042760d4992@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001232547.355947-3-rosenp@gmail.com>

Hi Rosen,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rosen-Penev/crypto-cesa-add-COMPILE_TEST/20241002-072835
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20241001232547.355947-3-rosenp%40gmail.com
patch subject: [PATCH 2/5] crypto: cesa: use enabled variants for clk_get
config: um-randconfig-r073-20241003 (https://download.01.org/0day-ci/archive/20241003/202410031841.JyZSemmn-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202410031841.JyZSemmn-lkp@intel.com/

smatch warnings:
drivers/crypto/marvell/cesa/cesa.c:517 mv_cesa_probe() warn: missing error code 'ret'

vim +/ret +517 drivers/crypto/marvell/cesa/cesa.c

f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  432  static int mv_cesa_probe(struct platform_device *pdev)
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  433  {
0bf6948995f9f7 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  434  	const struct mv_cesa_caps *caps = &orion_caps;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  435  	const struct mbus_dram_target_info *dram;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  436  	const struct of_device_id *match;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  437  	struct device *dev = &pdev->dev;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  438  	struct mv_cesa_dev *cesa;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  439  	struct mv_cesa_engine *engines;
28ee8b0912ca2f drivers/crypto/marvell/cesa/cesa.c Sven Auhagen    2020-07-21  440  	int irq, ret, i, cpu;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  441  	u32 sram_size;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  442  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  443  	if (cesa_dev) {
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  444  		dev_err(&pdev->dev, "Only one CESA device authorized\n");
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  445  		return -EEXIST;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  446  	}
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  447  
0bf6948995f9f7 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  448  	if (dev->of_node) {
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  449  		match = of_match_node(mv_cesa_of_match_table, dev->of_node);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  450  		if (!match || !match->data)
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  451  			return -ENOTSUPP;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  452  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  453  		caps = match->data;
0bf6948995f9f7 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  454  	}
0bf6948995f9f7 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  455  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  456  	cesa = devm_kzalloc(dev, sizeof(*cesa), GFP_KERNEL);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  457  	if (!cesa)
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  458  		return -ENOMEM;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  459  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  460  	cesa->caps = caps;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  461  	cesa->dev = dev;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  462  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  463  	sram_size = CESA_SA_DEFAULT_SRAM_SIZE;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  464  	of_property_read_u32(cesa->dev->of_node, "marvell,crypto-sram-size",
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  465  			     &sram_size);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  466  	if (sram_size < CESA_SA_MIN_SRAM_SIZE)
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  467  		sram_size = CESA_SA_MIN_SRAM_SIZE;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  468  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  469  	cesa->sram_size = sram_size;
a86854d0c599b3 drivers/crypto/marvell/cesa.c      Kees Cook       2018-06-12  470  	cesa->engines = devm_kcalloc(dev, caps->nengines, sizeof(*engines),
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  471  				     GFP_KERNEL);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  472  	if (!cesa->engines)
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  473  		return -ENOMEM;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  474  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  475  	spin_lock_init(&cesa->lock);
bf8f91e711926c drivers/crypto/marvell/cesa.c      Romain Perier   2016-06-21  476  
3cea6b36a43405 drivers/crypto/marvell/cesa/cesa.c Zhang Qilong    2020-09-17  477  	cesa->regs = devm_platform_ioremap_resource_byname(pdev, "regs");
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  478  	if (IS_ERR(cesa->regs))
dfe97ad30e8c03 drivers/crypto/marvell/cesa.c      Boris Brezillon 2016-03-17  479  		return PTR_ERR(cesa->regs);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  480  
db509a45339fd7 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  481  	ret = mv_cesa_dev_dma_init(cesa);
db509a45339fd7 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  482  	if (ret)
db509a45339fd7 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  483  		return ret;
db509a45339fd7 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  484  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  485  	dram = mv_mbus_dram_info_nooverlap();
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  486  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  487  	platform_set_drvdata(pdev, cesa);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  488  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  489  	for (i = 0; i < caps->nengines; i++) {
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  490  		struct mv_cesa_engine *engine = &cesa->engines[i];
0501d0d1494900 drivers/crypto/marvell/cesa/cesa.c Herbert Xu      2023-10-27  491  		char res_name[16];
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  492  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  493  		engine->id = i;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  494  		spin_lock_init(&engine->lock);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  495  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  496  		ret = mv_cesa_get_sram(pdev, i);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  497  		if (ret)
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  498  			goto err_cleanup;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  499  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  500  		irq = platform_get_irq(pdev, i);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  501  		if (irq < 0) {
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  502  			ret = irq;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  503  			goto err_cleanup;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  504  		}
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  505  
28ee8b0912ca2f drivers/crypto/marvell/cesa/cesa.c Sven Auhagen    2020-07-21  506  		engine->irq = irq;
28ee8b0912ca2f drivers/crypto/marvell/cesa/cesa.c Sven Auhagen    2020-07-21  507  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  508  		/*
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  509  		 * Not all platforms can gate the CESA clocks: do not complain
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  510  		 * if the clock does not exist.
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  511  		 */
0501d0d1494900 drivers/crypto/marvell/cesa/cesa.c Herbert Xu      2023-10-27  512  		snprintf(res_name, sizeof(res_name), "cesa%u", i);
4d5eba631bcc35 drivers/crypto/marvell/cesa/cesa.c Rosen Penev     2024-10-01  513  		engine->clk = devm_clk_get_optional_enabled(dev, res_name);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  514  		if (IS_ERR(engine->clk)) {
4d5eba631bcc35 drivers/crypto/marvell/cesa/cesa.c Rosen Penev     2024-10-01  515  			engine->clk = devm_clk_get_optional_enabled(dev, NULL);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  516  			if (IS_ERR(engine->clk))
4d5eba631bcc35 drivers/crypto/marvell/cesa/cesa.c Rosen Penev     2024-10-01 @517  				goto err_cleanup;

ret = PTR_ERR(engine->clk);

f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  518  		}
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  519  
0501d0d1494900 drivers/crypto/marvell/cesa/cesa.c Herbert Xu      2023-10-27  520  		snprintf(res_name, sizeof(res_name), "cesaz%u", i);
4d5eba631bcc35 drivers/crypto/marvell/cesa/cesa.c Rosen Penev     2024-10-01  521  		engine->zclk = devm_clk_get_optional_enabled(dev, res_name);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  522  		if (IS_ERR(engine->zclk))
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  523  			goto err_cleanup;

ret = PTR_ERR(engine->zclk);

f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  524  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  525  		engine->regs = cesa->regs + CESA_ENGINE_OFF(i);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  526  
db509a45339fd7 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  527  		if (dram && cesa->caps->has_tdma)
21ec757d2dd865 drivers/crypto/marvell/cesa.c      Romain Perier   2016-04-19  528  			mv_cesa_conf_mbus_windows(engine, dram);
db509a45339fd7 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  529  
21ec757d2dd865 drivers/crypto/marvell/cesa.c      Romain Perier   2016-04-19  530  		writel(0, engine->regs + CESA_SA_INT_STATUS);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  531  		writel(CESA_SA_CFG_STOP_DIG_ERR,
21ec757d2dd865 drivers/crypto/marvell/cesa.c      Romain Perier   2016-04-19  532  		       engine->regs + CESA_SA_CFG);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  533  		writel(engine->sram_dma & CESA_SA_SRAM_MSK,
21ec757d2dd865 drivers/crypto/marvell/cesa.c      Romain Perier   2016-04-19  534  		       engine->regs + CESA_SA_DESC_P0);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  535  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  536  		ret = devm_request_threaded_irq(dev, irq, NULL, mv_cesa_int,
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  537  						IRQF_ONESHOT,
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  538  						dev_name(&pdev->dev),
21ec757d2dd865 drivers/crypto/marvell/cesa.c      Romain Perier   2016-04-19  539  						engine);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  540  		if (ret)
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  541  			goto err_cleanup;
bf8f91e711926c drivers/crypto/marvell/cesa.c      Romain Perier   2016-06-21  542  
28ee8b0912ca2f drivers/crypto/marvell/cesa/cesa.c Sven Auhagen    2020-07-21  543  		/* Set affinity */
28ee8b0912ca2f drivers/crypto/marvell/cesa/cesa.c Sven Auhagen    2020-07-21  544  		cpu = cpumask_local_spread(engine->id, NUMA_NO_NODE);
28ee8b0912ca2f drivers/crypto/marvell/cesa/cesa.c Sven Auhagen    2020-07-21  545  		irq_set_affinity_hint(irq, get_cpu_mask(cpu));
28ee8b0912ca2f drivers/crypto/marvell/cesa/cesa.c Sven Auhagen    2020-07-21  546  
bf8f91e711926c drivers/crypto/marvell/cesa.c      Romain Perier   2016-06-21  547  		crypto_init_queue(&engine->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
bf8f91e711926c drivers/crypto/marvell/cesa.c      Romain Perier   2016-06-21  548  		atomic_set(&engine->load, 0);
85030c5168f1df drivers/crypto/marvell/cesa.c      Romain Perier   2016-06-21  549  		INIT_LIST_HEAD(&engine->complete_queue);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  550  	}
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  551  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  552  	cesa_dev = cesa;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  553  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  554  	ret = mv_cesa_add_algs(cesa);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  555  	if (ret) {
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  556  		cesa_dev = NULL;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  557  		goto err_cleanup;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  558  	}
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  559  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  560  	dev_info(dev, "CESA device successfully registered\n");
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  561  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  562  	return 0;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  563  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  564  err_cleanup:
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  565  	for (i = 0; i < caps->nengines; i++) {
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  566  		mv_cesa_put_sram(pdev, i);
28ee8b0912ca2f drivers/crypto/marvell/cesa/cesa.c Sven Auhagen    2020-07-21  567  		if (cesa->engines[i].irq > 0)
28ee8b0912ca2f drivers/crypto/marvell/cesa/cesa.c Sven Auhagen    2020-07-21  568  			irq_set_affinity_hint(cesa->engines[i].irq, NULL);
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  569  	}
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  570  
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  571  	return ret;
f63601fd616ab3 drivers/crypto/marvell/cesa.c      Boris Brezillon 2015-06-18  572  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

