Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB3D3FE4
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 04:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742100176; cv=none; b=dtqJTktQXbRk6nlucam4JmoaS/GBB0IUVwP33j3iU8AVW1wOlugRK2wMjM8HquyTWREuxUWJVT8THHSW7sjHyWeSC7jvEVtQZ1oGGndEnHCqipvFgJezNwNDQ6Xmyv5E0/J0qZZ4aAl/Kk+go3jyW5QjEXs2K6uAaU8EUx8Xb7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742100176; c=relaxed/simple;
	bh=FGfADJhm3CFsBBZggsIiPgW1VfQ6TKF1BI01LcIXnxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ywu+kNYOTUJekiOHyx/dLbKqNFSJpJhPRgT1pTirtzwI+EghyEKiRsmHvx0AjJudnoyfM9r8SvJ9vI5ipJHoVUVL3Dl38WCwtg3Web4OoeLZZCxbJaQmWewp53NeKd6LArWWfOs2iib4X5qnjXZIc3wqMfEg7FDWpK56iAq+TtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=k9NBerxG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="k9NBerxG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9yXLEA2gkkxVwFj95a0vCypA5LZaUICGQDwQVgpFSFQ=; b=k9NBerxGqgHGEcMxl6lcRVW1nh
	T8d8mErIpzSgpSALsqo5WOXzc6t2vB6vwlIsWldcIeO9GpniL2TfnD7atrfDoyKWGmVHswK0DNjjQ
	BJaHQYeKTMeAa86B5j2A6Ogn61+7ZEChQ9eJfjHTz39BZOshwgecnCCzJHYvfuY0KmMjTqAC3/YPT
	ht+oSST7dUZdGmrUYbwv8UOs47fU+GJh6hFiDUv2Xe99kRQpdRHLXCEeGI2Yc7YbUfXK3h3zCrWMT
	iwMXS6QjjPgvy9jXUhWNxGCGUeeY8N6b0uBQFRnJboRflOs8gBvkXy035HzvmsJJRzAlWIV3mVK7j
	1FfEel+g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttfpo-006yzW-2M;
	Sun, 16 Mar 2025 12:42:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 12:42:48 +0800
Date: Sun, 16 Mar 2025 12:42:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 3/8] crypto: acomp - Move stream management into scomp
 layer
Message-ID: <Z9ZWyGpILLHTQzhf@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <25f96a0e0e642e9d1c6014b12b00fd21b9f9c785.1741488107.git.herbert@gondor.apana.org.au>
 <20250316043631.GC117195@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316043631.GC117195@sol.localdomain>

On Sat, Mar 15, 2025 at 09:36:31PM -0700, Eric Biggers wrote:
>
> But of course there is also no guarantee that users want it to be per-"tfm"
> either, let alone have a full set of per-CPU buffers.  FWIW, this series makes
> the kernel use an extra 40 MB of memory on my system if I enable
> CONFIG_UBIFS_FS, which seems problematic.

The memory is allocated on first use, or am I missing something?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
