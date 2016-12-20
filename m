From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: testmgr: Use linear alias for test input
Date: Tue, 20 Dec 2016 12:12:29 +0000
Message-ID: <CAKv+Gu-1fXgNfuBByNWsDuT-Ft3gThHy3AYo2DF4rvKwrPtP4Q@mail.gmail.com>
References: <1482190646-7720-1-git-send-email-labbott@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Christopher Covington <cov@codeaurora.org>
To: Laura Abbott <labbott@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482190646-7720-1-git-send-email-labbott@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 19 December 2016 at 23:37, Laura Abbott <labbott@redhat.com> wrote:
> Christopher Covington reported a crash on aarch64 on recent Fedora
> kernels:
>
> kernel BUG at ./include/linux/scatterlist.h:140!
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 2 PID: 752 Comm: cryptomgr_test Not tainted 4.9.0-11815-ge93b1cc #162
> Hardware name: linux,dummy-virt (DT)
> task: ffff80007c650080 task.stack: ffff800008910000
> PC is at sg_init_one+0xa0/0xb8
> LR is at sg_init_one+0x24/0xb8
> ...
> [<ffff000008398db8>] sg_init_one+0xa0/0xb8
> [<ffff000008350a44>] test_acomp+0x10c/0x438
> [<ffff000008350e20>] alg_test_comp+0xb0/0x118
> [<ffff00000834f28c>] alg_test+0x17c/0x2f0
> [<ffff00000834c6a4>] cryptomgr_test+0x44/0x50
> [<ffff0000080dac70>] kthread+0xf8/0x128
> [<ffff000008082ec0>] ret_from_fork+0x10/0x50
>
> The test vectors used for input are part of the kernel image. These
> inputs are passed as a buffer to sg_init_one which eventually blows up
> with BUG_ON(!virt_addr_valid(buf)). On arm64, virt_addr_valid returns
> false for the kernel image since virt_to_page will not return the
> correct page. The kernel image is also aliased to the linear map so get
> the linear alias and pass that to the scatterlist instead.
>
> Reported-by: Christopher Covington <cov@codeaurora.org>
> Fixes: d7db7a882deb ("crypto: acomp - update testmgr with support for acomp")
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> x86 supports virt_addr_valid working on kernel image addresses but arm64 is
> more strict. This is the direction things have been moving with my
> CONFIG_DEBUG_VIRTUAL series for arm64 which is tightening the definition of
> __pa/__pa_symbol.

A helper function would be nice, so that we can call
sg_init_table/sg_set_page directly, and avoid the redundant
virt_to_phys(__va()) translation (and add a comment *why* we should
not use sg_init_one() with the address of a kernel symbol).

But I will leave it up to Herbert to decide whether he prefers that or not.

In any case,
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/testmgr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index f616ad7..f5bac10 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1464,7 +1464,7 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
>
>                 memset(output, 0, dlen);
>                 init_completion(&result.completion);
> -               sg_init_one(&src, ctemplate[i].input, ilen);
> +               sg_init_one(&src, __va(__pa_symbol(ctemplate[i].input)), ilen);
>                 sg_init_one(&dst, output, dlen);
>
>                 req = acomp_request_alloc(tfm);
> @@ -1513,7 +1513,7 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
>
>                 memset(output, 0, dlen);
>                 init_completion(&result.completion);
> -               sg_init_one(&src, dtemplate[i].input, ilen);
> +               sg_init_one(&src, __va(__pa_symbol(dtemplate[i].input)), ilen);
>                 sg_init_one(&dst, output, dlen);
>
>                 req = acomp_request_alloc(tfm);
> --
> 2.7.4
>
