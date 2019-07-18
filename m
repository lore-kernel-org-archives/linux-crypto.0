Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E2EC76195
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 05:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 327F42173B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 05:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfGRFls (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 01:41:48 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57798 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbfGRFls (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 01:41:48 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hnzAk-0007AX-DF; Thu, 18 Jul 2019 13:41:42 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hnzAg-0005eJ-UB; Thu, 18 Jul 2019 13:41:38 +0800
Date:   Thu, 18 Jul 2019 13:41:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Cfir Cohen <cfir@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccp/gcm - use const time tag comparison.
Message-ID: <20190718054138.nzz24mi6mawlrpa4@gondor.apana.org.au>
References: <20190702173256.50485-1-cfir@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702173256.50485-1-cfir@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 02, 2019 at 10:32:56AM -0700, Cfir Cohen wrote:
> Avoid leaking GCM tag through timing side channel.
> 
> Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
> Cc: <stable@vger.kernel.org> # v4.12+
> Signed-off-by: Cfir Cohen <cfir@google.com>
> ---
>  drivers/crypto/ccp/ccp-ops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
