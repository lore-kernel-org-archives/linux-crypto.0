From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt - remove AES-XTS-192 speed tests
Date: Thu, 3 Aug 2017 14:23:05 +0800
Message-ID: <20170803062305.GF12039@gondor.apana.org.au>
References: <1787722.TLPNYLEBHS@tauon.chronox.de>
 <20170719164032.17731-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>,
        Dan Douglass <dan.douglass@nxp.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58408 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdHCGXT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:23:19 -0400
Content-Disposition: inline
In-Reply-To: <20170719164032.17731-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 19, 2017 at 07:40:32PM +0300, Horia Geantă wrote:
> Remove xts(aes) speed tests with 2 x 192-bit keys, since implementations
> adhering strictly to IEEE 1619-2007 standard cannot cope with key sizes
> other than 2 x 128, 2 x 256 bits - i.e. AES-XTS-{128,256}:
> [...]
> tcrypt: test 5 (384 bit key, 16 byte blocks):
> caam_jr 8020000.jr: key size mismatch
> tcrypt: setkey() failed flags=200000
> [...]
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
