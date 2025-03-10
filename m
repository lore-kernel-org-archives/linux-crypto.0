Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2137230BC3
	for <linux-crypto@vger.kernel.org>; Mon, 10 Mar 2025 17:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626408; cv=none; b=QoHh5o55a6lnzHVFCJsknBckYe6vJZgB90pnHSiZ4DD7TJFOs/V95QV5zLIXsS/A68P2vDVn/27FUgVCq1ZEF/5Gld6+tgaIGYzjhEu9ZfbdIxpw+NyavslKh1wjFUQHDN/WWIXeRIEd9RYDXiJvqnVjoRa3YWBHEIbJjvs4zss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626408; c=relaxed/simple;
	bh=edAV+zjG7U2OwbqmnK3l8WIrJmhSjLJ4WDS2x0Xzrec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMN+NgT9VxYzm/7My42AgEnz5QL24+lNSO8CBe8IPWfL6TyFFaqwTdIWCsrE7f6NWqvfucDxLrMbe0e5GcCjWOGZHzsQt57Va7FmBuhuHzVk/j/WnJ9GTsszWranW/kX+3Iaf7USIVNmdcLYyXMua/d0rXN9rysYudVxA/U0iZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ds5WrEJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ds5WrEJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2442AC4CEE5;
	Mon, 10 Mar 2025 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741626408;
	bh=edAV+zjG7U2OwbqmnK3l8WIrJmhSjLJ4WDS2x0Xzrec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ds5WrEJlNf8XJ5CWCDMrfCRxWreyd+fJquKUqeKzADHZv5520BVY9dbb+9HFdIAFO
	 dZiwFQHKD4RteVMAV4aK8L9AEGh1h5i73l5Lkjrx9SqSucUz20mosaxbl2ujcViTVy
	 7khuIqyXV2eGIZ/qpwV8XTpTj6Zna2RvkC8saB37Mwa1R/v1zV1LszTCHISmc33q5b
	 yZKAT/VmaNja88UdSRqzOjpvvhZLtFJjQPo7UmGc6HU6I4mzaMXNYm15fxgY7am8xw
	 rfAs53a3f2sOeFf1JvZEttBbrCiFgsBRtp1znNPAv3/rkKy4a0ck4wHan0YxXLydlP
	 yHBvkCY8iW58g==
Date: Mon, 10 Mar 2025 10:06:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 2/3] crypto: scatterwalk - Add memcpy_sglist
Message-ID: <20250310170646.GC1701@sol.localdomain>
References: <cover.1741318360.git.herbert@gondor.apana.org.au>
 <18a6df64615a10be64c3c902f8b1f36e472548d7.1741318360.git.herbert@gondor.apana.org.au>
 <20250307213749.GA27856@quark.localdomain>
 <Z8whc1HklIA3rBNi@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8whc1HklIA3rBNi@gondor.apana.org.au>

On Sat, Mar 08, 2025 at 06:52:35PM +0800, Herbert Xu wrote:
> On Fri, Mar 07, 2025 at 01:37:49PM -0800, Eric Biggers wrote:
> >
> > There's no user of this yet, but presumably this is going to be used to replace
> > some of the bizarre code that is using the "null skcipher" to copy between two
> > scatterlists?  For example the code in crypto/seqiv.c.
> 
> It was actually for zram:
> 
> https://lore.kernel.org/all/Z8kiRym1hS9fB2mE@gondor.apana.org.au/
> 
> But yes we could definitely replace the null skcipher with this.
> Do you want to have a go at that?
> 

Yes, I'll do that.

- Eric
