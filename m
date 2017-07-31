From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v5 3/6] iomap: introduce io{read|write}64_{lo_hi|hi_lo}
Date: Mon, 31 Jul 2017 21:11:41 +0300
Message-ID: <CAHp75VcX7SeYyp6OEYLQLaAk-eHzbFV05wGC+dD2OeCcnxY6TQ@mail.gmail.com>
References: <20170726231917.6073-1-logang@deltatee.com> <20170726231917.6073-4-logang@deltatee.com>
 <CAHp75Vcv7UCpnGY+mL7CMU5u9hCUxwaYWNsg58BoWBJGAFX4tQ@mail.gmail.com>
 <5c52d908-3b77-c5c6-99a7-1164d878ac95@deltatee.com> <CAHp75Ve619EE9ePy2zj+MjS7-MW3u_k2BQ5kc9iFBMYYQ9nMWQ@mail.gmail.com>
 <3a4c9453-20be-8164-85eb-5ad4d596a299@deltatee.com> <CAHp75VdE-xRHDEfmmURtoak6+4Vga4szLnDkGjtJHm47DZRCAQ@mail.gmail.com>
 <65ca8848-3a99-bda8-5165-9453b70316fa@deltatee.com> <CAHp75VdOh+aa771g=T-f=XMkS5nY-7VFK6miqyxw0dOA8YOJyw@mail.gmail.com>
 <c5208a76-e94b-0203-3591-81b14e7fd888@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c5208a76-e94b-0203-3591-81b14e7fd888@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 31, 2017 at 9:04 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
> On 31/07/17 12:03 PM, Andy Shevchenko wrote:
>>
>> Per commit 3a044178cccf they are exactly created for this kind of cases.
>>
>
> Sure, ok, and my patchset provides the same set of functions to satisfy
> such a use.

Okay, please, Cc me for next version, I think I need fresh view on it.
Thanks!

-- 
With Best Regards,
Andy Shevchenko
