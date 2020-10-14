Return-Path: <SRS0=tejW=DV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E3BC433E7
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Oct 2020 23:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 059DB218AC
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Oct 2020 23:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602719983;
	bh=FfHibkEmYUCe/bQXHylwghTGPLsFZvJ03fiRBUTaOmI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=TAS1DyjRtiNsZeE1AJl1jH3fR3i5eh8iJSs2+D8Wiv4r4mxPGvsI2kQKC8WsWLiVo
	 pcCkVyYxFaPQlkLuv+5MPYk7vWPil38ETCgMS7dZQnMe0EqvxluZ3N/KiH1K4tr77p
	 td8LbSN+5Zx3PWYYmruJdloNeOFW4Ql0K4Kki8ZQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731137AbgJNX7m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Oct 2020 19:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgJNX7m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Oct 2020 19:59:42 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B7D6214D8;
        Wed, 14 Oct 2020 23:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602719981;
        bh=FfHibkEmYUCe/bQXHylwghTGPLsFZvJ03fiRBUTaOmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yQGYtX9+h6yNrskNtol3K35NJgu8zKnC+mMl2tw3C0YT71wJ0/lgT0ODq3C4Y0bDX
         tLPeOLvk/AV2REISI5w9/mpeYQVEQrnAv/EjbyVfFHgCkWgkW/9kNh+xBWllnjogve
         OTrkIYNx+L29Reb2tqG2ZaAuvUelXb6OfaQqx2QQ=
Date:   Wed, 14 Oct 2020 16:59:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>
Subject: Re: [PATCH v7,net-next,04/13] drivers: crypto: add Marvell
 OcteonTX2 CPT PF driver
Message-ID: <20201014165939.2cc81954@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012105719.12492-5-schalla@marvell.com>
References: <20201012105719.12492-1-schalla@marvell.com>
        <20201012105719.12492-5-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 12 Oct 2020 16:27:10 +0530 Srujana Challa wrote:
> +	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
> +	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));

dma_set_mask_and_coherent()
