Return-Path: <SRS0=cN3k=QQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11322C282C4
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Feb 2019 21:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9A292192C
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Feb 2019 21:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549749143;
	bh=692inXkzswiXqW3KwoY2XU39G+jQVkY33N0oUEuzNOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=U5ymcnB+3f7CmJ4dgkDzFAHSRghWlNEkj/M4xW8dmINNMaEn4J6Tne4zA3nc3wk1m
	 6SJcotbJVg7mgEpODySbL3RUoR0Q3RziAyMeZbnl5c/a/WSewnpC9lAFlPaFhk2pmG
	 AWhLrupKuauYdtMq33dfXvnVR4cEQU9Ig4bT8GUM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfBIVwX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Feb 2019 16:52:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbfBIVwX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Feb 2019 16:52:23 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3737621919;
        Sat,  9 Feb 2019 21:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549749142;
        bh=692inXkzswiXqW3KwoY2XU39G+jQVkY33N0oUEuzNOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CXZRK0XMz/URVsgKX10ryZ78TJT97OlXEXrJI5pibcm91GNpRBEZOjLz9+nnIdFBA
         Hs7WuGqRVzh9LOqYjo9ByZpm0K+ZCqLmUHneD4XxYFzaMqzdes9EllNCx1ieRF3VtZ
         a3tksT4OTJkrlFxsFZSII898xIY/n5ljunFKulbk=
Date:   Sat, 9 Feb 2019 13:52:20 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 0/4] crypto: caam - add ecb mode support
Message-ID: <20190209215219.GA688@sol.localdomain>
References: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Iuliana,

On Fri, Feb 08, 2019 at 03:50:06PM +0200, Iuliana Prodan wrote:
> This patch set adds ecb mode support for aes, des, 3des and arc4 ciphers.
> skcipher implementation is reused, making sure to handle the no IV case.
> 
> While here:
> -fix a DMA API issue where initial src/dst_nents are used instead of nents
> returned by dma_map_sg()
> -export arc4 defines in a common header
> -update cbc des and 3des to check for weak keys 
> 
> Iuliana Prodan (4):
>   crypto: caam - use mapped_{src,dst}_nents for job descriptor
>   crypto: export arc4 defines
>   crypto: caam - add ecb(*) support
>   crypto: caam - weak key checking for cbc des, 3des
> 

Do you have an actual use case for adding more DES, 3DES, and ARC4
implementations, or are you simply adding them because the hardware happens to
supports it?  These old ciphers are insecure, so IMO more implementations should
only be added if there is a real use case where they're absolutely needed.

- Eric
