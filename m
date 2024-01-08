Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647A81170A
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jan 2024 09:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vcnbPif6"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40e43e489e4so12930495e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jan 2024 01:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704706007; x=1705310807; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S2SS3mWBtdGH2dbT6gPsZGk8mJr7dIMPmHn982oUoew=;
        b=vcnbPif6BTlvj/s5WlmvMJPvXsTqNsfN1HLaxsKcibbiNR9iOkY5YyVWQ/Di3p7go1
         FO23N3Ry9tMVqZJD67JKr8B2tuKc33mpAae89wtWnxeEo4SquVQmbnyBHNqqCet9oeKM
         UWWuJX1QrYuD/hdZ4McKmQk8THobjTee+8HnWr29DubarRD7YPmo7FHUh4S/CJ4SPrVy
         1E+Xe0FPJUGVwPpeGKCbKaHNakwEico7Lm+hg7O+eYRJvWQK6NCD74leL4pt9iFV03kv
         oRpK0N9R1L2TYwOff64PdHcbePqwOkb5OB5SUDkxTgic+uXrHlFP3hlYOG7D7UJ7blrz
         B8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704706007; x=1705310807;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S2SS3mWBtdGH2dbT6gPsZGk8mJr7dIMPmHn982oUoew=;
        b=Eq2KN6AqokW67cJMjulKCdA3XOyQ19YmvtCEmOpqRy5tD/+nwUl/H9wk84LyXrJ7jl
         TsFV+jQ5bj2cXwrXd0qFUCZAjKVrN2abGThsx2t2mSdeT2W9s8LiUUuwSdIQCxBayXe0
         MH9RnqMQtCzXtZ3J1N3xXEE9ii4ckcAGdj/D4fDRo1dCTwtoxX6i6nPLXQD0q0MYzDSJ
         T0JMe/2Bf4kN9WzKuyGeIkpizIUViw3ZFig1y3BgDHNyp3sl9P60WteKr1H9ckwpAfzp
         n1QSy0g5AXUFH8RgtsrkyVhGaeb6jk4a618zoMv14mpblUnpTkMlq4rZqtfqv4hSpcGw
         ixEw==
X-Gm-Message-State: AOJu0Yz/JEUFMPEWmdkwzdK1IWTj/W7BU8TcVKuLFVGl72AjqxtdtToE
	fVECJYbVIhqPiWodUhj1Dj90EnDowniiDQ==
X-Google-Smtp-Source: AGHT+IFOYdkNYKGv/hwC043c5WWLbAui7ofghqK2cXAiRghCwI/k+ZWA3xcuObt1THg3dWxy0GG+Vw==
X-Received: by 2002:a05:600c:19d2:b0:40e:3bba:8089 with SMTP id u18-20020a05600c19d200b0040e3bba8089mr1831556wmq.186.1704706007635;
        Mon, 08 Jan 2024 01:26:47 -0800 (PST)
Received: from localhost ([102.140.209.237])
        by smtp.gmail.com with ESMTPSA id d1-20020adfa341000000b0033662fb321esm7310089wrb.33.2024.01.08.01.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 01:26:47 -0800 (PST)
Date: Mon, 8 Jan 2024 12:26:42 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: tom.zanussi@linux.intel.com
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto: iaa - Add compression mode management along
 with fixed mode
Message-ID: <05696b53-c6ff-45e5-a3f1-d8f407a60050@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Tom Zanussi,

The patch b190447e0fa3: "crypto: iaa - Add compression mode
management along with fixed mode" from Dec 5, 2023 (linux-next),
leads to the following Smatch static checker warning:

	drivers/crypto/intel/iaa/iaa_crypto_main.c:532 init_device_compression_mode()
	error: not allocating enough for = 'device_mode->aecs_decomp_table' 5352 vs 1600

drivers/crypto/intel/iaa/iaa_crypto_main.c
    510 static int init_device_compression_mode(struct iaa_device *iaa_device,
    511                                         struct iaa_compression_mode *mode,
    512                                         int idx, struct idxd_wq *wq)
    513 {
    514         size_t size = sizeof(struct aecs_comp_table_record) + IAA_AECS_ALIGN;
    515         struct device *dev = &iaa_device->idxd->pdev->dev;
    516         struct iaa_device_compression_mode *device_mode;
    517         int ret = -ENOMEM;
    518 
    519         device_mode = kzalloc(sizeof(*device_mode), GFP_KERNEL);
    520         if (!device_mode)
    521                 return -ENOMEM;
    522 
    523         device_mode->name = kstrdup(mode->name, GFP_KERNEL);
    524         if (!device_mode->name)
    525                 goto free;
    526 
    527         device_mode->aecs_comp_table = dma_alloc_coherent(dev, size,
    528                                                           &device_mode->aecs_comp_table_dma_addr, GFP_KERNEL);
    529         if (!device_mode->aecs_comp_table)
    530                 goto free;
    531 
--> 532         device_mode->aecs_decomp_table = dma_alloc_coherent(dev, size,
                                  ^^^^^^
comp and decomp sizes are different.  So we should be allocating
aecs_decomp_table_record + IAA_AECS_ALIGN here probably.

    533                                                             &device_mode->aecs_decomp_table_dma_addr, GFP_KERNEL);
    534         if (!device_mode->aecs_decomp_table)
    535                 goto free;
    536 
    537         /* Add Huffman table to aecs */
    538         memset(device_mode->aecs_comp_table, 0, sizeof(*device_mode->aecs_comp_table));
    539         memcpy(device_mode->aecs_comp_table->ll_sym, mode->ll_table, mode->ll_table_size);
    540         memcpy(device_mode->aecs_comp_table->d_sym, mode->d_table, mode->d_table_size);
    541 

regards,
dan carpenter
