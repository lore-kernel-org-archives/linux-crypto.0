From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v18 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Tue, 3 Jul 2018 15:16:07 -0600
Message-ID: <81e128b6-b365-b2c8-d86e-50f40024eb9d@deltatee.com>
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
 <CAHp75VefGpNkF0ANA_wBm627aZXS60NPZ9VAdOYqr_iZ8Hvpzw@mail.gmail.com>
 <CAOMZO5Ayn4ik4F3sWhTo9Q5DGHG6nuf71M3DLsM+heMi0TFjVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
To: Fabio Estevam <festevam@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOMZO5Ayn4ik4F3sWhTo9Q5DGHG6nuf71M3DLsM+heMi0TFjVg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/3/2018 2:10 PM, Fabio Estevam wrote:
> On Tue, Jul 3, 2018 at 4:58 PM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> 
>> By the way, is there any URL which contains dmesg out of kernel with
>> this commit reverted?
> 
> Yes, here is the linux-next 20180626 dmesg (which is the last
> linux-next that does not contain 46e4bf08f63 and it boots fine) :
> https://storage.kernelci.org/next/master/next-20180626/arm/imx_v6_v7_defconfig/lab-baylibre-seattle/boot-imx6q-wandboard.html

Is this a virtual machine? And if so, any chance we can get an image and
qemu command line to run it ourselves?

Thanks,

Logan
