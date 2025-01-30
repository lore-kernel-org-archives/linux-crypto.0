Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79C6187FE0;
	Thu, 30 Jan 2025 03:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738209295; cv=none; b=OO9zPCLl3zWV+UNNxbl1eE3047eiQYMzxUbVgEYKGWuyIXiJXwZPnHmE5yIALYd3XSCMFeqfb4f1kBRbsWLYNUvFzr7s2/74VzfxXWzrneQ/c94Q8AL+IRa2IxLsWQALbeci47f6/jC+ToBfdRm9WObBccLVspP9cNp2RhB2oEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738209295; c=relaxed/simple;
	bh=0eqYRMjhRhzq0f4XiwMQ3bq1W0qGIWErBY26RMDs4R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDwWzxRTb0c7Od07BVwqCLcErdn+RiKQj1Ip3sPLbRvNRIWX2vM/fk6bPQOxY8M/0r8d9FKOF0Tu2ZsSPBCIWi9iRu8a/kxuvXbowu8HGvYGJu/9yNNfQlSknHEUC4n4VqMINUWaqpyHCeCNe80I613khbnzWR+7lAUJlRfDv8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUI85Ig9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUI85Ig9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9574C4CEE1;
	Thu, 30 Jan 2025 03:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738209295;
	bh=0eqYRMjhRhzq0f4XiwMQ3bq1W0qGIWErBY26RMDs4R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUI85Ig9LamH1vUOI8ll15pImcXY/L/zshl3XUwMmA9Mjg63Pi0zYcqmUkl3wpcSI
	 t6HmL04R0jZCR3R9rXkvsTlO2L8TBsgV48J/565MmWxIcXMszwYTIKhnThih1oUaJP
	 xrtzQ75yWjCthg+FGS17+MOPHitsZp/KFCuml3uZEQU8g3y7oSQtEJMtNtb/vATU9B
	 dHjZ/Pvw2pFifyawJF3+cVipDqlYCwSyaFcILg6r1wlPkB30VQpgKdasrAfo+P2H1o
	 bjJOu21W0ri0genNoge16yx/Q3EVxkyd4w9H/FqmHeRj/FzflAPjCqzzZ9GEwckcqI
	 ATSh8Ujl3tx9Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 07/11] scripts/gen-crc-consts: add gen-crc-consts.py
Date: Wed, 29 Jan 2025 19:51:26 -0800
Message-ID: <20250130035130.180676-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130035130.180676-1-ebiggers@kernel.org>
References: <20250130035130.180676-1-ebiggers@kernel.org>
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
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS               |   1 +
 scripts/gen-crc-consts.py | 214 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 215 insertions(+)
 create mode 100755 scripts/gen-crc-consts.py

diff --git a/MAINTAINERS b/MAINTAINERS
index bc8ce7af3303..aabd17a1cc6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6129,10 +6129,11 @@ S:	Maintained
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
index 000000000000..43d044ada7be
--- /dev/null
+++ b/scripts/gen-crc-consts.py
@@ -0,0 +1,214 @@
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
+    terms = ['1' if i == 0 else 'x' if i == 1 else f'x^{i}'
+             for i in reversed(range(poly.bit_length()))
+             if (poly & (1 << i)) != 0]
+    j = 0
+    while j < len(terms):
+        s = prefix + terms[j] + (' +' if j < len(terms) - 1 else '')
+        j += 1
+        while j < len(terms) and len(s) < 72:
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
+# Format a polynomial as hex.  Bit-reflect it if the CRC is LSB-first.
+def fmt_poly(variant, poly, num_bits):
+    if variant.lsb:
+        poly = bitreverse(poly, num_bits)
+    return f'0x{poly:0{2*num_bits//8}x}'
+
+# Print a comment describing constants generated for the given CRC variant.
+def print_header(variant, what):
+    print('/*')
+    s = f'{"least" if variant.lsb else "most"}-significant-bit-first CRC-{variant.bits}'
+    print(f' * {what} generated for {s} using')
+    pprint_poly(' * G(x) = ', variant.G)
+    print(' */')
+
+# Print a polynomial as hex, but drop a term if needed to keep it in 64 bits.
+def print_poly_truncate65thbit(variant, poly, num_bits, desc):
+    if num_bits > 64:
+        assert num_bits == 65
+        if variant.lsb:
+            assert (poly & 1) != 0
+            poly >>= 1
+            desc += ' - 1'
+        else:
+            poly ^= 1 << 64
+            desc += ' - x^64'
+        num_bits = 64
+    print(f'\t\t{fmt_poly(variant, poly, num_bits)},\t/* {desc} */')
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
+        print('')
+        print_header(v, 'CRC folding constants')
+        print('static const struct {')
+        if not v.lsb:
+            print('\tu8 bswap_mask[16];')
+        for i in FOLD_DISTANCES:
+            print(f'\tu64 fold_across_{i}_bits_consts[2];')
+        print('\tu8 shuf_table[48];')
+        print('\tu64 barrett_reduction_consts[2];')
+        print(f'}} {v.name}_consts ____cacheline_aligned __maybe_unused = {{')
+
+        # Byte-reflection mask, needed for MSB CRCs
+        if not v.lsb:
+            print('\t.bswap_mask = {' + ', '.join(str(i) for i in reversed(range(16))) + '},')
+
+        # Fold constants for all distances down to 128 bits
+        k = v.bits - 65 if v.lsb else 0
+        for i in FOLD_DISTANCES:
+            print(f'\t.fold_across_{i}_bits_consts = {{')
+            for j in [64, 0] if v.lsb else [0, 64]:
+                if i + j + k == 128 and not v.lsb:
+                    # Special case: for MSB CRCs, store
+                    # (x^(64 + v.bits) mod G) * x^(64 - v.bits) instead of
+                    # x^128 mod G.  These values are congruent to each other and
+                    # are equivalent for the usual folding across 128 bits, but
+                    # the former value happens to also be needed during the
+                    # final reduction.  It generates a fold across '64 + v.bits'
+                    # bits combined with a left shift by '64 - v.bits' bits.
+                    const = reduce(1 << (64 + v.bits), v.G) << (64 - v.bits)
+                    print(f'\t\t{fmt_poly(v, const, v.bits)},\t/* x^{64+v.bits} mod G(x) * x^{64 - v.bits} */')
+                    continue
+                const = reduce(1 << (i + j + k), v.G)
+                pow_desc = f'{i}{"+" if j >= 0 else "-"}{abs(j)}'
+                if k != 0:
+                    pow_desc += f'{"+" if k >= 0 else "-"}{abs(k)}'
+                print(f'\t\t{fmt_poly(v, const, v.bits)},\t/* x^({pow_desc}) mod G(x) */')
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
+        m = 63 if v.lsb else 64
+        print('\t.barrett_reduction_consts = {')
+        print_poly_truncate65thbit(v, div(1<<(m+v.bits), v.G), m+1,
+                                   f'floor(x^{m+v.bits} / G(x))')
+        print_poly_truncate65thbit(v, v.G, v.bits+1, 'G(x)')
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

