Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF2F45D5FC;
	Mon, 28 Sep 2026 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616775; cv=none; b=eTHLceaE24ZsJIhLZy9lqazww7pgpzs44Y3KQatzMvlxsgCejYvUotrz3JNn6qwDScLQBorGSacK/LmQwjw13Fl5Q9/JgpFd8F2OCZIH+jfHLYjD7UOMQgWzPUVivWvUgXH6ihVe0RXuFX+Qo+MHGAKIpzxI2mMHn0ZPa/HOcbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616775; c=relaxed/simple;
	bh=UO0wORJC7A11uXsY7WzcFB5vHpZoMgQKuLqNvmRodkw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gcB15lHz2wXjth2ZYhU7B4SAs+8AMHEb5a8BssFgU7JjJUfaz00ZOcMMMz2WRSl6cK17g/eYagE5GxZwhoLAeLsnO2ACKiU36zkfbTQIYwlzitH8FGtAgnmolsZPoSlkrpYR5j2kc/LKIrfDW7B4E4QIQiVu03GErCPErC4Z4gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bs8gZl21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bs8gZl21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AAB1F000FF;
	Mon, 28 Sep 2026 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616773;
	bh=UO0wORJC7A11uXsY7WzcFB5vHpZoMgQKuLqNvmRodkw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bs8gZl21EgXlr1ogxYmUKhEdGQWh/DAKFrR6vbipZPiBabZ1/ok6G279uSZM4DP/4
	 ejCloOlcoyCGBYgFxGf/57WgSkGZLso7QrCbJr8OgGzpc14kNkCT/I5uSVcJCUCBhv
	 Uqc9UpdAtMOGV1gznAP5SEf3kyCXDUuUKPM6oAvpbmATlCiWByYLe0Dmq25P8tRoqj
	 f/KStFDA/LQFsI/ox53s9PlgHfilT07LYzA2mlG2LTeDfTuKB0DJ+LRL/MPOcotAvv
	 mxi56tP/eLXb39m3eXRARWIyCdEJwqSYfVuOwyAMruQjB5h6YnuAetngetfhxwNu5K
	 wt1eBGoHMX10w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/12] crypto: api - Allocate tfms from the secret
 pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rafael J. Wysocki" <rafael@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Will Deacon" <will@kernel.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Byungchul
 Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dave Young" <ruirui.yang@linux.dev>, "Mark
 Rutland" <mark.rutland@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Zi Yan" <ziy@nvidia.com>, "Mike Rapoport" <rppt@kernel.org>, "Baoquan
 He" <baoquan.he@linux.dev>, "David Howells" <dhowells@redhat.com>, "Serge
 E. Hallyn" <serge@hallyn.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Pedro Falcato" <pfalcato@suse.de>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Oscar Salvador" <osalvador@suse.de>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Peter Xu" <peterx@redhat.com>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Nico Pache" <nico.pache@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Saravana
 Kannan" <saravanak@kernel.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rob
 Herring" <robh@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Mike
 Snitzer" <snitzer@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Rik
 van Riel" <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>, "Barry Song" <baohua@kernel.org>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "David S. Miller" <davem@davemloft.net>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Jarkko Sakkinen" <jarkko@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Jann Horn" <jannh@google.com>, "Usama Arif" <usama.arif@linux.dev>, "James
 Morris" <jmorris@namei.org>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "David Hildenbrand" <david@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Dev Jain" <dev.jain@arm.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Muchun Song" <muchun.song@linux.dev>, "Alasdair
 Kergon" <agk@redhat.com>
Cc: devicetree@vger.kernel.org, linux-arch@vger.kernel.org, conor+dt@kernel.org, robh@kernel.org, linux-doc@vger.kernel.org, kexec@lists.infradead.org, dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-6-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-6-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:32:49 +0000
Message-Id: <20260928173250.18AAB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

> A tfm's context holds the expanded key schedule, which a crash dump
> would capture.
>=20
> Allocate tfms from the secret pool, so that their backing pages are
> marked by crash_memaction for the kdump kernel to wipe.
> The context is a flexible array at the end of struct crypto_tfm and the
> frontend's private data sits in front of the struct, so the whole
> allocation moves into the pool.
>=20
> Allocation cost increases by a bucket lookup in crash_memaction. Freeing
> is unchanged.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D6

