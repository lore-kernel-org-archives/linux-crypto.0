From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 26/32] kvm: svm: Add support for SEV
 LAUNCH_UPDATE_DATA command
Date: Thu, 16 Mar 2017 11:48:48 +0100
Message-ID: <14021d2a-2a94-a0c8-88db-acbc04b4daac__31880.3439768546$1489661381$gmane$org@redhat.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846786714.2349.17724971671841396908.stgit@brijesh-build-machine>
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
Received: from mx1.redhat.com ([209.132.183.28]:36196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751137AbdCPKtE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 06:49:04 -0400
In-Reply-To: <148846786714.2349.17724971671841396908.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 02/03/2017 16:17, Brijesh Singh wrote:
> +static struct page **sev_pin_memory(unsigned long uaddr, unsigned long ulen,
> +				    unsigned long *n)
> +{
> +	struct page **pages;
> +	int first, last;
> +	unsigned long npages, pinned;
> +
> +	/* Get number of pages */
> +	first = (uaddr & PAGE_MASK) >> PAGE_SHIFT;
> +	last = ((uaddr + ulen - 1) & PAGE_MASK) >> PAGE_SHIFT;
> +	npages = (last - first + 1);
> +
> +	pages = kzalloc(npages * sizeof(struct page *), GFP_KERNEL);
> +	if (!pages)
> +		return NULL;
> +
> +	/* pin the user virtual address */
> +	down_read(&current->mm->mmap_sem);
> +	pinned = get_user_pages_fast(uaddr, npages, 1, pages);
> +	up_read(&current->mm->mmap_sem);

get_user_pages_fast, like get_user_pages_unlocked, must be called
without mmap_sem held.

> +	if (pinned != npages) {
> +		printk(KERN_ERR "SEV: failed to pin  %ld pages (got %ld)\n",
> +				npages, pinned);
> +		goto err;
> +	}
> +
> +	*n = npages;
> +	return pages;
> +err:
> +	if (pinned > 0)
> +		release_pages(pages, pinned, 0);
> +	kfree(pages);
> +
> +	return NULL;
> +}
>
> +	/* the array of pages returned by get_user_pages() is a page-aligned
> +	 * memory. Since the user buffer is probably not page-aligned, we need
> +	 * to calculate the offset within a page for first update entry.
> +	 */
> +	offset = uaddr & (PAGE_SIZE - 1);
> +	len = min_t(size_t, (PAGE_SIZE - offset), ulen);
> +	ulen -= len;
> +
> +	/* update first page -
> +	 * special care need to be taken for the first page because we might
> +	 * be dealing with offset within the page
> +	 */

No need to special case the first page; just set "offset = 0" inside the
loop after the first iteration.

Paolo

> +	data->handle = sev_get_handle(kvm);
> +	data->length = len;
> +	data->address = __sev_page_pa(inpages[0]) + offset;
> +	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_DATA,
> +			data, &argp->error);
> +	if (ret)
> +		goto err_3;
> +
> +	/* update remaining pages */
> +	for (i = 1; i < nr_pages; i++) {
> +
> +		len = min_t(size_t, PAGE_SIZE, ulen);
> +		ulen -= len;
> +		data->length = len;
> +		data->address = __sev_page_pa(inpages[i]);
> +		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_DATA,
> +					data, &argp->error);
> +		if (ret)
> +			goto err_3;
> +	}
