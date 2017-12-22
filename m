From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: n2 - cure use after free
Date: Fri, 22 Dec 2017 19:36:16 +1100
Message-ID: <20171222083616.GA30844@gondor.apana.org.au>
References: <20171219180907.12895-1-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, sparclinux@vger.kernel.org, jengelh@inai.de,
        linux-crypto@vger.kernel.org, rmk+kernel@arm.linux.org.uk
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171219180907.12895-1-jengelh@inai.de>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jan Engelhardt <jengelh@inai.de> wrote:
> queue_cache_init is first called for the Control Word Queue
> (n2_crypto_probe). At that time, queue_cache[0] is NULL and a new
> kmem_cache will be allocated. If the subsequent n2_register_algs call
> fails, the kmem_cache will be released in queue_cache_destroy, but
> queue_cache_init[0] is not set back to NULL.
> 
> So when the Module Arithmetic Unit gets probed next (n2_mau_probe),
> queue_cache_init will not allocate a kmem_cache again, but leave it
> as its bogus value, causing a BUG() to trigger when queue_cache[0] is
> eventually passed to kmem_cache_zalloc:
> 
>        n2_crypto: Found N2CP at /virtual-devices@100/n2cp@7
>        n2_crypto: Registered NCS HVAPI version 2.0
>        called queue_cache_init
>        n2_crypto: md5 alg registration failed
>        n2cp f028687c: /virtual-devices@100/n2cp@7: Unable to register algorithms.
>        called queue_cache_destroy
>        n2cp: probe of f028687c failed with error -22
>        n2_crypto: Found NCP at /virtual-devices@100/ncp@6
>        n2_crypto: Registered NCS HVAPI version 2.0
>        called queue_cache_init
>        kernel BUG at mm/slab.c:2993!
>        Call Trace:
>         [0000000000604488] kmem_cache_alloc+0x1a8/0x1e0
>                  (inlined) kmem_cache_zalloc
>                  (inlined) new_queue
>                  (inlined) spu_queue_setup
>                  (inlined) handle_exec_unit
>         [0000000010c61eb4] spu_mdesc_scan+0x1f4/0x460 [n2_crypto]
>         [0000000010c62b80] n2_mau_probe+0x100/0x220 [n2_crypto]
>         [000000000084b174] platform_drv_probe+0x34/0xc0
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
