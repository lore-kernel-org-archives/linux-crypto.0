From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Desynchronizing dm-raid1
Date: Tue, 13 May 2008 16:35:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0805131622120.486@engineering.redhat.com>
References: <E1JtKQL-0004Nm-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.64.0805061849020.7260@engineering.redhat.com>
	<Pine.LNX.4.64.0805122325050.373@engineering.redhat.com>
	<20080513033822.GA9604@gondor.apana.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: dm-devel@redhat.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080513033822.GA9604@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org



On Tue, 13 May 2008, Herbert Xu wrote:

> On Mon, May 12, 2008 at 11:28:44PM -0400, Mikulas Patocka wrote:
>>
>> Or do you thint it would be useless (all major disk-encryption algorithms
>> read input buffer more times?) or it would create too much code
>> complexity?
>
> I'm open to this approach.  As long as you do the work and come up
> with the patch that is :)
>
> Cheers,

And where would you propose to place this bit?

One possibility would be struct crypto_tfm->crt_flags
Another possibility is struct crypto_alg->cra_flags

Can chaining mode change the value of the flag? (I presume that yes)

So make a bit in struct crypto_alg. And propagate it to 
crypto_alg->cra_flags of chaining modes that read input data only once?

I'm not familiar with Linux crypto API, so the location of the flag should 
be selected by someone who knows it well.

Here I'm sending the patch for dm-crypt. To optimize it further, you 
should add the test after bio_data_dir(ctx->bio_in) == WRITE test --- i.e. 
if the algorithm is safe to read input only once, the smaller and faster 
branch can be executed.

Mikukas

---

Copy data when writing to the device.

This patch fixes damaged blocks on encrypted device when the computer crashes.

Linux IO architecture allows the data to be modified while they are being
written.

While we are processing write requests, the data may change, and it is expected,
that each byte written to the device is either old byte or new byte.

Some crypto functions may read the input buffer more than once and so they'll
produce garbage if the buffer changes under them. When this garbage is
read again and decrypted, it may produce damage in all bytes in the block. This
damage is visible only if the computer crashes; if it didn't crash, the memory
manager writes correct buffer or page contents some times later.

So we first copy data to a temporary buffer with memcpy and then encrypt them
in place.

Mikulas Patocka <mpatocka@redhat.com>

---
  drivers/md/dm-crypt.c |   14 ++++++++++++--
  1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.25.3/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.25.3.orig/drivers/md/dm-crypt.c	2008-05-13 21:48:32.000000000 +0200
+++ linux-2.6.25.3/drivers/md/dm-crypt.c	2008-05-13 22:14:12.000000000 +0200
@@ -360,8 +360,18 @@ static int crypt_convert_block(struct cr
  			 crypto_ablkcipher_alignmask(cc->tfm) + 1);

  	sg_init_table(&dmreq->sg_in, 1);
-	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
-		    bv_in->bv_offset + ctx->offset_in);
+	if (bio_data_dir(ctx->bio_in) == WRITE) {
+		char *page_in = kmap_atomic(bv_in->bv_page, KM_USER0);
+		char *page_out = kmap_atomic(bv_out->bv_page, KM_USER1);
+		memcpy(page_out + bv_out->bv_offset + ctx->offset_out, page_in + bv_in->bv_offset + ctx->offset_in, 1 << SECTOR_SHIFT);
+		kunmap_atomic(page_in, KM_USER0);
+		kunmap_atomic(page_out, KM_USER1);
+
+		sg_set_page(&dmreq->sg_in, bv_out->bv_page, 1 << SECTOR_SHIFT,
+			    bv_out->bv_offset + ctx->offset_out);
+	} else
+		sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
+			    bv_in->bv_offset + ctx->offset_in);

  	sg_init_table(&dmreq->sg_out, 1);
  	sg_set_page(&dmreq->sg_out, bv_out->bv_page, 1 << SECTOR_SHIFT,
