Return-Path: <SRS0=WlNz=3A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F9AC282DD
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 20:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E44F208E4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 20:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578772924;
	bh=4bxlJS8vU/MMH+Ybyi3LMPzmFH6dAF8uh/1PGTdl3xA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=BEwGebn+9X+YzzLngWPkFRVLj6b+1hLdOhgS474UquJ2PIVATJX9JSV/qkLNv6tOJ
	 ip53dwzPOCrE/10veASs+4dYZ14/6px1Gm+LxL3CTu976zUbyQxC0KqHs8udpASvFu
	 kVVs0nPhK9FHKBRvXbAfdvXbuu9JOTXL5cbPhs98=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbgAKUCD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Jan 2020 15:02:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731083AbgAKUCD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Jan 2020 15:02:03 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3066A20866;
        Sat, 11 Jan 2020 20:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578772922;
        bh=4bxlJS8vU/MMH+Ybyi3LMPzmFH6dAF8uh/1PGTdl3xA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S9eCIiQmHgrpL7kJjjR0uW8UKxu9gv1wYz0w8LRH6KFUekcDJf56aMKwU1jPaU3x3
         YuK6X5QP/6MiL3LOSO8uSOf5djvapdHtKotypUbvoPY8c1xKgmrCuuSd2I2WMrCDxV
         tia3Y7mfUL6e33emaKXl/gAS4XhRzh32P3AhDuKs=
Date:   Sat, 11 Jan 2020 20:40:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, dave.jiang@intel.com,
        grant.likely@arm.com, jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH v11 2/4] uacce: add uacce driver
Message-ID: <20200111194006.GD435222@kroah.com>
References: <1578710919-12141-1-git-send-email-zhangfei.gao@linaro.org>
 <1578710919-12141-3-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578710919-12141-3-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jan 11, 2020 at 10:48:37AM +0800, Zhangfei Gao wrote:
> +static int uacce_fops_open(struct inode *inode, struct file *filep)
> +{
> +	struct uacce_mm *uacce_mm = NULL;
> +	struct uacce_device *uacce;
> +	struct uacce_queue *q;
> +	int ret = 0;
> +
> +	uacce = xa_load(&uacce_xa, iminor(inode));
> +	if (!uacce)
> +		return -ENODEV;
> +
> +	if (!try_module_get(uacce->parent->driver->owner))
> +		return -ENODEV;

Why are you trying to grab the module reference of the parent device?
Why is that needed and what is that going to help with here?

This shouldn't be needed as the module reference of the owner of the
fileops for this module is incremented, and the "parent" module depends
on this module, so how could it be unloaded without this code being
unloaded?

Yes, if you build this code into the kernel and the "parent" driver is a
module, then you will not have a reference, but when you remove that
parent driver the device will be removed as it has to be unregistered
before that parent driver can be removed from the system, right?

Or what am I missing here?

> +static void uacce_release(struct device *dev)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +
> +	kfree(uacce);
> +	uacce = NULL;

That line didn't do anything :)

thanks,

greg k-h
