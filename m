Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6814ECAAA1
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Sep 2022 08:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiIII2A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Sep 2022 04:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiIII17 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2022 04:27:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBB1129C4C;
        Fri,  9 Sep 2022 01:27:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C19F0B82400;
        Fri,  9 Sep 2022 08:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFBAC433D6;
        Fri,  9 Sep 2022 08:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662712073;
        bh=wplK1MNx6GLWVUbbruKvDkA3JRB/6GAIG6BnV8rErfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rdmK7ipAWJeq9bGSuaMLTMeFZrmSMuKXrGJ41kMfygaKeuw+7UCciaAO7EYxGEbCN
         5cXADqTZ3S87XLkjITJIVGvRgeNqhLuFrdLFpBtR8W4NH7DHkHsq4i7WSiOp35srpa
         8ZU2ejV5OMw/+rhcNyBLqkCuNvFqgnHToxLlU8jM=
Date:   Fri, 9 Sep 2022 10:27:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kai Ye <yekai13@huawei.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com,
        liulongfang@huawei.com
Subject: Re: [PATCH v8 2/3] Documentation: add a isolation strategy sysfs
 node for uacce
Message-ID: <Yxr5BpM+VIjKhVpZ@kroah.com>
References: <20220902031304.37516-1-yekai13@huawei.com>
 <20220902031304.37516-3-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902031304.37516-3-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 02, 2022 at 03:13:03AM +0000, Kai Ye wrote:
> Update documentation describing sysfs node that could help to
> configure isolation strategy for users in the user space. And
> describing sysfs node that could read the device isolated state.
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-uacce | 26 ++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
> index 08f2591138af..af5bc2f326d2 100644
> --- a/Documentation/ABI/testing/sysfs-driver-uacce
> +++ b/Documentation/ABI/testing/sysfs-driver-uacce
> @@ -19,6 +19,32 @@ Contact:        linux-accelerators@lists.ozlabs.org
>  Description:    Available instances left of the device
>                  Return -ENODEV if uacce_ops get_available_instances is not provided
>  
> +What:           /sys/class/uacce/<dev_name>/isolate_strategy
> +Date:           Sep 2022
> +KernelVersion:  6.0
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    (RW) Configure the frequency size for the hardware error
> +                isolation strategy. This size is a configured integer value.
> +                The default is 0. The maximum value is 65535. This value is a
> +                threshold based on your driver strategies.

I do not understand what the units are here.

How is anyone supposed to know what they are?

> +                For example, in the hisilicon accelerator engine, first we will
> +                time-stamp every slot AER error. Then check the AER error log
> +                when the device AER error occurred. if the device slot AER error
> +                count exceeds the preset the number of times in one hour, the
> +                isolated state will be set to true. So the device will be
> +                isolated. And the AER error log that exceed one hour will be
> +                cleared. Of course, different strategies can be defined in
> +                different drivers.

So this file can contain values of different units depending on the
different driver that creates it?  How is anyone supposed to know what
it is and what it should be?

This feels very loose, please define this much better so that it can be
understood and maintained properly.

thanks,

greg k-h
