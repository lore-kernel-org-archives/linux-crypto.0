From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Write in sha3_update
Date: Fri, 1 Dec 2017 11:07:22 -0800
Message-ID: <20171201190722.GB142348@gmail.com>
References: <001a113a788209b77e055f0aebaf@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+6f724d52da8e3ff8872545bd8444f50f0d174c5f@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35438 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdLATH0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Dec 2017 14:07:26 -0500
Content-Disposition: inline
In-Reply-To: <001a113a788209b77e055f0aebaf@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 28, 2017 at 05:23:01AM -0800, syzbot wrote:
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in memcpy include/linux/string.h:341
> [inline]
> BUG: KASAN: stack-out-of-bounds in sha3_update+0xdf/0x2e0
> crypto/sha3_generic.c:161
> Write of size 4096 at addr ffff8801cca07c40 by task syzkaller076574/3044
> 
> CPU: 1 PID: 3044 Comm: syzkaller076574 Not tainted 4.14.0-mm1+ #25
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
>  check_memory_region+0x137/0x190 mm/kasan/kasan.c:267
>  memcpy+0x37/0x50 mm/kasan/kasan.c:303
>  memcpy include/linux/string.h:341 [inline]
>  sha3_update+0xdf/0x2e0 crypto/sha3_generic.c:161
>  crypto_shash_update+0xcb/0x220 crypto/shash.c:109
>  shash_finup_unaligned+0x2a/0x60 crypto/shash.c:151
>  crypto_shash_finup+0xc4/0x120 crypto/shash.c:165
>  hmac_finup+0x182/0x330 crypto/hmac.c:152
>  crypto_shash_finup+0xc4/0x120 crypto/shash.c:165
>  shash_digest_unaligned+0x9e/0xd0 crypto/shash.c:172
>  crypto_shash_digest+0xc4/0x120 crypto/shash.c:186
>  hmac_setkey+0x36a/0x690 crypto/hmac.c:66
>  crypto_shash_setkey+0xad/0x190 crypto/shash.c:64
>  shash_async_setkey+0x47/0x60 crypto/shash.c:207
>  crypto_ahash_setkey+0xaf/0x180 crypto/ahash.c:200
>  hash_setkey+0x40/0x90 crypto/algif_hash.c:446
>  alg_setkey crypto/af_alg.c:221 [inline]
>  alg_setsockopt+0x2a1/0x350 crypto/af_alg.c:254
>  SYSC_setsockopt net/socket.c:1851 [inline]
>  SyS_setsockopt+0x189/0x360 net/socket.c:1830
>  entry_SYSCALL_64_fastpath+0x1f/0x96

#syz fix: crypto: hmac - require that the underlying hash algorithm is unkeyed
