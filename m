From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.2 12.2/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 12 Oct 2017 20:21:02 +0200
Message-ID: <20171012182102.ffyxggnhyymtmhky@pd.tnic>
References: <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171011165030.115696-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171011165030.115696-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 11, 2017 at 11:50:30AM -0500, Brijesh Singh wrote:
> +static int sev_do_cmd(int cmd, void *data, int *psp_ret)
> +{
> +	unsigned int phys_lsb, phys_msb;
> +	struct psp_device *psp;
> +	unsigned int reg, ret;
> +	struct sp_device *sp;
> +
> +	sp = sp_get_psp_master_device();
> +	if (!sp)
> +		return -ENODEV;
> +
> +	psp = sp->psp_data;
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
> +	/* Only one command at a time... */
> +	mutex_lock(&sev_cmd_mutex);
> +
> +	iowrite32(phys_lsb, psp->io_regs + PSP_CMDBUFF_ADDR_LO);
> +	iowrite32(phys_msb, psp->io_regs + PSP_CMDBUFF_ADDR_HI);
> +
> +	reg = cmd;
> +	reg <<= PSP_CMDRESP_CMD_SHIFT;
> +	reg |= PSP_CMDRESP_IOC;
> +	iowrite32(reg, psp->io_regs + PSP_CMDRESP);
> +
> +	ret = sev_wait_cmd_ioc(psp, &reg);

Btw, that function returns 0 unconditionally. So you can make it return
void and...

> +	if (ret)
> +		goto unlock;

... remove this check and initialize ret to 0 at the beginning.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
