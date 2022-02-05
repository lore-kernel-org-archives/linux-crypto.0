Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE32C433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 07:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379629AbiBEH6z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Feb 2022 02:58:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35282 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiBEH6x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Feb 2022 02:58:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB356B83984
        for <linux-crypto@vger.kernel.org>; Sat,  5 Feb 2022 07:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A414C340E8;
        Sat,  5 Feb 2022 07:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644047931;
        bh=YZmFFgPW6SIr+eOB+Y0P4RXURvMW/ETUxHG5SNWROPg=;
        h=From:To:Cc:Subject:Date:From;
        b=eUMEpe1kO5gZXkyalBWfheL12nn8CH3o3YAL16Oz+tBqKZO6QE3UyU9voWhGKrAHv
         8RVJc8pB00QdsYQrhEOV9XMqTAw5e2w0A9nl4Jxxpb8+gEE8y5IG40p3Yjs4F7F9D5
         iz6m4otei2ZX9yWYcqfAhTO3cJM9Xxp2G0O1dnht8RED3yk1Zu6fWJ7GM6s1vmSP8r
         U0wCWCUx174Hv+Q/PSHjQAuqv98Vg7CSDSTBYs/FV6zK9ZpZfmbSkkEza3PMeATf83
         OWDAPRjBjX44lJtHVMN/Kz6Mn/w9/WGMJpKRUL0rM7wwruApTlYaBo2gmtdp0EXvEg
         Z/m2xKLQ0rOvg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v3 0/2] xor: enable auto-vectorization in Clang
Date:   Sat,  5 Feb 2022 08:58:35 +0100
Message-Id: <20220205075837.153418-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1918; h=from:subject; bh=YZmFFgPW6SIr+eOB+Y0P4RXURvMW/ETUxHG5SNWROPg=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh/i4q3MHqWyeqUdXeErHvSrrClAZzMtnFm4u08mJJ ODwmIWWJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYf4uKgAKCRDDTyI5ktmPJKWfC/ 9yUC5Ln4w+LAVAnphHIjfHr8MzYFU0hnKHdkKhOqU29ljw85ygbIq90aWgPn4mGi+MYsO+/M3jyWj1 cnQhiUK3AnRemKH7qFQy1T4nrKjNqMqj6HtoThAU0aIVfuN72QQbpmPSqYmAB21f8mDGTbm8cS2l8l jOPMzmtJMza4CxI68NFy0Y7WznHAT5/V11SCKVL/C2yroCyUP65uMEH8NeijGVnDlSNBf12uSygT7p 6e5hPv8XfGotHwZF8RR7Z/VQp1brvA9IMpEk8wAC7AE4y5w2tyf0CgVsgwkXUNnSDPcTTUmkghlPJX ELx5kp+dRkFku+6NWz60ZlT3AWZgmX91AAfoFL190KLH/qHoX5xLZKAKQl9gydrbegF/6XCGB9oSr2 xETe/4LGg7RImTUTZ5OhjxDg+ZFPpOiSAKjB2h2hg+JZqiPFKJYki7MwaRtfkoS6wV+ZywpnyGWQyp dfYGtCOwz2RVhijB6BS0M2PZlYf5N2+MY/BLeO/+vxNDo=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update the xor_blocks() prototypes so that the compiler understands that
the inputs always refer to distinct regions of memory. This is implied
by the existing implementations, as they use different granularities for
the load/xor/store loops.

With that, we can fix the ARM/Clang version, which refuses to SIMD
vectorize otherwise, and throws a spurious warning related to the GCC
version being incompatible.

Changes since v2:
- fix arm64 build after rebase
- name PPC argument names consistently
- add Nick's acks and link tags

Changes since v1:
- fix PPC build
- add Nathan's Tested-by

Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>

Ard Biesheuvel (2):
  lib/xor: make xor prototypes more friendely to compiler vectorization
  crypto: arm/xor - make vectorized C code Clang-friendly

 arch/alpha/include/asm/xor.h           | 53 ++++++++----
 arch/arm/include/asm/xor.h             | 42 ++++++----
 arch/arm/lib/xor-neon.c                | 12 +--
 arch/arm64/include/asm/xor.h           | 21 +++--
 arch/arm64/lib/xor-neon.c              | 46 +++++++----
 arch/ia64/include/asm/xor.h            | 21 +++--
 arch/powerpc/include/asm/xor_altivec.h | 25 +++---
 arch/powerpc/lib/xor_vmx.c             | 28 ++++---
 arch/powerpc/lib/xor_vmx.h             | 27 ++++---
 arch/powerpc/lib/xor_vmx_glue.c        | 32 ++++----
 arch/s390/lib/xor.c                    | 21 +++--
 arch/sparc/include/asm/xor_32.h        | 21 +++--
 arch/sparc/include/asm/xor_64.h        | 42 ++++++----
 arch/x86/include/asm/xor.h             | 42 ++++++----
 arch/x86/include/asm/xor_32.h          | 42 ++++++----
 arch/x86/include/asm/xor_avx.h         | 21 +++--
 include/asm-generic/xor.h              | 84 +++++++++++++-------
 include/linux/raid/xor.h               | 21 +++--
 18 files changed, 384 insertions(+), 217 deletions(-)

-- 
2.30.2

