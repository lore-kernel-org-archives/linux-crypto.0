From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Allow ecb(cipher_null) in FIPS mode
Date: Fri, 21 Apr 2017 20:18:20 +0800
Message-ID: <20170421121820.GA14381@gondor.apana.org.au>
References: <20170421110306.3343-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, gmazyland@gmail.com
To: Milan Broz <gmazyland@gmail.com>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42848 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1039038AbdDUMSs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 08:18:48 -0400
Content-Disposition: inline
In-Reply-To: <20170421110306.3343-1-gmazyland@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Milan Broz <gmazyland@gmail.com> wrote:
> The cipher_null is not a real cipher, FIPS mode should not restrict its use.
> 
> It is used for several tests (for example in cryptsetup testsuite) and also
> temporarily for reencryption of not yet encrypted device in cryptsetup-reencrypt tool.
> 
> Problem is easily reproducible with
>  cryptsetup benchmark -c null
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>

Stephan?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
