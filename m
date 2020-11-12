Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55954C5519F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 15:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8D7422240
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 15:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0NNWkyK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgKLPv2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 10:51:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgKLPv2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 10:51:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC794206B5;
        Thu, 12 Nov 2020 15:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605196287;
        bh=TYEWdcD7v2ennGhfF4qG9FM/FxMBZMrCGhXmvdk00pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M0NNWkyKMwu0BHGROMdCPS4kazp/UYnNj4PoP6wXLKVpBukS4aTeakITfIISPP8nM
         TiXf5rojtCEeAXrqO45pYutCsUSCGZFw8MnNHAnOHGfboH3bEDl0sw1U38CvLIctRS
         IdzYnEr3HM4W8Dw+LKxu0yuowcLrL0OYXYxPmyns=
Date:   Thu, 12 Nov 2020 07:51:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>,
        "Lukas Bartosik [C]" <lbartosik@marvell.com>
Subject: Re: [EXT] Re: [PATCH v9,net-next,05/12] crypto: octeontx2: add
 mailbox communication with AF
Message-ID: <20201112075125.1ed41ffc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BYAPR18MB2791873F6D23CC618AD76093A0E70@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20201109120924.358-1-schalla@marvell.com>
        <20201109120924.358-6-schalla@marvell.com>
        <20201111155412.388660b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BYAPR18MB2791873F6D23CC618AD76093A0E70@BYAPR18MB2791.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 12 Nov 2020 07:07:34 +0000 Srujana Challa wrote:
> > On Mon, 9 Nov 2020 17:39:17 +0530 Srujana Challa wrote:  
> > > +	err = pci_alloc_irq_vectors(pdev, RVU_PF_INT_VEC_CNT,
> > > +				    RVU_PF_INT_VEC_CNT, PCI_IRQ_MSIX);  
> > 
> > I don't see any pci_free_irq_vectors() in this patch  
> 
> This will be handled by the devres managed PCI interface.

All good by me then, please resend once you get a ack from someone on
the crypto side.
