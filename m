Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5084C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C0B205C9
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfLKJgx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 04:36:53 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54176 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbfLKJgx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 04:36:53 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ieyQ8-0008Ql-42; Wed, 11 Dec 2019 17:36:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ieyQ3-0003HT-Iz; Wed, 11 Dec 2019 17:36:31 +0800
Date:   Wed, 11 Dec 2019 17:36:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] crypto: Fix Kconfig indentation
Message-ID: <20191211093631.sf2es6tnao6ypk52@gondor.apana.org.au>
References: <1574306448-31868-1-git-send-email-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1574306448-31868-1-git-send-email-krzk@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 21, 2019 at 04:20:48AM +0100, Krzysztof Kozlowski wrote:
> Adjust indentation from spaces to tab (+optional two spaces) as in
> coding style with command like:
> 	$ sed -e 's/^        /\t/' -i */Kconfig
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
> 
> ---
> 
> Changes since v1:
> 1. Fix also 7-space and tab+1 space indentation issues.
> ---
>  drivers/crypto/Kconfig         | 22 +++++++++++-----------
>  drivers/crypto/caam/Kconfig    | 14 +++++++-------
>  drivers/crypto/chelsio/Kconfig | 30 +++++++++++++++---------------
>  drivers/crypto/stm32/Kconfig   |  6 +++---
>  drivers/crypto/ux500/Kconfig   | 16 ++++++++--------
>  5 files changed, 44 insertions(+), 44 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
