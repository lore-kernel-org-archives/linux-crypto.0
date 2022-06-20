Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA83C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jun 2022 14:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245449AbiFTOX7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jun 2022 10:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245182AbiFTOXs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jun 2022 10:23:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6731B1EEEC;
        Mon, 20 Jun 2022 06:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22394B811C2;
        Mon, 20 Jun 2022 13:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33985C3411C;
        Mon, 20 Jun 2022 13:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655732335;
        bh=+fFogW7MYgbcV+/+vdX3im2l7WY1OGpRvAvNxoxAPyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MY0okBXnmX/EcirZ4FWy0Au4Y8zBCrkzVtpjevX0FoB6qwpJTz30gOQFAAt4oN6Wp
         DW3fpwxgyyETQUYYDXCMkZ3HFC4L2BRZ0in3174sgFIpi+tOiSnguvTwsE9p523sUu
         fFtI9jPYwiStyH0GgovpWMaPLWnOVLDFBXv5s+7c=
Date:   Mon, 20 Jun 2022 15:38:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Wangzhou <wangzhou1@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        Yang Shen <shenyang39@huawei.com>
Subject: Re: [PATCH] uacce: fix concurrency of fops_open and uacce_remove
Message-ID: <YrB4WLW/ZvKp1imo@kroah.com>
References: <20220610123423.27496-1-zhangfei.gao@linaro.org>
 <Yqn3spLZHpAkQ9Us@myrica>
 <fdc8d8b0-4e04-78f5-1e8a-4cf44c89a37f@linaro.org>
 <YqrmdKNrYTCiS/MC@myrica>
 <d90e8ea5-2f18-2eda-b4b2-711083aa7ecd@linaro.org>
 <YrB1D9rv9G4h/BYU@myrica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrB1D9rv9G4h/BYU@myrica>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 20, 2022 at 02:24:31PM +0100, Jean-Philippe Brucker wrote:
> >From c7c2b051ec19285bbb973f8a2a5e58bb5326e00e Mon Sep 17 00:00:00 2001
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Date: Mon, 20 Jun 2022 10:10:41 +0100
> Subject: [PATCH] uacce: Tidy up locking
> 
> The uacce driver must deal with a possible removal of the parent driver
> or device at any time.

No it should not, if the reference counting logic is properly set up.
The parent driver should correctly tear things down here.

> At the moment there are several issues that may
> result in use-after-free. Tidy up the locking to handle module removal.

I don't think you did that, as module removal should never happen if a
file descriptor is opened as I previously mentioned.

thanks,

greg k-h
