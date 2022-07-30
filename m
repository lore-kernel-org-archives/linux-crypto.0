Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D22C3F6B0
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Jul 2022 11:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiG3LGj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Jul 2022 07:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiG3LGi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Jul 2022 07:06:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0AC1F2E0;
        Sat, 30 Jul 2022 04:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B197A60C1C;
        Sat, 30 Jul 2022 11:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F0CC433C1;
        Sat, 30 Jul 2022 11:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659179195;
        bh=N6zLasfFsL1yWZblnms4sO+Zn0caoxKfwEgHEXyiOEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vWsZezaKlHxz87XuLnXJ7Di0oDFU49bpvj3GdK6bklE6uY2U9XBITT6t0IsRC9QXa
         cLqMWS9B7rSBP6B+/AqvCiDLksq/kF5lpzBOrW8VQdi76BmHZ1NZ0ktZBLVJMwu03x
         rjnYexPzS73xcMS5im5d9zP9bHlEKtmZaobytUg0=
Date:   Sat, 30 Jul 2022 13:06:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kai Ye <yekai13@huawei.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com,
        liulongfang@huawei.com
Subject: Re: [PATCH v6 2/3] Documentation: add a isolation strategy sysfs
 node for uacce
Message-ID: <YuUQuNPIV6Xrfmwt@kroah.com>
References: <20220730083246.55646-1-yekai13@huawei.com>
 <20220730083246.55646-3-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220730083246.55646-3-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jul 30, 2022 at 04:32:45PM +0800, Kai Ye wrote:
> Update documentation describing sysfs node that could help to
> configure isolation strategy for users in the user space. And
> describing sysfs node that could read the device isolated state.
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-uacce | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
> index 08f2591138af..1601f9dac29c 100644
> --- a/Documentation/ABI/testing/sysfs-driver-uacce
> +++ b/Documentation/ABI/testing/sysfs-driver-uacce
> @@ -19,6 +19,23 @@ Contact:        linux-accelerators@lists.ozlabs.org
>  Description:    Available instances left of the device
>                  Return -ENODEV if uacce_ops get_available_instances is not provided
>  
> +What:           /sys/class/uacce/<dev_name>/isolate_strategy
> +Date:           Jul 2022
> +KernelVersion:  5.20
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    (RW) Configure the frequency size for the hardware error
> +                isolation strategy. This size is a configured integer value.
> +                The default is 0. The maximum value is 65535. This value is a
> +                threshold based on your driver handling strategy.

what is a "driver handling strategy"?  What exactly is this units in?
Any documentation for how to use this?

thanks,

greg k-h
