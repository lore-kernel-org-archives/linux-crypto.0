From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v4 3/4] lib: introduce crc_t10dif_update()
Date: Tue, 5 May 2015 13:22:03 +0900
Message-ID: <CAC5umyg5iAXruJkvCOQui84TdueLCik72+Wi3caXpmHUQghvyw@mail.gmail.com>
References: <1430461431-5936-1-git-send-email-akinobu.mita@gmail.com>
	<1430461431-5936-4-git-send-email-akinobu.mita@gmail.com>
	<1430496906.660.79.camel@schen9-desk2.jf.intel.com>
	<CAC5umyi8dQgtN4qQBm6_X6MvPZo56sUs-RRKR+4Ds6Tx_67-wA@mail.gmail.com>
	<1430755775.660.88.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: target-devel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33266 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbbEEEWG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2015 00:22:06 -0400
In-Reply-To: <1430755775.660.88.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2015-05-05 1:09 GMT+09:00 Tim Chen <tim.c.chen@linux.intel.com>:
> On Sat, 2015-05-02 at 10:38 +0900, Akinobu Mita wrote:
>> 2015-05-02 1:15 GMT+09:00 Tim Chen <tim.c.chen@linux.intel.com>:
>> > On Fri, 2015-05-01 at 15:23 +0900, Akinobu Mita wrote:
>> >> This introduces crc_t10dif_update() which enables to calculate CRC
>> >> for a block which straddles multiple SG elements by calling multiple
>> >> times.  This also converts crc_t10dif() to use crc_t10dif_update() as
>> >> they are almost same.
>> >>
>> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> >> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
>> >> Cc: Tim Chen <tim.c.chen@linux.intel.com>
>> >> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> >> Cc: "David S. Miller" <davem@davemloft.net>
>> >> Cc: linux-crypto@vger.kernel.org
>> >> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
>> >> Cc: Sagi Grimberg <sagig@mellanox.com>
>> >> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
>> >> Cc: Christoph Hellwig <hch@lst.de>
>> >> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
>> >> Cc: target-devel@vger.kernel.org
>> >> ---
>> >> * Changes from v3:
>> >> - Reduce duplicated code between crc_t10dif_update and crc_t10dif,
>> >>   suggested by Tim and Herbert
>> >>
>> >>  include/linux/crc-t10dif.h |  1 +
>> >>  lib/crc-t10dif.c           | 13 ++++++++++---
>> >>  2 files changed, 11 insertions(+), 3 deletions(-)
>> >>
>> >> diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
>> >> index cf53d07..d81961e 100644
>> >> --- a/include/linux/crc-t10dif.h
>> >> +++ b/include/linux/crc-t10dif.h
>> >> @@ -9,5 +9,6 @@
>> >>  extern __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer,
>> >>                               size_t len);
>> >>  extern __u16 crc_t10dif(unsigned char const *, size_t);
>> >> +extern __u16 crc_t10dif_update(__u16 crc, unsigned char const *, size_t);
>> >>
>> >>  #endif
>> >> diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
>> >> index dfe6ec1..d775737 100644
>> >> --- a/lib/crc-t10dif.c
>> >> +++ b/lib/crc-t10dif.c
>> >> @@ -19,7 +19,7 @@
>> >>  static struct crypto_shash *crct10dif_tfm;
>> >>  static struct static_key crct10dif_fallback __read_mostly;
>> >>
>> >> -__u16 crc_t10dif(const unsigned char *buffer, size_t len)
>> >> +__u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
>> >>  {
>> >>       struct {
>> >>               struct shash_desc shash;
>> >> @@ -28,17 +28,24 @@ __u16 crc_t10dif(const unsigned char *buffer, size_t len)
>> >>       int err;
>> >>
>> >>       if (static_key_false(&crct10dif_fallback))
>> >> -             return crc_t10dif_generic(0, buffer, len);
>> >> +             return crc_t10dif_generic(crc, buffer, len);
>> >>
>> >>       desc.shash.tfm = crct10dif_tfm;
>> >>       desc.shash.flags = 0;
>> >> -     *(__u16 *)desc.ctx = 0;
>> >>
>> >> +     err = crypto_shash_import(&desc.shash, &crc);
>> >> +     BUG_ON(err);
>> >>       err = crypto_shash_update(&desc.shash, buffer, len);
>> >>       BUG_ON(err);
>> >>
>> >>       return *(__u16 *)desc.ctx;
>> >>  }
>> >> +EXPORT_SYMBOL(crc_t10dif_update);
>> >> +
>> >> +__u16 crc_t10dif(const unsigned char *buffer, size_t len)
>> >> +{
>> >> +     return crc_t10dif_update(0, buffer, len);
>> >
>> > Nitpicking a bit:
>> >
>> > Will putting an extra function call to crc_t10dif_update will add extra
>> > overhead to crc_t10dif, which is what most driver uses? As
>> > we are calling crc_t10dif a lot (millions of times) as we go
>> > through a block device, this extra function call
>> > is undesirable.  Using a __crc_t10dif_update
>> > inline function that both crc_t10dif_update and crc_t10dif
>> > invokes can will avoid this overhead.
>>
>> I'll convert crc_t10dif to inline function.  But do we also need to
>> make crc_t10dif_update inline function? (i.e. is there any difference
>> between __crc_t10dif_update and crc_t10dif_update?)
>
> I don't mean convert crc_t10dif to inline, but make a local inline function
> __crc_t10dif_update that both crc_t10dif_update and crc_t10dif can use
> so crc_t10dif don't have to do one more function call.  Yes, crc_t10dif_update
> and __crc_t10dif_update are equivalent but since the latter is inlined, so there's no
> performance impact and we get rid of the overhead of the extra function
> call in crc_t10dif.
>
> Like
>
> +
> +__u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
> +{
> +       return __crc_t10dif_update(crc, buffer, len, true);
> +}
> +EXPORT_SYMBOL(crc_t10dif_update);
> +
> +__u16 crc_t10dif(const unsigned char *buffer, size_t len)
> +{
> +       return __crc_t10dif_update(0, buffer, len, false);
> +}
>  EXPORT_SYMBOL(crc_t10dif);

You mean that we should avoid crypto_shash_import() function call
in crc_t10dif(), right?

The reason for crypto_shash_import() was I wanted to make
crc_t10dif_update() more generic.  But as far as I can see existing
crct10dif modules (crct10dif-generic and crct10dif-pclmul), we don't
need it (i.e. '*(__u16 *)desc.ctx = crc' instead of crc_t10dif_import)

Do you think it's better to remove crc_t10dif_import call from
crc_t10dif() and crc_t10dif_update() altogether?
