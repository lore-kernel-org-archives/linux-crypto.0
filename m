Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F8D37C10A;
	Mon, 28 Sep 2026 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616841; cv=none; b=ubFSA8q3FLl//2ToO3c7Vu3jbLyTtOyBR3ksITS9TaxXw1HEch4lBBF4iYZENSWZY6I1x9IRhmFAHmNEPV4t04Zb+84ZrHihnZo8c0KPxdRCtWJESG6i2dWg2M/VFRi/nCIeTBAdquxkrMFuwOiNhIN1tTXPveKf8e1YH1WiKGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616841; c=relaxed/simple;
	bh=Rv/LkB6PetOdVT/pJO5A17DkMHpW1BtDQRc+jBFVZPw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pFGMtRa/Gph6mjbQRQNbR3xv0ZrejZvv1zdnQh+ijdshtU1dcvWsFxq4nqiEWybNlRZ3oDtWVvcF5CQ7gA8PoQhkxGJvdVt5pKXm5NhUvh3sc7SFC82dK0CcG4p0RX61V96GwSDlF8kLSIhUFOM9zZaEpUhbX3J2iqS8Dild8io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EXIu9dO6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EXIu9dO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E641F000FF;
	Mon, 28 Sep 2026 17:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616839;
	bh=Rv/LkB6PetOdVT/pJO5A17DkMHpW1BtDQRc+jBFVZPw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EXIu9dO6xq2mXjLluKTuv30Af8CyESirOON3Mf9f2hlYpl04nw+40wD3YbPZG1tfL
	 HmEUK5JSYhOyLVpaITSvM4ELC305cnUmqN9ksJ+i7mccp6EtQ/LsYNrSRewyr85nde
	 fVJV76IlrsFhWqVs/3xmVmIBd5rfId8R3Lh7oVvN7+x6UaAjI/u56vaUwWNH+BzmMd
	 5K4imrySj0RLN+5w4QO4+sSnSj9TmSjJF2l8B8t3RQ3nGTFBARSJ9FwuxizUmBvtrv
	 QDRybDY6Goyif08lGnOWdctOSDJJJnyLsuwJCiGm2H3dSjfMBA31RN52rTusPsKHOf
	 pnr0NyfPsRKJg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/12] dm crypt: Allocate key material from the
 secret pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>, "Matthew Brost" <matthew.brost@intel.com>, "Byungchul
 Park" <byungchul@sk.com>, "Harry Yoo" <harry@kernel.org>, "Dave Young" <ruirui.yang@linux.dev>, "Will
 Deacon" <will@kernel.org>, "David Howells" <dhowells@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Mark Rutland" <mark.rutland@arm.com>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Dev Jain" <dev.jain@arm.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Peter Xu" <peterx@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "James
 Morris" <jmorris@namei.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jann Horn" <jannh@google.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Saravana Kannan" <saravanak@kernel.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, "Lance Yang" <lance.yang@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Randy Dunlap" <rdunlap@infradead.org>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Muchun Song" <muchun.song@linux.dev>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Danilo Krummrich" <dakr@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Mike Rapoport" <rppt@kernel.org>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Liam R. Howlett" <liam@infradead.org>, "Rik van
 Riel" <riel@surriel.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Nico
 Pache" <nico.pache@linux.dev>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Mike
 Snitzer" <snitzer@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Pedro
 Falcato" <pfalcato@suse.de>, "Baoquan He" <baoquan.he@linux.dev>, "Suren
 Baghdasaryan" <surenb@google.com>, "Alasdair Kergon" <agk@redhat.com>, "Zi
 Yan" <ziy@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Rob Herring" <robh@kernel.org>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Jarkko
 Sakkinen" <jarkko@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, conor+dt@kernel.org, driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org, robh@kernel.org, linux-security-module@vger.kernel.org, kexec@lists.infradead.org, keyrings@vger.kernel.org, linux-arch@vger.kernel.org, devicetree@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-5-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-5-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:33:55 +0000
Message-Id: <20260928173355.B7E641F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

> dm-crypt keeps the volume key, the IV mode seeds and, when a keyring key
> is used, the key description in memory for as long as the target exists.
> If the system crashes, they are left in memory and will end up in a
> crash dump.
>=20
> Allocate every buffer that holds key material from the new secret pool,
> whose backing pages are marked by crash_memaction for the kdump kernel
> to wipe. The volume key is a flexible array at the end of struct
> crypt_config, so the whole struct moves into the pool with it.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D5

