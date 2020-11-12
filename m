Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDBBC56201
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 01:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11AA3205ED
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 01:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjuG5H1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgKLBdn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Nov 2020 20:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbgKLAKm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Nov 2020 19:10:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFCC320759;
        Thu, 12 Nov 2020 00:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605139841;
        bh=K6GhIf09wG7HHL3UYGzXcboTjOl6PZZmZ/yPx05msC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hjuG5H1MFSXO4Pn6Y4mA+hQm5e9CoTR/c9ooufK/0dJ17lOXFdALJ+dpMYW5S4io/
         QuFmFbcoAA1eTyjBRDojX3/lZJ/QTKmkzoSMtXDC/i6uYGso7L4RnlWIm3Kz5oxT3+
         l1G1zVdXPbis9A+rwWkzYLOctmJxOpmHyf0BMtxU=
Date:   Wed, 11 Nov 2020 16:10:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <herbert@gondor.apana.org.au>
Cc:     Srujana Challa <schalla@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Lukasz Bartosik <lbartosik@marvell.com>
Subject: Re: [PATCH v9,net-next,12/12] crypto: octeontx2: register with
 linux crypto framework
Message-ID: <20201111161039.64830a68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109120924.358-13-schalla@marvell.com>
References: <20201109120924.358-1-schalla@marvell.com>
        <20201109120924.358-13-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 9 Nov 2020 17:39:24 +0530 Srujana Challa wrote:
> CPT offload module utilises the linux crypto framework to offload
> crypto processing. This patch registers supported algorithms by
> calling registration functions provided by the kernel crypto API.
> 
> The module currently supports:
> - AES block cipher in CBC,ECB,XTS and CFB mode.
> - 3DES block cipher in CBC and ECB mode.
> - AEAD algorithms.
>   authenc(hmac(sha1),cbc(aes)),
>   authenc(hmac(sha256),cbc(aes)),
>   authenc(hmac(sha384),cbc(aes)),
>   authenc(hmac(sha512),cbc(aes)),
>   authenc(hmac(sha1),ecb(cipher_null)),
>   authenc(hmac(sha256),ecb(cipher_null)),
>   authenc(hmac(sha384),ecb(cipher_null)),
>   authenc(hmac(sha512),ecb(cipher_null)),
>   rfc4106(gcm(aes)).

Herbert, could someone who knows about crypto take a look at this, 
if the intention is to merge this via net-next?
