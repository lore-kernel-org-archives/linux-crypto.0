Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E4632BF4B
	for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 07:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762846963; cv=none; b=kGBR0BE2pT/i1RbZyEVekX/DKh0O4svBE9jpQXQR/3RXEuMSaM4donkKIBRUe6nLvaOhhZuZ4tOsfnHs8s3G/xE4awSDZrxWP+AS8YsXYoi1z1ekUdKikDx7DIzjHTYFLdxk+GJ9JMZ96f6o01VQabHUKZU1kSKQiVKtU+hoy1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762846963; c=relaxed/simple;
	bh=r+8w4vA3SwktEPMJkEoELzqnRwyW2DrJoa/HlJ2wn6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UoLT+ugt7RoLe95DQg2uIuqIRQPWc4ayaJLlDk8xoQJM4ZGUOmFE8ffRSMhsrvG9rXOtJgh9QnUaF05uLPNsEM0d/QYXX7A01xC/VKegj1WkY0IxL0EI6W6K7wXpftElttGIfJD2xBFgzyxDvSZRW0wi4rMCdH7BubOaBUmrrWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1RXS4tT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1RXS4tT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204F2C4CEF7
	for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 07:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762846963;
	bh=r+8w4vA3SwktEPMJkEoELzqnRwyW2DrJoa/HlJ2wn6w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=B1RXS4tTEDLecE0jKoDVZYnhACX3BRpJPYBVtOtyfhjG33CZuC7PguvLtnzR+d4qT
	 6bryLy/6DpG0KKIYriFQJI/dO3v6aU5qq3KZP41cjaBr7jVF5eR0CmaoNNK2OyglYx
	 gV/vVmV1+7sSeMcqpgZ4iznny6zFtyf2ZJpNsOwzfFUgWxFg1Jto9jWjYbaQdpUqP/
	 MRjpZQ5TXUTSvJHQZvsCmH8zdFSg64iPzUPoJlKmgCvrRr4OpQIOlI9sP2cBnz/h3k
	 t6kKYRWz5+5BeONP2ThLcDqgRAwfsaQWPdadIR/aXAVZzq9wGgEGVtxA85Ha+7ZaD7
	 H5qdmwsALIh0Q==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5942e61f001so3721048e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 23:42:43 -0800 (PST)
X-Gm-Message-State: AOJu0Yw2SsRS7/DUJlXn4SZtAznkuj2Ivz37gzWc944dAuSfS9dWVWIv
	9cVd/PvjVi00uqolpzUXvjt/sRSPteCoVoF15RxXbuJSgPg+8ZnpIxuqSlm1K2XXlheQsVqJ0vE
	Rqk9GAFkCQkWsTZSV26Qbe6Q+TAha66c=
X-Google-Smtp-Source: AGHT+IFlBkUObIglCRf4UZWv8l+HYHOpshdd7U6UW4spi43RTFetJkp3sRg/WvoVxR2gFpWAMX+W8RQn7JMt52Gj9NI=
X-Received: by 2002:a05:6512:158c:b0:594:341a:ab1e with SMTP id
 2adb3069b0e04-5945f1b74afmr3460983e87.31.1762846961256; Mon, 10 Nov 2025
 23:42:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109234726.638437-1-ebiggers@kernel.org> <20251109234726.638437-3-ebiggers@kernel.org>
 <CAMj1kXE1mhu7u5RwhCBA_RUGV6JSDV-GQPpq+thE-0-oVxrmfw@mail.gmail.com>
In-Reply-To: <CAMj1kXE1mhu7u5RwhCBA_RUGV6JSDV-GQPpq+thE-0-oVxrmfw@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 11 Nov 2025 08:42:29 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHoH2K0dpqyrgFJ-OBmP2QrUWZD3aCfaA_eoPzGsLbPMw@mail.gmail.com>
X-Gm-Features: AWmQ_blV8cVZF11eG-28ddw818OLF8-voDXRwu93uaHJb2HD2rwHxKD2AEQyhZU
Message-ID: <CAMj1kXHoH2K0dpqyrgFJ-OBmP2QrUWZD3aCfaA_eoPzGsLbPMw@mail.gmail.com>
Subject: Re: [PATCH 2/9] lib/crypto: polyval: Add POLYVAL library
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 10 Nov 2025 at 16:21, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Hi,
>
> On Mon, 10 Nov 2025 at 00:49, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Add support for POLYVAL to lib/crypto/.
> >
> > This will replace the polyval crypto_shash algorithm and its use in the
> > hctr2 template, simplifying the code and reducing overhead.
> >
> > Specifically, this commit introduces the POLYVAL library API and a
> > generic implementation of it.  Later commits will migrate the existing
> > architecture-optimized implementations of POLYVAL into lib/crypto/ and
> > add a KUnit test suite.
> >
> > I've also rewritten the generic implementation completely, using a more
> > modern approach instead of the traditional table-based approach.  It's
> > now constant-time, requires no precomputation or dynamic memory
> > allocations, decreases the per-key memory usage from 4096 bytes to 16
> > bytes, and is faster than the old polyval-generic even on bulk data
> > reusing the same key (at least on x86_64, where I measured 15% faster).
> > We should do this for GHASH too, but for now just do it for POLYVAL.
> >
>
> Very nice.
>
> GHASH might suffer on 32-bit, I suppose, but taking this approach at
> least on 64-bit also for GHASH would be a huge improvement.
>
> I had a stab at replacing the int128 arithmetic with
> __builtin_bitreverse64(), but it seems to make little difference (and
> GCC does not support it [yet]). I've tried both arm64 and x86, and the
> perf delta (using your kunit benchmark) is negligible in either case.

Sigh. I intended to only apply the generic patch and the kunit test,
but applied the whole series in the end, which explains perfectly why
x86_64 and arm64 performance are identical, given that the generic
code isn't even used.

So trying this again, on a Cortex-A72 without Crypto Extensions, I do
get a ~30% performance improvement doing the below. I haven't
re-tested x86, but given that it does not appear to have a native
scalar bit reverse instruction (or __builtin_bitreverse64() is broken
for it), there is probably no point in finding out.

Not saying we should do this for POLYVAL, but something to keep in
mind for gf128mul.c perhaps.


--- a/lib/crypto/polyval.c
+++ b/lib/crypto/polyval.c
@@ -42,11 +42,48 @@
  * 256-bit => 128-bit reduction algorithm.
  */

-#ifdef CONFIG_ARCH_SUPPORTS_INT128
+#if defined(CONFIG_ARCH_SUPPORTS_INT128) ||
__has_builtin(__builtin_bitreverse64)

 /* Do a 64 x 64 => 128 bit carryless multiplication. */
 static void clmul64(u64 a, u64 b, u64 *out_lo, u64 *out_hi)
 {
+       u64 a0 = a & 0x1111111111111111;
+       u64 a1 = a & 0x2222222222222222;
+       u64 a2 = a & 0x4444444444444444;
+       u64 a3 = a & 0x8888888888888888;
+
+       u64 b0 = b & 0x1111111111111111;
+       u64 b1 = b & 0x2222222222222222;
+       u64 b2 = b & 0x4444444444444444;
+       u64 b3 = b & 0x8888888888888888;
+
+#if __has_builtin(__builtin_bitreverse64)
+#define brev64 __builtin_bitreverse64
+       u64 c0 = (a0 * b0) ^ (a1 * b3) ^ (a2 * b2) ^ (a3 * b1);
+       u64 c1 = (a0 * b1) ^ (a1 * b0) ^ (a2 * b3) ^ (a3 * b2);
+       u64 c2 = (a0 * b2) ^ (a1 * b1) ^ (a2 * b0) ^ (a3 * b3);
+       u64 c3 = (a0 * b3) ^ (a1 * b2) ^ (a2 * b1) ^ (a3 * b0);
+
+       a0 = brev64(a0);
+       a1 = brev64(a1);
+       a2 = brev64(a2);
+       a3 = brev64(a3);
+
+       b0 = brev64(b0);
+       b1 = brev64(b1);
+       b2 = brev64(b2);
+       b3 = brev64(b3);
+
+       u64 d0 = (a0 * b0) ^ (a1 * b3) ^ (a2 * b2) ^ (a3 * b1);
+       u64 d1 = (a0 * b1) ^ (a1 * b0) ^ (a2 * b3) ^ (a3 * b2);
+       u64 d2 = (a0 * b2) ^ (a1 * b1) ^ (a2 * b0) ^ (a3 * b3);
+       u64 d3 = (a0 * b3) ^ (a1 * b2) ^ (a2 * b1) ^ (a3 * b0);
+
+       *out_hi = ((brev64(d0) >> 1) & 0x1111111111111111) ^
+                 ((brev64(d1) >> 1) & 0x2222222222222222) ^
+                 ((brev64(d2) >> 1) & 0x4444444444444444) ^
+                 ((brev64(d3) >> 1) & 0x8888888888888888);
+#else
        /*
         * With 64-bit multiplicands and one term every 4 bits, there would be
         * up to 64 / 4 = 16 one bits per column when each multiplication is
@@ -60,15 +97,10 @@ static void clmul64(u64 a, u64 b, u64 *out_lo, u64 *out_hi)
         * Instead, mask off 4 bits from one multiplicand, giving a max of 15
         * one bits per column.  Then handle those 4 bits separately.
         */
-       u64 a0 = a & 0x1111111111111110;
-       u64 a1 = a & 0x2222222222222220;
-       u64 a2 = a & 0x4444444444444440;
-       u64 a3 = a & 0x8888888888888880;
-
-       u64 b0 = b & 0x1111111111111111;
-       u64 b1 = b & 0x2222222222222222;
-       u64 b2 = b & 0x4444444444444444;
-       u64 b3 = b & 0x8888888888888888;
+       a0 &= ~0xfULL;
+       a1 &= ~0xfULL;
+       a2 &= ~0xfULL;
+       a3 &= ~0xfULL;

        /* Multiply the high 60 bits of @a by @b. */
        u128 c0 = (a0 * (u128)b0) ^ (a1 * (u128)b3) ^
@@ -85,18 +117,20 @@ static void clmul64(u64 a, u64 b, u64 *out_lo, u64 *out_hi)
        u64 e1 = -((a >> 1) & 1) & b;
        u64 e2 = -((a >> 2) & 1) & b;
        u64 e3 = -((a >> 3) & 1) & b;
-       u64 extra_lo = e0 ^ (e1 << 1) ^ (e2 << 2) ^ (e3 << 3);
-       u64 extra_hi = (e1 >> 63) ^ (e2 >> 62) ^ (e3 >> 61);

        /* Add all the intermediate products together. */
-       *out_lo = (((u64)c0) & 0x1111111111111111) ^
-                 (((u64)c1) & 0x2222222222222222) ^
-                 (((u64)c2) & 0x4444444444444444) ^
-                 (((u64)c3) & 0x8888888888888888) ^ extra_lo;
        *out_hi = (((u64)(c0 >> 64)) & 0x1111111111111111) ^
                  (((u64)(c1 >> 64)) & 0x2222222222222222) ^
                  (((u64)(c2 >> 64)) & 0x4444444444444444) ^
-                 (((u64)(c3 >> 64)) & 0x8888888888888888) ^ extra_hi;
+                 (((u64)(c3 >> 64)) & 0x8888888888888888) ^
+                 (e1 >> 63) ^ (e2 >> 62) ^ (e3 >> 61);
+
+       *out_lo = e0 ^ (e1 << 1) ^ (e2 << 2) ^ (e3 << 3);
+#endif
+       *out_lo ^= (((u64)c0) & 0x1111111111111111) ^
+                  (((u64)c1) & 0x2222222222222222) ^
+                  (((u64)c2) & 0x4444444444444444) ^
+                  (((u64)c3) & 0x8888888888888888);
 }

 #else /* CONFIG_ARCH_SUPPORTS_INT128 */
