Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC91324B20;
	Thu, 15 Jan 2026 20:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768509815; cv=none; b=g8dk1PeCKFefZDisUSnvqlzg9jBFuM/TN0/kegBtVy5fvTl/JG/g6qGUa0yKWqtDk9NR16OdKtYABSBXPa0dG3bUYNbchMDRukuna4BkkUhOc5GqBWJPVFbX+SOfA5ZC1rjTKI5V57eKwiWPrIKks1jU1aHEcDVry/AIAtOiNsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768509815; c=relaxed/simple;
	bh=T0yUpiuw/OkVmyA4WNYjG9h+/8JmhVkUSiHo3GgotZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c5RGXPfRssUxOzcTY3tCI6z8fURhs1yQubcFQ5dPiVLWtiv0nr1x4/BcY6KJVSneao0MMAtqq/xlu18HPKleouQXOwv3IlEGprWNoPTKVT7HQQ13IyaUOgjEgiRUb4WvyB1NpBohOp7TjIVXG09jGnWYoWjfbgTJUcA8whsJi4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OzzoKjS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OzzoKjS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310C0C16AAE;
	Thu, 15 Jan 2026 20:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768509814;
	bh=T0yUpiuw/OkVmyA4WNYjG9h+/8JmhVkUSiHo3GgotZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OzzoKjS1ihnv+kzjilUrTiO5sU/pDTc9ns/k6uNfJ5eFU2CRaMEbKmDiJy/uSH9js
	 iJnoU+wA6BVFxJ71veKXeJeCjNpJJtRUjMa4iwQMPzaskOYVsueCfoufL9J12sZxoh
	 tbtc82vlpQ1A0N8zl+cYJ+l/Oonm7r7L6RAVErgirJgpTo+9f9j2NiLMZA4yhUEjKs
	 chQu2i43ggKTNWI58JhbblkiEautSJMnbMmrYNBpfmRIbZ0gX4DFeUuGO4YGStWRsK
	 eOr5Ko3agjS/DjtqyqoV0AR4+IGW+NTA05W19YD8S4yJC/din0OjcRiEHwHT8xQUII
	 gX9S/fFZbGF/A==
Date: Thu, 15 Jan 2026 12:43:32 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <20260115204332.GA3138@quark>
References: <20260115183831.72010-1-dengler@linux.ibm.com>
 <20260115183831.72010-2-dengler@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115183831.72010-2-dengler@linux.ibm.com>

On Thu, Jan 15, 2026 at 07:38:31PM +0100, Holger Dengler wrote:
> Add a KUnit test suite for AES library functions, including KAT and
> benchmarks.
> 
> Signed-off-by: Holger Dengler <dengler@linux.ibm.com>

The cover letter had some more information.  Could you put it in the
commit message directly?  Normally cover letters aren't used for a
single patch: the explanation should just be in the patch itself.

> diff --git a/lib/crypto/tests/aes-testvecs.h b/lib/crypto/tests/aes-testvecs.h
> new file mode 100644
> index 000000000000..dfa528db7f02
> --- /dev/null
> +++ b/lib/crypto/tests/aes-testvecs.h
> @@ -0,0 +1,78 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _AES_TESTVECS_H
> +#define _AES_TESTVECS_H
> +
> +#include <crypto/aes.h>
> +
> +struct buf {
> +	size_t blen;
> +	u8 b[];
> +};

'struct buf' is never used.

> +static const struct aes_testvector aes128_kat = {

Where do these test vectors come from?  All test vectors should have a
documented source.

> +static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
> +{
> +	const size_t num_iters = 10000000;

10000000 iterations is too many.  That's 160 MB of data in each
direction per AES key length.  Some CPUs without AES instructions can do
only ~20 MB AES per second.  In that case, this benchmark would take 16
seconds to run per AES key length, for 48 seconds total.

hash-test-template.h and crc_kunit.c use 10000000 / (len + 128)
iterations.  That would be 69444 in this case (considering len=16),
which is less than 1% of the iterations you've used.  Choosing a number
similar to that would seem more appropriate.

Ultimately these are just made-up numbers.  But I think we should aim
for the benchmark test in each KUnit test suite to take less than a
second or so.  The existing tests roughly achieve that, whereas it seems
this one can go over it by quite a bit due to the 10000000 iterations.

> +	kunit_info(test, "enc (iter. %zu, duration %lluns)",
> +		   num_iters, t_enc);
> +	kunit_info(test, "enc (len=%zu): %llu MB/s",
> +		   (size_t)AES_BLOCK_SIZE,
> +		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NSEC_PER_SEC,
> +			     (t_enc ?: 1) * SZ_1M));
> +
> +	kunit_info(test, "dec (iter. %zu, duration %lluns)",
> +		   num_iters, t_dec);
> +	kunit_info(test, "dec (len=%zu): %llu MB/s",
> +		   (size_t)AES_BLOCK_SIZE,
> +		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NSEC_PER_SEC,
> +			     (t_dec ?: 1) * SZ_1M));

Maybe delete the first line of each pair, and switch from power-of-2
megabytes to power-of-10?  That would be consistent with how the other
crypto and CRC benchmarks print their output.

> +MODULE_DESCRIPTION("KUnit tests and benchmark aes library");

"aes library" => "for the AES library"

- Eric
