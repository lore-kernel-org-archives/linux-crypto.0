Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A450BC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BFBC20675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388902AbfDROXm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:23:42 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55100 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388806AbfDROXm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:23:42 -0400
X-Greylist: delayed 1412 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Apr 2019 10:23:41 EDT
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH7wx-0004kO-PY; Thu, 18 Apr 2019 22:23:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH7wv-0004BL-54; Thu, 18 Apr 2019 22:23:37 +0800
Date:   Thu, 18 Apr 2019 22:23:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp: Do not free psp_master when PLATFORM_INIT
 fails
Message-ID: <20190418142337.hrdykxre3g5bvjbz@gondor.apana.org.au>
References: <20190408204241.20393-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408204241.20393-1-brijesh.singh@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 08, 2019 at 08:42:55PM +0000, Singh, Brijesh wrote:
> Currently, we free the psp_master if the PLATFORM_INIT fails during the
> SEV FW probe. If psp_master is freed then driver does not invoke the PSP
> FW. As per SEV FW spec, there are several commands (PLATFORM_RESET,
> PLATFORM_STATUS, GET_ID etc) which can be executed in the UNINIT state
> We should not free the psp_master when PLATFORM_INIT fails.
> 
> Fixes: 200664d5237f ("crypto: ccp: Add SEV support")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: stable@vger.kernel.org # 4.19.y
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/psp-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
