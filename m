Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AC630DED1;
	Mon, 15 Dec 2025 20:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765829975; cv=none; b=AH81ythxPM07m19DJ9vmDlHQBXrzdHOFyURYFRXonbSm09w4yblZXZ3ggo7QWexVt9fWTSNmneMqUcfLE1mVlGZWgIr9ewe3URJo527ZqmpMQg0MiiNJ6bH9bZIo99WhvfgLdA8uxjjLLrhruVID8k2NLyHIuSXSEQmS/+dbwx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765829975; c=relaxed/simple;
	bh=E+QzejHtijSGaPlFbBvp+OnZfBnjehGhpPgMOSX/QgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GH/iVF9xABLXZ2wz2JLTX2c1h3JawL4OtY6oQrRpqRmHvI+tXwM23v4unDdsO5KiHtwSnay00BdwnryOLA/+EnsWdLvLGAWRjJdOQ5NYIc0UEVD0xgxYftvj75U78CnCcqitRDFS6ugrIOK8SjGq9tp0bPrDHr0ttevNEhc+h8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAvJGS3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAvJGS3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911F3C116B1;
	Mon, 15 Dec 2025 20:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765829974;
	bh=E+QzejHtijSGaPlFbBvp+OnZfBnjehGhpPgMOSX/QgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OAvJGS3DzDvBbZCvAqpFygmWaL5vh63j3EYvFvO3JtZn2w1XnDKSMCWDOc4Hb5y0N
	 lP41evjext4BHS70IXbBhBQcwpEJPVt7IoSy797Qx3o1M9H0f2/y7Zciyp2Yww+1rE
	 KpfeKD+SsUwQfs6TtqWXrXeiyqOAlBr4t7b1MK2ruCxARY5xJrEAqSxTn0Agnnr79c
	 ggOTUYotzRnpAe61LjUYFrCp0GW3Kdye9nGdLcVDo+Uk5T8wKxsi6T1gMmCdpJx+/1
	 +lyfaDYNpRMdGr0gMnxcYDOa3IVVZIhHfF7fge3LntC0l/JvORvjmaqFUwKfdL4ARZ
	 engKXWdh89t8w==
Date: Mon, 15 Dec 2025 20:19:32 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] Implementation of Ascon-Hash256
Message-ID: <20251215201932.GC10539@google.com>
References: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>

On Mon, Dec 15, 2025 at 02:54:33PM +0700, Rusydi H. Makarim wrote:
> This patch implements Ascon-Hash256. Ascon-Hash256 is a hash function as a part
> 	of the Ascon-Based Lightweight Cryptography Standards for Constrained Devices,
> 	published as NIST SP 800-232 (https://csrc.nist.gov/pubs/sp/800/232/final).
> 
> Signed-off-by: Rusydi H. Makarim <rusydi.makarim@kriptograf.id>

What is the use case for supporting this algorithm in the kernel?  Which
specific kernel subsystem will be using this algorithm, and why?

There's a significant maintainence cost to each supported algorithm.  So
if there's no in-kernel user, there's no need to add this.

- Eric
