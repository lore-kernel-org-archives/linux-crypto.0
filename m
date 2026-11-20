Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138212;
	b=tzdnPeK7jVcgiYYX0SJtIqZC98KR2e71XJpr1m7eP6UU/SX2QglkiF0uizBl2QaYrtlw
	 6ZSj7xHxlxk3x9R+vT0dKeuugleO14wSVROwSpBSwFBko7kqCYCZKl6jhK1UPfSM7BvD2
	 IyOjS2O5X7WX2kqVA8N8jFXEJkqX2BIIAUJjzG7+psDzobkaR+kKZL/fvnnMuxe2BP1DJ
	 uVlu28HvbU1qxr9ld3y85YFMOEh9ssNlQ3jcxtba4QHhxo9DA+mvzretyVJGJV06p9f7X
	 DcPbSMsW0gnpL9Tw0lQ+tyrC4S3h1elTGkFqJTdoFXb83aCv9oj6cY6SMcg6oQNZrow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138212;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9ImONX/OJLk7ZVEjl1GC16IN6OyX9Pq+3BH0fPw1GE8=;
	b=13FfDZdFWgPtzCZSvgh8Gty+RdCMz29ByN9FJsaT5Q81uD65UvuuMeS96H8vGrDR3ioj
	 7YZVQ31CkpFgnarcEfHXkauE6czl84I/uRVYbZjAnG6FNDm0pi/1IIUlJ+nT+nwiPIE3m
	 1egiBgbCFS/CZnvVjriRqGzjfBtcWM1eygKVMWmMB6aa+E0v+dL6JTONNHEVzp73wqTx1
	 h4Q1H4AUAVAlJox4kJaU4rsrTFLN/quVcTTOnIkOuuK3VgxQNCPKZEEa5CHWslCJNHvgg
	 5su8WVtSbeuD5YPwg++nW9nA0fafVZ+ZRuwmIm3UoHiIu7UBPIoc6ULC4eHSAXRuQ1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X87qlv5o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF56606A331
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 01:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X87qlv5o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF8F1F000C4;
	Fri, 20 Nov 2026 01:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138212;
	bh=9ImONX/OJLk7ZVEjl1GC16IN6OyX9Pq+3BH0fPw1GE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X87qlv5obpqY9SUX4Ep20A6feTb2q/tu9xFeGTCxgskG++L+cYQ3LyNbrYa6zLKK7
	 ToCsMSmbT44QrpqoFSfvPyyW1l1uJBYDuJvaWboy++8+3LrBXyCX4g3Cl3OeOWMANi
	 H/P5mk3QXcjCbaWjdMxdIMb4HtlA1UaRKP7sPjDvFSfKf3G+4G9W30luXLMV93iaZX
	 Q28LYAEw7sIFUNnQEbC3uEz5SQL0IUBQmznv4XmeYw1at9KgLlJlfrxo81fBce9pkL
	 AtR48LFgud9m2mGnRmieCRCQVkZJDER8hUSiOZtGMBQmLygGyzzW0LorGbkkGWXnXE
	 sQaPtKy3j9W/Q==
Message-ID: <sashiko-outbox-224307@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 3/6] lib/crc: x86: Convert crc32_lsb_*() from
 assembly to C
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qu Wenruo" <wqu@suse.com>, linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, ardb@kernel.org, dsterba@suse.cz
In-Reply-To: <f5577a87c45cd4b5ef4fa8ace3b0a05c3f9fddd3.1795137348.git.wqu@suse.com>
References: <cover.1795137348.git.wqu@suse.com>
 <f5577a87c45cd4b5ef4fa8ace3b0a05c3f9fddd3.1795137348.git.wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:30:11 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] lib/crc: x86: build failure in fold256() on GCC 8.1 and 8.2
--

commit 4e73f2c859c18b715ef71e051a7e40e392c143ab
Author: Qu Wenruo <wqu@suse.com>

lib/crc: x86: Convert crc32_lsb_*() from assembly to C

This commit rewrites the x86 PCLMULQDQ and VPCLMULQDQ crc32_lsb functions
from assembly to C using compiler intrinsics.

> diff --git a/lib/crc/x86/crc-pclmul-helpers.h b/lib/crc/x86/crc-pclmul-he=
lpers.h
> new file mode 100644
> index 0000000000000..c4bac60220f32
> --- /dev/null
> +++ b/lib/crc/x86/crc-pclmul-helpers.h
> @@ -0,0 +1,72 @@
[ ... ]
> +/* The ISA extensions needed for each vector length */
> +#define CRC_TARGET_128	"sse4.1,pclmul"
> +#define CRC_TARGET_256	"sse4.1,pclmul,avx2,vpclmulqdq"
> +#define CRC_TARGET_512	"sse4.1,pclmul,avx2,vpclmulqdq,avx512f,avx512bw,a=
vx512vl"
> +
> +/* The target attributes of the helpers, to keep their signatures short =
*/
> +#define __crc128	__attribute__((target(CRC_TARGET_128)))
> +#define __crc256	__attribute__((target(CRC_TARGET_256)))
> +#define __crc512	__attribute__((target(CRC_TARGET_512)))
[ ... ]
> +static __always_inline __crc256 __m256i fold256(__m256i acc, __m256i dat=
a, __m256i k)
> +{
> +	__m256i lo =3D _mm256_clmulepi64_epi128(acc, k, 0x00);
> +	__m256i hi =3D _mm256_clmulepi64_epi128(acc, k, 0x11);
> +
> +	return _mm256_xor_si256(_mm256_xor_si256(hi, data), lo);
> +}

[Severity: Medium]
Does fold256() break x86 builds with CONFIG_CRC32_ARCH=3Dy on GCC 8.1 and
8.2?

As noted in the commit message, GCC 8.1 and 8.2 declare
_mm256_clmulepi64_epi128() under #pragma GCC target("vpclmulqdq,avx512vl"),
which fails to inline into fold256() because CRC_TARGET_256 omits avx512vl.
Since scripts/min-tool-version.sh still declares 8.1.0 as the minimum
supported GCC version, fold256() needs a workaround for GCC < 8.3 (such as
calling __builtin_ia32_vpclmulqdq_v4di directly) unless the minimum GCC
version is raised first.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795137348.gi=
t.wqu@suse.com?part=3D3
