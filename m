Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FE8C55ABD
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 16:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D64E8217A0
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 16:44:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="avfzrA7W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgKMQon (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 11:44:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgKMQon (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 11:44:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93128208D5;
        Fri, 13 Nov 2020 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605285882;
        bh=yE9m79It61Px7M5KdfeOK7s4vlAH/9PT2N6H9v+TsBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=avfzrA7WlUokPPk0FHUWKh6dc0wRkkjyHZTIphID11n7Q9HAAnSY/e3sP4H4XjtfU
         nT4YaMpiCsaAnj/AkhXzwokDVJIlnxftWWOGBUioJMk7T1sPB/QaXxH5Okcz5EXFb6
         VGhzuL4HDVY+PVkwLL3NlBZI+0HCrbJGNq7rMrmA=
Date:   Fri, 13 Nov 2020 08:44:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Srujana Challa <schalla@marvell.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com,
        Lukasz Bartosik <lbartosik@marvell.com>
Subject: Re: [PATCH v9,net-next,12/12] crypto: octeontx2: register with
 linux crypto framework
Message-ID: <20201113084440.138a76fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113031601.GA27112@gondor.apana.org.au>
References: <20201109120924.358-1-schalla@marvell.com>
        <20201109120924.358-13-schalla@marvell.com>
        <20201111161039.64830a68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201113031601.GA27112@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 13 Nov 2020 14:16:01 +1100 Herbert Xu wrote:
> On Wed, Nov 11, 2020 at 04:10:39PM -0800, Jakub Kicinski wrote:
> > On Mon, 9 Nov 2020 17:39:24 +0530 Srujana Challa wrote:  
> > > CPT offload module utilises the linux crypto framework to offload
> > > crypto processing. This patch registers supported algorithms by
> > > calling registration functions provided by the kernel crypto API.
> > > 
> > > The module currently supports:
> > > - AES block cipher in CBC,ECB,XTS and CFB mode.
> > > - 3DES block cipher in CBC and ECB mode.
> > > - AEAD algorithms.
> > >   authenc(hmac(sha1),cbc(aes)),
> > >   authenc(hmac(sha256),cbc(aes)),
> > >   authenc(hmac(sha384),cbc(aes)),
> > >   authenc(hmac(sha512),cbc(aes)),
> > >   authenc(hmac(sha1),ecb(cipher_null)),
> > >   authenc(hmac(sha256),ecb(cipher_null)),
> > >   authenc(hmac(sha384),ecb(cipher_null)),
> > >   authenc(hmac(sha512),ecb(cipher_null)),
> > >   rfc4106(gcm(aes)).  
> > 
> > Herbert, could someone who knows about crypto take a look at this, 
> > if the intention is to merge this via net-next?  
> 
> This patch seems to be quite large but it is self-contained.  How
> about waiting a release cycle and then resubmitting it to linux-crypto
> on its own?

SGTM, actually everything starting from patch 4 is in drivers/crypto, 
so we can merge the first 3 into net-next and the rest via crypto?
