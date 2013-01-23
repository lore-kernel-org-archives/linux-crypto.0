From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: linux-next: Tree for Jan 23 (mtd/ubi and iio and
 crypto/crc32[c])
Date: Thu, 24 Jan 2013 10:23:16 +1100
Message-ID: <20130123232316.GB25726@gondor.apana.org.au>
References: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au>
 <51006DC9.30802@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jonathan Cameron <jic23-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51006DC9.30802-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 23, 2013 at 03:10:01PM -0800, Randy Dunlap wrote:
> On 01/22/13 22:43, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130122:
> > 
> 
> 
> on i386:
> 
> ERROR: "crc32_le" [drivers/mtd/ubi/ubi.ko] undefined!
> ERROR: "iio_triggered_buffer_setup" [drivers/iio/adc/max1363.ko] undefined!
> ERROR: "iio_triggered_buffer_cleanup" [drivers/iio/adc/max1363.ko] undefined!
> ERROR: "__crc32c_le" [crypto/crc32c.ko] undefined!
> ERROR: "crc32_le" [crypto/crc32.ko] undefined!

Weird.  You do have CONFIG_CRC32 selected, so did it compile
a lib/crc32.ko or not?

Thanks,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
