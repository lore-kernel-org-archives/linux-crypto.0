From: Paul Burton <paul.burton@mips.com>
Subject: Re: [PATCH net-next v5 06/20] zinc: ChaCha20 MIPS32r2 implementation
Date: Tue, 18 Sep 2018 20:25:51 +0000
Message-ID: <20180918202549.ogfyunppxaha7sfu@pburton-laptop>
References: <20180918161646.19105-1-Jason@zx2c4.com>
 <20180918161646.19105-7-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        =?iso-8859-1?Q?Ren=E9_van_Dorst?= <opensource@vdorst.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918161646.19105-7-Jason@zx2c4.com>
Content-Language: en-US
Content-ID: <63642532067635489B41DE900E363F85@namprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason,

On Tue, Sep 18, 2018 at 06:16:32PM +0200, Jason A. Donenfeld wrote:
> +.Lchacha20_mips_xor_aligned_4_b:
> +	/* STORE_ALIGNED( 4,  0, $sp, 0+CONSTANT_OFS_SP) */
> +	lw	T0, 0+CONSTANT_OFS_SP($sp)
> +	lw	T1, 0(IN)
> +	addu	X0, T0
> +	CPU_TO_LE32(X0)
> +	xor	X0, T1
> +	.set noreorder
> +	bne	OUT, PTR_LAST_ROUND, .Loop_chacha20_rounds
> +	sw	X0, 0(OUT)
> +	.set reorder
> +
> +	.set noreorder
> +	bne	$at, BYTES, .Lchacha20_mips_xor_bytes
> +	/* Empty delayslot, Increase NONCE_0, return NONCE_0 value */
> +	addiu	NONCE_0, 1
> +	.set noreorder

Should this be .set reorder?

Even better - could we not just place the addiu before the bne & drop
the .set noreorder, allowing the assembler to fill the delay slot with
the addiu? Likewise in many other places throughout the patch.

That would be more future proof - particularly if we ever want to adjust
this for use with the nanoMIPS ISA which has no delay slots. It may also
allow the assembler the choice to use compact branches (ie. branches
without visible delay slots) when targeting MIPS32r6. I know neither of
these will currently build this code, but I think avoiding all the
noreorder blocks would be a nice cleanup just for the sake of
readability anyway.

Thanks,
    Paul
