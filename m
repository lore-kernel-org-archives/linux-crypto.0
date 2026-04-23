Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481E523C4FF;
	Thu, 23 Apr 2026 07:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776930263; cv=none; b=a6D4ezyVnUk/IlKM8cDoxE8iqWdHBzaeJOQkWl+IVY/k9TVVTffoNMtz17Etw0h3pbiRpT/W/Vu3f1ajo1+8Jq8SABFXIDAhSs/ZL5Ff0ZlE5Awl7y/aLPvGdmpu8yYlmXvXc0Poqb3ymoOn0wCn/x5cd4D7KqK/5hoLA8NfcYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776930263; c=relaxed/simple;
	bh=ManUlrjOATanCNBLil3mYiOJaQsx0qPFa33vxr+zbfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cC93Yox0nynGYpXQc//2Pk+z56K03CVuFt9UIFXxzWhu3miHnkeizEdPHue9guFC+9jDrzQFZz/2ZfkF+BafebDa8gjr+BMuVgRLtnX0Bazm05Fx6jQ0x4+kan72aFOOHjxSCIzucN4o+ivoZ4Khoilf7/C1joAu5/9g7+gHT4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B599E68C4E; Thu, 23 Apr 2026 09:44:11 +0200 (CEST)
Date: Thu, 23 Apr 2026 09:44:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 2/8] xor/arm: Replace vectorized implementation with
 arm64's intrinsics
Message-ID: <20260423074411.GA31018@lst.de>
References: <20260422171655.3437334-10-ardb+git@google.com> <20260422171655.3437334-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422171655.3437334-12-ardb+git@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Nice!

Acked-by: Christoph Hellwig <hch@lst.de>

