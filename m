From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.8
Date: Fri, 23 Sep 2016 22:48:35 +0800
Message-ID: <20160923144835.GA20135@gondor.apana.org.au>
References: <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
 <20160801095821.GA1260@gondor.apana.org.au>
 <20160905093318.GA30895@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160905093318.GA30895@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes a regression RSA that was only half-fixed earlier
in the cycle.  It also fixes an older regression that breaks the
keyring subsystem.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (2):
      KEYS: Fix skcipher IV clobbering
      crypto: rsa-pkcs1pad - Handle leading zero for decryption

 crypto/rsa-pkcs1pad.c                    |   41 +++++++++++++++++-------------
 security/keys/encrypted-keys/encrypted.c |   11 +++++---
 2 files changed, 31 insertions(+), 21 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
