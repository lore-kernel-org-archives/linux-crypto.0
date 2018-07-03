From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v18 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Tue, 3 Jul 2018 21:06:58 +0300
Message-ID: <CAHp75VcZjViSE7rxWALgvL20cLYq4si2XWU19UfoewXYiBcstQ@mail.gmail.com>
References: <20180622194752.11221-1-logang@deltatee.com> <20180622194752.11221-7-logang@deltatee.com>
 <CAOMZO5DpwPsidKQ9wfe8mNTgdOpkdHHgqHMa4yQBx9uRrfFmww@mail.gmail.com>
 <CAHp75VcCNsx2sHcYG2aNiw354exTvO=NUOS9P_BTmcM3siAepg@mail.gmail.com> <13ea3f97-4a33-3a24-1b7e-b819be73d867@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Fabio Estevam <festevam@gmail.com>,
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
In-Reply-To: <13ea3f97-4a33-3a24-1b7e-b819be73d867@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 3, 2018 at 9:01 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> On 03/07/18 11:36 AM, Andy Shevchenko wrote:
>>> This is now in linux-next as commit 46e4bf08f6388 and it breaks
>>> booting imx6 (32-bit ARM):

>>> Any ideas on how to fix this issue?
>>
>> Oops, first of all the header should be hi-lo instead of lo-hi.
>> Does it fix it?
>>
>> Otherwise I didn't (briefly) see what can be the issue.
>
> I had to dig to find this: but Horia had said[1] that the HW was
> specified to use lo-hi and I think we ended up changing to that for this
> commit based on his feedback. This is also mentioned in the commit message.

Apparently I missed that part of the discussion.

> Besides that, it looks like we are hitting an undefined instruction. So
> my best guess is that we are somehow now calling a proper 64bit read
> when we should be calling two 32-bit reads.

Which is a bit strange. For arm we have been using generic
definitions. Only very few architectures use own defined macros.

>
> Fabio, can you send your configuration?
>
> Thanks,
>
> Logan
>
> [1]
> http://lkml.kernel.org/r/VI1PR0401MB259145C2DFDB5E4084EA5DFC98D20@VI1PR0401MB2591.eurprd04.prod.outlook.com
>
>



-- 
With Best Regards,
Andy Shevchenko
