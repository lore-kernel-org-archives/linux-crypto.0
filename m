Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E65C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 634C5208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfHIGKm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 02:10:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37276 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbfHIGKm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 02:10:42 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hvy6o-0007BC-IO; Fri, 09 Aug 2019 16:10:38 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hvy6n-0002iy-Jk; Fri, 09 Aug 2019 16:10:37 +1000
Date:   Fri, 9 Aug 2019 16:10:37 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - fix concurrency issue in givencrypt
 descriptor
Message-ID: <20190809061037.GD10392@gondor.apana.org.au>
References: <20190730054833.24192-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190730054833.24192-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 30, 2019 at 08:48:33AM +0300, Horia Geantă wrote:
> IV transfer from ofifo to class2 (set up at [29][30]) is not guaranteed
> to be scheduled before the data transfer from ofifo to external memory
> (set up at [38]:
> 
> [29] 10FA0004           ld: ind-nfifo (len=4) imm
> [30] 81F00010               <nfifo_entry: ofifo->class2 type=msg len=16>
> [31] 14820004           ld: ccb2-datasz len=4 offs=0 imm
> [32] 00000010               data:0x00000010
> [33] 8210010D    operation: cls1-op aes cbc init-final enc
> [34] A8080B04         math: (seqin + math0)->vseqout len=4
> [35] 28000010    seqfifold: skip len=16
> [36] A8080A04         math: (seqin + math0)->vseqin len=4
> [37] 2F1E0000    seqfifold: both msg1->2-last2-last1 len=vseqinsz
> [38] 69300000   seqfifostr: msg len=vseqoutsz
> [39] 5C20000C      seqstr: ccb2 ctx len=12 offs=0
> 
> If ofifo -> external memory transfer happens first, DECO will hang
> (issuing a Watchdog Timeout error, if WDOG is enabled) waiting for
> data availability in ofifo for the ofifo -> c2 ififo transfer.
> 
> Make sure IV transfer happens first by waiting for all CAAM internal
> transfers to end before starting payload transfer.
> 
> New descriptor with jump command inserted at [37]:
> 
> [..]
> [36] A8080A04         math: (seqin + math0)->vseqin len=4
> [37] A1000401         jump: jsl1 all-match[!nfifopend] offset=[01] local->[38]
> [38] 2F1E0000    seqfifold: both msg1->2-last2-last1 len=vseqinsz
> [39] 69300000   seqfifostr: msg len=vseqoutsz
> [40] 5C20000C      seqstr: ccb2 ctx len=12 offs=0
> 
> [Note: the issue is present in the descriptor from the very beginning
> (cf. Fixes tag). However I've marked it v4.19+ since it's the oldest
> maintained kernel that the patch applies clean against.]
> 
> Cc: <stable@vger.kernel.org> # v4.19+
> Fixes: 1acebad3d8db8 ("crypto: caam - faster aead implementation")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/caamalg_desc.c | 9 +++++++++
>  drivers/crypto/caam/caamalg_desc.h | 2 +-
>  2 files changed, 10 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
