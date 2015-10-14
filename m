From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/pkcs7_verify: Fix unaligned access in
 pkcs7_verify()
Date: Wed, 14 Oct 2015 22:29:15 +0800
Message-ID: <20151014142915.GI17455@gondor.apana.org.au>
References: <20151013145401.GM20800@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, dhowells@redhat.com, marcel@holtmann.org,
	David.Woodhouse@intel.com
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151013145401.GM20800@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 13, 2015 at 10:54:01AM -0400, Sowmini Varadhan wrote:
> 
> On sparc, we see unaligned access messages on each modprobe[-r]:
> 
> Kernel unaligned access at TPC[6ad9b4] pkcs7_verify [..]
> Kernel unaligned access at TPC[6a5484] crypto_shash_finup [..]
> Kernel unaligned access at TPC[6a5390] crypto_shash_update [..]
> Kernel unaligned access at TPC[10150308] sha1_sparc64_update [..]
> Kernel unaligned access at TPC[101501ac] __sha1_sparc64_update [..]
> 
> These ware triggered by mod_verify_sig() invocations of pkcs_verify(), and
> are are being caused by an unaligned desc at (sha1, digest_size is 0x14)
>         desc = digest + digest_size;
> 
> To fix this, pkcs7_verify needs to make sure that desc is pointing
> at an aligned value past the digest_size, and kzalloc appropriately,
> taking alignment values into consideration.
> 
> Signed-off-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
