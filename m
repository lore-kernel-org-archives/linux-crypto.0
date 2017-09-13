From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part2 PATCH v3 03/26] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) device support
Date: Wed, 13 Sep 2017 16:17:49 +0200
Message-ID: <20170913141749.pvphgxgcsjam4us7@pd.tnic>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-4-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750999AbdIMOSC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Sep 2017 10:18:02 -0400
Content-Disposition: inline
In-Reply-To: <20170724200303.12197-4-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 24, 2017 at 03:02:40PM -0500, Brijesh Singh wrote:
> AMDs new Secure Encrypted Virtualization (SEV) feature allows the memory
> contents of a virtual machine to be transparently encrypted with a key
> unique to the guest VM. The programming and management of the encryption
> keys are handled by the AMD Secure Processor (AMD-SP), which exposes the
> commands for these tasks. The complete spec for various commands are
> available at:
> http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf
> 
> This patch extends AMD-SP driver to provide:
> 
>  - a in-kernel APIs to communicate with SEV device. The APIs can be used
>    by the hypervisor to create encryption context for the SEV guests.
> 
>  - a userspace IOCTL to manage the platform certificates etc
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

...

> +int sev_issue_cmd(int cmd, void *data, int *psp_ret)
> +{
> +	struct sev_device *sev = get_sev_master_device();
> +	unsigned int phys_lsb, phys_msb;
> +	unsigned int reg, ret;
> +
> +	if (!sev)
> +		return -ENODEV;
> +
> +	if (psp_ret)
> +		*psp_ret = 0;

So you set psp_ret to 0 here...

> +
> +	/* Set the physical address for the PSP */
> +	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
> +	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
> +
> +	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x\n",
> +			cmd, phys_msb, phys_lsb);
> +	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
> +			sev_cmd_buffer_len(cmd), false);
> +
> +	/* Only one command at a time... */
> +	mutex_lock(&sev_cmd_mutex);
> +
> +	iowrite32(phys_lsb, sev->io_regs + PSP_CMDBUFF_ADDR_LO);
> +	iowrite32(phys_msb, sev->io_regs + PSP_CMDBUFF_ADDR_HI);
> +	wmb();
> +
> +	reg = cmd;
> +	reg <<= PSP_CMDRESP_CMD_SHIFT;
> +	reg |= sev_poll ? 0 : PSP_CMDRESP_IOC;
> +	iowrite32(reg, sev->io_regs + PSP_CMDRESP);
> +
> +	ret = sev_wait_cmd(sev, &reg);
> +	if (ret)
> +		goto unlock;

... something fails here and you unlock...

> +
> +	if (psp_ret)
> +		*psp_ret = reg & PSP_CMDRESP_ERR_MASK;
> +
> +	if (reg & PSP_CMDRESP_ERR_MASK) {
> +		dev_dbg(sev->dev, "sev command %u failed (%#010x)\n",
> +			cmd, reg & PSP_CMDRESP_ERR_MASK);
> +		ret = -EIO;
> +	}
> +
> +unlock:
> +	mutex_unlock(&sev_cmd_mutex);
> +	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> +			sev_cmd_buffer_len(cmd), false);
> +	return ret;

... and here you return psp_ret == 0 even though something failed.

What I think you should do is not touch @psp_ret when you return before
the SEV command executes and *when* you return, set @psp_ret accordingly
to denote the status of the command execution.

Or if you're touching it before you execute the SEV
command and you return early, it should say something like
PSP_CMDRESP_COMMAND_DIDNT_EXECUTE or so, to tell the caller exactly what
happened.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
