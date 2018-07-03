From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v18 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Tue, 3 Jul 2018 20:52:37 -0300
Message-ID: <CAOMZO5CGT7TbpWEAWEA7qTxuGO1mog_QDhG-e0MuDDckUS2W3A@mail.gmail.com>
References: <20180622194752.11221-1-logang@deltatee.com> <20180622194752.11221-7-logang@deltatee.com>
 <CAOMZO5DpwPsidKQ9wfe8mNTgdOpkdHHgqHMa4yQBx9uRrfFmww@mail.gmail.com>
 <CAHp75VcCNsx2sHcYG2aNiw354exTvO=NUOS9P_BTmcM3siAepg@mail.gmail.com>
 <13ea3f97-4a33-3a24-1b7e-b819be73d867@deltatee.com> <CAOMZO5CfUfNZd0kG=VVnH4BjP+XMpGh3bPCUrTwi_4w6YEGX7g@mail.gmail.com>
 <CAHp75VcDudrwV4kRnVR+vtddFhxHsU672YqOJgPPchuLvPV3nA@mail.gmail.com>
 <CAOMZO5A4bsu9dXCPb4QeSbnnLi=pr1=WYWn8p2AfU3rEG=RWXg@mail.gmail.com>
 <6e5224b9-343f-990c-19bd-fe37c6fbdc9b@deltatee.com> <CAOMZO5CJ_iG=p_+xL=Q_Rv3F5vtGggsgatar4XVTL+UFVnHBTA@mail.gmail.com>
 <7ddda181-6337-32cc-7a0d-43fc6a7ba78b@deltatee.com> <CAHp75VcN=pUkFK6=_7yErMRGNS3WsgBhkWMSwP0Cw_ZmGR=RJg@mail.gmail.com>
 <c64cd9c9-3eb5-acbd-3578-b32ec39d3ea4@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c64cd9c9-3eb5-acbd-3578-b32ec39d3ea4@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 3, 2018 at 8:20 PM, Logan Gunthorpe <logang@deltatee.com> wrote:

> Oh. So some IO in some other place must have changed to trigger the BUG...

Yes, there are two 64-bit write operations inside caam_jr_init().

If I use the old 64-bit write function then things works fine:

--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -384,6 +384,17 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 }
 EXPORT_SYMBOL(caam_jr_enqueue);

+static inline void wr_reg64old(void __iomem *reg, u64 data)
+{
+       if (!caam_imx && caam_little_end) {
+               wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);
+               wr_reg32((u32 __iomem *)(reg), data);
+       } else {
+               wr_reg32((u32 __iomem *)(reg), data >> 32);
+               wr_reg32((u32 __iomem *)(reg) + 1, data);
+ }
+}
+
 /*
  * Init JobR independent of platform property detection
  */
@@ -434,8 +445,8 @@ static int caam_jr_init(struct device *dev)
  jrp->head = 0;
  jrp->tail = 0;

- wr_reg64(&jrp->rregs->inpring_base, inpbusaddr);
- wr_reg64(&jrp->rregs->outring_base, outbusaddr);
+ wr_reg64old(&jrp->rregs->inpring_base, inpbusaddr);
+ wr_reg64old(&jrp->rregs->outring_base, outbusaddr);
  wr_reg32(&jrp->rregs->inpring_size, JOBR_DEPTH);
  wr_reg32(&jrp->rregs->outring_size, JOBR_DEPTH);
