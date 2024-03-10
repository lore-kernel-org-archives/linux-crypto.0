Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39CE2C85A
	for <linux-crypto@vger.kernel.org>; Sun, 10 Mar 2024 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710079493; cv=none; b=N5XL68CHEkI/2ZpHnYL6LTKzU/dS91NYWO/OPOsPQ4Ic38S/TDgrQIK3v2CTKi5AlM+Lk3usJqF/dxwvd3TNId+2/+GoP82h9UVI7NT1o/z6Fa23B4ub370/Mc5gG9oCkCTMK5YFD4d8wEOXKntc9eSnsFVPUA8SSnb40LuX1eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710079493; c=relaxed/simple;
	bh=4cO05FTGfu5CYWVtNolCJgMtg0Om/u7O9trOND68qQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rb+WB8i4ISqz2nbxZUn9+FlIDacXbnDxqMiVq13SHr5rDaF0FeH7iJHnRS33DuA6SO4EekLRiTKYIVIVNZ6gun/50qIEg3BuMCddLCUjxthrdmE3r6g2lSfsQAVi+Sv7vcPPSTK2f++ZjjfzgoIdZ4I5ajYKIkj2Vqol7CK2Plc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6RCFoWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6RCFoWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E30BC433F1
	for <linux-crypto@vger.kernel.org>; Sun, 10 Mar 2024 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710079492;
	bh=4cO05FTGfu5CYWVtNolCJgMtg0Om/u7O9trOND68qQI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=d6RCFoWRL8uPShAzIgJId2f+LTftxOZiRCyVNvsDeeFp3VXjEeI6KgtToLg80Vu+4
	 yNjYpq3EZKwfY5wU2Na/Ym0xmQgH+Danx6RySFpillJlY09nxW4++pjAibvjYxye9W
	 xJSRnIY3YLeq2685oWUHC9sioBYiRnulmJc+5iZt15zdkdxvuBoV+YEJ+cbrnQrdR7
	 wr8nqXB7H6OofXXTUFPQeEPLkMkpF+/MtLj5j8Gp8pCf4ExNP9Tpq6apSydy+XAbfn
	 bxYCodFvC9mpHvlKo3aPXkRhOc45SHZt4ZsNFd/L2TXJq7GyGxjgIB7mxAnagyjqd9
	 lTo3fDdjmNnQA==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5131c48055cso3716998e87.1
        for <linux-crypto@vger.kernel.org>; Sun, 10 Mar 2024 07:04:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUZzp5x5VUR3JbTDYAZEG3GG0CepdG96+AoURTczekCsqnbMdqHYTFiSEb+Nhg0H78tE4Ut5JqNw6iwxbXeg0dZqu1Nl24o23rcbB0G
X-Gm-Message-State: AOJu0YxSiSEqdeMBdGF2f3bN8yV33Nog1Sk82/HyfgQwt92TBowXZFkE
	cMR9A+4yR/9RsvKo8QiS7ELnU9creJmJn1uXWLzE8rvMg2t6XeyBpn+UzAN4ig1qK+NibOdcAVu
	T0IS+255u5IrjOVOgDUm+8Ao7eiw=
X-Google-Smtp-Source: AGHT+IHXqojiC1EnAvsrKfFxmT1sF1AwpGUNcpQyx3evJzS8zLgF9OyQu2IBEMPqMaAmlHZf9OFN0VHL1RJu3GZ6CLQ=
X-Received: by 2002:ac2:5926:0:b0:513:60f5:b488 with SMTP id
 v6-20020ac25926000000b0051360f5b488mr2527791lfi.24.1710079490832; Sun, 10 Mar
 2024 07:04:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202403091614.NeUw5zcv-lkp@intel.com> <20240309091057.7954-1-21cnbao@gmail.com>
In-Reply-To: <20240309091057.7954-1-21cnbao@gmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 10 Mar 2024 22:04:40 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4VnM=Dw8N7j9ySWNpWVxCKeUnwFTmFOQBmLtTnfopRFQ@mail.gmail.com>
Message-ID: <CAAhV-H4VnM=Dw8N7j9ySWNpWVxCKeUnwFTmFOQBmLtTnfopRFQ@mail.gmail.com>
Subject: Re: [herbert-cryptodev-2.6:master 80/80] crypto/scompress.c:174:38:
 warning: unused variable 'dst_page'
To: Barry Song <21cnbao@gmail.com>
Cc: lkp@intel.com, kernel@xen0n.name, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, oe-kbuild-all@lists.linux.dev, 
	v-songbaohua@oppo.com, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Barry,

On Sat, Mar 9, 2024 at 5:11=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptod=
ev-2.6.git master
> > head:   77292bb8ca69c808741aadbd29207605296e24af
> > commit: 77292bb8ca69c808741aadbd29207605296e24af [80/80] crypto: scomp =
- remove memcpy if sg_nents is 1 and pages are lowmem
> > config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20=
240309/202403091614.NeUw5zcv-lkp@intel.com/config)
> > compiler: loongarch64-linux-gcc (GCC) 13.2.0
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20240309/202403091614.NeUw5zcv-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202403091614.NeUw5zcv-l=
kp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> >    In file included from crypto/scompress.c:12:
> >    include/crypto/scatterwalk.h: In function 'scatterwalk_pagedone':
> >    include/crypto/scatterwalk.h:76:30: warning: variable 'page' set but=
 not used [-Wunused-but-set-variable]
> >       76 |                 struct page *page;
> >          |                              ^~~~
> >    crypto/scompress.c: In function 'scomp_acomp_comp_decomp':
> > >> crypto/scompress.c:174:38: warning: unused variable 'dst_page' [-Wun=
used-variable]
> >      174 |                         struct page *dst_page =3D sg_page(re=
q->dst);
> >          |                                      ^~~~~~~~
> >
> >
> > vim +/dst_page +174 crypto/scompress.c
> >
> >    112
> >    113        static int scomp_acomp_comp_decomp(struct acomp_req *req,=
 int dir)
> >    114        {
> >    115                struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(=
req);
> >    116                void **tfm_ctx =3D acomp_tfm_ctx(tfm);
> > [snipped]
> >    171                        } else {
> >    172                                int nr_pages =3D DIV_ROUND_UP(req=
->dst->offset + req->dlen, PAGE_SIZE);
> >    173                                int i;
> >  > 174                                struct page *dst_page =3D sg_page=
(req->dst);
> >    175
> >    176                                for (i =3D 0; i < nr_pages; i++)
> >    177                                        flush_dcache_page(dst_pag=
e + i);
>
> + Huacai, Xuerui
>
> loongarch code needs a fix, it should have removed the below
> two macros:
OK, seems reasonable.

Huacai

>
> diff --git a/arch/loongarch/include/asm/cacheflush.h b/arch/loongarch/inc=
lude/asm/cacheflush.h
> index 80bd74106985..f8754d08a31a 100644
> --- a/arch/loongarch/include/asm/cacheflush.h
> +++ b/arch/loongarch/include/asm/cacheflush.h
> @@ -37,8 +37,6 @@ void local_flush_icache_range(unsigned long start, unsi=
gned long end);
>  #define flush_icache_range     local_flush_icache_range
>  #define flush_icache_user_range        local_flush_icache_range
>
> -#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
> -
>  #define flush_cache_all()                              do { } while (0)
>  #define flush_cache_mm(mm)                             do { } while (0)
>  #define flush_cache_dup_mm(mm)                         do { } while (0)
> @@ -47,7 +45,6 @@ void local_flush_icache_range(unsigned long start, unsi=
gned long end);
>  #define flush_cache_vmap(start, end)                   do { } while (0)
>  #define flush_cache_vunmap(start, end)                 do { } while (0)
>  #define flush_icache_user_page(vma, page, addr, len)   do { } while (0)
> -#define flush_dcache_page(page)                                do { } wh=
ile (0)
>  #define flush_dcache_mmap_lock(mapping)                        do { } wh=
ile (0)
>  #define flush_dcache_mmap_unlock(mapping)              do { } while (0)
>
>
> as include/asm-generic/cacheflush.h already has the below,
>
> #ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
> static inline void flush_dcache_page(struct page *page)
> {
> }
>
> #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
> #endif
>
> >    178                        }
> >    179                }
> >    180        out:
> >    181                spin_unlock(&scratch->lock);
> >    182                return ret;
> >    183        }
> >    184
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
>
> Thanks
> Barry
>
