Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182243C584F;
	Thu, 18 Jun 2026 09:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781774710; cv=none; b=U1ygWl9bOGubPQu5BFIBXiPAlSHcX2P7HCcDdB51aVzbl41vvArL2XUX8QrL7zDLRwP+tU80mJ6swhI6T9/SaeYMqoxPeZRQXKGjAIuk+Bu410i3Fn3xWqiz+vWLkU8nXe607kcm+XpTmSc9Ll0WDExOybOMTXYWHBgJmvTp3Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781774710; c=relaxed/simple;
	bh=K3h27conaKiYwvyytimbi/McmUT5F2vOuPKpaBqKafk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WMy33pHhAVYLFouu/g9qSrchOBeFEOx5E/dvrAq72RIx5oogc+FOTxvJV8abH7dzZTQhDuy3peazxe3/ghS0iombqYZ6XyZQgq4ARVWsTvxl5rjfyGSLuXjRWCck/0s4Qa1eBhUk74HqQrVaWBplhiN+lpfZ+blR5l/7uQ+dUpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B524668C7B; Thu, 18 Jun 2026 11:25:00 +0200 (CEST)
Date: Thu, 18 Jun 2026 11:25:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Laight <david.laight.linux@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH v3] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260618092500.GC17530@lst.de>
References: <20260615190338.26581-1-ebiggers@kernel.org> <20260617055653.GB19218@lst.de> <20260617110516.0a70950e@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617110516.0a70950e@pumpkin>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 17, 2026 at 11:05:16AM +0100, David Laight wrote:
> > FYI, one or 2 sources are basically useless as they RAID5 configs
> > that have no benefits over simple mirroring and thus the numbers
> > aren't too interesting.
> 
> With three disks you xor two buffers (src_count == 1) to get the parity
> to write to the third - so that is a valid RAID5 config.

Sure.  It did not say it is invalid, it just isn't very useful.

