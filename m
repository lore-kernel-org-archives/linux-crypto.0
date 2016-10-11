From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/6] crypto: arm64 - big endian fixes
Date: Tue, 11 Oct 2016 12:01:56 +0100
Message-ID: <CAKv+Gu-sxi7LXt=W9gCZUVDT8RXk8T0oqFk9m-n0WKidFoHXkA@mail.gmail.com>
References: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu9Nj5ccpRpgqg9Ohif4=k5+dAVuP8tKtNEj9_z7BQ_jjQ@mail.gmail.com>
 <20161011021247.GA10976@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20161011021247.GA10976@gondor.apana.org.au>
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

On 11 October 2016 at 03:12, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Oct 10, 2016 at 12:26:00PM +0100, Ard Biesheuvel wrote:
>>
>> /* This piece of crap needs to disappear into per-type test hooks. */
>> if (!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
>>      CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV) &&
>>    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
>>     CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
>> alg->cra_ablkcipher.ivsize))
>> type |= CRYPTO_ALG_TESTED;
>>
>> This causes cbc(aes), ctr(aes) and xts(aes) to remain untested, unless
>> I add CRYPTO_ALG_GENIV to their cra_flags. Is this expected behavior?
>> What would be your recommended way to ensure these algos are covered
>> by the boottime tests?
>
> This is a leftover from the old blkcipher/ablkcipher interface.
> I've got a patch pending which will remove this if clause.
>

OK, thanks.

So I will follow up with a v2 of this series with two additional fixes.
