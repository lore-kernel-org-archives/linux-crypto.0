From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] lib/crc32: treewide: Use existing define with
 polynomial
Date: Sat, 28 Jul 2018 00:05:13 +0800
Message-ID: <20180727160513.fluthoaj24co2khr@gondor.apana.org.au>
References: <20180717160541.3843-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180717160541.3843-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 17, 2018 at 06:05:35PM +0200, Krzysztof Kozlowski wrote:
> Hi,
> 
> Kernel defines same polynomial for CRC-32 in few places.
> This is unnecessary duplication of the same value. Also this might
> be error-prone for future code - every driver will define the
> polynomial again.
> 
> This is an attempt to unify definition of polynomial.  Few obvious
> hard-coded locations are fixed with define.
> 
> All series depend on each 1/6 and 2/6.
> 
> This could be merged in two different merge windows (1st lib/crc and then
> the rest) or taken through one tree.
> 
> It would be nice to get some testing. Only generic lib/crc, bunzip, xz_crc32
> and Freescale's Ethernet driver were tested on HW.  Rest got just different
> builds.
> 
> Best regards,
> Krzysztof
> 
> 
> 
> 
> Krzysztof Kozlowski (6):
>   lib/crc: Move polynomial definition to separate header
>   lib/crc: Use consistent naming for CRC-32 polynomials
>   crypto: stm32_crc32 - Use existing define with polynomial
>   net: ethernet: Use existing define with polynomial
>   staging: rtl: Use existing define with polynomial
>   lib: Use existing define with polynomial
> 
>  drivers/crypto/stm32/stm32_crc32.c               | 11 ++++-------
>  drivers/net/ethernet/amd/xgbe/xgbe-dev.c         |  4 ++--
>  drivers/net/ethernet/apple/bmac.c                |  8 ++------
>  drivers/net/ethernet/broadcom/tg3.c              |  3 ++-
>  drivers/net/ethernet/freescale/fec_main.c        |  4 ++--
>  drivers/net/ethernet/freescale/fs_enet/fec.h     |  3 ---
>  drivers/net/ethernet/freescale/fs_enet/mac-fec.c |  3 ++-
>  drivers/net/ethernet/micrel/ks8851_mll.c         |  3 ++-
>  drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c    |  4 ++--
>  drivers/staging/rtl8712/rtl871x_security.c       |  5 ++---
>  drivers/staging/rtl8723bs/core/rtw_security.c    |  5 ++---
>  include/linux/crc32poly.h                        | 20 ++++++++++++++++++++
>  lib/crc32.c                                      | 11 ++++++-----
>  lib/crc32defs.h                                  | 14 --------------
>  lib/decompress_bunzip2.c                         |  3 ++-
>  lib/gen_crc32table.c                             |  5 +++--
>  lib/xz/xz_crc32.c                                |  3 ++-
>  17 files changed, 55 insertions(+), 54 deletions(-)
>  create mode 100644 include/linux/crc32poly.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
