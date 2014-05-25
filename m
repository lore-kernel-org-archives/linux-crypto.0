From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto accelerator
Date: Sun, 25 May 2014 13:58:39 +0200
Message-ID: <5381DAEF.20007@gmail.com>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <1400771396-9686-4-git-send-email-clabbe.montjoie@gmail.com> <201405241400.03456.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	rdunlap@infradead.org, maxime.ripard@free-electrons.com,
	linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
	davem@davemloft.net, grant.likely@linaro.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62598 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaEYL6o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 May 2014 07:58:44 -0400
In-Reply-To: <201405241400.03456.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 24/05/2014 14:00, Marek Vasut a =E9crit :
> On Thursday, May 22, 2014 at 05:09:56 PM, LABBE Corentin wrote:
>=20
> Do I have to repeat myself ? :)

No, sorry for the commit message, I begin to use git
Generally I agree all your remarks with some comments below.

>=20
>> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
>> ---
>>  drivers/crypto/Kconfig    |   49 ++
>>  drivers/crypto/Makefile   |    1 +
>>  drivers/crypto/sunxi-ss.c | 1476
>> +++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 1526
>> insertions(+)
>>  create mode 100644 drivers/crypto/sunxi-ss.c
>>
>> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>> index 03ccdb0..5ea0922 100644
>> --- a/drivers/crypto/Kconfig
>> +++ b/drivers/crypto/Kconfig
>> @@ -418,4 +418,53 @@ config CRYPTO_DEV_MXS_DCP
>>  	  To compile this driver as a module, choose M here: the module
>>  	  will be called mxs-dcp.
>>
>> +config CRYPTO_DEV_SUNXI_SS
>> +        tristate "Support for Allwinner Security System cryptograph=
ic
>> accelerator" +        depends on ARCH_SUNXI
>> +        help
>> +          Some Allwinner processors have a crypto accelerator named
>> +          Security System. Select this if you want to use it.
>> +
>> +          To compile this driver as a module, choose M here: the mo=
dule
>> +          will be called sunxi-ss.
>> +
>> +if CRYPTO_DEV_SUNXI_SS
>> +config CRYPTO_DEV_SUNXI_SS_PRNG
>> +	bool "Security System PRNG"
>> +	select CRYPTO_RNG2
>> +	help
>> +	  If you enable this option, the SS will provide a pseudo random
>> +	  number generator.
>> +config CRYPTO_DEV_SUNXI_SS_MD5
>> +	bool "Security System MD5"
>> +	select CRYPTO_MD5
>> +	help
>> +	  If you enable this option, the SS will provide MD5 hardware
>> +	  acceleration.
>=20
> This is one IP block and it provides 5 algorithms. Put it under one c=
onfig=20
> option please.

I want to let the user choose what it want to be used. Someone could wa=
nt only to accelerate md5 and to not use the PRNG.
Lots of other hw crypto driver do the same.

>=20
> Also, just shorted this to CONFIG_CRYPTO_SUNXI_SS , the _DEV stuff in=
 the name=20
> is useless.

I think not, most of cryptographic hardware driver begin with CRYPTO_DE=
V (CRYPTO_DEV_PADLOCK, CRYPTO_DEV_GEODE, CRYPTO_DEV_TALITOS etc...), on=
ly S390 does not have a _DEV.

,
>=20
> [...]
>=20
>> diff --git a/drivers/crypto/sunxi-ss.c b/drivers/crypto/sunxi-ss.c
>> new file mode 100644
>> index 0000000..bbf57bc
>> --- /dev/null
>> +++ b/drivers/crypto/sunxi-ss.c
>> @@ -0,0 +1,1476 @@
>> +/*
>> + * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A2=
0 SoC
>=20
> Why can this not be generic Allwinner-all-chips driver ? Does the IP =
block=20
> change that dramatically between the chips?

As I said in my introduction email, lots of allwinner chips seems to ha=
ve the same crypto device.
But since I do not own any of those hardware, and in most case does not=
 have a datasheet, I only assume support for A20.
I will add this comment in the header of the driver.

>=20
> [...]
>=20
>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_MD5
>> +#include <crypto/md5.h>
>> +#define SUNXI_SS_HASH_COMMON
>> +#endif
>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_SHA1
>> +#include <crypto/sha.h>
>> +#define SUNXI_SS_HASH_COMMON
>> +#endif
>> +#ifdef SUNXI_SS_HASH_COMMON
>> +#include <crypto/hash.h>
>> +#include <crypto/internal/hash.h>
>> +#endif
>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_AES
>> +#include <crypto/aes.h>
>> +#endif
>> +
>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_3DES
>> +#define SUNXI_SS_DES
>> +#endif
>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_DES
>> +#define SUNXI_SS_DES
>> +#endif
>> +#ifdef SUNXI_SS_DES
>> +#include <crypto/des.h>
>> +#endif
>=20
> Please discard this mayhem when getting rid of all the configuration =
option.
>=20
>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_PRNG
>> +#include <crypto/internal/rng.h>
>> +
>> +struct prng_context {
>> +	u8 seed[192/8];
>> +	unsigned int slen;
>> +};
>> +#endif
>> +
>> +#define SUNXI_SS_CTL            0x00
>> +#define SUNXI_SS_KEY0           0x04
>> +#define SUNXI_SS_KEY1           0x08
>> +#define SUNXI_SS_KEY2           0x0C
>> +#define SUNXI_SS_KEY3           0x10
>> +#define SUNXI_SS_KEY4           0x14
>> +#define SUNXI_SS_KEY5           0x18
>> +#define SUNXI_SS_KEY6           0x1C
>> +#define SUNXI_SS_KEY7           0x20
>> +
>> +#define SUNXI_SS_IV0            0x24
>> +#define SUNXI_SS_IV1            0x28
>> +#define SUNXI_SS_IV2            0x2C
>> +#define SUNXI_SS_IV3            0x30
>> +
>> +#define SUNXI_SS_CNT0           0x34
>> +#define SUNXI_SS_CNT1           0x38
>> +#define SUNXI_SS_CNT2           0x3C
>> +#define SUNXI_SS_CNT3           0x40
>> +
>> +#define SUNXI_SS_FCSR           0x44
>> +#define SUNXI_SS_ICSR           0x48
>> +
>> +#define SUNXI_SS_MD0            0x4C
>> +#define SUNXI_SS_MD1            0x50
>> +#define SUNXI_SS_MD2            0x54
>> +#define SUNXI_SS_MD3            0x58
>> +#define SUNXI_SS_MD4            0x5C
>> +
>> +#define SS_RXFIFO         0x200
>> +#define SS_TXFIFO         0x204
>=20
> You don't have much consistency in the register naming scheme, please=
 fix this=20
> somehow. I suppose renaming the SS_[RT]XFIFO registers to SUNXI_SS_[R=
T]XFIFO is=20
> a good idea.
>=20
>> +/* SUNXI_SS_CTL configuration values */
>> +
>> +/* AES/DES/3DES key select - bits 24-27 */
>> +#define SUNXI_SS_KEYSELECT_KEYN		(0 << 24)
>=20
> Uh oh , you ORR some values with this flag, which is always zero. Thi=
s seems=20
> broken.
>=20
> [...]
>=20
>> +/* SS Method - bits 4-6 */
>> +#define SUNXI_OP_AES                    (0 << 4)
>> +#define SUNXI_OP_DES                    (1 << 4)
>> +#define SUNXI_OP_3DES                   (2 << 4)
>> +#define SUNXI_OP_SHA1                   (3 << 4)
>> +#define SUNXI_OP_MD5                    (4 << 4)
>> +#define SUNXI_OP_PRNG                   (5 << 4)
>> +
>> +/* Data end bit - bit 2 */
>> +#define SUNXI_SS_DATA_END               BIT(2)
>=20
> Please use the BIT() macros in consistent fashion. Either use it or d=
on't use it=20
> (I'd much rather see it not used), but don't mix the stuff :-(
>=20
> [...]
>=20
>> +/* General notes:
>> + * I cannot use a key/IV cache because each time one of these chang=
e ALL
>> stuff + * need to be re-writed.
>> + * And for example, with dm-crypt IV changes on each request.
>> + *
>> + * After each request the device must be disabled.
>=20
> This really isn't quite clear, can you please expand the comment so i=
t's more=20
> understandtable ?
>=20
>> + * For performance reason, we use writel_relaxed/read_relaxed for a=
ll
>> + * operations on RX and TX FIFO.
>> + * For all other registers, we use writel.
>> + * See http://permalink.gmane.org/gmane.linux.ports.arm.kernel/1176=
44
>> + * and http://permalink.gmane.org/gmane.linux.ports.arm.kernel/1176=
40
>> + * */
>=20
> I will not review the algos, they need to be AHASH/ABLKCIPHER algos. =
See the=20
> reasoning further down below.
>=20
> [...]
>=20
>> +/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> =3D=3D=3D=3D*/
>> +/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>> =3D=3D=3D=3D=3D*/ +static struct crypto_alg sunxi_des3_alg =3D {
>> +	.cra_name =3D "cbc(des3_ede)",
>> +	.cra_driver_name =3D "cbc-des3-sunxi-ss",
>> +	.cra_priority =3D 300,
>> +	.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> +	.cra_flags =3D CRYPTO_ALG_TYPE_BLKCIPHER,
>=20
> This must be rewritten to be ABLKCIPHER.
>=20
>> +	.cra_ctxsize =3D sizeof(struct sunxi_req_ctx),
>> +	.cra_module =3D THIS_MODULE,
>> +	.cra_type =3D &crypto_blkcipher_type,
>> +	.cra_init =3D sunxi_des_init,
>> +	.cra_exit =3D sunxi_des_exit,
>> +	.cra_alignmask =3D 3,
>> +	.cra_u.blkcipher =3D {
>> +		.min_keysize    =3D DES3_EDE_KEY_SIZE,
>> +		.max_keysize    =3D DES3_EDE_KEY_SIZE,
>> +		.ivsize         =3D 8,
>> +		.setkey         =3D sunxi_des3_setkey,
>> +		.encrypt        =3D sunxi_des3_cbc_encrypt,
>> +		.decrypt        =3D sunxi_des3_cbc_decrypt,
>> +	}
>> +};
>> +
>> +#endif /* CONFIG_CRYPTO_DEV_SUNXI_SS_3DES */
>> +
>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_PRNG
>> +/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> =3D=3D=3D=3D*/
>> +/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>> =3D=3D=3D=3D=3D*/ +static int sunxi_ss_rng_get_random(struct crypto_=
rng *tfm, u8
>> *rdata, +		unsigned int dlen)
>> +{
>> +	struct prng_context *ctx =3D crypto_tfm_ctx((struct crypto_tfm *)t=
fm);
>=20
> Use crypto_rng_ctx() here . The cast is plain wrong. I know it works =
due to how=20
> the structures are defined, but this is not right.
>=20
>> +	unsigned int i;
>> +	u32 mode =3D 0;
>> +	u32 v;
>> +
>> +	dev_dbg(ss_ctx->dev, "DEBUG %s dlen=3D%u\n", __func__, dlen);
>> +
>> +	if (dlen =3D=3D 0 || rdata =3D=3D NULL)
>> +		return 0;
>=20
> Return -EINVAL or somesuch here, no?
>=20
>> +	mode |=3D SUNXI_OP_PRNG;
>> +	mode |=3D SUNXI_PRNG_ONESHOT;
>> +	mode |=3D SUNXI_SS_ENABLED;
>> +
>> +	mutex_lock(&lock);
>> +	writel(mode, ss_ctx->base + SUNXI_SS_CTL);
>> +
>> +	for (i =3D 0; i < ctx->slen; i +=3D 4) {
>> +		v =3D *(u32 *)(ctx->seed + i);
>=20
> Define the .seed field as u32 if you actually want to access it as u3=
2. You are=20
> very lucky you didn't trigger alignment faults with this yet.
>=20
>> +		dev_dbg(ss_ctx->dev, "DEBUG Seed %d %x\n", i, v);
>> +	}
>=20
> But this debug instrumentation looks quite useless anyway.

As I said in my introduction mail, I cannot get PRNG to work, so it is =
the reason of lots of dev_dbg()
Anyway, I will remove them.

>=20
>> +	for (i =3D 0; i < ctx->slen && i < 192/8 && i < 16; i +=3D 4) {
>> +		v =3D *(u32 *)(ctx->seed + i);
>> +		dev_dbg(ss_ctx->dev, "DEBUG Seed %d %x\n", i, v);
>> +		writel(v, ss_ctx->base + SUNXI_SS_KEY0 + i);
>> +	}
>> +
>> +	mode |=3D SUNXI_PRNG_START;
>> +	writel(mode, ss_ctx->base + SUNXI_SS_CTL);
>> +	for (i =3D 0; i < 4; i++) {
>> +		v =3D readl(ss_ctx->base + SUNXI_SS_CTL);
>> +		dev_dbg(ss_ctx->dev, "DEBUG CTL %x %x\n", mode, v);
>> +	}
>> +	for (i =3D 0; i < dlen && i < 160 / 8; i +=3D 4) {
>> +		v =3D readl(ss_ctx->base + SUNXI_SS_MD0 + i);
>> +		*(u32 *)(rdata + i) =3D v;
>> +		dev_dbg(ss_ctx->dev, "DEBUG MD%d %x\n", i, v);
>> +	}
>=20
> Drop the debug instrumentation and define the seed buffer as u32.
>=20
>> +	writel(0, ss_ctx->base + SUNXI_SS_CTL);
>> +	mutex_unlock(&lock);
>> +	return dlen;
>> +}
>> +
>> +/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> =3D=3D=3D=3D*/
>> +/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>> =3D=3D=3D=3D=3D*/ +static int sunxi_ss_rng_reset(struct crypto_rng *=
tfm, u8 *seed,
>> +		unsigned int slen)
>> +{
>> +	struct prng_context *ctx =3D crypto_tfm_ctx((struct crypto_tfm *)t=
fm);
>=20
> Use crypto_rng_ctx() here . The cast is plain wrong.
>=20
>> +	dev_dbg(ss_ctx->dev, "DEBUG %s slen=3D%u\n", __func__, slen);
>> +	memcpy(ctx->seed, seed, slen);
>> +	ctx->slen =3D slen;
>> +	return 0;
>> +}
>=20
> [...]
>=20
>> +static int sunxi_ss_probe(struct platform_device *pdev)
>> +{
>> +	struct resource *res;
>> +	u32 v;
>> +	int err;
>> +	unsigned long cr;
>> +
>> +	if (!pdev->dev.of_node)
>> +		return -ENODEV;
>> +
>> +	memset(ss_ctx, 0, sizeof(struct sunxi_ss_ctx));
>=20
> Static data are always zeroed out by default, no ?
>=20
> If you just so accidentally happen to probe() this driver twice, you =
will get=20
> some seriously ugly surprise here, since you zero the data out withou=
t checking=20
> if the device might have already been probed. A much better idea woul=
d be to
> define a static struct sunxi_ss_ctx *ss_ctx; and then
>=20
>  if (ss_ctx) {
>   dev_err(&pdev->dev, "Only one instance allowed");
>   return -ENODEV;
>  }
>  ss_ctx =3D devm_kzalloc(&pdev->dev, sizeof(*ss_ctx), GFP_KERNEL);
>=20
> Also note the use of sizeof(*ss_ctx), this will allow for this line t=
o not be=20
> changed in case the type of *ss_ctx ever changes in the future. So us=
e it.
>=20
>> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (res =3D=3D NULL) {
>> +		dev_err(&pdev->dev, "Cannot get the MMIO ressource\n");
>> +		/* TODO PTR_ERR ? */
>=20
> Fix the TODOs .
>=20
>> +		return -ENXIO;
>> +	}
>> +	ss_ctx->base =3D devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(ss_ctx->base)) {
>> +		dev_err(&pdev->dev, "Cannot request MMIO\n");
>> +		return PTR_ERR(ss_ctx->base);
>> +	}
>=20
> Actually, this is the pattern. You don't need to check for IS_ERR(res=
) before=20
> calling devm_ioremap_resource().
>=20
> res =3D platform_get_resource();
> base =3D devm_ioremap_resource(&pdev->dev, res)
> if (IS_ERR(base))
>  return PTR_ERR(base);
>=20
>> +	/* TODO Does this information could be usefull ? */
>> +	writel(SUNXI_SS_ENABLED, ss_ctx->base + SUNXI_SS_CTL);
>> +	v =3D readl(ss_ctx->base + SUNXI_SS_CTL);
>> +	v >>=3D 16;
>> +	v &=3D 0x07;
>> +	dev_info(&pdev->dev, "Die ID %d\n", v);
>> +	writel(0, ss_ctx->base + SUNXI_SS_CTL);
>=20
> You are configuring hardware before enabling clock for that hardware.=
 That does=20
> not seem right.
>=20
>> +	ss_ctx->ssclk =3D devm_clk_get(&pdev->dev, "mod");
>> +	if (IS_ERR(ss_ctx->ssclk)) {
>> +		err =3D PTR_ERR(ss_ctx->ssclk);
>> +		dev_err(&pdev->dev, "Cannot get SS clock err=3D%d\n", err);
>> +		return err;
>> +	}
>> +	dev_dbg(&pdev->dev, "clock ss acquired\n");
>> +
>> +	ss_ctx->busclk =3D devm_clk_get(&pdev->dev, "ahb");
>> +	if (IS_ERR(ss_ctx->busclk)) {
>> +		err =3D PTR_ERR(ss_ctx->busclk);
>> +		dev_err(&pdev->dev, "Cannot get AHB SS clock err=3D%d\n", err);
>> +		return err;
>> +	}
>> +	dev_dbg(&pdev->dev, "clock ahb_ss acquired\n");
>=20
> These dev_dbg() aren't really useful.
>=20
>> +	/* Enable the clocks */
>> +	err =3D clk_prepare_enable(ss_ctx->busclk);
>> +	if (err !=3D 0) {
>> +		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
>> +		return err;
>> +	}
>> +	err =3D clk_prepare_enable(ss_ctx->ssclk);
>> +	if (err !=3D 0) {
>> +		dev_err(&pdev->dev, "Cannot prepare_enable ssclk\n");
>> +		clk_disable_unprepare(ss_ctx->busclk);
>> +		return err;
>> +	}
>> +
>> +#define	SUNXI_SS_CLOCK_RATE_BUS (24 * 1000 * 1000)
>> +#define	SUNXI_SS_CLOCK_RATE_SS (150 * 1000 * 1000)
>=20
> Make this const unsigned long or somesuch, the define is horrid and n=
ot=20
> typesafe.
>=20
>> +	/* Check that clock have the correct rates gived in the datasheet =
*/
>> +	cr =3D clk_get_rate(ss_ctx->busclk);
>> +	if (cr >=3D SUNXI_SS_CLOCK_RATE_BUS)
>> +		dev_dbg(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >=3D %u)\n"=
,
>> +				cr, cr / 1000000, SUNXI_SS_CLOCK_RATE_BUS);
>> +	else
>> +		dev_warn(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >=3D=20
> %u)\n",
>> +				cr, cr / 1000000, SUNXI_SS_CLOCK_RATE_BUS);
>> +	cr =3D clk_get_rate(ss_ctx->ssclk);
>> +	if (cr =3D=3D SUNXI_SS_CLOCK_RATE_SS)
>> +		dev_dbg(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <=3D %u)\n",
>> +				cr, cr / 1000000, SUNXI_SS_CLOCK_RATE_SS);
>> +	else {
>> +		dev_warn(&pdev->dev, "Clock ss is at %lu (%lu MHz) (must be <=3D=20
> %u)\n",
>> +				cr, cr / 1000000, SUNXI_SS_CLOCK_RATE_SS);
>> +		/* Try to set the clock to the maximum allowed */
>> +		err =3D clk_set_rate(ss_ctx->ssclk, SUNXI_SS_CLOCK_RATE_SS);
>> +		if (err !=3D 0) {
>> +			dev_err(&pdev->dev, "Cannot set clock rate to ssclk\n");
>> +			goto label_error_clock;
>> +		}
>> +		cr =3D clk_get_rate(ss_ctx->ssclk);
>> +		dev_info(&pdev->dev, "Clock ss set to %lu (%lu MHz) (must be >=3D=
=20
> %u)\n",
>> +				cr, cr / 1000000, SUNXI_SS_CLOCK_RATE_BUS);
>> +	}
>=20
> Just run clk_set_rate() for both and be done with it.
>=20
>> +	ss_ctx->buf_in =3D NULL;
>> +	ss_ctx->buf_in_size =3D 0;
>> +	ss_ctx->buf_out =3D NULL;
>> +	ss_ctx->buf_out_size =3D 0;
>=20
> This is useless, you already did that with devm_kzalloc() above.
>=20
>> +	ss_ctx->dev =3D &pdev->dev;
>> +
>> +	mutex_init(&lock);
>> +
>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_PRNG
>> +	err =3D crypto_register_alg(&sunxi_ss_prng);
>=20
> Use crypto_register_algs() when you get rid of those useless #defines=
 for each=20
> algo.
>=20
>> +	if (err) {
>> +		dev_err(&pdev->dev, "crypto_register_alg error\n");
>> +		goto label_error_prng;
>> +	} else {
>> +		dev_info(&pdev->dev, "Registred PRNG\n");
>=20
> This is useless, you can always check that the thing was probed via /=
proc/crypto=20
> . Please remove this dev_into().
>=20
>> +	}
>> +#endif
>> +
>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_MD5
>> +	err =3D crypto_register_shash(&sunxi_md5_alg);
>=20
> Do not use shash for such device. This is clearly and ahash (and asyn=
c in=20
> general) device. The rule of a thumb here is that you use sync algos =
only for=20
> devices which have dedicated instructions for computing the transform=
ation. For=20
> devices which are attached to some kind of bus, you use async algos (=
ahash etc).
>=20
>> +	if (err) {
>> +		dev_err(&pdev->dev, "Fail to register MD5\n");
>> +		goto label_error_md5;
>> +	} else {
>> +		dev_info(&pdev->dev, "Registred MD5\n");
>> +	}
>> +#endif
>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_SHA1
>> +	err =3D crypto_register_shash(&sunxi_sha1_alg);
>=20
> DTTO.
>=20
> I am preparing a document for the crypto API, drop me a PM if you wan=
t the=20
> preliminary version. I don't want to release it until it's more compl=
ete as it=20
> will only produce more confusion throughout the crypto API than there=
 already=20
> is.
>=20
> [...]
>=20
>> +static const struct of_device_id a20ss_crypto_of_match_table[] =3D =
{
>> +	{ .compatible =3D "allwinner,sun7i-a20-crypto" },
>> +	{}
>> +};
>> +MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
>=20
> If possible, scrub the a20 nonsense.
>=20
>> +static struct platform_driver sunxi_ss_driver =3D {
>> +	.probe          =3D sunxi_ss_probe,
>> +	.remove         =3D sunxi_ss_remove,
>> +	.driver         =3D {
>> +		.owner          =3D THIS_MODULE,
>> +		.name           =3D "sunxi-ss",
>> +		.of_match_table	=3D a20ss_crypto_of_match_table,
>> +	},
>> +};
>> +
>> +module_platform_driver(sunxi_ss_driver);
>> +
>> +MODULE_DESCRIPTION("Allwinner Security System crypto accelerator");
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
>=20
> MODULE_ALIAS is missing I think.
>=20

Thanks for your review.
