From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 06/20] zinc: ChaCha20 MIPS32r2 implementation
Date: Thu, 20 Sep 2018 15:19:06 +0200
Message-ID: <CAHmME9rm9dqa6wtBDLngdXfv+3DCCsgM51z9nbGg3Bb_Q_zdwg@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-7-Jason@zx2c4.com>
 <20180918202549.ogfyunppxaha7sfu@pburton-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, jhogan@kernel.org,
        linux-mips@linux-mips.org
To: paul.burton@mips.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918202549.ogfyunppxaha7sfu@pburton-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Paul,

Thanks a bunch for the review.

On Tue, Sep 18, 2018 at 10:25 PM Paul Burton <paul.burton@mips.com> wrote:
> Should this be .set reorder?

Nice catch. Fixed here:
https://git.zx2c4.com/WireGuard/commit/?id=23d97fc333cf85dd07445a9d21a28cbef47c553c
But then...

> Even better - could we not just place the addiu before the bne & drop
> the .set noreorder, allowing the assembler to fill the delay slot with
> the addiu? Likewise in many other places throughout the patch.
>
> That would be more future proof - particularly if we ever want to adjust
> this for use with the nanoMIPS ISA which has no delay slots. It may also
> allow the assembler the choice to use compact branches (ie. branches
> without visible delay slots) when targeting MIPS32r6. I know neither of
> these will currently build this code, but I think avoiding all the
> noreorder blocks would be a nice cleanup just for the sake of
> readability anyway.

Great idea. Rene has committed that here:
https://git.zx2c4.com/WireGuard/commit/?id=5c153a59ac3aa58a3ff17c69fee63d599e5f2758

These will be in the v6 patchset whenever that's posted, and it's
already been merged into the dev tree:
https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/log/?h=jd/wireguard

Regards,
Jason
