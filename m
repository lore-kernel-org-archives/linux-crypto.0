From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH] staging: ccree: fix boolreturn.cocci warning
Date: Tue, 17 Oct 2017 08:19:06 +1100
Message-ID: <20171016211906.GN16106@eros>
References: <1508148597-11911-1-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        karthik@techveda.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: sunil.m@techveda.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508148597-11911-1-git-send-email-sunil.m@techveda.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 16, 2017 at 03:39:57PM +0530, sunil.m@techveda.org wrote:
> From: Suniel Mahesh <sunil.m@techveda.org>
> 
> This fixes the following coccinelle warning:
> WARNING: return of 0/1 in function 'ssi_is_hw_key' with return type bool.

Perhaps

Coccinelle emits WARNING: return of 0/1 in function 'ssi_is_hw_key' with return type bool.

Return 'false' instead of 0.

> Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
> ---
> Note:
> - Patch was tested and built(ARCH=arm) on latest
>   linux-next.
> - No build issues reported, however it was not
>   tested on real hardware.
> - Please discard this changeset, if this is not
>   helping the code look better.
> ---
>  drivers/staging/ccree/ssi_cipher.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
> index c9a83df..f499962 100644
> --- a/drivers/staging/ccree/ssi_cipher.h
> +++ b/drivers/staging/ccree/ssi_cipher.h
> @@ -75,7 +75,7 @@ struct arm_hw_key_info {
>  
>  static inline bool ssi_is_hw_key(struct crypto_tfm *tfm)
>  {
> -	return 0;
> +	return false;
>  }

Hope this helps,
Tobin.
