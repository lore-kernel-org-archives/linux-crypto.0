Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D9E4F30EF;
	Mon, 28 Sep 2026 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616927; cv=none; b=TJZuUaKnz5QekG6LX9kDcPQegcZ9q4xv4jLyvuj5fZ7PuKciUGfzEukaVlSdc5cJVyKKYOBUKTAjVrrNYJRXv8oxJlIR6eCZHTtu19rOC2TMGygLeiowG9oXG4eyW3b9GtSGPw7ngmsLO2UJIlOGWpw9jCQhST/vLCjWY2FoSJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616927; c=relaxed/simple;
	bh=a4lZX1e4/G7E7zoiiPGuLQny40pLt5lDAq0/0qKyC/o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P7UsZ2DgpeDCAHjUuJV/QkWdDb181QOYL7OfUF0SBrPiTwCPHyqyeNdK2icVO7Yq94KS2b3WILiFTdvxrkNBexlC4SKtYrrlijOLZo+PZRWLMcrN+mEZ558uJBJV/k3BJEDQYdpYuVjilvkASi9B52skbG+qbI9QDBCHtWW4RZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgJleyjF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgJleyjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064A71F00893;
	Mon, 28 Sep 2026 17:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616925;
	bh=1wgoeoJYPRfg3GcR5cNgIa+KIwSHuCasXM5odxS1hrI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JgJleyjFQgWpfSJkA6nyiCqqkWAAQHtWpxUxiVpk/gtQMO+5K7zLj5gw60+XRVrxG
	 DOxpA1mOKjw+UpOYOeAT8dGi1rHv4aXAS/klnjPQQTsZ8M2A7aHg9r5h38IBTnycHr
	 Iq3i3uWPDRV0Ha6SOjYiot9MUb80bIaPo4t9fvVIUc5TN2bKqu+nC4zb5/1aJcNHSp
	 8yrxScOB5GeImFdiGk8r9MJ+cXNpADyVXtzcldQsWRluad0eoZommMs41pDQElhyDf
	 TXYaXwVdcTkN3AXpUXfrkwTpLtLbSwRpIfEdx6NbmMkCLCcvUN8Dc1I/37mSc4kT+z
	 YLFq0XLOxp1iA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/12] mm/madvise: Add MADV_CRASH_SECRET,
 MADV_CRASH_CACHE and MADV_CRASH_RESET
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serge E. Hallyn" <serge@hallyn.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Barry Song" <baohua@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "James Morris" <jmorris@namei.org>, "Jann
 Horn" <jannh@google.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Zi
 Yan" <ziy@nvidia.com>, "David Howells" <dhowells@redhat.com>, "Saravana
 Kannan" <saravanak@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Matthew
 Brost" <matthew.brost@intel.com>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Rob Herring" <robh@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Pedro
 Falcato" <pfalcato@suse.de>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@suse.com>, "Arnd Bergmann" <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, "Alistair
 Popple" <apopple@nvidia.com>, "Alasdair Kergon" <agk@redhat.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Nico Pache" <nico.pache@linux.dev>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Peter
 Xu" <peterx@redhat.com>, "Mike Rapoport" <rppt@kernel.org>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Muchun Song" <muchun.song@linux.dev>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "David Hildenbrand" <david@kernel.org>, "Rik
 van Riel" <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Baoquan
 He" <baoquan.he@linux.dev>, "Byungchul Park" <byungchul@sk.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Dave Young" <ruirui.yang@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Mike Snitzer" <snitzer@kernel.org>, "Usama
 Arif" <usama.arif@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, "Mimi
 Zohar" <zohar@linux.ibm.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-integrity@vger.kernel.org, conor+dt@kernel.org, keyrings@vger.kernel.org, devicetree@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kexec@lists.infradead.org, dm-devel@lists.linux.dev, robh@kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-10-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-10-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:35:21 +0000
Message-Id: <20260928173522.064A71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: MADV_CRASH_SECRET skips migration entries leaving secrets unpr=
otected
--

commit bd54b0316a2281079a7116bef1937bfde7198adf
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

mm/madvise: Add MADV_CRASH_SECRET, MADV_CRASH_CACHE and MADV_CRASH_RESET

This commit introduces new madvise flags allowing userspace to mark pages
containing secrets or unimportant cache data. These marks are registered in=
 a
bitmap for the kdump kernel to process during a crash dump.

> diff --git a/mm/madvise.c b/mm/madvise.c
> index 00b1be655a8b5..37f08334e95a8 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
[ ... ]
> @@ -1173,6 +1175,98 @@ static long madvise_populate(struct madvise_behavi=
or *madv_behavior)
[ ... ]
> +static int crash_mark_pmd_entry(pmd_t *pmd, unsigned long addr,
> +		unsigned long end, struct mm_walk *walk)
> +{
> +	pte_t *start_pte, *pte;
> +	spinlock_t *ptl;
> +
> +	if (fatal_signal_pending(current))
> +		return -EINTR;
> +
> +	ptl =3D pmd_trans_huge_lock(pmd, walk->vma);
> +	if (ptl) {
> +		pmd_t pmdval =3D *pmd;
> +
> +		if (pmd_present(pmdval))
> +			madvise_crash_mark_pfns(walk,
> +				pmd_pfn(pmdval) + ((addr & ~PMD_MASK) >> PAGE_SHIFT),
> +				(end - addr) >> PAGE_SHIFT);
> +		spin_unlock(ptl);
> +		return 0;
> +	}

[Severity: High]
Does this code leave secrets unprotected if a migration is occurring
concurrently?

If a PMD is temporarily unmapped during a migration (such as background
compaction or NUMA balancing), pmd_present evaluates to false. This
code skips the PMD without marking it and returns 0, leaving the entire
2MB range unprotected in the crash memaction bitmap. Once the migration
completes, the restored page remains permanently unmarked and will be
dumped.

> +
> +	start_pte =3D pte =3D pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> +	if (!start_pte)
> +		return 0;
> +
> +	for (; addr < end; pte++, addr +=3D PAGE_SIZE) {
> +		pte_t ptent =3D ptep_get(pte);
> +
> +		if (pte_present(ptent))
> +			madvise_crash_mark_pfns(walk, pte_pfn(ptent), 1);
> +	}

[Severity: High]
Similarly, does this loop silently skip non-present PTEs like migration
and device-exclusive swap entries?

When userspace calls madvise with MADV_CRASH_SECRET, it expects the
memory range to be marked. Checking only pte_present skips resident
physical pages that are temporarily unmapped for migration. Since the
rmap hooks only see the flags as folios arrive, these skipped entries
never get added to the bitmap, potentially leaking sensitive data in a
crash dump.

> +
> +	pte_unmap_unlock(start_pte, ptl);
> +	cond_resched();
> +	return 0;
> +}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D10
