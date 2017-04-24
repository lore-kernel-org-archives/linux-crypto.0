From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Allow ecb(cipher_null) in FIPS mode
Date: Mon, 24 Apr 2017 18:21:46 +0800
Message-ID: <20170424102146.GA21181@gondor.apana.org.au>
References: <20170421110306.3343-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, gmazyland@gmail.com
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:47324 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1168460AbdDXKkD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 06:40:03 -0400
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

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
