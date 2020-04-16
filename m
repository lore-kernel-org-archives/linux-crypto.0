Return-Path: <SRS0=NP+Z=6A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4B7C2BA2B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D05812087E
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408163AbgDPGu7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:50:59 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41376 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408551AbgDPGu4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Apr 2020 02:50:56 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jOyMK-0005H0-Cw; Thu, 16 Apr 2020 16:50:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Apr 2020 16:50:48 +1000
Date:   Thu, 16 Apr 2020 16:50:48 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - fix the address of the last entry of S/G
Message-ID: <20200416065048.GB7901@gondor.apana.org.au>
References: <1586275125-20571-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586275125-20571-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 07, 2020 at 06:58:45PM +0300, Iuliana Prodan wrote:
> For skcipher algorithms, the input, output HW S/G tables
> look like this: [IV, src][dst, IV]
> Now, we can have 2 conditions here:
> - there is no IV;
> - src and dst are equal (in-place encryption) and scattered
> and the error is an "off-by-one" in the HW S/G table.
> 
> This issue was seen with KASAN:
> BUG: KASAN: slab-out-of-bounds in skcipher_edesc_alloc+0x95c/0x1018
> 
> Read of size 4 at addr ffff000022a02958 by task cryptomgr_test/321
> 
> CPU: 2 PID: 321 Comm: cryptomgr_test Not tainted
> 5.6.0-rc1-00165-ge4ef8383-dirty #4
> Hardware name: LS1046A RDB Board (DT)
> Call trace:
>  dump_backtrace+0x0/0x260
>  show_stack+0x14/0x20
>  dump_stack+0xe8/0x144
>  print_address_description.isra.11+0x64/0x348
>  __kasan_report+0x11c/0x230
>  kasan_report+0xc/0x18
>  __asan_load4+0x90/0xb0
>  skcipher_edesc_alloc+0x95c/0x1018
>  skcipher_encrypt+0x84/0x150
>  crypto_skcipher_encrypt+0x50/0x68
>  test_skcipher_vec_cfg+0x4d4/0xc10
>  test_skcipher_vec+0x178/0x1d8
>  alg_test_skcipher+0xec/0x230
>  alg_test.part.44+0x114/0x4a0
>  alg_test+0x1c/0x60
>  cryptomgr_test+0x34/0x58
>  kthread+0x1b8/0x1c0
>  ret_from_fork+0x10/0x18
> 
> Allocated by task 321:
>  save_stack+0x24/0xb0
>  __kasan_kmalloc.isra.10+0xc4/0xe0
>  kasan_kmalloc+0xc/0x18
>  __kmalloc+0x178/0x2b8
>  skcipher_edesc_alloc+0x21c/0x1018
>  skcipher_encrypt+0x84/0x150
>  crypto_skcipher_encrypt+0x50/0x68
>  test_skcipher_vec_cfg+0x4d4/0xc10
>  test_skcipher_vec+0x178/0x1d8
>  alg_test_skcipher+0xec/0x230
>  alg_test.part.44+0x114/0x4a0
>  alg_test+0x1c/0x60
>  cryptomgr_test+0x34/0x58
>  kthread+0x1b8/0x1c0
>  ret_from_fork+0x10/0x18
> 
> Freed by task 0:
> (stack is not available)
> 
> The buggy address belongs to the object at ffff000022a02800
>  which belongs to the cache dma-kmalloc-512 of size 512
> The buggy address is located 344 bytes inside of
>  512-byte region [ffff000022a02800, ffff000022a02a00)
> The buggy address belongs to the page:
> page:fffffe00006a8000 refcount:1 mapcount:0 mapping:ffff00093200c400
> index:0x0 compound_mapcount: 0
> flags: 0xffff00000010200(slab|head)
> raw: 0ffff00000010200 dead000000000100 dead000000000122 ffff00093200c400
> raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff000022a02800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff000022a02880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff000022a02900: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>                                                     ^
>  ffff000022a02980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff000022a02a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> 
> Fixes: 334d37c9e263 ("crypto: caam - update IV using HW support")
> Cc: <stable@vger.kernel.org> # v5.3+
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> ---
>  drivers/crypto/caam/caamalg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
