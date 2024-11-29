Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B00168DA;
	Fri, 29 Nov 2024 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732896605; cv=none; b=V2lc7XknoLvmxg0G5RqUJt79V7SqWV7ddanNvkxVfOpKYmSnZbhrnpKJy7ukGss4G6miqHtGgKUATtJx/fBXAfe+yDMIFFaTR2i8TbItMGpiKbpBhxTMiMEmPgxPbtYDDha6HoNr5qBVC6gZAvA6WmKpuGoqk4o+K4ptAMbX09s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732896605; c=relaxed/simple;
	bh=tLYTMDQXQL2x03mcwzCL/tJ5nbkPDv3owmBLoLTD5ls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ifiljuWMsf7OAQXgrcTyl4e3W3xHALXtIZcQsA46sd1sqjyl71Xx8xiKtYlKtOObbeY5R9X+385TH3xq31Yd2V5wmp67VWyuWQv0YvtGojo05utRFAv/ZjxWiANO6/iGmqnCCJZ50LK9HKa8389vJbnKdUt/pBKNJxhFJG1DLbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rY0PH76c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rY0PH76c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3660C4CECF;
	Fri, 29 Nov 2024 16:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732896604;
	bh=tLYTMDQXQL2x03mcwzCL/tJ5nbkPDv3owmBLoLTD5ls=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rY0PH76c1wgpAeKxhWcaKFkgqDS5Lsrva/gfCJdHnGCEXZzW0jJioosld76FLZ8Cq
	 SrzV52ih/tHWpOPS80Thr2gvGRL8eklsudGsQGgBLtuB9N52yITHGPrElhXTQ9evVY
	 RzFfxFN7HJAsLDOzpojqt3rg6hQzxtZsIkTlAfL3OPtbDx+j5YxgI2Hbc5adBOtWYV
	 nKwFswdviCbhXvODG+tXzPUw+OlOH5gnC0ozri7dfnLasg0GAfO59ymFm3tclmPYP7
	 m/5SjGWlX9TD++grf7BhzVNHLc9q9ma0dh4sxGNTbGD1K7kPKjL/Uj0mEUfWE5TOvU
	 pnJ0/5uoStlOQ==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ffc86948dcso21854461fa.2;
        Fri, 29 Nov 2024 08:10:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW3PfElU5l3fh1zniVcY/+EMxlhJs62Bww9BAwv0DjkAN2TOHimDiX/maiRC86U3ppxaKlQKN1whePUjOM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHcnZ+vojLeZ93CpbhIPf5RH8CODnPvVIUuFQ2bcUopGlMBFNt
	RSy+mLXAr9CBqWbbKbxfxdnzPp6gjXO4L/RdjPV8G5GZ54THskuGD63fSgasQdY9HfycybWfNr+
	iSf6g9d+ek3hjn9oi3VTDQ9jyydc=
X-Google-Smtp-Source: AGHT+IGo4vefS3BVGJC9QJug0PEfkjnPfa3kCPinOGxYkgjXIUmmaZK82yRudLOCMXnKx/EBKpPPSuYxtPZWeQxLY1Y=
X-Received: by 2002:a05:6512:3d8b:b0:539:8f4d:a7dc with SMTP id
 2adb3069b0e04-53df0111eb8mr7269672e87.48.1732896602997; Fri, 29 Nov 2024
 08:10:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241125041129.192999-1-ebiggers@kernel.org> <20241125041129.192999-3-ebiggers@kernel.org>
In-Reply-To: <20241125041129.192999-3-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 29 Nov 2024 17:09:51 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFGs8Ur0yt9GetVaub8LzbeWJ77jaZ4ZstvECb3JH9Pvg@mail.gmail.com>
Message-ID: <CAMj1kXFGs8Ur0yt9GetVaub8LzbeWJ77jaZ4ZstvECb3JH9Pvg@mail.gmail.com>
Subject: Re: [PATCH 2/6] scripts/crc: add gen-crc-consts.py
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 25 Nov 2024 at 05:12, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add a Python script that generates constants for computing the given CRC
> variant(s) using x86's pclmulqdq or vpclmulqdq instructions.
>

There is nothing x86 specific about this, right? Except perhaps the
choice of fold distances?

> It can also generate the traditional byte-at-a-time tables.
>
> Only small changes should be needed for this script to also work to
> generate the constants needed for CRC computation on other architectures
> with a carryless multiplication instruction, such as arm64.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  scripts/crc/gen-crc-consts.py | 207 ++++++++++++++++++++++++++++++++++
>  1 file changed, 207 insertions(+)
>  create mode 100755 scripts/crc/gen-crc-consts.py
>
> diff --git a/scripts/crc/gen-crc-consts.py b/scripts/crc/gen-crc-consts.py
> new file mode 100755
> index 0000000000000..84f0902e1cd7b
> --- /dev/null
> +++ b/scripts/crc/gen-crc-consts.py
> @@ -0,0 +1,207 @@
> +#!/usr/bin/env python3
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +#
> +# Script that generates constants for computing the given CRC variant(s).
> +#
> +# Copyright 2024 Google LLC
> +#
> +# Author: Eric Biggers <ebiggers@google.com>
> +
> +import sys
> +
> +# XOR (add) an iterable of polynomials.
> +def xor(iterable):
> +    res = 0
> +    for val in iterable:
> +        res ^= val
> +    return res
> +
> +# Multiply two polynomials.
> +def clmul(a, b):
> +    return xor(a << i for i in range(b.bit_length()) if (b & (1 << i)) != 0)
> +
> +# Polynomial division floor(a / b).
> +def div(a, b):
> +    q = 0
> +    while a.bit_length() >= b.bit_length():
> +        q ^= 1 << (a.bit_length() - b.bit_length())
> +        a ^= b << (a.bit_length() - b.bit_length())
> +    return q
> +
> +# Reduce the polynomial 'a' modulo the polynomial 'b'.
> +def reduce(a, b):
> +    return a ^ clmul(div(a, b), b)
> +
> +# Pretty-print a polynomial.
> +def pprint_poly(prefix, poly):
> +    terms = ['1' if i == 0 else 'x' if i == 1 else f'x^{i}'
> +             for i in reversed(range(poly.bit_length()))
> +             if (poly & (1 << i)) != 0]
> +    j = 0
> +    while j < len(terms):
> +        s = prefix + terms[j] + (' +' if j < len(terms) - 1 else '')
> +        j += 1
> +        while j < len(terms) and len(s) < 72:
> +            s += ' ' + terms[j] + (' +' if j < len(terms) - 1 else '')
> +            j += 1
> +        print(s)
> +        prefix = ' * ' + (' ' * (len(prefix) - 3))
> +
> +# Reverse the bits of a polynomial.
> +def bitreverse(poly, num_bits):
> +    return xor(1 << (num_bits - 1 - i) for i in range(num_bits)
> +               if (poly & (1 << i)) != 0)
> +
> +# Format a polynomial as hex.  Bit-reflect it if the CRC is LSB-first.
> +def fmt_poly(variant, poly, num_bits):
> +    if variant.lsb:
> +        poly = bitreverse(poly, num_bits)
> +    return f'0x{poly:0{2*num_bits//8}x}'
> +
> +# Print a comment describing constants generated for the given CRC variant.
> +def print_header(variant, what):
> +    print('/*')
> +    s = f'{"least" if variant.lsb else "most"}-significant-bit-first CRC-{variant.bits}'
> +    print(f' * {what} generated for {s} using')
> +    pprint_poly(' * G(x) = ', variant.G)
> +    print(' */')
> +
> +# Print a polynomial as hex, but drop a term if needed to keep it in 64 bits.
> +def print_poly_truncate65thbit(variant, poly, num_bits, desc):
> +    if num_bits > 64:
> +        assert num_bits == 65
> +        if variant.lsb:
> +            assert (poly & 1) != 0
> +            poly >>= 1
> +            desc += ' - 1'
> +        else:
> +            poly ^= 1 << 64
> +            desc += ' - x^64'
> +        num_bits = 64
> +    print(f'\t\t{fmt_poly(variant, poly, num_bits)},\t/* {desc} */')
> +
> +class CrcVariant:
> +    def __init__(self, bits, generator_poly, bit_order):
> +        self.bits = bits
> +        if bit_order not in ['lsb', 'msb']:
> +            raise ValueError('Invalid value for bit_order')
> +        self.lsb = bit_order == 'lsb'
> +        self.name = f'crc{bits}_{bit_order}_0x{generator_poly:0{(2*bits+7)//8}x}'
> +        if self.lsb:
> +            generator_poly = bitreverse(generator_poly, bits)
> +        self.G = generator_poly ^ (1 << bits)
> +
> +# Generate tables for byte-at-a-time CRC computation.
> +def gen_sliceby1_tables(variants):
> +    for v in variants:
> +        print('')
> +        print_header(v, 'CRC table')
> +        print(f'static const u{v.bits} __maybe_unused {v.name}_table[256] = {{')
> +        s = ''
> +        for i in range(256):
> +            remainder = (bitreverse(i, 8) if v.lsb else i) << (v.bits - 8)
> +            for _ in range(8):
> +                remainder <<= 1
> +                if (remainder & (1 << v.bits)) != 0:
> +                    remainder ^= v.G
> +            next_entry = fmt_poly(v, remainder, v.bits) + ','
> +            if len(s + next_entry) > 71:
> +                print(f'\t{s}')
> +                s = ''
> +            s += (' ' if s else '') + next_entry
> +        if s:
> +            print(f'\t{s}')
> +        print('};')
> +
> +# Generate constants for carryless multiplication based CRC computation.
> +def gen_x86_pclmul_consts(variants):
> +    # These are the distances, in bits, to generate folding constants for.
> +    FOLD_DISTANCES = [2048, 1024, 512, 256, 128]
> +
> +    for v in variants:
> +        print('')
> +        print_header(v, 'CRC folding constants')
> +        print('static const struct {')
> +        if not v.lsb:
> +            print('\tu8 bswap_mask[16];')
> +        for i in FOLD_DISTANCES:
> +            print(f'\tu64 fold_across_{i}_bits_consts[2];')
> +        print('\tu8 shuf_table[48];')
> +        print('\tu64 barrett_reduction_consts[2];')
> +        if v.lsb and v.bits < 64:
> +            print('\tu64 extract_crc_mask[2];')
> +        print(f'}} {v.name}_consts __cacheline_aligned __maybe_unused = {{')
> +
> +        # Byte-reflection mask, needed for MSB CRCs
> +        if not v.lsb:
> +            print('\t.bswap_mask = {' + ', '.join(str(i) for i in reversed(range(16))) + '},')
> +
> +        # Fold constants for all distances down to 128 bits
> +        k = v.bits - 65 if v.lsb else 0
> +        for i in FOLD_DISTANCES:
> +            print(f'\t.fold_across_{i}_bits_consts = {{')
> +            for j in [64, 0] if v.lsb else [0, 64]:
> +                const = reduce(1<<(i+j+k), v.G)
> +                pow_desc = f'{i}{"+" if j >= 0 else "-"}{abs(j)}'
> +                if k != 0:
> +                    pow_desc += f'{"+" if k >= 0 else "-"}{abs(k)}'
> +                print(f'\t\t{fmt_poly(v, const, v.bits)},\t/* x^({pow_desc}) mod G(x) */')
> +            print('\t},')
> +
> +        # Shuffle table for handling 1..15 bytes at end
> +        print('\t.shuf_table = {')
> +        print('\t\t' + (16*'-1, ').rstrip())
> +        print('\t\t' + ''.join(f'{i:2}, ' for i in range(16)).rstrip())
> +        print('\t\t' + (16*'-1, ').rstrip())
> +        print('\t},')
> +
> +        # Barrett reduction constants for reducing 128 bits to the final CRC
> +        m = 63 if v.lsb else 64
> +        print('\t.barrett_reduction_consts = {')
> +        print_poly_truncate65thbit(v, div(1<<(m+v.bits), v.G), m+1,
> +                                   f'floor(x^{m+v.bits} / G(x))')
> +        print_poly_truncate65thbit(v, v.G, v.bits+1, 'G(x)')
> +        print('\t},')
> +        if v.lsb and v.bits < 64:
> +            print(f'\t.extract_crc_mask = {{0, 0x{(1<<(v.bits))-1:x}}},')
> +
> +        print('};')
> +
> +def parse_crc_variants(vars_string):
> +    variants = []
> +    for var_string in vars_string.split(','):
> +        bits, bit_order, generator_poly = var_string.split('_')
> +        assert bits.startswith('crc')
> +        bits = int(bits.removeprefix('crc'))
> +        assert generator_poly.startswith('0x')
> +        generator_poly = generator_poly.removeprefix('0x')
> +        assert len(generator_poly) % 2 == 0
> +        generator_poly = int(generator_poly, 16)
> +        variants.append(CrcVariant(bits, generator_poly, bit_order))
> +    return variants
> +
> +if len(sys.argv) != 3:
> +    sys.stderr.write(f'Usage: {sys.argv[0]} CONSTS_TYPE[,CONSTS_TYPE]... CRC_VARIANT[,CRC_VARIANT]...\n')
> +    sys.stderr.write('  CONSTS_TYPE can be sliceby1 or x86_pclmul\n')
> +    sys.stderr.write('  CRC_VARIANT is crc${num_bits}_${bit_order}_${generator_poly_as_hex}\n')
> +    sys.stderr.write('     E.g. crc16_msb_0x8bb7 or crc32_lsb_0xedb88320\n')
> +    sys.stderr.write('     Polynomial must use the given bit_order and exclude x^{num_bits}\n')
> +    sys.exit(1)
> +
> +print('/* SPDX-License-Identifier: GPL-2.0-or-later */')

Does it make sense to add a GPL header into a generated file?


> +print('/*')
> +print(' * CRC constants generated by:')
> +print(' *')
> +print(f' *\t{sys.argv[0]} {" ".join(sys.argv[1:])}')
> +print(' *')
> +print(' * Do not edit manually.')
> +print(' */')
> +consts_types = sys.argv[1].split(',')
> +variants = parse_crc_variants(sys.argv[2])
> +for consts_type in consts_types:
> +    if consts_type == 'sliceby1':
> +        gen_sliceby1_tables(variants)
> +    elif consts_type == 'x86_pclmul':
> +        gen_x86_pclmul_consts(variants)
> +    else:
> +        raise ValueError(f'Unknown consts_type: {consts_type}')
> --
> 2.47.0
>
