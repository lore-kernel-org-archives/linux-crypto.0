Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6501AF0C2;
	Mon, 23 Dec 2024 19:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734982976; cv=none; b=VrA4QIhLtakT3A44FSjAPa4zGYpPUYIOSNw5Ac9cGnSMs0ML9Kxem3CwHA6avo9SYifEvdFk3RwCWiqp++CcO2cfeExk79rtLnaGhIwC0SURQba3fCNi8DaHLuMC905qj/VQVKAr5Q2sISGb3FwMIabkbT4MmtYkK7R4Jz+a/w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734982976; c=relaxed/simple;
	bh=fQbgDPFJlQTTU+AQsFMlMSKRH4NJ/wLfbeZPSBbzVHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0/n0Fn5MYPHC0DZauKGXMKCIS3pFbDyQa8lhcTZ9EsUlkj5S9JXXnJdjDPzAztL+/fUZcQi5aPPFbKZdfK2EPdvBVreUfp9i5qGw1wE24gAVoqg9X67Fpnu6M4d+ryJaOxhqa30Nv1GaBWZzdqnEI2HHjUzFUi7rNihu+TsLqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cYZEyc9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cYZEyc9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786BDC4CED3;
	Mon, 23 Dec 2024 19:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734982975;
	bh=fQbgDPFJlQTTU+AQsFMlMSKRH4NJ/wLfbeZPSBbzVHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cYZEyc9JbkVBDwlkZpcojmpiVGg5zsMmZHbh6SyQ0oe5bhW6kO29zs1nfbDR4cvAl
	 hoqR29PZOxWzx3p9KGZgadLdhG6eJQ5RnJaTYBsVQydnO6qw366hYUQE/WL+NMX6G8
	 eoojquZyRUd5AIbmuoUr3A45kG9aWat1u5RellK7BuziLO0AwmmlrNHGKSXbHOxXCc
	 Pg9Ny9lgNFP1BmnorHBpd+Hw4oU9WkwWP1CuOOfGxdOyBgMfX+Qzqjva3pjOVPd9e5
	 065qyS9urRIcW1XaoOrRKjg0UuJHJVInl41L969padWo3YzVlZBXY83kKL8XCOy1Y7
	 yIGecUsjIZxTA==
Date: Mon, 23 Dec 2024 11:42:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: linux-crypto@vger.kernel.org, Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 26/29] net/tls: use the new scatterwalk functions
Message-ID: <20241223194249.GB2032@quark.localdomain>
References: <20241221091056.282098-1-ebiggers@kernel.org>
 <20241221091056.282098-27-ebiggers@kernel.org>
 <20241223074825.7c4c74a0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241223074825.7c4c74a0@kernel.org>

On Mon, Dec 23, 2024 at 07:48:25AM -0800, Jakub Kicinski wrote:
> On Sat, 21 Dec 2024 01:10:53 -0800 Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Replace calls to the deprecated function scatterwalk_copychunks() with
> > memcpy_from_scatterwalk(), memcpy_to_scatterwalk(), or
> > scatterwalk_skip() as appropriate.
> > 
> > The new functions behave more as expected and eliminate the need to call
> > scatterwalk_done() or scatterwalk_pagedone().  This was not always being
> > done when needed, and therefore the old code appears to have also had a
> > bug where the dcache of the destination page(s) was not always being
> > flushed on architectures that need that.
> > 
> > Cc: Boris Pismenny <borisp@nvidia.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks.  FYI I will need to update this patch in the next version, as I did not
take into consideration what chain_to_walk() is doing.  This code seems to be a
bit unique in how it is using the scatterwalk functions.

Also I think the second paragraph of my commit message is wrong, as the calls to
scatterwalk_done() in tls_enc_records() are the ones I thought were missing.

- Eric
