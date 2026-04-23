Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07A42FA0C7;
	Thu, 23 Apr 2026 07:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776930437; cv=none; b=chfvul9PLVRvMTnYO9h/g7SqVhLnfYTF5nfQTrnKJK5Qfkbm8RrrphEhRsO8ZpYLVD9CY9jiKVP2Jy3iH7Q4F/iL+JRbtOfjNxA2TKb3890jP/xVosTg9rH1TDkEEYiUem3OpKxpOiEEsasy95gpf9uI7AxU80TFNshZUzmHaZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776930437; c=relaxed/simple;
	bh=8Dx2M4XQZwmCexx9suRjFy3b/yBsVT6IZaWN/B+cTIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlehND2DdxLSFWfZvK6aMdNvaHIaGAEZrNIweSvHZ1V63vLu1yCqYvjy8NohywkQZ7kqmO/4nNR1PoOdQWOuQz0IlwdpagvU6oJs+TKKhbdfWhiWYIq4hQsWO4C8usK8o2YuCQgYVSzPa4wCAgwnLuQpQlzNkPp9YEPyHmUjDwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BAEA568D05; Thu, 23 Apr 2026 09:47:12 +0200 (CEST)
Date: Thu, 23 Apr 2026 09:47:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 7/8] lib/raid6: Include asm/neon-intrinsics.h rather
 than arm_neon.h
Message-ID: <20260423074712.GC31018@lst.de>
References: <20260422171655.3437334-10-ardb+git@google.com> <20260422171655.3437334-17-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422171655.3437334-17-ardb+git@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 22, 2026 at 07:17:03PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> arm_neon.h is a compiler header which needs some scaffolding to work
> correctly in the linux context, and so it is better not to include it
> directly. Both ARM and arm64 now provide asm/neon-intrinsics.h which
> takes care of this.


This could potentially clash with the raid6 library rework I'm doing
for 7.2. Although git has become pretty good about renamed files, so
maybe it won't be so bad.

