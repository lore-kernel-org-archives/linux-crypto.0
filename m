Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8112C4742C
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 06:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A235922265
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 06:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgKPG0V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Nov 2020 01:26:21 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:44902 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgKPG0V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Nov 2020 01:26:21 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1keXxm-0001PK-Gm; Mon, 16 Nov 2020 17:26:07 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Nov 2020 17:26:06 +1100
Date:   Mon, 16 Nov 2020 17:26:06 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Srujana Challa <schalla@marvell.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com,
        Lukasz Bartosik <lbartosik@marvell.com>
Subject: Re: [PATCH v9,net-next,12/12] crypto: octeontx2: register with linux
 crypto framework
Message-ID: <20201116062606.GA29271@gondor.apana.org.au>
References: <20201109120924.358-1-schalla@marvell.com>
 <20201109120924.358-13-schalla@marvell.com>
 <20201111161039.64830a68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201113031601.GA27112@gondor.apana.org.au>
 <20201113084440.138a76fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113084440.138a76fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 13, 2020 at 08:44:40AM -0800, Jakub Kicinski wrote:
>
> SGTM, actually everything starting from patch 4 is in drivers/crypto, 
> so we can merge the first 3 into net-next and the rest via crypto?

Yes of course.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
