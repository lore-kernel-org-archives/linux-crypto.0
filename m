From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 0/6] lib/crc32: treewide: Use existing define with polynomial
Date: Wed, 18 Jul 2018 08:33:56 +0200
Message-ID: <CAJKOXPdOrp07+YsEhsti6WLND6We2q_R=30cCWdaBgmEWkS5Ww@mail.gmail.com>
References: <20180717160541.3843-1-krzk@kernel.org> <20180718001258.GA210746@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
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
        linux-arm-kern
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718001258.GA210746@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18 July 2018 at 02:12, Eric Biggers <ebiggers3@gmail.com> wrote:
> Hi Krzysztof,
>
> On Tue, Jul 17, 2018 at 06:05:35PM +0200, Krzysztof Kozlowski wrote:
>> Hi,
>>
>> Kernel defines same polynomial for CRC-32 in few places.
>> This is unnecessary duplication of the same value. Also this might
>> be error-prone for future code - every driver will define the
>> polynomial again.
>>
>> This is an attempt to unify definition of polynomial.  Few obvious
>> hard-coded locations are fixed with define.
>>
>> All series depend on each 1/6 and 2/6.
>>
>> This could be merged in two different merge windows (1st lib/crc and then
>> the rest) or taken through one tree.
>>
>> It would be nice to get some testing. Only generic lib/crc, bunzip, xz_crc32
>> and Freescale's Ethernet driver were tested on HW.  Rest got just different
>> builds.
>>
>> Best regards,
>> Krzysztof
>>
>> Krzysztof Kozlowski (6):
>>   lib/crc: Move polynomial definition to separate header
>>   lib/crc: Use consistent naming for CRC-32 polynomials
>>   crypto: stm32_crc32 - Use existing define with polynomial
>>   net: ethernet: Use existing define with polynomial
>>   staging: rtl: Use existing define with polynomial
>>   lib: Use existing define with polynomial
>>
>>  drivers/crypto/stm32/stm32_crc32.c               | 11 ++++-------
>>  drivers/net/ethernet/amd/xgbe/xgbe-dev.c         |  4 ++--
>>  drivers/net/ethernet/apple/bmac.c                |  8 ++------
>>  drivers/net/ethernet/broadcom/tg3.c              |  3 ++-
>>  drivers/net/ethernet/freescale/fec_main.c        |  4 ++--
>>  drivers/net/ethernet/freescale/fs_enet/fec.h     |  3 ---
>>  drivers/net/ethernet/freescale/fs_enet/mac-fec.c |  3 ++-
>>  drivers/net/ethernet/micrel/ks8851_mll.c         |  3 ++-
>>  drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c    |  4 ++--
>>  drivers/staging/rtl8712/rtl871x_security.c       |  5 ++---
>>  drivers/staging/rtl8723bs/core/rtw_security.c    |  5 ++---
>>  include/linux/crc32poly.h                        | 20 ++++++++++++++++++++
>>  lib/crc32.c                                      | 11 ++++++-----
>>  lib/crc32defs.h                                  | 14 --------------
>>  lib/decompress_bunzip2.c                         |  3 ++-
>>  lib/gen_crc32table.c                             |  5 +++--
>>  lib/xz/xz_crc32.c                                |  3 ++-
>>  17 files changed, 55 insertions(+), 54 deletions(-)
>>  create mode 100644 include/linux/crc32poly.h
>>
>
> Did you check whether any of these users can be converted to use the CRC
> implementations in lib/, so they wouldn't need the polynomial definition
> themselves?

I did not check but that's interesting point... The Ethernet drivers
(xgbe, tg3, fec, ks8851, dwc-xlgmac) look like could be converted to
generic implementation. The apple/bmac looks weird. The rtl WiFi
drivers in long term can be converted to use generic lib80211 for
encryption (see commit 0d4876f4e977 ("staging:r8188eu: Use lib80211 to
encrypt (TKIP) tx frames")) but that is much bigger task. The
remaining use the polynomials in different aspect:
1. XZ and BUNZIP use it to create CRC tables - probably generic
gen_crc32table.c could be used,
2. stm32_crc32.c uses it to initialize HW CRC accelerator.

I can work on Freescale FEC, xz and bunzip code because these I can
test but I would prefer to do it as follow up.

Best regards,
Krzysztof
