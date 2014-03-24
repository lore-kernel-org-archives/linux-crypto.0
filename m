From: chandramouli narayanan <mouli@linux.intel.com>
Subject: Re: [PATCH 0/3] crypto: x86/sha1 - regression and other fixes
Date: Mon, 24 Mar 2014 10:29:33 -0700
Message-ID: <1395682173.2367.66.camel@pegasus.jf.intel.com>
References: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Marek Vasut <marex@denx.de>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34978 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbaCXR2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2014 13:28:48 -0400
In-Reply-To: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2014-03-24 at 17:10 +0100, Mathias Krause wrote:
> The recent addition of the AVX2 variant of the SHA1 hash function wrongly
> disabled the AVX variant by introducing a flaw in the feature test. Fixed
> in patch 1.
> 
> The alignment calculations of the AVX2 assembler implementation are
> questionable, too. Especially the page alignment of the stack pointer is
> broken in multiple ways. Fixed in patch 2. In patch 3 another issue for
> code alignment is fixed.
> 
> Please apply!
> 
> Mathias Krause (3):
>   crypto: x86/sha1 - re-enable the AVX variant
>   crypto: x86/sha1 - fix stack alignment of AVX2 variant
>   crypto: x86/sha1 - reduce size of the AVX2 asm implementation
> 
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S |    8 ++------
>  arch/x86/crypto/sha1_ssse3_glue.c      |   26 ++++++++++++++++----------
>  2 files changed, 18 insertions(+), 16 deletions(-)
> 
Your fixes are the right on mark. I went through your patches and tested
them and found to be correct.

Sorry for causing regression and missing alignment issues in the patches
I submitted.

- mouli
