Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7116D326
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jul 2024 15:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719848618; cv=none; b=JUdCRU7mt1D+rjFtwYXE3kTEul+U+I37eg3cagvrzehucOFkHq2JjJ3CLPlGmggY9Am+HW6XH4u3mCZioCaPMRF0xdh5P8IcAqkrx8w70iK/lxo1dLV1F/LP43Skj+E3keGlSW/BXclzlmiNsG9XdSSIfmnvvnk+0FJ12eZtsRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719848618; c=relaxed/simple;
	bh=zDEkERNJE/MSnzMdn8TBJ7WRg9m6LCkM9RUeIIHLeFU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Dqo1S9sEnmOnaTZdpmNklO+4AbgsZ1ydECLqmdC/DZjM3KwbVNCafH/1qA5SnE4RqWfYoGJ2t4MbBG4ng4aUzBqBGXDGGhDZ5qlDP9VZvDtQj10oWqIBpwUXHCPV0sZUOMqWdSiJ2k1xk7IvwJAVCw3D+wxRMiBAO4LLMi//5J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LSHkz8pE; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LSHkz8pE"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5b9778bb7c8so1723276eaf.3
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jul 2024 08:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719848616; x=1720453416; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9jzIOafebewEo1ZZHJ4C0Fr72HpACHosWsaCca63y70=;
        b=LSHkz8pEA8usG9xsuBrlgyijar4A8E/IhmCGZ9vhxLta3d308G6TZYvuT9Yci9BoIP
         PIjy1rmBBIUMcWUrCE28I3GmhZP86BzY1O48lJ8QpfgGlcCzo8DzxDc7HhNLWBuQcWJG
         rXKzr3v7BWl+RbheQxwJKMXKN5wCqYu72xikukJIq9ycDFjNtpcTRujDC5m0xwY4oF4r
         5HDzQs/BOvsomoTVTOAKqYK2DwcefSbeS3Dq4IkbqXi9lvVpGqr4uVkdONj4qSXIyxuB
         omtD7F8UPqMFGHXKFz9yoeezJsbEcgpQgD9xY1rGFtWYd2CFzxEife/qcy6/6I0vnrP9
         +xbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719848616; x=1720453416;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9jzIOafebewEo1ZZHJ4C0Fr72HpACHosWsaCca63y70=;
        b=cqh13aBRrrj02EAcbfbGKmuvUHjTglyuWNRwcxP3IiRxkzjEEOyooXrSVuivOnNuZE
         yhMLAsWl6Q+U2RvQbTMXGtbkglikQ0YkQr+YcFkiL7RS93VctH6OAWJkL9IxQFLqltqS
         oDyBviQfpXt41TZeUShImFDsoa4X8EoPP7ih9cYp0noomHTbsJY9HP94iGTAlmpD+oGj
         w71D80pL7ukdaBnTMlrjc4o2cXbi+OG8DzvrIAZSi3+0MeNoN2dWGwkD4lrND09LF9Un
         C7hrtgORCoJMc3YxjcGTvzSUVXH/nf34DN2Eide5tMC0joOFPk/MR0KvWmDn/NL+0vLN
         IFKg==
X-Forwarded-Encrypted: i=1; AJvYcCWDzw/ZvAbuN1284LKZO09ML6hYEijzPKNXRg8FapmNhy+CXTkI6pgMhBkKVty45c1aZfSWLnUS2T79yj8JdL4yu2jp9Csf7jIde/NL
X-Gm-Message-State: AOJu0YxpmU0wN/iU4we28zTFzZ0RJvnBvGY7xdHMj8Zve/IC8eYTMnD5
	TpXlghGeYbLX2Qu6rSQCQrPjPc3lC/IDxLyVAN9MQjk+Xe5Uuw29hj/ezvIFj4I=
X-Google-Smtp-Source: AGHT+IHDxWKHqbKggeW5m/UHELJJsSAkUbSHIz5mdvPHuItb+51Qna7y7RwAeJL+Khg+Wsc2oO72Kw==
X-Received: by 2002:a4a:5842:0:b0:5c4:2eef:d39 with SMTP id 006d021491bc7-5c439257c35mr5388343eaf.8.1719848616260;
        Mon, 01 Jul 2024 08:43:36 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:e8c6:2364:637f:c70e])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5c41480bfa1sm1016306eaf.4.2024.07.01.08.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 08:43:35 -0700 (PDT)
Date: Mon, 1 Jul 2024 17:43:34 +0200
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v5 7/7] Enable Driver compilation in crypto Kconfig and
 Makefile
Message-ID: <dcca1eff-48eb-411d-aef8-e206e241f3e1@suswa.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621082053.638952-8-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPAcc-Skcipher-support/20240625-184208
base:   1dcf865d3bf5bff45e93cb2410911b3428dacb78
patch link:    https://lore.kernel.org/r/20240621082053.638952-8-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH v5 7/7] Enable Driver compilation in crypto Kconfig and Makefile
config: x86_64-randconfig-161-20240626 (https://download.01.org/0day-ci/archive/20240626/202406260926.bfyJ84yf-lkp@intel.com/config)
compiler: gcc-10 (Ubuntu 10.5.0-1ubuntu1) 10.5.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202406260926.bfyJ84yf-lkp@intel.com/

New smatch warnings:
drivers/crypto/dwc-spacc/spacc_core.c:1029 fixup_sg() error: we previously assumed 'sg' could be null (see line 1008)

Old smatch warnings:
drivers/crypto/dwc-spacc/spacc_core.c:1417 spacc_isenabled() error: buffer overflow 'spacc->config.modes' 81 <= 81
drivers/crypto/dwc-spacc/spacc_core.c:1422 spacc_isenabled() error: buffer overflow 'spacc->config.modes' 81 <= 81
drivers/crypto/dwc-spacc/spacc_core.c:2018 spacc_open() warn: inconsistent indenting

vim +/sg +1029 drivers/crypto/dwc-spacc/spacc_core.c

8e3d92f71646e6 Pavitrakumar M 2024-06-21  1003  static int fixup_sg(struct scatterlist *sg, int nbytes)
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1004  {
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1005  	int sg_nents = 0;
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1006  
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1007  	while (nbytes > 0) {
8e3d92f71646e6 Pavitrakumar M 2024-06-21 @1008  		if (sg && sg->length) {

Can we really pass a NULL sg?

8e3d92f71646e6 Pavitrakumar M 2024-06-21  1009  			++sg_nents;
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1010  
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1011  			if (sg->length > nbytes)
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1012  				return sg_nents;
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1013  
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1014  			nbytes -= sg->length;
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1015  
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1016  			sg = sg_next(sg);
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1017  			if (!sg)
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1018  				break;
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1019  			/* WARNING: sg->length may be > nbytes */
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1020  		} else {
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1021  			/*
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1022  			 * The Linux crypto system uses its own SG chaining
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1023  			 * method which is slightly incompatible with the
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1024  			 * generic SG chaining. In particular, dma_map_sg does
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1025  			 * not support this method. Turn them into proper
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1026  			 * chained SGs here (which dma_map_sg does
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1027  			 * support) as a workaround.
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1028  			 */
8e3d92f71646e6 Pavitrakumar M 2024-06-21 @1029  			spacc_sg_chain(sg, 1, sg_chain_ptr(sg));
                                                                                       ^^^                 ^^
Because if so, we're toast.

8e3d92f71646e6 Pavitrakumar M 2024-06-21  1030  			sg = sg_chain_ptr(sg);
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1031  			if (!sg)
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1032  				break;
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1033  		}
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1034  	}
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1035  
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1036  	return sg_nents;
8e3d92f71646e6 Pavitrakumar M 2024-06-21  1037  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

