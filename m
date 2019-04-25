Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88981C10F03
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 625F0217D7
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfDYHu1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:50:27 -0400
Received: from [5.180.42.13] ([5.180.42.13]:52360 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbfDYHu1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 03:50:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hJZ9G-0002GQ-6M; Thu, 25 Apr 2019 15:50:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hJZ9F-00025f-LJ; Thu, 25 Apr 2019 15:50:25 +0800
Date:   Thu, 25 Apr 2019 15:50:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam/jr - update gcm detection logic
Message-ID: <20190425075025.bqxxlsgepb7th2up@gondor.apana.org.au>
References: <20190416162712.31106-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190416162712.31106-1-horia.geanta@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 16, 2019 at 07:27:12PM +0300, Horia Geantă wrote:
> GCM detection logic has to change for two reasons:
> -some CAAM instantiations with Era < 10, even though they have AES LP,
> they now support GCM mode
> -Era 10 upwards, there is a dedicated bit in AESA_VERSION[AESA_MISC]
> field for GCM support
> 
> For Era 9 and earlier, all AES accelerator versions support GCM,
> except for AES LP (CHAVID_LS[AESVID]=3) with revision CRNR[AESRN] < 8.
> 
> For Era 10 and later, bit 9 of the AESA_VERSION register should be used
> to detect GCM support in AES accelerator.
> 
> Note: caam/qi and caam/qi2 are drivers for QI (Queue Interface), which
> is used in DPAA-based SoCs; for now, we rely on CAAM having an AES HP
> and this AES accelerator having support for GCM.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/caamalg.c | 18 +++++++++++-------
>  drivers/crypto/caam/regs.h    |  3 +++
>  2 files changed, 14 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
--
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
