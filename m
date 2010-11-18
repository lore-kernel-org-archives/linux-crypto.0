From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v4] x86, crypto: ported aes-ni implementation to x86
Date: Thu, 18 Nov 2010 08:41:38 +0100
Message-ID: <9A3E97A7-EB84-4F3A-A7FD-4471E7ECBE5C@googlemail.com>
References: <1289514030-32332-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57654 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0KRHln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Nov 2010 02:41:43 -0500
Received: by bwz15 with SMTP id 15so2473435bwz.19
        for <linux-crypto@vger.kernel.org>; Wed, 17 Nov 2010 23:41:42 -0800 (PST)
In-Reply-To: <1289514030-32332-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11.11.2010, 23:20 Mathias Krause wrote:
> The AES-NI instructions are also available in legacy mode so the 32-bit
> architecture may profit from those, too.
> 
> To illustrate the performance gain here's a short summary of a dm-crypt
> speed test on a Core i7 M620 running at 2.67GHz comparing both assembler
> implementations:
> 
> x86:                   i568       aes-ni    delta
> ECB, 256 bit:     93.8 MB/s   123.3 MB/s   +31.4%
> CBC, 256 bit:     84.8 MB/s   262.3 MB/s  +209.3%
> LRW, 256 bit:    108.6 MB/s   222.1 MB/s  +104.5%
> XTS, 256 bit:    105.0 MB/s   205.5 MB/s   +95.7%
> 
> Additionally, due to some minor optimizations, the 64-bit version also
> got a minor performance gain as seen below:
> 
> x86-64:           old impl.    new impl.    delta
> ECB, 256 bit:    121.1 MB/s   123.0 MB/s    +1.5%
> CBC, 256 bit:    285.3 MB/s   290.8 MB/s    +1.9%
> LRW, 256 bit:    263.7 MB/s   265.3 MB/s    +0.6%
> XTS, 256 bit:    251.1 MB/s   255.3 MB/s    +1.7%
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
> v4 changes:
> * adapted CBC implementation to be useable on x86, too
> * redo the measurement using dm-crypt
> 
> v3 changes:
> * fixed 32-bit implementation of aesni_ecb_enc (a hunk somehow moved to the end
>  of another function)
> 
> v2 changes:
> * hide almost all register names in macros so the same code base can be shared
>  between x86 and x86_64
> * unified Kconfig documentation again
> * added alignment constraints for internal functions.
> 
> 
> arch/x86/crypto/aesni-intel_asm.S  |  197 ++++++++++++++++++++++++++++++------
> arch/x86/crypto/aesni-intel_glue.c |   22 +++-
> crypto/Kconfig                     |   12 ++-
> 3 files changed, 191 insertions(+), 40 deletions(-)

No comments so far? :(
What's wrong with the patch?

Regards,
Mathias