Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59814E431D;
	Mon, 28 Sep 2026 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790615932; cv=none; b=kos1Yz1EDuOIWKJ23K8BKNA6cVIyoR2ne6eVjla6UoHIl0U4MONA/Wyf4UJOCL8saH5R4J7MCMf+8jGAgYQec4XmRkT+1BMtJO1a3LfrezgxSOVoXF+o4dALQ9OIorvhu13V0ELROT5aRfF7djNUqGAuhkRZxStMSLSokgERN34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790615932; c=relaxed/simple;
	bh=9SRs8/rOn26by3iMG8hdNCf/UvAHGDeYY9ugeeoN3Q8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hSMWxyKEl+xA9bmiLfq9AgvqsMijhFnqbYBuo7duuHfkeZLxSi2nq2lPV6UR60pmiTzxpAQYJvhB5wYia1fIezPO/++LwRg3MMdzzLm9XBzU2ZD6s2GynEV0YteGiHqw5Rql2Bvb+MbMUwtm1lDA3Wa/MU73GhRAsjH0x87n0p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de; spf=pass smtp.mailfrom=jaseg.de; dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b=DNLZl1/b; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SrAbGVu9; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaseg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b="DNLZl1/b";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SrAbGVu9"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 9F7B213804B9;
	Mon, 28 Sep 2026 13:18:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 28 Sep 2026 13:18:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790615927;
	 x=1790623127; bh=VyoQd+XYtM8MalSS97WFivUhH9Nv0sgsXiDNIKjETw0=; b=
	DNLZl1/bJrT5NIjybkb4OcN5gX9nO9HlgO0o/1yECxU9RsJH0eQRX2/tGlzQapiD
	t/ODi+9mJlnkcMQTQcyWzQXoEsyoHvF5ZK0ouFuagMfBjIrCQXuHM7QM7ahpDh+J
	uLk2uXsFHRSkm6PvIZrLn8B05ybj88yeXAVsRxrROabHUUybRiZqZpy4lQ/3Y4Xj
	CRBwOpN10VIVIjyvpEGuR1TZ151mZPayn9r/+EpOQDlPZD8GFShEegK0gcIeonqM
	mPK2Th1x0JWvd7bytRDQz3Bf20Phxav5RqknSftK6ed0aAo+J10UBnkps5bDYEqm
	5PQm7Om2vgfMcN2PF4bVPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790615927; x=
	1790623127; bh=VyoQd+XYtM8MalSS97WFivUhH9Nv0sgsXiDNIKjETw0=; b=S
	rAbGVu9aLQZgQZRMI2tR/vZmt4ILLLCbc2rUUPmXFef2+El3STE6fhYAf428iRs/
	SrXPv2O/LfVolC5i5LK2G8xS0Eo1B3X/QnrPlLjLBxifjblKMFe+4fOBAKKiFfxT
	97ayiLCJ4kx+WmyXajCEGks2EX9o4uz+ZteDFLEuQtZFBGyWyRcMkMqaziuNDehF
	8wmeiqVC0ICDypsU8syu91i6Bg4lqH/9osQU2FQ9qo2LCgCMzXDOJ0o1XGtL+uNK
	SIKvPLFDUlJ+TFEXQ2E7jn60hd7mABvUk7NZo1N3BS6CuKnf/z9qAJFQ3IFONPDX
	vYi16IzQYVMJR2svUxXAA==
X-ME-Sender: <xms:dqG6ajdW_eF7NmbujcUKc3MVSv1GpDSfmnYs7pH6PsN4ATIx2KVcoQ>
    <xme:dqG6asp96DVwSLhM_CJD4IcVI8Y6hSi1O0wPIMRWKCGpKjNa5MYOeCx_CkxWmwjG7
    qrEVa1auqiDSmtb6BbG7ZKqV0lBOu60UH7sGnxiGf4G9UiWeSFY2A>
X-ME-Received: <xmr:dqG6aoznC5XDyyL9Hb1NhrLqEXxZURmkf2b2kbz98Hi2JUXOyqXChZKAXY9XofF7>
X-ME-Proxy-Cause: dmFkZTE/22e7clbyNdHwn0HCBx+H3lsiFyo6QkPV6dpSn20/QyCOxtHNd7QTmx6b7eJ6RH
    b7MD0YK3xmhVFW7pHJl/jJiaLCtzwYaWJ6VBcJNMtYB/lM8rXCQqoyXJAKc1Q+3NTJHLRu
    Q+616RIwRjK3mn/tprgeZTxr9VaE0UGr12rr0RgYUziHPYN8WsIu22gnQm98Dq7NFgLEYb
    bOn/3mv6ye0r5zsmXTZhHlWNyOVRZl7FwJjAmuaSy3Z2MGyz8Xby78ZPjGLjvAF+o1XCsp
    YM5+7QijkJtemWRQaETyS2I23TsNHUOR4KF7C0sS19NgtEnCYopA0Qb1idGIqDD/y3bAXm
    tiatHBtnSbNBAIPG8UZ0JzTDV4LXQW9cjYAH4KcqcwlUW2vSLe06fnPaE2O7x/OrgVI/Y0
    nSrQGMiJefsuIXqfPgMaJEccq6V3Mq0cNbzz6ehXnGLo67erj40iyGkApeTywmWxobCwLU
    hosOvkQ1ZJ432qWY/+tn6CV41bqBqD17VDJatk7gTpqbqFfgwq6ScnfyVDFhWW2JTvBE0b
    WudD2JLfhhoIAKPaxR3XhubQPudhgtjMWY1/3c8PRUOP6aOa4zKUrJQwq3pgjEzMdHGiHM
    KvtuEOTphT9iHRUmTiGUiv0clQA0Yx6iw5VlXrgQEFe4QMWuTvvwgva39kRA
X-ME-Proxy: <xmx:dqG6at8Nd-pQKXDli-SP0Kl-OJOcI-eszZZtMDSSvOtR_YUfkHJJPg>
    <xmx:dqG6apznRWY1__Fow6Mx2Jt0zN54WCqYHbcUDnymCQZrBME0zNAkqw>
    <xmx:dqG6agJ7CGuqwIwXN4h-hbaeij9ali4I21awML7z969xwqxq6Hcrag>
    <xmx:dqG6atC9HvyOGWZ9LO3GrYolttBLnnyVZYDTxgPWLgXw6ZQ0HQW8Jg>
    <xmx:d6G6agMh1prXTW9pTuKl6mWokwyoggdOKtYIxtPIluO1HZ2OjoVPlYuc>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:18:29 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:17:49 +0200
Subject: [PATCH v3 01/12] kexec: Add a crash memaction registry
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-1-e511e9ee2329@jaseg.de>
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

Add a registry identifying page use to a kdump kernel. Intended uses are
wiping of crypto keys on crash, or omitting pages holding e.g. crypto
keys or unimportant caches from crash dumps.

The registry is a bitmap with one bit for each physical page. The
meaning of the bits is set by the crash_memaction= cmdline param. When
not present, no bitmap is allocated. Marking is a lock-free bitmap
update with no allocation, so it is safe from any context.

The bitmap and its metadata is handed over to the kdump kernel through
elfcorehdr.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Assisted-by: Claude Opus 5 <noreply@anthropic.com>
---
 Documentation/admin-guide/kernel-parameters.txt |   9 +
 MAINTAINERS                                     |   1 +
 drivers/of/kexec.c                              |   7 +
 include/linux/crash_memaction.h                 |  71 ++++
 include/linux/kexec.h                           |   6 +
 kernel/Kconfig.kexec                            |  21 ++
 kernel/crash_core.c                             | 416 ++++++++++++++++++++++++
 kernel/kexec_core.c                             |   4 +
 kernel/kexec_file.c                             |  10 +
 kernel/ksysfs.c                                 |  15 +
 10 files changed, 560 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2041dd9a8f18..26a78335c156 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1040,6 +1040,15 @@ Kernel parameters
 			Default is enabled if CONFIG_HOTPLUG_PARALLEL=y. Otherwise
 			the parameter has no effect.
 
+	crash_memaction={secret|cache}[,...]
+			[KNL,EARLY] When CONFIG_CRASH_MEMACTION is set, this
+			parameter instructs the kernel to hand an eventual
+			kdump kernel a bitmap of pages annotated with the
+			given types. Annotations are made with madvise(2).
+			Kernel crypto keys are annotated secret. What the
+			kdump kernel does with this is up to it. Default is
+			nothing is tracked and no bitmap is created.
+
 	crash_kexec_post_notifiers
 			Only jump to kdump kernel after running the panic
 			notifiers and dumping kmsg. This option increases
diff --git a/MAINTAINERS b/MAINTAINERS
index dccddc99ac9a..c6350fd34f4c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14259,6 +14259,7 @@ F:	Documentation/admin-guide/kdump/
 F:	fs/proc/vmcore.c
 F:	include/linux/crash_core.h
 F:	include/linux/crash_dump.h
+F:	include/linux/crash_memaction.h
 F:	include/uapi/linux/vmcore.h
 F:	kernel/crash_*.c
 
diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index 029903b986cb..a4d9eca9debe 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -442,6 +442,13 @@ void *of_kexec_alloc_and_setup_fdt(const struct kimage *image,
 				goto out;
 		}
 
+		if (image->memaction_addr != 0) {
+			ret = fdt_add_mem_rsv(fdt, image->memaction_addr,
+					      image->memaction_sz);
+			if (ret)
+				goto out;
+		}
+
 #ifdef CONFIG_CRASH_DUMP
 		/* add linux,usable-memory-range */
 		ret = fdt_appendprop_addrrange(fdt, 0, chosen_node,
diff --git a/include/linux/crash_memaction.h b/include/linux/crash_memaction.h
new file mode 100644
index 000000000000..5f3e114c60ad
--- /dev/null
+++ b/include/linux/crash_memaction.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef LINUX_CRASH_MEMACTION_H
+#define LINUX_CRASH_MEMACTION_H
+
+#include <linux/init.h>
+#include <linux/jump_label.h>
+#include <linux/types.h>
+
+struct kimage;
+
+enum crash_memaction_types {
+	CRASH_MEMACTION_CACHE = 0x1000,
+	CRASH_MEMACTION_SECRET = 0x2000,
+};
+
+#define CRASH_MEMACTION_NOTE_NAME	"MEMACTION"
+
+/*
+ * Bit n of the bitmap at @bitmap_paddr stands for the page frame at
+ * @start_pfn + n.
+ */
+struct crash_memaction_region_note {
+	u64 start_pfn;
+	u64 nr_pages;
+	u64 bitmap_paddr;
+};
+
+/* Wire format between the two kernels */
+struct crash_memaction_note {
+	u32 types; /* CRASH_MEMACTION_* types that set bitmap bits stand for */
+	u32 page_shift;
+	u32 nr_regions;
+	u32 _pad;
+	struct crash_memaction_region_note regions[];
+};
+
+#ifdef CONFIG_CRASH_MEMACTION
+void __init crash_memaction_init(void);
+
+DECLARE_STATIC_KEY_FALSE(crash_memaction_active);
+
+/* Safe from any context. */
+void __crash_memaction_mark_pfns(unsigned long pfn, unsigned long nr_pages);
+void __crash_memaction_unmark_pfns(unsigned long pfn, unsigned long nr_pages);
+
+static inline void crash_memaction_unmark_pfns(unsigned long pfn,
+		unsigned long nr_pages)
+{
+	if (static_branch_unlikely(&crash_memaction_active))
+		__crash_memaction_unmark_pfns(pfn, nr_pages);
+}
+
+void crash_memaction_mark(void *addr, size_t size, int types);
+void crash_memaction_unmark(void *addr, size_t size);
+
+int crash_memaction_types(void);
+ssize_t crash_memaction_types_str(char *buf);
+
+int crash_load_memaction(struct kimage *image);
+void crash_memaction_unload(struct kimage *image);
+#else
+static inline void crash_memaction_init(void) { }
+static inline void crash_memaction_unmark_pfns(unsigned long pfn,
+		unsigned long nr_pages) { }
+static inline void crash_memaction_mark(void *addr, size_t size, int types) { }
+static inline void crash_memaction_unmark(void *addr, size_t size) { }
+static inline int crash_memaction_types(void) { return 0; }
+static inline int crash_load_memaction(struct kimage *image) { return 0; }
+static inline void crash_memaction_unload(struct kimage *image) { }
+#endif /* CONFIG_CRASH_MEMACTION */
+#endif /* LINUX_CRASH_MEMACTION_H */
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index e5f1cfc11fef..f4a2450be879 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -415,6 +415,12 @@ struct kimage {
 	/* dm crypt keys buffer */
 	unsigned long dm_crypt_keys_addr;
 	unsigned long dm_crypt_keys_sz;
+
+	/* crash memaction descriptor buffer */
+	void *memaction_note_va;
+	unsigned long memaction_addr;
+	unsigned long memaction_sz;
+	int memaction_index;
 };
 
 /* kexec interface functions */
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index a97ed9605602..f7326fa6476b 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -179,4 +179,25 @@ config CRASH_MAX_MEMORY_RANGES
 	  the computation behind the value provided through the
 	  /sys/kernel/crash_elfcorehdr_size attribute.
 
+config ARCH_SUPPORTS_CRASH_MEMACTION
+	bool
+
+config CRASH_MEMACTION
+	bool "Register kdump actions for certain memory ranges"
+	depends on CRASH_DUMP
+	depends on KEXEC_FILE
+	depends on ARCH_SUPPORTS_CRASH_MEMACTION
+	help
+	  Track pages that may require special handling by the kdump kernel:
+	  pages holding secrets such as crypto keys, which it can wipe before
+	  anything reads the dump, and pages not worth dumping at all. This
+	  kernel only records which pages are which; what happens to them is
+	  the kdump kernel's decision.
+
+	  Nothing is tracked and no memory is spent unless the kernel is booted
+	  with the crash_memaction= parameter, which also says which types the
+	  bits stand for. The bitmap then costs about 32 KiB per GiB of memory.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index d0bd2d0cf899..6bb2f5645ca6 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -18,11 +18,23 @@
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
 #include <linux/crash_core.h>
+#include <linux/crash_memaction.h>
 #include <linux/reboot.h>
 #include <linux/btf.h>
 #include <linux/objtool.h>
 #include <linux/delay.h>
 #include <linux/panic.h>
+#include <linux/timekeeping.h>
+#include <linux/atomic.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/jump_label.h>
+#include <linux/overflow.h>
+#include <linux/pfn.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/vmcore_info.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -33,6 +45,406 @@
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
 
+#ifdef CONFIG_CRASH_MEMACTION
+
+#define CRASH_MEMACTION_NOTE_NAME_BYTES \
+	ALIGN(sizeof(CRASH_MEMACTION_NOTE_NAME), 4)
+
+/* Bitmap a hole may waste before it gets a region of its own. */
+#define CRASH_MEMACTION_MAX_HOLE_BYTES	SZ_128K
+
+DEFINE_STATIC_KEY_FALSE(crash_memaction_active);
+EXPORT_SYMBOL_GPL(crash_memaction_active);
+
+struct crash_memaction_region {
+	unsigned long start_pfn;
+	unsigned long nr_pages;
+	unsigned long *bits;
+};
+
+static struct crash_memaction_region *crash_memaction_regions __ro_after_init;
+static unsigned int crash_memaction_nr_regions __ro_after_init;
+static size_t crash_memaction_note_bytes __ro_after_init;
+
+static struct crash_memaction_note *crash_memaction_desc __ro_after_init;
+static size_t crash_memaction_desc_bytes __ro_after_init;
+
+static phys_addr_t crash_memaction_note_paddr;
+
+static int crash_memaction_type_mask __ro_after_init;
+
+int crash_memaction_types(void)
+{
+	return crash_memaction_type_mask;
+}
+
+static int __init crash_memaction_param(char *str)
+{
+	char *tok;
+
+	while ((tok = strsep(&str, ",")) != NULL) {
+		if (!strcmp(tok, "secret"))
+			crash_memaction_type_mask |= CRASH_MEMACTION_SECRET;
+		else if (!strcmp(tok, "cache"))
+			crash_memaction_type_mask |= CRASH_MEMACTION_CACHE;
+		else if (*tok)
+			pr_warn("memaction: ignoring unknown type \"%s\"\n",
+				tok);
+	}
+	return 0;
+}
+early_param("crash_memaction", crash_memaction_param);
+
+ssize_t crash_memaction_types_str(char *buf)
+{
+	int mask = crash_memaction_type_mask;
+	int len = 0;
+
+	if (mask & CRASH_MEMACTION_SECRET)
+		len += sysfs_emit_at(buf, len, "secret");
+	if (mask & CRASH_MEMACTION_CACHE)
+		len += sysfs_emit_at(buf, len, "%scache", len ? "," : "");
+
+	return len + sysfs_emit_at(buf, len, "\n");
+}
+
+void __init crash_memaction_init(void)
+{
+	struct crash_memaction_region *regions;
+	struct crash_memaction_note *desc;
+	unsigned long total_bytes = 0;
+	unsigned long start, end, prev_end;
+	unsigned int nr = 0, i;
+	size_t desc_bytes;
+	void *bits;
+	int idx;
+
+	if (!crash_memaction_type_mask)
+		return;
+
+	regions = memblock_alloc(memblock.memory.cnt * sizeof(*regions),
+				 SMP_CACHE_BYTES);
+	if (!regions)
+		goto nomem;
+
+	for_each_mem_pfn_range(idx, NUMA_NO_NODE, &start, &end, NULL) {
+		if (nr && bitmap_size(start - prev_end) <=
+				CRASH_MEMACTION_MAX_HOLE_BYTES) {
+			regions[nr - 1].nr_pages = max(
+					end - regions[nr - 1].start_pfn,
+					regions[nr - 1].nr_pages);
+		} else {
+			regions[nr].start_pfn = start;
+			regions[nr].nr_pages = end - start;
+			nr++;
+		}
+		prev_end = end;
+	}
+
+	for (i = 0; i < nr; i++)
+		total_bytes += bitmap_size(regions[i].nr_pages);
+
+	bits = memblock_alloc(total_bytes, PAGE_SIZE);
+	if (!bits)
+		goto nomem;
+
+	for (i = 0; i < nr; i++) {
+		regions[i].bits = bits;
+		bits += bitmap_size(regions[i].nr_pages);
+	}
+
+	desc_bytes = struct_size_t(struct crash_memaction_note, regions, nr);
+	desc = memblock_alloc(desc_bytes, sizeof(u64));
+	if (!desc)
+		goto nomem;
+
+	desc->types = crash_memaction_type_mask;
+	desc->page_shift = PAGE_SHIFT;
+	desc->nr_regions = nr;
+	for (i = 0; i < nr; i++) {
+		desc->regions[i].start_pfn = regions[i].start_pfn;
+		desc->regions[i].nr_pages = regions[i].nr_pages;
+		desc->regions[i].bitmap_paddr = __pa(regions[i].bits);
+	}
+
+	crash_memaction_regions = regions;
+	crash_memaction_nr_regions = nr;
+	crash_memaction_desc = desc;
+	crash_memaction_desc_bytes = desc_bytes;
+	crash_memaction_note_bytes =
+		PAGE_ALIGN(2 * sizeof(struct elf_note) +
+			   CRASH_MEMACTION_NOTE_NAME_BYTES +
+			   ALIGN(desc_bytes, 4));
+
+	static_branch_enable(&crash_memaction_active);
+
+	pr_info("crash_memaction: types 0x%x, %u memory region(s), %lu KiB of bitmap\n",
+		crash_memaction_type_mask, nr, total_bytes >> 10);
+	return;
+
+nomem:
+	crash_memaction_type_mask = 0;
+	pr_err("crash_memaction: cannot allocate page bitmaps, disabled\n");
+}
+
+/*
+ * The clear reads before it writes: it runs on every frame the page allocator
+ * hands out and almost never has anything to do, so this keeps an allocation
+ * from dirtying a cache line for frames it has nothing to do with.
+ */
+static __always_inline void crash_memaction_word(atomic_long_t *p, unsigned long mask, bool set)
+{
+	unsigned long val = atomic_long_read(p);
+
+	if (set) {
+		if ((val & mask) != mask)
+			atomic_long_or(mask, p);
+	} else if (val & mask) {
+		atomic_long_andnot(mask, p);
+	}
+}
+
+/*
+ * __bitmap_set() and __bitmap_clear() merged, with the store made atomic: the
+ * partial words at either end can be shared with an unrelated folio, and
+ * marking runs from rmap with no lock. Counts are unsigned long rather than
+ * the header's unsigned int, which a bit per page frame outgrows.
+ */
+static void __crash_memaction_bits(unsigned long *map, unsigned long start,
+		unsigned long nr, bool set)
+{
+	atomic_long_t *p = (atomic_long_t *)(map + BIT_WORD(start));
+	const unsigned long size = start + nr;
+	unsigned long bits = BITS_PER_LONG - (start % BITS_PER_LONG);
+	unsigned long mask = BITMAP_FIRST_WORD_MASK(start);
+
+	/* Unsigned, so this is __bitmap_set()'s "nr - bits >= 0". */
+	while (nr >= bits) {
+		crash_memaction_word(p, mask, set);
+		nr -= bits;
+		bits = BITS_PER_LONG;
+		mask = ~0UL;
+		p++;
+	}
+
+	if (nr) {
+		mask &= BITMAP_LAST_WORD_MASK(size);
+		crash_memaction_word(p, mask, set);
+	}
+}
+
+static __always_inline void crash_memaction_bits(unsigned long *map,
+		unsigned long start, unsigned long nr, bool set)
+{
+	if (nr == 1) {
+		if (set) {
+			if (!test_bit(start, map))
+				set_bit(start, map);
+		} else if (test_bit(start, map)) {
+			clear_bit(start, map);
+		}
+		return;
+	}
+
+	__crash_memaction_bits(map, start, nr, set);
+}
+
+static void crash_memaction_update(unsigned long start_pfn,
+		unsigned long nr_pages, bool set)
+{
+	unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned int i;
+
+	for (i = 0; i < crash_memaction_nr_regions; i++) {
+		struct crash_memaction_region *reg = &crash_memaction_regions[i];
+		unsigned long from = max(start_pfn, reg->start_pfn);
+		unsigned long to = min(end_pfn, reg->start_pfn + reg->nr_pages);
+
+		if (reg->start_pfn >= end_pfn)
+			break;
+		if (from < to)
+			crash_memaction_bits(reg->bits, from - reg->start_pfn,
+					     to - from, set);
+	}
+}
+
+void __crash_memaction_mark_pfns(unsigned long pfn, unsigned long nr_pages)
+{
+	crash_memaction_update(pfn, nr_pages, true);
+}
+EXPORT_SYMBOL_GPL(__crash_memaction_mark_pfns);
+
+void __crash_memaction_unmark_pfns(unsigned long pfn, unsigned long nr_pages)
+{
+	crash_memaction_update(pfn, nr_pages, false);
+}
+EXPORT_SYMBOL_GPL(__crash_memaction_unmark_pfns);
+
+static void crash_memaction_va(void *addr, size_t size, bool set)
+{
+	unsigned long start = ALIGN_DOWN((unsigned long)addr, PAGE_SIZE);
+	unsigned long end = ALIGN((unsigned long)addr + size, PAGE_SIZE);
+	unsigned long va;
+
+	if (!addr || !size)
+		return;
+
+	if (virt_addr_valid(addr)) {
+		if (!virt_addr_valid((void *)(end - 1))) {
+			pr_warn("memaction: invalid range 0x%p+%zx\n",
+				addr, size);
+			return;
+		}
+
+		/* The linear map is physically contiguous. */
+		crash_memaction_update(PHYS_PFN(virt_to_phys((void *)start)),
+				       (end - start) >> PAGE_SHIFT, set);
+		return;
+	}
+
+	if (!is_vmalloc_addr(addr)) {
+		pr_warn("memaction: invalid range 0x%p+%zx: neither linear nor vmalloc\n",
+			addr, size);
+		return;
+	}
+
+	for (va = start; va < end; va += PAGE_SIZE) {
+		struct page *page = vmalloc_to_page((void *)va);
+
+		if (!page) {
+			pr_warn("memaction: unmapped page 0x%lx inside range 0x%p+%zx\n",
+				va, addr, size);
+			return;
+		}
+
+		crash_memaction_update(page_to_pfn(page), 1, set);
+	}
+}
+
+void crash_memaction_mark(void *addr, size_t size, int types)
+{
+	if (!static_branch_unlikely(&crash_memaction_active))
+		return;
+	if (!(types & crash_memaction_type_mask))
+		return;
+
+	crash_memaction_va(addr, size, true);
+}
+EXPORT_SYMBOL_GPL(crash_memaction_mark);
+
+void crash_memaction_unmark(void *addr, size_t size)
+{
+	if (!static_branch_unlikely(&crash_memaction_active))
+		return;
+
+	crash_memaction_va(addr, size, false);
+}
+EXPORT_SYMBOL_GPL(crash_memaction_unmark);
+
+int crash_load_memaction(struct kimage *image)
+{
+	unsigned long nr_pages, i;
+	struct page **pages;
+	int ret;
+	struct kexec_buf kbuf = {
+		.image = image,
+		.buffer = NULL,
+		.bufsz = 0,
+		.mem = KEXEC_BUF_MEM_UNKNOWN,
+		.memsz = crash_memaction_note_bytes,
+		.buf_align = PAGE_SIZE,
+		.buf_min = 0,
+		.buf_max = ULONG_MAX,
+		.top_down = true,
+		.random = true,
+	};
+
+	if (!crash_memaction_nr_regions)
+		return 0;
+
+	ret = kexec_add_buffer(&kbuf);
+	if (ret)
+		return ret;
+
+	nr_pages = crash_memaction_note_bytes / PAGE_SIZE;
+	pages = kmalloc_array(nr_pages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_pages; i++)
+		pages[i] = pfn_to_page((kbuf.mem >> PAGE_SHIFT) + i);
+
+	image->memaction_note_va = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	kfree(pages);
+	if (!image->memaction_note_va)
+		return -ENOMEM;
+
+	image->memaction_addr = kbuf.mem;
+	image->memaction_sz = kbuf.memsz;
+	image->memaction_index = image->nr_segments - 1;
+	crash_memaction_note_paddr = kbuf.mem;
+
+	return 0;
+}
+
+void crash_memaction_unload(struct kimage *image)
+{
+	if (!image->memaction_note_va)
+		return;
+
+	vunmap(image->memaction_note_va);
+	image->memaction_note_va = NULL;
+	image->memaction_addr = 0;
+	image->memaction_sz = 0;
+	image->memaction_index = -1;
+	crash_memaction_note_paddr = 0;
+}
+
+static void crash_memaction_save(struct kimage *image)
+{
+	if (!image || !image->memaction_note_va)
+		return;
+
+	final_note(append_elf_note(image->memaction_note_va,
+				   CRASH_MEMACTION_NOTE_NAME, 0,
+				   crash_memaction_desc,
+				   crash_memaction_desc_bytes));
+}
+
+static unsigned long crash_memaction_nr_phdr(void)
+{
+	return crash_memaction_note_paddr ? 1 : 0;
+}
+
+static Elf64_Phdr *crash_memaction_emit_phdr(Elf64_Ehdr *ehdr,
+		Elf64_Phdr *phdr)
+{
+	if (!crash_memaction_note_paddr)
+		return phdr;
+
+	phdr->p_type = PT_NOTE;
+	phdr->p_offset = phdr->p_paddr = crash_memaction_note_paddr;
+	phdr->p_filesz = phdr->p_memsz = crash_memaction_note_bytes;
+	(ehdr->e_phnum)++;
+
+	return phdr + 1;
+}
+
+#else
+static inline void crash_memaction_save(struct kimage *image) { }
+
+static inline unsigned long crash_memaction_nr_phdr(void)
+{
+	return 0;
+}
+
+static inline Elf64_Phdr *crash_memaction_emit_phdr(Elf64_Ehdr *ehdr,
+		Elf64_Phdr *phdr)
+{
+	return phdr;
+}
+#endif /* CONFIG_CRASH_MEMACTION */
+
 /* time to wait for possible DMA to finish before starting the kdump kernel
  * when a CMA reservation is used
  */
@@ -142,6 +554,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
 			crash_cma_clear_pending_dma();
+			crash_memaction_save(kexec_crash_image);
 			machine_kexec(kexec_crash_image);
 		}
 		kexec_unlock();
@@ -182,6 +595,7 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 	/* extra phdr for vmcoreinfo ELF note */
 	nr_phdr = nr_cpus + 1;
 	nr_phdr += mem->nr_ranges;
+	nr_phdr += crash_memaction_nr_phdr();
 
 	/*
 	 * kexec-tools creates an extra PT_LOAD phdr for kernel text mapping
@@ -231,6 +645,8 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 	(ehdr->e_phnum)++;
 	phdr++;
 
+	phdr = crash_memaction_emit_phdr(ehdr, phdr);
+
 	/* Prepare PT_LOAD type program header for kernel text region */
 	if (need_kernel_map) {
 		phdr->p_type = PT_LOAD;
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 7ee8c9f078f6..ac7406d68bdf 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -8,6 +8,7 @@
 
 #include <linux/btf.h>
 #include <linux/capability.h>
+#include <linux/crash_memaction.h>
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/slab.h>
@@ -264,6 +265,8 @@ struct kimage *do_kimage_alloc_init(void)
 	image->elfcorehdr_updated = false;
 #endif
 
+	image->memaction_index = -1;
+
 	return image;
 }
 
@@ -595,6 +598,7 @@ void kimage_free(struct kimage *image)
 		crash_update_vmcoreinfo_safecopy(NULL);
 		vunmap(image->vmcoreinfo_data_copy);
 	}
+	crash_memaction_unload(image);
 #endif
 
 	kimage_free_extra_pages(image);
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index a8455481f639..e87194524fd7 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -10,6 +10,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/capability.h>
+#include <linux/crash_memaction.h>
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/slab.h>
@@ -325,6 +326,10 @@ kimage_file_alloc_init(struct kimage **rimage, int kernel_fd,
 		/* Enable special crash kernel control page alloc policy. */
 		image->control_page = crashk_res.start;
 		image->type = KEXEC_TYPE_CRASH;
+
+		ret = crash_load_memaction(image);
+		if (ret)
+			goto out_free_image;
 	}
 #endif
 
@@ -360,6 +365,7 @@ kimage_file_alloc_init(struct kimage **rimage, int kernel_fd,
 out_free_post_load_bufs:
 	kimage_file_post_load_cleanup(image);
 out_free_image:
+	crash_memaction_unload(image);
 	kfree(image);
 	return ret;
 }
@@ -877,6 +883,10 @@ static int kexec_calculate_store_digests(struct kimage *image)
 			continue;
 #endif
 
+		/* Exclude the memaction buffer, written during the crash */
+		if (i == image->memaction_index)
+			continue;
+
 		ksegment = &image->segment[i];
 		/*
 		 * Skip purgatory as it will be modified once we put digest
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index f45ade718054..846bd850a4fb 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -14,6 +14,7 @@
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/vmcore_info.h>
+#include <linux/crash_memaction.h>
 #include <linux/profile.h>
 #include <linux/stat.h>
 #include <linux/sched.h>
@@ -133,6 +134,17 @@ KERNEL_ATTR_RO(vmcoreinfo);
 
 #endif /* CONFIG_VMCORE_INFO */
 
+#ifdef CONFIG_CRASH_MEMACTION
+
+static ssize_t crash_memaction_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	return crash_memaction_types_str(buf);
+}
+KERNEL_ATTR_RO(crash_memaction);
+
+#endif /* CONFIG_CRASH_MEMACTION */
+
 /* whether file capabilities are enabled */
 static ssize_t fscaps_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
@@ -203,6 +215,9 @@ static struct attribute * kernel_attrs[] = {
 #ifdef CONFIG_VMCORE_INFO
 	&vmcoreinfo_attr.attr,
 #endif
+#ifdef CONFIG_CRASH_MEMACTION
+	&crash_memaction_attr.attr,
+#endif
 #ifndef CONFIG_TINY_RCU
 	&rcu_expedited_attr.attr,
 	&rcu_normal_attr.attr,

-- 
2.55.0

