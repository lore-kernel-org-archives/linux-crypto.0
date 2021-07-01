Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799F3C11F64
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 19:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5639D61410
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 19:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhGAUBg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jul 2021 16:01:36 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:50588 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhGAUBg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jul 2021 16:01:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 3B9176108476;
        Thu,  1 Jul 2021 21:59:04 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Szag2gsOxhr4; Thu,  1 Jul 2021 21:59:03 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 6B18F6083273;
        Thu,  1 Jul 2021 21:59:03 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id J1fDMrE6PDep; Thu,  1 Jul 2021 21:59:03 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 366E3610846D;
        Thu,  1 Jul 2021 21:59:03 +0200 (CEST)
Date:   Thu, 1 Jul 2021 21:59:03 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, horia geanta <horia.geanta@nxp.com>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Vasut <marex@denx.de>, david <david@sigma-star.at>
Message-ID: <1382866497.13280.1625169542979.JavaMail.zimbra@nod.at>
In-Reply-To: <20210701185638.3437487-3-sean.anderson@seco.com>
References: <20210701185638.3437487-1-sean.anderson@seco.com> <20210701185638.3437487-3-sean.anderson@seco.com>
Subject: Re: [PATCH v2 2/2] crypto: mxs_dcp: Use sg_mapping_iter to copy
 data
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: crypto: mxs_dcp: Use sg_mapping_iter to copy data
Thread-Index: aSs59U4orgMqgMDdkjos50LXYOppwA==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Sean Anderson" <sean.anderson@seco.com>
> An: "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "davem"
> <davem@davemloft.net>
> CC: "horia geanta" <horia.geanta@nxp.com>, "aymen sghaier" <aymen.sghaier@nxp.com>, "richard" <richard@nod.at>,
> "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>, "Marek Vasut" <marex@denx.de>, "Sean Anderson"
> <sean.anderson@seco.com>
> Gesendet: Donnerstag, 1. Juli 2021 20:56:38
> Betreff: [PATCH v2 2/2] crypto: mxs_dcp: Use sg_mapping_iter to copy data

> This uses the sg_miter_*() functions to copy data, instead of doing it
> ourselves. Using sg_copy_buffer() would be better, but this way we don't
> have to keep traversing the beginning of the scatterlist every time we
> do another copy.

Huh? This does not match the code.
You use sg_pcopy_from_buffer() which is just a wrapper around sg_copy_buffer().

Did you forget to update the commit message? :-)

> In addition to reducing code size, this fixes the following oops
> resulting from failing to kmap the page:
> 
> [   68.896381] Unable to handle kernel NULL pointer dereference at virtual
> address 00000ab8
> [   68.904539] pgd = 3561adb3
> [   68.907475] [00000ab8] *pgd=00000000
> [   68.911153] Internal error: Oops: 805 [#1] ARM
> [   68.915618] Modules linked in: cfg80211 rfkill des_generic libdes arc4
> libarc4 cbc ecb algif_skcipher sha256_generic libsha256 sha1_generic hmac
> aes_generic libaes cmac sha512_generic md5 md4 algif_hash af_alg i2c_imx
> i2c_core ci_hdrc_imx ci_hdrc mxs_dcp ulpi roles udc_core imx_sdma usbmisc_imx
> usb_common firmware_class virt_dma phy_mxs_usb nf_tables nfnetlink ip_tables
> x_tables ipv6 autofs4
> [   68.950741] CPU: 0 PID: 139 Comm: mxs_dcp_chan/ae Not tainted 5.10.34 #296
> [   68.958501] Hardware name: Freescale i.MX6 Ultralite (Device Tree)
> [   68.964710] PC is at memcpy+0xa8/0x330
> [   68.968479] LR is at 0xd7b2bc9d
> [   68.971638] pc : [<c053e7c8>]    lr : [<d7b2bc9d>]    psr: 000f0013
> [   68.977920] sp : c2cbbee4  ip : 00000010  fp : 00000010
> [   68.983159] r10: 00000000  r9 : c3283a40  r8 : 1a5a6f08
> [   68.988402] r7 : 4bfe0ecc  r6 : 76d8a220  r5 : c32f9050  r4 : 00000001
> [   68.994945] r3 : 00000ab8  r2 : fffffff0  r1 : c32f9050  r0 : 00000ab8
> [   69.001492] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [   69.008646] Control: 10c53c7d  Table: 83664059  DAC: 00000051
> [   69.014414] Process mxs_dcp_chan/ae (pid: 139, stack limit = 0x667b57ab)
> [   69.021133] Stack: (0xc2cbbee4 to 0xc2cbc000)
> [   69.025519] bee0:          c32f9050 c3235408 00000010 00000010 00000ab8
> 00000001 bf10406c
> [   69.033720] bf00: 00000000 00000000 00000010 00000000 c32355d0 832fb080
> 00000000 c13de2fc
> [   69.041921] bf20: c3628010 00000010 c33d5780 00000ab8 bf1067e8 00000002
> c21e5010 c2cba000
> [   69.050125] bf40: c32f8040 00000000 bf106a40 c32f9040 c3283a80 00000001
> bf105240 c3234040
> [   69.058327] bf60: ffffe000 c3204100 c2c69800 c2cba000 00000000 bf103b84
> 00000000 c2eddc54
> [   69.066530] bf80: c3204144 c0140d1c c2cba000 c2c69800 c0140be8 00000000
> 00000000 00000000
> [   69.074730] bfa0: 00000000 00000000 00000000 c0100114 00000000 00000000
> 00000000 00000000
> [   69.082932] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
> [   69.091131] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> 00000000 00000000
> [   69.099364] [<c053e7c8>] (memcpy) from [<bf10406c>]
> (dcp_chan_thread_aes+0x4e8/0x840 [mxs_dcp])
> [   69.108117] [<bf10406c>] (dcp_chan_thread_aes [mxs_dcp]) from [<c0140d1c>]
> (kthread+0x134/0x160)
> [   69.116941] [<c0140d1c>] (kthread) from [<c0100114>]
> (ret_from_fork+0x14/0x20)
> [   69.124178] Exception stack(0xc2cbbfb0 to 0xc2cbbff8)
> [   69.129250] bfa0:                                     00000000 00000000
> 00000000 00000000
> [   69.137450] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
> [   69.145648] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [   69.152289] Code: e320f000 e4803004 e4804004 e4805004 (e4806004)
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v2:
> - Fix warning when taking the minimum of a u32 and a size_t
> - Use sg_pcopy_from_buffer to properly deal with partial reads.
> 
> drivers/crypto/mxs-dcp.c | 36 +++++++++---------------------------
> 1 file changed, 9 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index f397cc5bf102..d19e5ffb5104 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -300,21 +300,20 @@ static int mxs_dcp_aes_block_crypt(struct
> crypto_async_request *arq)
> 
> 	struct scatterlist *dst = req->dst;
> 	struct scatterlist *src = req->src;
> -	const int nents = sg_nents(req->src);
> +	int dst_nents = sg_nents(dst);
> 
> 	const int out_off = DCP_BUF_SZ;
> 	uint8_t *in_buf = sdcp->coh->aes_in_buf;
> 	uint8_t *out_buf = sdcp->coh->aes_out_buf;
> 
> -	uint8_t *out_tmp, *src_buf, *dst_buf = NULL;
> 	uint32_t dst_off = 0;
> +	uint8_t *src_buf = NULL;
> 	uint32_t last_out_len = 0;
> 
> 	uint8_t *key = sdcp->coh->aes_key;
> 
> 	int ret = 0;
> -	int split = 0;
> -	unsigned int i, len, clen, rem = 0, tlen = 0;
> +	unsigned int i, len, clen, tlen = 0;
> 	int init = 0;
> 	bool limit_hit = false;
> 
> @@ -332,7 +331,7 @@ static int mxs_dcp_aes_block_crypt(struct
> crypto_async_request *arq)
> 		memset(key + AES_KEYSIZE_128, 0, AES_KEYSIZE_128);
> 	}
> 
> -	for_each_sg(req->src, src, nents, i) {
> +	for_each_sg(req->src, src, sg_nents(src), i) {
> 		src_buf = sg_virt(src);
> 		len = sg_dma_len(src);
> 		tlen += len;
> @@ -357,34 +356,17 @@ static int mxs_dcp_aes_block_crypt(struct
> crypto_async_request *arq)
> 			 * submit the buffer.
> 			 */
> 			if (actx->fill == out_off || sg_is_last(src) ||
> -				limit_hit) {
> +			    limit_hit) {
> 				ret = mxs_dcp_run_aes(actx, req, init);
> 				if (ret)
> 					return ret;
> 				init = 0;
> 
> -				out_tmp = out_buf;
> +				sg_pcopy_from_buffer(dst, dst_nents, out_buf,
> +						     actx->fill, dst_off);
> +				dst_off += actx->fill;
> 				last_out_len = actx->fill;
> -				while (dst && actx->fill) {
> -					if (!split) {
> -						dst_buf = sg_virt(dst);
> -						dst_off = 0;
> -					}
> -					rem = min(sg_dma_len(dst) - dst_off,
> -						  actx->fill);
> -
> -					memcpy(dst_buf + dst_off, out_tmp, rem);
> -					out_tmp += rem;
> -					dst_off += rem;
> -					actx->fill -= rem;
> -
> -					if (dst_off == sg_dma_len(dst)) {
> -						dst = sg_next(dst);
> -						split = 0;
> -					} else {
> -						split = 1;
> -					}
> -				}
> +				actx->fill = 0;
> 			}
> 		} while (len);
> 
> --
> 2.25.1
