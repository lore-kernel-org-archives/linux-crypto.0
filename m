From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: PATCH crypto/zlib: Allow Z_OK return value from zlib_deflate
Date: Wed, 13 Jan 2010 20:45:04 +1100
Message-ID: <20100113094504.GA11422@gondor.apana.org.au>
References: <20091220192122.M17448@cs.sunysb.edu> <20091223120157.GA29795@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	vtaras@cs.sunysb.edu,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Aseem Rastogi <arastogi@cs.sunysb.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52343 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753343Ab0AMJpJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2010 04:45:09 -0500
Content-Disposition: inline
In-Reply-To: <20091223120157.GA29795@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 23, 2009 at 08:01:57PM +0800, Herbert Xu wrote:
>
> Hmm, it seems that the semantics of the final function isn't
> quite right.  It was never meant to be called multiple times.
> 
> Let me see if we can fix this up without touching the interface.

How about this patch? So now the final functions are more like
their zlib counterparts.  If it runs out of output buffer, it
returns avail_out + 1 and you need to call it again.

diff --git a/crypto/zlib.c b/crypto/zlib.c
index c301573..632b4b4 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -190,19 +190,23 @@ static int zlib_compress_final(struct crypto_pcomp *tfm,
 	stream->avail_out = req->avail_out;
 
 	ret = zlib_deflate(stream, Z_FINISH);
+	if (ret == Z_OK)
+		ret = req->avail_out + 1;
 	if (ret != Z_STREAM_END) {
 		pr_debug("zlib_deflate failed %d\n", ret);
 		return -EINVAL;
-	}
+	} else
+		ret = req->avail_out - stream->avail_out;
 
-	ret = req->avail_out - stream->avail_out;
 	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
 		 req->avail_in - stream->avail_in, ret);
+
 	req->next_in = stream->next_in;
 	req->avail_in = stream->avail_in;
 	req->next_out = stream->next_out;
 	req->avail_out = stream->avail_out;
+
 	return ret;
 }
 
@@ -323,15 +327,19 @@ static int zlib_decompress_final(struct crypto_pcomp *tfm,
 		}
 	} else
 		ret = zlib_inflate(stream, Z_FINISH);
-	if (ret != Z_STREAM_END) {
+
+	if (ret == Z_OK)
+		ret = req->avail_out + 1;
+	else if (ret != Z_STREAM_END) {
 		pr_debug("zlib_inflate failed %d\n", ret);
 		return -EINVAL;
-	}
+	} else
+		ret = req->avail_out - stream->avail_out;
 
-	ret = req->avail_out - stream->avail_out;
 	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
 		 req->avail_in - stream->avail_in, ret);
+
 	req->next_in = stream->next_in;
 	req->avail_in = stream->avail_in;
 	req->next_out = stream->next_out;

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
