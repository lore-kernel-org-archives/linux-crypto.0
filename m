Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31A23AF666;
	Mon, 28 Sep 2026 19:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623228; cv=none; b=booYWv8WKl8xMLMjYHTSxIfkS+M8xNwEbEXr97xA9pg4yJVld17yETnv+go7y68DQd+FHRFsdpZqOno/wlLMwXOq54yUP9ABySV32h1AalBlGYQMCQOJkzupE90aWRzF86PdMaafrX1XcrW3nWiIPj9ZtECaEVxfU50ldqcme+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623228; c=relaxed/simple;
	bh=3zEPkUFxOR09IdnXs7p5QQFfZrVevbRfZuoN0pz3I+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tdFVJTpUDBbeJBJnOkhOOxuXE4oZEGog96Uo4+E5ZMlBvYsY+WJw3dsIhtjHiLXU7LVk2U+h1SeU4ovqXyOEVjZWhk6HsUNExTRsxkzUve5JZzScV3uTgc5ich0S0rKH2SaI6Lp6DpukDyjIOmxMGjmeV3c/v+YYuoIXWi1OiH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RqFymikj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RqFymikj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=XBqyVMo6pWKAr13NYV/9DY4DwxVan3yzu41fmE1Qx6w=; b=RqFymikjtUZjzYg7puqAnn+sg3
	61FRddqIeawfj9uM+vYWtCfo1ylwmmINy9FVZ/tC3YoBr4aJbIxEXtzk8tGX7VF962W5/ko1IE4pH
	KonoVPFwRYCXr6IMzmkpDCSMyDSAZY/zqDxV/mCwdoNoAM5tXfSzkQUN3apsLc04f+dO2/wr/GN47
	fslxlNodhFwrFldD91LdDL0Shf4oAvq9/kpLqsB1DAq9kpr0v0pi54xZnCxJ165Dj5JiEfHoGb14+
	XqJsHdq9vLDUgWcjCxT3dZasZuSlJQzWrvwEoI6aKbB3bzok+wGAUIx0NeBWwrnl2M9jV0GUdDAJm
	b5C3yInA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xBGt9-00000001Pqt-0G3I;
	Mon, 28 Sep 2026 19:19:47 +0000
Message-ID: <99217c46-6ec4-4af6-ac14-18f814f86ba1@infradead.org>
Date: Mon, 28 Sep 2026 12:19:44 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/12] kexec: Expose the crash memaction bitmap in
 debugfs
To: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Mimi Zohar <zohar@linux.ibm.com>,
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-12-e511e9ee2329@jaseg.de>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-12-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/28/26 10:18 AM, Jan Sebastian Götte wrote:
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 3cdc8d459ac0..b5380e16bfaf 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -204,4 +204,18 @@ config CRASH_MEMACTION
>  
>  	  If unsure, say N.
>  
> +config CRASH_MEMACTION_DEBUGFS
> +	bool "Expose the crash memaction bitmap in debugfs"
> +	depends on CRASH_MEMACTION && DEBUG_FS
> +	help
> +	  Allow reading the live crash_memaction bitmap through
> +      /sys/kernel/debug/crash_memaction/. The bitmap is used when
> +      CRASH_MEMACTION is set and when a crash_memaction cmdline param is present
> +      to tell an eventual kdump kernel about the use of certain memory pages.
> +
> +      Note that this is a debug interface only that gives no guarantees
> +      whatsoever on memory consistency.
> +
> +	  If unsure, say N.
> +
>  endmenu

Please adhere to kernel coding style for Kconfig files:

10) Kconfig configuration files
-------------------------------

For all of the Kconfig* configuration files throughout the source tree,
the indentation is somewhat different.  Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces.

-- 
~Randy

