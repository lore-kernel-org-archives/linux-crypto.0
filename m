Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD194C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 13:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADF5D205F4
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 13:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLCNQp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 08:16:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:40720 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbfLCNQp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 08:16:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3567AB162;
        Tue,  3 Dec 2019 13:16:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 303B0DA7D9; Tue,  3 Dec 2019 14:16:38 +0100 (CET)
Date:   Tue, 3 Dec 2019 14:16:38 +0100
From:   David Sterba <dsterba@suse.cz>
To:     kbuild test robot <lkp@intel.com>
Cc:     David Sterba <dsterba@suse.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: crypto/blake2b_generic.c:245:1: warning: the frame size of 1220
 bytes is larger than 1024 bytes
Message-ID: <20191203131638.GO2734@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, kbuild test robot <lkp@intel.com>,
        David Sterba <dsterba@suse.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
References: <201912010551.6rUbsvGE%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201912010551.6rUbsvGE%lkp@intel.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 01, 2019 at 05:54:53AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   32ef9553635ab1236c33951a8bd9b5af1c3b1646
> commit: 91d689337fe8b7703608a2ec39aae700b99f3933 crypto: blake2b - add blake2b generic implementation
> date:   4 weeks ago
> config: arc-randconfig-a0031-20191201 (attached as .config)
> compiler: arc-elf-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 91d689337fe8b7703608a2ec39aae700b99f3933
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=arc 

So this is for ARC.

> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    crypto/blake2b_generic.c: In function 'blake2b_compress':
> >> crypto/blake2b_generic.c:245:1: warning: the frame size of 1220 bytes is larger than 1024 bytes [-Wframe-larger-than=]

1220 looks like a lot, the x86_64 asks for 288 bytes for
blake2b_compress, this roughly matches the declarations and effects of
inlining (2 x 16 x sizeof(u64) is 256).

I'm not familiar with ARC limitations regarding eg. 64 bit types so this
would be my first guess that this requires more temporary stack space
than other arches that can handle u64 just fine.

>     }
>     ^
> 
> vim +245 crypto/blake2b_generic.c
> 
>    183	
>    184	#define G(r,i,a,b,c,d)                                  \
>    185		do {                                            \
>    186			a = a + b + m[blake2b_sigma[r][2*i+0]]; \
>    187			d = ror64(d ^ a, 32);                   \
>    188			c = c + d;                              \
>    189			b = ror64(b ^ c, 24);                   \
>    190			a = a + b + m[blake2b_sigma[r][2*i+1]]; \
>    191			d = ror64(d ^ a, 16);                   \
>    192			c = c + d;                              \
>    193			b = ror64(b ^ c, 63);                   \
>    194		} while (0)
>    195	
>    196	#define ROUND(r)                                \
>    197		do {                                    \
>    198			G(r,0,v[ 0],v[ 4],v[ 8],v[12]); \
>    199			G(r,1,v[ 1],v[ 5],v[ 9],v[13]); \
>    200			G(r,2,v[ 2],v[ 6],v[10],v[14]); \
>    201			G(r,3,v[ 3],v[ 7],v[11],v[15]); \
>    202			G(r,4,v[ 0],v[ 5],v[10],v[15]); \
>    203			G(r,5,v[ 1],v[ 6],v[11],v[12]); \
>    204			G(r,6,v[ 2],v[ 7],v[ 8],v[13]); \
>    205			G(r,7,v[ 3],v[ 4],v[ 9],v[14]); \
>    206		} while (0)
>    207	
>    208	static void blake2b_compress(struct blake2b_state *S,
>    209				     const u8 block[BLAKE2B_BLOCKBYTES])
>    210	{
>    211		u64 m[16];
>    212		u64 v[16];
>    213		size_t i;
>    214	
>    215		for (i = 0; i < 16; ++i)
>    216			m[i] = get_unaligned_le64(block + i * sizeof(m[i]));
>    217	
>    218		for (i = 0; i < 8; ++i)
>    219			v[i] = S->h[i];
>    220	
>    221		v[ 8] = blake2b_IV[0];
>    222		v[ 9] = blake2b_IV[1];
>    223		v[10] = blake2b_IV[2];
>    224		v[11] = blake2b_IV[3];
>    225		v[12] = blake2b_IV[4] ^ S->t[0];
>    226		v[13] = blake2b_IV[5] ^ S->t[1];
>    227		v[14] = blake2b_IV[6] ^ S->f[0];
>    228		v[15] = blake2b_IV[7] ^ S->f[1];
>    229	
>    230		ROUND(0);
>    231		ROUND(1);
>    232		ROUND(2);
>    233		ROUND(3);
>    234		ROUND(4);
>    235		ROUND(5);
>    236		ROUND(6);
>    237		ROUND(7);
>    238		ROUND(8);
>    239		ROUND(9);
>    240		ROUND(10);
>    241		ROUND(11);
>    242	
>    243		for (i = 0; i < 8; ++i)
>    244			S->h[i] = S->h[i] ^ v[i] ^ v[i + 8];
>  > 245	}

(rest of mail kept for reference)
