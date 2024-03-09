Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0937F25753
	for <linux-crypto@vger.kernel.org>; Sat,  9 Mar 2024 09:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709975473; cv=none; b=SITNVoqxmclh0j1aIuuRSFkZsyZKS8LNBcP+3PHndHKtpTUhthyjUhwgeH1DP9kVkSTwbxoPbZeIwC/Iml4w//rYXexaMmPGMFVDgQFuXSg9xpP20ZVepq7uDvJkGy6FnFtN4G+Hq++XbZBoGuOWt78BbYTbd0RAIxZIoKoetss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709975473; c=relaxed/simple;
	bh=K3WtC2amZZCVq3xeoEFYG11teftFq7BcqSEOPIPEFdY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dnP8f7sj/HCFOdjPVrO+Orx8Cc7MSQ68Dqlid0T1arNWxgatHLP0WoRhczRTYsY0C+QKeuICW9eJDgE3+PRXKWNixD4a5X5QLdmXvGp35NVILLugSp8Z3dwLmcBZENaplgv6hMoSsQHgw7DyOVhelvQUOhdb4wXrmKFBqSFDYlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kdyp2x0q; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kdyp2x0q"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3bbbc6e51d0so995148b6e.3
        for <linux-crypto@vger.kernel.org>; Sat, 09 Mar 2024 01:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709975471; x=1710580271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eqNmT55jTcvWbN7b37y3AhUIsk2g7VRwP9WuKg2uzU8=;
        b=Kdyp2x0qCPRDgryXUCZUtPgeG09hqjNokyi214gXeI0f0NGkQsTlbr4LR604PH5Dxl
         Cbf9HRN7HxM1JpG0m6Y4slbH+l/AIglG7tHCaAGOymZ9I1QtMpq+Oy2pxy+wD9pvEVnI
         /vAxeDJ7rEc58a1gGKsHhGM3MT6GV9LBJk0a8vpGtdrwsGhMWBYTjWgS9CYswW4nGSBw
         bhE8Mq8TwTXg6V/AUgBC3vf8y7SwSEfrictwVFj3VO+0IVKUXB1q5iQA3X46VsBqVjbX
         ZbdCEkn2tHTX/HQxpV4JOrIhOErLoPKXc5R1v4ieCqJX7Iw9x8NoH4QJM6JiDWi/2G16
         23KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709975471; x=1710580271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eqNmT55jTcvWbN7b37y3AhUIsk2g7VRwP9WuKg2uzU8=;
        b=mIQeNhvtwz+ze+D560jmujLfqMMvy9yuIlKYyNpyzrkN/ec+CxPt1GOP50WDarLfkf
         BQvmdPYkFeFMm0LHfku+rv2tJdtgFDljpx+Ztjy1Lz6eeDtu26s/pLYvY8RWm8AJa4Gi
         uTk5qLM/gXVHataVXXc3gUqyXypuh7N+B3C3wSStsCH2lIEp6hf2Fr62UhCdBe3k8Op5
         vSPXVO2XnNsWh9J+Lpf4EDAQCmGhSa+sqGveV+73ucIK+HUfAFzbgespNTKWBNuOip43
         nAf9vAMCSL88IHcFZr7TZgHBG314GLq3nK3mIAGp4IvRqwbTCX8EczAnPp3VV+JrG0X0
         9x2A==
X-Forwarded-Encrypted: i=1; AJvYcCXIiKgfx6pygu0tMs1RmF5JtDRU2euD1yvI6HLlvVlny6GpQfihYvWd6tdZqTESIigZTqtbDFaFjuhA8JcSBWzhQV1slT1s6VwLdhdW
X-Gm-Message-State: AOJu0YyUp2sh3/F9X6+p9ezuR/wQ70mKDGk0VWh93lX1yQSBLhQN8v0Q
	1MTraJBNtc4nbpDpZVeDxNheb1vgxhH05pqGVcoaFi3n8aozsSdR
X-Google-Smtp-Source: AGHT+IHgkCigzgpR227zt8SJGCW8WseyiFE/Ib1V5+cZSP43pd47WbyG6LUBLoGhFrucgeH0b0LRfQ==
X-Received: by 2002:a05:6808:2204:b0:3c2:1db6:2513 with SMTP id bd4-20020a056808220400b003c21db62513mr1696818oib.56.1709975470849;
        Sat, 09 Mar 2024 01:11:10 -0800 (PST)
Received: from localhost.localdomain ([2407:7000:8942:5500:aaa1:59ff:fe57:eb97])
        by smtp.gmail.com with ESMTPSA id p5-20020a637f45000000b005dc1edf7371sm889096pgn.9.2024.03.09.01.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Mar 2024 01:11:10 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: lkp@intel.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name
Cc: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	v-songbaohua@oppo.com,
	loongarch@lists.linux.dev
Subject: Re: [herbert-cryptodev-2.6:master 80/80] crypto/scompress.c:174:38: warning: unused variable 'dst_page'
Date: Sat,  9 Mar 2024 22:10:57 +1300
Message-Id: <20240309091057.7954-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <202403091614.NeUw5zcv-lkp@intel.com>
References: <202403091614.NeUw5zcv-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   77292bb8ca69c808741aadbd29207605296e24af
> commit: 77292bb8ca69c808741aadbd29207605296e24af [80/80] crypto: scomp - remove memcpy if sg_nents is 1 and pages are lowmem
> config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20240309/202403091614.NeUw5zcv-lkp@intel.com/config)
> compiler: loongarch64-linux-gcc (GCC) 13.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240309/202403091614.NeUw5zcv-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202403091614.NeUw5zcv-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from crypto/scompress.c:12:
>    include/crypto/scatterwalk.h: In function 'scatterwalk_pagedone':
>    include/crypto/scatterwalk.h:76:30: warning: variable 'page' set but not used [-Wunused-but-set-variable]
>       76 |                 struct page *page;
>          |                              ^~~~
>    crypto/scompress.c: In function 'scomp_acomp_comp_decomp':
> >> crypto/scompress.c:174:38: warning: unused variable 'dst_page' [-Wunused-variable]
>      174 |                         struct page *dst_page = sg_page(req->dst);
>          |                                      ^~~~~~~~
> 
> 
> vim +/dst_page +174 crypto/scompress.c
> 
>    112	
>    113	static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
>    114	{
>    115		struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
>    116		void **tfm_ctx = acomp_tfm_ctx(tfm);
> [snipped]
>    171			} else {
>    172				int nr_pages = DIV_ROUND_UP(req->dst->offset + req->dlen, PAGE_SIZE);
>    173				int i;
>  > 174				struct page *dst_page = sg_page(req->dst);
>    175	
>    176				for (i = 0; i < nr_pages; i++)
>    177					flush_dcache_page(dst_page + i);

+ Huacai, Xuerui

loongarch code needs a fix, it should have removed the below
two macros:

diff --git a/arch/loongarch/include/asm/cacheflush.h b/arch/loongarch/include/asm/cacheflush.h
index 80bd74106985..f8754d08a31a 100644
--- a/arch/loongarch/include/asm/cacheflush.h
+++ b/arch/loongarch/include/asm/cacheflush.h
@@ -37,8 +37,6 @@ void local_flush_icache_range(unsigned long start, unsigned long end);
 #define flush_icache_range     local_flush_icache_range
 #define flush_icache_user_range        local_flush_icache_range
 
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
-
 #define flush_cache_all()                              do { } while (0)
 #define flush_cache_mm(mm)                             do { } while (0)
 #define flush_cache_dup_mm(mm)                         do { } while (0)
@@ -47,7 +45,6 @@ void local_flush_icache_range(unsigned long start, unsigned long end);
 #define flush_cache_vmap(start, end)                   do { } while (0)
 #define flush_cache_vunmap(start, end)                 do { } while (0)
 #define flush_icache_user_page(vma, page, addr, len)   do { } while (0)
-#define flush_dcache_page(page)                                do { } while (0)
 #define flush_dcache_mmap_lock(mapping)                        do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)              do { } while (0)


as include/asm-generic/cacheflush.h already has the below,

#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
static inline void flush_dcache_page(struct page *page)
{
}

#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
#endif

>    178			}
>    179		}
>    180	out:
>    181		spin_unlock(&scratch->lock);
>    182		return ret;
>    183	}
>    184	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Thanks
Barry

