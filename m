Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5150F270023
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 18:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740681529; cv=none; b=oeM1Czz6whQFfQORxIX2GUUjfAiWXCUTCaUqd/qRqZnjGA3ii6tVaWsZDuu3Sow0WHwqt+0Xf+cfR70oWOWHKflyBrjjrhZDyuACl8yyPugPS6A4d358WRLhx8EyLdn2PICZ674PzCZkVWph+mzagsYoCAizc/o0PaTXUa9OQvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740681529; c=relaxed/simple;
	bh=1nZUm+Rnpk+A01u11Gmh6kUxXiy9OKofXp9SJwE/j6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KOMOAm9WLGjj8GqxQLEKjhQYeyopZCrgmVbcW18+2/es08n+Fsofqj7XWdLPTo8EBF417gBYW5NOwueTMPMN8srPWJh9c9/LZ+FrSWf/OypJzuidt097H81Brsxw2lWGjHY31gxKcqYHt1cs0cYcXDQnjGcvIgOECL9FBqL3P3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHlOGBaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHlOGBaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12400C4CEDD;
	Thu, 27 Feb 2025 18:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740681529;
	bh=1nZUm+Rnpk+A01u11Gmh6kUxXiy9OKofXp9SJwE/j6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZHlOGBafezUqsI91KyFECvRZEwFT3kOrqQ95sNC1quz3fDoiugK23z6NhgR8QCTJ9
	 +KP4Niv2w7IqaHHpdA9kySMnoX6n1XRpkT4geDoBuWJD1629fL9Hks/cvHafy6ZdoB
	 BReEidZDGw5bfrQebgpKaTWdccq9LJZ5qLnvQZ+7ww9N1Ix6NNBcaYWsDvjZg8F1fB
	 8bLSJP8kSqVj/RoAKGTDw1JigwiOTjrCOWUFjNs1nczX+KitBYmDYrmkvGgji6kanY
	 ufZi2t8cp1K653fq0pPiGlxMOMzmdd7fsN8YGiZx4sXpjqomHGfn1MCr5cvjM5JaUR
	 2yHZHSwRG7zRQ==
Date: Thu, 27 Feb 2025 10:38:47 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <20250227183847.GB1613@sol.localdomain>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8CquB-BZrP5JFYg@google.com>

On Thu, Feb 27, 2025 at 06:11:04PM +0000, Yosry Ahmed wrote:
> On Thu, Feb 27, 2025 at 06:15:09PM +0800, Herbert Xu wrote:
> > Use the acomp virtual address interface.
> > 
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> I can't speak to the rest of the series, but I like what this patch is
> doing in zswap. Together with the recent zsmalloc changes, we should be
> able to drop the alternative memcpy path completely, without needing to
> use kmap_to_page() or removing the warning the highmem code.
> 
> Thanks for doing this!

Well, unfortunately this patchset still uses sg_init_one() on the virtual
address, so AFAICS it doesn't work with arbitrary virtual addresses.

- Eric
