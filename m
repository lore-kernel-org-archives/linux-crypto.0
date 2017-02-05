From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH] crypto: algapi - make crypto_xor() and crypto_inc()
 alignment agnostic
Date: Sat, 4 Feb 2017 19:05:27 -0800
Message-ID: <20170205030527.GA21055@zzz>
References: <1485785489-5116-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170202064716.GB582@zzz>
 <CAHmME9qtX64rp-bXfb7-vM-vsBd18186MNZ4G9KonLYhsM5uEg@mail.gmail.com>
 <CAHmME9pwhWrXLEXyrPKueFwoVexEVNvSxN=FDFLsi+gHowE2Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33859 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdBEDFc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Feb 2017 22:05:32 -0500
Received: by mail-pf0-f196.google.com with SMTP id y143so4336117pfb.1
        for <linux-crypto@vger.kernel.org>; Sat, 04 Feb 2017 19:05:32 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAHmME9pwhWrXLEXyrPKueFwoVexEVNvSxN=FDFLsi+gHowE2Ww@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 05, 2017 at 12:10:53AM +0100, Jason A. Donenfeld wrote:
> Another thing that might be helpful is that you can let gcc decide on
> the alignment, and then optimize appropriately. Check out what we do
> with siphash:
> 
> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/tree/include/linux/siphash.h#n76
> 
> static inline u64 siphash(const void *data, size_t len, const
> siphash_key_t *key)
> {
> #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>         if (!IS_ALIGNED((unsigned long)data, SIPHASH_ALIGNMENT))
>                 return __siphash_unaligned(data, len, key);
> #endif
>         return ___siphash_aligned(data, len, key);
> }
> 
> With this trick, we fall through to the fast alignment-assuming code,
> if gcc can prove that the address is inlined. This is often the case
> when passing structs, or when passing buffers that have
> __aligned(BLOCKSIZE). It proves to be a very useful optimization on
> some platforms.

Yes, this is a good idea.  Though it seems that usually at least one of the two
pointers passed to crypto_xor() will have alignment unknown to the compiler,
sometimes the length is constant which inlining can help a lot for.  For
example, if someone does crypto_xor(foo, bar, 16) on x86_64 or ARM64, we'd
really like it to turn into just a few instructions like this:

	mov    (%rsi),%rax
	xor    %rax,(%rdi)
	mov    0x8(%rsi),%rax
	xor    %rax,0x8(%rdi)

So how about inlining crypto_xor() if CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS or
the pointers are long-aligned, otherwise calling an out-of-line function
__crypto_xor_unaligned() that handles all the cases with weird alignment.
Something like the following patch:

(Note: exactly how __crypto_xor_unaligned() is implemented is still debatable;
it could be more similar to Ard's proposal, or it could use the unaligned access
helpers.)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index df939b54b09f..a0591db3f13a 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -972,23 +972,69 @@ void crypto_inc(u8 *a, unsigned int size)
 }
 EXPORT_SYMBOL_GPL(crypto_inc);
 
-static inline void crypto_xor_byte(u8 *a, const u8 *b, unsigned int size)
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+void __crypto_xor_unaligned(u8 *dst, const u8 *src, unsigned int len)
 {
-	for (; size; size--)
-		*a++ ^= *b++;
-}
+	unsigned long delta = (unsigned long)dst ^ (unsigned long)src;
 
-void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
-{
-	u32 *a = (u32 *)dst;
-	u32 *b = (u32 *)src;
+	/* Handle relative misalignment */
+	if (delta % sizeof(unsigned long)) {
+
+		/* 1-byte relative misalignment? */
+		if (delta & 1) {
+			while (len--)
+				*dst++ ^= *src++;
+			return;
+		}
 
-	for (; size >= 4; size -= 4)
-		*a++ ^= *b++;
+		/* 2-byte relative misalignment? */
+		if ((delta & 2) || sizeof(unsigned long) == 4) {
+			if ((unsigned long)dst % __alignof__(u16) && len) {
+				*dst++ ^= *src++;
+				len--;
+			}
+			while (len >= 2) {
+				*(u16 *)dst ^= *(u16 *)src;
+				dst += 2, src += 2, len -= 2;
+			}
+			if (len)
+				*dst ^= *src;
+			return;
+		}
+
+		/* 4-byte relative misalignment? */
+		while ((unsigned long)dst % __alignof__(u32) && len) {
+			*dst++ ^= *src++;
+			len--;
+		}
+		while (len >= 4) {
+			*(u32 *)dst ^= *(u32 *)src;
+			dst += 4, src += 4, len -= 4;
+		}
+		while (len--)
+			*dst++ ^= *src++;
+		return;
+	}
+
+	/* No relative misalignment; use word accesses */
+
+	while ((unsigned long)dst % __alignof__(unsigned long) && len) {
+		*dst++ ^= *src++;
+		len--;
+	}
+
+	while (len >= sizeof(unsigned long)) {
+		*(unsigned long *)dst ^= *(unsigned long *)src;
+		dst += sizeof(unsigned long);
+		src += sizeof(unsigned long);
+		len -= sizeof(unsigned long);
+	}
 
-	crypto_xor_byte((u8 *)a, (u8 *)b, size);
+	while (len--)
+		*dst++ ^= *src++;
 }
-EXPORT_SYMBOL_GPL(crypto_xor);
+EXPORT_SYMBOL_GPL(__crypto_xor_unaligned);
+#endif /* !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
 
 unsigned int crypto_alg_extsize(struct crypto_alg *alg)
 {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 404e9558e879..718145c5eaca 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -191,9 +191,29 @@ static inline unsigned int crypto_queue_len(struct crypto_queue *queue)
 	return queue->qlen;
 }
 
-/* These functions require the input/output to be aligned as u32. */
 void crypto_inc(u8 *a, unsigned int size);
-void crypto_xor(u8 *dst, const u8 *src, unsigned int size);
+
+void __crypto_xor_unaligned(u8 *dst, const u8 *src, unsigned int len);
+
+static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int len)
+{
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+	    (((unsigned long)dst | (unsigned long)src) %
+	     __alignof__(unsigned long) == 0))
+	{
+		while (len >= sizeof(unsigned long)) {
+			*(unsigned long *)dst ^= *(unsigned long *)src;
+			dst += sizeof(unsigned long);
+			src += sizeof(unsigned long);
+			len -= sizeof(unsigned long);
+		}
+
+		while (len--)
+			*dst++ ^= *src++;
+		return;
+	}
+	return __crypto_xor_unaligned(dst, src, len);
+}
 
 int blkcipher_walk_done(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk, int err);
