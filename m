Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD5F31E85D;
	Fri, 27 Mar 2026 13:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774619457; cv=none; b=ozxwRq1Fx7EJ8DVOlEAhPicBqjkKOzPJYO/Xx/rw+Qmpd+9Qrda5LdMwbFwnlsKsXl6m0wvH2blw/looo+6RdnobqKSWkf0NW+72tdMQ/e5Qlv8NIFQV0thlkYqDghdZgSeCD6FtYFFCyoqrk14Qq+rv4QzHtHmcNWVG5wjOjFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774619457; c=relaxed/simple;
	bh=VFsqS7IjLQM0GDy8DuWqNRCp4A8E/CjZs/kHmojkyJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vnq5tM02lN6JJkq5eHxrZxTdIbEvewVSCebo4JDQAZf1sbx1WqjYSb4XEWJJoU6SBq+zCGybg/CdAvOgXA2MNWiV7z3332VIi45NpQcGwx8jjPeG137HZauWCTItwaUNd4uvVTNIHX5SemydbMs8YewF+CQHTajcQIUK6pcDKfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 638E468B05; Fri, 27 Mar 2026 14:50:51 +0100 (CET)
Date: Fri, 27 Mar 2026 14:50:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-raid@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 4/5] xor/arm64: Use shared NEON intrinsics
 implementation from 32-bit ARM
Message-ID: <20260327135051.GA739@lst.de>
References: <20260327113047.4043492-7-ardb+git@google.com> <20260327113047.4043492-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327113047.4043492-11-ardb+git@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 27, 2026 at 12:30:52PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Tweak the arm64 code so that the pure NEON intrinsics implementation of
> XOR is shared between arm64 and ARM.

Instead of hiding the implementation in a header, just split xor-neon.c
into two .c files, one of which could be built by arm32 as well, probably
in the arm/ instead of the arm64/ subdirectory, but we can also add a
new arm-common one if that's what the arm maintainers prefer.

