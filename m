From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.3
Date: Tue, 13 Oct 2015 20:17:50 +0800
Message-ID: <20151013121750.GA6408@gondor.apana.org.au>
References: <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150908092502.GA8332@gondor.apana.org.au>
 <20150916103014.GA12315@gondor.apana.org.au>
 <20150926200133.GA19035@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150926200133.GA19035@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes the following issues:

* Fix AVX detection to prevent use of non-existent AESNI.
* Some SPARC ciphers did not set their IV size which may lead
  to memory corruption.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Ben Hutchings (1):
      crypto: camellia_aesni_avx - Fix CPU feature checks

Dave Kleikamp (1):
      crypto: sparc - initialize blkcipher.ivsize

 arch/sparc/crypto/aes_glue.c              |    2 ++
 arch/sparc/crypto/camellia_glue.c         |    1 +
 arch/sparc/crypto/des_glue.c              |    2 ++
 arch/x86/crypto/camellia_aesni_avx_glue.c |    5 +++++
 4 files changed, 10 insertions(+)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
