Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37606C04AAF
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 12:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3E5720863
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 12:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558354037;
	bh=7zdwMAUYhf2ylYbKS53Ib4UuTa5trGghnNiVGixm+co=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bdrt52ymsSLjyVeLUWSqaAsOlnVro/MqAHuC9mbsWImx+6GVfI2WtFiK7bo8TTodN
	 gXuBZXuXJ7usvy4B3h2DmTsrPCwYCD17Qyk4Cruy/SBW4wZGGe7KytqA/Fuw68rfx4
	 9Tc/ZSCn9+t4KuM3WH8pGInu9n6nAJ31XWsrTfI0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfETMHQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 08:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730534AbfETMHP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 08:07:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB02620815;
        Mon, 20 May 2019 12:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354035;
        bh=7zdwMAUYhf2ylYbKS53Ib4UuTa5trGghnNiVGixm+co=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mj0YbAirA9Kj0ERZC2aP8YjmaMR9uHQl4RniJ7MaSdN+GPCvEQag6a+zm4rVrIJIx
         gNMWDPV5K5vo0g7mMzAAH0MHQnaDk8HYC+MAAxbmz7WPXApBx5UyhMAn9QJxZEwW4J
         66lWHWg9Sb8NggFlQupipD9oKFcfG2fuo5y4bqOg=
Date:   Mon, 20 May 2019 14:07:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [STABLE PATCH 0/2] crypto: ccree: fixes backport to 4.19
Message-ID: <20190520120713.GA13524@kroah.com>
References: <20190520115025.16457-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520115025.16457-1-gilad@benyossef.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 20, 2019 at 02:50:22PM +0300, Gilad Ben-Yossef wrote:
> Backport of upstream fixes to 4.19.y, which also applies to 5.0.y
> and 5.1.y.
> 
> Gilad Ben-Yossef (2):
>   crypto: ccree: zap entire sg on aead request unmap
>   crypto: ccree: fix backlog notifications
> 
>  drivers/crypto/ccree/cc_aead.c        |  4 ++++
>  drivers/crypto/ccree/cc_buffer_mgr.c  | 18 ++---------------
>  drivers/crypto/ccree/cc_cipher.c      |  4 ++++
>  drivers/crypto/ccree/cc_hash.c        | 28 +++++++++++++++++++--------
>  drivers/crypto/ccree/cc_request_mgr.c | 11 ++++++++---
>  5 files changed, 38 insertions(+), 27 deletions(-)

As the "FAILED:" emails said, I need these for 5.1 and 5.0 as well,
can't just move from 4.19 to a newer kernel and have regressions. I'll
go see if these apply there too.

Also, giving me the git commit ids of the original patches in Linus's
tree is necessary, so I don't have to go dig it up by hand.  I'll do it
this time...

let me see how this goes...

greg k-h
