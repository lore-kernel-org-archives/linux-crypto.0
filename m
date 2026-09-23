Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38864481FC7;
	Wed, 23 Sep 2026 20:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790197171; cv=none; b=nnY3qx8I+0qB94cIaqshijlJDKX13aCEHWiqFo9G7jIxpFmxjRjAvL7e0/ZzSeHhr1JJemubo7viGr8BDf65XSOn0Cut7AfZgCc6RDVh7mdCUHwHeHGgwuAafLRQGLS7D0ZVQ0nlEhfnzHcmO1/p0FnJfyiapjINTXESVGFFZjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790197171; c=relaxed/simple;
	bh=XjLg0A25jRw5IumqJVTczAk25TCLJcI4jyt9XoU+w/0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=EDZw1lyD64iYKOzh0IKfVVaxhx78D3XP30jLFINhxcnrATmwtdxEFx7iN9O/bNTfW9HCHHN6x5a738cvKyGMiRRJkBqndZEfit+P46LUZWOGimvhGDQu2Tp5wu0g+I+p95QxtDbmcCmqmmDRdpsRLNlj7fdcCAX2vCNmiu+iN6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QqomW+yl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QqomW+yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602181F000FF;
	Wed, 23 Sep 2026 20:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790197169;
	bh=IEdNn3aUwe4HImBS9dDjkJ7weHk8oU+emztUHcnANtw=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=QqomW+ylpw/PDwHN9aiavnvl81CPHF9/3wUqB+c4utej/ylTCBDXi9PwjpqywO48f
	 qpoH7O7V2ClBBAc6veRhtMn+YFtMQU57vfRRpftyeQqjMJfAsiI9koqG0HNVwhCxgx
	 R2GvCdoiPC4W9beZtTMPNobd5zj6RbzdrEwxEVKM1eZUatzQEvrfrNBVdeiQPs/LpV
	 DwdHrQgMIQpCmpB/94BNzCIP6mSvzojtmhqdzFOsMOPHldJz4VxIcOTMjPZNGq7I+K
	 PLTTmlIUxjLF+suBD4fBrd4SJ3YFZXArduF8R+tUZnRjDKVw2i5gzgIa3K7+IjzRot
	 egDJ2t3wrj7MQ==
Date: Wed, 23 Sep 2026 15:59:28 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jini Susan George <jinisusan.george@amd.com>,
	Kees Cook <kees@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Kim Phillips <kim.phillips@amd.com>, Joerg Roedel <jroedel@suse.de>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Liam Merwick <liam.merwick@oracle.com>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Xiaotian Feng <dfeng@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Andi Kleen <ak@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>,
	Tony Luck <tony.luck@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>,
	Jonathan Cameron <jic23@kernel.org>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
	Petr Tesarik <ptesarik@suse.com>,
	David Howells <dhowells@redhat.com>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Ilias Stamatis <ilstam@amazon.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Toshi Kani <toshi.kani@hp.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vinod Koul <vkoul@kernel.org>,
	Jiang Liu <jiang.liu@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	linux-coco@lists.linux.dev, xen-devel@lists.xenproject.org,
	iommu@lists.linux.dev, linux-mm@kvack.org, aik@ozlabs.ru,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Pratik R . Sampat" <prsampat@amd.com>,
	Scott Soule Cheloha <scott.cheloha@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH kernel 02/17] pci/tsm: Fix stale comment about TDI
 report range start
Message-ID: <20260923205928.GA1942391@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916115159.1938195-3-aik@amd.com>

On Wed, Sep 16, 2026 at 09:51:42PM +1000, Alexey Kardashevskiy wrote:
> The PCIe spec r6 and later defines the MMIO range start in 4K units which
> was not the intention. The upcoming change makes it a byte address.
> The structure is already fixed to match the new definition but the comment
> is stale, fix it.

Please include specific reference to current spec, e.g.,
"PCIe r7.0, sec x".

I'm not sure who's intention is referred to here.

Please make the subject line match others in drivers/pci in style,
including capitalization.  Use "git log --oneline drivers/pci" to see.

> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  drivers/pci/tsm/core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
> index 9ac216ad896d..2a18be5be56e 100644
> --- a/drivers/pci/tsm/core.c
> +++ b/drivers/pci/tsm/core.c
> @@ -623,7 +623,6 @@ EXPORT_SYMBOL_GPL(pci_tsm_mmio_teardown);
>  #define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_UPDATABLE BIT(3)
>  #define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID GENMASK(31, 16)
>  
> -/* An interface report 'pfn' is 4K in size */
>  struct pci_tsm_devif_mmio {
>  	__le64 phys;
>  	__le32 nr_pfns;
> -- 
> 2.55.0
> 
