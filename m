From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v11 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Tue, 6 Mar 2018 09:56:22 -0700
Message-ID: <06d07fd5-a73c-34b0-079c-f4b44ef7a0cb@deltatee.com>
References: <20180305190824.847-1-logang@deltatee.com>
 <20180305190824.847-7-logang@deltatee.com>
 <VI1PR0402MB33422D83AE168D84FDED974698D90@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <VI1PR0402MB33422D83AE168D84FDED974698D90@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 06/03/18 05:37 AM, Horia Geantã wrote:
> On 3/5/2018 9:08 PM, Logan Gunthorpe wrote:
>> Clean up the extra ifdefs which defined the wr_reg64 and rd_reg64
>> functions in non-64bit cases in favour of the new common
>> io-64-nonatomic-lo-hi header.
>>
>> To be consistent with CAAM engine HW spec: in case of 64-bit registers,
>> irrespective of device endianness, the lower address should be read from
>> / written to first, followed by the upper address. Indeed the I/O
>> accessors in CAAM driver currently don't follow the spec, however this
>> is a good opportunity to fix the code.
>>
>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
>> Cc: Horia Geantã <horia.geanta@nxp.com>
>> Cc: Dan Douglass <dan.douglass@nxp.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: "David S. Miller" <davem@davemloft.net>
> Reviewed-by: Horia Geantã <horia.geanta@nxp.com>
> 
> Please get used to carrying Reviewed-bys from previous iterations when patches
> stay the same:

Sorry, I usually do this but I must have missed the email. Thanks.

Logan
