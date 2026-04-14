Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11077389E07
	for <linux-crypto@vger.kernel.org>; Tue, 14 Apr 2026 22:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776204907; cv=none; b=U2FizanLAL8s1vuEwpvuaktCp4PfdnqSUXAXXPwIdC/P/l8T2fOdXcAkLIzHUefQ48UY5mzPCpwk/I4eV7Gx2oJJEjYZkGZ0BJ7EdvkMU/KV1NCkHQh99UBqjt0Km7ekS3wiR6GOXtWjLpl8uKEmL6DcRTuhSrt/hQTaTzu4RyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776204907; c=relaxed/simple;
	bh=UZW2AHoIhNhn+yCefOAfuBYpbKa6HnpLM9+FljlMqQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZrZ3LourbcrzyzsoMfGrl0SZh9t/goFQ3w9cJaezhEzi0wgCXd0WeOd5C+XBsbvqIRNPgSN1O3xU4XBnxVUXkeZ616dw0kOAQ3lmXJFZTIdrcQVW/7iovWN1ZmYV0hrWeFYiEFqPMQtjAZakeFWnlsjVv/cTejA5koacF6ukL5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id 8401F10605;
	Wed, 15 Apr 2026 00:14:55 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 7B4F6602E52E; Wed, 15 Apr 2026 00:14:55 +0200 (CEST)
Date: Wed, 15 Apr 2026 00:14:55 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jason Donenfeld <jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Tadeusz Struk <tstruk@gigaio.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/mpi - Fix integer underflow in
 mpi_read_raw_from_sgl()
Message-ID: <ad68X6BveJXqynUk@wunner.de>
References: <59eca92ff4f87e2081777f1423a0efaaadcfdb39.1776003111.git.lukas@wunner.de>
 <20260414175903.GC24456@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414175903.GC24456@quark>

On Tue, Apr 14, 2026 at 10:59:03AM -0700, Eric Biggers wrote:
> On Sun, Apr 12, 2026 at 04:19:47PM +0200, Lukas Wunner wrote:
> > Yiming reports an integer underflow in mpi_read_raw_from_sgl() when
> > subtracting "lzeros" from the unsigned "nbytes".
[...]
> 
> This code (which has no tests...) is unnecessarily hard to understand,
> though.  I haven't been able to fully understand the logic yet, but it
> looks like it still has bugs, including still reading past the given
> nbytes.  It should be possible to replace it with something simpler and
> less error-prone.

mpi_read_raw_from_sgl() skips over leading zero bytes in the scatterlist
and then over leading zero bits in the first non-zero byte, before it
starts copying data to the newly-allocated MPI.

One possible simplification is to use memchr_inv() to search for the
first non-zero byte, instead of open coding it.  See the patch below.
If you think it's a step in the right direction, I can submit the patch
in the next cycle.

-- >8 --

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index cb001aa..72e7ac7 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -17,6 +17,7 @@
 #include "sg_sw_sec4.h"
 #include "caampkc.h"
 #include <crypto/internal/engine.h>
+#include <linux/count_zeros.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
@@ -219,12 +220,9 @@ static int caam_rsa_count_leading_zeros(struct scatterlist *sgl,
 	lzeros = 0;
 	len = 0;
 	while (nbytes > 0) {
-		/* do not strip more than given bytes */
-		while (len && !*buff && lzeros < nbytes) {
-			lzeros++;
-			len--;
-			buff++;
-		}
+		lzeros = count_leading_zerobytes(buff, min(len, nbytes));
+		len -= lzeros;
+		buff += lzeros;
 
 		if (len && *buff)
 			break;
diff --git a/include/linux/count_zeros.h b/include/linux/count_zeros.h
index 5b8ff5a..29d9d67 100644
--- a/include/linux/count_zeros.h
+++ b/include/linux/count_zeros.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_BITOPS_COUNT_ZEROS_H_
 #define _LINUX_BITOPS_COUNT_ZEROS_H_
 
+#include <linux/string.h>
 #include <asm/bitops.h>
 
 /**
@@ -50,4 +51,14 @@ static inline int count_trailing_zeros(unsigned long x)
 		return (x != 0) ? __ffs(x) : COUNT_TRAILING_ZEROS_0;
 }
 
+static inline size_t count_leading_zerobytes(const void *start, size_t len)
+{
+	void *first = memchr_inv(start, 0, len);
+
+	if (!first)
+		return len;
+
+	return first - start;
+}
+
 #endif /* _LINUX_BITOPS_COUNT_ZEROS_H_ */
diff --git a/lib/crypto/mpi/mpicoder.c b/lib/crypto/mpi/mpicoder.c
index 9359a58..011434d 100644
--- a/lib/crypto/mpi/mpicoder.c
+++ b/lib/crypto/mpi/mpicoder.c
@@ -347,11 +347,9 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 	lzeros = 0;
 	len = 0;
 	while (nbytes > 0) {
-		while (len && !*buff && lzeros < nbytes) {
-			lzeros++;
-			len--;
-			buff++;
-		}
+		lzeros = count_leading_zerobytes(buff, min(len, nbytes));
+		len -= lzeros;
+		buff += lzeros;
 
 		if (len && *buff)
 			break;

