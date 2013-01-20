From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 22/36]
 arch/x86/crypto/crc32-pclmul_asm.S:87:2: warning: #warning Using 32bit
 code support
Date: Sun, 20 Jan 2013 11:55:45 +1100
Message-ID: <20130120005545.GA3328@gondor.apana.org.au>
References: <50fb3f38.VIxxNsjMujPGjroT%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Boyko <alexander_boyko@xyratex.com>
To: kbuild test robot <fengguang.wu@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:49183 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752203Ab3ATAzr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 19:55:47 -0500
Content-Disposition: inline
In-Reply-To: <50fb3f38.VIxxNsjMujPGjroT%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 20, 2013 at 08:50:00AM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   d3f5188dfea70e7ea6570bd4bc9d6d7dbd431e39
> commit: 78c37d191dd6899d8c219fee597a17d6e3c5d288 [22/36] crypto: crc32 - add crc32 pclmulqdq implementation and wrappers for table implementation
> config: make ARCH=i386 allyesconfig
> 
> All warnings:
> 
> >> arch/x86/crypto/crc32-pclmul_asm.S:87:2: warning: #warning Using 32bit code support [-Wcpp]
> 
> vim +87 arch/x86/crypto/crc32-pclmul_asm.S
> 
>     71	/*
>     72	 * #define CRCPOLY_TRUE_LE_FULL 0x1DB710641LL
>     73	 *
>     74	 * Barrett Reduction constant (u64`) = u` = (x**64 / P(x))` = 0x1F7011641LL
>     75	 * #define CONSTANT_RU  0x1F7011641LL
>     76	 */
>     77	.Lconstant_RUpoly:
>     78		.octa 0x00000001F701164100000001DB710641
>     79	
>     80	#define CONSTANT %xmm0
>     81	
>     82	#ifdef __x86_64__
>     83	#define BUF     %rdi
>     84	#define LEN     %rsi
>     85	#define CRC     %edx
>     86	#else
>   > 87	#warning Using 32bit code support

Do we need this warning or can I kill it?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
