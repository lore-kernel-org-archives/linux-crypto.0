From: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH v3] x86, crypto: ported aes-ni implementation to x86
Date: Thu, 04 Nov 2010 06:27:11 +0800
Message-ID: <1288823231.3016.25.camel@yhuang-mobile>
References: <1288818883-7620-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5336 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab0KCW1N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Nov 2010 18:27:13 -0400
In-Reply-To: <1288818883-7620-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2010-11-03 at 14:14 -0700, Mathias Krause wrote:
> The AES-NI instructions are also available in legacy mode so the 32-bit
> architecture may profit from those, too.
> 
> To illustrate the performance gain here's a short summary of the tcrypt
> speed test on a Core i7 M620 running at 2.67GHz comparing both assembler
> implementations:
> 
> x86:                              i568       aes-ni   delta
> 256 bit, 8kB blocks, ECB:  125.94 MB/s  187.09 MB/s  +48.6%

Which method do you used for speed testing?

modprobe tcrypt mode=200 sec=<?>

That actually does not work very well for AES-NI. Because AES-NI
blkcipher is tested in synchronous mode, and in that mode,
kernel_fpu_begin/end() must be called for every block, and
kernel_fpu_begin/end() is quite slow. At the same time, some further
optimization for AES-NI can not be tested (such as "ecb-aes-aesni"
driver) in that mode, because they are only available in asynchronous
mode.

When developing AES-NI for x86_64, I uses dm-crypt + AES-NI for speed
testing, where AES-NI blkcipher will be tested in asynchronous mode, and
kernel_fpu_begin/end() is called for every page. Can you use that to
test?

Or you can add test_acipher_speed (similar with test_ahash_speed) to
test cipher in asynchronous mode.

Best Regards,
Huang Ying
