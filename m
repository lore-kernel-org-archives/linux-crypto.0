From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v18 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Tue, 3 Jul 2018 17:57:55 -0600
Message-ID: <991b2298-bb3f-dad3-c93b-b43ee5f372de@deltatee.com>
References: <20180622194752.11221-1-logang@deltatee.com>
 <20180622194752.11221-7-logang@deltatee.com>
 <CAOMZO5DpwPsidKQ9wfe8mNTgdOpkdHHgqHMa4yQBx9uRrfFmww@mail.gmail.com>
 <CAHp75VcCNsx2sHcYG2aNiw354exTvO=NUOS9P_BTmcM3siAepg@mail.gmail.com>
 <13ea3f97-4a33-3a24-1b7e-b819be73d867@deltatee.com>
 <CAOMZO5CfUfNZd0kG=VVnH4BjP+XMpGh3bPCUrTwi_4w6YEGX7g@mail.gmail.com>
 <CAHp75VcDudrwV4kRnVR+vtddFhxHsU672YqOJgPPchuLvPV3nA@mail.gmail.com>
 <CAOMZO5A4bsu9dXCPb4QeSbnnLi=pr1=WYWn8p2AfU3rEG=RWXg@mail.gmail.com>
 <6e5224b9-343f-990c-19bd-fe37c6fbdc9b@deltatee.com>
 <CAOMZO5CJ_iG=p_+xL=Q_Rv3F5vtGggsgatar4XVTL+UFVnHBTA@mail.gmail.com>
 <7ddda181-6337-32cc-7a0d-43fc6a7ba78b@deltatee.com>
 <CAHp75VcN=pUkFK6=_7yErMRGNS3WsgBhkWMSwP0Cw_ZmGR=RJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Fabio Estevam <festevam@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VcN=pUkFK6=_7yErMRGNS3WsgBhkWMSwP0Cw_ZmGR=RJg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 03/07/18 04:21 PM, Andy Shevchenko wrote:
> It is an explicit call to BUG().
> That's why we see wrong instruction trap.

Ok, I think I see the problem... the code is rather confusing:

Prior to the patch, IOs were BE depending on caam_little_end but if
caam_imx was set, then it wrote two LE writes with the high one first.
After the patch, it writes two BE writes with the high one first.

To confirm, can you try the patch below?

If this is the case, we can either revert the commit or fold in this
patch depending on what others think is clearer.

Thanks,

Logan

--

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 5826acd9194e..5f70c460da25 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -138,10 +138,14 @@ static inline void clrsetbits_32(void __iomem
*reg, u32 clear, u32 set)
  */
 static inline void wr_reg64(void __iomem *reg, u64 data)
 {
-       if (!caam_imx && caam_little_end)
+       if (caam_imx && caam_little_end) {
+               iowrite32(data >> 32, reg);
+               iowrite32(data, reg + sizeof(u32));
+       } else if (caam_little_end) {
                iowrite64(data, reg);
-       else
+       } else {
                iowrite64be(data, reg);
+       }
 }

 static inline u64 rd_reg64(void __iomem *reg)
