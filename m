Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9478224AFD;
	Thu,  6 Feb 2025 07:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738827623; cv=none; b=uVqGeBO6NaD2j5cRpMVr/2s55RxENwQansMRte+RckjsauKsEpML4WsHex2USS7LJNa3RrC42jh+74DL3BSf4DiPGeAJrZUAn6/neGM7GEGrd5pVtYcxghbNVE+Bnqhb1ghKyspTcyGZh/sOT9OYt4Al9fgV4Ci/6BjRZQTVeIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738827623; c=relaxed/simple;
	bh=wwX8EZ5h9xqBya8Fa+uHTbcyQ/ii7FO1vvnLIAmWWHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8leBpLt194fX6LC//Fr4YNeAiOslya3xYKEPI0Ol5eWBPwPuOND0PyUPnPm1ql/FK+uoJjyjQi1arS2Asl0V7KNbe2BTy+csizRSHJm9Cry/jzbaHjQ8rg2UYACxWPhj8ENTk1Itp77D7PUD5mFmK0ZG1kibV/UxxEn7JgMGGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JuJ25szY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JuJ25szY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF50C4CEE7;
	Thu,  6 Feb 2025 07:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738827623;
	bh=wwX8EZ5h9xqBya8Fa+uHTbcyQ/ii7FO1vvnLIAmWWHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuJ25szYu2S6Im7zriWTZwqxrnP4gR+ZzdrHI2rLQUgqG0yJmmGcidhu1kfSoD9ma
	 f2u1BRjr+7Gy1eP1GCYPJcvmyxfAs2mL9wvR2doufLgm9bCvWhIvEIZdS6WbF0CSHl
	 BJDdHwDC8b8Qa1hOnQa1chwph8I6Ic2tCFe2n4NY6koRLA0ZBVtBahC5bNqJ9JICQg
	 j85Yljk/3trVJcUQ0J7AHMS0EOBXWN/f0VrgPJSHuvwBg5sY48/hy8+yCXuG53eDNs
	 dhQhpFH8mFzIDpvidvo0+LJtDkUu3HQ6C7spfZ9EmJ55D1PBtBSAFaa5bLlfZLVqTy
	 WxS/XFqjIY6EA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 2/6] scripts/gen-crc-consts: add gen-crc-consts.py
Date: Wed,  5 Feb 2025 23:39:44 -0800
Message-ID: <20250206073948.181792-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250206073948.181792-1-ebiggers@kernel.org>
References: <20250206073948.181792-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add a Python script that generates constants for computing the given CRC
variant(s) using x86's pclmulqdq or vpclmulqdq instructions.

This is specifically tuned for x86's crc-pclmul-template.S.  However,
other architectures with a 64x64 => 128-bit carryless multiplication
instruction should be able to use the generated constants too.  (Some
tweaks may be warranted based on the exact instructions available on
each arch, so the script may grow an arch argument in the future.)

The script also supports generating the tables needed for table-based
CRC computation.  Thus, it can also be used to reproduce the tables like
t10_dif_crc_table[] and crc16_table[] that are currently hardcoded in
the source with no generation script explicitly documented.

Python is used rather than C since it enables implementing the CRC math
in the simplest way possible, using arbitrary precision integers.  The
outputs of this script are intended to be checked into the repo, so
Python will continue to not be required to build the kernel, and the
script has been optimized for simplicity rather than performance.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS               |   1 +
 scripts/gen-crc-consts.py | 239 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 240 insertions(+)
 create mode 100755 scripts/gen-crc-consts.py

diff --git a/MAINTAINERS b/MAINTAINERS
index 896a307fa0654..3532167f31939 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6130,10 +6130,11 @@ S:	Maintained
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-next
 F:	Documentation/staging/crc*
 F:	arch/*/lib/crc*
 F:	include/linux/crc*
 F:	lib/crc*
+F:	scripts/gen-crc-consts.py
 
 CREATIVE SB0540
 M:	Bastien Nocera <hadess@hadess.net>
 L:	linux-input@vger.kernel.org
 S:	Maintained
diff --git a/scripts/gen-crc-consts.py b/scripts/gen-crc-consts.py
new file mode 100755
index 0000000000000..608714ba451eb
--- /dev/null
+++ b/scripts/gen-crc-consts.py
@@ -0,0 +1,239 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Script that generates constants for computing the given CRC variant(s).
+#
+# Copyright 2025 Google LLC
+#
+# Author: Eric Biggers <ebiggers@google.com>
+
+import sys
+
+# XOR (add) an iterable of polynomials.
+def xor(iterable):
+    res = 0
+    for val in iterable:
+        res ^= val
+    return res
+
+# Multiply two polynomials.
+def clmul(a, b):
+    return xor(a << i for i in range(b.bit_length()) if (b & (1 << i)) != 0)
+
+# Polynomial division floor(a / b).
+def div(a, b):
+    q = 0
+    while a.bit_length() >= b.bit_length():
+        q ^= 1 << (a.bit_length() - b.bit_length())
+        a ^= b << (a.bit_length() - b.bit_length())
+    return q
+
+# Reduce the polynomial 'a' modulo the polynomial 'b'.
+def reduce(a, b):
+    return a ^ clmul(div(a, b), b)
+
+# Pretty-print a polynomial.
+def pprint_poly(prefix, poly):
+    terms = [f'x^{i}' for i in reversed(range(poly.bit_length()))
+             if (poly & (1 << i)) != 0]
+    j = 0
+    while j < len(terms):
+        s = prefix + terms[j] + (' +' if j < len(terms) - 1 else '')
+        j += 1
+        while j < len(terms) and len(s) < 73:
+            s += ' ' + terms[j] + (' +' if j < len(terms) - 1 else '')
+            j += 1
+        print(s)
+        prefix = ' * ' + (' ' * (len(prefix) - 3))
+
+# Reverse the bits of a polynomial.
+def bitreverse(poly, num_bits):
+    assert poly.bit_length() <= num_bits
+    return xor(1 << (num_bits - 1 - i) for i in range(num_bits)
+               if (poly & (1 << i)) != 0)
+
+# Format a polynomial as hex.  Bit-reflect it if the CRC is lsb-first.
+def fmt_poly(variant, poly, num_bits):
+    if variant.lsb:
+        poly = bitreverse(poly, num_bits)
+    return f'0x{poly:0{2*num_bits//8}x}'
+
+# Print a pair of 64-bit polynomial multipliers.  They are always passed in the
+# order [HI64_TERMS, LO64_TERMS] but will be printed in the appropriate order.
+def print_mult_pair(variant, mults):
+    mults = list(mults if variant.lsb else reversed(mults))
+    terms = ["HI64_TERMS", "LO64_TERMS"] if variant.lsb else ["LO64_TERMS", "HI64_TERMS"]
+    for i in range(2):
+        print(f'\t\t{fmt_poly(variant, mults[i]["val"], 64)},\t/* {terms[i]}: {mults[i]["desc"]} */')
+
+# Print a comment describing constants generated for the given CRC variant.
+def print_header(variant, what):
+    print('/*')
+    s = f'{"least" if variant.lsb else "most"}-significant-bit-first CRC-{variant.bits}'
+    print(f' * {what} generated for {s} using')
+    pprint_poly(' * G(x) = ', variant.G)
+    print(' */')
+
+class CrcVariant:
+    def __init__(self, bits, generator_poly, bit_order):
+        self.bits = bits
+        if bit_order not in ['lsb', 'msb']:
+            raise ValueError('Invalid value for bit_order')
+        self.lsb = bit_order == 'lsb'
+        self.name = f'crc{bits}_{bit_order}_0x{generator_poly:0{(2*bits+7)//8}x}'
+        if self.lsb:
+            generator_poly = bitreverse(generator_poly, bits)
+        self.G = generator_poly ^ (1 << bits)
+
+# Generate tables for CRC computation using the "slice-by-N" method.
+# N=1 corresponds to the traditional byte-at-a-time table.
+def gen_slicebyN_tables(variants, n):
+    for v in variants:
+        print('')
+        print_header(v, f'Slice-by-{n} CRC table')
+        print(f'static const u{v.bits} __maybe_unused {v.name}_table[{256*n}] = {{')
+        s = ''
+        for i in range(256 * n):
+            # The i'th table entry is the CRC of the message consisting of byte
+            # i % 256 followed by i // 256 zero bytes.
+            poly = (bitreverse(i % 256, 8) if v.lsb else (i % 256)) << (v.bits + 8*(i//256))
+            next_entry = fmt_poly(v, reduce(poly, v.G), v.bits) + ','
+            if len(s + next_entry) > 71:
+                print(f'\t{s}')
+                s = ''
+            s += (' ' if s else '') + next_entry
+        if s:
+            print(f'\t{s}')
+        print('};')
+
+# Generate constants for carryless multiplication based CRC computation.
+def gen_x86_pclmul_consts(variants):
+    # These are the distances, in bits, to generate folding constants for.
+    FOLD_DISTANCES = [2048, 1024, 512, 256, 128]
+
+    for v in variants:
+        (G, n, lsb) = (v.G, v.bits, v.lsb)
+        print('')
+        print_header(v, 'CRC folding constants')
+        print('static const struct {')
+        if not lsb:
+            print('\tu8 bswap_mask[16];')
+        for i in FOLD_DISTANCES:
+            print(f'\tu64 fold_across_{i}_bits_consts[2];')
+        print('\tu8 shuf_table[48];')
+        print('\tu64 barrett_reduction_consts[2];')
+        print(f'}} {v.name}_consts ____cacheline_aligned __maybe_unused = {{')
+
+        # Byte-reflection mask, needed for msb-first CRCs
+        if not lsb:
+            print('\t.bswap_mask = {' + ', '.join(str(i) for i in reversed(range(16))) + '},')
+
+        # Fold constants for all distances down to 128 bits
+        for i in FOLD_DISTANCES:
+            print(f'\t.fold_across_{i}_bits_consts = {{')
+            # Given 64x64 => 128 bit carryless multiplication instructions, two
+            # 64-bit fold constants are needed per "fold distance" i: one for
+            # HI64_TERMS that is basically x^(i+64) mod G and one for LO64_TERMS
+            # that is basically x^i mod G.  The exact values however undergo a
+            # couple adjustments, described below.
+            mults = []
+            for j in [64, 0]:
+                pow_of_x = i + j
+                if lsb:
+                    # Each 64x64 => 128 bit carryless multiplication instruction
+                    # actually generates a 127-bit product in physical bits 0
+                    # through 126, which in the lsb-first case represent the
+                    # coefficients of x^1 through x^127, not x^0 through x^126.
+                    # Thus in the lsb-first case, each such instruction
+                    # implicitly adds an extra factor of x.  The below removes a
+                    # factor of x from each constant to compensate for this.
+                    # For n < 64 the x could be removed from either the reduced
+                    # part or unreduced part, but for n == 64 the reduced part
+                    # is the only option; we just always use the reduced part.
+                    pow_of_x -= 1
+                # Make a factor of 64-n be applied unreduced rather than
+                # reduced, to cause the product to use only the x^n and above
+                # terms and always be zero in the x^0 through x^(n-1) terms.
+                # Usually this makes no difference as it does not affect the
+                # product's congruence class mod G and the constant remains
+                # 64-bit, but part of the final reduction from 128 bits does
+                # rely on this property when it reuses one of the constants.
+                pow_of_x -= 64 - n
+                mults.append({ 'val': reduce(1 << pow_of_x, G) << (64 - n),
+                               'desc': f'(x^{pow_of_x} mod G) * x^{64-n}' })
+            print_mult_pair(v, mults)
+            print('\t},')
+
+        # Shuffle table for handling 1..15 bytes at end
+        print('\t.shuf_table = {')
+        print('\t\t' + (16*'-1, ').rstrip())
+        print('\t\t' + ''.join(f'{i:2}, ' for i in range(16)).rstrip())
+        print('\t\t' + (16*'-1, ').rstrip())
+        print('\t},')
+
+        # Barrett reduction constants for reducing 128 bits to the final CRC
+        print('\t.barrett_reduction_consts = {')
+        mults = []
+
+        val = div(1 << (63+n), G)
+        desc = f'floor(x^{63+n} / G)'
+        if not lsb:
+            val = (val << 1) - (1 << 64)
+            desc = f'({desc} * x) - x^64'
+        mults.append({ 'val': val, 'desc': desc })
+
+        val = G - (1 << n)
+        desc = f'G - x^{n}'
+        if lsb and n == 64:
+            assert (val & 1) != 0
+            val >>= 1
+            desc = f'({desc} - x^0) / x'
+        else:
+            pow_of_x = 64 - n - (1 if lsb else 0)
+            val <<= pow_of_x
+            desc = f'({desc}) * x^{pow_of_x}'
+        mults.append({ 'val': val, 'desc': desc })
+
+        print_mult_pair(v, mults)
+        print('\t},')
+
+        print('};')
+
+def parse_crc_variants(vars_string):
+    variants = []
+    for var_string in vars_string.split(','):
+        bits, bit_order, generator_poly = var_string.split('_')
+        assert bits.startswith('crc')
+        bits = int(bits.removeprefix('crc'))
+        assert generator_poly.startswith('0x')
+        generator_poly = generator_poly.removeprefix('0x')
+        assert len(generator_poly) % 2 == 0
+        generator_poly = int(generator_poly, 16)
+        variants.append(CrcVariant(bits, generator_poly, bit_order))
+    return variants
+
+if len(sys.argv) != 3:
+    sys.stderr.write(f'Usage: {sys.argv[0]} CONSTS_TYPE[,CONSTS_TYPE]... CRC_VARIANT[,CRC_VARIANT]...\n')
+    sys.stderr.write('  CONSTS_TYPE can be sliceby[1-8] or x86_pclmul\n')
+    sys.stderr.write('  CRC_VARIANT is crc${num_bits}_${bit_order}_${generator_poly_as_hex}\n')
+    sys.stderr.write('     E.g. crc16_msb_0x8bb7 or crc32_lsb_0xedb88320\n')
+    sys.stderr.write('     Polynomial must use the given bit_order and exclude x^{num_bits}\n')
+    sys.exit(1)
+
+print('/* SPDX-License-Identifier: GPL-2.0-or-later */')
+print('/*')
+print(' * CRC constants generated by:')
+print(' *')
+print(f' *\t{sys.argv[0]} {" ".join(sys.argv[1:])}')
+print(' *')
+print(' * Do not edit manually.')
+print(' */')
+consts_types = sys.argv[1].split(',')
+variants = parse_crc_variants(sys.argv[2])
+for consts_type in consts_types:
+    if consts_type.startswith('sliceby'):
+        gen_slicebyN_tables(variants, int(consts_type.removeprefix('sliceby')))
+    elif consts_type == 'x86_pclmul':
+        gen_x86_pclmul_consts(variants)
+    else:
+        raise ValueError(f'Unknown consts_type: {consts_type}')
-- 
2.48.1

