Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D52E372661;
	Tue, 28 Jul 2026 03:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785210249; cv=none; b=EM2jYqGvBbdT3i9VH0/kUb13rr0nAl/0HfGAv1FrE2Dyl/V66T6nNAU7y6LhtCk7mzpA0B5XBcrjOfym5agtKUY/EnvLybPlQSsR20qufo4yeaiP9nUHFoiupS1DhfGPDho3r/+d663L0GJohsfCN+jrP5EOtuSIZODhaHaOErc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785210249; c=relaxed/simple;
	bh=zcISkZrkhxCtl6AVbUTUJqsi5MmFJa+RTncRXpQ5qI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z1/XBhIrVYJlb3G/jvX4dpE6o/7PYyH33sP/+VN4LmaG7S6ocj7CUmFOnF5zC49FFUQnUHSWa7lQrsLwH4Nuptj//025clXNpEOKJMPuecGHyCKTLWW9NTQX+oAcuLaFSblCxK2JoUXHKRNQA4pBLNKffgLl++hQIKYMEWlwu3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BF36368AFE; Tue, 28 Jul 2026 05:44:04 +0200 (CEST)
Date: Tue, 28 Jul 2026 05:44:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [PATCH v2 8/8] lib/raid/xor: x86: Add AVX-512 optimized
 xor_gen()
Message-ID: <20260728034404.GE18902@lst.de>
References: <20260728021603.79870-1-ebiggers@kernel.org> <20260728021603.79870-9-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728021603.79870-9-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Stick to the xor: prefix here as well please.

