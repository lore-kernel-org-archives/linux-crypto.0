From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm64/aes - fix handling sub-block CTS-CBC inputs
Date: Mon, 8 Oct 2018 13:53:13 +0800
Message-ID: <20181008055313.escoye4faoo2qbh5@gondor.apana.org.au>
References: <20181003052215.22468-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20181003052215.22468-1-ebiggers@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 02, 2018 at 10:22:15PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In the new arm64 CTS-CBC implementation, return an error code rather
> than crashing on inputs shorter than AES_BLOCK_SIZE bytes.  Also set
> cra_blocksize to AES_BLOCK_SIZE (like is done in the cts template) to
> indicate the minimum input size.
> 
> Fixes: dd597fb33ff0 ("crypto: arm64/aes-blk - add support for CTS-CBC mode")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
