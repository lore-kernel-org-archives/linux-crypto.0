Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F7F3FC5B7;
	Mon, 28 Sep 2026 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790615915; cv=none; b=Y0B6v8P2TXm6GvRrhELiebtg6R2rHPv/JDfR2C7k8LJNJRtg/9KZr8varK7ruuB/6zgbhlUHIE4pC+nsa6oWNLkdW/YuqwI6fw3NiLqobDckZuU5ov/+BiDrlPTOEsMrwiL3ZAjNDd3Y9itIAMVnerfM8wfkD1IaP8sKlbvmlrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790615915; c=relaxed/simple;
	bh=NQ7FCOvj1P0hio7GdY33PzDULFySRHmwCazTCiLXg0M=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=hpSer6I1pRvfNHJrUMdZEWPVNpBtp2Ob4Jx7cValI2+mdRSiKaJPPjGIJU5/2n4wltsyO9QI/SxX0/QaSWXe1jShng2lurKxA0Qg1tsxVg9ubFLrOQO/R99xwNAcUfSEfZFVFNmePr/cEZK/FEc0tBBGyf8LeS2bAhYp3XWgTRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de; spf=pass smtp.mailfrom=jaseg.de; dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b=PDW96tMY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rP7VwLU+; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaseg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b="PDW96tMY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rP7VwLU+"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.phl.internal (Postfix) with ESMTP id 5F29B13804CF;
	Mon, 28 Sep 2026 13:18:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 28 Sep 2026 13:18:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm1; t=1790615909; x=1790623109; bh=bV
	g0AFXfRcn0kYVBIO4bfsJw3vxA/g/QL37izKwnfQA=; b=PDW96tMYg4rbGYdKku
	0EJCPNI36r4B2hUwhfR3GlFGPvu014j8MQbAmAu/jDt3apTosy9kl2lONm7ZW0tM
	WC4dSMUV+DZI/8WakXXy5rvWgEkGpzOScmSGb3IPOjsBrUN8LkjH/Ha/MT9arhrj
	lV5WTyTu5QzeR2yKg40VcC6BtfLWYxr0LyUY5BGoYDxszYqxkqeq1WOd58jjird1
	0fglY81og4AL3IOrAAj7x5sfsCKjH667Jl5IVYoZIlLo1qFx44vMQ/d8KNsxXLVQ
	te3Wx/YozKKpZTJTzDde316FvaArpyqNf3tYolcTAtev5GeHOKL7zDSQW4uXXnx+
	4Stw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790615909; x=1790623109; bh=bVg0AFXfRcn0kYVBIO4bfsJw3vxA
	/g/QL37izKwnfQA=; b=rP7VwLU+g5w5kgoZE/Ygfqp4O9SaMC2M+jdmk9pJscEl
	bgmxy1pqsyLyypPy/teiX1wg0jXQ0nPfuIwXjq7cUEIAaTJcjGO6UtUMfk3GOpgU
	GaOjwK1OyDrIS9OX4Y1TV59vKf7VSnORwDlqJraYMK2QlLsBNY9hYFndgoTVNxfh
	vyCKI6ejywyPLgEjUW6+Pb04S7gVk5iKib7E09GD3L7/daSIm3D4AM307v44m2bR
	SeamX+Tm+3Nvlp/aNOv1nfTHTGSkvpcrQBOJr8lxReqrA/SSML+H471MoZh6RYuM
	JMo72E3ICD3MLbyjniYyWV9zP3MEDkginbxbVtTKqA==
X-ME-Sender: <xms:YaG6akR6zEUWWm5zOtptcC5g5i5w2qNblqYpBtRBWKX05DcEkDNT_w>
    <xme:YaG6alOFelEG63JQmHEZMaF-e4O7ggLjwK0VvoRAwxO-8RIN98lg_2lp5CIaMUa7R
    W6iT7JUfZfhiE29ZEi5ZgAq-xs1FljwChczQM_LN_PCP9886HB2Pas>
X-ME-Received: <xmr:YaG6auEySkVu0oVYOEBOMDlnLc03H5U-j1rY_MXACx-1l3Zx97auzd4rkzBPJVDq>
X-ME-Proxy-Cause: dmFkZTF0iCUIjHjLkwYyqUzkXaYeY8zBVzbYdKa9uLqQTqMZv99nAR+IiEJPZL8+SJzKiZ
    B7K3UjPIiWFyTiV33TJp2Iu3+otBrZpR7GdRG7oEWKpQxhAYRys/bIgWVjAFO+ttb48/Iu
    vqtTDVO6beSYfb8DehSXxRdciBkpTkKn6DftQ8bRlXa4NWwGLAN1zR3yNWg1JGuJyO2wz/
    IIAW+S+/FbyS/i0Qc8pWib5DM/WcYqRedoxaD58VxZCKYewFPrkCfWlpRLwPx+CCMijei6
    NYqaXMB3pIqrRZsvEgwz9iXvEg7oTndNrsTGOSQoCalXtITSIECGB5COlgHV3BetS9pdNk
    Mi2BWMxCxErt8z5rhQ8RzJjuSNmMDsZ13mfP2K5O4G/XtKP4GwUlbMqf2G/eDIzZTe7Ddf
    W8g6pT8RqKP0+eIeSfmPFa6lY+sN4EB3i8gbBuTkoF0K64vyoMVtJhiICB7+CPi6u5Rqjk
    Hx+lJhTi44brC6/RpmQR8K1/0vQ+VbXWiIsYI0Tajw97tGq1WtKJHin2gLVyZQXOghUoHC
    iF9Q8Rkrf9hrCgBCVxZdi4r8n08voOTzj01FOEXwmMjJYyw/N0x0PZuaB8Z+VCCg0Vd3EA
    qwVKuKkmhlJ7CaWDTzA2u9vCQbBGkZI7hdOPcs/SXlyoX3Q7/RgMG4GELV2Q
X-ME-Proxy: <xmx:YaG6ahB_BxV8xWTFhKnQ-hpdBQ-bjdKKSLoNBOcCL1FzH_JkIOQyfQ>
    <xmx:YaG6ankfpCLXapt1GM8R3UNIjgB_PVs2fW6PYF7Pk1XTmowCMoZQjA>
    <xmx:YaG6ahvSEmutTft2TiccZxTYsTwsCXnVsrxvWvOoTJB2T9GVDW8Snw>
    <xmx:YaG6anVJ0kMtsUB9aikmSQQRzu1NRpBUPJB1FlMUDlFX-eAuWy3grQ>
    <xmx:ZaG6ahiI1MV-bxXkvIHv1w2c4MwhADANsDKMFiU-VHH_QQ7gj6gVuWzt>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:18:08 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Subject: [PATCH v3 00/12] CRASH_MEMACTION: describe pages to a kdump kernel
 (was: CRASH_WIPE_SECRETS)
Date: Mon, 28 Sep 2026 19:17:48 +0200
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y2Oyw6CMBBFf4V07RjaCgFX/odhUcsAxUDJtKBC+
 HfLY3mSk3vuwhySQcfu0cIIJ+OM7QPIS8R0o/oawZSBmYhFGuciAU3KNdBhp7QPLoyD84Sqg9P
 gkKLUldKJklnOws5AWJnv3ngWB7vx1aL22/BmNMZ5S7/9xCQ37+hlnJ+9GcmaGYHwY+kNk4AY8
 iTlJZdayFv8aJXD+loiK9Z1/QMbbXc71gAAAA==
X-Change-ID: 20260925-crash-memaction-upstream-20260921-6e3cfac5a389
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

I'm using linux on an embedded target in a Hardware Security Module-like
application. One requirement is that I want the system to be able to
quickly erase its memory when it detects physical tampering. I'm
approaching that by using kdump to load into a small payload that
instead of dumping RAM, erases RAM frmo start to end. However, writing
all of RAM, especially on an embedded target, is rather slow. For this
reason, I propose a new crash_memaction mechanism that lets the old
kernel indicate marked memory areas to the kdump kernel at page
granularity.

I will be using this mechanism to indicate "secret" memory ranges for
early wiping by my kdump payload. After discussion with Baoquan He early
August, the patchset includes a second flag that can be used to indicate
"cache" memory that the kdump kernel may want to skip when creating the
dumpfile.

The record is a bitmap with one bit per page, allocated at boot. It
reaches the kdump kernel as a PT_NOTE named MEMACTION. Marking is a
lock-free atomic bitmap update with no allocation, so it is safe in any
context.

The feature is gated by a static key that is patched in only when the
kernel is booted with a crash_memaction= parameter indicating which
flags to pass to the kdump kernel. The parameter sets the meaning of the
bitmap bits to both kernels.

Marking Memory
==============

Theres both a kernel and a userspace interface to mark memory.

In-kernel, crash_memaction_mark() takes a virtual address range and a
type. Marking has page granularity. To support smaller objects,
patch 2 adds a "secret pool" kmem_buckets instance whose backing pages
are marked SECRET. Patches 5 to 7 move dm-crypt volume keys and IV
seeds, crypto tfm contexts, and the payloads of the user, trusted, and
encrypted key types into this pool. Keeping keys in dedicated slab
caches also provides some defence in depth against use-after-free and
out-of-bounds reads, independently of what I'm doing here with kdump.

For userspace mappings, madvise() with MADV_CRASH_SECRET or
MADV_CRASH_CACHE sets a new VMA flag, VM_CRASH_MARK. Folios mapped into
a marked VMA are registered as they arrive in rmap.

A mark lasts until the page frame is allocated again, so it is cleared
in post_alloc_hook() rather than when freed to account for leftover
data. Hugetlb folios reused from the pool bypass post_alloc_hook(), so
their marks are cleared on dequeue instead.

Overhead
========

Measured on arm64 (QRB2210, 4x Cortex-A53, 3.6G) at next-20260922, three
boots of the same tree:

    k0  CONFIG_CRASH_MEMACTION=n
    k1  CONFIG_CRASH_MEMACTION=y, no crash_memaction=
    k2  CONFIG_CRASH_MEMACTION=y, crash_memaction=secret

k1 and k2 are the same kernel image. The workload rebuilds mm/ of a
kernel tree a few times with make -j4.

    k0  157.05 s median (n=8, range 156.51-157.77)
    k1  158.23 s median (n=8, range 157.96-159.69)
    k2  157.42 s median (n=8, range 156.97-163.24)

Against k0 that is +0.75% for k1 and +0.24% for k2, both within
measurement noise.

Out of scope here
=================

This series only records the page types in the note. The secret type is
wired up with some kernel users related to disk encryption. The cache
type is not wired up with any kernel users (but can be used from
userspace).

The bitmap is sized from the memblock memory map at boot and is never
resized. Memory added by hotplug is therefore not covered by a bitmap
and cannot be marked. I'm focused on embedded targets that don't support
hotplug anyway.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
Changes in v3:
- Use page bitmap instead of range-based registry
- Move smaller allocations into secret_pool buckets
- Link to v3: https://patch.msgid.link/20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de

To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
To: Rob Herring <robh@kernel.org>
To: Saravana Kannan <saravanak@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <baoquan.he@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Dave Young <ruirui.yang@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
To: David Hildenbrand <david@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Brendan Jackman <brendan.jackman@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
To: Alasdair Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
To: Mimi Zohar <zohar@linux.ibm.com>
To: David Howells <dhowells@redhat.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
To: Paul Moore <paul@paul-moore.com>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Liam R. Howlett" <liam@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
To: Pedro Falcato <pfalcato@suse.de>
To: Rik van Riel <riel@surriel.com>
To: Harry Yoo <harry@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Nico Pache <nico.pache@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>
To: Barry Song <baohua@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
To: Kiryl Shutsemau <kas@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Byungchul Park <byungchul@sk.com>
To: Gregory Price <gourry@gourry.net>
To: Ying Huang <ying.huang@linux.alibaba.com>
To: Alistair Popple <apopple@nvidia.com>
To: Peter Xu <peterx@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: kexec@lists.infradead.org
Cc: driver-core@lists.linux.dev
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: dm-devel@lists.linux.dev
Cc: linux-crypto@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: keyrings@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-arch@vger.kernel.org

---
Jan Sebastian Götte (12):
      kexec: Add a crash memaction registry
      lib, kexec: Add a secret pool for key material
      mm: Wire up the crash memaction registry
      arm64: Enable the crash memaction registry
      dm crypt: Allocate key material from the secret pool
      crypto: api - Allocate tfms from the secret pool
      security/keys: Allocate key payloads from the secret pool
      mm: Add VM_CRASH_MARK
      mm/rmap: Mark folios mapped into crash_memaction-marked VMAs
      mm/madvise: Add MADV_CRASH_SECRET, MADV_CRASH_CACHE and MADV_CRASH_RESET
      Documentation/mm: Document the crash memaction registry
      kexec: Expose the crash memaction bitmap in debugfs

 Documentation/admin-guide/kernel-parameters.txt |   9 +
 Documentation/mm/crash_memaction.rst            |  68 ++++
 Documentation/mm/index.rst                      |   1 +
 MAINTAINERS                                     |   4 +
 arch/arm64/Kconfig                              |   3 +
 crypto/api.c                                    |   9 +-
 drivers/md/dm-crypt.c                           |  19 +-
 drivers/of/kexec.c                              |   7 +
 fs/proc/task_mmu.c                              |   3 +
 include/linux/crash_memaction.h                 |  86 +++++
 include/linux/kexec.h                           |   6 +
 include/linux/mm.h                              |   9 +
 include/linux/rmap.h                            |   5 +-
 include/linux/secret_pool.h                     |  47 +++
 include/uapi/asm-generic/mman-common.h          |   4 +
 kernel/Kconfig.kexec                            |  39 ++
 kernel/crash_core.c                             | 475 ++++++++++++++++++++++++
 kernel/kexec_core.c                             |   4 +
 kernel/kexec_file.c                             |  10 +
 kernel/ksysfs.c                                 |  15 +
 lib/Makefile                                    |   1 +
 lib/secret_pool.c                               |  27 ++
 mm/huge_memory.c                                |   2 +
 mm/hugetlb.c                                    |  10 +-
 mm/madvise.c                                    | 132 +++++++
 mm/migrate.c                                    |   2 +-
 mm/mm_init.c                                    |   3 +
 mm/page_alloc.c                                 |   6 +
 mm/rmap.c                                       |   8 +
 mm/userfaultfd.c                                |   1 +
 security/keys/encrypted-keys/encrypted.c        |   5 +-
 security/keys/trusted-keys/trusted_core.c       |   3 +-
 security/keys/user_defined.c                    |   3 +-
 33 files changed, 1006 insertions(+), 20 deletions(-)
---
base-commit: a8c591ed6b672915e0be57843f943a2a723aff40
change-id: 20260925-crash-memaction-upstream-20260921-6e3cfac5a389

Best regards,
--  
Jan Sebastian Götte <linux@jaseg.de>

