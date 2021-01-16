Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A2EC433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 02:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4DA22075A
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 02:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbhAPCAR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 21:00:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAPCAR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 21:00:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E23522075A;
        Sat, 16 Jan 2021 01:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610762376;
        bh=8DBfgcZmjZUV0p9L7RoJ9Btu1l4QjF7cBMCJGChwyXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hfM1D+WoEpCDxjJksH/irYwrhNehrSOnNhUsOPpR6oWlNlbjZuFdvYSBLLNhJYDeR
         dZfI0BM0BwMpkVnfrXZqsbHB+XE4IB+ZRWyS7DixFl5wXQ5KL3T7/4xkf1qW0Qn8f8
         dDiCNGk8FXa1usxVlNo7W3Uknf97g/q7Uli/QSCAObJh5wiQ5+U97kuz8+OgdlqsGJ
         1GiYu7tj+u70z4Jhf79WrZE811HFhHbQfPpCNVdNcwV9uTtPWnHvrcYUR9kpLXvRq6
         7a7oVCoYRH8l5+f4hc/Yo58xeuV5Cc2LJOPoobLPFY7XKckLFo6xnk9dE0XJu9tKqZ
         mLyZXZWrrNMUQ==
Date:   Fri, 15 Jan 2021 17:59:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        Linux Memory Management List <linux-mm@kvack.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [linux-next:master 952/3956] crypto/blake2b_generic.c:73:13:
 warning: stack frame size of 9776 bytes in function
 'blake2b_compress_one_generic'
Message-ID: <YAJIhjzmvszXAXUb@gmail.com>
References: <202101160841.jUXjdS7j-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202101160841.jUXjdS7j-lkp@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jan 16, 2021 at 08:59:50AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   b3a3cbdec55b090d22a09f75efb7c7d34cb97f25
> commit: 28dcca4cc0c01e2467549a36b1b0eacfdb01236c [952/3956] crypto: blake2b - sync with blake2s implementation
> config: powerpc64-randconfig-r021-20210115 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 5b42fd8dd4e7e29125a09a41a33af7c9cb57d144)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install powerpc64 cross compiling tool for clang build
>         # apt-get install binutils-powerpc64-linux-gnu
>         # https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=28dcca4cc0c01e2467549a36b1b0eacfdb01236c
>         git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>         git fetch --no-tags linux-next master
>         git checkout 28dcca4cc0c01e2467549a36b1b0eacfdb01236c
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=powerpc64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> crypto/blake2b_generic.c:73:13: warning: stack frame size of 9776 bytes in function 'blake2b_compress_one_generic' [-Wframe-larger-than=]
>    static void blake2b_compress_one_generic(struct blake2b_state *S,
>                ^
>    1 warning generated.
> 
> 
> vim +/blake2b_compress_one_generic +73 crypto/blake2b_generic.c
> 
>     48	
>     49	#define G(r,i,a,b,c,d)                                  \
>     50		do {                                            \
>     51			a = a + b + m[blake2b_sigma[r][2*i+0]]; \
>     52			d = ror64(d ^ a, 32);                   \
>     53			c = c + d;                              \
>     54			b = ror64(b ^ c, 24);                   \
>     55			a = a + b + m[blake2b_sigma[r][2*i+1]]; \
>     56			d = ror64(d ^ a, 16);                   \
>     57			c = c + d;                              \
>     58			b = ror64(b ^ c, 63);                   \
>     59		} while (0)
>     60	
>     61	#define ROUND(r)                                \
>     62		do {                                    \
>     63			G(r,0,v[ 0],v[ 4],v[ 8],v[12]); \
>     64			G(r,1,v[ 1],v[ 5],v[ 9],v[13]); \
>     65			G(r,2,v[ 2],v[ 6],v[10],v[14]); \
>     66			G(r,3,v[ 3],v[ 7],v[11],v[15]); \
>     67			G(r,4,v[ 0],v[ 5],v[10],v[15]); \
>     68			G(r,5,v[ 1],v[ 6],v[11],v[12]); \
>     69			G(r,6,v[ 2],v[ 7],v[ 8],v[13]); \
>     70			G(r,7,v[ 3],v[ 4],v[ 9],v[14]); \
>     71		} while (0)
>     72	
>   > 73	static void blake2b_compress_one_generic(struct blake2b_state *S,
>     74						 const u8 block[BLAKE2B_BLOCK_SIZE])
>     75	{
>     76		u64 m[16];
>     77		u64 v[16];
>     78		size_t i;
>     79	
>     80		for (i = 0; i < 16; ++i)
>     81			m[i] = get_unaligned_le64(block + i * sizeof(m[i]));
>     82	
>     83		for (i = 0; i < 8; ++i)
>     84			v[i] = S->h[i];
>     85	
>     86		v[ 8] = BLAKE2B_IV0;
>     87		v[ 9] = BLAKE2B_IV1;
>     88		v[10] = BLAKE2B_IV2;
>     89		v[11] = BLAKE2B_IV3;
>     90		v[12] = BLAKE2B_IV4 ^ S->t[0];
>     91		v[13] = BLAKE2B_IV5 ^ S->t[1];
>     92		v[14] = BLAKE2B_IV6 ^ S->f[0];
>     93		v[15] = BLAKE2B_IV7 ^ S->f[1];
>     94	
>     95		ROUND(0);
>     96		ROUND(1);
>     97		ROUND(2);
>     98		ROUND(3);
>     99		ROUND(4);
>    100		ROUND(5);
>    101		ROUND(6);
>    102		ROUND(7);
>    103		ROUND(8);
>    104		ROUND(9);
>    105		ROUND(10);
>    106		ROUND(11);
>    107	#ifdef CONFIG_CC_IS_CLANG
>    108	#pragma nounroll /* https://bugs.llvm.org/show_bug.cgi?id=45803 */
>    109	#endif
>    110		for (i = 0; i < 8; ++i)
>    111			S->h[i] = S->h[i] ^ v[i] ^ v[i + 8];
>    112	}
>    113	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Looks like the clang bug that causes large stack usage in this function
(https://bugs.llvm.org/show_bug.cgi?id=45803 which is still unfixed) got
triggered again.  Note that the function only has 264 bytes of local variables,
so there's no reason why it should use anywhere near 9776 bytes of stack space.

I'm not sure what we can do about this.  Last time the solution was commit
0c0408e86dbe which randomly added a 'pragma nounroll' to the loop at the end.

Anyone have any better idea than randomly trying adding optimization pragmas and
seeing what makes the report go away?

Also this was reported with clang 12.0.0 which is a prerelease version, so I'm
not sure how much I'm supposed to care about this report.

- Eric
