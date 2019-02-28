Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B19C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9F9820842
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730807AbfB1GaZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:30:25 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39834 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1GaZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:30:25 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzFCy-0005kp-UD; Thu, 28 Feb 2019 14:30:16 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzFCy-0001da-Et; Thu, 28 Feb 2019 14:30:16 +0800
Date:   Thu, 28 Feb 2019 14:30:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: s5p: update iv after AES-CBC op end
Message-ID: <20190228063016.dqhhvpnc6nbhgxlp@gondor.apana.org.au>
References: <CGME20190219160249eucas1p17f521e74a9acab6a330e72a3c682adce@eucas1p1.samsung.com>
 <20190219160232.22084-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219160232.22084-1-k.konieczny@partner.samsung.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 19, 2019 at 05:02:32PM +0100, Kamil Konieczny wrote:
> Fix bug "s5p-sss crypto driver doesn't set next AES-CBC IV". While at this,
> fix also AES-CTR mode. Tested on Odroid U3 with Eric Biggers branch
> "iv-out-testing".
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> ---
> Changes since v1:
>  - reworded Subject and commit message
>  - changed code according to comments by Krzysztof Kozlowski
>  - added Reported-by line
> ---
>  drivers/crypto/s5p-sss.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
