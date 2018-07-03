From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v18 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Tue, 3 Jul 2018 20:55:59 -0300
Message-ID: <CAOMZO5CoFy=v+7wo5juZRbqLrvuuO7==Ma8hU7paEPARm-yyzw@mail.gmail.com>
References: <20180622194752.11221-1-logang@deltatee.com> <20180622194752.11221-7-logang@deltatee.com>
 <CAOMZO5DpwPsidKQ9wfe8mNTgdOpkdHHgqHMa4yQBx9uRrfFmww@mail.gmail.com>
 <CAHp75VcCNsx2sHcYG2aNiw354exTvO=NUOS9P_BTmcM3siAepg@mail.gmail.com>
 <13ea3f97-4a33-3a24-1b7e-b819be73d867@deltatee.com> <CAOMZO5CfUfNZd0kG=VVnH4BjP+XMpGh3bPCUrTwi_4w6YEGX7g@mail.gmail.com>
 <CAHp75VcDudrwV4kRnVR+vtddFhxHsU672YqOJgPPchuLvPV3nA@mail.gmail.com>
 <CAOMZO5A4bsu9dXCPb4QeSbnnLi=pr1=WYWn8p2AfU3rEG=RWXg@mail.gmail.com>
 <6e5224b9-343f-990c-19bd-fe37c6fbdc9b@deltatee.com> <CAOMZO5CJ_iG=p_+xL=Q_Rv3F5vtGggsgatar4XVTL+UFVnHBTA@mail.gmail.com>
 <CAHp75VefGpNkF0ANA_wBm627aZXS60NPZ9VAdOYqr_iZ8Hvpzw@mail.gmail.com>
 <CAOMZO5Ayn4ik4F3sWhTo9Q5DGHG6nuf71M3DLsM+heMi0TFjVg@mail.gmail.com> <CAHp75VepHb5BaGmB_2eBmMrmyeAAOih9GE4E34s49gDbvKskgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Logan Gunthorpe <logang@deltatee.com>,
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
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VepHb5BaGmB_2eBmMrmyeAAOih9GE4E34s49gDbvKskgA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 3, 2018 at 5:40 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:

> And here just a wild guess, if you comment out a BUG() in IRQ handler,
> does it boot?

Not really. It fails a bit later:

[    3.863231] caam 2100000.caam: Entropy delay = 3200
[    3.929028] caam 2100000.caam: Instantiated RNG4 SH0
[    3.989789] caam 2100000.caam: Instantiated RNG4 SH1
[    3.994809] caam 2100000.caam: device ID = 0x0a16010000000000 (Era 4)
[    4.001313] caam 2100000.caam: job rings = 2, qi = 0
[    4.019569]  mmcblk1: p1 p2
[    4.021007] caam algorithms registered in /proc/crypto
[    4.030633] caam_jr 2101000.jr0: job ring error: irqstate: 00000103
[    4.037036] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
[    4.043751] Modules linked in:
[    4.046829] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
4.18.0-rc3-next-20180703-00001-g62a05d4-dirty #498
[    4.056317] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[    4.062869] PC is at caam_jr_dequeue+0x240/0x2bc
[    4.067499] LR is at 0x1
[    4.070042] pc : [<c075e6bc>]    lr : [<00000001>]    psr: 60000113
[    4.076317] sp : c1001d58  ip : ec85c000  fp : c1001da4
[    4.081549] r10: ec858010  r9 : ec85c000  r8 : 00000000
[    4.086783] r7 : 000001ff  r6 : 00000001  r5 : 00000000  r4 : 00000000
[    4.093318] r3 : ffffffff  r2 : 00000000  r1 : 00000000  r0 : 00000001
[    4.099856] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    4.106999] Control: 10c5387d  Table: 1000404a  DAC: 00000051
[    4.112754] Process swapper/0 (pid: 0, stack limit = 0x(ptrval))
[    4.118771] Stack: (0xc1001d58 to 0xc1002000)
