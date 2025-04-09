Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6238325DAE3
	for <linux-crypto@vger.kernel.org>; Wed,  9 Apr 2025 10:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744196349; cv=none; b=VKDudvAjcgMxND4I2bGosnOU8KU9KfumGWTe8QIoCfZCkIjQ4wGeC60tVCNQ8+YGB2Yz6OcB+seibF6HGcjacIUISYjETQd3VIqr65kFIeODX7KOyL4e3AlVLYklB8YrWaFSD0Atqj0LkKVwKT9idp763mU7PL38QxuTLzybXNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744196349; c=relaxed/simple;
	bh=yZVgJyKOyVxMf18P43WCJzG5o9H/sxGUpm/YaLSPafg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ilf/oIXp8EZJhzPuW4JK2qLYe2yrqdAlu8HN7Fu+BTZlO7KQ5ff8ob51Hfr1cr86t6qgIgJjAGVqyfpoiuS2jTcRxSUIutso6hpAYQjE5Bc9gg1l3lofC4KiQttnqAEDbbddy3e7vYdSg2xMh+3K8hylyc6clqBXl1ctVvBpsYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SbJFv+V6; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SbJFv+V6"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39149bccb69so6209276f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 09 Apr 2025 03:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744196346; x=1744801146; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rp0QpgiUoyf8iyuqXo4YUnWomQqWX1wfBy0iYncrzTY=;
        b=SbJFv+V6dwK+0LxJvwNOrcZBOsJof+cBBzhlNcMw6p1GZskrdAEdk/x3e/3NwTM6AA
         BUXeZX6ihGSDvmiXuwmNaVuxrAp3HL5xbUGD6/CmHeS958SuYY9LMfEQUJe0BTLTwlQn
         2wi+niglVFW02c/Z2st5+fCV0mJj8XBpm9H/R4MoC3uV7TlwEYlwkMA2duWHIcGhJznr
         hqFFt42mJ23Gfw+A2QPpXvFqjsBdlk7Btv3dv02s8Q5IC4ew4Dj9cJe6B9U0kDin9mEs
         Rqs+NdXPdqWfRNZ/mmMDalLP4xQKianlrIvq3lYRL13F9OR6bgwAKgpq1ZufN8LYEP+e
         r8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744196346; x=1744801146;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rp0QpgiUoyf8iyuqXo4YUnWomQqWX1wfBy0iYncrzTY=;
        b=TPP3Hxi+Ooo3ikddrqs9BV7Y7pk1AGafvW1MWJsps82dMKTEDENfednuhgTsD5RmeS
         fVTXWOz+Zq6iXZrq0pFjiq8tgLB9yncSTiN3+U0AvvmWM+SR5w7WB9iJVA5jAHQlIbhx
         yVtLZ1OLxmhMsMeg64xz9cbKTPO6N3CjZP45X28fPfmQSz8igdWgESQFpRRbYskUWfNI
         wRTZguCQQ+0jC2t1Xs2o2ofCFSKGqtgSj5nMOUMgXnit4rSyPNoXZNkRuHWND94gLI24
         N/yy0hqE/F/aucnHmTWGfPCx9DRnASJt+1Q7W5Alanpy74gpq987z24/LnynNGKmLzYu
         84kw==
X-Gm-Message-State: AOJu0YzwTO0b+yyEUg/dise15IGbCnyNNbdrvKsk3ZjAV3Ll36PX99tk
	Fxkk1527oFLcOw9Pa6fMbN6LIwdLfgh+1v5vbt024hxlrbe8n2E8J4sX4CDsbvK92JO+8aW3R5U
	l
X-Gm-Gg: ASbGnctajKG4wm6gT/oXbyOYst6NbbBvG8tZeE7QhjSXZHcBdCxDQvKD3yPCtddfD4q
	BPpS4kL8DDzINhevxXL6ADmdeSeZKC4oyJJb0psyoG0ng1IaboxsJC212WR7yGelRSmx0Vfsl8X
	IL0A2DgcjTJBjgFm1qTYodhqXkzSoBtGhBUZgn4oYcLJJidZlG571pgIOycrLY6asWAKevId/8k
	VNFDloAfo5+pFxWqbvXwaeHajhfjVj2A5OQfnAzfEVgcDi9kIxOrTT4mY1gHO+5UMQRglXpVhG2
	VawpZnsfPdb50cGHr2JbRzXmepJUp+UlBkkxew+MFARPLg==
X-Google-Smtp-Source: AGHT+IFm3aRn4XSKJ6DwXLZtIJ5f2qVTrnkTsKDf1Ox3VffGFNnCdgfG+2SXN2xkf8YHh8eog8+T+g==
X-Received: by 2002:a05:6000:1a8a:b0:391:48d4:bd02 with SMTP id ffacd0b85a97d-39d87ab60e9mr2086456f8f.29.1744196345553;
        Wed, 09 Apr 2025 03:59:05 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-39d8936129dsm1327340f8f.18.2025.04.09.03.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 03:59:05 -0700 (PDT)
Date: Wed, 9 Apr 2025 13:59:01 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto: ccp - Move dev_info/err messages for SEV/SNP
 init and shutdown
Message-ID: <d9c2e79c-e26e-47b7-8243-ff6e7b101ec3@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Ashish Kalra,

Commit 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for
SEV/SNP init and shutdown") from Mar 24, 2025 (linux-next), leads to
the following Smatch static checker warning:

	drivers/crypto/ccp/sev-dev.c:1755 __sev_snp_shutdown_locked()
	error: uninitialized symbol 'dfflush_error'.

drivers/crypto/ccp/sev-dev.c
    1718 static int __sev_snp_shutdown_locked(int *error, bool panic)
    1719 {
    1720         struct psp_device *psp = psp_master;
    1721         struct sev_device *sev;
    1722         struct sev_data_snp_shutdown_ex data;
    1723         int ret;
    1724 
    1725         if (!psp || !psp->sev_data)
    1726                 return 0;
    1727 
    1728         sev = psp->sev_data;
    1729 
    1730         if (!sev->snp_initialized)
    1731                 return 0;
    1732 
    1733         memset(&data, 0, sizeof(data));
    1734         data.len = sizeof(data);
    1735         data.iommu_snp_shutdown = 1;
    1736 
    1737         /*
    1738          * If invoked during panic handling, local interrupts are disabled
    1739          * and all CPUs are stopped, so wbinvd_on_all_cpus() can't be called.
    1740          * In that case, a wbinvd() is done on remote CPUs via the NMI
    1741          * callback, so only a local wbinvd() is needed here.
    1742          */
    1743         if (!panic)
    1744                 wbinvd_on_all_cpus();
    1745         else
    1746                 wbinvd();
    1747 
    1748         ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
    1749         /* SHUTDOWN may require DF_FLUSH */
    1750         if (*error == SEV_RET_DFFLUSH_REQUIRED) {
    1751                 int dfflush_error;
    1752 
    1753                 ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, &dfflush_error);
    1754                 if (ret) {
--> 1755                         dev_err(sev->dev, "SEV-SNP DF_FLUSH failed, ret = %d, error = %#x\n",
    1756                                 ret, dfflush_error);
                                              ^^^^^^^^^^^^^
dfflush_error isn't necessarily initialized on error in
__sev_do_cmd_locked().

regards,
dan carpenter

    1757                         return ret;
    1758                 }
    1759                 /* reissue the shutdown command */
    1760                 ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data,
    1761                                           error);

