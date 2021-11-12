Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38474C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 08:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B04160F93
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 08:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhKLJAc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232841AbhKLJAc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 04:00:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEACC60174;
        Fri, 12 Nov 2021 08:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636707461;
        bh=qwF10LzYUh/5T7JHWf40NdpKnvbq6HmmRAes4RqYG9I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RkzpijkuJR7isJmsqb3vJObv84vsHuJCywYtLAewq/l6RU795dN/5TonQ5smxvnhx
         nTqGqoxHalnd3THNbe1cpphNzNlOke9k3BJk7gYBr6EvgvpV+uPy9CykqBcLgH3O7h
         qy+uwz2gPs43olIlXLFi3whrLrINZp0Z7CtHV0cM=
Date:   Fri, 12 Nov 2021 09:57:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Aayush Agarwal <aayush.a.agarwal@oracle.com>
Cc:     Evan Xuan <jian.xuan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Amey Narkhede <ameynarkhede03@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lee Jones <lee.jones@linaro.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium/nitrox - Fix 'File exists' error in
 'nitrox_probe()'
Message-ID: <YY4sgh89YZNpIjGt@kroah.com>
References: <20211112085401.29306-1-aayush.a.agarwal@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112085401.29306-1-aayush.a.agarwal@oracle.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 12, 2021 at 12:54:00AM -0800, Aayush Agarwal wrote:
> When two cavium cards are inserted and on booting OS,
> nitrox_debugfs_init() is called twice and thus tries to create
> 'n5pf' directory twice inside '/'. This causes the 'File exists' error.
> 
> This error was handled before
> 'commit 97a93b2b5839 ("crypto: cavium/nitrox - no need to check return
> value of debugfs_create functions")'
> 
> This commit handles the error by redirecting the code by checking
> if 'n5pf' directory exists already using 'debugfs_lookup()' function.
> 
> Tested-by: Evan Xuan <jian.xuan@oracle.com>
> Signed-off-by: Aayush Agarwal <aayush.a.agarwal@oracle.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
> index 6c61817996a3..1eee05e30f05 100644
> --- a/drivers/crypto/cavium/nitrox/nitrox_main.c
> +++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
> @@ -7,6 +7,7 @@
>  #include <linux/mutex.h>
>  #include <linux/pci.h>
>  #include <linux/pci_ids.h>
> +#include <linux/debugfs.h>
>  
>  #include "nitrox_dev.h"
>  #include "nitrox_common.h"
> @@ -479,6 +480,13 @@ static int nitrox_probe(struct pci_dev *pdev,
>  	if (err)
>  		goto pf_hw_fail;
>  
> +	struct dentry *check_dir = debugfs_lookup(KBUILD_MODNAME, NULL);
> +
> +	if (check_dir != NULL) {
> +		dput(check_dir);
> +		goto pf_hw_fail;

Why is this a "failure"?

> +	}
> +
>  	nitrox_debugfs_init(ndev);

Why not just put the "check" logic in this function instead?
You want to have per-device directories in debugfs for this device,
right?  If so, then this function should handle that, not the
nitrox_probe() call.

thanks,

greg k-h
