Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C19DC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 11:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E04542075C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 11:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfBVL5C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:57:02 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:54800 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVL5C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 06:57:02 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gx9Rr-0000Wx-Oa; Fri, 22 Feb 2019 19:56:59 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gx9Rq-0007At-KU; Fri, 22 Feb 2019 19:56:58 +0800
Date:   Fri, 22 Feb 2019 19:56:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, Leo Li <leoyang.li@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: Re: [PATCH 0/3] crypto: caam/qi2 - performance-related updates
Message-ID: <20190222115658.m334r57doahjns4d@gondor.apana.org.au>
References: <20190211114614.24748-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190211114614.24748-1-horia.geanta@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 11, 2019 at 01:46:11PM +0200, Horia Geantă wrote:
> The main update in this patch set is taking advantage of current DPIO
> (SW portal) implementation, making sure a CPU-affine portal is used.
> 
> There is a dependency on Freescale SoC drivers tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/leo/linux.git/log/?h=next
> 
> Patches that need to be integrated start from (excluding) commit:
> bfeffd155283 ("Linux 5.0-rc1")
> up to (including) commit:
> afb77422819f ("bus: fsl-mc: automatically add a device_link on fsl_mc_[portal,object]_allocate")
> 
> Thanks,
> Horia
> 
> Horia Geantă (3):
>   crypto: caam/qi2 - use affine DPIOs
>   crypto: caam/qi2 - rate-limit enqueue failure prints
>   crypto: caam/qi2 - relax busy polling while enqueuing FDs
> 
>  drivers/crypto/caam/caamalg_qi2.c | 56 ++++++++++++++++++++++-----------------
>  drivers/crypto/caam/caamalg_qi2.h |  2 ++
>  2 files changed, 34 insertions(+), 24 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
