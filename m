From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/2] crypto: stm32 - Support for STM32 CRYP crypto
 module
Date: Sun, 22 Oct 2017 08:59:36 +0200
Message-ID: <20171022065936.GA8489@Red>
References: <1508403839-14131-1-git-send-email-fabien.dessenne@st.com>
 <1508403839-14131-3-git-send-email-fabien.dessenne@st.com>
 <20171019103454.GA26877@Red>
 <0359a8aa-5d91-6284-76cb-44bbd7865a0f@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alexandre TORGUE <alexandre.torgue-qxv4g6HH51o@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Lionel DEBIEVE <lionel.debieve-qxv4g6HH51o@public.gmane.org>,
        Benjamin GAIGNARD <benjamin.gaignard-qxv4g6HH51o@public.gmane.org>,
        Ludovic BARRE <ludovic.barre-qxv4g6HH51o@public.gmane.org>
To: Fabien DESSENNE <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0359a8aa-5d91-6284-76cb-44bbd7865a0f-qxv4g6HH51o@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 19, 2017 at 01:01:56PM +0000, Fabien DESSENNE wrote:
> Hi Corentin
> 
> 
> Thank you for your comments. I will fix according to them. See also me 
> answers/questions below
> 
> While we are at it, do you plan to deliver a new version of the 
> crypto_engine update? (I had to remove the AEAD part of this new driver 
> since it depends on that pending update)

No plan, I do not like the Herbert proposal, so it is a bit hard to progress on it.

> 
> BR
> 
> Fabien
> 
> 
> On 19/10/17 12:34, Corentin Labbe wrote:
> > Hello
> >
> > I have some minor comment below
> >
> > On Thu, Oct 19, 2017 at 11:03:59AM +0200, Fabien Dessenne wrote:
> >> This module registers block cipher algorithms that make use of the
> >> STMicroelectronics STM32 crypto "CRYP1" hardware.
> >> The following algorithms are supported:
> >> - aes: ecb, cbc, ctr
> >> - des: ecb, cbc
> >> - tdes: ecb, cbc
> >>
> >> Signed-off-by: Fabien Dessennie <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
> >> ---
> >>   drivers/crypto/stm32/Kconfig      |    9 +
> >>   drivers/crypto/stm32/Makefile     |    3 +-
> >>   drivers/crypto/stm32/stm32-cryp.c | 1188 +++++++++++++++++++++++++++++++++++++
> >>   3 files changed, 1199 insertions(+), 1 deletion(-)
> >>   create mode 100644 drivers/crypto/stm32/stm32-cryp.c
> >>
> >> diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
> >> index 602332e..61ef00b 100644
> >> --- a/drivers/crypto/stm32/Kconfig
> >> +++ b/drivers/crypto/stm32/Kconfig
> > [...]
> >> +/* Bit [0] encrypt / decrypt */
> >> +#define FLG_ENCRYPT             BIT(0)
> >> +/* Bit [8..1] algo & operation mode */
> >> +#define FLG_AES                 BIT(1)
> >> +#define FLG_DES                 BIT(2)
> >> +#define FLG_TDES                BIT(3)
> >> +#define FLG_ECB                 BIT(4)
> >> +#define FLG_CBC                 BIT(5)
> >> +#define FLG_CTR                 BIT(6)
> >> +/* Mode mask = bits [15..0] */
> >> +#define FLG_MODE_MASK           GENMASK(15, 0)
> >> +
> >> +/* Registers */
> >> +#define CRYP_CR                 0x00000000
> >> +#define CRYP_SR                 0x00000004
> >> +#define CRYP_DIN                0x00000008
> >> +#define CRYP_DOUT               0x0000000C
> >> +#define CRYP_DMACR              0x00000010
> >> +#define CRYP_IMSCR              0x00000014
> >> +#define CRYP_RISR               0x00000018
> >> +#define CRYP_MISR               0x0000001C
> >> +#define CRYP_K0LR               0x00000020
> >> +#define CRYP_K0RR               0x00000024
> >> +#define CRYP_K1LR               0x00000028
> >> +#define CRYP_K1RR               0x0000002C
> >> +#define CRYP_K2LR               0x00000030
> >> +#define CRYP_K2RR               0x00000034
> >> +#define CRYP_K3LR               0x00000038
> >> +#define CRYP_K3RR               0x0000003C
> >> +#define CRYP_IV0LR              0x00000040
> >> +#define CRYP_IV0RR              0x00000044
> >> +#define CRYP_IV1LR              0x00000048
> >> +#define CRYP_IV1RR              0x0000004C
> >> +
> >> +/* Registers values */
> >> +#define CR_DEC_NOT_ENC          0x00000004
> >> +#define CR_TDES_ECB             0x00000000
> >> +#define CR_TDES_CBC             0x00000008
> >> +#define CR_DES_ECB              0x00000010
> >> +#define CR_DES_CBC              0x00000018
> >> +#define CR_AES_ECB              0x00000020
> >> +#define CR_AES_CBC              0x00000028
> >> +#define CR_AES_CTR              0x00000030
> >> +#define CR_AES_KP               0x00000038
> >> +#define CR_AES_UNKNOWN          0xFFFFFFFF
> >> +#define CR_ALGO_MASK            0x00080038
> >> +#define CR_DATA32               0x00000000
> >> +#define CR_DATA16               0x00000040
> >> +#define CR_DATA8                0x00000080
> >> +#define CR_DATA1                0x000000C0
> >> +#define CR_KEY128               0x00000000
> >> +#define CR_KEY192               0x00000100
> >> +#define CR_KEY256               0x00000200
> >> +#define CR_FFLUSH               0x00004000
> >> +#define CR_CRYPEN               0x00008000
> > Why not using BIT(x) ?
> 
> Some values are not only 1 bit (then we may use BIT and BITGEN but this 
> would be less readable), so I prefer to keep this values.
> 
> > Why not using also directly FLG_XX since CR_XX are arbitray values ? like using instead CR_AES_CBC = FLG_AES | FLG_CBC
> 
> The CR_ values are used to write in the registers. FLG_ are arbitraty 
> values, so we cannot mix them.

I think you could do without FLG_XXX and use instead register values (spliting algo and block mode values is necessary in that case)

> 
> >
> > [...]
> >> +static inline void stm32_cryp_wait_enable(struct stm32_cryp *cryp)
> >> +{
> >> +	while (stm32_cryp_read(cryp, CRYP_CR) & CR_CRYPEN)
> >> +		cpu_relax();
> >> +}
> > This function is not used, so you could remove it
> >
> >> +
> >> +static inline void stm32_cryp_wait_busy(struct stm32_cryp *cryp)
> >> +{
> >> +	while (stm32_cryp_read(cryp, CRYP_SR) & SR_BUSY)
> >> +		cpu_relax();
> >> +}
> > No timeout ?
> >
> >
> >> +
> >> +static inline void stm32_cryp_wait_output(struct stm32_cryp *cryp)
> >> +{
> >> +	while (!(stm32_cryp_read(cryp, CRYP_SR) & SR_OFNE))
> >> +		cpu_relax();
> >> +}
> > This function is not used, so you could remove it
> >
> > [...]
> >> +static int stm32_cryp_check_aligned(struct scatterlist *sg, size_t total,
> >> +				    size_t align)
> >> +{
> >> +	int len = 0;
> >> +
> >> +	if (!total)
> >> +		return 0;
> >> +
> >> +	if (!IS_ALIGNED(total, align))
> >> +		return -EINVAL;
> >> +
> >> +	while (sg) {
> >> +		if (!IS_ALIGNED(sg->offset, sizeof(u32)))
> >> +			return -1;
> > -1 is not a good return value, prefer any -Exxxx
> >
> >> +
> >> +		if (!IS_ALIGNED(sg->length, align))
> >> +			return -1;
> >> +
> >> +		len += sg->length;
> >> +		sg = sg_next(sg);
> >> +	}
> >> +
> >> +	if (len != total)
> >> +		return -1;
> > [...]
> >> +static int stm32_cryp_copy_sgs(struct stm32_cryp *cryp)
> >> +{
> >> +	void *buf_in, *buf_out;
> >> +	int pages, total_in, total_out;
> >> +
> >> +	if (!stm32_cryp_check_io_aligned(cryp)) {
> >> +		cryp->sgs_copied = 0;
> >> +		return 0;
> >> +	}
> >> +
> >> +	total_in = ALIGN(cryp->total_in, cryp->hw_blocksize);
> >> +	pages = total_in ? get_order(total_in) : 1;
> >> +	buf_in = (void *)__get_free_pages(GFP_ATOMIC, pages);
> >> +
> >> +	total_out = ALIGN(cryp->total_out, cryp->hw_blocksize);
> >> +	pages = total_out ? get_order(total_out) : 1;
> >> +	buf_out = (void *)__get_free_pages(GFP_ATOMIC, pages);
> >> +
> >> +	if (!buf_in || !buf_out) {
> >> +		pr_err("Couldn't allocate pages for unaligned cases.\n");
> > You must use dev_err() instead. without it, it will be hard to know which subsystem said that error message.
> >
> > [...]
> >> +static int stm32_cryp_cra_init(struct crypto_tfm *tfm)
> >> +{
> >> +	tfm->crt_ablkcipher.reqsize = sizeof(struct stm32_cryp_reqctx);
> >> +
> >> +	return 0;
> >> +}
> > You could simply remove this function
> 
> I am not sure we can. Here we set reqsize.
> Most of the other drivers do the same, but maybe this is wrong everywhere.
> Could you give more details?
> 

Forget what I said, I was wrong. Sorry

Regards
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
