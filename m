Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3C9C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 06:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbiA1GYa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:24:30 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60602 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346412AbiA1GYa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 01:24:30 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDKgC-00011H-T4; Fri, 28 Jan 2022 17:24:17 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 17:24:16 +1100
Date:   Fri, 28 Jan 2022 17:24:16 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kees Cook <keescook@chromium.org>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Suheil Chandran <schandran@marvell.com>,
        Shijith Thotton <sthotton@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3] crypto: octeontx2 - Avoid stack variable overflow
Message-ID: <YfOMELhRJYYOsHZ6@gondor.apana.org.au>
References: <20220112203811.3951406-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112203811.3951406-1-keescook@chromium.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 12, 2022 at 12:38:11PM -0800, Kees Cook wrote:
> Building with -Warray-bounds showed a stack variable array index
> overflow. Increase the expected size of the array to avoid the warning:
> 
> In file included from ./include/linux/printk.h:555,
>                  from ./include/asm-generic/bug.h:22,
>                  from ./arch/x86/include/asm/bug.h:84,
>                  from ./include/linux/bug.h:5,
>                  from ./include/linux/mmdebug.h:5,
>                  from ./include/linux/gfp.h:5,
>                  from ./include/linux/firmware.h:7,
>                  from drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:5:
> drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c: In function 'otx2_cpt_print_uc_dbg_info':
> ./include/linux/dynamic_debug.h:162:33: warning: array subscript 4 is above array bounds of 'u32[4]' {aka 'unsigned int[4]'} [-Warray-bounds]
>   162 |         _dynamic_func_call(fmt, __dynamic_pr_debug,             \
>       |                                 ^
> ./include/linux/dynamic_debug.h:134:17: note: in definition of macro '__dynamic_func_call'
>   134 |                 func(&id, ##__VA_ARGS__);               \
>       |                 ^~~~
> ./include/linux/dynamic_debug.h:162:9: note: in expansion of macro '_dynamic_func_call'
>   162 |         _dynamic_func_call(fmt, __dynamic_pr_debug,             \
>       |         ^~~~~~~~~~~~~~~~~~
> ./include/linux/printk.h:570:9: note: in expansion of macro 'dynamic_pr_debug'
>   570 |         dynamic_pr_debug(fmt, ##__VA_ARGS__)
>       |         ^~~~~~~~~~~~~~~~
> drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1807:41: note: in expansion of macro 'pr_debug'
>  1807 |                                         pr_debug("Mask: %8.8x %8.8x %8.8x %8.8x %8.8x",
>       |                                         ^~~~~~~~
> drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1765:13: note: while referencing 'mask'
>  1765 |         u32 mask[4];
>       |             ^~~~
> 
> This is justified because the mask size (eng_grps->engs_num) can be at
> most 144 (OTX2_CPT_MAX_ENGINES bits), which is larger than available
> storage. 4 * 32 == 128, so this must be 5: 5 * 32bit = 160.
> 
> Additionally clear the mask before conversion so trailing bits are zero.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Boris Brezillon <bbrezillon@kernel.org>
> Cc: Arnaud Ebalard <arno@natisbad.org>
> Cc: Srujana Challa <schalla@marvell.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Suheil Chandran <schandran@marvell.com>
> Cc: Shijith Thotton <sthotton@marvell.com>
> Cc: Lukasz Bartosik <lbartosik@marvell.com>
> Cc: linux-crypto@vger.kernel.org
> Fixes: d9d7749773e8 ("crypto: octeontx2 - add apis for custom engine groups")
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v1: https://lore.kernel.org/lkml/20211215225558.1995027-1-keescook@chromium.org/
> v2: https://lore.kernel.org/lkml/20220105174953.2433019-1-keescook@chromium.org/
> v3:
>  - Fix commit log math typo
>  - Add Ack
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
