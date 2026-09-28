Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C684EA396;
	Mon, 28 Sep 2026 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617110; cv=none; b=HBrYZUzdvPQ90k0udXIJJtgGcSxOTIzVciIwy78DfcSLjmOc9bpxiifQl4eDTZ5dzEGAiA4Ba5K8yfGLWz3kpGY6A9alYxE3IXXq9cN+k2rcjzojRo4Du7ZSq09vIzBeM48msQhZqhi4LPofBgCc6NCcFlNpOTofEDp6vxTkG0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617110; c=relaxed/simple;
	bh=xJhbTHO7wEMk0X/yuss96Wwdr3iGorXMFwRDRJGF3Qg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iU0WdGLWCQwDFCabjDeALL29VBOcGQASgXQU68KR0Rx1vUkLTYnj5GGRtbOFGryqDq6uwTJEst0eeToyaX8aQfYWYuAV/avQFhO3HIjcaZiWl3bj7ygspQExGxydGWnDYX2gWDkL/yoL3FzJ+TyzGATGost1XBT8Nz/m8C56DTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gq48WQDi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gq48WQDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D2B1F000FF;
	Mon, 28 Sep 2026 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617109;
	bh=XQwrxz5DxAOSOS9tl6JASwUQOclPkIJdyJDy+q6eIS8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gq48WQDii6Y2wXwqk2Dl5BFMHy7xKx8TTGraKfDWphG9muDmzzP3BKh9CjmfaLF3b
	 OGISBa4ZzYAkBhG9XfSWCUruhzX8uzuilGXlekZydznqvNfrHD6aMMPjaFLjnJiqvv
	 RS0BJPSDgMDpCXRjmHgUqyuIVax/AU7gXUFbYIKly2dx7CBfFuJMxfvmYz+ffoS2uo
	 iQcT5DQH44SZc0420Lhot1F8XmVL3de4jo5/eFDKxyEydTB6dleUSgAgMjplshTKNs
	 z7HPMxwt4Jj4/m6ojc0dHEtXTm0zh80Jt2ohM7T5bFSATpMbyO4Q9pIhcs2aP1aCif
	 ZFYMCktn4VFEw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/12] mm: Wire up the crash memaction registry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jann Horn" <jannh@google.com>, "Nico Pache" <nico.pache@linux.dev>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Lance Yang" <lance.yang@linux.dev>, "Baoquan
 He" <baoquan.he@linux.dev>, "Harry Yoo" <harry@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Gregory Price" <gourry@gourry.net>, "Arnd
 Bergmann" <arnd@arndb.de>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Serge
 E. Hallyn" <serge@hallyn.com>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Pedro Falcato" <pfalcato@suse.de>, "Barry
 Song" <baohua@kernel.org>, "Peter Xu" <peterx@redhat.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Liam
 R. Howlett" <liam@infradead.org>, "Matthew Brost" <matthew.brost@intel.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Alasdair Kergon" <agk@redhat.com>, "Rob
 Herring" <robh@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Oscar
 Salvador" <osalvador@suse.de>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Jarkko Sakkinen" <jarkko@kernel.org>, "Rik
 van Riel" <riel@surriel.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Dave Young" <ruirui.yang@linux.dev>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Byungchul Park" <byungchul@sk.com>, "David
 S. Miller" <davem@davemloft.net>, "Saravana Kannan" <saravanak@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Mike Snitzer" <snitzer@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Mimi Zohar" <zohar@linux.ibm.com>, "Paul Moore" <paul@paul-moore.com>, "James
 Morris" <jmorris@namei.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Will
 Deacon" <will@kernel.org>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Jonathan
 Corbet" <corbet@lwn.net>
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-fsdevel@vger.kernel.org, devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org, linux-arch@vger.kernel.org, kexec@lists.infradead.org, robh@kernel.org, dm-devel@lists.linux.dev, conor+dt@kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-3-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-3-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:38:25 +0000
Message-Id: <20260928173825.79D2B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: Stale secret data exposed due to premature unmarking of hugetl=
b folios
--

commit 62d401cf60aea442c3fea654492895fe956cadd9
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

mm: Wire up the crash memaction registry

This commit allocates the crash memaction registry bitmap during boot and
syncs marked pages to it. It introduces hooks to unmark pages when they are
handed out, placing the unmark after zeroing for page allocator folios, and
in dequeue_hugetlb_folio_node_exact for hugetlb folios.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index da980377d3533..36f0c0d8f5f14 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c

[ ... ]

> @@ -1281,6 +1282,9 @@ static struct folio *dequeue_hugetlb_folio_node_exa=
ct(struct hstate *h,
>  		folio_clear_hugetlb_freed(folio);
>  		h->free_huge_pages--;
>  		h->free_huge_pages_node[nid]--;
> +
> +		crash_memaction_unmark_pfns(folio_pfn(folio),
> +					    folio_nr_pages(folio));

[Severity: High]
Can this expose stale secret data to a crash dump if a crash occurs before
the folio is zeroed?

When a hugetlb folio containing secret data is freed to the hugetlb pool, it
retains its crash_memaction mark. When dequeued here in
dequeue_hugetlb_folio_node_exact(), it is unconditionally unmarked before
being returned.

Because the caller is responsible for zeroing the folio later via
folio_zero_user(), a window exists where the kdump kernel could observe an
unmarked folio and include its unzeroed secret data in the dump.

(Note: A similar window appears to exist for THP allocations when
init_on_alloc=3D0 because THP is allocated without __GFP_ZERO, causing
post_alloc_hook() to unmark it before the fault handler zeroes it.)

Could this unmarking be delayed until after the folio is zeroed?

>  		return folio;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D3
