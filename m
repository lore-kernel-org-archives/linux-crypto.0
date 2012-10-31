From: David McCullough <ucdevel@gmail.com>
Subject: Re: [PATCH] [RFC] crypto: sha1/arm - fix build with
 CONFIG_THUMB2_KERNEL
Date: Wed, 31 Oct 2012 10:25:00 +1000
Message-ID: <20121031002457.GB6972@spottygum.com>
References: <20121030100742.17910.70241.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: David McCullough <ucdevel@gmail.com>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20121030100742.17910.70241.stgit@localhost6.localdomain6>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org


Jussi Kivilinna wrote the following:
> Building cryptodev-2.6 tree with CONFIG_THUMB2_KERNEL=y and
> CONFIG_CRYPTO_SHA1_ARM=y give following error:
> 
>    AS      arch/arm/crypto/sha1-armv4-large.o
> arch/arm/crypto/sha1-armv4-large.S: Assembler messages:
> arch/arm/crypto/sha1-armv4-large.S:197: Error: r13 not allowed here --
> `teq r14,sp'
> arch/arm/crypto/sha1-armv4-large.S:377: Error: r13 not allowed here --
> `teq r14,sp'
> arch/arm/crypto/sha1-armv4-large.S:469: Error: r13 not allowed here --
> `teq r14,sp'
> 
> Build can be fixed with adding '.arm' at head of sha1-armv4-large.S.
> However I'm not sure if this correct fix as this is my first stab
> at arm assembler and I could not get CONFIG_THUMB2_KERNEL boot up
> on 'qemu-system-arm -M vexpress-a9' to verify correctness. So this
> is only build tested.

That fixes the problem for the assembler,  in that you have forced it to
treat the code as 32 bit (non-thumb).

I know you can mix thumb and non-thumb code,  and it seems that as long as
all parties know what code is in what mode it should work.

Unfortunately I don't know enough about it be sure this is a valid fix.
I think we need a long term arm expert to pass judgement on this one,
unless of source you manage to get it tested.  I don't have any thumb
targets I can try it on, sory,

Cheers,
Davidm

> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-crypto@vger.kernel.org
> Cc: David McCullough <ucdevel@gmail.com>
> ---
>  arch/arm/crypto/sha1-armv4-large.S |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/crypto/sha1-armv4-large.S b/arch/arm/crypto/sha1-armv4-large.S
> index 7050ab1..e8a55eb 100644
> --- a/arch/arm/crypto/sha1-armv4-large.S
> +++ b/arch/arm/crypto/sha1-armv4-large.S
> @@ -53,6 +53,8 @@
>  
>  .text
>  
> +.arm
> +
>  .global	sha1_block_data_order
>  .type	sha1_block_data_order,%function
>  
> 

-- 
David McCullough,  davidm@spottygum.com,   Ph: 0410 560 763
