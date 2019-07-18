Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE93C76191
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 05:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 689442173B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 05:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfGRFl4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 01:41:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57812 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfGRFl4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 01:41:56 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hnzAt-0007BF-Qk; Thu, 18 Jul 2019 13:41:51 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hnzAt-0005eb-5Q; Thu, 18 Jul 2019 13:41:51 +0800
Date:   Thu, 18 Jul 2019 13:41:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Rientjes <rientjes@google.com>
Cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Cfir Cohen <cfir@google.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL
Message-ID: <20190718054151.fi5akslvzp7h5b2w@gondor.apana.org.au>
References: <alpine.DEB.2.21.1907101426290.2777@chino.kir.corp.google.com>
 <e30eae0f-415b-842e-39c4-801227126367@amd.com>
 <alpine.DEB.2.21.1907121341210.37390@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1907121341210.37390@chino.kir.corp.google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 12, 2019 at 01:41:58PM -0700, David Rientjes wrote:
> SEV_VERSION_GREATER_OR_EQUAL() will fail if upgrading from 2.2 to 3.1, for
> example, because the minor version is not equal to or greater than the
> major.
> 
> Fix this and move to a static inline function for appropriate type
> checking.
> 
> Fixes: edd303ff0e9e ("crypto: ccp - Add DOWNLOAD_FIRMWARE SEV command")
> Reported-by: Cfir Cohen <cfir@google.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  v2: no need to check api_major >= maj after checking api_major > maj
>      per Thomas
> 
>  drivers/crypto/ccp/psp-dev.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
