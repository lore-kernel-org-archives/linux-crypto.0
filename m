From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v18 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Wed, 4 Jul 2018 11:01:24 -0600
Message-ID: <55236e2b-a2a5-493a-5696-19c5926885b3@deltatee.com>
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
 <991b2298-bb3f-dad3-c93b-b43ee5f372de@deltatee.com>
 <VI1PR0402MB3485F76DD56D221EB256B4F698410@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAOMZO5C7V4_SpXOcAz0KbGYScpos0HRD-aa-Zh_6M3p9EqLsLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Fabio Estevam <festevam@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOMZO5C7V4_SpXOcAz0KbGYScpos0HRD-aa-Zh_6M3p9EqLsLQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/4/2018 9:06 AM, Fabio Estevam wrote:
>> Logan, you mentioned the following (which unfortunately I somehow missed):
>> https://lore.kernel.org/lkml/c3f2e061-5ed1-5c74-b955-3d2bfb0da074@deltatee.com
>> The lo_hi/hi_lo functions seem to always refer to the data being written
>> or read not to the address operated on.

Oy, yes that was more than a year ago.

>> OTOH, initial commit that added asm-generic/io-64-nonatomic-lo-hi.h and
>> asm-generic/io-64-nonatomic-hi-lo.h mentions:
>> 797a796a13df6 ("asm-generic: architecture independent readq/writeq for 32bit
>> environment")
>> - <asm-generic/io-64-nonatomic-lo-hi.h> provides non-atomic readq/ writeq with
>> the order of lower address -> higher address
>> - <asm-generic/io-64-nonatomic-hi-lo.h> provides non-atomic readq/ writeq with
>> reversed order

Hmm, well in fairness that commit didn't add any BE operations so
lower/higher address is the same as lower/higher data being written.
hi-lo/lo-hi is a bit ambiguous in that sense and designing it to match
the semantics of the only user seemed to make sense at the time. I
didn't even check the rough comments in an old commit message which I
wouldn't really take as canonical. Also, it seems to me, most hardware
would expect you to write in order of the address (if it cares at all)
not in the order of the higher/lower data word. Though, I have no
explicit examples only a gut feeling.

>> I think we should keep the initial semantics when adding support for
>> io{read|write}64, i.e. "lo" and "hi" to refer to address and not to value.
>>
>> Actually this is the semantics intended for the CAAM patch, see the note at the
>> end of the commit message that refers to addresses, not values:
>> To be consistent with CAAM engine HW spec: in case of 64-bit registers,
>> irrespective of device endianness, the lower address should be read from
>> / written to first, followed by the upper address.
>>
>>
>> 2. CAAM driver I/O accessors for i.MX case
>> Since this quirk cannot be accommodated in generic fashion, code dealing with
>> caam_imx has to stay.

Yes, though IMO, I think the patch I sent earlier is clearer than the
current code with the nested ifs in different static functions. In any
case, I'll drop it and let you make any changes you see fit.

Logan
