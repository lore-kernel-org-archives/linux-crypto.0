From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v5 3/6] iomap: introduce io{read|write}64_{lo_hi|hi_lo}
Date: Mon, 31 Jul 2017 10:31:58 -0600
Message-ID: <3a4c9453-20be-8164-85eb-5ad4d596a299@deltatee.com>
References: <20170726231917.6073-1-logang@deltatee.com>
 <20170726231917.6073-4-logang@deltatee.com>
 <CAHp75Vcv7UCpnGY+mL7CMU5u9hCUxwaYWNsg58BoWBJGAFX4tQ@mail.gmail.com>
 <5c52d908-3b77-c5c6-99a7-1164d878ac95@deltatee.com>
 <CAHp75Ve619EE9ePy2zj+MjS7-MW3u_k2BQ5kc9iFBMYYQ9nMWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75Ve619EE9ePy2zj+MjS7-MW3u_k2BQ5kc9iFBMYYQ9nMWQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 31/07/17 10:10 AM, Andy Shevchenko wrote:
> Some drivers (hardware) would like to have non-atomic MMIO accesses
> when readq() defined

Huh? But that's the whole point of the io64-nonatomic header. If a
driver wants a specific non-atomic access they should just code two 32
bit accesses.

> In case of readq() / writeq() it's defined by the order of inclusion:
> 
> 1)
> include <...non-atomic...>
> include <linux/io.h>
> 
> Always non-atomic will be used.

I'm afraid you're wrong about this. The io-64-nonatomic-xx header
includes linux/io.h. Thus the order of the includes doesn't matter and
it will always auto switch. In any case, making an interface do
different things depending on the order of include files is *completely*
insane.

> P.S. I have done a table of comparison between IO accessors in Linux
> kernel and it looks hell out of being consistent.

There are a few corner oddities but it's really not that bad. Most
things are done for a reason if you dig into them.

Logan
