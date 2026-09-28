Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A714EC673;
	Mon, 28 Sep 2026 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617001; cv=none; b=J2nIX2rCMzHAS02Nb1AyUzq7yH9HNicwBVQ3+tF87WRkeNi8Dd/3PY38SBLsEUhdljQi89UFk8ZcUuDkBDrMibIY+coAb1aZWD8eoQQFITCgfH2ZPExSQ9Gw0IQ3EVX0XQVhy0N1BqJc5G9FHnWyrIAw870uhau0GG+SLbH0mlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617001; c=relaxed/simple;
	bh=i6o4iwa+hxpDJwxlO5GTa38fuInhR3UBYSCwzs+8duE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JiGBRHTts4y8b/LbHCAAu6Igu4wXqh5g8gOgHPMfjivE+3+bDDmfz8uUvtsTxfVitneeJ0+Iz45kJWRkDWy3qkfbZkpT+r+02NacoUiubUj0OGhd6qCGUs4QuCubLFr6/XjrtXHptEw+IPWjt4RjZ03crwOH0BIjSIzMAMysUuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CdVMt+Fz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CdVMt+Fz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B211F000FF;
	Mon, 28 Sep 2026 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617000;
	bh=xXafi02ZLO1Y0xc1WsCP1jTVPyy0rIJ0X6evEJWG+Cs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CdVMt+Fzf8G8t9rbknnGaVrM5SS+D6vf8+Yoh8W6ZNN6HA8AwFKbWq4iAqfZXz+Ft
	 d6MVIyxwinfxhUDgeSbx7Dog/6xDVinP9/nnAQpm3L3BeHj6F2w9uLhGMX0RIwqRFp
	 ow0hYfT1lH9zRieXdzWZTFJ3OuwSjepCBV16JWZsA0vXLvh1ZOhMNs5F+OsbJov4tp
	 Rvcjcg0CXhk62W2ijvnpQb0dh5CrMyp0hQ+z20rlXdt1LlRtr6DDTzOnq5FPBrwN13
	 /j0jojUVX3IMJsrMgcEwhZ5ROe55Wv7PFan2FBHF9O9li/r2rx/qWmXuyEF8Ks1t22
	 NGObYvk9JQFvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/12] lib, kexec: Add a secret pool for key material
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rob Herring" <robh@kernel.org>, "Barry Song" <baohua@kernel.org>, "Matthew
 Brost" <matthew.brost@intel.com>, "Zi Yan" <ziy@nvidia.com>, "David Howells" <dhowells@redhat.com>, "Dev
 Jain" <dev.jain@arm.com>, "David Hildenbrand" <david@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Andrew Morton" <akpm@linux-foundation.org>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Mark
 Rutland" <mark.rutland@arm.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "James Morris" <jmorris@namei.org>, "Rik
 van Riel" <riel@surriel.com>, "Usama Arif" <usama.arif@linux.dev>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Randy Dunlap" <rdunlap@infradead.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Byungchul Park" <byungchul@sk.com>, "Paul
 Moore" <paul@paul-moore.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "David
 S. Miller" <davem@davemloft.net>, "Peter Xu" <peterx@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Harry
 Yoo" <harry@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Pedro Falcato" <pfalcato@suse.de>, "Gregory
 Price" <gourry@gourry.net>, "Mimi Zohar" <zohar@linux.ibm.com>, "Saravana
 Kannan" <saravanak@kernel.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Jann Horn" <jannh@google.com>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Alistair Popple" <apopple@nvidia.com>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Alasdair Kergon" <agk@redhat.com>, "Will
 Deacon" <will@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Dave Young" <ruirui.yang@linux.dev>, "Ying
 Huang" <ying.huang@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kexec@lists.infradead.org, keyrings@vger.kernel.org, robh@kernel.org, linux-doc@vger.kernel.org, conor+dt@kernel.org, dm-devel@lists.linux.dev, linux-mm@kvack.org, linux-integrity@vger.kernel.org, devicetree@vger.kernel.org, driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-2-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-2-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:36:35 +0000
Message-Id: <20260928173636.78B211F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] lib/secret_pool: fallback to shared kmalloc inadvertently marks en=
tire pages as secret
--

commit 774a436bfd0576d919ce17b831096d5b8c8dbbb5
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

lib, kexec: Add a secret pool for key material
   =20
Key material allocated with kmalloc() shares its slab pages with
unrelated allocations. crash_memaction marks memory at page granularity,
so smaller objects in shared slab pages can't cleanly be marked or
unmarked. This commit adds a secret pool built on kmem_buckets to
hold such keys in marked pages.

> diff --git a/lib/secret_pool.c b/lib/secret_pool.c
> new file mode 100644
> index 0000000000000..62954847091a0
> --- /dev/null
> +++ b/lib/secret_pool.c
> @@ -0,0 +1,27 @@
[ ... ]
> +void *secret_pool_alloc_node(size_t size, gfp_t flags, int node)
> +{
> +	void *p =3D kmem_buckets_alloc_node_track_caller(secret_pool, size,
> +						       flags, node);
> +
> +	crash_memaction_mark(p, size, CRASH_MEMACTION_SECRET);
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this unconditionally mark the allocation even if it falls back to a sh=
ared
kmalloc page?

The commit message notes that if the secret pool is used before its initcall
runs or if pool creation fails, allocations will fall back to ordinary kmal=
loc
caches.

Because crash_memaction_mark() operates at page granularity, wouldn't calli=
ng
it on a shared kmalloc page inadvertently mark the entire page (and unrelat=
ed
kernel objects sharing it) as a secret?

In the event of a crash, could this cause the kdump kernel to wipe or exclu=
de
these shared pages, potentially destroying crash data?

> +
> +	return p;
> +}
> +EXPORT_SYMBOL_GPL(secret_pool_alloc_node);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D2
