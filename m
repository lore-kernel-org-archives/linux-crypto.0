Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2894534887B;
	Mon, 28 Sep 2026 17:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617309; cv=none; b=Ad79XkFjjInFIitRpV1k0IkjnlXADHKgoWKSPmYzNHt05nRUnPkDG0uTTWhJT6gQk+kZgW9TX+oS97gAJwEqUJt5xyoPdduc8QiVK9zn5XgMbU7vfpz1Xx1GEEtKE2z14iMraYPoXu9UNrhaHEvW1lz9fT8QxfL/zQHwvejHB7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617309; c=relaxed/simple;
	bh=w1V0FmqumbUaFEHbOuDQCMioksi2L79HUj2fl85SiJw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AnGiJNdAbdnoiNTl4rSkxPdPk9NZfaOf4m9DKW7WoiYBiclQNXGJQSZFdokrAH6NFjq8Bk4QBJMe3NWq9SKQ13HHgThl2TgWL3qO28AvH8HLeAFDils34p2vmBq3Euz3N/DYsExzdOatKGf5sYdRnKXfmfIH39GAT7jaxo7EzbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ji81w2P3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ji81w2P3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864EC1F000FF;
	Mon, 28 Sep 2026 17:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617307;
	bh=bio2Y9F5gf2JUjQfJ3HNyq0KHsAJNYGF0LSeTxxnRz8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ji81w2P3OvwBwZ+SfBFlHppqHkwIgn8FNMqhUbCYfyrtsaGSgA9Y6NadfxtKqDtRc
	 G4hk/u46xqtuPWC1WCpBVreTPBuXwixIjfMEu0mDHhK/yMVG/8eIF2HlGo0kMQffMf
	 GqY3YbTg8UX/0lArRf2Amw2MEp9DpkyGyR7xex0Cuy3ZMS/5rMC6JADOdNgpWV4rFN
	 kZuEXyrTKpE4uJ66bwwrBN31kdfBimpDoR6N//XUlwV7lAMzWVLvUYB/LTnxAzIL4w
	 Ubs2S8JTCuzXg/VukK3Y+Ks57iOqlME4Epo1KIkexQOk3ASeJyXF0S49fZzlm8sR60
	 LrxzI3InFhyvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/12] mm/rmap: Mark folios mapped into
 crash_memaction-marked VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serge E. Hallyn" <serge@hallyn.com>, "Suren Baghdasaryan" <surenb@google.com>,
 =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Baoquan He" <baoquan.he@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Mike Rapoport" <rppt@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Dev Jain" <dev.jain@arm.com>, "Zi Yan" <ziy@nvidia.com>, "David
 Howells" <dhowells@redhat.com>, "Alasdair Kergon" <agk@redhat.com>, "Arnd
 Bergmann" <arnd@arndb.de>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Dave Young" <ruirui.yang@linux.dev>, "Rik
 van Riel" <riel@surriel.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Nico Pache" <nico.pache@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Jann Horn" <jannh@google.com>, "Barry Song" <baohua@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Danilo
 Krummrich" <dakr@kernel.org>, "Mike Snitzer" <snitzer@kernel.org>, "James
 Morris" <jmorris@namei.org>, "Mark Rutland" <mark.rutland@arm.com>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Peter
 Xu" <peterx@redhat.com>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Paul Moore" <paul@paul-moore.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Byungchul Park" <byungchul@sk.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Will Deacon" <will@kernel.org>, "Rob
 Herring" <robh@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "Michal
 Hocko" <mhocko@suse.com>, "Saravana Kannan" <saravanak@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Kiryl Shutsemau" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, "Eric Biggers" <ebiggers@kernel.org>, linux-integrity@vger.kernel.org, robh@kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org, driver-core@lists.linux.dev, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, dm-devel@lists.linux.dev, devicetree@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-crypto@vger.kernel.org, conor+dt@kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-9-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-9-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:41:43 +0000
Message-Id: <20260928174143.864EC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] mm/userfaultfd: UFFDIO_MOVE misses crash_memaction registration =
for swap cache
- [Medium] mm: stale crash_memaction marks when moving pages to unmarked VM=
As
- [Low] mm/rmap: data race on vma->vm_flags in crash_mark_pages()
--

commit 78115d9186907359bdb879efc1ef14d161aac39a
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>
Subject: mm/rmap: Mark folios mapped into crash_memaction-marked VMAs

This patch propagates crash_memaction marks set through madvise() to the
crash_memaction registry. It registers folios of a VMA carrying VM_CRASH_MA=
RK
as they are mapped, and updates the registry when a folio moves. It also ho=
oks
into the free path to deregister pages and avoid tracking stale data.

> diff --git a/include/linux/crash_memaction.h b/include/linux/crash_memact=
ion.h
> index 5f3e114c60ad7..2de60bc12dd9f 100644
> --- a/include/linux/crash_memaction.h
> +++ b/include/linux/crash_memaction.h
[ ... ]
> @@ -50,6 +51,18 @@ static inline void crash_memaction_unmark_pfns(unsigne=
d long pfn,
>  		__crash_memaction_unmark_pfns(pfn, nr_pages);
>  }
> =20
> +static inline void crash_mark_pages(struct page *page, int nr_pages,
> +		struct vm_area_struct *vma)
> +{
> +	if (!static_branch_unlikely(&crash_memaction_active))
> +		return;
> +
> +	if (likely(!(vma->vm_flags & VM_CRASH_MARK)))
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Low]
Should this lockless read of vma->vm_flags use READ_ONCE()?

The crash_mark_pages() function is called via folio_add_anon_rmap_ptes()
during migration (such as in remove_migration_pte()) holding only the
anon_vma lock. At the same time, mprotect() can update vma->vm_flags
while holding the VMA lock, but not the anon_vma lock.=20

Could this concurrent modification lead to a data race or torn reads during
migration?

> +		return;
> +
> +	__crash_memaction_mark_pfns(page_to_pfn(page), nr_pages);
> +}
> +
>  void crash_memaction_mark(void *addr, size_t size, int types);
>  void crash_memaction_unmark(void *addr, size_t size);
> =20
[ ... ]
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3fb9504dff7a9..adbda968d58ef 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2966,6 +2966,8 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t=
 *dst_pmd, pmd_t *src_pmd, pm
> =20
>  		folio_move_anon_rmap(src_folio, dst_vma);
>  		src_folio->index =3D linear_anon_page_index(dst_vma, dst_addr);
> +		/* No rmap add, and the two VMAs need not agree on the flag. */
> +		crash_mark_pages(&src_folio->page, HPAGE_PMD_NR, dst_vma);
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Medium]
How are stale crash_memaction marks handled when moving to an unmarked VMA?

If a process marks a VMA with MADV_CRASH_CACHE, then moves an exclusive
anonymous page to an unmarked VMA via mremap() here in
move_pages_huge_pmd(), the destination VMA is checked but the source VMA
is not unmarked.

Because the new VMA lacks the mark, a subsequent madvise(MADV_CRASH_RESET)
will short-circuit and fail to unmark the pages. Will these pages remain
permanently marked and excluded from kdump dumps until freed, potentially
risking data loss?

> =20
>  		_dst_pmd =3D folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
>  		/* Follow mremap() behavior and treat the entry dirty after the move */
[ ... ]
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index b242fa8b22c8c..bb0a35d59daa9 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1326,6 +1326,7 @@ static long move_present_ptes(struct mm_struct *mm,
> =20
>  		folio_move_anon_rmap(src_folio, dst_vma);
>  		src_folio->index =3D linear_anon_page_index(dst_vma, dst_addr);
> +		crash_mark_pages(&src_folio->page, 1, dst_vma);
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Medium]
Similar to the mremap() case above, does move_present_ptes() fail to unmark
the PFN if the page came from a marked src_vma but is moving to an unmarked
dst_vma?

[Severity: Medium]
Are we missing crash_memaction registration for swap cache folios during
UFFDIO_MOVE?

While the rmap is updated for present PTEs with a crash_mark_pages() call
here, the parallel move_swap_pte() path in mm/userfaultfd.c seems to
omit it:

	if (src_folio) {
		folio_move_anon_rmap(src_folio, dst_vma);
		src_folio->index =3D linear_anon_page_index(dst_vma, dst_addr);
	} else {

If a process marks a VMA with MADV_CRASH_SECRET, and then uses UFFDIO_MOVE
to move a swapped-out but swapcache-resident page into this VMA, the page
registration is skipped. If the system crashes before the page is faulted
in, is there a risk that the kdump kernel will dump the unmarked RAM and
leak the secret data?

> =20
>  		orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_page_prot);
>  		/* Set soft dirty bit so userspace can notice the pte was moved */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D9
