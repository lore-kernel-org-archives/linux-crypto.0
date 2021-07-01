Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7997DC11F64
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 19:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C0A0613E0
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 19:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhGAThC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jul 2021 15:37:02 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:50262 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhGAThB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jul 2021 15:37:01 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2021 15:37:01 EDT
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id EAE436108188;
        Thu,  1 Jul 2021 21:28:40 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Cu2fSJkVVSEt; Thu,  1 Jul 2021 21:28:40 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 20775610848B;
        Thu,  1 Jul 2021 21:28:40 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cVnxTMQBKNSC; Thu,  1 Jul 2021 21:28:40 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id EBAA06108478;
        Thu,  1 Jul 2021 21:28:39 +0200 (CEST)
Date:   Thu, 1 Jul 2021 21:28:39 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, horia geanta <horia.geanta@nxp.com>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Vasut <marex@denx.de>, david <david@sigma-star.at>
Message-ID: <723802567.13207.1625167719840.JavaMail.zimbra@nod.at>
In-Reply-To: <20210701185638.3437487-1-sean.anderson@seco.com>
References: <20210701185638.3437487-1-sean.anderson@seco.com>
Subject: Re: [PATCH v2 0/2] crypto: mxs_dcp: Fix an Oops on i.MX6ULL
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: crypto: mxs_dcp: Fix an Oops on i.MX6ULL
Thread-Index: IWrviunujKG/v99nyBJ/3UbF2cACPA==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sean,

[CC'ing David]

----- Ursprüngliche Mail -----
> Von: "Sean Anderson" <sean.anderson@seco.com>
> An: "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "davem"
> <davem@davemloft.net>
> CC: "horia geanta" <horia.geanta@nxp.com>, "aymen sghaier" <aymen.sghaier@nxp.com>, "richard" <richard@nod.at>,
> "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>, "Marek Vasut" <marex@denx.de>, "Sean Anderson"
> <sean.anderson@seco.com>
> Gesendet: Donnerstag, 1. Juli 2021 20:56:36
> Betreff: [PATCH v2 0/2] crypto: mxs_dcp: Fix an Oops on i.MX6ULL

> This fixes at least one oops when using the DCP on ULL. However, I got
> another Oops when running kcapi-dgst-test.sh from the libkcapi test
> suite [1]:
> 
> [ 6961.181777] Unable to handle kernel NULL pointer dereference at virtual
> address 000008f8
> [ 6961.190143] pgd = e59542a6
> [ 6961.192917] [000008f8] *pgd=00000000
> [ 6961.196586] Internal error: Oops: 5 [#1] ARM
> [ 6961.200877] Modules linked in: crypto_user mxs_dcp cfg80211 rfkill
> des_generic libdes arc4 libarc4 cbc ecb algif_skcipher sha256_generic libsha256
> sha1_generic hmac aes_generic libaes cmac sha512_generic md5 md4 algif_hash
> af_alg i2c_imx ci_hdrc_imx ci_hdrc i2c_core ulpi roles udc_core imx_sdma
> usb_common firmware_class usbmisc_imx virt_dma phy_mxs_usb nf_tables nfnetlink
> ip_tables x_tables ipv6 autofs4 [last unloaded: mxs_dcp]
> [ 6961.239228] CPU: 0 PID: 469 Comm: mxs_dcp_chan/ae Not tainted
> 5.10.46-315-tiago #315
> [ 6961.246988] Hardware name: Freescale i.MX6 Ultralite (Device Tree)
> [ 6961.253201] PC is at memcpy+0xc0/0x330
> [ 6961.256993] LR is at dcp_chan_thread_aes+0x220/0x94c [mxs_dcp]
> [ 6961.262847] pc : [<c053f1e0>]    lr : [<bf13cda4>]    psr: 800e0013
> [ 6961.269130] sp : cdc09ef4  ip : 00000010  fp : c36e5808
> [ 6961.274370] r10: cdcc3150  r9 : 00000000  r8 : bff46000
> [ 6961.279613] r7 : c36e59d0  r6 : c2e42840  r5 : cdcc3140  r4 : 00000001
> [ 6961.286156] r3 : 000008f9  r2 : 80000000  r1 : 000008f8  r0 : cdc1004f
> [ 6961.292704] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [ 6961.299860] Control: 10c53c7d  Table: 83358059  DAC: 00000051
> [ 6961.305628] Process mxs_dcp_chan/ae (pid: 469, stack limit = 0xe1efdc80)
> [ 6961.312346] Stack: (0xcdc09ef4 to 0xcdc0a000)
> [ 6961.316726] 9ee0:                                              cdc1004f
> 00000001 bf13cda4
> [ 6961.324930] 9f00: 00000000 00000000 c23b41a0 00000000 c36e59d0 00000001
> 00000010 00000000
> [ 6961.333132] 9f20: 00000000 00000000 c13de2fc 000008f9 8dc13080 00000010
> cdcc3150 c21e5010
> [ 6961.341335] 9f40: cdc08000 cdc10040 00000001 bf13fa40 cdc11040 c2e42880
> 00000002 cc861440
> [ 6961.349535] 9f60: ffffe000 c33dbe00 c332cb40 cdc08000 00000000 bf13cb84
> 00000000 c3353c54
> [ 6961.357736] 9f80: c33dbe44 c0140d34 cdc08000 c332cb40 c0140c00 00000000
> 00000000 00000000
> [ 6961.365936] 9fa0: 00000000 00000000 00000000 c0100114 00000000 00000000
> 00000000 00000000
> [ 6961.374138] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
> [ 6961.382338] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> 00000000 00000000
> [ 6961.390567] [<c053f1e0>] (memcpy) from [<bf13cda4>]
> (dcp_chan_thread_aes+0x220/0x94c [mxs_dcp])
> [ 6961.399312] [<bf13cda4>] (dcp_chan_thread_aes [mxs_dcp]) from [<c0140d34>]
> (kthread+0x134/0x160)
> [ 6961.408137] [<c0140d34>] (kthread) from [<c0100114>]
> (ret_from_fork+0x14/0x20)
> [ 6961.415377] Exception stack(0xcdc09fb0 to 0xcdc09ff8)
> [ 6961.420448] 9fa0:                                     00000000 00000000
> 00000000 00000000
> [ 6961.428647] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
> [ 6961.436845] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [ 6961.443488] Code: e4808004 e480e004 e8bd01e0 e1b02f82 (14d13001)
> 
> where dcp_chan_thread_aes+0x220 is the line
> 
>	memcpy(in_buf + actx->fill, src_buf, clen);
> 
> in mxs_dcp_aes_block_crypt. I also tried with the following patch
> instead of the one included in this series:
> 
> ---
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index f397cc5bf102..54fd24ba1261 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -367,6 +367,7 @@ static int mxs_dcp_aes_block_crypt(struct
> crypto_async_request *arq)
>                                last_out_len = actx->fill;
>                                while (dst && actx->fill) {
>                                        if (!split) {
> +                                               kmap(sg_page(dst));
>                                                dst_buf = sg_virt(dst);
>                                                dst_off = 0;
>                                        }
> @@ -379,6 +380,7 @@ static int mxs_dcp_aes_block_crypt(struct
> crypto_async_request *arq)
>                                        actx->fill -= rem;
> 
>                                        if (dst_off == sg_dma_len(dst)) {
> +                                               kunmap(sg_page(dst));
>                                                dst = sg_next(dst);
>                                                split = 0;
>                                        } else {
> --
> 
> but got the same oops. Unfortunately, I don't have the time to
> investigate this oops as well. I'd appreciate if anyone else using this
> device could look into this and see if they encounter the same errors.
> 
> [1] https://github.com/smuellerDD/libkcapi/blob/master/test/kcapi-dgst-test.sh

Can you please share your kernel .config? David or I can test on our test bed.
But will take a few days.

Thanks,
//richard
