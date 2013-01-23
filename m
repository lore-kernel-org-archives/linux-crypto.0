From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: linux-next: Tree for Jan 23 (mtd/ubi and iio and crypto/crc32[c])
Date: Wed, 23 Jan 2013 15:41:57 -0800
Message-ID: <51007545.5040406@infradead.org>
References: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au> <51006DC9.30802@infradead.org> <20130123232316.GB25726@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jonathan Cameron <jic23-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130123232316.GB25726-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 01/23/13 15:23, Herbert Xu wrote:
> On Wed, Jan 23, 2013 at 03:10:01PM -0800, Randy Dunlap wrote:
>> On 01/22/13 22:43, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20130122:
>>>
>>
>>
>> on i386:
>>
>> ERROR: "crc32_le" [drivers/mtd/ubi/ubi.ko] undefined!
>> ERROR: "iio_triggered_buffer_setup" [drivers/iio/adc/max1363.ko] undefined!
>> ERROR: "iio_triggered_buffer_cleanup" [drivers/iio/adc/max1363.ko] undefined!
>> ERROR: "__crc32c_le" [crypto/crc32c.ko] undefined!
>> ERROR: "crc32_le" [crypto/crc32.ko] undefined!
> 
> Weird.  You do have CONFIG_CRC32 selected, so did it compile
> a lib/crc32.ko or not?

Hmph, this seems to be some kind of rebuild problem.  It's not
reproducible, so the mtd/ubi and crypto reports above are incorrect --
please ignore them.  Only the iio one is reproducible.

Sorry about that.

-- 
~Randy
