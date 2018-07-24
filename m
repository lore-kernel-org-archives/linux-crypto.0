From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v6 02/18] crypto: cbc: Remove VLA usage
Date: Tue, 24 Jul 2018 09:49:20 -0700
Message-ID: <20180724164936.37477-3-keescook@chromium.org>
References: <20180724164936.37477-1-keescook@chromium.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>,
        Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
        "Gustavo A. R. Silva" <gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>,
        Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>,
        Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
        "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>,
        Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
        Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
        Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
        Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>,
        Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>,
        Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>,
        Giovanni Cabiddu <giovanni.cabiddu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        David Howells <dhowe
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180724164936.37477-1-keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this
uses the upper bounds on blocksize. Since this is always a cipher
blocksize, use the existing cipher max blocksize.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 include/crypto/cbc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/crypto/cbc.h b/include/crypto/cbc.h
index f5b8bfc22e6d..47db0aac2ab9 100644
--- a/include/crypto/cbc.h
+++ b/include/crypto/cbc.h
@@ -113,7 +113,9 @@ static inline int crypto_cbc_decrypt_inplace(
 	unsigned int bsize = crypto_skcipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
-	u8 last_iv[bsize];
+	u8 last_iv[MAX_CIPHER_BLOCKSIZE];
+
+	BUG_ON(bsize > sizeof(last_iv));
 
 	/* Start of the last block. */
 	src += nbytes - (nbytes & (bsize - 1)) - bsize;
-- 
2.17.1
