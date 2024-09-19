Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3625A191F74;
	Thu, 19 Sep 2024 07:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726729710; cv=none; b=Ztr48oJvwxYO8kl1CKNrYn2MhxruKgK4EGzri/5Ru992E2pXF8suGbuXEu0Z1TVPdo3OppBbB4Cx5PuCv67TlyezBkuFArFHgyJTfwM5dfjm2zMRKR9AYIn6Jpr7RIM0gRDGJT+XqZif3WMosPHukw0o2L+0tWuMiwz0u8REUXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726729710; c=relaxed/simple;
	bh=+jswPnTjUBFJ2tndsS3fsCBd6aFxviaBp2KnFOJaAF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qkkYl2tG1DcADust0EWb9U1bVZjvjWEH9aImukC4x1A20c14u8SxEY1vrHsBcLusTl3VrT/aAWdgTtL6ysRXz3AKUfi3iIv0wchl4vPA4gyo8ectXnuJBDMHyfJHyoqY0gpC2askpgEY5+5OXTi/HcY2lbZ3ndZ1zFnS0O0IXEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4X8RSV2VlQz9tQt;
	Thu, 19 Sep 2024 09:08:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0GgCnPIhWzuN; Thu, 19 Sep 2024 09:08:26 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4X8RSV1NVVz9tQs;
	Thu, 19 Sep 2024 09:08:26 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 1C3148B775;
	Thu, 19 Sep 2024 09:08:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id epjVah3m3Yyp; Thu, 19 Sep 2024 09:08:26 +0200 (CEST)
Received: from [192.168.234.38] (unknown [192.168.234.38])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 890448B763;
	Thu, 19 Sep 2024 09:08:25 +0200 (CEST)
Message-ID: <77655d9e-fc05-4300-8f0d-7b2ad840d091@csgroup.eu>
Date: Thu, 19 Sep 2024 09:08:25 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
To: Xi Ruoyao <xry111@xry111.site>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>
Cc: linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
 Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
References: <20240901061315.15693-1-xry111@xry111.site>
 <20240901061315.15693-3-xry111@xry111.site>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20240901061315.15693-3-xry111@xry111.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Xi,

Le 01/09/2024 à 08:13, Xi Ruoyao a écrit :
> Hook up the generic vDSO implementation to the LoongArch vDSO data page
> by providing the required __arch_chacha20_blocks_nostack,
> __arch_get_k_vdso_rng_data, and getrandom_syscall implementations.
> 
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> ---

...

> diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vdso/vgetrandom-chacha.S
> new file mode 100644
> index 000000000000..7e86a50f6e85
> --- /dev/null
> +++ b/arch/loongarch/vdso/vgetrandom-chacha.S
> @@ -0,0 +1,242 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserved.
> + */
> +
> +#include <asm/asm.h>
> +#include <asm/regdef.h>
> +#include <linux/linkage.h>
> +
> +.text
> +
> +/* Salsa20 quarter-round */
> +.macro	QR	a b c d
> +	add.w		\a, \a, \b
> +	xor		\d, \d, \a
> +	rotri.w		\d, \d, 16
> +
> +	add.w		\c, \c, \d
> +	xor		\b, \b, \c
> +	rotri.w		\b, \b, 20
> +
> +	add.w		\a, \a, \b
> +	xor		\d, \d, \a
> +	rotri.w		\d, \d, 24
> +
> +	add.w		\c, \c, \d
> +	xor		\b, \b, \c
> +	rotri.w		\b, \b, 25
> +.endm
> +

I know nothing about Loongarch assembly and execution performance, but I 
see that GCC groups operations by 4 when building 
reference_chacha20_blocks() from vdso_test_chacha, see below.

Shouldn't you do the same and group ROUNDs by 4 just like I did on 
powerpc ? 
(https://github.com/torvalds/linux/blob/master/arch/powerpc/kernel/vdso/vgetrandom-chacha.S)

0000000000000134 <.L3>:
  134:	001061d8 	add.w       	$s1, $t2, $s1
  138:	0015c312 	xor         	$t6, $s1, $t4
  13c:	26000070 	ldptr.d     	$t4, $sp, 0
  140:	001036d6 	add.w       	$fp, $fp, $t1
  144:	001065f9 	add.w       	$s2, $t3, $s2
  148:	0010335a 	add.w       	$s3, $s3, $t0
  14c:	00159ad3 	xor         	$t7, $fp, $a2
  150:	0015c344 	xor         	$a0, $s3, $t4
  154:	0015c731 	xor         	$t5, $s2, $t5
  158:	004cc273 	rotri.w     	$t7, $t7, 0x10
  15c:	004cc252 	rotri.w     	$t6, $t6, 0x10
  160:	004cc231 	rotri.w     	$t5, $t5, 0x10
  164:	004cc084 	rotri.w     	$a0, $a0, 0x10
  168:	00104766 	add.w       	$a2, $s4, $t5
  16c:	00102088 	add.w       	$a4, $a0, $a4
  170:	00102669 	add.w       	$a5, $t7, $a5
  174:	001048e7 	add.w       	$a3, $a3, $t6
  178:	0015b530 	xor         	$t4, $a5, $t1
  17c:	0015b10c 	xor         	$t0, $a4, $t0
  180:	0015b8ee 	xor         	$t2, $a3, $t2
  184:	0015bccf 	xor         	$t3, $a2, $t3
  188:	004cd18d 	rotri.w     	$t1, $t0, 0x14
  18c:	004cd210 	rotri.w     	$t4, $t4, 0x14
  190:	004cd1ce 	rotri.w     	$t2, $t2, 0x14
  194:	004cd1ef 	rotri.w     	$t3, $t3, 0x14
  198:	001042d6 	add.w       	$fp, $fp, $t4
  19c:	00103b18 	add.w       	$s1, $s1, $t2
  1a0:	00103f39 	add.w       	$s2, $s2, $t3
  1a4:	0010375a 	add.w       	$s3, $s3, $t1
  1a8:	0015ced3 	xor         	$t7, $fp, $t7
  1ac:	0015cb12 	xor         	$t6, $s1, $t6
  1b0:	0015c731 	xor         	$t5, $s2, $t5
  1b4:	00159344 	xor         	$a0, $s3, $a0
  1b8:	004ce274 	rotri.w     	$t8, $t7, 0x18
  1bc:	004ce084 	rotri.w     	$a0, $a0, 0x18
  1c0:	004ce253 	rotri.w     	$t7, $t6, 0x18
  1c4:	004ce232 	rotri.w     	$t6, $t5, 0x18
  1c8:	00105129 	add.w       	$a5, $a5, $t8
  1cc:	00101111 	add.w       	$t5, $a4, $a0
  1d0:	00104ce7 	add.w       	$a3, $a3, $t7
  1d4:	001048c6 	add.w       	$a2, $a2, $t6
  1d8:	0015c130 	xor         	$t4, $a5, $t4
  1dc:	0015b8ee 	xor         	$t2, $a3, $t2
  1e0:	0015bccf 	xor         	$t3, $a2, $t3
  1e4:	0015b62d 	xor         	$t1, $t5, $t1
  1e8:	004ce610 	rotri.w     	$t4, $t4, 0x19
  1ec:	004ce5ce 	rotri.w     	$t2, $t2, 0x19
  1f0:	004ce5ef 	rotri.w     	$t3, $t3, 0x19
  1f4:	004ce5ad 	rotri.w     	$t1, $t1, 0x19
  1f8:	00103ad6 	add.w       	$fp, $fp, $t2
  1fc:	00103f18 	add.w       	$s1, $s1, $t3
  200:	00103739 	add.w       	$s2, $s2, $t1
  204:	0010435a 	add.w       	$s3, $s3, $t4
  208:	001592c4 	xor         	$a0, $fp, $a0
  20c:	0015d314 	xor         	$t8, $s1, $t8
  210:	0015cf33 	xor         	$t7, $s2, $t7
  214:	0015cb52 	xor         	$t6, $s3, $t6
  218:	004cc084 	rotri.w     	$a0, $a0, 0x10
  21c:	004cc294 	rotri.w     	$t8, $t8, 0x10
  220:	004cc273 	rotri.w     	$t7, $t7, 0x10
  224:	004cc252 	rotri.w     	$t6, $t6, 0x10
  228:	001010dc 	add.w       	$s5, $a2, $a0
  22c:	0010523d 	add.w       	$s6, $t5, $t8
  230:	00104d3e 	add.w       	$s7, $a5, $t7
  234:	001048ff 	add.w       	$s8, $a3, $t6
  238:	0015c3ec 	xor         	$t0, $s8, $t4
  23c:	0015bb8e 	xor         	$t2, $s5, $t2
  240:	0015bfaf 	xor         	$t3, $s6, $t3
  244:	0015b7cd 	xor         	$t1, $s7, $t1
  248:	004cd1ad 	rotri.w     	$t1, $t1, 0x14
  24c:	004cd18c 	rotri.w     	$t0, $t0, 0x14
  250:	004cd1ce 	rotri.w     	$t2, $t2, 0x14
  254:	004cd1ef 	rotri.w     	$t3, $t3, 0x14
  258:	00103ad7 	add.w       	$s0, $fp, $t2
  25c:	00103f0a 	add.w       	$a6, $s1, $t3
  260:	0010372b 	add.w       	$a7, $s2, $t1
  264:	00103341 	add.w       	$ra, $s3, $t0
  268:	001592e4 	xor         	$a0, $s0, $a0
  26c:	0015d154 	xor         	$t8, $a6, $t8
  270:	0015cd73 	xor         	$t7, $a7, $t7
  274:	0015c832 	xor         	$t6, $ra, $t6
  278:	004ce084 	rotri.w     	$a0, $a0, 0x18
  27c:	004ce294 	rotri.w     	$t8, $t8, 0x18
  280:	004ce273 	rotri.w     	$t7, $t7, 0x18
  284:	004ce252 	rotri.w     	$t6, $t6, 0x18
  288:	0010139c 	add.w       	$s5, $s5, $a0
  28c:	001053bd 	add.w       	$s6, $s6, $t8
  290:	00104fde 	add.w       	$s7, $s7, $t7
  294:	00104bff 	add.w       	$s8, $s8, $t6
  298:	0015b7d1 	xor         	$t5, $s7, $t1
  29c:	0015bb8e 	xor         	$t2, $s5, $t2
  2a0:	0015b3ed 	xor         	$t1, $s8, $t0
  2a4:	0015bfaf 	xor         	$t3, $s6, $t3
  2a8:	0040808c 	slli.w      	$t0, $a0, 0x0
  2ac:	004ce631 	rotri.w     	$t5, $t5, 0x19
  2b0:	004ce5ce 	rotri.w     	$t2, $t2, 0x19
  2b4:	004ce5ef 	rotri.w     	$t3, $t3, 0x19
  2b8:	004ce5ad 	rotri.w     	$t1, $t1, 0x19
  2bc:	2700006c 	stptr.d     	$t0, $sp, 0
  2c0:	02bffca5 	addi.w      	$a1, $a1, -1(0xfff)
  2c4:	0040822c 	slli.w      	$t0, $t5, 0x0
  2c8:	004082f6 	slli.w      	$fp, $s0, 0x0
  2cc:	0040839b 	slli.w      	$s4, $s5, 0x0
  2d0:	004081ce 	slli.w      	$t2, $t2, 0x0
  2d4:	00408158 	slli.w      	$s1, $a6, 0x0
  2d8:	00408286 	slli.w      	$a2, $t8, 0x0
  2dc:	004083a8 	slli.w      	$a4, $s6, 0x0
  2e0:	004081ef 	slli.w      	$t3, $t3, 0x0
  2e4:	00408179 	slli.w      	$s2, $a7, 0x0
  2e8:	00408270 	slli.w      	$t4, $t7, 0x0
  2ec:	004083c9 	slli.w      	$a5, $s7, 0x0
  2f0:	0040803a 	slli.w      	$s3, $ra, 0x0
  2f4:	00408251 	slli.w      	$t5, $t6, 0x0
  2f8:	004083e7 	slli.w      	$a3, $s8, 0x0
  2fc:	004081ad 	slli.w      	$t1, $t1, 0x0
  300:	47fe34bf 	bnez        	$a1, -460(0x7ffe34)	# 134 <.L3>

Christophe
