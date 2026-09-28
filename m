Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6C148A8C8;
	Mon, 28 Sep 2026 17:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616874; cv=none; b=Fs8bFXbpDsJ22CAMSvOQfrAcWlQJNbugtE7FrXBo/WVuvmla9mitlT1o3PuQKi1oJIL6P76OREe3bD4W8bPUsJZvD7f52gR1RFS/TgtfEafs0hutTKrmz+NQoX1x6r49x4FaOrlDAtADnSHCBRD3lmQjQ1nTvYfTAksH3Tlk/80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616874; c=relaxed/simple;
	bh=oChNvTVcXS1M8GWzAzYF7Z0+i8fHsTieZxNwgOt5e0g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C5NNUgFUBIRkbVTulOVeP1l1DkxddgjLrvYd5VnBNgCzpx5+y6YnUXxV8MBkjw889g9dJcf4+evMZ9pwBD1n59Aej0e5wvWQmVplEVhCgU1x6z+pcaPB/mB05lK76LBxVSbcZy4QQYEKpFlovrp4Jp+bl7cjcdFEHXyOux4jcZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+w+Z9wE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+w+Z9wE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F581F000FF;
	Mon, 28 Sep 2026 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616871;
	bh=QAKyyibYUeejb8Whf31Eer9u3DhP0lRlPQeFXRFIdSk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H+w+Z9wESnUyUk1z3NRUG0aKCTTmaliwJI3UJqNW92EDEx8yWt5IWQ7pyBzgIWwpf
	 edziuZ/MPBo4XgajXrK04hsrEOa/zvy+Ot0IOy60OhSRWI2Td9beXuchZesaQMJd5b
	 Rx0cT24384Qwv2um+9adZ5rPfGE9gkhKL3XL4T7h46kvSYWRzvBblgSqMGdYAp84z9
	 aY6v/2Uk75AUlow9mwHVkzL9YGx+gShh09W6Nwo3BqNgD1a8qNofxUq2ZVccFNV60v
	 nLG95gBh5yDckaxi0qJ/k1pkDigOBbNcvJ6/0B53eAbdssIAMPXl8HHzmteeMssO/b
	 a062/NVRAXUPQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/12] mm: Add VM_CRASH_MARK
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mimi Zohar" <zohar@linux.ibm.com>, "Michal Hocko" <mhocko@suse.com>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Mark Rutland" <mark.rutland@arm.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Jonathan Corbet" <corbet@lwn.net>, "David
 Howells" <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Usama
 Arif" <usama.arif@linux.dev>, "Arnd Bergmann" <arnd@arndb.de>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Saravana Kannan" <saravanak@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Will
 Deacon" <will@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Alistair
 Popple" <apopple@nvidia.com>, "Suren Baghdasaryan" <surenb@google.com>, "Harry
 Yoo" <harry@kernel.org>, "Rob Herring" <robh@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Pedro Falcato" <pfalcato@suse.de>, "Oscar
 Salvador" <osalvador@suse.de>, "Lorenzo Stoakes" <ljs@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Byungchul Park" <byungchul@sk.com>, "Peter
 Xu" <peterx@redhat.com>, "Baoquan He" <baoquan.he@linux.dev>, "Mike
 Rapoport" <rppt@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Barry
 Song" <baohua@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "David
 Hildenbrand" <david@kernel.org>, "Gregory Price" <gourry@gourry.net>,
 =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "David S. Miller" <davem@davemloft.net>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alasdair
 Kergon" <agk@redhat.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "James
 Morris" <jmorris@namei.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Mike Snitzer" <snitzer@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Danilo Krummrich" <dakr@kernel.org>, "Jann
 Horn" <jannh@google.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Dave
 Young" <ruirui.yang@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Rik van Riel" <riel@surriel.com>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Matthew Brost" <matthew.brost@intel.com>
Cc: robh@kernel.org, "Eric Biggers" <ebiggers@kernel.org>, conor+dt@kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, driver-core@lists.linux.dev
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-8-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-8-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:34:25 +0000
Message-Id: <20260928173427.06F581F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] mm: VM_CRASH_MARK missing from ftrace mmflags VMA flag definitions
- [Low] mm: proc.rst missing documentation for 'cm' VmFlags mnemonic
--

commit 7b00e78975a449ed080eb0472f9ec80a85b781f6
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

mm: Add VM_CRASH_MARK

This commit adds a new VMA flag, VM_CRASH_MARK, to describe folios mapped
into a VMA to the kdump kernel through crash_memaction. The flag indicates
pages to be handled based on the cmdline param, such as secret or cache
pages.

> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index c0d228036b8a6..880946edf4dfa 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1161,6 +1161,9 @@ static void show_smap_vma_flags(struct seq_file *m,=
 struct vm_area_struct *vma)
>  #endif
>  #ifdef CONFIG_64BIT
>  		[ilog2(VM_SEALED)] =3D "sl",
> +#endif
> +#ifdef CONFIG_CRASH_MEMACTION
> +		[ilog2(VM_CRASH_MARK)] =3D "cm",

[Severity: Low]
Since this adds the new cm mnemonic to the smaps output in show_smap_vma_fl=
ags(),
shouldn't this also be documented in Documentation/filesystems/proc.rst so =
users
reading the smaps file can understand what the string means?

>  #endif
>  	};
>  	size_t i;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b9ed4f569b75f..4ffe6350f8655 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
[ ... ]
> @@ -526,6 +530,11 @@ enum {
>  #define VM_ALLOW_ANY_UNCACHED	VM_NONE
>  #define VM_SEALED		VM_NONE
>  #endif
> +#ifdef CONFIG_CRASH_MEMACTION
> +#define VM_CRASH_MARK		INIT_VM_FLAG(CRASH_MARK)

[Severity: Low]
When defining a new VMA flag here, does it also need to be registered in the
__def_vmaflag_names array in include/trace/events/mmflags.h?

If it is omitted, tracing tools capturing mmap or madvise events might outp=
ut
an unknown hexadecimal bit instead of the human-readable crash_mark flag.

> +#else
> +#define VM_CRASH_MARK		VM_NONE
> +#endif

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D8
