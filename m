Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C143E17B50B;
	Thu,  6 Feb 2025 19:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738870282; cv=none; b=c6Sf9frRCUzIji1SGiYyKAyTl7eCdvt49Vg1xG/w0R1LIc58odBP5MIU8VAE7oIT9yegsMSBVZcwFvvhJJPgbj7KOWyQD4R3WSrmAjZeS7dnKMSL3h+aGzVcWbVDIvAboxOpU8o8EwGsuU3wXTBlH/Q+Y2zLBppoW7Tz/Sj+Dkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738870282; c=relaxed/simple;
	bh=NAFm1eLpYert9vXtw/1gQKmaI8vqQmc+ncGEXsi2PHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lvnz2csjuZYRr0iCueToV7+zPAIbqGkZ6s7xgq1mAZPsR3DMMaPZrqWfImqMtaavx8/kkOMKxisbDv96Oq1VBNK939ktFvvaJZIMW7/0ZLTM6ZYdT1hM3IlQTUtvDUaaWLBDGPb+jXkd1CTEl2Sfr/NttiBRxRVR/ZYEy+0QpXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W01c97vk; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W01c97vk"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38dc5764fc0so501662f8f.3;
        Thu, 06 Feb 2025 11:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738870279; x=1739475079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vtid46726QjWowddDI5xX/yk9x7tgopwugY0X3Dz+hI=;
        b=W01c97vk1Kw49xtIcav6Mb8ipcnJ6PkKP7CyOEz+1okLde2x73VQiSpIdf8etG57dF
         ViiVbYgz30WjcAZc5BlPTkrvXOYQ4ao5uIN+WEXro4acUEJyBGe0pVTrTovEyjj7D2L1
         Xit68tuRnc82hnz7pAu2SaJ3TmyVNSACpngEpYD6EHK4xVx2rZiLBNF4hkza+Kc5iM6X
         Za50GRv0hm2mKd2TmHgsUi+tTLTTZ3tnAQ/jpjAWj92bP9AwcHcErJmXt1qINxFbhGsy
         fgqK6F8/LpFR+qpFU028vEyqTMgKz9WIdNKEX04iJjqmDnFf8VSbBwbxpYTjWHPPhbuA
         Qw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738870279; x=1739475079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vtid46726QjWowddDI5xX/yk9x7tgopwugY0X3Dz+hI=;
        b=NolddJJf64g3ITH3Yg4G3yQVJH38hbfbzCO8/oV2fka2zXIzuGZ0pZkidpd0Fszcwy
         kUg14dF+luGhmSMKeBjRIFefuv2HdmQ79gxtUFiDxul3LEcNBag70pMj/3OmuaVpxBZX
         sDGAWaHqjD7uNH6PS01ssxi4JJ12Tqh2Kqwwt8jSloSFOOJsPShxmMAo1jVroJc6m6K5
         ywdPJREmi0Og6VYO9b6+y4AFteaVqNEyramxKWI1ffDdu33yKkFBBZSSD0njomRgWrK6
         xOYe1oxfdkAbQsA5OqsM2vrhBEtV3lR7nQEUm108cB09VOLZ2hAczf/cni98hwwNUyzJ
         BnlA==
X-Forwarded-Encrypted: i=1; AJvYcCV4OvZgpqQdemA/yCxSm1hcavf0orQCW06qhV7K4PV2yTWbm6pTLiaMd8tzuapTmKEyRs1mvC6odJZAzofK@vger.kernel.org, AJvYcCVHdK0D3ARMpheyhAtpd1cLlVpVAFBA0Nq1giJbPDES4zzP4VT3HM/47e72nCEpT7GTIM0oFlg3chPfpg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSS41Mu6r/lBMMTekNPyJZQqE+k8rgFaI5sSmMouCwT2cyYOnZ
	V6hwlrUy4Lolzxco8krFEv+qEAGc9Pc4rG5k+Xp0XdktKqYSppUg
X-Gm-Gg: ASbGncvlwanxwUOEzEJuh2DINKrmsPPxD72rNYHQH7+gDxYD/ERcUT16rj5idJSf4xV
	07qrsit2kX9OTsrTOA+3I89FQFG6mo7K6BRdodJ33mEnafamX7frf0HmXogJLmNRoEJBIgjWY8Y
	T6B78r8OpISi8kKBGJrZK1qAD6U2zUWaSmC1UU+k1LPO3GYQWkd/iSJrm6UZMVixKABxNWxhB8a
	a7vYvTbW3iG/LEK87yYiAXxTnRipLTIiNEvyroj6Z05T+TC0yN13lzWa9IUi0GcOc5pPzABNLQP
	qjGCr1v6SJfY2su8KjO1CSURviwebGCgbHE6HJX2MhTk4eV0qrsusg==
X-Google-Smtp-Source: AGHT+IEbeLPvuzNHsdRHKpDkT6UVHoOjxzZ6jIfVJxALCHSeX7RuhxuIDNIk9IhHKHqOIFdGd8uxqQ==
X-Received: by 2002:a05:6000:1569:b0:38d:baf7:8d3a with SMTP id ffacd0b85a97d-38dc8da77c0mr206137f8f.7.1738870278808;
        Thu, 06 Feb 2025 11:31:18 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391da96502sm29722995e9.1.2025.02.06.11.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 11:31:18 -0800 (PST)
Date: Thu, 6 Feb 2025 19:31:17 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 x86@kernel.org, linux-block@vger.kernel.org, Ard Biesheuvel
 <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>, Kent Overstreet
 <kent.overstreet@linux.dev>, "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 2/6] scripts/gen-crc-consts: add gen-crc-consts.py
Message-ID: <20250206193117.7a9a463c@pumpkin>
In-Reply-To: <20250206073948.181792-3-ebiggers@kernel.org>
References: <20250206073948.181792-1-ebiggers@kernel.org>
	<20250206073948.181792-3-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Feb 2025 23:39:44 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> Add a Python script that generates constants for computing the given CRC
> variant(s) using x86's pclmulqdq or vpclmulqdq instructions.
> 
> This is specifically tuned for x86's crc-pclmul-template.S.  However,
> other architectures with a 64x64 => 128-bit carryless multiplication
> instruction should be able to use the generated constants too.  (Some
> tweaks may be warranted based on the exact instructions available on
> each arch, so the script may grow an arch argument in the future.)
> 
> The script also supports generating the tables needed for table-based
> CRC computation.  Thus, it can also be used to reproduce the tables like
> t10_dif_crc_table[] and crc16_table[] that are currently hardcoded in
> the source with no generation script explicitly documented.
> 
> Python is used rather than C since it enables implementing the CRC math
> in the simplest way possible, using arbitrary precision integers.  The
> outputs of this script are intended to be checked into the repo, so
> Python will continue to not be required to build the kernel, and the
> script has been optimized for simplicity rather than performance.

It might be better to output #defines that just contain array
initialisers rather than the definition of the actual array itself.

Then any code that wants the values can include the header and
just use the constant data it wants to initialise its own array.

	David

> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Acked-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  MAINTAINERS               |   1 +
>  scripts/gen-crc-consts.py | 239 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 240 insertions(+)
>  create mode 100755 scripts/gen-crc-consts.py
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 896a307fa0654..3532167f31939 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6130,10 +6130,11 @@ S:	Maintained
>  T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-next
>  F:	Documentation/staging/crc*
>  F:	arch/*/lib/crc*
>  F:	include/linux/crc*
>  F:	lib/crc*
> +F:	scripts/gen-crc-consts.py
>  
>  CREATIVE SB0540
>  M:	Bastien Nocera <hadess@hadess.net>
>  L:	linux-input@vger.kernel.org
>  S:	Maintained
> diff --git a/scripts/gen-crc-consts.py b/scripts/gen-crc-consts.py
> new file mode 100755
> index 0000000000000..608714ba451eb
> --- /dev/null
> +++ b/scripts/gen-crc-consts.py
> @@ -0,0 +1,239 @@
> +#!/usr/bin/env python3
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +#
> +# Script that generates constants for computing the given CRC variant(s).
> +#
> +# Copyright 2025 Google LLC
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
> +    terms = [f'x^{i}' for i in reversed(range(poly.bit_length()))
> +             if (poly & (1 << i)) != 0]
> +    j = 0
> +    while j < len(terms):
> +        s = prefix + terms[j] + (' +' if j < len(terms) - 1 else '')
> +        j += 1
> +        while j < len(terms) and len(s) < 73:
> +            s += ' ' + terms[j] + (' +' if j < len(terms) - 1 else '')
> +            j += 1
> +        print(s)
> +        prefix = ' * ' + (' ' * (len(prefix) - 3))
> +
> +# Reverse the bits of a polynomial.
> +def bitreverse(poly, num_bits):
> +    assert poly.bit_length() <= num_bits
> +    return xor(1 << (num_bits - 1 - i) for i in range(num_bits)
> +               if (poly & (1 << i)) != 0)
> +
> +# Format a polynomial as hex.  Bit-reflect it if the CRC is lsb-first.
> +def fmt_poly(variant, poly, num_bits):
> +    if variant.lsb:
> +        poly = bitreverse(poly, num_bits)
> +    return f'0x{poly:0{2*num_bits//8}x}'
> +
> +# Print a pair of 64-bit polynomial multipliers.  They are always passed in the
> +# order [HI64_TERMS, LO64_TERMS] but will be printed in the appropriate order.
> +def print_mult_pair(variant, mults):
> +    mults = list(mults if variant.lsb else reversed(mults))
> +    terms = ["HI64_TERMS", "LO64_TERMS"] if variant.lsb else ["LO64_TERMS", "HI64_TERMS"]
> +    for i in range(2):
> +        print(f'\t\t{fmt_poly(variant, mults[i]["val"], 64)},\t/* {terms[i]}: {mults[i]["desc"]} */')
> +
> +# Print a comment describing constants generated for the given CRC variant.
> +def print_header(variant, what):
> +    print('/*')
> +    s = f'{"least" if variant.lsb else "most"}-significant-bit-first CRC-{variant.bits}'
> +    print(f' * {what} generated for {s} using')
> +    pprint_poly(' * G(x) = ', variant.G)
> +    print(' */')
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
> +# Generate tables for CRC computation using the "slice-by-N" method.
> +# N=1 corresponds to the traditional byte-at-a-time table.
> +def gen_slicebyN_tables(variants, n):
> +    for v in variants:
> +        print('')
> +        print_header(v, f'Slice-by-{n} CRC table')
> +        print(f'static const u{v.bits} __maybe_unused {v.name}_table[{256*n}] = {{')
> +        s = ''
> +        for i in range(256 * n):
> +            # The i'th table entry is the CRC of the message consisting of byte
> +            # i % 256 followed by i // 256 zero bytes.
> +            poly = (bitreverse(i % 256, 8) if v.lsb else (i % 256)) << (v.bits + 8*(i//256))
> +            next_entry = fmt_poly(v, reduce(poly, v.G), v.bits) + ','
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
> +        (G, n, lsb) = (v.G, v.bits, v.lsb)
> +        print('')
> +        print_header(v, 'CRC folding constants')
> +        print('static const struct {')
> +        if not lsb:
> +            print('\tu8 bswap_mask[16];')
> +        for i in FOLD_DISTANCES:
> +            print(f'\tu64 fold_across_{i}_bits_consts[2];')
> +        print('\tu8 shuf_table[48];')
> +        print('\tu64 barrett_reduction_consts[2];')
> +        print(f'}} {v.name}_consts ____cacheline_aligned __maybe_unused = {{')
> +
> +        # Byte-reflection mask, needed for msb-first CRCs
> +        if not lsb:
> +            print('\t.bswap_mask = {' + ', '.join(str(i) for i in reversed(range(16))) + '},')
> +
> +        # Fold constants for all distances down to 128 bits
> +        for i in FOLD_DISTANCES:
> +            print(f'\t.fold_across_{i}_bits_consts = {{')
> +            # Given 64x64 => 128 bit carryless multiplication instructions, two
> +            # 64-bit fold constants are needed per "fold distance" i: one for
> +            # HI64_TERMS that is basically x^(i+64) mod G and one for LO64_TERMS
> +            # that is basically x^i mod G.  The exact values however undergo a
> +            # couple adjustments, described below.
> +            mults = []
> +            for j in [64, 0]:
> +                pow_of_x = i + j
> +                if lsb:
> +                    # Each 64x64 => 128 bit carryless multiplication instruction
> +                    # actually generates a 127-bit product in physical bits 0
> +                    # through 126, which in the lsb-first case represent the
> +                    # coefficients of x^1 through x^127, not x^0 through x^126.
> +                    # Thus in the lsb-first case, each such instruction
> +                    # implicitly adds an extra factor of x.  The below removes a
> +                    # factor of x from each constant to compensate for this.
> +                    # For n < 64 the x could be removed from either the reduced
> +                    # part or unreduced part, but for n == 64 the reduced part
> +                    # is the only option; we just always use the reduced part.
> +                    pow_of_x -= 1
> +                # Make a factor of 64-n be applied unreduced rather than
> +                # reduced, to cause the product to use only the x^n and above
> +                # terms and always be zero in the x^0 through x^(n-1) terms.
> +                # Usually this makes no difference as it does not affect the
> +                # product's congruence class mod G and the constant remains
> +                # 64-bit, but part of the final reduction from 128 bits does
> +                # rely on this property when it reuses one of the constants.
> +                pow_of_x -= 64 - n
> +                mults.append({ 'val': reduce(1 << pow_of_x, G) << (64 - n),
> +                               'desc': f'(x^{pow_of_x} mod G) * x^{64-n}' })
> +            print_mult_pair(v, mults)
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
> +        print('\t.barrett_reduction_consts = {')
> +        mults = []
> +
> +        val = div(1 << (63+n), G)
> +        desc = f'floor(x^{63+n} / G)'
> +        if not lsb:
> +            val = (val << 1) - (1 << 64)
> +            desc = f'({desc} * x) - x^64'
> +        mults.append({ 'val': val, 'desc': desc })
> +
> +        val = G - (1 << n)
> +        desc = f'G - x^{n}'
> +        if lsb and n == 64:
> +            assert (val & 1) != 0
> +            val >>= 1
> +            desc = f'({desc} - x^0) / x'
> +        else:
> +            pow_of_x = 64 - n - (1 if lsb else 0)
> +            val <<= pow_of_x
> +            desc = f'({desc}) * x^{pow_of_x}'
> +        mults.append({ 'val': val, 'desc': desc })
> +
> +        print_mult_pair(v, mults)
> +        print('\t},')
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
> +    sys.stderr.write('  CONSTS_TYPE can be sliceby[1-8] or x86_pclmul\n')
> +    sys.stderr.write('  CRC_VARIANT is crc${num_bits}_${bit_order}_${generator_poly_as_hex}\n')
> +    sys.stderr.write('     E.g. crc16_msb_0x8bb7 or crc32_lsb_0xedb88320\n')
> +    sys.stderr.write('     Polynomial must use the given bit_order and exclude x^{num_bits}\n')
> +    sys.exit(1)
> +
> +print('/* SPDX-License-Identifier: GPL-2.0-or-later */')
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
> +    if consts_type.startswith('sliceby'):
> +        gen_slicebyN_tables(variants, int(consts_type.removeprefix('sliceby')))
> +    elif consts_type == 'x86_pclmul':
> +        gen_x86_pclmul_consts(variants)
> +    else:
> +        raise ValueError(f'Unknown consts_type: {consts_type}')

