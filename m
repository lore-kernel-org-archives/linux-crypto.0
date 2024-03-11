Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69EBFC17
	for <linux-crypto@vger.kernel.org>; Mon, 11 Mar 2024 07:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710142848; cv=none; b=t0IHTrgNjPCJ1dJPreH2r1cOTSQd8Fxu9JxSrGKxxWOSay9Md7V5/1P92bFWXYlvFOGJzBq2eQJK/hvA0rxI5TO49moRmvyJsivpWA9pT6DDOErXVxswepwlcF0oyZxgGZOsD0Jf6FQ2G6i3yB5CmRoOVd7gtv5M+MZs4ADKSsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710142848; c=relaxed/simple;
	bh=xQOsuiwh4tTpYKJAUKw8q/WwBDBZDhpNlMtr5qqHVSY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=uKbXSofyYjlQCirPyNPmYGVcdLcMwjPrRzkaSlKG+c9NzibDtd/ykd7BR0DIaBFiuXuJuI7LIhMZ9vBSZrHsdDR0W0xMIRzqkY07T/hw290m3AvGhWkw5L3yt2L/hA05jWbayj5TKF0IVbfncPPW+SyTjwZULWL70w1POOdQwpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CIkRV3KD; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CIkRV3KD"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-33e8b957a89so755597f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Mar 2024 00:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1710142845; x=1710747645; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eVclaOUNNQHaiMY4OSjqHr11jriWi56sAbG66uxHGtw=;
        b=CIkRV3KD/P7C1wPiN2bRZ95UFRJ2yqN6+B+K7sCURHd2SglWD03ZghwtdYUkLpVfca
         Ux6lOCKcxXN0Dyt/ERcGTF/TlQYOr7H8aXu+YyOYiwIHdLoh527F46ISk45Cw5b5VG0w
         rVWKYbxp0HO9/gG7TgufAdDpqpep4YaqQ0xZ9Ljy39pcoy2zFKUJOU/LDMx+C1+4D7fe
         OAYvxx48pwoR30SVTa6eH37Nl/ReqOX48PgbJBoo5xXZmrWwz2R3shOE00TszKobhyZI
         2jH4nW7zsVDN2zwIjNMKO4+divrUOMh2wbhyq+LM9CQmvS9u3TkGh2BVt08tEgWKS5Wn
         KLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710142845; x=1710747645;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eVclaOUNNQHaiMY4OSjqHr11jriWi56sAbG66uxHGtw=;
        b=GW93ljlqEhDncMGFLgeTroDsExImZjkpObCZ3c3cXLrepbDecD74kAD8nK60zyp1el
         RYSB0F37hx8YUthkH62ezMvnID9kGMZNVutUEdkKs7AOFA8d/q5xle2aKz4QKKJt4vZq
         HY9+RNrT8LqWVZI1UwNSu24sO5H7We+CxOC5d/hFoIUVWbS55dL4sx4EhBpLOPEaf7PN
         5d+kDUCgzuiPHpqISDdiBNI9vopbrKIaMSj74J736B6VPCqMLYAJ1NlCGH4b8cWq2y8V
         r4rNwLfysBOmEB6DpHvzEmx/tABIWcTSsNrPGgD8ICDAbirl1UnbViyAIIRJtaJQrx9Q
         INew==
X-Forwarded-Encrypted: i=1; AJvYcCXybVprZg4Ex1O/KNMAIhI4k6p8nzMSGaUDz20rtNW12x3d1TmNM4WE+7MnE9dXbiCLDWAJa4C/GJrFIh3XeHy5MWm6eJrSOAKzOehP
X-Gm-Message-State: AOJu0YxGI8IpSlKNJSSZ//Dvj9A6f8ZP9pFgIiD1eyXhCuQixP02rHPE
	tek4pnPboQL4ORdXe3dieaxqQ0ihZMGZWAcjOmg5yHwIiv/84quHxOhYJe2AtR0=
X-Google-Smtp-Source: AGHT+IFG3p9i/GwaORQw7AYMiRkBM4TiCq3dT5JLYVfKV1sF2G2FrxnJTk2xGSHyD4QUmmll6vYqGg==
X-Received: by 2002:adf:ef43:0:b0:33d:71e5:f556 with SMTP id c3-20020adfef43000000b0033d71e5f556mr4606485wrp.27.1710142844925;
        Mon, 11 Mar 2024 00:40:44 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id z2-20020a5d6402000000b0033dedd63382sm5649639wru.101.2024.03.11.00.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 00:40:44 -0700 (PDT)
Date: Mon, 11 Mar 2024 10:40:40 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and
 Makefile file
Message-ID: <1f00d2ad-185e-4f02-a20f-0e9b101add50@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305112831.3380896-5-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPAcc-driver-to-Linux-kernel/20240305-193337
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20240305112831.3380896-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
config: i386-randconfig-141-20240308 (https://download.01.org/0day-ci/archive/20240311/202403111044.eqxBgcDl-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202403111044.eqxBgcDl-lkp@intel.com/

New smatch warnings:
drivers/crypto/dwc-spacc/spacc_skcipher.c:176 spacc_cipher_cb() warn: was && intended here instead of ||?
drivers/crypto/dwc-spacc/spacc_aead.c:1131 spacc_aead_process() error: uninitialized symbol 'ptaadsize'.

vim +176 drivers/crypto/dwc-spacc/spacc_skcipher.c

6ad822cec22644 Pavitrakumar M 2024-03-05  146  static void spacc_cipher_cb(void *spacc, void *tfm)
6ad822cec22644 Pavitrakumar M 2024-03-05  147  {
6ad822cec22644 Pavitrakumar M 2024-03-05  148  	struct cipher_cb_data *cb = tfm;
6ad822cec22644 Pavitrakumar M 2024-03-05  149  	int err = -1, rc;
6ad822cec22644 Pavitrakumar M 2024-03-05  150  	int total_len;
6ad822cec22644 Pavitrakumar M 2024-03-05  151  	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(cb->req);
6ad822cec22644 Pavitrakumar M 2024-03-05  152  
6ad822cec22644 Pavitrakumar M 2024-03-05  153  	u32 status_reg = readl(cb->spacc->regmap + SPACC_REG_STATUS);
6ad822cec22644 Pavitrakumar M 2024-03-05  154  	u32 status_ret = (status_reg >> 24) & 0x03;
6ad822cec22644 Pavitrakumar M 2024-03-05  155  
6ad822cec22644 Pavitrakumar M 2024-03-05  156  	if (ctx->mode == CRYPTO_MODE_DES_CBC ||
6ad822cec22644 Pavitrakumar M 2024-03-05  157  	    ctx->mode == CRYPTO_MODE_3DES_CBC) {
6ad822cec22644 Pavitrakumar M 2024-03-05  158  		rc = spacc_read_context(cb->spacc, cb->tctx->handle,
6ad822cec22644 Pavitrakumar M 2024-03-05  159  					SPACC_CRYPTO_OPERATION, NULL, 0,
6ad822cec22644 Pavitrakumar M 2024-03-05  160  					cb->req->iv, 8);
6ad822cec22644 Pavitrakumar M 2024-03-05  161  	} else if (ctx->mode != CRYPTO_MODE_DES_ECB  &&
6ad822cec22644 Pavitrakumar M 2024-03-05  162  		   ctx->mode != CRYPTO_MODE_3DES_ECB &&
6ad822cec22644 Pavitrakumar M 2024-03-05  163  		   ctx->mode != CRYPTO_MODE_SM4_ECB  &&
6ad822cec22644 Pavitrakumar M 2024-03-05  164  		   ctx->mode != CRYPTO_MODE_AES_ECB  &&
6ad822cec22644 Pavitrakumar M 2024-03-05  165  		   ctx->mode != CRYPTO_MODE_SM4_XTS  &&
6ad822cec22644 Pavitrakumar M 2024-03-05  166  		   ctx->mode != CRYPTO_MODE_KASUMI_ECB) {
6ad822cec22644 Pavitrakumar M 2024-03-05  167  		if (status_ret == 0x3) {
6ad822cec22644 Pavitrakumar M 2024-03-05  168  			err = -EINVAL;
6ad822cec22644 Pavitrakumar M 2024-03-05  169  			goto REQ_DST_CP_SKIP;
6ad822cec22644 Pavitrakumar M 2024-03-05  170  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  171  		rc = spacc_read_context(cb->spacc, cb->tctx->handle,
6ad822cec22644 Pavitrakumar M 2024-03-05  172  					SPACC_CRYPTO_OPERATION, NULL, 0,
6ad822cec22644 Pavitrakumar M 2024-03-05  173  					cb->req->iv, 16);
6ad822cec22644 Pavitrakumar M 2024-03-05  174  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  175  
6ad822cec22644 Pavitrakumar M 2024-03-05 @176  	if (ctx->mode != CRYPTO_MODE_DES_ECB  ||
6ad822cec22644 Pavitrakumar M 2024-03-05  177  	    ctx->mode != CRYPTO_MODE_DES_CBC  ||
6ad822cec22644 Pavitrakumar M 2024-03-05  178  	    ctx->mode != CRYPTO_MODE_3DES_ECB ||
6ad822cec22644 Pavitrakumar M 2024-03-05  179  	    ctx->mode != CRYPTO_MODE_3DES_CBC) {

ctx->mode can't possibly be equal to multiple values at the same time
so this condition is always true.  && was intended.

6ad822cec22644 Pavitrakumar M 2024-03-05  180  		if (status_ret == 0x03) {
6ad822cec22644 Pavitrakumar M 2024-03-05  181  			err = -EINVAL;
6ad822cec22644 Pavitrakumar M 2024-03-05  182  			goto REQ_DST_CP_SKIP;
6ad822cec22644 Pavitrakumar M 2024-03-05  183  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  184  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  185  
6ad822cec22644 Pavitrakumar M 2024-03-05  186  	if (ctx->mode == CRYPTO_MODE_SM4_ECB && status_ret == 0x03) {
6ad822cec22644 Pavitrakumar M 2024-03-05  187  		err = -EINVAL;
6ad822cec22644 Pavitrakumar M 2024-03-05  188  		goto REQ_DST_CP_SKIP;
6ad822cec22644 Pavitrakumar M 2024-03-05  189  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  190  
6ad822cec22644 Pavitrakumar M 2024-03-05  191  	total_len = cb->req->cryptlen;
6ad822cec22644 Pavitrakumar M 2024-03-05  192  	if (ctx->mode == CRYPTO_MODE_SM4_XTS && total_len != 16) {
6ad822cec22644 Pavitrakumar M 2024-03-05  193  		if (status_ret == 0x03) {
6ad822cec22644 Pavitrakumar M 2024-03-05  194  			err = -EINVAL;
6ad822cec22644 Pavitrakumar M 2024-03-05  195  			goto REQ_DST_CP_SKIP;
6ad822cec22644 Pavitrakumar M 2024-03-05  196  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  197  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  198  
6ad822cec22644 Pavitrakumar M 2024-03-05  199  	dma_sync_sg_for_cpu(cb->tctx->dev, cb->req->dst, ctx->dst_nents,
6ad822cec22644 Pavitrakumar M 2024-03-05  200  				DMA_FROM_DEVICE);
6ad822cec22644 Pavitrakumar M 2024-03-05  201  
6ad822cec22644 Pavitrakumar M 2024-03-05  202  	err = cb->spacc->job[cb->new_handle].job_err;
6ad822cec22644 Pavitrakumar M 2024-03-05  203  REQ_DST_CP_SKIP:
6ad822cec22644 Pavitrakumar M 2024-03-05  204  	spacc_cipher_cleanup_dma(cb->tctx->dev, cb->req);
6ad822cec22644 Pavitrakumar M 2024-03-05  205  	spacc_close(cb->spacc, cb->new_handle);
6ad822cec22644 Pavitrakumar M 2024-03-05  206  
6ad822cec22644 Pavitrakumar M 2024-03-05  207  	/* call complete */
6ad822cec22644 Pavitrakumar M 2024-03-05  208  	skcipher_request_complete(cb->req, err);
6ad822cec22644 Pavitrakumar M 2024-03-05  209  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

