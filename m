Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBEB3C09E7;
	Wed, 16 Sep 2026 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789581088; cv=none; b=ZFjSKJMzT+g8cIlgQGKpvvsMl9o8bGnnP8Q0w2kQ9WISQ8vMmNt/dryLWusiHFrRWbEKMdt1UtXlePkXzKUenVttlh0ALf18mEb1NVvy0G9zKiGwtUskki6F/2rOYlq5BQLE3U4sh//bqubnPZZzD56Fo80BwDNckC0izDzDLSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789581088; c=relaxed/simple;
	bh=ipTJmkF3/zpr+sbsZHP7u7xHksn9daIAXHVrXTmWyRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6KDlYO3X/wPuFlzi9B+Z2uYSKNkTSHaZkG1c0DHywAJ5qIIBUYUcIlSW81hcScgq3Amhd8AqfTsHilUlD5fGj99gyRhSn/6QJ+gfdDG6CRuwt/dC1AANvW9eUQRTO/4CyZ1V84wRDYPecZJ6RTH40WxWOul27rEsUzpdoDOx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=E7FjhsZ1; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="E7FjhsZ1"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 99E4540E00E8;
	Wed, 16 Sep 2026 17:51:09 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 9zV9muLWubjt; Wed, 16 Sep 2026 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789581064; bh=or2++1LeeipZYCb3G9WRgyA4slOHEhMs91sMxm37PrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E7FjhsZ1898C+iRkHA2e9itQoyiqH/Ch3CRAiwQscnU0CXAU1B3A58i/8qF7CWRQh
	 G9fmEyLGGIFdYQql64Uc91Gneuv+SDG6aDTZnURc3lGHscWFc5r5ZPh1vPnn+mqjo9
	 KFHhO1O53B1kflUQZ5pwBl1X+TZ/YeOf6S4ukWau6F9Oy2bvc2AkWVFtpJFZA/d20Q
	 giWI8kOs24tcni/YN9qyJ2ifRbE9E3/xTzGmQUWsiuXTEhyoEZljOUczoL/sJ+VORm
	 Jkvi5hPfZD2JyHdgx2JTUeJM+9EfC5lNAKlo3wpXrtxjuZdy0HbqzBa/nrDlGGXUEB
	 T6ChTVHnrHjzueQm9iG6UjvNvWs1Ci2nBGXVxdIW5G0N5g5YvMPiyWBQmN/KIt+8BJ
	 4nMWbx4zbda4r5Pe4F71yKd9gdBn5WVrThXpykty5Y9ZS6rxK/Zy/4imk+qiuwIQBK
	 +J/Y7B2Xd/vbfAw0NWAJZRMYwlCrFpuzM/A8ynROZCZpyn7YbI8CMVxBS6k2Zrpwya
	 T6Y4mlUo4kZxEKXRc1Vy6jsORFjfP4A+DtCjZKq1wSzIccfVVxpJX103Kp6LkYYPGE
	 WV11UFcMReR+2ndH81MYlmJrtQ8QF3VCSlMJid4YqIKWMK9eHGy2UwsKc4B1bjlrvo
	 ZcjWPKxqQS0jjFQdEECxxF+M=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6DA8240E00B9;
	Wed, 16 Sep 2026 17:49:32 +0000 (UTC)
Date: Wed, 16 Sep 2026 10:49:29 -0700
From: Borislav Petkov <bp@alien8.de>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [RFC PATCH kernel 01/17] pci/dma/tsm: Call disable DMA bus hook
 on cleanup
Message-ID: <20260916174929.GCaqrWqZ1fIhi4Rgbn@fat_crate.local>
References: <20260916115159.1938195-1-aik@amd.com>
 <20260916115159.1938195-2-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260916115159.1938195-2-aik@amd.com>

On Wed, Sep 16, 2026 at 09:51:41PM +1000, Alexey Kardashevskiy wrote:
> +	if (device_tcb_trusted(dev))

Where is that function and the rest of the gunk needed for me to apply before
I review those?

The patches on that branch:

https://github.com/AMDESE/linux-kvm/commits/tsm-next

which come before those here are enough?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
