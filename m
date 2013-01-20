From: Alexander Boyko <alexander_boyko@xyratex.com>
Subject: Re: [cryptodev:master 22/36] arch/x86/crypto/crc32-pclmul_asm.S:87:2:
 warning: #warning Using 32bit code support
Date: Sun, 20 Jan 2013 09:55:37 +0400
Message-ID: <50FB86D9.1070200@xyratex.com>
References: <50fb3f38.VIxxNsjMujPGjroT%fengguang.wu@intel.com> <20130120005545.GA3328@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63942 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3ATFzt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Jan 2013 00:55:49 -0500
Received: by mail-ee0-f49.google.com with SMTP id d4so2298098eek.36
        for <linux-crypto@vger.kernel.org>; Sat, 19 Jan 2013 21:55:48 -0800 (PST)
In-Reply-To: <20130120005545.GA3328@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

You can kill it.
1/20/13 4:55 AM, Herbert Xu =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Sun, Jan 20, 2013 at 08:50:00AM +0800, kbuild test robot wrote:
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto=
dev-2.6.git master
>> head:   d3f5188dfea70e7ea6570bd4bc9d6d7dbd431e39
>> commit: 78c37d191dd6899d8c219fee597a17d6e3c5d288 [22/36] crypto: crc=
32 - add crc32 pclmulqdq implementation and wrappers for table implemen=
tation
>> config: make ARCH=3Di386 allyesconfig
>>
>> All warnings:
>>
>>>> arch/x86/crypto/crc32-pclmul_asm.S:87:2: warning: #warning Using 3=
2bit code support [-Wcpp]
>> vim +87 arch/x86/crypto/crc32-pclmul_asm.S
>>
>>     71	/*
>>     72	 * #define CRCPOLY_TRUE_LE_FULL 0x1DB710641LL
>>     73	 *
>>     74	 * Barrett Reduction constant (u64`) =3D u` =3D (x**64 / P(x)=
)` =3D 0x1F7011641LL
>>     75	 * #define CONSTANT_RU  0x1F7011641LL
>>     76	 */
>>     77	.Lconstant_RUpoly:
>>     78		.octa 0x00000001F701164100000001DB710641
>>     79=09
>>     80	#define CONSTANT %xmm0
>>     81=09
>>     82	#ifdef __x86_64__
>>     83	#define BUF     %rdi
>>     84	#define LEN     %rsi
>>     85	#define CRC     %edx
>>     86	#else
>>   > 87	#warning Using 32bit code support
> Do we need this warning or can I kill it?
>
> Thanks!
