Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5175E4EFFD7;
	Mon, 28 Sep 2026 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617113; cv=none; b=g86Ok14QaEEeUj+gnR5S+AKmr9Y9xXEuvHEXyLvrsfc/e5uuVivNxtI36ZhHfLBxJj0si3ZQKMTS2TGce9a0QPNNOd9y1G369rTE1ZQAkLcDPSv+q/5X0cVUnIbuvMwg5gR+51694arzRjUlYdoOikD98cTXOlBc10NrnS5u6PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617113; c=relaxed/simple;
	bh=DySG/0GS7NCEj9TyzIgF1uBY5DmteDGpMAAIrxw8IfI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=er+jioHTybooDL5W2nmESEjZjkEsiSN31Fx3ORxdLpf2THqPspZq8b2cxC9pcJwveAX9rvdxIGTctQzeqLWY9GyveN6TAKl1u/UypVgcDRZ9V10T6plRnDsnsd/EmRmXe1GqXJZiLvVRBGZ742Yd2cXvzNLwT/E593Lfc2jAm8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3XNkJUM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3XNkJUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9521F00893;
	Mon, 28 Sep 2026 17:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617112;
	bh=nU2fH54lTM/XVwJXQyjGLBeD3ZciwzAWp4eXcqDvdbM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S3XNkJUMsfb4UVOiI5bqkQdMQxSrtSwJSk+zko+Kb8nyx1/fqNP+w7Q7XMX4d9LFS
	 UpCy7pFlCeLa40OP6BXCxLJAzMBOd9S9sxWq8L8Jtt8orYI0l5uqfdJZROyth2vfib
	 5uQjGgfd2Z1mVJgCwOGmsJxkE0gLFEG3SX22xLC77eFkOJMnQzLdB37T2NqjWpNoyp
	 FTppfoE54PLRaqkGfhCai4quB2BGHu9vVrE9Ttd2f5wdvTQz58p7klVEjZDYk8ILzq
	 0uWbZHan00HjovXjqsXB+ZjTvra2/JJk7Xr6L34CRAqtG/8M4oLEVkPLj0ZgwqrtyI
	 1xxzJXt9dk+iA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/12] kexec: Expose the crash memaction bitmap in
 debugfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hildenbrand" <david@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Jann Horn" <jannh@google.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Will
 Deacon" <will@kernel.org>, "David S. Miller" <davem@davemloft.net>, "Harry
 Yoo" <harry@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Peter
 Xu" <peterx@redhat.com>, "Mark Rutland" <mark.rutland@arm.com>, "Usama Arif" <usama.arif@linux.dev>, "Rik
 van Riel" <riel@surriel.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "James
 Morris" <jmorris@namei.org>, "Dev Jain" <dev.jain@arm.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Paul Moore" <paul@paul-moore.com>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Alasdair
 Kergon" <agk@redhat.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Rob Herring" <robh@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Barry Song" <baohua@kernel.org>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Randy Dunlap" <rdunlap@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "David
 Howells" <dhowells@redhat.com>, "Saravana Kannan" <saravanak@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Baoquan He" <baoquan.he@linux.dev>, "Dave
 Young" <ruirui.yang@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "Byungchul
 Park" <byungchul@sk.com>, "Alistair Popple" <apopple@nvidia.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Matthew
 Brost" <matthew.brost@intel.com>, "Suren Baghdasaryan" <surenb@google.com>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Arnd Bergmann" <arnd@arndb.de>, "Jonathan
 Corbet" <corbet@lwn.net>, "Mimi Zohar" <zohar@linux.ibm.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "Gregory Price" <gourry@gourry.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Mike Snitzer" <snitzer@kernel.org>,
 =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>
Cc: linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, devicetree@vger.kernel.org, linux-security-module@vger.kernel.org, kexec@lists.infradead.org, driver-core@lists.linux.dev, keyrings@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, conor+dt@kernel.org, linux-crypto@vger.kernel.org, robh@kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-12-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-12-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:38:29 +0000
Message-Id: <20260928173829.9E9521F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] kconfig: syntax error due to insufficient indentation in help text
--

commit d0f9200d03ebaf0ef39b9f78a15ab259102ed7e8
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

kexec: Expose the crash memaction bitmap in debugfs

This commit adds debugfs support to expose the crash memaction bitmap by
creating "regions" and "bitmap" files under /sys/kernel/debug/crash_memacti=
on/.
The feature is guarded by the new CONFIG_CRASH_MEMACTION_DEBUGFS option.

> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 3cdc8d459ac05..b5380e16bfafb 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -204,4 +204,18 @@ config CRASH_MEMACTION

[ ... ]

> +config CRASH_MEMACTION_DEBUGFS
> +	bool "Expose the crash memaction bitmap in debugfs"
> +	depends on CRASH_MEMACTION && DEBUG_FS
> +	help
> +	  Allow reading the live crash_memaction bitmap through
> +      /sys/kernel/debug/crash_memaction/. The bitmap is used when

[Severity: Low]
Does this indentation break the Kconfig help block?

The first line of the help text is indented with 1 tab and 2 spaces (which
is equivalent to 10 spaces in Kconfig), but this line starts with only 6
spaces. The Kconfig lexer terminates a help block when it encounters an
indentation level lower than the block's first line. This could cause the
parser to interpret the rest of the text as an invalid Kconfig directive,
potentially resulting in a syntax error and build failure during make confi=
g.

> +      CRASH_MEMACTION is set and when a crash_memaction cmdline param is=
 present
> +      to tell an eventual kdump kernel about the use of certain memory p=
ages.
> +
> +      Note that this is a debug interface only that gives no guarantees
> +      whatsoever on memory consistency.
> +
> +	  If unsure, say N.
> +
>  endmenu

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D12
