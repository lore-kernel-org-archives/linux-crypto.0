Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BE0C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62ABB20B1F
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbfBAGv4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:51:56 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:57090 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBAGvz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:51:55 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpSg4-0000Gh-DD; Fri, 01 Feb 2019 14:51:52 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpSg4-0005p0-9X; Fri, 01 Feb 2019 14:51:52 +0800
Date:   Fri, 1 Feb 2019 14:51:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Roland Hieber <rhi@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH v2 2/2] crypto: caam - fix DMA mapping of stack memory
Message-ID: <20190201065152.lii5qhftm3dtgwbl@gondor.apana.org.au>
References: <VI1PR0402MB348525A6FEFD55F6896C9249989B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190126180215.9842-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190126180215.9842-1-horia.geanta@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jan 26, 2019 at 08:02:15PM +0200, Horia Geantă wrote:
> Roland reports the following issue and provides a root cause analysis:
> 
> "On a v4.19 i.MX6 system with IMA and CONFIG_DMA_API_DEBUG enabled, a
> warning is generated when accessing files on a filesystem for which IMA
> measurement is enabled:
> 
>     ------------[ cut here ]------------
>     WARNING: CPU: 0 PID: 1 at kernel/dma/debug.c:1181 check_for_stack.part.9+0xd0/0x120
>     caam_jr 2101000.jr0: DMA-API: device driver maps memory from stack [addr=b668049e]
>     Modules linked in:
>     CPU: 0 PID: 1 Comm: switch_root Not tainted 4.19.0-20181214-1 #2
>     Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
>     Backtrace:
>     [<c010efb8>] (dump_backtrace) from [<c010f2d0>] (show_stack+0x20/0x24)
>     [<c010f2b0>] (show_stack) from [<c08b04f4>] (dump_stack+0xa0/0xcc)
>     [<c08b0454>] (dump_stack) from [<c012b610>] (__warn+0xf0/0x108)
>     [<c012b520>] (__warn) from [<c012b680>] (warn_slowpath_fmt+0x58/0x74)
>     [<c012b62c>] (warn_slowpath_fmt) from [<c0199acc>] (check_for_stack.part.9+0xd0/0x120)
>     [<c01999fc>] (check_for_stack.part.9) from [<c019a040>] (debug_dma_map_page+0x144/0x174)
>     [<c0199efc>] (debug_dma_map_page) from [<c065f7f4>] (ahash_final_ctx+0x5b4/0xcf0)
>     [<c065f240>] (ahash_final_ctx) from [<c065b3c4>] (ahash_final+0x1c/0x20)
>     [<c065b3a8>] (ahash_final) from [<c03fe278>] (crypto_ahash_op+0x38/0x80)
>     [<c03fe240>] (crypto_ahash_op) from [<c03fe2e0>] (crypto_ahash_final+0x20/0x24)
>     [<c03fe2c0>] (crypto_ahash_final) from [<c03f19a8>] (ima_calc_file_hash+0x29c/0xa40)
>     [<c03f170c>] (ima_calc_file_hash) from [<c03f2b24>] (ima_collect_measurement+0x1dc/0x240)
>     [<c03f2948>] (ima_collect_measurement) from [<c03f0a60>] (process_measurement+0x4c4/0x6b8)
>     [<c03f059c>] (process_measurement) from [<c03f0cdc>] (ima_file_check+0x88/0xa4)
>     [<c03f0c54>] (ima_file_check) from [<c02d8adc>] (path_openat+0x5d8/0x1364)
>     [<c02d8504>] (path_openat) from [<c02dad24>] (do_filp_open+0x84/0xf0)
>     [<c02daca0>] (do_filp_open) from [<c02cf50c>] (do_open_execat+0x84/0x1b0)
>     [<c02cf488>] (do_open_execat) from [<c02d1058>] (__do_execve_file+0x43c/0x890)
>     [<c02d0c1c>] (__do_execve_file) from [<c02d1770>] (sys_execve+0x44/0x4c)
>     [<c02d172c>] (sys_execve) from [<c0101000>] (ret_fast_syscall+0x0/0x28)
>     ---[ end trace 3455789a10e3aefd ]---
> 
> The cause is that the struct ahash_request *req is created as a
> stack-local variable up in the stack (presumably somewhere in the IMA
> implementation), then passed down into the CAAM driver, which tries to
> dma_single_map the req->result (indirectly via map_seq_out_ptr_result)
> in order to make that buffer available for the CAAM to store the result
> of the following hash operation.
> 
> The calling code doesn't know how req will be used by the CAAM driver,
> and there could be other such occurrences where stack memory is passed
> down to the CAAM driver. Therefore we should rather fix this issue in
> the CAAM driver where the requirements are known."
> 
> Fix this problem by:
> -instructing the crypto engine to write the final hash in state->caam_ctx
> -subsequently memcpy-ing the final hash into req->result
> 
> Cc: <stable@vger.kernel.org> # v4.19+
> Reported-by: Roland Hieber <rhi@pengutronix.de>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/caamhash.c | 85 +++++++++++-------------------------------
>  1 file changed, 21 insertions(+), 64 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
