Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C951EA65
	for <linux-crypto@vger.kernel.org>; Sun, 20 Jul 2025 09:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753002628; cv=none; b=dgo0Bl4zpIhuIklQH1uVF6+FrxpTqH3GOkWNhd/kOVw3DqQvL0VEj2zK1xOPxFYJ2qMH6c6Wq+kJLLCBaz0s1p4vfNem9/2oQU0m0eMTk1CQkFWm6y8V40anI27okl+UE7SvY9fdEL/Xa+jeqnHjp9qSHVVSHwUciCNDcRNt1Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753002628; c=relaxed/simple;
	bh=ei0Eh047+wSJThQEsyFcTd1qFGA0tlIkADv3TCDhntA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rVyh2qkaUd7isqzaD9CzygjD/KvnCSATcP3v1eUbDDwFvIbgmA6TEO+kYTQbdHVTcvlQZVu5mtSgBkXgiEwJekyubCP5Y+sOPVQGM9ySzWPDeHNlFgrons3lBWCyKTLPAEynJdYnOp33ughqggWZeXm2Xj3x1+L7C8LqF8bXR1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jf2zq1n1; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jf2zq1n1"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-32b5931037eso25856921fa.2
        for <linux-crypto@vger.kernel.org>; Sun, 20 Jul 2025 02:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753002625; x=1753607425; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N0ftmC07bPJUHX/2kEDOcXbA7qHmCdGf8ARIf1w4s7g=;
        b=Jf2zq1n125Zq3vKNQrwtOlv7GVDWsEas0SpvjzEN1cSzjWdawB6NuFvCAst6QAt489
         gAKrpAivDGBfgK/lWzTNbjZGXVMHrHAhW2idv4oup+mAhxY6YCN6GQd9RHv6ESgF1uVY
         5PCxFZ7lV2qgDaGzg8LcIb8iaOjp0nv4klUwamsMvRCGKrWzZlApPWTtIURrAM7NF+op
         2n6m2migJ+FclnVFBlYQsLUut4HtyV+wg2UDFeFuARE8a3x5v99zbpcErou1jdWz2FbZ
         PPBvJUjDGZl6n7Zk5bK7m3pLmf+vBM7tMDNpbzX20sKu9Fr5EbWQgnqWy6lAj5ZBcndB
         NqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753002625; x=1753607425;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N0ftmC07bPJUHX/2kEDOcXbA7qHmCdGf8ARIf1w4s7g=;
        b=OYTqmoFDM5+i+RyhVN82dXe82g20INQBhydvpvfPP1mUSppWBz4Fgs1h9ZPWRRMc6J
         YqKkSU5t7FByAwHyQwKCziGhOexWXxHjcWNbJdch4+TZWMjdy+qpbKwI397525Gy64Px
         9IfQ+e1kyQA9gZJiwAhskOnZj9z/lIf8WPiW3nUMk3Ape7Dgg74ECicKwAUaM3gkqSOj
         lVddvV7g9DQeAo8G2ind0qV5dSztMWo4NwtLadcMq3J4Y5avExOfhL0jgJxJ5Br8YdSi
         4+RZb2VykkFlNCDlLl0thpTjEKc6I2UCTER+xFIm3FbCDBO/ooZWOMN1LmpGr+WdFej7
         pYbA==
X-Forwarded-Encrypted: i=1; AJvYcCVMrASieUIcmLLdF8uq9OioavjHZ6g9y2yI+SX97K/LyFX0Nio7yBLW+IteykqrRHd2xd94Tk2VVBG9gtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YypKGib8IzbWf05BISL99bGO4kwvrrskrvAOSkylLXlaigf2nPk
	n7ozoZ0/e0ICA1vUXFgnOO2glt1kfi/NjqzNXjAKeWBhwwWdE0gV8N5tMghjE/7LvUMP/GwP8G8
	p+TWVv8QC0EWWG0YogWpi7voLy9N/oCk=
X-Gm-Gg: ASbGncsHXe3sDlOg9tWEjSN6hZQrnWglimSibb1n3tSyL5ijOY5z+QUwAzWVyegDvm9
	Tue4e3xYEs4+Nj/BMf+Rs6Eei9ZYijUmpaCWIdZtLlai20jE6YjqlWJ2C4Lg95ytZyn79r8YN3J
	bGq9N1oOqy3z5fbYy7aHlykJmxg8Fn5GjKeqQe9kvE80U7kcds+TF9g1HbGGOukPn8RDrn8Om6V
	4+phQ==
X-Google-Smtp-Source: AGHT+IE5xxEtscj8W8X3uqNEj4QG9qJNtLWSFq770DqhyUeRlqJ6lVyN1byWziP7D7DbO8NLTjOth80sHUD6ftGLYmU=
X-Received: by 2002:a05:651c:2105:b0:32a:66e6:9ffe with SMTP id
 38308e7fff4ca-3308e546bcfmr55243641fa.21.1753002624524; Sun, 20 Jul 2025
 02:10:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Date: Sun, 20 Jul 2025 17:10:13 +0800
X-Gm-Features: Ac12FXzZ8rJlzdWF1XPFH0ohGBsLc_3zNJMrBV1GZXcoS4313sbwM3QBjyvjyPY
Message-ID: <CACGDn=Rn079JhB7dwqbC-3GNiydJs=dGEXtcw+cC8z2Yjp2Qbg@mail.gmail.com>
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS implementation
To: Eric Biggers <ebiggers@kernel.org>
Cc: alex@ghiti.fr, appro@cryptogams.org, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org, 
	paul.walmsley@sifive.com, zhang.lyra@gmail.com, 
	Zhihang Shao <zhihang.shao.iscas@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

I recently ran a test using the Kunit module you wrote for testing
poly1305, which I executed on QEMU RISC-V 64, . The results show a
significant performance improvement of the optimized implementation
compared to the generic one. The test data are as follows:

--- base.log    2025-07-19 17:41:06.443392989 +0800
+++ optimized.log       2025-07-19 17:40:45.650048601 +0800
@@ -1,31 +1,31 @@
-[    0.668631]     # Subtest: poly1305
-[    0.668774]     # module: poly1305_kunit
-[    0.668857]     1..12
-[    0.670267]     ok 1 test_hash_test_vectors
-[    0.679479]     ok 2 test_hash_all_lens_up_to_4096
-[    0.696048]     ok 3 test_hash_incremental_updates
-[    0.697645]     ok 4 test_hash_buffer_overruns
-[    0.701060]     ok 5 test_hash_overlaps
-[    0.702858]     ok 6 test_hash_alignment_consistency
-[    0.703108]     ok 7 test_hash_ctx_zeroization
-[    0.846150]     ok 8 test_hash_interrupt_context_1
-[    1.235247]     ok 9 test_hash_interrupt_context_2
-[    1.250813]     ok 10 test_poly1305_allones_keys_and_message
-[    1.251138]     ok 11 test_poly1305_reduction_edge_cases
-[    1.287196]     # benchmark_hash: len=1: 2 MB/s
-[    1.305363]     # benchmark_hash: len=16: 61 MB/s
-[    1.321102]     # benchmark_hash: len=64: 212 MB/s
-[    1.340105]     # benchmark_hash: len=127: 263 MB/s
-[    1.353880]     # benchmark_hash: len=128: 364 MB/s
-[    1.370118]     # benchmark_hash: len=200: 377 MB/s
-[    1.381879]     # benchmark_hash: len=256: 570 MB/s
-[    1.394125]     # benchmark_hash: len=511: 657 MB/s
-[    1.404265]     # benchmark_hash: len=512: 794 MB/s
-[    1.413356]     # benchmark_hash: len=1024: 985 MB/s
-[    1.421925]     # benchmark_hash: len=3173: 1131 MB/s
-[    1.429956]     # benchmark_hash: len=4096: 1218 MB/s
-[    1.438184]     # benchmark_hash: len=16384: 1216 MB/s
-[    1.438462]     ok 12 benchmark_hash
-[    1.438686] # poly1305: pass:12 fail:0 skip:0 total:12
-[    1.438763] # Totals: pass:12 fail:0 skip:0 total:12
-[    1.438904] ok 1 poly1305
+[    0.666280]     # Subtest: poly1305
+[    0.666413]     # module: poly1305_kunit
+[    0.666490]     1..12
+[    0.667702]     ok 1 test_hash_test_vectors
+[    0.672896]     ok 2 test_hash_all_lens_up_to_4096
+[    0.686244]     ok 3 test_hash_incremental_updates
+[    0.687263]     ok 4 test_hash_buffer_overruns
+[    0.689957]     ok 5 test_hash_overlaps
+[    0.691393]     ok 6 test_hash_alignment_consistency
+[    0.691622]     ok 7 test_hash_ctx_zeroization
+[    0.769741]     ok 8 test_hash_interrupt_context_1
+[    0.930832]     ok 9 test_hash_interrupt_context_2
+[    0.940068]     ok 10 test_poly1305_allones_keys_and_message
+[    0.940478]     ok 11 test_poly1305_reduction_edge_cases
+[    0.964546]     # benchmark_hash: len=1: 3 MB/s
+[    0.978836]     # benchmark_hash: len=16: 78 MB/s
+[    0.990414]     # benchmark_hash: len=64: 289 MB/s
+[    1.003012]     # benchmark_hash: len=127: 397 MB/s
+[    1.012755]     # benchmark_hash: len=128: 517 MB/s
+[    1.022928]     # benchmark_hash: len=200: 603 MB/s
+[    1.030981]     # benchmark_hash: len=256: 835 MB/s
+[    1.038706]     # benchmark_hash: len=511: 1046 MB/s
+[    1.045233]     # benchmark_hash: len=512: 1240 MB/s
+[    1.050733]     # benchmark_hash: len=1024: 1638 MB/s
+[    1.055620]     # benchmark_hash: len=3173: 1998 MB/s
+[    1.060247]     # benchmark_hash: len=4096: 2132 MB/s
+[    1.064695]     # benchmark_hash: len=16384: 2267 MB/s
+[    1.065179]     ok 12 benchmark_hash
+[    1.065425] # poly1305: pass:12 fail:0 skip:0 total:12
+[    1.065498] # Totals: pass:12 fail:0 skip:0 total:12
+[    1.065612] ok 1 poly1305

Next, I plan to validate this performance gain on actual RISC-V
hardware. I will also submit a v5 patch to the mailing list.
Look forward to your feedback and suggestions.

- Zhihang
