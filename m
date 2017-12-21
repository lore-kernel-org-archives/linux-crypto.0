From: Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 1/2] crypto: Fix out-of-bounds access of the data buffer in generic-gcm-aesni
Date: Wed, 20 Dec 2017 18:09:40 -0800
Message-ID: <14368087.35hhKrHupz@js-desktop.svl.corp.google.com>
References: <20171221010838.54243-1-junaids@google.com> <20171221010838.54243-2-junaids@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com, ebiggers3@gmail.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f45.google.com ([209.85.160.45]:36907 "EHLO
        mail-pl0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755868AbdLUCJn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 21:09:43 -0500
Received: by mail-pl0-f45.google.com with SMTP id s3so10133016plp.4
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 18:09:43 -0800 (PST)
In-Reply-To: <20171221010838.54243-2-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, December 20, 2017 5:08:37 PM PST Junaid Shahid wrote:
> +.macro READ_PARTIAL_BLOCK DPTR DLEN XMM1 XMMDst
> +        cmp $8, \DLEN
> +        jl _read_lt8_\@

> +        mov (\DPTR), %rax
> +        MOVQ_R64_XMM %rax, \XMMDst
Just noticed that these two can be replaced with:
+        movq (\DPTR), \XMMDst

> +        sub $8, \DLEN
> +        jz _done_read_partial_block_\@
> +	xor %eax, %eax
> +_read_next_byte_\@:
