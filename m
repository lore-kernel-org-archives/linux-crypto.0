Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1039FC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 04:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D240620707
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 04:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574397472;
	bh=SUQ9OFAb62GXoX/MtVCEnH4ZzSHKhWxeJQUcD9rTFj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=idxRlh7fK/SHuIiNcJJlgSCL4ku1QKA9nuuOuGUFoRbkQBcGnQmIy5erH+CUaPLL3
	 84aWnYDD7uaBlkZeo8i62s7uWw78nKjuIj6LrTKWwBN3iVc+3klbyCDsrmvePxfEDo
	 ZcG8bc6mND+4F/YUnCE2YR4NEyNBzWOBblhh3+tM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKVEhv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 23:37:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbfKVEhv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 23:37:51 -0500
Received: from localhost (unknown [171.61.94.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 573AB2068D;
        Fri, 22 Nov 2019 04:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574397471;
        bh=SUQ9OFAb62GXoX/MtVCEnH4ZzSHKhWxeJQUcD9rTFj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rz++MFrfWK+An4b+AwBuTYhLWNDxawnfeV1XKGoY1BJL4CBdVW757Al5r599uC2cX
         Mi5eym5FF1c8+yTGXVDulsls3nfj+r5n3ZDH/oMtPD79UJXqhYzemEX1TbpDztsmKO
         Rm2C57tdhmZ5HLT4ZgLTiZcnxlIMKWXcpydxWV78=
Date:   Fri, 22 Nov 2019 10:07:45 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] crypto: atmel - Retire
 dma_request_slave_channel_compat()
Message-ID: <20191122043745.GK82508@vkoul-mobl>
References: <20191121101602.21941-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121101602.21941-1-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 21-11-19, 12:15, Peter Ujfalusi wrote:
> Hi,
> 
> Changes since v1:
> - Rebased on next-20191121 to avoid conflict for atmel-aes
> 
> I'm going through the kernel to crack down on dma_request_slave_channel_compat()
> users.
> 
> These drivers no longer needs it as they are only probed via DT and even if they
> would probe in legacy mode, the dma_request_chan() + dma_slave_map must be used
> for supporting non DT boots.

Reviewed-by: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
