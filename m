Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB133148B8;
	Thu, 18 Dec 2025 19:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766086402; cv=none; b=Iog1kzJeoOLoR3wogjg5cjSdWcECiGdnkrOU3vkFDJKGCp4a7VBzpCF3vuwKChS0u9fc/Hc9775gAYu/6puwZW3lKWu8Djw2+cfQkY/2oqGGApwqhf09azaafzNIxqXSZcBdC/hysQvG7p54DY4f1AKfnE3BVBXldUJmietKHfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766086402; c=relaxed/simple;
	bh=PV3IGjuZgVhRWhCp7SOdNijNKDv3qPkTIXy9uzMrU0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2u2m843APYik7hTe2lAZXpiIv0jXxu1BeBpmSIwXBWfySgiVbw3xnk64Z4Vv7Y2r/4u5UPYoN9hwcyaLnXOAHGzlPFec9HGxR2/thsHLB176C7HV1VGAonGPbYCrjEtmEHo6BE6JWIjCZuXI9Wx/TnUJSfreomM2qZc7MiWSUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=prHbla3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="prHbla3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBDAC4CEFB;
	Thu, 18 Dec 2025 19:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766086401;
	bh=PV3IGjuZgVhRWhCp7SOdNijNKDv3qPkTIXy9uzMrU0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=prHbla3KN+6YCAgf1s2o/A9KTI9Ek8JxR+XPxlXob5hEJNHssMHKcz/t2RsIRDD1E
	 OxE+fcwWLL1dyr7461bMmUyal992gywqqmE/bIXBV6kEXxWFwcdLLq/1TmxDjnOkyK
	 VywuSIDASk/ngS8wHcPMrQpvqUIa8tCcYiukTI8jPNHQH+dPOId3ScFz9hJ0I4tytU
	 DDrpD4xorLcb6uAhvci/Vp6nVM1Yl8HxhWNY+y+G22VCB4QyP8dMnLPT7RpnqaEDdO
	 K5qH3yG29l208FGcS7dUAKA05NPB++qtU2GwecR5QvuxhYCB6QEuhOVHPmU7dJN8uk
	 Z0XUpoQ7Uq4nA==
Date: Thu, 18 Dec 2025 11:33:12 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitor@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: use rol32 in md5.c
Message-ID: <20251218193312.GE21380@sol>
References: <20251214-rol32_in_md5-v1-1-20f5f11a92b2@kriptograf.id>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251214-rol32_in_md5-v1-1-20f5f11a92b2@kriptograf.id>

On Sun, Dec 14, 2025 at 06:15:12PM +0700, Rusydi H. Makarim wrote:
> use rol32 in MD5STEP
> 
> ---
> this patch replaces the bitwise left rotation in lib/crypto/md5.c
> with rol32
> 
> Signed-off-by: Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
> ---
>  lib/crypto/md5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

I cleaned up your commit message as follows:

commit 325c29e7d11caaf3b4f04f2c8f7d6bc4861cce5a
Author: Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
Date:   Sun Dec 14 18:15:12 2025 +0700

    lib/crypto: md5: Use rol32() instead of open-coding it

    For the bitwise left rotation in MD5STEP, use rol32() from
    <linux/bitops.h> instead of open-coding it.

    Signed-off-by: Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
    Link: https://lore.kernel.org/r/20251214-rol32_in_md5-v1-1-20f5f11a92b2@kriptograf.id
    Signed-off-by: Eric Biggers <ebiggers@kernel.org>

For future reference: please don't include a scissors line in the middle
of your commit message.  Everything below it gets cut off.

- Eric
