From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH RESEND] crypto: af_alg - add keylen checking to avoid
 NULL ptr passing down
Date: Mon, 18 Dec 2017 11:12:33 -0800
Message-ID: <20171218191233.GA55142@gmail.com>
References: <1513604436-43814-1-git-send-email-hw.likun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Li Kun <hw.likun@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:46538 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933534AbdLRTMi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Dec 2017 14:12:38 -0500
Received: by mail-io0-f193.google.com with SMTP id x129so10964277iod.13
        for <linux-crypto@vger.kernel.org>; Mon, 18 Dec 2017 11:12:37 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1513604436-43814-1-git-send-email-hw.likun@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 18, 2017 at 01:40:36PM +0000, Li Kun wrote:
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
> Cc: stable@vger.kernel.org
> ---
>  crypto/af_alg.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 337cf38..10f22f3 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -210,6 +210,8 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
>  	u8 *key;
>  	int err;
>  
> +	if (!keylen)
> +		return -EINVAL;
>  	key = sock_kmalloc(sk, keylen, GFP_KERNEL);
>  	if (!key)
>  		return -ENOMEM;
> -- 

If the length is 0 then why is the underlying ->setkey() method dereferencing
the pointer?  Which algorithm does this happen for?  Checking for NULL makes no
sense; the length needs to be checked instead.

Eric
