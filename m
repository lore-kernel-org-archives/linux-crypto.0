From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 01/27] Drivers: ccree: ssi_sysfs.h - align block comments
Date: Wed, 24 May 2017 19:51:05 +1000
Message-ID: <20170524095105.GK8158@eros>
References: <20170524044032.29913-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
To: Derek Robson <robsonde@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20170524044032.29913-1-robsonde@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Wed, May 24, 2017 at 04:40:32PM +1200, Derek Robson wrote:
> Fixed block comment alignment, Style fix only
> Found using checkpatch

It's 'one thing per patch', this whole set does one thing. You may
like to submit it as a single patch. You won't need the file name in
the commit summary then also :)

Good luck,
Tobin.

> 
> Signed-off-by: Derek Robson <robsonde@gmail.com>
> ---
>  drivers/staging/ccree/ssi_sysfs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/ccree/ssi_sysfs.h b/drivers/staging/ccree/ssi_sysfs.h
> index cd456c5dccc4..4893e014adf7 100644
> --- a/drivers/staging/ccree/ssi_sysfs.h
> +++ b/drivers/staging/ccree/ssi_sysfs.h
> @@ -15,7 +15,7 @@
>   */
>  
>  /* \file ssi_sysfs.h
> -   ARM CryptoCell sysfs APIs
> + * ARM CryptoCell sysfs APIs
>   */
>  
>  #ifndef __SSI_SYSFS_H__
> -- 
> 2.12.2
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
