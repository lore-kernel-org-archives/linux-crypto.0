Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58A52737F4;
	Sun, 30 Nov 2025 09:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764494029; cv=none; b=bXTIsWBhEbHu5XeQzink+e+uJe+U8hALhFF74G18LxjJSlYfh9A4UsyuHZQJpEreeFWHThal6h+4jHHsrvDKpuPeYtmKnWOT1Xjp+m0mv3dsiVe880NdcXeqjlHxnJiGvXBiIZwMHlB9tLgSS+8QyL9BSqYLmTbTf1y6aMcPhVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764494029; c=relaxed/simple;
	bh=bNKduOJWZ0FYDLvAybtzbp6GKmgT33tkSjld7saEbFE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=TF0TTht7352T9agDPSAUGmJnXY/nsizvTYsQXmL61W+jFZIr24FHTqv34tb3GzrZZMGPfwwKD6d6Xh5p9Y//jj1ZTmUsPO0QXf4wA0baqw1lhxI8WNM1Qf1HgIHH894NR4/Qw7ogRtrUO2XtJmO5rpwFAc6usYKy8I+EPvtx6LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.0.112] (unknown [114.241.82.59])
	by APP-03 (Coremail) with SMTP id rQCowADnd9quCixpX5qqAg--.16371S2;
	Sun, 30 Nov 2025 17:13:20 +0800 (CST)
Message-ID: <b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn>
Date: Sun, 30 Nov 2025 17:13:18 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vivian Wang <wangruikang@iscas.ac.cn>
Subject: lib/crypto: riscv: crypto_zvkb crashes on selftest if no misaligned
 vector support
To: Jerry Shih <jerry.shih@sifive.com>, Eric Biggers <ebiggers@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Ard Biesheuvel <ardb@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Han Gao <gaohan@iscas.ac.cn>, linux-crypto@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:rQCowADnd9quCixpX5qqAg--.16371S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZw18XrWkWFy7GFy5Aw1xuFg_yoWrGrWxpF
	45tr1fCr48Ar4kGr48Ar1rKr4rJw1UCa47Jwn7J3Z8Za1UWw1UXrn2yrW7uF1Dtr1UJry7
	twsYqr4Igw1UKaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
	C2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
	wI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxUqiFxDUUUU
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/

Hi,

We ran into a problem with chacha_zvkb, where having:

- OpenSBI 1.7+ (for FWFT support)
- CRYPTO_CHACHA20POLY1305=y and CRYPTO_SELFTESTS=y (and deps, of course)
- Hardware with Zvkb support
- Hardware *without* misaligned vector load/store support

Leads to a crash on boot during selftest on a vlsseg8e32.v instruction,
because it requires 4-byte alignment of the buffers.

OpenSBI by default emulates vector misaligned operations, however Linux
explicitly disables it with SBI FWFT while not providing vector
misaligned emulation of its own.

This can be reproduced by running everything in Spike without
--misaligned, and is reproducible on stable 6.17.9, 6.18-rc1 and
6.18-rc7. See log at the end. Note that I had to fix chacha_zvkb
somewhat to have it retain a frame pointer to get a stack trace - patch
will be sent later.

Setting cra_alignmask to 3 for everything in crypto/chacha.c "fixes"
this, but there seems to be no obvious way to say "if use_zvkb then
cra_alignmask = 3", and, not being familiar with the crypto API stuff, I
can't figure out a good way to say "if riscv then cra_alignmask = 3" either.

AFAICT, this problem was missed from the very start since commit
bb54668837a0 ("crypto: riscv - add vector crypto accelerated ChaCha20").

Please advise.

Thanks,
Vivian "dramforever" Wang

Crash log:

[    0.160370] Oops - load address misaligned [#1]
[    0.160370] Modules linked in:
[    0.160375] CPU: 0 UID: 0 PID: 44 Comm: cryptomgr_test Not tainted 6.18.0-rc1-dirty #5 NONE
[    0.160385] Hardware name: ucbbar,spike-bare (DT)
[    0.160385] epc : chacha_zvkb+0xa4/0x300
[    0.160395]  ra : chacha_crypt+0xe0/0x134
[    0.160400] epc : ffffffff8051eff8 ra : ffffffff8051eee8 sp : ff2000000022b730
[    0.160405]  gp : ffffffff81a1f650 tp : ff600000027d1800 t0 : 000000006b206574
[    0.160410]  t1 : 00000000000000d8 t2 : 0000000000000001 s0 : ff2000000022b790
[    0.160415]  s1 : ffffffffbca3aa27 a0 : ff2000000022b8a8 a1 : ff600000030a8001
[    0.160420]  a2 : ff600000030b8001 a3 : 0000000000000001 a4 : 000000000000000c
[    0.160425]  a5 : 0000000061707865 a6 : 000000003320646e a7 : 0000000079622d32
[    0.160430]  s2 : 000000001a00608f s3 : ffffffff948be502 s4 : 0000000032e565c6
[    0.160440]  s5 : 000000005b7013d5 s6 : ffffffffc159e731 s7 : ffffffff8a5fbd3a
[    0.160445]  s8 : 0000000000000000 s9 : 0000000000000000 s10: ffffffffaf1e2dd8
[    0.160450]  s11: ffffffff9e109452 t3 : 0000000000000040 t4 : ffffffffbca3aa27
[    0.160455]  t5 : 00000000294d72a5 t6 : ffffffff948be502
[    0.160460] status: 8000000200000720 badaddr: ff600000030a8001 cause: 0000000000000004
[    0.160465] [<ffffffff8051eff8>] chacha_zvkb+0xa4/0x300
[    0.160470] [<ffffffff8051eee8>] chacha_crypt+0xe0/0x134
[    0.160480] [<ffffffff804ab952>] chacha_stream_xor+0x192/0x1cc
[    0.160485] [<ffffffff804abbc6>] crypto_xchacha_crypt+0x1ca/0x1f0
[    0.160495] [<ffffffff8049ea84>] crypto_skcipher_encrypt+0x28/0x44
[    0.160505] [<ffffffff804a7bde>] test_skcipher_vec_cfg+0x266/0x5d8
[    0.160515] [<ffffffff804a7fcc>] test_skcipher+0x7c/0xf4
[    0.160530] [<ffffffff804a80b8>] alg_test_skcipher+0x74/0x16c
[    0.160540] [<ffffffff804a8c08>] alg_test+0xe4/0x49c
[    0.160545] [<ffffffff804a53b8>] cryptomgr_test+0x1c/0x3c
[    0.160555] [<ffffffff8004dff4>] kthread+0xc0/0x178
[    0.160565] [<ffffffff80012306>] ret_from_fork_kernel+0xe/0xcc
[    0.160580] [<ffffffff80b61bbe>] ret_from_fork_kernel_asm+0x16/0x18
[    0.160595] Code: a657 5208 4657 02cc c6d7 5e0c 4757 5e0d c7d7 5e0d (e807) ebc5
[    0.160600] ---[ end trace 0000000000000000 ]---
[    0.160605] Kernel panic - not syncing: Fatal exception in interrupt
[    0.161415] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---


