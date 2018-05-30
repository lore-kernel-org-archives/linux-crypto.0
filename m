From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/5] crypto: ccree: cleanup, fixes and R-Car enabling
Date: Thu, 31 May 2018 00:28:04 +0800
Message-ID: <20180530162804.zp4n22nprqmigywz@gondor.apana.org.au>
References: <1527171551-21979-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527171551-21979-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 24, 2018 at 03:19:05PM +0100, Gilad Ben-Yossef wrote:
> The patch set enables the use of CryptoCell found in some Renesas R-Car
> Salvator-X boards and fixes some driver issues uncovered that prevented
> to work properly.
> 
> Changes from v1:
> - Properly fix the bug that caused us to read a bad signature register
>   rather than dropping the check
> - Proper DT fields as indicated by Geert Uytterhoeven.
> - Better clock enabling as suggested by Geert Uytterhoeven.
> 
> Note! the last two patches in the set depend on the
> "clk: renesas: r8a7795: Add CR clock" patch from Geert Uytterhoeven.

Patches 1-3 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
