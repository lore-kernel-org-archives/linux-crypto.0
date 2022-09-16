Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8DFEECAAD8
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 09:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiIPJfw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 05:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiIPJfv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 05:35:51 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C377E9D8D8;
        Fri, 16 Sep 2022 02:35:48 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oZ7l7-005FHo-7O; Fri, 16 Sep 2022 19:35:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Sep 2022 17:35:41 +0800
Date:   Fri, 16 Sep 2022 17:35:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     'Guanjun' <guanjun@linux.alibaba.com>
Cc:     elliott@hpe.com, zelin.deng@linux.alibaba.com,
        xuchun.shang@linux.alibaba.com, artie.ding@linux.alibaba.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v1 1/9] crypto/ycc: Add YCC (Yitian Cryptography
 Complex) accelerator driver
Message-ID: <YyRDbT0fQQwsVpKL@gondor.apana.org.au>
References: <1662435353-114812-1-git-send-email-guanjun@linux.alibaba.com>
 <1662435353-114812-2-git-send-email-guanjun@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1662435353-114812-2-git-send-email-guanjun@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 06, 2022 at 11:35:45AM +0800, 'Guanjun' wrote:
.
> +static const struct file_operations ycc_fops = {
> +	.open = ycc_cdev_open,
> +	.release = ycc_cdev_release,
> +	.unlocked_ioctl = ycc_cdev_ioctl,
> +};

What is this device for? It doesn't seem to do anything so why
not jsut drop it?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
