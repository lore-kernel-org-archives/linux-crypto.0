Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6094D1780;
	Mon, 28 Sep 2026 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616739; cv=none; b=q15GjlqSHwUYcyUF0t3tjC6icg2AJgBnou2gXRqEDA4V97dDf3gaV8wYQJcBqbYKORIQRQyKSiUl/2H/EOOxH3lHPDC6v1PxLDMfKdgLV8uOQZ4ayHhFRHBtUgSn3gIYvZBwM1i0IXx4gN0qhgBJMZwvknpOpYzbu/5k+Rbwq8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616739; c=relaxed/simple;
	bh=8v0HMtdYSmeR7hSMV83Y5zxCj1beVOpYUQy4t0SZILE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BGRVeYsacdp1Xr/Rf3T2ffQfq2u9Zc3EJUyD+HzLpIPluxtPcOYV9iP74m6AGKdWWosmlLG7cUrOVtqODqALy+7dGQyjbsLJtK8APjAQr1L8GUcY/fJLun4+BmF2jGDu3tvKG33fVPUxnHK2awxujRfIrdp6wmnTVgihGwhdbEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiOBtobw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiOBtobw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604931F000FF;
	Mon, 28 Sep 2026 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616738;
	bh=8v0HMtdYSmeR7hSMV83Y5zxCj1beVOpYUQy4t0SZILE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CiOBtobwfu4y22KpWjQYigG/SpghA3ZMlFopVsdnLt72agD6Na8u4zEaQV1gDfh/R
	 vPhP2hluuNYNnSKQ/oHFemJe2nmSOsG5hEzgjoBbn4FmBi94jSRYmehzmjhl+smP9k
	 Ynk0BgeUjd5wjzXn25xE16bMc897uxA3eya68pnLc2QlFHAtS0MZ1lnaq2WB7u2ZK8
	 fuY4ufUCglEtqbXnKVuv0r1LdgP8eQ7+CKClYlZnICwdD8HHYQyB2LaDjPAn/PX5Tj
	 Bu952lnXnp0ztfZLVtYiYzSRtQ62djuzg99bhr2cV6f05Ooqt3Rn776dbFVVVvDNdJ
	 JhQSWw0Ks2zVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/12] security/keys: Allocate key payloads from the
 secret pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hildenbrand" <david@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Michal Hocko" <mhocko@suse.com>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Kiryl
 Shutsemau" <kas@kernel.org>, "David Howells" <dhowells@redhat.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Danilo Krummrich" <dakr@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Baoquan He" <baoquan.he@linux.dev>, "Nico
 Pache" <nico.pache@linux.dev>, "Matthew Brost" <matthew.brost@intel.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Rob Herring" <robh@kernel.org>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "David
 S. Miller" <davem@davemloft.net>, "Alasdair Kergon" <agk@redhat.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Barry Song" <baohua@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Zi
 Yan" <ziy@nvidia.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Peter
 Xu" <peterx@redhat.com>, "Dev Jain" <dev.jain@arm.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Will Deacon" <will@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Jonathan Corbet" <corbet@lwn.net>, "Saravana
 Kannan" <saravanak@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Jann Horn" <jannh@google.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Usama Arif" <usama.arif@linux.dev>, "Serge E.
 Hallyn" <serge@hallyn.com>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "James
 Morris" <jmorris@namei.org>, "Rik van Riel" <riel@surriel.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Dave
 Young" <ruirui.yang@linux.dev>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Alistair Popple" <apopple@nvidia.com>
Cc: conor+dt@kernel.org, linux-fsdevel@vger.kernel.org, robh@kernel.org, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, dm-devel@lists.linux.dev, kexec@lists.infradead.org, linux-arch@vger.kernel.org, driver-core@lists.linux.dev, "Eric
 Biggers" <ebiggers@kernel.org>, devicetree@vger.kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-7-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-7-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:32:15 +0000
Message-Id: <20260928173215.604931F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

> Key payloads sit in memory in plain text for as long as the key exists,
> and a kdump crash dump captures them along with everything else.
>=20
> Allocate the payloads of the user-defined, trusted and encrypted key
> types from the new secret pool, so that their backing pages are marked
> by crash_memaction for the kdump kernel to wipe.
>=20
> This commit covers the key types used by dm-crypt/cryptsetup. Additional
> key types can be added if needed in future commits.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D7

