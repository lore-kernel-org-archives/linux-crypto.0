Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D891522E403
	for <linux-crypto@vger.kernel.org>; Mon, 10 Mar 2025 19:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741635074; cv=none; b=RxT0ZJ0TNfF+7d+PZt8FEwxsoNfVHDQgEN1XZtn5Ot4XpKC+quRkfuupRgSc056qO0/GhlguGpotsLNexwA29M1pc9in6JDHrDOwv4Lp1Q4YWJ2qkiPNyrhlHMFcH5tfXHW1fX52O4EITW43GC9oUtQ3Qk3/rSYBL2OOtyLopEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741635074; c=relaxed/simple;
	bh=v+b/kzEodLCVvkZx2b6X8TmLaTIIRtwT31F+hHamOgU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=m2OGmdkk/ynX4PcA4ax0ImEmlfLcgbXsLY9IRFGQywb2mdDtpLKELXGQEy7nn7Jn/UbCDp8V5R1QrMtD2yhqoEZSLz4X68yFq+MRFxh1WRUqi6lI+QFPnMo84bX981ZGzijwPqlLKV7E2GEKDioZ0p7Li26ya+OSuaza00hgI2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Vy4bjPg6; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vy4bjPg6"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43ce70f9afbso21188335e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Mar 2025 12:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741635071; x=1742239871; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FMNf5pDA6wndQOsjZsgjA/SqjQu85AYtNnsbK/6BwAU=;
        b=Vy4bjPg6OGKca2DivUf5dd5bvt1eEceWhAB0RUVs1EvH9z3No8OunBGoegIqVhay2K
         ULzn0kG9BpWr3qpwAwiNun6wEjfmi/4EM9ajyInlmvgEzoMEvcOys00xpEkPRR00worf
         3gV82uyMsekOAqfwrIgo5QnZ8Y5lzOLB+Qsi5pfLTx/k0G+NNqYM/7NsRfqcINXgxb0D
         ZlPPc9cTPhQbvSg9x+bVFswP0L8R/x2zoYGAhXtS2WDA1W4D8doM715uQQlZI+wr69Fa
         PHYyOGnQQsNEUi5Q4bPx0PSnQdq4+NQcvlvJomuqKV8RERH7SLP4gR69K+lWJwnbqSGn
         UEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741635071; x=1742239871;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FMNf5pDA6wndQOsjZsgjA/SqjQu85AYtNnsbK/6BwAU=;
        b=sXPftSQ5k4kOMkSTq2UoYbatj/uZg9AmDC+sYFVJ8k+deTwsAmBdHHLS7ftX9RlXfQ
         EDykxKiuc4yE6CxoV/H0gw275CAZOITHClPSErFa6yXw0mz2ppkApHl6f69Kr044lepy
         3owRZLM3EFJnXxXtMsInqb1nhSNB6tzJQXdeK+64/1xsGAqi8CA3eIiFK0Jq0CLPDy/p
         YVHO+eiwv2eWb4DTKTZCKGRw1btrBBf6+IZtyQf3i6YnTrugZSVk3n99Zj1KDaPmb1Eb
         NhDpVcXkH5N5h7jN4mgppPlpVlCzx2F0m/2VI5pK9ypcKIWMRZ8QUF39d9RkG7XsPyOp
         fMLw==
X-Forwarded-Encrypted: i=1; AJvYcCVtqxqxDPlBc94ItbENcmINPTWDdmsrxVD+NZ3HCMri9ycn5VP8JP7iKOyd6z1Km/Z94jgif/vFjqf60/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw2YBtdIHPqQzn2ZU+7RSF1KoXtRAO0iljLtg4ZiDRwNuD3Lye
	O2pqdZLGMiaiBVJK6lJMJ5GFCabQ2qZPb7O1oV9RPyiu3PjZCnARMp+9FK7ucNM=
X-Gm-Gg: ASbGncvSb8ZzihQpd05AYFJ6D7/ywbt6lpjlN/z+m2aarK3PvHhrc9GwMqivsOKxAmf
	gGFQ6OL5acXtttaX6zjArJ18moCUWYi+l74AL53zZAEQnWeTx15m0U6BjNudvpGENMCPZVhA00E
	fM6SoVBbYS9jYN0q0MBsPTQyjQ4whEK/g3xQCdkNQMRRHGystJpAa06rSY6dxSzrAiPx/oyosjj
	aRlkt8dzc7D2V4ln6xNAU/SvYJlwRaUWQ8NgHpjPgGNCodUz93LdzvB6QSGRfEbeu4Ynkk6z9VC
	E+RnWweo3bV4HSzWhkccd9LvlALuMbgbYOXnh/bPQOWNsvNIyg==
X-Google-Smtp-Source: AGHT+IEDcYCxs5mJAYlFaRGvShPNEs8pMoKoXux3iFgrh12kYqXw0trLLD+c5oeL3en7Z2PLwfzJvQ==
X-Received: by 2002:a05:600c:3b0e:b0:43c:f513:9585 with SMTP id 5b1f17b1804b1-43cf5139ae7mr52691985e9.13.1741635070877;
        Mon, 10 Mar 2025 12:31:10 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43ce48165c0sm100711905e9.26.2025.03.10.12.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 12:31:10 -0700 (PDT)
Date: Mon, 10 Mar 2025 22:31:06 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 7/8] crypto: scomp - Remove support for most
 non-trivial destination SG lists
Message-ID: <914f6ea6-bb6c-4feb-a4ac-23508a8ff335@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <205f05023b5ff0d8cf7deb6e0a5fbb4643f02e00.1741488107.git.herbert@gondor.apana.org.au>

Hi Herbert,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-api-Add-cra_type-destroy-hook/20250309-104526
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/205f05023b5ff0d8cf7deb6e0a5fbb4643f02e00.1741488107.git.herbert%40gondor.apana.org.au
patch subject: [v3 PATCH 7/8] crypto: scomp - Remove support for most non-trivial destination SG lists
config: um-randconfig-r072-20250310 (https://download.01.org/0day-ci/archive/20250311/202503110237.GjZvyi0K-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project e15545cad8297ec7555f26e5ae74a9f0511203e7)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202503110237.GjZvyi0K-lkp@intel.com/

New smatch warnings:
crypto/scompress.c:180 scomp_acomp_comp_decomp() error: we previously assumed 'req->dst' could be null (see line 174)

vim +180 crypto/scompress.c

1ab53a77b772bf7 Giovanni Cabiddu          2016-10-21  159  static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
1ab53a77b772bf7 Giovanni Cabiddu          2016-10-21  160  {
1ab53a77b772bf7 Giovanni Cabiddu          2016-10-21  161  	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
5b855462cc7e3f3 Herbert Xu                2025-03-09  162  	struct crypto_scomp **tfm_ctx = acomp_tfm_ctx(tfm);
1ab53a77b772bf7 Giovanni Cabiddu          2016-10-21  163  	struct crypto_scomp *scomp = *tfm_ctx;
e77b9947333baa6 Herbert Xu                2025-03-09  164  	struct crypto_acomp_stream *stream;
71052dcf4be70be Sebastian Andrzej Siewior 2019-03-29  165  	struct scomp_scratch *scratch;
5b855462cc7e3f3 Herbert Xu                2025-03-09  166  	unsigned int slen = req->slen;
5b855462cc7e3f3 Herbert Xu                2025-03-09  167  	unsigned int dlen = req->dlen;
77292bb8ca69c80 Barry Song                2024-03-02  168  	void *src, *dst;
1ab53a77b772bf7 Giovanni Cabiddu          2016-10-21  169  	int ret;
1ab53a77b772bf7 Giovanni Cabiddu          2016-10-21  170  
5b855462cc7e3f3 Herbert Xu                2025-03-09  171  	if (!req->src || !slen)
71052dcf4be70be Sebastian Andrzej Siewior 2019-03-29  172  		return -EINVAL;
1ab53a77b772bf7 Giovanni Cabiddu          2016-10-21  173  
5b855462cc7e3f3 Herbert Xu                2025-03-09 @174  	if (req->dst && !dlen)
                                                                    ^^^^^^^^
Is this check necessary?

71052dcf4be70be Sebastian Andrzej Siewior 2019-03-29  175  		return -EINVAL;
1ab53a77b772bf7 Giovanni Cabiddu          2016-10-21  176  
5b855462cc7e3f3 Herbert Xu                2025-03-09  177  	if (sg_nents(req->dst) > 1)
5b855462cc7e3f3 Herbert Xu                2025-03-09  178  		return -ENOSYS;
1ab53a77b772bf7 Giovanni Cabiddu          2016-10-21  179  
5b855462cc7e3f3 Herbert Xu                2025-03-09 @180  	if (req->dst->offset >= PAGE_SIZE)
                                                                    ^^^^^^^^^^
Unchecked dereference

5b855462cc7e3f3 Herbert Xu                2025-03-09  181  		return -ENOSYS;
744e1885922a994 Chengming Zhou            2023-12-27  182  
5b855462cc7e3f3 Herbert Xu                2025-03-09  183  	if (req->dst->offset + dlen > PAGE_SIZE)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

