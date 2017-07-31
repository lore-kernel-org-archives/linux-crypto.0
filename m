From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v5 3/6] iomap: introduce io{read|write}64_{lo_hi|hi_lo}
Date: Mon, 31 Jul 2017 09:55:45 -0600
Message-ID: <5c52d908-3b77-c5c6-99a7-1164d878ac95@deltatee.com>
References: <20170726231917.6073-1-logang@deltatee.com>
 <20170726231917.6073-4-logang@deltatee.com>
 <CAHp75Vcv7UCpnGY+mL7CMU5u9hCUxwaYWNsg58BoWBJGAFX4tQ@mail.gmail.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:56211 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752063AbdGaP4L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 11:56:11 -0400
In-Reply-To: <CAHp75Vcv7UCpnGY+mL7CMU5u9hCUxwaYWNsg58BoWBJGAFX4tQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 30/07/17 10:03 AM, Andy Shevchenko wrote:
> On Thu, Jul 27, 2017 at 2:19 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>> In order to provide non-atomic functions for io{read|write}64 that will
>> use readq and writeq when appropriate. We define a number of variants
>> of these functions in the generic iomap that will do non-atomic
>> operations on pio but atomic operations on mmio.
>>
>> These functions are only defined if readq and writeq are defined. If
>> they are not, then the wrappers that always use non-atomic operations
>> from include/linux/io-64-nonatomic*.h will be used.
> 
> Don't you see here a slight problem?
> 
> In some cases we want to substitute atomic in favour of non-atomic
> when both are defined.
> So, please don't do this "smartly".

I'm not sure what you mean here. The driver should use ioread64 and
include an io-64-nonatomic header. Then there are three cases:

1) The arch has no atomic 64 bit io operations defined. In this case it
uses the non-atomic inline function in the io-64-nonatomic header.

2) The arch uses CONFIG_GENERIC_IOMAP and has readq defined, but not
ioread64 defined (likely because pio can't do atomic 64 bit operations
but mmio can). In this case we need to use the ioread64_xx functions
defined in iomap.c which do atomic mmio and non-atomic pio.

3) The arch has ioread64 defined so the atomic operation is used.

>> +u64 ioread64_lo_hi(void __iomem *addr)
>> +{
>> +       IO_COND(addr, return pio_read64_lo_hi(port), return readq(addr));
>> +       return 0xffffffffffffffffLL;
>> +}
> 
> U missed u.

I'll fix this in the next revision.

Thanks,

Logan
