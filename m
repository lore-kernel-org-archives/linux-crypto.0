From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: KASAN errors after 21c8e72037fb ("crypto: testmgr - use
 calculated count for number of test vectors")
Date: Tue, 28 Feb 2017 20:37:56 +0000
Message-ID: <CAKv+Gu-a0A8cWn+xYUDEEb2f=dKS+dQpFXK41Yznip0UOwQvTQ@mail.gmail.com>
References: <d4b417e1-f34b-f706-8806-4dd3814d1f1f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Laura Abbott <labbott@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d4b417e1-f34b-f706-8806-4dd3814d1f1f@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 28 February 2017 at 20:17, Laura Abbott <labbott@redhat.com> wrote:
> Hi,
>
> While attempting to debug something else, I saw KASAN errors
> from the crypto test with ccm:
>
> [   28.231615] ==================================================================
> [   28.232007] BUG: KASAN: global-out-of-bounds in __test_aead+0x9d9/0x2200 at addr ffffffff8212fca0
> [   28.232007] Read of size 16 by task cryptomgr_test/1107
> [   28.232007] Address belongs to variable 0xffffffff8212fca0
> [   28.232007] CPU: 0 PID: 1107 Comm: cryptomgr_test Not tainted 4.10.0+ #45
> [   28.232007] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
> [   28.232007] Call Trace:
> [   28.232007]  dump_stack+0x63/0x8a
> [   28.232007]  kasan_report.part.1+0x4a7/0x4e0
> [   28.232007]  ? __test_aead+0x9d9/0x2200
> [   28.232007]  ? crypto_ccm_init_crypt+0x218/0x3c0 [ccm]
> [   28.232007]  kasan_report+0x20/0x30
> [   28.232007]  check_memory_region+0x13c/0x1a0
> [   28.232007]  memcpy+0x23/0x50
> [   28.232007]  __test_aead+0x9d9/0x2200
> [   28.232007]  ? kasan_unpoison_shadow+0x35/0x50
> [   28.232007]  ? alg_test_akcipher+0xf0/0xf0
> [   28.232007]  ? crypto_skcipher_init_tfm+0x2e3/0x310
> [   28.232007]  ? crypto_spawn_tfm2+0x37/0x60
> [   28.232007]  ? crypto_ccm_init_tfm+0xa9/0xd0 [ccm]
> [   28.232007]  ? crypto_aead_init_tfm+0x7b/0x90
> [   28.232007]  ? crypto_alloc_tfm+0xc4/0x190
> [   28.232007]  test_aead+0x28/0xc0
> [   28.232007]  alg_test_aead+0x54/0xd0
> [   28.232007]  alg_test+0x1eb/0x3d0
> [   28.232007]  ? alg_find_test+0x90/0x90
> [   28.232007]  ? __sched_text_start+0x8/0x8
> [   28.232007]  ? __wake_up_common+0x70/0xb0
> [   28.232007]  cryptomgr_test+0x4d/0x60
> [   28.232007]  kthread+0x173/0x1c0
> [   28.232007]  ? crypto_acomp_scomp_free_ctx+0x60/0x60
> [   28.232007]  ? kthread_create_on_node+0xa0/0xa0
> [   28.232007]  ret_from_fork+0x2c/0x40
> [   28.232007] Memory state around the buggy address:
> [   28.232007]  ffffffff8212fb80: 00 00 00 00 01 fa fa fa fa fa fa fa 00 00 00 00
> [   28.232007]  ffffffff8212fc00: 00 01 fa fa fa fa fa fa 00 00 00 00 01 fa fa fa
> [   28.232007] >ffffffff8212fc80: fa fa fa fa 00 05 fa fa fa fa fa fa 00 00 00 00
> [   28.232007]                                   ^
> [   28.232007]  ffffffff8212fd00: 01 fa fa fa fa fa fa fa 00 00 00 00 01 fa fa fa
> [   28.232007]  ffffffff8212fd80: fa fa fa fa 00 00 00 00 00 05 fa fa fa fa fa fa
> [   28.232007] ==================================================================
>
> This seems to be caused by 21c8e72037fb ("crypto: testmgr -
> use calculated count for number of test vectors") but I think
> it's because it  now exposes this test vector which always causes the failure.
>
> {
>                 .key    = "\x7c\xc8\x18\x3b\x8d\x99\xe0\x7c"
>                           "\x45\x41\xb8\xbd\x5c\xa7\xc2\x32"
>                           "\x8a\xb8\x02\x59\xa4\xfe\xa9\x2c"
>                           "\x09\x75\x9a\x9b\x3c\x9b\x27\x39",
>                 .klen   = 32,
>                 .iv     = "\x03\xf9\xd9\x4e\x63\xb5\x3d\x9d"
>                           "\x43\xf6\x1e\x50",
>                 .assoc  = "\x57\xf5\x6b\x8b\x57\x5c\x3d\x3b"
>                           "\x13\x02\x01\x0c\x83\x4c\x96\x35"
>                           "\x8e\xd6\x39\xcf\x7d\x14\x9b\x94"
>                           "\xb0\x39\x36\xe6\x8f\x57\xe0\x13",
>                 .alen   = 32,
>                 .input  = "\x3b\x6c\x29\x36\xb6\xef\x07\xa6"
>                           "\x83\x72\x07\x4f\xcf\xfa\x66\x89"
>                           "\x5f\xca\xb1\xba\xd5\x8f\x2c\x27"
>                           "\x30\xdb\x75\x09\x93\xd4\x65\xe4",
>                 .ilen   = 32,
>                 .result = "\xb0\x88\x5a\x33\xaa\xe5\xc7\x1d"
>                           "\x85\x23\xc7\xc6\x2f\xf4\x1e\x3d"
>                           "\xcc\x63\x44\x25\x07\x78\x4f\x9e"
>                           "\x96\xb8\x88\xeb\xbc\x48\x1f\x06"
>                           "\x39\xaf\x39\xac\xd8\x4a\x80\x39"
>                           "\x7b\x72\x8a\xf7",
>                 .rlen   = 44,
>         },
>
>
> If I pad iv with extra NULL bytes the KASAN error goes away.
>
> Thoughts?
>

CCM IVs are 16 bytes, but due to the way they are constructed
internally, the final couple of bytes of input IV are dont-cares.

Apparently, we do read all 16 bytes, which triggers the KASAN errors.

So adding any kind of padding bytes to pad to length 16 should fix the
issue, and so your proposed fix is correct.

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
