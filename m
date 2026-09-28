Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285113546FE;
	Mon, 28 Sep 2026 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617810; cv=none; b=u324aXF56Pc4Lj0xk0suXS7kMne5VW7KZSdHC2/FQLoyBLuLQ+3uGQt9W9vft0VuqUblLj9SFBlq9ylkHP77Hxjr+0mZmDq4QXCTPRQmUxi+h06aWCJ3NdnnF2ECOTH+i+8JkNbM3gxXi/MNND1zd+572awL6bW6axKJPpbegZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617810; c=relaxed/simple;
	bh=u/E59QhchBsakfNPPqr6eKRHZdqiWw1FvCI9GEDCeFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fc/h7WXBiNx614J+45tghZv8S5GiPorXd9GsGPymd9yACZxK/j1mdZp1Ry9zxRd3ifd8EvnV0ViA8yusYieeZhyNXB4gx1x3cFvhjzVIKKWU6WBnev6q03JzoXENBbkr80Ms12XY4RNmbB7L+fXBNk5tpIc7mgLZjvUYAwK3kAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KjJm0noY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KjJm0noY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F290B1F000FF;
	Mon, 28 Sep 2026 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617809;
	bh=dJBj7jrhd8l/3+1i/MYD1Oe07SV8AbeGkY/QzpcIlXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KjJm0noY+sn5WykpEMYX/0cqYF5OZAonPsiiMo8gsrJp3dbtWXzQ+MUuPiGJZJA0x
	 6jLqI4XrjH/ECSiSdsjKSDEcOX8VHNjxTUmFetbOQTlOnUn092Xi9vWRpAgkcyI7cV
	 VEdR4+s8FUt72QAhYPACB1DPHc7Kdjz2uCMGh47V7dCsVAU9tDI9stHRuVWg4VowUL
	 wsubuRL7tSu1HVvPbp8bYrkCi5Pwl78yS8X19cLVqL1XZl7poDdf3RukkTBc6rpsfh
	 AjjBKhJEyZefMZQzGawiz22PfrG9g5f1MlSZXvtXI+fxD2E2qzuSdugjHmvJG38tDb
	 U9iSc28s9bD3A==
Date: Mon, 28 Sep 2026 18:49:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jan Sebastian =?utf-8?B?R8O2dHRl?= <linux@jaseg.de>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Mimi Zohar <zohar@linux.ibm.com>, 
	David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, kexec@lists.infradead.org, driver-core@lists.linux.dev, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 00/12] CRASH_MEMACTION: describe pages to a kdump
 kernel (was: CRASH_WIPE_SECRETS)
Message-ID: <arqli0H0v5qPG22z@gremlin>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>

On Mon, Sep 28, 2026 at 07:17:48PM +0200, Jan Sebastian Götte wrote:
> I'm using linux on an embedded target in a Hardware Security Module-like
> application. One requirement is that I want the system to be able to
> quickly erase its memory when it detects physical tampering. I'm
> approaching that by using kdump to load into a small payload that
> instead of dumping RAM, erases RAM frmo start to end. However, writing
> all of RAM, especially on an embedded target, is rather slow. For this
> reason, I propose a new crash_memaction mechanism that lets the old
> kernel indicate marked memory areas to the kdump kernel at page
> granularity.

Sorry this all seems really invasive for what seems to be a very specific
use case.

In general, with big changes like this, you should send the series as an
RFC.

Please send any future revisions of this as an RFC.

The bar for a new VMA flag, a new madvise() flag, etc. is really quite
high, and I've already noticed what looks like quite buggy code glancing
through.

And again, I really don't think your case sounds all that compelling for
general users, given how invasive the changes are, so I strongly suggest
you rethink your approach.

In any case, as a newcomer to mm, we really ask that people start with
smaller changes and build up gradually, a change like this really should
only be done by somebody with an established reputation in the kernel.

In general re: AI-generated code see
https://docs.kernel.org/process/generated-content.html

	If tools permit you to generate a contribution automatically, expect
	additional scrutiny in proportion to how much of it was generated.

	As with the output of any tooling, the result may be incorrect or
	inappropriate. You are expected to understand and to be able to defend
	everything you submit. If you are unable to do so, then do not submit the
	resulting changes.

	If you do so anyway, maintainers are entitled to reject your series without
	detailed review.

Thanks!

--
Cheers, Lorenzo
