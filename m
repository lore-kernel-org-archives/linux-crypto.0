From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto, x86: aesni - fix token pasting for clang
Date: Fri, 24 Mar 2017 22:12:50 +0800
Message-ID: <20170324141250.GB14780@gondor.apana.org.au>
References: <20170315223600.131367-1-md@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Michael Davidson <md@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42634 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935660AbdCXONs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:13:48 -0400
Content-Disposition: inline
In-Reply-To: <20170315223600.131367-1-md@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 15, 2017 at 03:36:00PM -0700, Michael Davidson wrote:
> aes_ctrby8_avx-x86_64.S uses the C preprocessor for token pasting
> of character sequences that are not valid preprocessor tokens.
> While this is allowed when preprocessing assembler files it exposes
> an incompatibilty between the clang and gcc preprocessors where
> clang does not strip leading white space from macro parameters,
> leading to the CONCAT(%xmm, i) macro expansion on line 96 resulting
> in a token with a space character embedded in it.
> 
> While this could be resolved by deleting the offending space character,
> the assembler is perfectly capable of doing the token pasting correctly
> for itself so we can just get rid of the preprocessor macros.
> 
> Signed-off-by: Michael Davidson <md@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
