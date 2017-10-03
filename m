From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] staging: ccree: Convert to
 platform_{get,set}_drvdata()
Date: Tue, 3 Oct 2017 18:29:20 +0200
Message-ID: <20171003162920.GA11186@kroah.com>
References: <1505993344-18304-1-git-send-email-sunil.m@techveda.org>
 <1505996262-19137-1-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org
To: sunil.m@techveda.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58108 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751964AbdJCQ3L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 12:29:11 -0400
Content-Disposition: inline
In-Reply-To: <1505996262-19137-1-git-send-email-sunil.m@techveda.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 21, 2017 at 05:47:42PM +0530, sunil.m@techveda.org wrote:
> From: Suniel Mahesh <sunil.m@techveda.org>
> 
> Platform devices are expected to use wrapper functions,
> platform_{get,set}_drvdata() with platform_device as argument,
> for getting and setting the driver data. dev_{get,set}_drvdata()
> are using &plat_dev->dev.
> For wrapper functions we can directly pass a struct platform_device.
> 
> dev_set_drvdata() is redundant and therefore removed. The driver core
> clears the driver data to NULL after device_release or on probe failure.
> 
> Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
> ---
> Changes for v2:
> - Rebased on top of staging-testing.

Can you rebase again, this still does not apply :(
