From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: arm - add build time test for CRC
 instruction support
Date: Wed, 1 Mar 2017 19:52:10 +0800
Message-ID: <20170301115210.GB11489@gondor.apana.org.au>
References: <1488292617-27317-1-git-send-email-ard.biesheuvel@linaro.org>
 <1488292617-27317-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: arnd@arndb.de, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, jonathanh@nvidia.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1488292617-27317-2-git-send-email-ard.biesheuvel@linaro.org>
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

On Tue, Feb 28, 2017 at 02:36:57PM +0000, Ard Biesheuvel wrote:
> The accelerated CRC32 module for ARM may use either the scalar CRC32
> instructions, the NEON 64x64 to 128 bit polynomial multiplication
> (vmull.p64) instruction, or both, depending on what the current CPU
> supports.
> 
> However, this also requires support in binutils, and as it turns out,
> versions of binutils exist that support the vmull.p64 instruction but
> not the crc32 instructions.
> 
> So refactor the Makefile logic so that this module only gets built if
> binutils has support for both.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
