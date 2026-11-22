Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795314066;
	b=bxJZYEofw/hn1AAwfYxshvWGRwhkS7azLxU7qTTZ67wfMVMVLgs8Py5QfiauHEaiZAus
	 +ifLFchENvjcodHqX7zEzUWyD/DMF/hzveWPUwhtWNEW1JR/jBZPw1+Yw6rLbW8DwRwp/
	 Tz/TO3YO2kJqBBSbixqcgqvZu0Z/vixxN+KzV+63XEjIMobUpGi5meZ6JEzBvXZpPGvF+
	 Puhw16etvXv085z0TbRBjAHFRVwNAmgoVteBdNbFkfEUcEmj8lVTqmbFs+MnSQrKEGI/U
	 jobRqqBUXUQc98SvUz4kdZ/uX8+Om1BcI+FrAlhOJnLIFIFLr6AsGsIHvNaBCcRU8QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795314066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dmITdC7D63ctVyeLjY9YNyhcnBwccogTjE8pz3EsUxk=;
	b=3ufludnvDFMlXZvDd3WgNTTCcPZq1dAPrJVL+slSdurNaZJeeA2YoUJ2OBQRF0EAeFJD
	 ynWrQlCRdRHd68NDfxx34RI3dP/dkjF0/fY0cD75UDYceOiByss2IEEaafpiOvhJlNohO
	 S0MirajVpdHPEVkSLs6boOpmDI7QOh9tR9mS4Ki2a0+DRxzosUGyR8ABWm/Nhm+O4Tj+N
	 rJh6iz2Eexd9edO4smH2SedH0S0jyBzHjTa8pbrl8yi0f+ZJ0iIWfKF83MFJc70mkQGXQ
	 2Je+WvJBuTIbpDHh+DUg059Ew6NrHGr4QdOjehNdE7FnhCIildQBGc5jSXCiePSU5Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J+M+lHwP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58652606A320
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 02:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J+M+lHwP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB38D1F000C0;
	Sun, 22 Nov 2026 02:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795314065;
	bh=dmITdC7D63ctVyeLjY9YNyhcnBwccogTjE8pz3EsUxk=;
	h=From:To:Cc:Subject:Date;
	b=J+M+lHwPYkRMtVoRe97yd9Qu9w7vJuN9PZOUY6HPE9pzbTtJ4s4IT9T0eNbSVyKqP
	 kcAlraYDb744FLNaW5/EG55UE0mSMfmgYXuCACBNL+qev+qlS0QLzKmh8cq6PiwAdu
	 28/oxbjOtTnb1wpISTWlH7VOdVgKECXWIw12tloBa7EiyTfE0nc0S9fbFmgXZ6BJyM
	 sd5QdKk18JfW1FTVfNRVoD2MZmjzXYIe7iHRhXXv2JdUlZGSjTSf/HiFLhxN86ZVBS
	 TmnMHX9nsPvJnGMwgBuOPD/oU5a+TWORKCr3fquni1PwFuTSWELFEH9kattB5mfcSf
	 OicIjzYmzkGdw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/8] lib/crypto: De-bloat and optimize sha512-ssse3-asm.S
Date: Sat, 21 Nov 2026 18:20:22 -0800
Message-ID: <20261122022030.296468-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series reduces the text size of sha512-ssse3-asm.o by over 10 KB,
eliminates an excessively large stack frame that wasn't being zeroized,
and implements various additional optimizations.  Many of these
optimizations were already being used in other code such as
sha512-avx2-asm.o; this older file was just never updated properly.

I don't have access to an x86_64 CPU that lacks AVX2 support, but
running this code on a more recent CPU shows a 30% increase in SHA-512
throughput.  Since the benefit of the 'shld' hack in sha512-avx-asm.S on
Sandy Bridge was allegedly 20%, it's plausible that this more than
closes the gap after the removal of that file.  But even if it doesn't,
it should be a worthwhile cleanup, especially because of the text and
stack size reductions and increased consistency with other files.

Patch 1 is an updated version of
https://lore.kernel.org/linux-crypto/20261112082839.414786-3-ebiggers@kernel.org/

Eric Biggers (8):
  lib/crypto: x86/sha512: Partially roll up sha512_transform_ssse3()
  lib/crypto: x86/sha512: Keep message schedule in XMM registers
  lib/crypto: x86/sha512: Keep W[t]+K[t] in %xmm5 instead of stack
  lib/crypto: x86/sha512: Keep XMM_QWORD_BSWAP in %xmm14 across blocks
  lib/crypto: x86/sha512: Use pshufb for ror64(x, 8) in SSSE3 s0
  lib/crypto: x86/sha512: Keep state in registers across blocks in SSSE3
  lib/crypto: x86/sha512: Shorten critical-path additions in SSSE3
  lib/crypto: x86/sha512: Use local labels for data

 lib/crypto/x86/sha512-ssse3-asm.S | 298 ++++++++++++++++++------------
 1 file changed, 175 insertions(+), 123 deletions(-)


base-commit: 909ef7a9a30fa139e69e555e3606680f5cca7726
-- 
2.56.1

