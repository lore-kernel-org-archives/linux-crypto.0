Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94985C10F0E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 09:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AB9E206BA
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 09:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfDOJlt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:41:49 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:33716 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfDOJlt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 05:41:49 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hFy7P-0007Z7-4l; Mon, 15 Apr 2019 17:41:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hFy7G-0006Tu-Pk; Mon, 15 Apr 2019 17:41:30 +0800
Date:   Mon, 15 Apr 2019 17:41:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lionel Debieve <lionel.debieve@st.com>
Cc:     Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Rob Herring <rob.herring@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 0/2] hwrng: stm32 - Fix issue and add default quality
 level
Message-ID: <20190415094130.lfelvgmkwyonkub5@gondor.apana.org.au>
References: <1554114646-18791-1-git-send-email-lionel.debieve@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554114646-18791-1-git-send-email-lionel.debieve@st.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 01, 2019 at 12:30:44PM +0200, Lionel Debieve wrote:
> This series will fix two missing parts in the current driver.
> The first one will fix a missing function in the rng driver that
> need to call a proper removal to notify the pm_runtime framework.
> 
> Second is an improvement for driver to be used as default entropy
> source early in the boot processing.
> 
> Lionel Debieve (2):
>   hwrng: stm32 - fix unbalanced pm_runtime_enable
>   hwrng: stm32 - set default random quality
> 
>  drivers/char/hw_random/stm32-rng.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
