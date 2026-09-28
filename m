Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50B34D9579;
	Mon, 28 Sep 2026 17:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616923; cv=none; b=K0kGW1nZSBqJ+yXmgwp9H6JS5t3Zyc7X6z42lZ9qtO82bATu9cRnXRA2yvTlvmnaqRuKjZyTx7dlIw5c8wg3FOtJjNGZYLABmXGrMUnXYsydUttVl5crUcw3C1JWQaggt0XGzLnYnizE/VY7dKQ+93eni5b8FlzMWamvf/eQMt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616923; c=relaxed/simple;
	bh=QVeyl5juHc9NJdeD8w2LctoRHYEP7jkGYs5FqZyrwKE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VlkldQseCuZobdgpM/6C+rnji0I5szv6CLceVJxud4KwcxhYyw3hg+AKK0rKGw3IPX+vPYvOKIk6ajBc2CuDo/6+9+uKvZkPRbdagSJZJym0G39WP/MHC7/jvkfpNsgiI0fvMRP6FQycpczPpFTFUUXBGNngZYy94d58PfpQ+Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVFu0Pkk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVFu0Pkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC3E1F000FF;
	Mon, 28 Sep 2026 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616921;
	bh=QVeyl5juHc9NJdeD8w2LctoRHYEP7jkGYs5FqZyrwKE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EVFu0PkkUr8RV9mJRyKpyqQI0KLTl3eJ7cm3rD0eHUOrJFg12gdP4hTIhrBrQLcqx
	 DbGbKJ9Pqs/CzWQkWJdwqFfS+uxZ7QMpVc+1ei7HjNk0Y/WemxWbLjnkULJ4JUT+De
	 CQRCq6zo9B7dF6dK67pIoay6PE4C8hWugtefNItCljakS0O50fVoIIu3Hu/+Drl81P
	 48KDHKDvUXHIVv5sle+bfB9fb2uOvwiWutpb2mamcMMiXF3zon9LfAts50zpG22279
	 eqlSNWYkYSL02mUPtY3yW819sweAPRaC0NtyWCu3rqUbN4JJhqMoUI7sjSowtv712Q
	 g/nBMfMVK1Bpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/12] arm64: Enable the crash memaction registry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peter Xu" <peterx@redhat.com>, "Mark Rutland" <mark.rutland@arm.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Gregory
 Price" <gourry@gourry.net>, "Kiryl Shutsemau" <kas@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Will
 Deacon" <will@kernel.org>, "Usama Arif" <usama.arif@linux.dev>, "Paul Moore" <paul@paul-moore.com>, "Saravana
 Kannan" <saravanak@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Dev Jain" <dev.jain@arm.com>, "David S. Miller" <davem@davemloft.net>, "Rik
 van Riel" <riel@surriel.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Danilo Krummrich" <dakr@kernel.org>, "Jann
 Horn" <jannh@google.com>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Pedro
 Falcato" <pfalcato@suse.de>, "Randy Dunlap" <rdunlap@infradead.org>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Muchun
 Song" <muchun.song@linux.dev>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Byungchul Park" <byungchul@sk.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Jonathan Corbet" <corbet@lwn.net>, "Alasdair
 Kergon" <agk@redhat.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Zi Yan" <ziy@nvidia.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Barry Song" <baohua@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Alistair Popple" <apopple@nvidia.com>, "Matthew
 Brost" <matthew.brost@intel.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "Mike
 Rapoport" <rppt@kernel.org>, "David Howells" <dhowells@redhat.com>, "Rob
 Herring" <robh@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "James Morris" <jmorris@namei.org>, "Dave
 Young" <ruirui.yang@linux.dev>, "Mimi Zohar" <zohar@linux.ibm.com>
Cc: driver-core@lists.linux.dev, linux-crypto@vger.kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org, conor+dt@kernel.org, linux-security-module@vger.kernel.org, devicetree@vger.kernel.org, linux-integrity@vger.kernel.org, keyrings@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "Eric
 Biggers" <ebiggers@kernel.org>, robh@kernel.org, dm-devel@lists.linux.dev, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-4-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-4-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:35:17 +0000
Message-Id: <20260928173517.CDC3E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

> Select ARCH_SUPPORTS_CRASH_MEMACTION on arm64.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D4

