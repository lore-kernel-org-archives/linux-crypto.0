Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48478 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfARK4u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 05:56:50 -0500
Date: Fri, 18 Jan 2019 18:56:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - split akcipher tests by a key type
Message-ID: <20190118105645.w7hpezhdsme7lzev@gondor.apana.org.au>
References: <20190107175427.13261-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107175427.13261-1-vt@altlinux.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 07, 2019 at 08:54:27PM +0300, Vitaly Chikunov wrote:
> Before this, if akcipher_testvec have `public_key_vec' set to true
> (i.e. having a public key) only sign/encrypt test is performed, but
> verify/decrypt test is skipped.
> 
> With a public key we could do encrypt and verify, but to sign and decrypt
> a private key is required.
> 
> This logic is correct for encrypt/decrypt tests (decrypt is skipped if
> no private key). But incorrect for sign/verify tests - sign is performed
> no matter if there is no private key, but verify is skipped if there is
> a public key.
> 
> Rework `test_akcipher_one' to arrange tests properly depending on value
> of `public_key_vec` and `siggen_sigver_test'.
> 
> No tests were missed since there is only one sign/verify test (which
> have `siggen_sigver_test' set to true) and it has a private key, but
> future tests could benefit from this improvement.
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>  crypto/testmgr.c | 86 +++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 57 insertions(+), 29 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
