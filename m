From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: eCryptfs: Use skcipher and shash
Date: Wed, 16 Mar 2016 17:06:01 +0800
Message-ID: <20160316090601.GA29058@gondor.apana.org.au>
References: <20160316074141.GB12860@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ecryptfs@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42905 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPJGF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Mar 2016 05:06:05 -0400
Content-Disposition: inline
In-Reply-To: <20160316074141.GB12860@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 16, 2016 at 10:41:41AM +0300, Dan Carpenter wrote:
> Hello Herbert Xu,
> 
> The patch 3095e8e366b4: "eCryptfs: Use skcipher and shash" from Jan
> 25, 2016, leads to the following static checker warning:
> 
> 	fs/ecryptfs/keystore.c:1117 ecryptfs_parse_tag_70_packet()
> 	error: potential null dereference 's'.  (kzalloc returns null)

Thanks for catching this Dan.  It's probably easiest if I add
this to the crypto tree.

---8<---
eCryptfs: Fix null pointer dereference on kzalloc error path

The conversion to skcipher and shash added a couple of null pointer
dereference bugs on the kzalloc failure path.  This patch fixes them.

Fixes: 3095e8e366b4 ("eCryptfs: Use skcipher and shash")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index c5c84df..9893d15 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -635,8 +635,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 	if (!s) {
 		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
 		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
-		rc = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 	(*packet_size) = 0;
 	rc = ecryptfs_find_auth_tok_for_sig(
@@ -922,8 +921,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 	if (!s) {
 		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
 		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
-		rc = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 	if (max_packet_size < ECRYPTFS_TAG_70_MIN_METADATA_SIZE) {
 		printk(KERN_WARNING "%s: max_packet_size is [%zd]; it must be "

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
