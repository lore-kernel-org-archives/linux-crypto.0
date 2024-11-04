Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DF319B59F
	for <linux-crypto@vger.kernel.org>; Mon,  4 Nov 2024 08:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730709085; cv=none; b=YOmS6Zrwlp4AZAWy5QVVgjqO7blWttSGiIGGbJm+Y2ulsu9bjkgu25PeaFWZJSBnPdMZseIUhNQv5GF1nXzUk4w8Q6Ssvjpff1vLEqzhIZpZX4/Tn/yVxpjF4DDZHjiLfRu1MyWiCPM/GBB0BEA8UhJzzHNSshNn/+dBO8EJobo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730709085; c=relaxed/simple;
	bh=RMFwDMojD3zrSAgOcjuKC+xriirvgs/o1aANeynXSuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=YJGUg+NPEAXDvJ9H8n1bCFMEFsfAHFHA0jYrBfTIGwhOovN6f30rLVvCvSE7B/DM1AkjbQbo5J6/AKTEd0jPXvFx3RdlLv1VSr/kaQUbpTbyBhqQPLoWl6qvKqMC9XOyoyO6o3I4Cc93/ZQeRtIV2t/28++3r9G9fr1lf12hZsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IWKBxuYT; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IWKBxuYT"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43155afca99so28512945e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 04 Nov 2024 00:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730709078; x=1731313878; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T5vDLGsbEr0SVIowN1t5ye+7OUL4pjjT2D7werAFSjM=;
        b=IWKBxuYTkq6vrWktIU4NQb+ppiLmusdhAA+wKIM7dsIqwjibfjojLeWeUzYwEXwvCL
         dZS2u2L9YQQHdglBiFuBnLy1AHlVZOYDgoiK/TAJ4fq9bX5tkb+1ce4T2kTAfX3QF6+8
         C6z7zn+Jp7RpdnIsnk0qO0t4hlA4Awz7z9WQj27+q89wybZw75T1rnNpuK2HKwsLz4VF
         3LGCsJyJZuIVs5eZ+qJM2Gvy5e1EdPhLeUcNgtInjTDsJ8rlMzh0N9LCiqimUcwk8+Rq
         lxB4gGS3Xf6LOnvHG2Ct/OtuiHTDyc6mK7ZXyVtIzSp8YID/a3pnDdhg8+g8qTx6BVPS
         rBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730709078; x=1731313878;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T5vDLGsbEr0SVIowN1t5ye+7OUL4pjjT2D7werAFSjM=;
        b=ga9Rama8LmttGEuTVutEYwYNdj/cYsBcOxS1nsCdHmU6fjoDrNuTm6B61+Xq0zdFAM
         nxpY7hFtQb5S7ktByxWWlBDMRYythn0yMKQbFJsa6uw7Tb2cw6LxQqQQys1pdQiBHq3L
         0Vq9nPc/N1g8UMB3sM+I1ljpGmJoK53vDl7CmDhjgfrt0tI74ETTplcWNrgwkdnrKKP9
         /Bbt0nuEAVxEs1Gan0IzfH+FvMjcpGwrp/JM7MEd1WPXyeYtwQ1uhXd4bDdcpLTj1Ity
         5BhEDuZ837Gy3j95ROKPVY4Bqu2L9e444+Eip1oFhgwy5eeScAIzwZpbMoyDCG6Jwiqk
         Cbyw==
X-Forwarded-Encrypted: i=1; AJvYcCXXUd10nu8qrHsTD8bfVAudLktCfmfaWkTfy/ZXAJVDjDs80LPYZS7whOlJrjXgfydDklatzcQgXP4kUco=@vger.kernel.org
X-Gm-Message-State: AOJu0YypJ41gJWPv7xrmC//2g1aRVSp3F6O0BE5jzf1Ihj5+3LD+IzUR
	xGhwtRGY6ULCWgLl+hzDXM6CTTuxuS2B5KPTNCYcHVVIUoRjMbZLZfWSJCEPb6o=
X-Google-Smtp-Source: AGHT+IFFiT8xMGT+o7kM5vRaU6KjK8tqr+AcRQcVqXIZYuM1L7HGi9LZqQfv+QQLXIRdVtTWEYW6xA==
X-Received: by 2002:a5d:64a7:0:b0:374:c7cd:8818 with SMTP id ffacd0b85a97d-381c79e366dmr9155476f8f.22.1730709078297;
        Mon, 04 Nov 2024 00:31:18 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10d439esm12549514f8f.44.2024.11.04.00.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 00:31:17 -0800 (PST)
Date: Mon, 4 Nov 2024 11:31:13 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosryahmed@google.com, nphamcs@gmail.com,
	chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, ying.huang@intel.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com, zanussi@kernel.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com, kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v2 13/13] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Message-ID: <89728727-0fd2-4539-bc89-17a699d7179a@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241103032111.333282-14-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-acomp-Define-two-new-interfaces-for-compress-decompress-batching/20241103-112337
base:   5c4cf96cd70230100b5d396d45a5c9a332539d19
patch link:    https://lore.kernel.org/r/20241103032111.333282-14-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v2 13/13] mm: zswap: Compress batching with Intel IAA in zswap_store() of large folios.
config: x86_64-randconfig-161-20241104 (https://download.01.org/0day-ci/archive/20241104/202411040859.2z0MfFkR-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202411040859.2z0MfFkR-lkp@intel.com/

smatch warnings:
mm/zswap.c:1788 zswap_store_propagate_errors() warn: variable dereferenced before check 'sbp->entry' (see line 1785)

vim +1788 mm/zswap.c

c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1771  static __always_inline void zswap_store_propagate_errors(
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1772  	struct zswap_store_pipeline_state *zst,
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1773  	u8 error_batch_idx)
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1774  {
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1775  	u8 i;
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1776  
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1777  	if (zst->errors[error_batch_idx])
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1778  		return;
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1779  
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1780  	for (i = 0; i < zst->nr_comp_pages; ++i) {
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1781  		struct zswap_store_sub_batch_page *sbp = &zst->sub_batch[i];
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1782  
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1783  		if (sbp->batch_idx == error_batch_idx) {
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1784  			if (!sbp->error) {
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02 @1785  				if (!IS_ERR_VALUE(sbp->entry->handle))
                                                                                                  ^^^^^^^^^^^^^^^^^^
Dereferenced

c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1786  					zpool_free(zst->pool->zpool, sbp->entry->handle);
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1787  
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02 @1788  				if (sbp->entry) {
                                                                                    ^^^^^^^^^^
Checked too late

c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1789  					zswap_entry_cache_free(sbp->entry);
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1790  					sbp->entry = NULL;
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1791  				}
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1792  				sbp->error = -EINVAL;
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1793  			}
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1794  		}
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1795  	}
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1796  
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1797  	/*
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1798  	 * Set zswap status for the folio to "error"
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1799  	 * for use in swap_writepage.
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1800  	 */
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1801  	zst->errors[error_batch_idx] = -EINVAL;
c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1802  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

