From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-next: build failure after merge of the crypto tree
Date: Wed, 20 Jul 2016 22:32:50 +0800
Message-ID: <20160720143250.GA3323@gondor.apana.org.au>
References: <20160720174634.53bad636@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160720174634.53bad636@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 20, 2016 at 05:46:34PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the dax-misc tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/crypto/vmx/aesp8-ppc.S: Assembler messages:
> drivers/crypto/vmx/aesp8-ppc.S:2036: Error: symbol `.aes_p8_xts_decrypt' is already defined
> 
> Caused by commit
> 
>   11c6e16ee13a ("crypto: vmx - Adding asm subroutines for XTS")
> 
> I have reverted that commit (and commit c07f5d3da643 ("crypto: vmx -
> Adding support for XTS")) for today.

Thanks Stephen.  I think this patch should fix it.

---8<---
Subject: crypto: vmx - Fix aes_p8_xts_decrypt build failure

We use _GLOBAL so there is no need to do the manual alignment,
in fact it causes a build failure.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
index 813ffcc..0b4a293 100644
--- a/drivers/crypto/vmx/aesp8-ppc.pl
+++ b/drivers/crypto/vmx/aesp8-ppc.pl
@@ -2125,8 +2125,6 @@ Lxts_enc_ret:
 .size	.${prefix}_xts_encrypt,.-.${prefix}_xts_encrypt
 
 .globl	.${prefix}_xts_decrypt
-.align	5
-.${prefix}_xts_decrypt:
 	mr		$inp,r3				# reassign
 	li		r3,-1
 	${UCMP}i	$len,16
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
