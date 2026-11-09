Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794206210;
	b=cAg8Dqec6k0C7abQ3njS6IT1rMQba6RzdMjJO1GDiDTQ/egXrJmNNFXH0SGjRWTygPY0
	 x5YukVR+PPXd/G8HQhTKpyM31/86grWR2LmSUYNohqU0buSw9+2aESCtOkwfuV/yOpWVP
	 E9ZGjZl29FaPxEPMSClHvMcv97BC7fpy8f6Kv/bvUIla6+j4BuJaPA+7Ok1jLNNEOWY22
	 7T6bFPhXWHyHnuyrEF5Eco8qWzS2R3csBnkFY3T8lwKnxwoqwZYroMSirQelBprwKfe57
	 yAiZfmQHfwlJoK3KnYb5E+aySgF/WODRNvwvsLF+LXPnLgx/UNhHRqWkS2lDQsew0jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794206210;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=AtsfehftEhocEg2I5bmWwp2ROneUNtV4068+F7Hlw8w=;
	b=spizSneDKGXHMomI/uMVyXQpL+nVFXeKycUYGq0sYBKGN0nuwky1Wamcbcnf1OsVCS3i
	 J2Sm9iefRYz3368PANTUwGcGII1AMUMwtrSM94gIdaeiPkuxdH1EU35W14Aar6LGBn4XD
	 +KkPZ6G4WoXqkGOJG7p1U9nubCAA9E14Lf9twCDjK6krE0kg63uAjZ3Hcd9tYNj6jPjbi
	 XvafkxsLKLoFbIgD+0FVKQG0mUlInriNr2wmwMrrsJTT3zFjcdOk+jc3rOPZQ4vvEZKsc
	 aG9o275oAuA1NSB//UrD4VI5IF/mtOQwMYUaeL2jtzhL4bMYVGI7VsGXAaPccMCUuBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b="JHF72/UU";
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32DD606A321;
	Mon,  9 Nov 2026 06:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F32DD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=JHF72/UU
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 56B0A40E04CD;
	Mon,  9 Nov 2026 06:36:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id aOVENPtaFWK7; Mon,  9 Nov 2026 06:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1794206204; bh=AtsfehftEhocEg2I5bmWwp2ROneUNtV4068+F7Hlw8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JHF72/UUi4yUT9aqIf+1NnxYf6RBnkvYAj3W0oNSoARYb9dCH6USJz/XwRB3zKAzN
	 MWJW9xd/ygniOGVsaaW7GBZaf+qXYyhu3aJBhi2D/f1MdqaPIPAWinTyaFBOA9gM35
	 5nUywwgnc62cQv4bfa4eoHQf48x0D4FJFNgLCt83+USeUOLy7Qh+2lSpB7trl1wz/p
	 kEpq/vJ6nrjXE/KAhASp6qorwpWq2HXjCxbam8Cyo1Z2sIRXrUNhsh6zZ/KoYZL2i4
	 1lmr105l2rgJ8qXntBB7PKSVPBF2/Z8bSDrAGXjT8NRQY6og6HlqYUIe5alwo9BgNF
	 dx1kkKAsqjQxtJJM1XRbbhZFSRsQTaoRpIN6D9Rt0nTL0lKCj+axgl9IxZagHCy091
	 r8Ki+ygh/0tcNG4AUVe5LTp4ch5qnCP4xKJ3OLYrbSXIXoab9f+zgIaxkW4jibdP8X
	 3s6MuKTd4JCyKlo7AF17HWOnrGSmGTMzu5kqiIdy8sdRXtaPhqcCV+NSL9gv2T7SAZ
	 ofaUI4PE6zr8T9OByuN3e8vf5AXpiMuzD+cRw/CoXMu517BCsSSS6nnJ+9Y0mm0MV/
	 h2mAq7Jr8pQs6CouL4r0WevxUISKIjEtmSGk88S8UwKCzTVapUK5ItYrpXUIxXDEx2
	 sCCf9g3g76KyyYwpg9RRhxLk=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B1AD640E01E1;
	Mon,  9 Nov 2026 06:35:12 +0000 (UTC)
Date: Sun, 8 Nov 2026 22:35:09 -0800
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
Message-ID: <20261109063509.GFavFpnZ-OM-rGcjdp@fat_crate.local>
References: <20260916115159.1938195-1-aik@amd.com>
 <20260916115159.1938195-2-aik@amd.com>
 <20260916174929.GCaqrWqZ1fIhi4Rgbn@fat_crate.local>
 <9c83efe9-9367-472f-bf39-e07252e70c3c@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9c83efe9-9367-472f-bf39-e07252e70c3c@amd.com>

On Thu, Sep 17, 2026 at 12:28:50PM +1000, Alexey Kardashevskiy wrote:
> Correct, the patches between v7.3-rc2 and 01/17 (can drop samples and tools,
> obviously) are enough. It is basically recent tagged upstream + rebased
> Dan's https://lore.kernel.org/r/20260705220819.2472765-1-djbw@kernel.org

You probably should rebase that branch on 7.4 because it has caught a bunch of
conflicts since the last time...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
