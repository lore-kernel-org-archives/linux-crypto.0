From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Write in sha3_update
Date: Tue, 28 Nov 2017 13:35:49 -0800
Message-ID: <20171128213549.GG45321@gmail.com>
References: <f403045fbfa0c86946055f111763@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+738fe8ad300f43de6dd637f91d595f9fc0df79ba@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f403045fbfa0c86946055f111763@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 28, 2017 at 12:45:01PM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> QAT: Invalid ioctl
> QAT: Invalid ioctl
> QAT: Invalid ioctl
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in memcpy include/linux/string.h:341 [inline]
> BUG: KASAN: slab-out-of-bounds in sha3_update+0xdf/0x2e0
> crypto/sha3_generic.c:161
> Write of size 192 at addr ffff8801bf3f80fc by task syz-executor3/18788
> 
> CPU: 1 PID: 18788 Comm: syz-executor3 Not tainted 4.15.0-rc1+ #197
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
>  hmac_update+0x7e/0xa0 crypto/hmac.c:122
>  crypto_shash_update+0xcb/0x220 crypto/shash.c:109
>  kdf_ctr security/keys/dh.c:181 [inline]
>  keyctl_dh_compute_kdf security/keys/dh.c:226 [inline]
>  __keyctl_dh_compute+0x16d8/0x1a00 security/keys/dh.c:398
>  keyctl_dh_compute+0xac/0xf3 security/keys/dh.c:434
>  SYSC_keyctl security/keys/keyctl.c:1745 [inline]
>  SyS_keyctl+0x72/0x2c0 security/keys/keyctl.c:1641
>  entry_SYSCALL_64_fastpath+0x1f/0x96

#syz dup: KASAN: stack-out-of-bounds Write in sha3_update
