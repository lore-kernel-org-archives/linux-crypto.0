Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA413CF04C;
	Fri, 15 May 2026 10:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840620; cv=none; b=T4f4XPOCccqSv9VK4J/GcxWIyeBg6XEqevXbEfIqMmqDN4HuvDKlScxLX5b8k/pIRIq3RzLtaGv/smrAodg5vo8teSGyowoDOtJRPjf1JT5/jYleLFnFer6NMqDHQcfQjHquNeFqU2StTWOjo5mM9awWXlgtzjVxohr6sp39L8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840620; c=relaxed/simple;
	bh=9YL70ocQPapy8m9Vwt9xSZRBqRiLTDSfWdZHGMUCyOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AP5KI9HpQYuzZGDXa/4zFa4/A45z4G8IXGQIm2r4qxDpUjTihSYzcdZCml8UTb8sxu+hAwy8qpQTy5iruRUlAxnIlUw6d4NdJkOQ42Zo580YqG3Q//3cmU32FYJNN01OpaQdugkJpB7YZibn988v1CR4OnZEHzoye0q1ro1NnI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=p5w5J1px; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="p5w5J1px"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ykRodeBhF0cXfcSqXz2szUw5McJKqpEFePe6cFI1Rto=; 
	b=p5w5J1pxzXQ6m6chUdkvsFtXcPJ8hZUpF31FPKK3GAAjkl9mRHduEy8nCxpg7bgogLSX2Vo2HB7
	RrlMV0MuzOdtbluF9f1Uf+YqHK/QHbAB3CKGzZpBq0cukWbTO3IpGOiLjiu8o+JYPYfZ+uDIpwG+4
	ofiKKg/MHeM+WlwJVdkRVjDUNHBhYEmJhts2oI9KqlewTJXU/ZeC8aPd7TC4kQVKWTRmg/PWFREsV
	DvsdT3VKrO6cpQFCDf3SutjDP0EXnPSk/bGTnyF2Aumvj8s6vK2KtmT3MVUrq3Kw3PJ+nSBZhKxpQ
	O4UgphF8lsuMkfwQWG5402xx4VzH88bcTz0g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNphS-00EOY0-39;
	Fri, 15 May 2026 18:23:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:23:22 +0800
Date: Fri, 15 May 2026 18:23:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Herve Codina <herve.codina@bootlin.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 00/11] crypto: talitos - fix several issues in the
 Freescale talitos crypto driver
Message-ID: <agb0Gry9gqmYHPdn@gondor.apana.org.au>
References: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>

On Thu, May 07, 2026 at 04:41:46PM +0200, Paul Louvel wrote:
> This series fixes several issues in the Freescale talitos crypto driver.
> 
> Patch 1 fixes a missing dma_sync_single_for_cpu() before reading a
> descriptor header.
> 
> Patches 2-5 add support for chaining an arbitrary number of descriptors
> in the driver for the SEC1 hardware.
> 
> Patches 6-8 rework the SEC1 hash implementation to build descriptor
> chains instead of submitting one descriptor at a time via a workqueue.
> 
> Patches 9-10 are cleanups: rename first_desc/last_desc to
> first_request/last_request, and remove a useless wrapper function.
> 
> Patch 11 fixes the same ahash request size limitation on SEC2 (64k - 1
> bytes), by splitting ahash_done() into SEC1 and SEC2 paths so that SEC2
> iterates through descriptors sequentially.
> 
> Tested on an MPC885 SoC (SEC1 Lite), and on an MPC8321EMP SoC (SEC2)
> with CRYPTO_SELFTESTS_FULL=y.
> For the SEC1 Lite, some tests are failing due to a timeout waiting for
> request completion. These failed tests existed prior to this series.
> On SEC2, there is no failed tests.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
> Changes in v3:
> - Patch 1 was reading the next chained descriptor header
>   unconditionally. Fixed it by checking if a request actually contained
>   a chained descriptor before deferencing it.
> - For descriptor chaining introduced in patch 2, use a next pointer
>   embedded inside struct talitos_edesc instead of the kernel's struct
>   list_node. This removes the necessity for a desc_chain member in
>   struct talitos_request. A dirty hack was previously used to assign a
>   request->desc_chain to the current request by taking edesc->prev,
>   assuming that the descriptor was added to a list before calling
>   talitos_submit(). Not only was this non-idiomatic, but it also broke
>   the skcipher and aead implementations because they do not use the
>   descriptor chaining feature at all. The descriptor chaining mechanism
>   does not need a doubly circular linked list; this change makes the
>   code more readable than sticking with the kernel linked list
>   implementation.
> - Updated the performance measurement in patch 6.
> - Drop patch 12, which was a revert of commit 4b24ea971a93 ("crypto:
>   talitos - Preempt overflow interrupts off-by-one fix"). This patch was
>   primarily motivated because the SEC1 has a Fetch Register rather than
>   a Fetch FIFO per channel. As a result, having a value of 24 in the
>   device tree node for the channel-fifo-len property does not make
>   sense, as the hardware does not have a Fetch FIFO. Setting this value
>   to 1 (which should be the correct value for SoCs featuring the SEC1
>   engine family) breaks the driver because no descriptor can be
>   submitted due to commit 4b24ea971a93, and the patch was primarily
>   intended to fix this issue. As this issue is too deep to be addressed
>   in this patch series, it has been dropped.
> - Link to v2: https://patch.msgid.link/20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com
> 
> Changes in v2:
> - Split the first patch into smaller, logically separated patches for
>   easier review.
> - Added more context on testing on the cover letter.
> - Introduce a fix to correctly read hardware descriptor header. This fix
>   was motivated by a remark of Sashiko on the v1:
>   https://sashiko.dev/#/patchset/20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5%40bootlin.com
> - Separate SEC2 64k-1 ahash limitation fix into its own patch.
> - Link to v1: https://patch.msgid.link/20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com
> 
> To: Herbert Xu <herbert@gondor.apana.org.au>
> To: "David S. Miller" <davem@davemloft.net>
> To: Christophe Leroy <chleroy@kernel.org>
> To: Paolo Abeni <pabeni@redhat.com>
> To: David Howells <dhowells@redhat.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> ---
> Paul Louvel (11):
>       crypto: talitos - use dma_sync_single_for_cpu() before reading descriptor header
>       crypto: talitos - add chaining of arbitrary number of descriptor for the SEC1
>       crypto: talitos - move dma unmapping code in flush_channel() into a standalone dma_unmap_request() function
>       crypto: talitos - move dma mapping code in talitos_submit() into a standalone dma_map_request() function
>       crypto: talitos - move code in current_desc_hdr() into a standalone function
>       crypto: talitos/hash - prepare SEC1 descriptor chaining, remove additional descriptor
>       crypto: talitos/hash - use descriptor chaining for SEC1 instead of workqueue
>       crypto: talitos/hash - drop workqueue mechanism for SEC1
>       crypto: talitos/hash - rename first_desc/last_desc to first_request/last_request
>       crypto: talitos/hash - remove useless wrapper
>       crypto: talitos/hash - fix SEC2 64k - 1 ahash request limitation
> 
>  drivers/crypto/talitos.c | 549 ++++++++++++++++++++++++-----------------------
>  drivers/crypto/talitos.h |  12 ++
>  2 files changed, 287 insertions(+), 274 deletions(-)
> ---
> base-commit: db8b9f227833e729faf44a512aa1e88a625b5ad8
> change-id: 20260504-bootlin_test-7-1-rc1_sec_bugfix-13169ed07ddc
> 
> Best regards,
> --  
> Paul Louvel <paul.louvel@bootlin.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
