Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEA126299;
	Mon, 28 Sep 2026 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616123; cv=none; b=MtKPR0oVl7SVwBTNxkZ4LSwk0Okb+ldxqoGRDUUpIssdh/Tbr8X8C15X4+PecdE/YYhSVjsPBqMhAajFatoJfNYm3cfKb37X9y6O6iaSGJT9gTrVN7f3XW+7Hv3Pl1aWcFq5wD6Stb8ZOmWgn4OwHbUrfKhbJWlKmE7Ge1omodQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616123; c=relaxed/simple;
	bh=OtF9DqDZEloPj7iXxs8U9LPusUCGA2vppCz3CZyXg0Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E/NYANxA2W8AuY7aZZ8SpmOtl0QSJ8hGlVOFbMoB7r7q8WvwpJNYkrHneCpQViPluHUGfNRxrlQ7zYvpsnOO8L7kS4U8FfSdExc7ezn3LG66zWMCJz10BzYTjRs7i5Y/54AsbuIqcIBiGVPilQXJ73Bjxiz89rorm7cV8jLDclc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de; spf=pass smtp.mailfrom=jaseg.de; dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b=dbQnwqwG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rDrxL5x4; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaseg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b="dbQnwqwG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rDrxL5x4"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.phl.internal (Postfix) with ESMTP id D4DE41380050;
	Mon, 28 Sep 2026 13:21:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 28 Sep 2026 13:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790616111;
	 x=1790623311; bh=olwSF3uNVbiXNhlSbfHN88OmJDHwcqFsRULZ6TEZ7DY=; b=
	dbQnwqwGvJptiJWV3zxDZlSDkn8uqo0HXFIE0ICOqd8uZ9OXtFTfTgkgnoQs2aEk
	w6T5994mCCxzWjbPjJVqT8JgZM6Pv9FP3tf5J+401tbQfy7rcNK4QJB8jtWb9fYW
	kJU3IdyFTSrIsC8H+mS5fPlIkPUavVdzX+6WTBSFJLXRm1kTbIF7chVPkia/pajA
	B/vM+7XJ9hrCXXSOJ173Hnk6ELL20UBwUGbdqpknBNuHYVw24O++te8xb71PmAtj
	CgOxRTFQI3zRFPz0sjcZaXIXVp3v3xdX7OqQ6P3Ov3v9YTEv/7G3gPaGg6mMUb0f
	Uoad8qDM6N3nckocuHyXYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790616111; x=
	1790623311; bh=olwSF3uNVbiXNhlSbfHN88OmJDHwcqFsRULZ6TEZ7DY=; b=r
	DrxL5x4jjwMO8a36NJAqiuQ+tBGDl1Vn1IWoxv+sAX9iuH+FGAn2z4IMeZz+fyaG
	UmTYyBnxsQUsFUQv2b9Z0DNnaFHBrnW69QUTSXrgmN4DxBuMoaoeHpPE/c0MGUr0
	+OWr+LRon961uuD4izohqIKvm4pwFxvGt/JhUr3cNfF93JmP6Xtjh92f6lRAnFSr
	SE8AuWKKtkQXHGGqlejODXlsgK8P6kbyqBV4XNfLjvu6/4jYFX40JfmVmCtMWHbf
	OXcFxiWeDrGAPuGtvlXB+aP8r0jNUzk++vmdT2bW8t0wV9wUAfko4DEISxYzAEuy
	q1SBzpcIuXqgzGLPv6QHw==
X-ME-Sender: <xms:L6K6arIsp-cCUlGKr9vOAeLPDX6hVHsPBAKXvmtsRUFDcZwe2iRvEw>
    <xme:L6K6ailST5k0OTaFkL4DbwqSk2fRBDnNp_4QDWgXSzpZoesbPRakPna_0QV9c9AIT
    DwoRoE_JvnBbs88jPS9AWjTkn9dkdjuoU6zE9hNxSSpn_MY19z9ARM>
X-ME-Received: <xmr:L6K6av-tNXS8bADYQUDC8ZXpVExbx-rizJKKlX3muF16uuvOHEtafuRLdJf0AxWT>
X-ME-Proxy-Cause: dmFkZTGQbPrEKBeqiEbZUNbtwb09ozvDcKaPX2bGG4VdNYbMU+7LyhaeiINgn6IUjWkUVC
    6JeDaps5HFM/iVHQBkfCnhUeITcngbOs46DTzpJ8KvHBBayyM5vMO0uohHMN0iPagLm+95
    Rf1dd3pLxz1GzQp/2gzOK2F0n0TFVWoHHloAxxgj18kV4y1s6LHvG6y9wZp+SAkfx0lqDS
    6+w2KnfcZVDjO3JLly6DGMBpywLp/GX5H1OE+vex7vwjXGaMwlcbDb4BamiBu6catKWgzf
    i0JoJoKItLv8231p2gQ7Z4FeLva21ZLwkVm+uIm+lkrRoLKPavhRV5MYmoHTX3B5pG+gJE
    mgxJ6jMnMrw2kF482XHxzUGcG5YwlHv4x+SFyrc5T6Z0Lfr3urEuSCKwI/VCz24ul4doIT
    OFRSi/9VlGSrGIhdLmjarMb32SBmTyO8AKI4AXVZRQJQybE+lz33EAzCj5x0ELuVCk5Rfa
    m1TEY5rMapnCV7CGN27IakeeOyRyXrhcVMhHv972PXUlJD4hxd0Iv1exZB2rkFqGrEZvBf
    mde8p+CpkUmDZ5hOkl4OweX7iK0rM7DUCQGs1kCixlQDIl8dCflcnqqnlIqMwFvXjx34z5
    O97ucpQ53u8thcXyAWpFFvCUUdyxbRITMhM2jASS/W/sg0DH08oEh2+PAWPQ
X-ME-Proxy: <xmx:L6K6atbejyNWkDZ5Myfw8vpfMJyJJ8ey23mDjTj8XCSoRMe1YNTqPQ>
    <xmx:L6K6asfKSNdGNMePMyW-FoXevmUmitKy4mBHpCa1OaYU7CGIpcLftA>
    <xmx:L6K6alHW_9apoX-EtKikHRv24CI94EbDrU_MFBWwMqorCF_a86GMeg>
    <xmx:L6K6anOYTd-zpwW17XDdAiyx6p--ln1secO0Xgu7Eo2jhxkPgFQ1og>
    <xmx:L6K6av09XGtqYulP8xrMqaO1V5PZeToPxh9LGqv3WKI1jdG99f63t_CD>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:21:30 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:17:59 +0200
Subject: [PATCH v3 11/12] Documentation/mm: Document the crash memaction
 registry
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-11-e511e9ee2329@jaseg.de>
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

Describe the crash memaction registry, including its kernel and userspace
interfaces, allocation lifetime rules, and current limitations.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 Documentation/mm/crash_memaction.rst | 59 ++++++++++++++++++++++++++++++++++++
 Documentation/mm/index.rst           |  1 +
 MAINTAINERS                          |  1 +
 3 files changed, 61 insertions(+)

diff --git a/Documentation/mm/crash_memaction.rst b/Documentation/mm/crash_memaction.rst
new file mode 100644
index 000000000000..3658bff7693c
--- /dev/null
+++ b/Documentation/mm/crash_memaction.rst
@@ -0,0 +1,59 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+Crash memory actions
+====================
+
+`CONFIG_CRASH_MEMACTION` provides a mechanism for the running kernel to
+communicate a single bit attribute per memory page to a kdump kernel. This
+feature can be used by the kdump kernel to exclude certain pages (e.g. holding
+crypto secrets, or cache) from the system memory dump, or to wipe their contents
+after a  crash.
+
+The meaning of the registry bitmap is set by the ``crash_memaction=`` kernel
+cmdline parameter. The running kernel only sets the bits for the tracked pages,
+and it's up to the kdump kernel to do something with them.
+
+	``crash_memaction={secret|cache}``
+
+Right now, ``secret`` tracks pages containing kernel crypto keys as well as
+pages explicitly marked using ``madvise(2)``. ``cache`` currently only tracks
+pages marked from userspace using ``madvise(2)``.
+
+Kernel users
+============
+
+Kernel code can mark a virtual range in the linear map or in vmalloc space::
+
+	void crash_memaction_mark(void *addr, size_t size, int types);
+	void crash_memaction_unmark(void *addr, size_t size);
+
+Marking is safe from any context and cannot fail. Markings last until the page
+frame is handed out to another user to cover stale data left over after the page
+is free'd.
+
+For objects smaller than a page, lib/secret_pool provides allocations from a
+"secret" marked kmem_buckets. Objects can be allocated through secret_pool
+without the need for any additional lifetime/marking tracking.
+
+Userspace interface
+===================
+
+For userspace code, ``MADV_CRASH_SECRET``, ``MADV_CRASH_CACHE`` and
+``MADV_CRASH_RESET`` are provided for use with ``madvise(2)``. Marks show up in
+``/proc/pid/smaps`` as ``cm`` VMA flag. Only anonymous, shmem and hugetlb ranges
+can be marked. Marking is transparent to swapping and lazy allocation.
+
+Limitations
+===========
+
+* This mechanism is best-effort. During a crash, nothing can be guaranteed. At
+  page level granularity, some over- or under-marking is to be expected.
+* Marks are tracked only for *mapped* folios, so a shmem file only ever written
+  with ``write(2)`` cannot be covered.
+* A single ``madvise(2)`` call on a folio mapped into several processes globally
+  (un)marks it for all of them.
+* Marks are tracked at page level granularity. There is no refcounting. When
+  trying to mark smaller objects, use lib/secret_pool or a similar mechanism.
+* Memory hotplug is not supported at this time. When memory is hotplugged, the
+  newly hotplugged memory will not be included in the bitmap.
diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 13a79f5d092c..4cdfc5030a56 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -54,6 +54,7 @@ documentation, or deleted if it has served its purpose.
    allocation-profiling
    arch_pgtable_helpers
    balance
+   crash_memaction
    damon/index
    free_page_reporting
    hmm
diff --git a/MAINTAINERS b/MAINTAINERS
index bcb11c2138bc..269b8be6c222 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14256,6 +14256,7 @@ L:	kexec@lists.infradead.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/admin-guide/kdump/
+F:	Documentation/mm/crash_memaction.rst
 F:	fs/proc/vmcore.c
 F:	include/linux/crash_core.h
 F:	include/linux/crash_dump.h

-- 
2.55.0

