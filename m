From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v5] crypto: s5p-sss: Add HASH support for Exynos
Date: Mon, 9 Oct 2017 20:52:52 +0200
Message-ID: <20171009185252.h57236ngyotx3vrl@kozik-lap>
References: <CGME20171009111232eucas1p1d17afaae66931a7dd234dbfa1d5a193f@eucas1p1.samsung.com>
 <afa6482f-dc1e-6aab-5754-fa86f554e0b2@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37808 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdJISw4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Oct 2017 14:52:56 -0400
Content-Disposition: inline
In-Reply-To: <afa6482f-dc1e-6aab-5754-fa86f554e0b2@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 09, 2017 at 01:12:30PM +0200, Kamil Konieczny wrote:
> Add support for MD5, SHA1, SHA256 hash algorithms for Exynos HW.
> It uses the crypto framework asynchronous hash api.
> It is based on omap-sham.c driver.
> S5P has some HW differencies and is not implemented.
> 
> Modifications in s5p-sss:
> 
> - Add hash supporting structures and functions.
> 
> - Modify irq handler to handle both aes and hash signals.
> 
> - Resize resource end in probe if EXYNOS_HASH is enabled in
>   Kconfig.
> 
> - Add new copyright line and new author.
> 
> - Tested on Odroid-U3 with Exynos 4412 CPU, kernel 4.13-rc6
>   with crypto run-time self test testmgr
>   and with tcrypt module with: modprobe tcrypt sec=1 mode=N
>   where N=402, 403, 404 (MD5, SHA1, SHA256).
> 
> Modifications in drivers/crypto/Kconfig:
> 
> - Add new CRYPTO_DEV_EXYNOS_HASH, depend on !EXYNOS_RNG
>   and CRYPTO_DEV_S5P
> 
> - Select sw algorithms MD5, SHA1 and SHA256 in EXYNOS_HASH
>   as they are nedded for fallback.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
> version 5:
> - fix suggested by Krzysztof Kozlowski: change defines HASH_OP into enum, fix
>   comments
> 
> version 4:
> - fixes suggested by Krzysztof Kozlowski: reformat comments, convert context
>   flags into two bool vars, drop SSS_ALIGNED, change name of SSS_DMA_ALIGN and
>   SSS_DMA_ALIGN_MASK, split assignments into separate lines, use IS_ENABLED in
>   place of ifdef, remove sss_hash_algs_info and simplify register and deregister
>   HASH algs
> 
> version 3:
> - many fixes suggested by Krzysztof Kozlowski: comments, uppercases in const,
>   remove unused defines, remove unused variable bs, constify aes_variant,
>   remove global var use_hash, remove WARN_ON, improve hash_import(),
>   change goto label into 'out' in s5p_hash_handle_queue(), reorder variable
>   declarations, add spinlock to protect clearing HASH_FLAGS_BUSY
> - simplify code: replace one-line functions s5p_hash_update_req(),
>   s5p_hash_final_req() with call to s5p_hash_xmit_dma(), and delete them
> - replace call to s5p_hash_hw_init() into s5p_ahash_dma_init() and delete it
> - fix clearing shash flag CRYPTO_TFM_REQ_MAY_SLEEP
> - fix s5p_hash_set_flow()
> 
> version 2:
> - change patch format so number of lines drops
> - change in Kconfig as suggested by Krzysztof Kozlowski, add
> 	EXYNOS_HASH subsection
> - change #ifndef EXYNOS_RNG into #ifdef CRYPTO_DEV_EXYNOS_HASH
> - remove style fixups in aes, as they should go in separate patch
> - remove FLOW_LOG, FLOW_DUMP macros and its uses
> - remove #if 0 ... endif
> - remove unused function hash_wait and its defines
> - fix compiler warning in dev_dbg
> - remove some comments
> - other minor fixes in comments
> 
>  drivers/crypto/Kconfig   |   14 +
>  drivers/crypto/s5p-sss.c | 1441 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 1445 insertions(+), 10 deletions(-)
> 

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
