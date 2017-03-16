From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 30/32] kvm: svm: Add support for SEV DEBUG_ENCRYPT
 command
Date: Thu, 16 Mar 2017 12:03:52 +0100
Message-ID: <05dbd756-e8e9-9384-2759-898e230a6909__39472.9145839394$1489662385$gmane$org@redhat.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846790758.2349.16768762953657853550.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Brijesh Singh <brijesh.singh@amd.com>, simon.guinot@sequanux.org,
        linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com,
        matt@codeblueprint.co.uk, linux-pci@vger.kernel.org,
        linus.walleij@linaro.org, gary.hook@amd.com, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, hpa@zytor.com, cl@linux.com,
        dan.j.williams@intel.com, aarcange@redhat.com,
        sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com,
        herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com,
        joro@8bytes.org, x86@kernel.org, peterz@infradead.org,
        piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com,
        ross.zwisler@linux.intel.com, bp@suse.de, dyoung@redhat.com,
        thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org,
        arnd@arndb.de, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com,
        luto
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751431AbdCPLEK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 07:04:10 -0400
In-Reply-To: <148846790758.2349.16768762953657853550.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 02/03/2017 16:18, Brijesh Singh wrote:
> +	data = (void *) get_zeroed_page(GFP_KERNEL);

The page does not need to be zeroed, does it?

> +
> +	if ((len & 15) || (dst_addr & 15)) {
> +		/* if destination address and length are not 16-byte
> +		 * aligned then:
> +		 * a) decrypt destination page into temporary buffer
> +		 * b) copy source data into temporary buffer at correct offset
> +		 * c) encrypt temporary buffer
> +		 */
> +		ret = __sev_dbg_decrypt_page(kvm, dst_addr, data, &argp->error);

Ah, I see now you're using this function here for read-modify-write.
data is already pinned here, so even if you keep the function it makes
sense to push pinning out of __sev_dbg_decrypt_page and into
sev_dbg_decrypt.

> +		if (ret)
> +			goto err_3;
> +		d_off = dst_addr & (PAGE_SIZE - 1);
> +
> +		if (copy_from_user(data + d_off,
> +					(uint8_t *)debug.src_addr, len)) {
> +			ret = -EFAULT;
> +			goto err_3;
> +		}
> +
> +		encrypt->length = PAGE_SIZE;

Why decrypt/re-encrypt all the page instead of just the 16 byte area
around the [dst_addr, dst_addr+len) range?

> +		encrypt->src_addr = __psp_pa(data);
> +		encrypt->dst_addr =  __sev_page_pa(inpages[0]);
> +	} else {
> +		if (copy_from_user(data, (uint8_t *)debug.src_addr, len)) {
> +			ret = -EFAULT;
> +			goto err_3;
> +		}

Do you need copy_from_user, or can you just pin/unpin memory as for
DEBUG_DECRYPT?

Paolo

> +		d_off = dst_addr & (PAGE_SIZE - 1);
> +		encrypt->length = len;
> +		encrypt->src_addr = __psp_pa(data);
> +		encrypt->dst_addr = __sev_page_pa(inpages[0]);
> +		encrypt->dst_addr += d_off;
> +	}
> +
> +	encrypt->handle = sev_get_handle(kvm);
> +	ret = sev_issue_cmd(kvm, SEV_CMD_DBG_ENCRYPT, encrypt, &argp->error);
