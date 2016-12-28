From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 1/3] crypto: chacha20 - convert generic and x86
 versions to skcipher
Date: Wed, 28 Dec 2016 09:23:07 +0000
Message-ID: <C46A3CDE-2329-4171-B4C5-071423EC3B4B@linaro.org>
References: <1481294033-23508-1-git-send-email-ard.biesheuvel@linaro.org>
 <1481294033-23508-2-git-send-email-ard.biesheuvel@linaro.org>
 <20161227100452.GB10629@gondor.apana.org.au>
 <20161228091801.GA12318@gondor.apana.org.au>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20161228091801.GA12318@gondor.apana.org.au>
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



> On 28 Dec 2016, at 09:18, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
>> On Tue, Dec 27, 2016 at 06:04:52PM +0800, Herbert Xu wrote:
>>> On Fri, Dec 09, 2016 at 02:33:51PM +0000, Ard Biesheuvel wrote:
>>> This converts the ChaCha20 code from a blkcipher to a skcipher, which
>>> is now the preferred way to implement symmetric block and stream ciphers.
>>> 
>>> This ports the generic and x86 versions at the same time because the
>>> latter reuses routines of the former.
>>> 
>>> Note that the skcipher_walk() API guarantees that all presented blocks
>>> except the final one are a multiple of the chunk size, so we can simplify
>>> the encrypt() routine somewhat.
>>> 
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> 
>> Patch applied.  Thanks.
> 
> I'm reverting this patch because it breaks the build on ARM without
> the two subsequent patches.
> 
> When resubmitting please make sure that the kernel can build and
> work after each patch.  Otherwise git bisections will fail.
> 

Ehm, could you keep this one and revert the other two instead please?  This patch will not change in the respin, and the other two are blkciphers rather than skciphers (and in the arm64 version, I optimized the asm code as well) so they will look rather different ( as they do in the nacked v2)

> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
