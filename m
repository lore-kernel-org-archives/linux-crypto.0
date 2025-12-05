Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482CC36CE01
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 18:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764960836; cv=none; b=gVdiE+7gp6uKkS2RB9xPKGxX377QXmTjr53k88d4J/VIkxw4YrjFC/zKuQgD8t4u6MTihakxrotMqitfQaryn3UkA9FMeSUlK6PePB1tV7bvrrqCNfVb4rj6+pB8tuWPaSQa4NtDgMbog/jGcopRsN2H+19E1Wr60grYjirjQe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764960836; c=relaxed/simple;
	bh=Zi2DsiHZrzCgVxEfsob6idXr+B+FV79qwubbH0RP528=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mvDaUEN52qGkVZ5yGQsYLUzNP4d6gP5OE5C3pFTz+uWrfbnqFRBHOjEfUO9MVQUZSTOw7BDK9WO8uhiHmErYvTVKvucuBZwtrCdhyTqtGfFJdDfIrMpbnyZySXj1sizlaEqNIwIX7wHm8+Zgv/pPJqMdzZ6FyIRZ1ewYcpJBkAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CKsb77s2; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CKsb77s2"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29852dafa7dso12665ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Dec 2025 10:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764960833; x=1765565633; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nM4TjJ0lOraXg9eHbppLzESGVggrY73p4QrHQ8UKDGI=;
        b=CKsb77s2X1edLBNONdOJe/dv+o6mcR79M+HnTDKA52oHk/dLkEDjohCP1X3eb93qxI
         cnHamf/MIp9KNbsEHOf/ds74QOnTZwD7vke9SW+bwwoAyPJkzr8g1EAe18B1yadV40ZI
         PC5bHsgUtyjWpz8FCP5kG0ZrASx47Lk++t9zFYJ3c8n6kvmnhkV147oRAPuqAf/154Jc
         udNZJ7UaPKttw/pDnGqknYn7122DgrojP3brWB8JnAtVHrNJbIIyJG2dN8qgsEjgyUeH
         T21SAvj45EjPaGy4/qlu1O53VjINgk4TNbl1KpZa/p+r6Ybhj8B4cQMkFYydGLeWp2Kb
         9luA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764960833; x=1765565633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nM4TjJ0lOraXg9eHbppLzESGVggrY73p4QrHQ8UKDGI=;
        b=XviPRZ13ABwXiH6A0UkVneBkAq9xbc/rURSR8p1dJwWAGyxeF0Iyo35ZZuUFW43D8/
         dNP41Of1JmQxjY+I15J70n9Qtl+wjQzJw0M89znc62KOTIsCm+Cq9BwxySaglb/BcGoB
         sHO5EjxtTfDf1Vkaeqq/1r+omtJw/keyVC1nYrpSD3syWAng7HWP2hMRfz2lu4INGsOT
         5hYJhJZJlmKkvPZi9tWfbCzRcB9PXbO5JukCPbYc0R7KO8jU7OvQLvCOOHj12ifF2e9s
         iWca0tjU5VPE5fMaYqTOZV9p2s5tcFcTWyn7y/1cBrl/uCXlDzHVR7gqVFww61yx/6rG
         E3hQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0Dgmd63i8KrB46loSn6lM0teD1Nr2sHNVysG6EmL+fRKmfkRpcaiYa8tMklgAGUQhpkwfUanirkZIgds=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv3FrcPLbfQKSbpb/JgvIfw6WM+uLdw/WnFNoG8TWVDYy/H0Ln
	kodhDOdbGbRYifgCMIZW+qbiz755zu1dlpZcjmEqVLi+JQCpB2mVNoCRiD3hdUhNKktMQinRktz
	KRWWcskJ600JT6SXMhVYkJ4JuXBCeui/qvaPa5Uef
X-Gm-Gg: ASbGnctaREO9KDxku1IGFGpyt0RnUMZBQMwRw3ouW0OWgSfMykwEMUP9hkwRHfzugI5
	wtghSK1xWjJhf7RPV8Q+cZj+U0IRKDPEpvhvKsrnmiQk08ju8qDJZAUmUbgVPV3nlv5LKFueZdI
	1FNmSMJ2FqeE9oVh9rVMNt0WFHZJ0URY4S94LZEKSyAKHzqbBWkCHpQXptE4zuV5tpl6JQCvyI0
	MnP8DnPjpqu83PO7xvSbuoeh2QE5WQOvYzm1mhA8FRQ5wQAsg0vdHk9MaLEO2/eEKfjM98lc863
	u3DQQuJ4B/NE4PywU/TIX8lkMFRitfqGm1XA
X-Google-Smtp-Source: AGHT+IGaaMXGFhcDd3mV7M4tDglsUcPmwLScnt+H2fKWnH7t8Dfa76w1ht9ihOvDmWB9jRAoi5vJS+qa/YidyNEDII0=
X-Received: by 2002:a17:902:d4cd:b0:295:1351:f63e with SMTP id
 d9443c01a7336-29df4a15923mr126815ad.10.1764960829429; Fri, 05 Dec 2025
 10:53:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205043121.62356-1-ebiggers@kernel.org>
In-Reply-To: <20251205043121.62356-1-ebiggers@kernel.org>
From: Ian Rogers <irogers@google.com>
Date: Fri, 5 Dec 2025 10:53:38 -0800
X-Gm-Features: AWmQ_bmnnXDtf_pkMH3CBh8X-secB3jJUBD6sNmjaTMmzb2gBDoLp0_b5Jn9HCc
Message-ID: <CAP-5=fWaOTh6h-xP5y2SBG7Xe03jG0zTawkrT2kbc-GyhBG_oA@mail.gmail.com>
Subject: Re: [PATCH] perf genelf: Switch from SHA-1 to BLAKE2s for build ID generation
To: Eric Biggers <ebiggers@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Fangrui Song <maskray@sourceware.org>, Pablo Galindo <pablogsal@gmail.com>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 8:35=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> Recent patches [1] [2] added an implementation of SHA-1 to perf and made
> it be used for build ID generation.
>
> I had understood the choice of SHA-1, which is a legacy algorithm, to be
> for backwards compatibility.
>
> It turns out, though, that there's no backwards compatibility
> requirement here other than the size of the build ID field, which is
> fixed at 20 bytes.  Not only did the hash algorithm already change (from
> MD5 to SHA-1), but the inputs to the hash changed too: from
> 'load_addr || code' to just 'code', and now again to
> 'code || symtab || strsym' [3].  Different linkers generate different
> build IDs, with the LLVM linker using BLAKE3 hashes for example [4].
>
> Therefore, we might as well switch to a more modern algorithm.  Let's go
> with BLAKE2s.  It's faster than SHA-1, isn't cryptographically broken,
> is easier to implement than BLAKE3, and the kernel's implementation in
> lib/crypto/blake2s.c is easily borrowed.  It also natively supports
> variable-length hashes, so it can directly produce the needed 20 bytes.
>
> Also make the following additional improvements:
>
> - Provide and use an incremental API, so the three inputs being hashed
>   don't all have to be concatenated into one buffer.
>
> - Add tag/length prefixes to each of the three inputs, so that different
>   tuples of inputs reliably result in different hashes.

Thanks Eric!

> [1] https://lore.kernel.org/linux-perf-users/20250521225307.743726-1-yuzh=
uo@google.com/
> [2] https://lore.kernel.org/linux-perf-users/20250625202311.23244-1-ebigg=
ers@kernel.org/
> [3] https://lore.kernel.org/linux-perf-users/20251125080748.461014-1-namh=
yung@kernel.org/
> [4] https://github.com/llvm/llvm-project/commit/d3e5b6f7539b86995aef6e207=
5c1edb3059385ce
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  tools/perf/tests/util.c   |  78 ++++++++++++--------
>  tools/perf/util/Build     |   2 +-
>  tools/perf/util/blake2s.c | 151 ++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/blake2s.h |  73 ++++++++++++++++++
>  tools/perf/util/genelf.c  |  58 +++++++--------
>  tools/perf/util/sha1.c    |  97 ------------------------
>  tools/perf/util/sha1.h    |   6 --
>  7 files changed, 302 insertions(+), 163 deletions(-)
>  create mode 100644 tools/perf/util/blake2s.c
>  create mode 100644 tools/perf/util/blake2s.h
>  delete mode 100644 tools/perf/util/sha1.c
>  delete mode 100644 tools/perf/util/sha1.h
>
> diff --git a/tools/perf/tests/util.c b/tools/perf/tests/util.c
> index b273d287e164..695e061f0fa7 100644
> --- a/tools/perf/tests/util.c
> +++ b/tools/perf/tests/util.c
> @@ -1,9 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include "tests.h"
> +#include "util/blake2s.h"
>  #include "util/debug.h"
> -#include "util/sha1.h"
>
>  #include <linux/compiler.h>
>  #include <stdlib.h>
>  #include <string2.h>
>
> @@ -15,49 +15,69 @@ static int test_strreplace(char needle, const char *h=
aystack,
>
>         free(new);
>         return ret =3D=3D 0;
>  }
>
> -#define MAX_LEN 512
> +#define MAX_DATA_LEN 512 /* Maximum tested data length */
> +#define HASH_LEN 20 /* Hash length to test */
>
> -/* Test sha1() for all lengths from 0 to MAX_LEN inclusively. */
> -static int test_sha1(void)
> +/* Test the implementation of the BLAKE2s hash algorithm. */
> +static int test_blake2s(void)
>  {
> -       u8 data[MAX_LEN];
> -       size_t digests_size =3D (MAX_LEN + 1) * SHA1_DIGEST_SIZE;
> -       u8 *digests;
> -       u8 digest_of_digests[SHA1_DIGEST_SIZE];
> +       u8 data[MAX_DATA_LEN];
> +       u8 hash[HASH_LEN];
> +       u8 hash2[HASH_LEN];
> +       struct blake2s_ctx main_ctx;
>         /*
> -        * The correctness of this value was verified by running this tes=
t with
> -        * sha1() replaced by OpenSSL's SHA1().
> +        * This value was generated by the following Python code:
> +        *
> +        * import hashlib
> +        *
> +        * data =3D bytes(i % 256 for i in range(513))
> +        * h =3D hashlib.blake2s(digest_size=3D20)
> +        * for i in range(513):
> +        *     h.update(hashlib.blake2s(data=3Ddata[:i], digest_size=3D20=
).digest())
> +        * print(h.hexdigest())
>          */
> -       static const u8 expected_digest_of_digests[SHA1_DIGEST_SIZE] =3D =
{
> -               0x74, 0xcd, 0x4c, 0xb9, 0xd8, 0xa6, 0xd5, 0x95, 0x22, 0x8=
b,
> -               0x7e, 0xd6, 0x8b, 0x7e, 0x46, 0x95, 0x31, 0x9b, 0xa2, 0x4=
3,
> +       static const u8 expected_hash_of_hashes[20] =3D {
> +               0xef, 0x9b, 0x13, 0x98, 0x78, 0x8e, 0x74, 0x59, 0x9c, 0xd=
5,
> +               0x0c, 0xf0, 0x33, 0x97, 0x79, 0x3d, 0x3e, 0xd0, 0x95, 0xa=
6
>         };
>         size_t i;
>
> -       digests =3D malloc(digests_size);
> -       TEST_ASSERT_VAL("failed to allocate digests", digests !=3D NULL);
> -
> -       /* Generate MAX_LEN bytes of data. */
> -       for (i =3D 0; i < MAX_LEN; i++)
> +       /* Generate MAX_DATA_LEN bytes of data. */
> +       for (i =3D 0; i < MAX_DATA_LEN; i++)
>                 data[i] =3D i;
>
> -       /* Calculate a SHA-1 for each length 0 through MAX_LEN inclusivel=
y. */
> -       for (i =3D 0; i <=3D MAX_LEN; i++)
> -               sha1(data, i, &digests[i * SHA1_DIGEST_SIZE]);
> +       blake2s_init(&main_ctx, sizeof(hash));
> +       for (i =3D 0; i <=3D MAX_DATA_LEN; i++) {
> +               struct blake2s_ctx ctx;
> +
> +               /* Compute the BLAKE2s hash of 'i' data bytes. */
> +               blake2s_init(&ctx, HASH_LEN);
> +               blake2s_update(&ctx, data, i);
> +               blake2s_final(&ctx, hash);
>
> -       /* Calculate digest of all digests calculated above. */
> -       sha1(digests, digests_size, digest_of_digests);
> +               /* Verify that multiple updates produce the same result. =
*/
> +               blake2s_init(&ctx, HASH_LEN);
> +               blake2s_update(&ctx, data, i / 2);
> +               blake2s_update(&ctx, &data[i / 2], i - (i / 2));
> +               blake2s_final(&ctx, hash2);
> +               TEST_ASSERT_VAL("inconsistent BLAKE2s hashes",
> +                               memcmp(hash, hash2, HASH_LEN) =3D=3D 0);
>
> -       free(digests);
> +               /*
> +                * Pass the hash to another BLAKE2s context, so that we
> +                * incrementally compute the hash of all the hashes.
> +                */
> +               blake2s_update(&main_ctx, hash, HASH_LEN);
> +       }
>
> -       /* Check for the expected result. */
> -       TEST_ASSERT_VAL("wrong output from sha1()",
> -                       memcmp(digest_of_digests, expected_digest_of_dige=
sts,
> -                              SHA1_DIGEST_SIZE) =3D=3D 0);
> +       /* Verify the hash of all the hashes. */
> +       blake2s_final(&main_ctx, hash);
> +       TEST_ASSERT_VAL("wrong BLAKE2s hashes",
> +                       memcmp(hash, expected_hash_of_hashes, HASH_LEN) =
=3D=3D 0);
>         return 0;
>  }
>
>  static int test__util(struct test_suite *t __maybe_unused, int subtest _=
_maybe_unused)
>  {
> @@ -66,9 +86,9 @@ static int test__util(struct test_suite *t __maybe_unus=
ed, int subtest __maybe_u
>         TEST_ASSERT_VAL("replace 1", test_strreplace('3', "123", "4", "12=
4"));
>         TEST_ASSERT_VAL("replace 2", test_strreplace('a', "abcabc", "ef",=
 "efbcefbc"));
>         TEST_ASSERT_VAL("replace long", test_strreplace('a', "abcabc", "l=
onglong",
>                                                         "longlongbclonglo=
ngbc"));
>
> -       return test_sha1();
> +       return test_blake2s();
>  }
>
>  DEFINE_SUITE("util", util);
> diff --git a/tools/perf/util/Build b/tools/perf/util/Build
> index 1c2a43e1dc68..2a9f3d015c1d 100644
> --- a/tools/perf/util/Build
> +++ b/tools/perf/util/Build
> @@ -3,10 +3,11 @@ include $(srctree)/tools/scripts/utilities.mak
>
>  perf-util-y +=3D arm64-frame-pointer-unwind-support.o
>  perf-util-y +=3D addr2line.o
>  perf-util-y +=3D addr_location.o
>  perf-util-y +=3D annotate.o
> +perf-util-y +=3D blake2s.o
>  perf-util-y +=3D block-info.o
>  perf-util-y +=3D block-range.o
>  perf-util-y +=3D build-id.o
>  perf-util-y +=3D cacheline.o
>  perf-util-y +=3D capstone.o
> @@ -41,11 +42,10 @@ perf-util-y +=3D rlimit.o
>  perf-util-y +=3D argv_split.o
>  perf-util-y +=3D rbtree.o
>  perf-util-y +=3D libstring.o
>  perf-util-y +=3D bitmap.o
>  perf-util-y +=3D hweight.o
> -perf-util-y +=3D sha1.o
>  perf-util-y +=3D smt.o
>  perf-util-y +=3D strbuf.o
>  perf-util-y +=3D string.o
>  perf-util-y +=3D strlist.o
>  perf-util-y +=3D strfilter.o
> diff --git a/tools/perf/util/blake2s.c b/tools/perf/util/blake2s.c
> new file mode 100644
> index 000000000000..ce5d89a19376
> --- /dev/null
> +++ b/tools/perf/util/blake2s.c
> @@ -0,0 +1,151 @@
> +// SPDX-License-Identifier: GPL-2.0 OR MIT
> +/*
> + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rig=
hts Reserved.
> + *
> + * This is an implementation of the BLAKE2s hash and PRF functions.
> + *
> + * Information: https://blake2.net/
> + */
> +
> +#include "blake2s.h"
> +#include <linux/kernel.h>
> +
> +static inline u32 ror32(u32 v, int n)
> +{
> +       return (v >> n) | (v << (32 - n));
> +}
> +
> +static inline void le32_to_cpu_array(u32 a[], size_t n)
> +{
> +       for (size_t i =3D 0; i < n; i++)
> +               a[i] =3D le32_to_cpu((__force __le32)a[i]);
> +}
> +
> +static inline void cpu_to_le32_array(u32 a[], size_t n)
> +{
> +       for (size_t i =3D 0; i < n; i++)
> +               a[i] =3D (__force u32)cpu_to_le32(a[i]);
> +}
> +
> +static const u8 blake2s_sigma[10][16] =3D {
> +       { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
> +       { 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
> +       { 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 },
> +       { 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 },
> +       { 9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13 },
> +       { 2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9 },
> +       { 12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11 },
> +       { 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10 },
> +       { 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5 },
> +       { 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0 },
> +};
> +
> +static inline void blake2s_increment_counter(struct blake2s_ctx *ctx, u3=
2 inc)
> +{
> +       ctx->t[0] +=3D inc;
> +       ctx->t[1] +=3D (ctx->t[0] < inc);
> +}
> +
> +static void blake2s_compress(struct blake2s_ctx *ctx,
> +                            const u8 *data, size_t nblocks, u32 inc)
> +{
> +       u32 m[16];
> +       u32 v[16];
> +       int i;
> +
> +       while (nblocks > 0) {
> +               blake2s_increment_counter(ctx, inc);
> +               memcpy(m, data, BLAKE2S_BLOCK_SIZE);
> +               le32_to_cpu_array(m, ARRAY_SIZE(m));
> +               memcpy(v, ctx->h, 32);
> +               v[ 8] =3D BLAKE2S_IV0;
> +               v[ 9] =3D BLAKE2S_IV1;
> +               v[10] =3D BLAKE2S_IV2;
> +               v[11] =3D BLAKE2S_IV3;
> +               v[12] =3D BLAKE2S_IV4 ^ ctx->t[0];
> +               v[13] =3D BLAKE2S_IV5 ^ ctx->t[1];
> +               v[14] =3D BLAKE2S_IV6 ^ ctx->f[0];
> +               v[15] =3D BLAKE2S_IV7 ^ ctx->f[1];
> +
> +#define G(r, i, a, b, c, d) do { \
> +       a +=3D b + m[blake2s_sigma[r][2 * i + 0]]; \
> +       d =3D ror32(d ^ a, 16); \
> +       c +=3D d; \
> +       b =3D ror32(b ^ c, 12); \
> +       a +=3D b + m[blake2s_sigma[r][2 * i + 1]]; \
> +       d =3D ror32(d ^ a, 8); \
> +       c +=3D d; \
> +       b =3D ror32(b ^ c, 7); \
> +} while (0)
> +
> +#define ROUND(r) do { \
> +       G(r, 0, v[0], v[ 4], v[ 8], v[12]); \
> +       G(r, 1, v[1], v[ 5], v[ 9], v[13]); \
> +       G(r, 2, v[2], v[ 6], v[10], v[14]); \
> +       G(r, 3, v[3], v[ 7], v[11], v[15]); \
> +       G(r, 4, v[0], v[ 5], v[10], v[15]); \
> +       G(r, 5, v[1], v[ 6], v[11], v[12]); \
> +       G(r, 6, v[2], v[ 7], v[ 8], v[13]); \
> +       G(r, 7, v[3], v[ 4], v[ 9], v[14]); \
> +} while (0)
> +               ROUND(0);
> +               ROUND(1);
> +               ROUND(2);
> +               ROUND(3);
> +               ROUND(4);
> +               ROUND(5);
> +               ROUND(6);
> +               ROUND(7);
> +               ROUND(8);
> +               ROUND(9);
> +
> +#undef G
> +#undef ROUND
> +
> +               for (i =3D 0; i < 8; ++i)
> +                       ctx->h[i] ^=3D v[i] ^ v[i + 8];
> +
> +               data +=3D BLAKE2S_BLOCK_SIZE;
> +               --nblocks;
> +       }
> +}
> +
> +static inline void blake2s_set_lastblock(struct blake2s_ctx *ctx)
> +{
> +       ctx->f[0] =3D -1;
> +}
> +
> +void blake2s_update(struct blake2s_ctx *ctx, const u8 *in, size_t inlen)
> +{
> +       const size_t fill =3D BLAKE2S_BLOCK_SIZE - ctx->buflen;
> +
> +       if (unlikely(!inlen))
> +               return;
> +       if (inlen > fill) {
> +               memcpy(ctx->buf + ctx->buflen, in, fill);
> +               blake2s_compress(ctx, ctx->buf, 1, BLAKE2S_BLOCK_SIZE);
> +               ctx->buflen =3D 0;
> +               in +=3D fill;
> +               inlen -=3D fill;
> +       }
> +       if (inlen > BLAKE2S_BLOCK_SIZE) {
> +               const size_t nblocks =3D DIV_ROUND_UP(inlen, BLAKE2S_BLOC=
K_SIZE);
> +
> +               blake2s_compress(ctx, in, nblocks - 1, BLAKE2S_BLOCK_SIZE=
);
> +               in +=3D BLAKE2S_BLOCK_SIZE * (nblocks - 1);
> +               inlen -=3D BLAKE2S_BLOCK_SIZE * (nblocks - 1);
> +       }
> +       memcpy(ctx->buf + ctx->buflen, in, inlen);
> +       ctx->buflen +=3D inlen;
> +}
> +
> +void blake2s_final(struct blake2s_ctx *ctx, u8 *out)
> +{
> +       blake2s_set_lastblock(ctx);
> +       memset(ctx->buf + ctx->buflen, 0,
> +              BLAKE2S_BLOCK_SIZE - ctx->buflen); /* Padding */
> +       blake2s_compress(ctx, ctx->buf, 1, ctx->buflen);
> +       cpu_to_le32_array(ctx->h, ARRAY_SIZE(ctx->h));
> +       memcpy(out, ctx->h, ctx->outlen);
> +       memset(ctx, 0, sizeof(*ctx));
> +}
> diff --git a/tools/perf/util/blake2s.h b/tools/perf/util/blake2s.h
> new file mode 100644
> index 000000000000..a1fe81a4bea8
> --- /dev/null
> +++ b/tools/perf/util/blake2s.h
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/*
> + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rig=
hts Reserved.
> + */
> +
> +#ifndef _CRYPTO_BLAKE2S_H
> +#define _CRYPTO_BLAKE2S_H
> +
> +#include <string.h>
> +#include <linux/types.h>
> +
> +#define BLAKE2S_BLOCK_SIZE 64
> +
> +struct blake2s_ctx {
> +       u32 h[8];
> +       u32 t[2];
> +       u32 f[2];
> +       u8 buf[BLAKE2S_BLOCK_SIZE];
> +       unsigned int buflen;
> +       unsigned int outlen;
> +};
> +
> +enum blake2s_iv {
> +       BLAKE2S_IV0 =3D 0x6A09E667UL,
> +       BLAKE2S_IV1 =3D 0xBB67AE85UL,
> +       BLAKE2S_IV2 =3D 0x3C6EF372UL,
> +       BLAKE2S_IV3 =3D 0xA54FF53AUL,
> +       BLAKE2S_IV4 =3D 0x510E527FUL,
> +       BLAKE2S_IV5 =3D 0x9B05688CUL,
> +       BLAKE2S_IV6 =3D 0x1F83D9ABUL,
> +       BLAKE2S_IV7 =3D 0x5BE0CD19UL,
> +};
> +
> +static inline void __blake2s_init(struct blake2s_ctx *ctx, size_t outlen=
,
> +                                 const void *key, size_t keylen)
> +{
> +       ctx->h[0] =3D BLAKE2S_IV0 ^ (0x01010000 | keylen << 8 | outlen);
> +       ctx->h[1] =3D BLAKE2S_IV1;
> +       ctx->h[2] =3D BLAKE2S_IV2;
> +       ctx->h[3] =3D BLAKE2S_IV3;
> +       ctx->h[4] =3D BLAKE2S_IV4;
> +       ctx->h[5] =3D BLAKE2S_IV5;
> +       ctx->h[6] =3D BLAKE2S_IV6;
> +       ctx->h[7] =3D BLAKE2S_IV7;
> +       ctx->t[0] =3D 0;
> +       ctx->t[1] =3D 0;
> +       ctx->f[0] =3D 0;
> +       ctx->f[1] =3D 0;
> +       ctx->buflen =3D 0;
> +       ctx->outlen =3D outlen;
> +       if (keylen) {
> +               memcpy(ctx->buf, key, keylen);
> +               memset(&ctx->buf[keylen], 0, BLAKE2S_BLOCK_SIZE - keylen)=
;
> +               ctx->buflen =3D BLAKE2S_BLOCK_SIZE;
> +       }
> +}
> +
> +static inline void blake2s_init(struct blake2s_ctx *ctx, size_t outlen)
> +{
> +       __blake2s_init(ctx, outlen, NULL, 0);
> +}
> +
> +static inline void blake2s_init_key(struct blake2s_ctx *ctx, size_t outl=
en,
> +                                   const void *key, size_t keylen)
> +{
> +       __blake2s_init(ctx, outlen, key, keylen);
> +}
> +
> +void blake2s_update(struct blake2s_ctx *ctx, const u8 *in, size_t inlen)=
;
> +
> +void blake2s_final(struct blake2s_ctx *ctx, u8 *out);
> +
> +#endif /* _CRYPTO_BLAKE2S_H */
> diff --git a/tools/perf/util/genelf.c b/tools/perf/util/genelf.c
> index a1cd5196f4ec..505fefdc60f3 100644
> --- a/tools/perf/util/genelf.c
> +++ b/tools/perf/util/genelf.c
> @@ -16,12 +16,12 @@
>  #include <err.h>
>  #ifdef HAVE_LIBDW_SUPPORT
>  #include <dwarf.h>
>  #endif
>
> +#include "blake2s.h"
>  #include "genelf.h"
> -#include "sha1.h"
>  #include "../util/jitdump.h"
>  #include <linux/compiler.h>
>
>  #ifndef NT_GNU_BUILD_ID
>  #define NT_GNU_BUILD_ID 3
> @@ -49,11 +49,11 @@ static char shd_string_table[] =3D {
>  };
>
>  static struct buildid_note {
>         Elf_Note desc;          /* descsz: size of build-id, must be mult=
iple of 4 */
>         char     name[4];       /* GNU\0 */
> -       u8       build_id[SHA1_DIGEST_SIZE];
> +       u8       build_id[20];

nit: Could we add a comment on where the value of 20 is coming from?
We could use something like: sizeof(((struct
perf_record_header_build_id*)0)->data). But a comment is enough imo.

Tested-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

>  } bnote;
>
>  static Elf_Sym symtab[]=3D{
>         /* symbol 0 MUST be the undefined symbol */
>         { .st_name  =3D 0, /* index in sym_string table */
> @@ -150,13 +150,32 @@ jit_add_eh_frame_info(Elf *e, void* unwinding, uint=
64_t unwinding_header_size,
>         shdr->sh_entsize =3D 0;
>
>         return 0;
>  }
>
> +enum {
> +       TAG_CODE =3D 0,
> +       TAG_SYMTAB =3D 1,
> +       TAG_STRSYM =3D 2,
> +};
> +
> +/*
> + * Update the hash using the given data, also prepending a (tag, len) pr=
efix to
> + * ensure that different input tuples result in different outputs.
> + */
> +static void blake2s_update_tagged(struct blake2s_ctx *ctx, int tag,
> +                                 const void *data, size_t len)
> +{
> +       u64 prefix =3D ((u64)tag << 56) | len;
> +
> +       blake2s_update(ctx, (const u8 *)&prefix, sizeof(prefix));
> +       blake2s_update(ctx, data, len);
> +}
> +
>  /*
>   * fd: file descriptor open for writing for the output file
> - * load_addr: code load address (could be zero, just used for buildid)
> + * load_addr: code load address (could be zero)
>   * sym: function name (for native code - used as the symbol)
>   * code: the native code
>   * csize: the code size in bytes
>   */
>  int
> @@ -171,12 +190,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_un=
used, const char *sym,
>         Elf_Ehdr *ehdr;
>         Elf_Phdr *phdr;
>         Elf_Shdr *shdr;
>         uint64_t eh_frame_base_offset;
>         char *strsym =3D NULL;
> -       void *build_id_data =3D NULL, *tmp;
> -       int build_id_data_len;
> +       struct blake2s_ctx ctx;
>         int symlen;
>         int retval =3D -1;
>
>         if (elf_version(EV_CURRENT) =3D=3D EV_NONE) {
>                 warnx("ELF initialization failed");
> @@ -251,17 +269,12 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_un=
used, const char *sym,
>         shdr->sh_type =3D SHT_PROGBITS;
>         shdr->sh_addr =3D GEN_ELF_TEXT_OFFSET;
>         shdr->sh_flags =3D SHF_EXECINSTR | SHF_ALLOC;
>         shdr->sh_entsize =3D 0;
>
> -       build_id_data =3D malloc(csize);
> -       if (build_id_data =3D=3D NULL) {
> -               warnx("cannot allocate build-id data");
> -               goto error;
> -       }
> -       memcpy(build_id_data, code, csize);
> -       build_id_data_len =3D csize;
> +       blake2s_init(&ctx, sizeof(bnote.build_id));
> +       blake2s_update_tagged(&ctx, TAG_CODE, code, csize);
>
>         /*
>          * Setup .eh_frame_hdr and .eh_frame
>          */
>         if (unwinding) {
> @@ -342,18 +355,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_un=
used, const char *sym,
>         shdr->sh_type =3D SHT_SYMTAB;
>         shdr->sh_flags =3D 0;
>         shdr->sh_entsize =3D sizeof(Elf_Sym);
>         shdr->sh_link =3D unwinding ? 6 : 4; /* index of .strtab section =
*/
>
> -       tmp =3D realloc(build_id_data, build_id_data_len + sizeof(symtab)=
);
> -       if (tmp =3D=3D NULL) {
> -               warnx("cannot allocate build-id data");
> -               goto error;
> -       }
> -       memcpy(tmp + build_id_data_len, symtab, sizeof(symtab));
> -       build_id_data =3D tmp;
> -       build_id_data_len +=3D sizeof(symtab);
> +       blake2s_update_tagged(&ctx, TAG_SYMTAB, symtab, sizeof(symtab));
>
>         /*
>          * setup symbols string table
>          * 2 =3D 1 for 0 in 1st entry, 1 for the 0 at end of symbol for 2=
nd entry
>          */
> @@ -393,18 +399,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_un=
used, const char *sym,
>         shdr->sh_name =3D 25; /* offset in shd_string_table */
>         shdr->sh_type =3D SHT_STRTAB;
>         shdr->sh_flags =3D 0;
>         shdr->sh_entsize =3D 0;
>
> -       tmp =3D realloc(build_id_data, build_id_data_len + symlen);
> -       if (tmp =3D=3D NULL) {
> -               warnx("cannot allocate build-id data");
> -               goto error;
> -       }
> -       memcpy(tmp + build_id_data_len, strsym, symlen);
> -       build_id_data =3D tmp;
> -       build_id_data_len +=3D symlen;
> +       blake2s_update_tagged(&ctx, TAG_STRSYM, strsym, symlen);
>
>         /*
>          * setup build-id section
>          */
>         scn =3D elf_newscn(e);
> @@ -420,11 +419,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_un=
used, const char *sym,
>         }
>
>         /*
>          * build-id generation
>          */
> -       sha1(build_id_data, build_id_data_len, bnote.build_id);
> +       blake2s_final(&ctx, bnote.build_id);
>         bnote.desc.namesz =3D sizeof(bnote.name); /* must include 0 termi=
nation */
>         bnote.desc.descsz =3D sizeof(bnote.build_id);
>         bnote.desc.type   =3D NT_GNU_BUILD_ID;
>         strcpy(bnote.name, "GNU");
>
> @@ -465,9 +464,8 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unus=
ed, const char *sym,
>         retval =3D 0;
>  error:
>         (void)elf_end(e);
>
>         free(strsym);
> -       free(build_id_data);
>
>         return retval;
>  }
> diff --git a/tools/perf/util/sha1.c b/tools/perf/util/sha1.c
> deleted file mode 100644
> index 7032fa4ff3fd..000000000000
> --- a/tools/perf/util/sha1.c
> +++ /dev/null
> @@ -1,97 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-only
> -/*
> - * SHA-1 message digest algorithm
> - *
> - * Copyright 2025 Google LLC
> - */
> -#include <linux/bitops.h>
> -#include <linux/kernel.h>
> -#include <linux/unaligned.h>
> -#include <string.h>
> -
> -#include "sha1.h"
> -
> -#define SHA1_BLOCK_SIZE 64
> -
> -static const u32 sha1_K[4] =3D { 0x5A827999, 0x6ED9EBA1, 0x8F1BBCDC, 0xC=
A62C1D6 };
> -
> -#define SHA1_ROUND(i, a, b, c, d, e)                                    =
      \
> -       do {                                                             =
     \
> -               if ((i) >=3D 16)                                         =
       \
> -                       w[i] =3D rol32(w[(i) - 16] ^ w[(i) - 14] ^ w[(i) =
- 8] ^ \
> -                                            w[(i) - 3],                 =
     \
> -                                    1);                                 =
     \
> -               e +=3D w[i] + rol32(a, 5) + sha1_K[(i) / 20];            =
       \
> -               if ((i) < 20)                                            =
     \
> -                       e +=3D (b & (c ^ d)) ^ d;                        =
       \
> -               else if ((i) < 40 || (i) >=3D 60)                        =
       \
> -                       e +=3D b ^ c ^ d;                                =
       \
> -               else                                                     =
     \
> -                       e +=3D (c & d) ^ (b & (c ^ d));                  =
       \
> -               b =3D rol32(b, 30);                                      =
       \
> -               /* The new (a, b, c, d, e) is the old (e, a, b, c, d). */=
     \
> -       } while (0)
> -
> -#define SHA1_5ROUNDS(i)                             \
> -       do {                                        \
> -               SHA1_ROUND((i) + 0, a, b, c, d, e); \
> -               SHA1_ROUND((i) + 1, e, a, b, c, d); \
> -               SHA1_ROUND((i) + 2, d, e, a, b, c); \
> -               SHA1_ROUND((i) + 3, c, d, e, a, b); \
> -               SHA1_ROUND((i) + 4, b, c, d, e, a); \
> -       } while (0)
> -
> -#define SHA1_20ROUNDS(i)                \
> -       do {                            \
> -               SHA1_5ROUNDS((i) + 0);  \
> -               SHA1_5ROUNDS((i) + 5);  \
> -               SHA1_5ROUNDS((i) + 10); \
> -               SHA1_5ROUNDS((i) + 15); \
> -       } while (0)
> -
> -static void sha1_blocks(u32 h[5], const u8 *data, size_t nblocks)
> -{
> -       while (nblocks--) {
> -               u32 a =3D h[0];
> -               u32 b =3D h[1];
> -               u32 c =3D h[2];
> -               u32 d =3D h[3];
> -               u32 e =3D h[4];
> -               u32 w[80];
> -
> -               for (int i =3D 0; i < 16; i++)
> -                       w[i] =3D get_unaligned_be32(&data[i * 4]);
> -               SHA1_20ROUNDS(0);
> -               SHA1_20ROUNDS(20);
> -               SHA1_20ROUNDS(40);
> -               SHA1_20ROUNDS(60);
> -
> -               h[0] +=3D a;
> -               h[1] +=3D b;
> -               h[2] +=3D c;
> -               h[3] +=3D d;
> -               h[4] +=3D e;
> -               data +=3D SHA1_BLOCK_SIZE;
> -       }
> -}
> -
> -/* Calculate the SHA-1 message digest of the given data. */
> -void sha1(const void *data, size_t len, u8 out[SHA1_DIGEST_SIZE])
> -{
> -       u32 h[5] =3D { 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476,
> -                    0xC3D2E1F0 };
> -       u8 final_data[2 * SHA1_BLOCK_SIZE] =3D { 0 };
> -       size_t final_len =3D len % SHA1_BLOCK_SIZE;
> -
> -       sha1_blocks(h, data, len / SHA1_BLOCK_SIZE);
> -
> -       memcpy(final_data, data + len - final_len, final_len);
> -       final_data[final_len] =3D 0x80;
> -       final_len =3D round_up(final_len + 9, SHA1_BLOCK_SIZE);
> -       put_unaligned_be64((u64)len * 8, &final_data[final_len - 8]);
> -
> -       sha1_blocks(h, final_data, final_len / SHA1_BLOCK_SIZE);
> -
> -       for (int i =3D 0; i < 5; i++)
> -               put_unaligned_be32(h[i], &out[i * 4]);
> -}
> diff --git a/tools/perf/util/sha1.h b/tools/perf/util/sha1.h
> deleted file mode 100644
> index e92c9966e1d5..000000000000
> --- a/tools/perf/util/sha1.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-only */
> -#include <linux/types.h>
> -
> -#define SHA1_DIGEST_SIZE 20
> -
> -void sha1(const void *data, size_t len, u8 out[SHA1_DIGEST_SIZE]);
>
> base-commit: bc04acf4aeca588496124a6cf54bfce3db327039
> --
> 2.52.0
>
