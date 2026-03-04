Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8893033E6;
	Wed,  4 Mar 2026 13:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772630618; cv=none; b=LdmAyTEBceGJDzhgW59IvZRwfJJt1oM+OCv+ov34MALzcIpgCHgAVPw3am5Flc2d51e5bE+mzSFquFuLjFwP4MPzM58KLND5M9+R5xKkTyz/ruCtlQZhNCCFcGOnebG99Qk2VAjMMaBO8VHpmMGxTjlnSb15nIpapNeHzKuramw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772630618; c=relaxed/simple;
	bh=pEqqklHexgITSbG0g3d7xNwIzPqfawaNzgS/0G1kBJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kKCJ2CiaVf3QwRO73iO1kXpl4br7nYlE3FbUrgP5w8Fj7BH1Ka9FSlG9WP8Hb7odIhI3Hy6ddl3uKpTBMJkYkpmlAv61zRjtOinq9qOlepj9Mrr8u82y8fzD0DNYdi4uX1vTKdNbfq1Bc7pDMOPP/6IEIb7lbIrwrG1A8869rXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0227A68D0D; Wed,  4 Mar 2026 14:23:28 +0100 (CET)
Date: Wed, 4 Mar 2026 14:23:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-nvme@lists.infradead.org, Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/21] nvme-auth: use crypto library for HMAC and
 hashing
Message-ID: <20260304132327.GA15515@lst.de>
References: <20260302075959.338638-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302075959.338638-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Thanks, this looks really great:

Acked-by: Christoph Hellwig <hch@lst.de>

