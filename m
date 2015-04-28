From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v3 2/5] lib: introduce crc_t10dif_update()
Date: Tue, 28 Apr 2015 10:38:36 -0700
Message-ID: <1430242716.660.70.camel@schen9-desk2.jf.intel.com>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
	 <1429972410-7146-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: target-devel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1429972410-7146-3-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, 2015-04-25 at 23:33 +0900, Akinobu Mita wrote:
> This introduces crc_t10dif_update() which enables to calculate CRC
> for a block which straddles multiple SG elements by calling multiple
> times.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: target-devel@vger.kernel.org
> ---
> * New patch from v3
> 
>  include/linux/crc-t10dif.h |  1 +
>  lib/crc-t10dif.c           | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
> index cf53d07..d81961e 100644
> --- a/include/linux/crc-t10dif.h
> +++ b/include/linux/crc-t10dif.h
> @@ -9,5 +9,6 @@
>  extern __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer,
>  				size_t len);
>  extern __u16 crc_t10dif(unsigned char const *, size_t);
> +extern __u16 crc_t10dif_update(__u16 crc, unsigned char const *, size_t);
>  
>  #endif
> diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
> index dfe6ec1..7cdbe2e 100644
> --- a/lib/crc-t10dif.c
> +++ b/lib/crc-t10dif.c
> @@ -19,6 +19,29 @@
>  static struct crypto_shash *crct10dif_tfm;
>  static struct static_key crct10dif_fallback __read_mostly;
>  
> +__u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
> +{
> +	struct {
> +		struct shash_desc shash;
> +		char ctx[2];
> +	} desc;
> +	int err;
> +
> +	if (static_key_false(&crct10dif_fallback))
> +		return crc_t10dif_generic(crc, buffer, len);
> +
> +	desc.shash.tfm = crct10dif_tfm;
> +	desc.shash.flags = 0;
> +
> +	err = crypto_shash_import(&desc.shash, &crc);
> +	BUG_ON(err);
> +	err = crypto_shash_update(&desc.shash, buffer, len);
> +	BUG_ON(err);
> +
> +	return *(__u16 *)desc.ctx;
> +}
> +EXPORT_SYMBOL(crc_t10dif_update);
> +
>  __u16 crc_t10dif(const unsigned char *buffer, size_t len)
>  {
>  	struct {


There are a lot of duplicated code between crc_t10dif_update and
crc_t10dif.  The only difference is for the update function
we import the crc value.  I will prefer that we consolidate the code
into a local inline function that crc_t10dif_update and
crc_t10dif invoke to get rid of all the duplication.

Probably something like:

diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index dfe6ec1..0248f78 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -19,7 +19,7 @@
 static struct crypto_shash *crct10dif_tfm;
 static struct static_key crct10dif_fallback __read_mostly;
 
-__u16 crc_t10dif(const unsigned char *buffer, size_t len)
+static inline __u16 __crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len, bool update)
 {
        struct {
                struct shash_desc shash;
@@ -28,17 +28,33 @@ __u16 crc_t10dif(const unsigned char *buffer, size_t len)
        int err;
 
        if (static_key_false(&crct10dif_fallback))
-               return crc_t10dif_generic(0, buffer, len);
+               return crc_t10dif_generic(crc, buffer, len);
 
        desc.shash.tfm = crct10dif_tfm;
        desc.shash.flags = 0;
-       *(__u16 *)desc.ctx = 0;
+
+       if (update) {
+               err = crypto_shash_import(&desc.shash, &crc);   
+               BUG_ON(err);
+       } else
+               *(__u16 *)desc.ctx = 0;
 
        err = crypto_shash_update(&desc.shash, buffer, len);
        BUG_ON(err);
 
        return *(__u16 *)desc.ctx;
 }
+
+__u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
+{
+       return __crc_t10dif_update(crc, buffer, len, true);
+}
+EXPORT_SYMBOL(crc_t10dif_update);
+
+__u16 crc_t10dif(const unsigned char *buffer, size_t len)
+{
+       return __crc_t10dif_update(0, buffer, len, false);
+}
 EXPORT_SYMBOL(crc_t10dif);


Thanks.

Tim
