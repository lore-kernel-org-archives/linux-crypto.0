From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH v3] staging: ccree: fix boolreturn.cocci warning
Date: Thu, 19 Oct 2017 07:54:50 +1100
Message-ID: <20171018205450.GB31318@eros>
References: <20171018023607.GE30848@eros>
 <1508308915-18789-1-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org
To: sunil.m@techveda.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508308915-18789-1-git-send-email-sunil.m@techveda.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Suniel,

Well done with you continued versions. I am being particularly nit picky here but since we are
striving for perfection I'm sure will humour me. If English is not your first language please
forgive me for picking you up on language subtleties.

On Wed, Oct 18, 2017 at 12:11:55PM +0530, sunil.m@techveda.org wrote:
> From: Suniel Mahesh <sunil.m@techveda.org>
> 
> This fixes the following coccinelle warning:
> WARNING: return of 0/1 in function 'ssi_is_hw_key' with return type bool.

This should be a description of the problem, so saying _why_ there is a problem or _what_ is wrong
with the code currently that warrants a patch. Sometimes while describing the problem you may
include descriptions of the solution especially it is not immediately obvious why your proposed
solution fixes the issue being explained. As an extra we shouldn't ever say 'This patch ...' or
'This does xyz'.

> return "false" instead of 0.

Perfect, this is in imperative mood. Spot on!

> Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
> ---
> Changes for v3:
> - Changed the commit log even more to give an accurate
>   description of the changeset as suggested by Toby C.Harding.

My name is Tobin :)

> ---
> Changes for v2:
> - Changed the commit log to give a more accurate description
>   of the changeset as suggested by Toby C.Harding.
> ---
> Note:
> - Patch was built(ARCH=arm) on latest linux-next.
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
>  
>  #endif /* CRYPTO_TFM_REQ_HW_KEY */
> -- 
> 1.9.1
> 

For what it's worth, Reviewed-by: Tobin C. Harding <me@tobin.cc>

As stated I am being particularly 'nit picky', the commit log is _probably_ good enough to be
merged, I am not a maintainer though so it's not really anything to do with me. I do know however
that sometimes patches go to the bottom of Greg's list if they have comments/suggestions. I mention
this only so you learn more about the process and to help you with successfully getting you patches
merged. Keep up the work!

Good luck,
Tobin.
