From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: Fix out-of-bounds access of the data
 buffer in generic-gcm-aesni
Date: Wed, 20 Dec 2017 00:36:16 -0800
Message-ID: <20171220083616.GB6565@zzz.localdomain>
References: <20171219221750.34148-1-junaids@google.com>
 <20171220044259.61106-2-junaids@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        andreslc@google.com, davem@davemloft.net, gthelen@google.com
To: Junaid Shahid <junaids@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:46451 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753779AbdLTIgT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 03:36:19 -0500
Received: by mail-pl0-f65.google.com with SMTP id i6so8614709plt.13
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 00:36:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171220044259.61106-2-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 19, 2017 at 08:42:58PM -0800, Junaid Shahid wrote:
> The aesni_gcm_enc/dec functions can access memory before the start of
> the data buffer if the length of the data buffer is less than 16 bytes.
> This is because they perform the read via a single 16-byte load. This
> can potentially result in accessing a page that is not mapped and thus
> causing the machine to crash. This patch fixes that by reading the
> partial block byte-by-byte and optionally an via 8-byte load if the block
> was at least 8 bytes.
> 
> Fixes: 0487ccac ("crypto: aesni - make non-AVX AES-GCM work with any aadlen")
> Signed-off-by: Junaid Shahid <junaids@google.com>

Did you run the self-tests (boot with CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
unset)?  The second patch causes them to start failing:

[    1.169640] alg: aead: Test 7 failed on encryption for rfc4106-gcm-aesni
[    1.178308] alg: aead: Test 4 failed on encryption for generic-gcm-aesni

Also, don't the AVX and AVX2 versions have the same bug?  These patches only fix
the non-AVX version.

> +# read the last <16 byte block
> +# Clobbers %rax, DPTR, TMP1 and XMM1-2
> +.macro READ_PARTIAL_BLOCK DPTR DLEN TMP1 XMM1 XMM2 XMMDst
> +        pxor \XMMDst, \XMMDst
> +        mov \DLEN, \TMP1
> +        cmp $8, \DLEN
> +        jl _read_last_lt8_\@
> +        mov (\DPTR), %rax
> +        MOVQ_R64_XMM %rax, \XMMDst
> +	add $8, \DPTR
> +        sub $8, \TMP1
> +        jz _done_read_last_partial_block_\@
> +_read_last_lt8_\@:
> +	shl $8, %rax
> +        mov -1(\DPTR, \TMP1, 1), %al
> +        dec \TMP1
> +        jnz _read_last_lt8_\@
> +        MOVQ_R64_XMM %rax, \XMM1

Doesn't %rax needs to be zeroed at '_read_last_lt8' so that the padding is
zeroed?

> +	# adjust the shuffle mask pointer to be able to shift either 0 or 8
> +	# bytes depending on whether the last block is <8 bytes or not
> +        mov \DLEN, \TMP1
> +        and $8, \TMP1
> +	lea SHIFT_MASK(%rip), %rax
> +	sub \TMP1, %rax
> +	movdqu (%rax), \XMM2		# get the appropriate shuffle mask
> +	PSHUFB_XMM \XMM2, \XMM1		# shift left either 0 or 8 bytes

Is there any way this can be simplified to use pslldq?  The shift is just 8
bytes or nothing, and we already had to branch earlier depending on whether we
needed to read the 8 bytes or not.

Eric
