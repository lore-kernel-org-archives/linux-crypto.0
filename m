Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E071E3803D6
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 15:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774019186; cv=none; b=QUsq3iRW/eCN/o5VrxV9e/+G8WKoqyjyszfSK0zdGp7gWz+5cl1f+zWkUeYOrIfcYqpoVpTkGnd2FSMDNDsgS4Ub5LT4+X8WOJl0ffT9vQAyuYtBjvuGG3vsMfUkwqKukbbO9ve4zUrXEuCH7St0Ogiact+kdILbzjV2yEeCdNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774019186; c=relaxed/simple;
	bh=DvpAtXbZitiq7MQ3g4MX7pj97XkM96ETYqAuNBHUsI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKoweIPVXxr517qkTBhN9sSOn1iMnR2IbP5bBYT0CkvKmq85tXRV+wgxOPndLzmiSCUixBoSot6O95hS40Vn9MUTqXv0kroZG1VdQ2C1pWoyi1Bcz/0NtGOX/S2KpSA4flHAkjBZ2ehGVLWROmtjU83ZcgeuikmNIZp6Q2cyKv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NcLxmILw; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NcLxmILw"
Date: Fri, 20 Mar 2026 16:06:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774019173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PM0ecKAgG32QvB1q4aNjle0Vk2lnfC0MirltUTa1XaE=;
	b=NcLxmILw2TOdpNaObDp5OgcX9bNJH2V5AALnfEbAl2pNVhALD6ziRtUXejDg+29FQGKQLp
	TrwRNU0wwUFk5L5L9zeRyrJj5UoCoNQyQ/cwcssFf5XfD+x5kxWEbePikVbap/czQdCMUa
	vG9osed2XollmYfkkBuneNIRfZbT5fM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Haren Myneni <haren@us.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: nx - Fix packed layout in struct
 nx842_crypto_header
Message-ID: <ab1iXryB4x0YwA3w@linux.dev>
References: <abnmUvHzhgS9xA-m@kspp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abnmUvHzhgS9xA-m@kspp>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 17, 2026 at 05:40:02PM -0600, Gustavo A. R. Silva wrote:
> struct nx842_crypto_header is declared with the __packed attribute,
> however	the fields grouped with struct_group_tagged() were not packed.
> This caused the grouped header portion of the structure to lose the
> packed layout guarantees of the containing structure.
> 
> Fix this by replacing struct_group_tagged() with __struct_group(...,
> ..., __packed, ...) so the grouped fields are packed, and the original
> layout is preserved, restoring the intended packed layout of the
> structure.
> 
> Before changes:
> struct nx842_crypto_header {
> 	union {
> 		struct {
> 			__be16     magic;                /*     0     2 */
> 			__be16     ignore;               /*     2     2 */
> 			u8         groups;               /*     4     1 */
> 		};                                       /*     0     6 */
> 		struct nx842_crypto_header_hdr hdr;      /*     0     6 */
> 	};                                               /*     0     6 */
> 	struct nx842_crypto_header_group group[];        /*     6     0 */
> 
> 	/* size: 6, cachelines: 1, members: 2 */
> 	/* last cacheline: 6 bytes */
> } __attribute__((__packed__));
> 
> After changes:
> struct nx842_crypto_header {
> 	union {
> 		struct {
> 			__be16     magic;                /*     0     2 */
> 			__be16     ignore;               /*     2     2 */
> 			u8         groups;               /*     4     1 */
> 		} __attribute__((__packed__));           /*     0     5 */
> 		struct nx842_crypto_header_hdr hdr;      /*     0     5 */
> 	};                                               /*     0     5 */
> 	struct nx842_crypto_header_group group[];        /*     5     0 */
> 
> 	/* size: 5, cachelines: 1, members: 2 */
> 	/* last cacheline: 5 bytes */
> } __attribute__((__packed__));
> 
> Fixes: 1e6b251ce175 ("crypto: nx - Avoid -Wflex-array-member-not-at-end warning")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/crypto/nx/nx-842.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
