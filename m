Return-Path: <SRS0=b5bf=R7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC72C4360F
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 06:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A35F120700
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 06:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfC1GHC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Mar 2019 02:07:02 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:53856 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfC1GHB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Mar 2019 02:07:01 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h9OBh-0003rE-A7; Thu, 28 Mar 2019 14:06:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h9OBg-0007mA-Gu; Thu, 28 Mar 2019 14:06:52 +0800
Date:   Thu, 28 Mar 2019 14:06:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     thomas.lendacky@amd.com, gary.hook@amd.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: ccp - Make ccp_register_rsa_alg static
Message-ID: <20190328060652.5fg4nvclreycjatk@gondor.apana.org.au>
References: <20190319135035.22056-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319135035.22056-1-yuehaibing@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 19, 2019 at 09:50:35PM +0800, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> 
> Fix sparse warning:
> 
> drivers/crypto/ccp/ccp-crypto-rsa.c:251:5:
>  warning: symbol 'ccp_register_rsa_alg' was not declared. Should it be static?
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/ccp/ccp-crypto-rsa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
