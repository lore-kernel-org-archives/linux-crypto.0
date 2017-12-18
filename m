From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: af_alg - add keylen checking to avoid NULL ptr
 passing down
Date: Mon, 18 Dec 2017 13:00:09 +0100
Message-ID: <20171218120009.GA8328@kroah.com>
References: <1513595363-27577-1-git-send-email-hw.likun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Li Kun <hw.likun@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752708AbdLRMAR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Dec 2017 07:00:17 -0500
Content-Disposition: inline
In-Reply-To: <1513595363-27577-1-git-send-email-hw.likun@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 18, 2017 at 11:09:23AM +0000, Li Kun wrote:
> alg_setkey do not check the keylen whether it is zero, so the key
> may be ZERO_SIZE_PTR when keylen is 0, which will pass the
> copy_from_user's checking and be passed to the lower functions as key.
> 
> If the lower functions only check the key if it is NULL, ZERO_SIZE_PTR
> will pass the checking, and will cause null ptr dereference, so it's
> better to intercept the invalid parameters in the upper functions.
> 
> This patch is also suitable to fix CVE-2017-15116 for stable trees.
> 
> Signed-off-by: Li Kun <hw.likun@huawei.com>
> ---
>  crypto/af_alg.c | 2 ++
>  1 file changed, 2 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
