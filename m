From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6.1 16/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Mon, 30 Oct 2017 18:21:50 +0100
Message-ID: <20171030172150.3eibiqr44i43zbvd@pd.tnic>
References: <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171029204825.18260-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([5.9.137.197]:47712 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932252AbdJ3RV4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2017 13:21:56 -0400
Content-Disposition: inline
In-Reply-To: <20171029204825.18260-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 29, 2017 at 03:48:25PM -0500, Brijesh Singh wrote:
> AMD's new Secure Encrypted Virtualization (SEV) feature allows the
> memory contents of virtual machines to be transparently encrypted with a
> key unique to the VM. The programming and management of the encryption
> keys are handled by the AMD Secure Processor (AMD-SP) which exposes the
> commands for these tasks. The complete spec is available at:

...

> Changes since v6:
>  * Add functions to init and shutdown firmware during modprobe
>  * Add sev_state variable in psp_device to keep track of the INIT and SHUTDOWN
>    state
>  * Don't allow caller to shutdown the FW because SHUTDOWN will be done during
>    the module removal.
>  * Drop the fw_init_mutex and init_refcount because we no longer allow apps to
>    INIT and UINIT the platform

Yes, it definitely looks much better this way. Thanks for doing that!

> 
>  drivers/crypto/ccp/psp-dev.c | 360 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/psp-dev.h |  22 +++
>  drivers/crypto/ccp/sp-dev.c  |   9 ++
>  drivers/crypto/ccp/sp-dev.h  |   4 +
>  include/linux/psp-sev.h      | 158 +++++++++++++++++++
>  5 files changed, 553 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index b5789f878560..060f57ac08b3 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -26,6 +26,15 @@
>  #include "sp-dev.h"
>  #include "psp-dev.h"
>  
> +#define DEVICE_NAME	"sev"
> +
> +static DEFINE_MUTEX(sev_cmd_mutex);
> +static struct sev_misc_dev *misc_dev;
> +static struct psp_device *psp_master;
> +
> +static int sev_platform_shutdown_locked(int *error);
> +static int sev_platform_init_locked(struct sev_data_init *data, int *error);

Useless forward declarations.

>  static struct psp_device *psp_alloc_struct(struct sp_device *sp)
>  {
>  	struct device *dev = sp->dev;

...

> +static int sev_do_cmd_locked(int cmd, void *data, int *psp_ret)

You can use the "__" prefix to denote that it is a lower-level helper:

__sev_do_cmd
__sev_do_cmd_locked

Ditto for the other locked functions.

> +	struct psp_device *psp = psp_master;
> +	unsigned int phys_lsb, phys_msb;
> +	unsigned int reg, ret = 0;
> +
> +	if (!psp)
> +		return -ENODEV;
> +
> +	/* Get the physical address of the command buffer */
> +	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
> +	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
> +
> +	dev_dbg(psp->dev, "sev command id %#x buffer 0x%08x%08x\n",
> +		cmd, phys_msb, phys_lsb);
> +
> +	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
> +			     sev_cmd_buffer_len(cmd), false);
> +
> +	iowrite32(phys_lsb, psp->io_regs + PSP_CMDBUFF_ADDR_LO);
> +	iowrite32(phys_msb, psp->io_regs + PSP_CMDBUFF_ADDR_HI);
> +
> +	reg = cmd;
> +	reg <<= PSP_CMDRESP_CMD_SHIFT;
> +	reg |= PSP_CMDRESP_IOC;
> +	iowrite32(reg, psp->io_regs + PSP_CMDRESP);
> +
> +	/* wait for command completion */
> +	sev_wait_cmd_ioc(psp, &reg);
> +
> +	if (psp_ret)
> +		*psp_ret = reg & PSP_CMDRESP_ERR_MASK;
> +
> +	if (reg & PSP_CMDRESP_ERR_MASK) {
> +		dev_dbg(psp->dev, "sev command %#x failed (%#010x)\n",
> +			cmd, reg & PSP_CMDRESP_ERR_MASK);
> +		ret = -EIO;
> +	}
> +
> +	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> +			     sev_cmd_buffer_len(cmd), false);
> +
> +	return ret;
> +}

...

> +static int sev_platform_init_locked(struct sev_data_init *data, int *error)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_data_init *input = NULL;
> +	int rc = 0;
> +
> +	if (!psp)
> +		return -ENODEV;
> +
> +	if (psp->sev_state == SEV_STATE_INIT)
> +		return 0;
> +
> +	if (!data) {
> +		input = kzalloc(sizeof(*input), GFP_KERNEL);
> +		if (!input)
> +			return -ENOMEM;
> +
> +		data = input;
> +	}

You can do the allocation in the enclosing function, outside of the
critical region so that you can keep it shorter.

Or even better: if you're going to synchronize the commands with a
mutex, you can define a static struct sev_data_init input in this file
which you always hand in and then you can save yourself the kmalloc
calls.

> +
> +	rc = sev_do_cmd_locked(SEV_CMD_INIT, data, error);
> +	if (rc)
> +		goto e_free;
> +
> +	psp->sev_state = SEV_STATE_INIT;
> +	dev_dbg(psp->dev, "SEV firmware intialized\n");

WARNING: 'intialized' may be misspelled - perhaps 'initialized'?
#254: FILE: drivers/crypto/ccp/psp-dev.c:215:
+       dev_dbg(psp->dev, "SEV firmware intialized\n");

WARNING: space prohibited between function name and open parenthesis '('
#445: FILE: drivers/crypto/ccp/psp-dev.c:440:
+       data = kzalloc(sizeof (*data), GFP_KERNEL);

Ok, tell me: how many times do I have to write:

"Please integrate scripts/checkpatch.pl into your patch creation
workflow. Some of the warnings/errors *actually* make sense."

until you actually do it?

> +
> +e_free:
> +	kfree(input);
> +	return rc;
> +}
> +
> +int sev_platform_init(struct sev_data_init *data, int *error)
> +{
> +	int rc;
> +
> +	mutex_lock(&sev_cmd_mutex);
> +	rc = sev_platform_init_locked(data, error);
> +	mutex_unlock(&sev_cmd_mutex);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(sev_platform_init);
> +
> +static int sev_platform_shutdown_locked(int *error)
> +{
> +	int ret;
> +
> +	ret = sev_do_cmd_locked(SEV_CMD_SHUTDOWN, 0, error);
> +	if (ret)
> +		return ret;
> +
> +	psp_master->sev_state = SEV_STATE_UNINIT;
> +	dev_dbg(psp_master->dev, "SEV firmware shutdown\n");
> +
> +	return ret;
> +}
> +
> +int sev_platform_shutdown(int *error)
> +{
> +	if (error)
> +		*error = 0;
> +
> +	return 0;
> +}

I'm guessing that that's just bare-bones and it will get filled up in
the next patches. Otherwise it looks pretty useless.

If it is just to block the user from sending SHUTDOWN to the PSP
master, just do that in the ioctl directly - no need to call some empty
functions.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
