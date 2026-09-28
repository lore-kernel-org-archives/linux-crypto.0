Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8FC37E5D5;
	Mon, 28 Sep 2026 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616710; cv=none; b=o8/6MkKsIIabuqw17oXICEcD2BG60SXW7euuMUNmo7eejvjAIkGY08e/cL0ZGKR3ShWEO/V0ffe6dPM8e7ZH9/VSvq7C9WO18N4mak1lY+Qq5qjbknHEOCC9Spc5x1w0t++rnx4Efan9IEg1+daVMkyJRUN5b0HBkbHZyieeQhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616710; c=relaxed/simple;
	bh=YUNsQKbdoNdkmOn7hVMkhLGJNjStR4GPA47+J2XShC8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XUaZluBHcAUa5rWPFATkTa0mwj+e7WuBcgBhxQAMeVlRSiNyt+59UroxutIDhyOQy+yAI7YlevqXlhYjdK0ws3SDj94rF9jVT+hvj0rQcnV6XtAhqVn+dS9OkoZW+LYGBPmp5Gq61KkXtxFOe4vtVnpJNxJB1g/pc0aZvWypmCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aaaRP7xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aaaRP7xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E5F1F000FF;
	Mon, 28 Sep 2026 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616709;
	bh=YUNsQKbdoNdkmOn7hVMkhLGJNjStR4GPA47+J2XShC8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aaaRP7xu4vYzsbzzIB1ARh5jRF/4XJXKwPf+eveA2AT8Jqgpt1Dnjgyzvhb6dw3MN
	 s5SsekoSkivHHuRMmjC8WK+SNNa6oKFRebBMX+pN+jDJMgAGxCCLmBp3y5icFGCyhq
	 koLG98wagBmCJ91hpHOfudtH6lk7UG6sxDevYDhmrwIL+e6sTydtzOC05AhgMH5nAw
	 VhsKAc6sD+RdhsMIBV2DVLUmCWQ+TBtLqTSr+vRei2d6ksq1uQcIEXUBbTV1E41N5c
	 FPQgqNF2AvWgUTJmSpxqa1beS5wNqni9CREmTJ+4t9aZH1Me00wySFaMVs7FJ3kIdV
	 Gx2ByASjD6MFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/12] Documentation/mm: Document the crash memaction
 registry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikulas Patocka" <mpatocka@redhat.com>, "David Hildenbrand" <david@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Michal Hocko" <mhocko@suse.com>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Peter
 Xu" <peterx@redhat.com>, "Danilo Krummrich" <dakr@kernel.org>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Jann
 Horn" <jannh@google.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Saravana
 Kannan" <saravanak@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Gregory
 Price" <gourry@gourry.net>, "Catalin Marinas" <catalin.marinas@arm.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Harry
 Yoo" <harry@kernel.org>, "Mimi Zohar" <zohar@linux.ibm.com>, "Matthew Brost" <matthew.brost@intel.com>,
 =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Paul Moore" <paul@paul-moore.com>, "Rob
 Herring" <robh@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Nico
 Pache" <nico.pache@linux.dev>, "Baoquan He" <baoquan.he@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Muchun Song" <muchun.song@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Dev Jain" <dev.jain@arm.com>, "Arnd Bergmann" <arnd@arndb.de>, "David
 S. Miller" <davem@davemloft.net>, "Suren Baghdasaryan" <surenb@google.com>, "Serge
 E. Hallyn" <serge@hallyn.com>, "Will Deacon" <will@kernel.org>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Mike Rapoport" <rppt@kernel.org>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Jarkko Sakkinen" <jarkko@kernel.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Byungchul
 Park" <byungchul@sk.com>, "Lance Yang" <lance.yang@linux.dev>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Dave
 Young" <ruirui.yang@linux.dev>, "Zi Yan" <ziy@nvidia.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Barry
 Song" <baohua@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Pedro Falcato" <pfalcato@suse.de>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Vlastimil Babka" <vbabka@kernel.org>, "James
 Morris" <jmorris@namei.org>, "Oscar Salvador" <osalvador@suse.de>, "Rik van
 Riel" <riel@surriel.com>, "Usama Arif" <usama.arif@linux.dev>, "Alasdair
 Kergon" <agk@redhat.com>
Cc: robh@kernel.org, devicetree@vger.kernel.org, "Eric Biggers" <ebiggers@kernel.org>, linux-security-module@vger.kernel.org, conor+dt@kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kexec@lists.infradead.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, keyrings@vger.kernel.org, driver-core@lists.linux.dev, linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-11-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-11-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:31:44 +0000
Message-Id: <20260928173144.96E5F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

> Describe the crash memaction registry, including its kernel and userspace
> interfaces, allocation lifetime rules, and current limitations.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D11

