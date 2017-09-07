From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Staging: ccree: Prefer using BIT macro.
Date: Thu, 7 Sep 2017 15:53:50 +0200
Message-ID: <20170907135350.GA27426@kroah.com>
References: <1504792029-8050-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        linux-crypto@vger.kernel.org
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39126 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932079AbdIGNxw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2017 09:53:52 -0400
Content-Disposition: inline
In-Reply-To: <1504792029-8050-1-git-send-email-srishtishar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 07, 2017 at 07:17:09PM +0530, Srishti Sharma wrote:
> Use BIT(x) instead of (1<<x), reported by checkpatch.pl.
> 
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> ---
>  drivers/staging/ccree/ssi_cipher.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
> index 296b375..6fbcf9d 100644
> --- a/drivers/staging/ccree/ssi_cipher.h
> +++ b/drivers/staging/ccree/ssi_cipher.h
> @@ -27,11 +27,11 @@
>  #include "ssi_buffer_mgr.h"
> 
>  /* Crypto cipher flags */
> -#define CC_CRYPTO_CIPHER_KEY_KFDE0    (1 << 0)
> -#define CC_CRYPTO_CIPHER_KEY_KFDE1    (1 << 1)
> -#define CC_CRYPTO_CIPHER_KEY_KFDE2    (1 << 2)
> -#define CC_CRYPTO_CIPHER_KEY_KFDE3    (1 << 3)
> -#define CC_CRYPTO_CIPHER_DU_SIZE_512B (1 << 4)
> +#define CC_CRYPTO_CIPHER_KEY_KFDE0    BIT(0)
> +#define CC_CRYPTO_CIPHER_KEY_KFDE1    BIT(1)
> +#define CC_CRYPTO_CIPHER_KEY_KFDE2    BIT(2)
> +#define CC_CRYPTO_CIPHER_KEY_KFDE3    BIT(3)
> +#define CC_CRYPTO_CIPHER_DU_SIZE_512B BIT(4)

Care to use a <TAB> here as well?  I know the original didn't, but the
cleaned up code should.

thanks,

greg k-h
