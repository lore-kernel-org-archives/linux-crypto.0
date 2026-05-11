Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965313BD63C;
	Mon, 11 May 2026 12:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778502494; cv=none; b=jP67WoAB/Ly37cZdsodKRGD9gbzNTF+kivGoXaq+MrJt4csy0rXp46FezxiBnuwHxPcbGmc1iP2nWJOIESbGUvil7t7kN79J25Bq0LJ+HqkA7rztvc0lwze3boOUeQgjaXu2pnyDVBrZ8Po7x2gaPOikBOYXQjjk50q7bzk8WBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778502494; c=relaxed/simple;
	bh=SRVG4Ckd3FP8SzTTUs7RcSrFIq/Z3+Y1Hkdq4HAX4Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qkqQkySdnllRsoaX1ukuoR/zVlgcjdyD0/ZA+GEUo++0y6x+awmW6VdjNmZM47msCdS9fYhh8rgJQOHENcMw/GUAkPZuPgRoSYIN38I5ye2S5FNZU9hwTMNDR2Z6gVDNtG25nC6S1g41rDyymP+yRhRDvLmnTQVxwp5SXpXBAHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B9E1B6732A; Mon, 11 May 2026 14:28:09 +0200 (CEST)
Date: Mon, 11 May 2026 14:28:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 7/8] lib/raid6: Include asm/neon-intrinsics.h rather
 than arm_neon.h
Message-ID: <20260511122809.GB16499@lst.de>
References: <20260422171655.3437334-10-ardb+git@google.com> <20260422171655.3437334-17-ardb+git@google.com> <20260423074712.GC31018@lst.de> <20260509202354.GD11883@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260509202354.GD11883@quark>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, May 09, 2026 at 01:23:54PM -0700, Eric Biggers wrote:
> I think this patch also breaks the userspace build of lib/raid6/.  Which
> is going away in Christoph's series anyway,

Assuming we're overcoming the objections.  Anyway, about to repost this,
and maybe Art is another voice for dropping the userspace build support
of the RAID code.

