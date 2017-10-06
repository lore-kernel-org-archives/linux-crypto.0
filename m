From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5 12/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Fri, 6 Oct 2017 14:48:21 -0500
Message-ID: <179acd06-f692-f403-4f06-827b88704da2@amd.com>
References: <20171004131412.13038-1-brijesh.singh@amd.com>
 <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171006184951.vq6hlhjanaefizli@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: brijesh.singh@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171006184951.vq6hlhjanaefizli@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/6/17 1:49 PM, Borislav Petkov wrote:
...
>> +
>> +static unsigned int sev_poll;
>> +module_param(sev_poll, uint, 0444);
>> +MODULE_PARM_DESC(sev_poll, "Poll for sev command completion - any non-zero value");
> What is that used for? Some debugging leftover probably? If not, add a
> comment for why it is useful.
>

Yes, it was used for debug and can be removed. I will it in next rev.

.....

> Ok, this patch is humongous. Please split it in at least 3 or 4 separate
> logical patches as it is very hard to review as one huge chunk right
> now. Like, for example, the header file additions could be one patch,
> then part of psp-dev.c and so on.
>
> You can then send me those split-up ones as a reply here so that I can
> take a look again.

I will see what I can do, Maybe I will add one command at a time like we
do in svm.c.

> Also, here are a bunch of fixes ontop. Please add
>
> "Improvements by Borislav Petkov <bp@suse.de>"
>
> to the commit message when you decide to use them.

Sure, I will add your Improved-by-tag.

> Btw, the psp_entry thing I've moved to sp-pci.c, you probably should do
> that in the patch which adds it, not here.
>
> Also, I've fixed:
>
> +       /* Clear the interrupt status by writing 1. */
> +       iowrite32(1, psp->io_regs + PSP_P2CMSG_INTSTS);
>
> to really write 1 and not reuse the old status value.

Actually this one is interesting. When we read the status register, one
of the bit in status register will be 1 (i.e it may not always be bit 0)
and we need to write 1 on same bit position to clear it -- basically
write the same value you read. I will improve the comment. 

> And so on, they should be obvious from the diff.
>
> Thx.
>
> ---
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 1b87a699bd3f..13633eaa7889 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -32,15 +32,11 @@
>  
>  static unsigned int sev_poll;
>  module_param(sev_poll, uint, 0444);
> -MODULE_PARM_DESC(sev_poll, "Poll for sev command completion - any non-zero value");
> +MODULE_PARM_DESC(sev_poll, "Poll for SEV command completion - any non-zero value");
>  
> -DEFINE_MUTEX(sev_cmd_mutex);
> +static DEFINE_MUTEX(sev_cmd_mutex);
>  static bool sev_fops_registered;
>  
> -const struct psp_vdata psp_entry = {
> -	.offset = 0x10500,
> -};
> -
>  static struct psp_device *psp_alloc_struct(struct sp_device *sp)
>  {
>  	struct device *dev = sp->dev;
> @@ -62,34 +58,37 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
>  {
>  	struct psp_device *psp = data;
>  	unsigned int status;
> +	int reg;
>  
> -	/* read the interrupt status */
> +	/* Read the interrupt status: */
>  	status = ioread32(psp->io_regs + PSP_P2CMSG_INTSTS);
>  
> -	/* check if its command completion */
> -	if (status & (1 << PSP_CMD_COMPLETE_REG)) {
> -		int reg;
> +	/* Check if it is command completion: */
> +	if (!(status & BIT(PSP_CMD_COMPLETE_REG)))
> +		goto done;
>  
> -		/* check if its SEV command completion */
> -		reg = ioread32(psp->io_regs + PSP_CMDRESP);
> -		if (reg & PSP_CMDRESP_RESP) {
> -			psp->sev_int_rcvd = 1;
> -			wake_up(&psp->sev_int_queue);
> -		}
> +	/* Check if it is SEV command completion: */
> +	reg = ioread32(psp->io_regs + PSP_CMDRESP);
> +	if (reg & PSP_CMDRESP_RESP) {
> +		psp->sev_int_rcvd = 1;
> +		wake_up(&psp->sev_int_queue);
>  	}
>  
> -	/* clear the interrupt status by writing 1 */
> -	iowrite32(status, psp->io_regs + PSP_P2CMSG_INTSTS);
> +done:
> +	/* Clear the interrupt status by writing 1. */
> +	iowrite32(1, psp->io_regs + PSP_P2CMSG_INTSTS);
>  
>  	return IRQ_HANDLED;
>  }
>  
> -static int sev_wait_cmd_poll(struct psp_device *psp, unsigned int timeout,
> +static int sev_wait_cmd_poll(struct psp_device *psp, unsigned int timeouts,
>  			     unsigned int *reg)
>  {
> -	int wait = timeout * 10;	/* 100ms sleep => timeout * 10 */
> +	/* 10*100ms max timeout */
> +	if (timeouts > 10)
> +		timeouts = 10;
>  
> -	while (--wait) {
> +	while (--timeouts) {
>  		msleep(100);
>  
>  		*reg = ioread32(psp->io_regs + PSP_CMDRESP);
> @@ -97,8 +96,8 @@ static int sev_wait_cmd_poll(struct psp_device *psp, unsigned int timeout,
>  			break;
>  	}
>  
> -	if (!wait) {
> -		dev_err(psp->dev, "sev command timed out\n");
> +	if (!timeouts) {
> +		dev_err(psp->dev, "SEV command timed out\n");
>  		return -ETIMEDOUT;
>  	}
>  
> @@ -157,11 +156,16 @@ static int sev_cmd_buffer_len(int cmd)
>  
>  static int sev_handle_cmd(int cmd, void *data, int *psp_ret)
>  {
> -	struct sp_device *sp = sp_get_psp_master_device();
>  	unsigned int phys_lsb, phys_msb;
> -	struct psp_device *psp = sp->psp_data;
> +	struct psp_device *psp;
>  	unsigned int reg, ret;
> +	struct sp_device *sp;
> +
> +	sp = sp_get_psp_master_device();
> +	if (!sp)
> +		return -ENODEV;
>  
> +	psp = sp->psp_data;
>  	if (!psp)
>  		return -ENODEV;
>  
> @@ -170,9 +174,10 @@ static int sev_handle_cmd(int cmd, void *data, int *psp_ret)
>  	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
>  
>  	dev_dbg(psp->dev, "sev command id %#x buffer 0x%08x%08x\n",
> -			cmd, phys_msb, phys_lsb);
> +		cmd, phys_msb, phys_lsb);
> +
>  	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
> -			sev_cmd_buffer_len(cmd), false);
> +			     sev_cmd_buffer_len(cmd), false);
>  
>  	/* Only one command at a time... */
>  	mutex_lock(&sev_cmd_mutex);
> @@ -201,7 +206,7 @@ static int sev_handle_cmd(int cmd, void *data, int *psp_ret)
>  unlock:
>  	mutex_unlock(&sev_cmd_mutex);
>  	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> -			sev_cmd_buffer_len(cmd), false);
> +			     sev_cmd_buffer_len(cmd), false);
>  	return ret;
>  }
>  
> diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
> index 51d3cd966eed..6e8f83b41521 100644
> --- a/drivers/crypto/ccp/psp-dev.h
> +++ b/drivers/crypto/ccp/psp-dev.h
> @@ -73,6 +73,4 @@ struct psp_device {
>  	struct miscdevice sev_misc;
>  };
>  
> -extern const struct psp_vdata psp_entry;
> -
>  #endif /* __PSP_DEV_H */
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 20a0f3543cf4..f5f43c50698a 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -268,6 +268,12 @@ static int sp_pci_resume(struct pci_dev *pdev)
>  }
>  #endif
>  
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
> +static const struct psp_vdata psp_entry = {
> +	.offset = 0x10500,
> +};
> +#endif
> +
>  static const struct sp_dev_vdata dev_vdata[] = {
>  	{
>  		.bar = 2,
>
