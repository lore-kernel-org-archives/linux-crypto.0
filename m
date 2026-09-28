Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F10F4E9C25;
	Mon, 28 Sep 2026 17:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790615960; cv=none; b=BlET/BSdBWmQj6AYndD35mxfks41bPi/uvoBZn0tQtD/Hd21oqFFPBSdGE2swYNSZ2YI6JkugTGx8l9PdtR5saZh7/Br/TukN4YApCjz5sODhDKM7X/v8khPyObpWRZutv7OxN//ciheEgU7EQx/DGPVBMIg+Ycdz88d/ccsa7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790615960; c=relaxed/simple;
	bh=TDjO0UsQlhkzIb05fcHxHXBmSygELW368uKDQukO1U0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bPQj+MWQlJuN+8mbM6gy2bTOyoFAQcc7SwjawcWmw7RJJfpDuqwAQED+VIy0ImFyHdUGUmu4kQswQSQyUL/nEApzPvWVxyznrUvfre/hABOZLNiRTDcUXsJ2okSpIjBlokOI8o9sM4Os9zMf6BycIPMAKASESCO3jS1ZQ4ko0DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de; spf=pass smtp.mailfrom=jaseg.de; dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b=USSes1s6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=d5SizAxE; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaseg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b="USSes1s6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="d5SizAxE"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 379EA13804E3;
	Mon, 28 Sep 2026 13:19:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 13:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790615956;
	 x=1790623156; bh=8Eqqf0HCSBZT/jI6NYBtGEMXZWPAcZ1W8yz5dAV6pIs=; b=
	USSes1s6BJwzq2EyJPOgLyoA42m2Szuaxg4fHYdIVEsM6a+c+5B4jtmOsypYMet2
	cWlRH2UFJwV4SihUHQZepiNd44Wi6vzbuQpsoNBHUgweIIVbH2KC50Lx62NWHvG9
	A23UQGj36gRTv8fA8FSlNzVQ+9dJjkrf1y3a7Sk3dIRc3mzxS8RMECD5zmPP7hLz
	gaohdpUSF76np+amLfmoXxSe3MNXOmAAMbJ/Pg8b1euJLK4+hdUXum3Yc3Gzkd0Y
	HTv081m46OYKMT2VPDuSTdDSqHQQQBTPg2aJraTBGR11T5L0vlEi+CNw2CY6GyVZ
	SDAMWGuGckkeG2peEGKLoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790615956; x=
	1790623156; bh=8Eqqf0HCSBZT/jI6NYBtGEMXZWPAcZ1W8yz5dAV6pIs=; b=d
	5SizAxEG4NEtVBU6Noa1+LIMQWPIToaS6fW+puNNNuq8kJJY88cjAj+Pz2tIlU58
	YTuFRaDvBWy23WXE5etBTx+xq3aFDeAz+wDoYboEk32Dxg4N7elNhP2mmZSoLQ/d
	tcQ/mXessBCQt1vxCegaA5B6TC4Db4tt6myNJwu1OBDXHmvHULTEzxQ0uh6S2evY
	dxmej9z320SVslK7tqi4A8H9CBEKcmfV3xm0A1+JoIPjlRumuBmTjBumCiYNkhen
	SYXV60omyaSV90HrnQWIbEC6aApEO2axgaqMKwrpRN8/+ycwdEJj2iGkqk3ZNTZR
	m12di5ScZTVY1KizjbGgw==
X-ME-Sender: <xms:lKG6anrrKOx5fQu0pRHdyb_8aX7jttAfKxIJo83VFXIL6Xs8FC4Huw>
    <xme:lKG6alE9VWbFN4WInjtakYZ8jaFoM7EXWUUf35w3iWnBKqIjBNr0Cxcug0o-vw7Se
    qmtkn17fAob1cNbqzJLaMVXFkTeIPUH4v3FEInPlDAYv9XCWB1fmWc>
X-ME-Received: <xmr:lKG6age-4IlQC6waNKqVglG8gWemRJrYAaTw0aS9gQyEc6a1pHTj1Alenfwm77Dz>
X-ME-Proxy-Cause: dmFkZTE3Dtw6IjhE/poi/CDPb5VXEYPNUPEe3rZRr1/3vnluvSNGZwYnc7Od0VEEqw6V8C
    kWRAMYAJAJV5aq+CNT4OFQyy1fVW8k3upxKlO9V7Rt5yUqYEIYE/wijeDPsE7H4gglp/5v
    F6D384IbY5FCBCgoXmGheBdMQQxOBU4ICiAnYejBlRLhJ/CKeqEcgPSAZh68CS/pdW/x+j
    oysMrjjAyGFH6oDZSV+ReHQBDpEH3XjCRs+r4WEsyv+LCLa1ZQRyjrSR6cKgS0Pi5Ve0FP
    CSaf3rI2+ul2/rPFwdCO88CC3NXOaOC07b4Jq2/gPXxONS3ydc229KCVcj4zNvzLHbXFTv
    Y87bfWoHF8P/EF1BtBuJNXri5Y3jHaQznC4c8pM9EDVGJlvXB+ULU56B2/xFp63H3ba76F
    ETaiTGM2+CV9ko/CMXbIA9HXJjVdDn9iwfU9WAkbJ/ktRKz+VCLmlAYjeMQn7eBHDTw/ME
    H7h06B41486MeTNdQ9ihuVImVcZBasvjpa1q3RUWa62/9W6wN7P2jLHSxRBDt9MrP/YHXe
    yrbQCcC5uo2HHogi63k5CazEKRjwFJ5SVg0gWg1DAf6rLjz1AVmATi0NJYKMjfy3jLjC7K
    HX9wF3F9j1o+o0BJlm5e/UuJNK9Ajp2fhlMmmNKWUkt8i5EfZhPcrAzoAV5g
X-ME-Proxy: <xmx:lKG6aj7iLMXS2IlkVZUzLevRbPUirNqNRSORUvG3PpJrzNlf5yEDsg>
    <xmx:lKG6ag-uEgxLdKGbT4N_esjjUBU5IE4qYbp-u5jgSkmAi6zYPZIAHQ>
    <xmx:lKG6avlLiKnKM3qjhyvlZyIHz4mXK79aSCnDuBirhZA0GO48uy4aRA>
    <xmx:lKG6avug_EOHI9_lLLqxGtOHFgEkNxUv_BXJRivr3cNdSU27Lwm3BA>
    <xmx:lKG6ar7342olHzHcQDVc978gVOkRg_kTwspjmX12JEl7Udkf-niszRQM>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:19:02 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:17:51 +0200
Subject: [PATCH v3 03/12] mm: Wire up the crash memaction registry
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-3-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
To: Jonathan Corbet <corbet@lwn.net>,
  Shuah Khan <skhan@linuxfoundation.org>,
  Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh@kernel.org>,
  Saravana Kannan <saravanak@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <brendan.jackman@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  Mark Rutland <mark.rutland@arm.com>,
 Alasdair Kergon <agk@redhat.com>,  Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>,
  Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Mimi Zohar <zohar@linux.ibm.com>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>,  "Serge E. Hallyn" <serge@hallyn.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,  Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,  Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,  Lance Yang <lance.yang@linux.dev>,
  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
  Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
  Matthew Brost <matthew.brost@intel.com>,
  Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,
  Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
  Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, 
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2

Allocate the registry bitmap during boot and sync marked pages to the
bitmap.

The registry bitmap is handed over to the kdump kernel through physical
addresses and thus needs to be a single, physically contiguous range.

A marking lasts past free and until the page frame is handed out again
in post_alloc_hook() to account for stale data left in pages that are
mid-migration or currently being reclaimed. For the same reason the
unmark comes after any init_on_alloc zeroing.

A hugetlb folio coming out of the pool never passes through
post_alloc_hook(), so it drops the marking of its previous life in
dequeue_hugetlb_folio_node_exact() instead. A folio the pool got from
the page allocator was already cleared in post_alloc_hook.

The hooks sit behind a static key patched out unless the kernel was
booted with crash_memaction= to mitigate overhead when not used.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Assisted-by: Claude Opus 5 <noreply@anthropic.com>
---
 mm/hugetlb.c    | 4 ++++
 mm/mm_init.c    | 3 +++
 mm/page_alloc.c | 6 ++++++
 3 files changed, 13 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da980377d353..36f0c0d8f5f1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -31,6 +31,7 @@
 #include <linux/numa.h>
 #include <linux/llist.h>
 #include <linux/cma.h>
+#include <linux/crash_memaction.h>
 #include <linux/migrate.h>
 #include <linux/nospec.h>
 #include <linux/delayacct.h>
@@ -1281,6 +1282,9 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+
+		crash_memaction_unmark_pfns(folio_pfn(folio),
+					    folio_nr_pages(folio));
 		return folio;
 	}
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9ce6060de06d..2245972b2685 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -27,6 +27,7 @@
 #include <linux/stackdepot.h>
 #include <linux/swap.h>
 #include <linux/cma.h>
+#include <linux/crash_memaction.h>
 #include <linux/crash_dump.h>
 #include <linux/execmem.h>
 #include <linux/sizes.h>
@@ -2706,6 +2707,8 @@ void __init mm_core_init(void)
 	 */
 	kho_memory_init();
 
+	crash_memaction_init();
+
 	memblock_free_all();
 	mem_init();
 	kmem_cache_init();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 759786240af3..ff82f632dc7d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -54,6 +54,7 @@
 #include <linux/khugepaged.h>
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
+#include <linux/crash_memaction.h>
 #include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
 #include "internal.h"
@@ -1854,6 +1855,11 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
 	pgalloc_tag_add(page, current, 1 << order, alloc_flags);
+
+	/*
+	 * Release leftover crash_memaction markings from a previous owner of this page.
+	 */
+	crash_memaction_unmark_pfns(page_to_pfn(page), 1UL << order);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,

-- 
2.55.0

