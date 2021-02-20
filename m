Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AE3C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 02:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7315B64E77
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 02:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBTCS4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Feb 2021 21:18:56 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:46474 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229700AbhBTCSz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Feb 2021 21:18:55 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lDHpv-0008H4-Fl; Sat, 20 Feb 2021 13:17:36 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 20 Feb 2021 13:17:35 +1100
Date:   Sat, 20 Feb 2021 13:17:35 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc:     clabbe.montjoie@gmail.com, clabbe@baylibre.com,
        gcherian@marvell.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxarm@openeuler.org,
        prime.zeng@huawei.com
Subject: Re: [PATCH 0/4] Fix the parameter of dma_map_sg()
Message-ID: <20210220021735.GA5309@gondor.apana.org.au>
References: <1612853965-67777-1-git-send-email-chenxiang66@hisilicon.com>
 <54b73ba3-54f9-bb73-e398-4f12bc359b26@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54b73ba3-54f9-bb73-e398-4f12bc359b26@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 20, 2021 at 09:51:17AM +0800, chenxiang (M) wrote:
> Ping...

Please be patient.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
