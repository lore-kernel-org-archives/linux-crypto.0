From: Scott Wood <scott.wood@nxp.com>
Subject: Re: [PATCH v2 4/8] powerpc: add io{read,write}64 accessors
Date: Tue, 10 May 2016 18:50:38 +0000
Message-ID: <DB5PR0401MB1928B01F60FF3137118F237891710@DB5PR0401MB1928.eurprd04.prod.outlook.com>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
 <1462462573-27779-1-git-send-email-horia.geanta@nxp.com>
 <AM2PR04MB0673A09EBC13818E0C2D764E98700@AM2PR04MB0673.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Cristian Stoica" <cristian.stoica@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"David S. Miller" <davem@davemloft.net>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	"Michael Ellerman" <mpe@ellerman.id.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/09/2016 03:20 AM, Horia Ioan Geanta Neag wrote:
> On 5/5/2016 6:37 PM, Horia Geant=E3 wrote:
>> This will allow device drivers to consistently use io{read,write}XX
>> also for 64-bit accesses.
>>
>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>
>=20
> It would be great if PPC maintainers could Ack this patch.
>=20
> As stated in the cover letter: https://lkml.org/lkml/2016/5/5/340
> I'd like to go with the whole patch set via cryptodev-2.6 tree.

It looks good to me.  Michael?

-Scott


>=20
> Thanks,
> Horia
>=20
>> ---
>>  arch/powerpc/kernel/iomap.c | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/arch/powerpc/kernel/iomap.c b/arch/powerpc/kernel/iomap=
=2Ec
>> index 12e48d56f771..3963f0b68d52 100644
>> --- a/arch/powerpc/kernel/iomap.c
>> +++ b/arch/powerpc/kernel/iomap.c
>> @@ -38,6 +38,18 @@ EXPORT_SYMBOL(ioread16);
>>  EXPORT_SYMBOL(ioread16be);
>>  EXPORT_SYMBOL(ioread32);
>>  EXPORT_SYMBOL(ioread32be);
>> +#ifdef __powerpc64__
>> +u64 ioread64(void __iomem *addr)
>> +{
>> +	return readq(addr);
>> +}
>> +u64 ioread64be(void __iomem *addr)
>> +{
>> +	return readq_be(addr);
>> +}
>> +EXPORT_SYMBOL(ioread64);
>> +EXPORT_SYMBOL(ioread64be);
>> +#endif /* __powerpc64__ */
>> =20
>>  void iowrite8(u8 val, void __iomem *addr)
>>  {
>> @@ -64,6 +76,18 @@ EXPORT_SYMBOL(iowrite16);
>>  EXPORT_SYMBOL(iowrite16be);
>>  EXPORT_SYMBOL(iowrite32);
>>  EXPORT_SYMBOL(iowrite32be);
>> +#ifdef __powerpc64__
>> +void iowrite64(u64 val, void __iomem *addr)
>> +{
>> +	writeq(val, addr);
>> +}
>> +void iowrite64be(u64 val, void __iomem *addr)
>> +{
>> +	writeq_be(val, addr);
>> +}
>> +EXPORT_SYMBOL(iowrite64);
>> +EXPORT_SYMBOL(iowrite64be);
>> +#endif /* __powerpc64__ */
>> =20
>>  /*
>>   * These are the "repeat read/write" functions. Note the
>>
>=20
>=20
