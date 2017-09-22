From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging:ccree Fix dont use assignment in if condition
Date: Fri, 22 Sep 2017 10:55:05 +0200
Message-ID: <20170922085505.GA8720@kroah.com>
References: <1505975824-28175-1-git-send-email-jananis37@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Janani Sankara Babu <jananis37@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdIVIyy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2017 04:54:54 -0400
Content-Disposition: inline
In-Reply-To: <1505975824-28175-1-git-send-email-jananis37@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 21, 2017 at 12:07:04PM +0530, Janani Sankara Babu wrote:
> This patch solves the following error shown by checkpatch script
> ERROR: do not use assignment in if condition
> 
> Signed-off-by: Janani Sankara Babu <jananis37@gmail.com>
> ---
>  drivers/staging/ccree/ssi_hash.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

You sent me 5 patches for the same driver, yet no way for me to
determine what the order of the patches are.  Please resend as a
numbered patch series so I get it right.

Remember, make it obvious what a maintainer is supposed to do...

thanks,

greg k-h
