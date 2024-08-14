Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4BF1B3F20
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 15:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723650095; cv=none; b=LMwYoHz6lekIxa5vGV7vT3MT1bYamU9KRK9XAnlArcFSQYqBqLJqxnFuNTEUwdB2RYixKjtTnPQcMg65GGbZ1lNG5gYlenuCDNXWJ3mdRjNVLK/xs3aS3Z2Ka9n8Y/WXH7TV+y9a0pPxPQruzfj19lW8qD1d4eHtbqu+ewFy7KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723650095; c=relaxed/simple;
	bh=rxYyc8SzGUTUF/ML7nyoo7wyjufbFdzj9xkkg3nfPH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWAOYjH5pcM9GnRPtV1ujbKtodOQ5CahYbN983PYBjRAEgYOsdMEJIviYFRI6tj6XcdZBi9WxKWtQta27/RHZHEpSu98lXfsEfmNGY7C3GovEvY+AxPZcXXDo0HoV2wBfm0sKS1/EzX71t5bij5mosXWcQNr1r1imxgRZp8/eZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aj8C2oFl; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aj8C2oFl"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7a1da036d35so426429185a.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 08:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723650092; x=1724254892; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ehv0OrpAi4Ybcoc7/k5omNsEzvsrRrKb+8p0zvshduM=;
        b=aj8C2oFlP1/2RZ8Z4sfv2h+9PXofhfjtAti5fD/7FpyBtfEBMaDgylJeiiH6xDjNK1
         09Hm1Tuda5HUw0MzX3eZNlVYpUo2mfSMOgVJrD/tfm5o4j+t26fGJ/m1TREEv6GPxR3d
         WpNoPACECmjHs1iijzWJbNMSM1L7Z114doFL5/6ueManf6olh7ONH6JLN2qcfv2A+xYI
         0v0EHN9OiegR8VJ0f6Um+76CSWBPNb9kI1ckLtcyO6/4pTJmk45+Xy7AhaS8eNsAdgMD
         gaOPLNLIj+hs+4QW9XdIZC7q69/1upe+TuYQL/g1nqzEj9IDEEVzdmKDmMPZILtPa3Cz
         BdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723650092; x=1724254892;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ehv0OrpAi4Ybcoc7/k5omNsEzvsrRrKb+8p0zvshduM=;
        b=Yp2EDHclyl2FsUrXjqF45FFBVsv7LTaRh2w3zpYOZB/FxVABUh3eIfbqZVhhuOmJ5I
         bz+hjBRgpr9biADX4tKesdDbCjvUSiFYL24M8in+iIWC2pu7SK8t3g1mpjICi6rvHKRu
         oKyIH8P8hzYP6nlWsiI2iAWWaOIfXLSbhiXV0pz7o+QuLwS0YKeXrpEQ8Ul49RqC8904
         lnIpcvPDg5TmJBmuvxmSEUtnxTFa7H7vx+MbUrAFdQejUREPzHHO75rDWV4RpCU/4vtS
         3TrU9i2IlOpty9kwx2iB2Hpi6t2pcyQWrKHH30bEoYcWWt1+5RL4urup+TeUDuVkarhb
         5vTw==
X-Forwarded-Encrypted: i=1; AJvYcCXsbwAqA7TxEfiGLuKuXkpYjzV3VecKiuxeBlhiqjU1XcgRs3glsw/PxLO2GkqFFJV76/e5+4n72Kfw0+YiXCFQqidOFjlpMX/9syeV
X-Gm-Message-State: AOJu0YwNdSL9PQLtDaBckFmAu2F+Nv5qPDLCAYG8gebzTlg9JIes/+zx
	Fs+hu8VdK/hkQNjtMl1SoEm5+AvYE/mukwxQtfDamRqsR0vhe5UaGjdedz8te7k=
X-Google-Smtp-Source: AGHT+IFCyT86pZoX8nKAATRnRsJzOfq99T2bbI82/om2gAx0OPOZ8YQ9HNLA98iM0a/w0Eeg9kV+5A==
X-Received: by 2002:a05:620a:1910:b0:79f:11e9:92b3 with SMTP id af79cd13be357-7a4ee317f13mr349393885a.6.1723650092362;
        Wed, 14 Aug 2024 08:41:32 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7df8c1asm448507385a.90.2024.08.14.08.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 08:41:31 -0700 (PDT)
Date: Wed, 14 Aug 2024 18:41:26 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v7 1/6] Add SPAcc Skcipher support
Message-ID: <71335dac-d015-4c12-b47c-4564acf5796f@stanley.mountain>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <20240729041350.380633-2-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729041350.380633-2-pavitrakumarm@vayavyalabs.com>

On Mon, Jul 29, 2024 at 09:43:45AM +0530, Pavitrakumar M wrote:
> +int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb,
> +				int job_idx, struct pdu_ddt *src_ddt,
> +				struct pdu_ddt *dst_ddt, u32 proc_sz,
> +				uint32_t aad_offset, uint32_t pre_aad_sz,
> +				u32 post_aad_sz, uint32_t iv_offset,
> +				uint32_t prio)
> +{
> +	int i;
> +	struct spacc_job *job;
> +	int ret = CRYPTO_OK, proc_len;
> +
> +	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS)
> +		return -ENXIO;
> +
> +	switch (prio)  {
> +	case SPACC_SW_CTRL_PRIO_MED:
> +		if (spacc->config.cmd1_fifo_depth == 0)
> +			return -EINVAL;
> +		break;
> +	case SPACC_SW_CTRL_PRIO_LOW:
> +		if (spacc->config.cmd2_fifo_depth == 0)
> +			return -EINVAL;
> +		break;
> +	}
> +
> +	job = &spacc->job[job_idx];
> +	if (!job)
> +		return -EIO;
> +
> +	/* process any jobs in the jb*/
> +	if (use_jb && spacc_process_jb(spacc) != 0)
> +		goto fifo_full;
> +
> +	if (_spacc_fifo_full(spacc, prio)) {
> +		if (use_jb)
> +			goto fifo_full;
> +		else
> +			return -EBUSY;
> +	}
> +
> +	/* compute the length we must process, in decrypt mode
> +	 * with an ICV (hash, hmac or CCM modes)
> +	 * we must subtract the icv length from the buffer size
> +	 */
> +	if (proc_sz == SPACC_AUTO_SIZE) {
> +		proc_len = src_ddt->len;
> +
> +		if (job->op == OP_DECRYPT &&
> +		    (job->hash_mode > 0 ||
> +		     job->enc_mode == CRYPTO_MODE_AES_CCM ||
> +		     job->enc_mode == CRYPTO_MODE_AES_GCM)  &&
> +		    !(job->ctrl & SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC)))
> +			proc_len = src_ddt->len - job->icv_len;
> +	} else {
> +		proc_len = proc_sz;
> +	}
> +
> +	if (pre_aad_sz & SPACC_AADCOPY_FLAG) {
> +		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_AAD_COPY);
> +		pre_aad_sz &= ~(SPACC_AADCOPY_FLAG);
> +	} else {
> +		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_AAD_COPY);
> +	}
> +
> +	job->pre_aad_sz  = pre_aad_sz;
> +	job->post_aad_sz = post_aad_sz;
> +
> +	if (spacc->config.dma_type == SPACC_DMA_DDT) {
> +		pdu_io_cached_write(spacc->regmap + SPACC_REG_SRC_PTR,
> +				    (uint32_t)src_ddt->phys,
> +				    &spacc->cache.src_ptr);
> +		pdu_io_cached_write(spacc->regmap + SPACC_REG_DST_PTR,
> +				    (uint32_t)dst_ddt->phys,
> +				    &spacc->cache.dst_ptr);
> +	} else if (spacc->config.dma_type == SPACC_DMA_LINEAR) {
> +		pdu_io_cached_write(spacc->regmap + SPACC_REG_SRC_PTR,
> +				    (uint32_t)src_ddt->virt[0],
> +				    &spacc->cache.src_ptr);
> +		pdu_io_cached_write(spacc->regmap + SPACC_REG_DST_PTR,
> +				    (uint32_t)dst_ddt->virt[0],
> +				    &spacc->cache.dst_ptr);
> +	} else {
> +		return -EIO;
> +	}
> +
> +	pdu_io_cached_write(spacc->regmap + SPACC_REG_PROC_LEN,
> +			    proc_len - job->post_aad_sz,
> +			    &spacc->cache.proc_len);
> +	pdu_io_cached_write(spacc->regmap + SPACC_REG_ICV_LEN,
> +			    job->icv_len, &spacc->cache.icv_len);
> +	pdu_io_cached_write(spacc->regmap + SPACC_REG_ICV_OFFSET,
> +			    job->icv_offset, &spacc->cache.icv_offset);
> +	pdu_io_cached_write(spacc->regmap + SPACC_REG_PRE_AAD_LEN,
> +			    job->pre_aad_sz, &spacc->cache.pre_aad);
> +	pdu_io_cached_write(spacc->regmap + SPACC_REG_POST_AAD_LEN,
> +			    job->post_aad_sz, &spacc->cache.post_aad);
> +	pdu_io_cached_write(spacc->regmap + SPACC_REG_IV_OFFSET,
> +			    iv_offset, &spacc->cache.iv_offset);
> +	pdu_io_cached_write(spacc->regmap + SPACC_REG_OFFSET,
> +			    aad_offset, &spacc->cache.offset);
> +	pdu_io_cached_write(spacc->regmap + SPACC_REG_AUX_INFO,
> +			    AUX_DIR(job->auxinfo_dir) |
> +			    AUX_BIT_ALIGN(job->auxinfo_bit_align) |
> +			    AUX_CBC_CS(job->auxinfo_cs_mode),
> +			    &spacc->cache.aux);
> +
> +	if (job->first_use == 1) {
> +		writel(job->ckey_sz | SPACC_SET_KEY_CTX(job->ctx_idx),
> +		       spacc->regmap + SPACC_REG_KEY_SZ);
> +		writel(job->hkey_sz | SPACC_SET_KEY_CTX(job->ctx_idx),
> +		       spacc->regmap + SPACC_REG_KEY_SZ);
> +	}
> +
> +	job->job_swid = spacc->job_next_swid;
> +	spacc->job_lookup[job->job_swid] = job_idx;
> +	spacc->job_next_swid =
> +		(spacc->job_next_swid + 1) % SPACC_MAX_JOBS;
> +	writel(SPACC_SW_CTRL_ID_SET(job->job_swid) |
> +	       SPACC_SW_CTRL_PRIO_SET(prio),
> +	       spacc->regmap + SPACC_REG_SW_CTRL);
> +	writel(job->ctrl, spacc->regmap + SPACC_REG_CTRL);
> +
> +	/* Clear an expansion key after the first call*/
> +	if (job->first_use == 1) {
> +		job->first_use = 0;
> +		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_KEY_EXP);
> +	}
> +
> +	return ret;

Change this to return CRYPTO_OK and delete the ret variable.

> +
> +fifo_full:
> +	/* try to add a job to the job buffers*/
> +	i = spacc->jb_head + 1;
> +	if (i == SPACC_MAX_JOB_BUFFERS)
> +		i = 0;
> +
> +	if (i == spacc->jb_tail)
> +		return -EBUSY;
> +
> +	spacc->job_buffer[spacc->jb_head] = (struct spacc_job_buffer) {
> +		.active		= 1,
> +		.job_idx	= job_idx,
> +		.src		= src_ddt,
> +		.dst		= dst_ddt,
> +		.proc_sz	= proc_sz,
> +		.aad_offset	= aad_offset,
> +		.pre_aad_sz	= pre_aad_sz,
> +		.post_aad_sz	= post_aad_sz,
> +		.iv_offset	= iv_offset,
> +		.prio		= prio
> +	};
> +
> +	spacc->jb_head = i;
> +
> +	return CRYPTO_USED_JB;

What's the point of CRYPTO_USED_JB?  This is the only place it's referenced and
the callers just eventually do if (ret) ret = -EINVAL or something like that.
Nothing uses it.

regards,
dan carpenter


