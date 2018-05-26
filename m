From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chtls - fix a missing-check bug
Date: Sun, 27 May 2018 00:27:29 +0800
Message-ID: <20180526162729.vwxxnr6po36ipz7h@gondor.apana.org.au>
References: <1526673338-486-1-git-send-email-wang6495@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kangjie Lu <kjlu@umn.edu>, Harsh Jain <harsh@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Michael Werner <werner@chelsio.com>,
        Casey Leedom <leedom@chelsio.com>,
        "open list:CXGB4 CRYPTO DRIVER (chcr)" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
To: Wenwen Wang <wang6495@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526673338-486-1-git-send-email-wang6495@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 18, 2018 at 02:55:35PM -0500, Wenwen Wang wrote:
> In do_chtls_setsockopt(), the tls crypto info is first copied from the
> poiner 'optval' in userspace and saved to 'tmp_crypto_info'. Then the
> 'version' of the crypto info is checked. If the version is not as expected,
> i.e., TLS_1_2_VERSION, error code -ENOTSUPP is returned to indicate that
> the provided crypto info is not supported yet. Then, the 'cipher_type'
> field of the 'tmp_crypto_info' is also checked to see if it is
> TLS_CIPHER_AES_GCM_128. If it is, the whole struct of
> tls12_crypto_info_aes_gcm_128 is copied from the pointer 'optval' and then
> the function chtls_setkey() is invoked to set the key.
> 
> Given that the 'optval' pointer resides in userspace, a malicious userspace
> process can race to change the data pointed by 'optval' between the two
> copies. For example, a user can provide a crypto info with TLS_1_2_VERSION
> and TLS_CIPHER_AES_GCM_128. After the first copy, the user can modify the
> 'version' and the 'cipher_type' fields to any versions and/or cipher types
> that are not allowed. This way, the user can bypass the checks, inject
> bad data to the kernel, cause chtls_setkey() to set a wrong key or other
> issues.
> 
> This patch reuses the data copied in the first try so as to ensure these
> checks will not be bypassed.
> 
> Signed-off-by: Wenwen Wang <wang6495@umn.edu>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
