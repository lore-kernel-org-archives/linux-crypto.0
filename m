Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E3EC4742C
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 01:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6685E20791
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 01:33:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nagKwsGn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgKLBdn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Nov 2020 20:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbgKKXyO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Nov 2020 18:54:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 468202072E;
        Wed, 11 Nov 2020 23:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605138853;
        bh=LSubJoD7h00l7+ja3XBEoh9BiXKvPq20VrLGf5lL/EM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nagKwsGnHgNc02aHDUziKQphPRZ0iGvxtSh76sADuzr4TKtazFRRaDn7w9eEBmZ3Y
         5L8iDLb0DM08yn2v3HMCDnOYqoPFNrmMUvOUsj3RaKJdgYxuSGwkaYKXuBSL98psCm
         OV6NvE8z25/NICxW8a25kucmKpdOkl64rY0MSDV4=
Date:   Wed, 11 Nov 2020 15:54:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Lukasz Bartosik <lbartosik@marvell.com>
Subject: Re: [PATCH v9,net-next,05/12] crypto: octeontx2: add mailbox
 communication with AF
Message-ID: <20201111155412.388660b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109120924.358-6-schalla@marvell.com>
References: <20201109120924.358-1-schalla@marvell.com>
        <20201109120924.358-6-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 9 Nov 2020 17:39:17 +0530 Srujana Challa wrote:
> +	err = pci_alloc_irq_vectors(pdev, RVU_PF_INT_VEC_CNT,
> +				    RVU_PF_INT_VEC_CNT, PCI_IRQ_MSIX);

I don't see any pci_free_irq_vectors() in this patch
