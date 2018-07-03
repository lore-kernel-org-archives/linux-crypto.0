From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v18 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Tue, 3 Jul 2018 12:47:01 -0600
Message-ID: <6e5224b9-343f-990c-19bd-fe37c6fbdc9b@deltatee.com>
References: <20180622194752.11221-1-logang@deltatee.com>
 <20180622194752.11221-7-logang@deltatee.com>
 <CAOMZO5DpwPsidKQ9wfe8mNTgdOpkdHHgqHMa4yQBx9uRrfFmww@mail.gmail.com>
 <CAHp75VcCNsx2sHcYG2aNiw354exTvO=NUOS9P_BTmcM3siAepg@mail.gmail.com>
 <13ea3f97-4a33-3a24-1b7e-b819be73d867@deltatee.com>
 <CAOMZO5CfUfNZd0kG=VVnH4BjP+XMpGh3bPCUrTwi_4w6YEGX7g@mail.gmail.com>
 <CAHp75VcDudrwV4kRnVR+vtddFhxHsU672YqOJgPPchuLvPV3nA@mail.gmail.com>
 <CAOMZO5A4bsu9dXCPb4QeSbnnLi=pr1=WYWn8p2AfU3rEG=RWXg@mail.gmail.com>
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
In-Reply-To: <CAOMZO5A4bsu9dXCPb4QeSbnnLi=pr1=WYWn8p2AfU3rEG=RWXg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On 03/07/18 12:11 PM, Fabio Estevam wrote:
> On Tue, Jul 3, 2018 at 3:09 PM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> 
>> Btw, what is the environment did you use to build it?
>> and what is the environment / make variable you supply (like ARCH,
>> CROSS_COMPILE, etc)?
> 
> I build it on a Dell laptop running Ubuntu 16.04 with the following
> variables exported:
> 
> export ARCH=arm
> export CROSS_COMPILE=/usr/bin/arm-linux-gnueabi-

Ok, I'm at a bit of a loss... When I look at the assembly before and
after the patch, it looks pretty much the same. Additionally, the
function where the undefined exception occurs (caam_jr_interrupt())
doesn't make any use of wr_reg64 or rd_reg64 which is the only thing the
patch changes...

Also, it looks like the nonatomic headers are doing what they are
supposed to on this arch and generating two 32-bit ios and not a 64 bit one.

So I have no idea what's going on here... Are we sure this is the patch
causing the problem? Did you bisect?

Thanks,

Logan
