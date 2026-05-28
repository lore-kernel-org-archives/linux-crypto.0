Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CD633987F;
	Thu, 28 May 2026 20:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000513; cv=none; b=jWlkra0rdnYQhR8HcpwQzhaegCJ4jCOMDxJ8FH+ZMUtYyH1MbcWaqcEvSuU64fnqYpSW0G7nD+KkfvpKP/+qlKGDRp39kzrkwL+somh+hAk1NQy2J0X7GfWykJRggg5lwfrNP7EpBxq4BQZSeXiuyRvizlg1h6Ja/iHNz4AN3As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000513; c=relaxed/simple;
	bh=1KQzjBdrrF6STM12dgWmPZt8niC6mNyssox/d2oLr5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C0yhkaaSrL0w7gUW6Y9QJNBDFl0vXy4nmyAjQBpq420/YYB8wkjdDYOF9F+JJUVy43Yygj0qvGdg3f0x2xaxkGjyLIXtF0TG0XXs8Kr2+LAXdQ6W+epghRclqdZOd4T8lJLe2Vgzg/5G1BT49C/AqGDgQ9bJEifgfG7yztkHgzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jxckgX6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jxckgX6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345F61F00A3A;
	Thu, 28 May 2026 20:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780000510;
	bh=HdR59bdOLxfad3MlDdWkNtt/Xj++SWYyaF4AAiiPNOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jxckgX6IuzS/15UM3yoi8wUw31sv5pTRwPf89lOLv7YAmOWqO7Y6l4UUIXYmD26Bi
	 5/D1Y5q8jASex0Bx+2bPrFvEO53T8Kf2a8FL7UTTAEXU/dlplF21UzqJZrOrPLNIzf
	 3BEty7OmJMnTZLQ20t6N9v8jZJfzG+uWtUVtXmD+50ggMTe7kaV62YEH1ybmMWBExd
	 Qiw3LWsak9AEq6XkDxz6IuIW65bCqlwjc0WPYGFf9+KszGLwP3DWNpO3zR8JuwUmDR
	 YjxEkcT90DeMfcbTYGYv6tXtfQWO9XnAGFkuQNiRoIdOqgLg6l6HIsengSTBj/6A/q
	 I7ZAXSyOuswtA==
Date: Thu, 28 May 2026 13:35:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/8] ARM crc64 and XOR using NEON intrinsics
Message-ID: <20260528203508.GA2054@quark>
References: <20260422171655.3437334-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422171655.3437334-10-ardb+git@google.com>

On Wed, Apr 22, 2026 at 07:16:56PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> This is a follow-up to both [0] and [1], both of which included patch #1
> of this series, which introduces the asm/neon-intrinsics.h header on
> 32-bit ARM. The remaining changes rely on this.
> 
> The purpose of this series is to streamline / clean up the use of NEON
> intrinsics on 32-bit ARM, by sharing more code, clean up Make rules and
> finally, getting rid of the hacked up types.h header, which does some
> nasty things that are only needed when building NEON intrinsics code.
> 
> Patches #2 and #3 replace the ARM autovectorized XOR implementation with
> the NEON intrinsics version used by arm64.
> 
> Patches #4 and #5 enable the arm64 NEON intrinsics implementation of
> crc64 on 32-bit ARM.
> 
> Patches #6 and #7 drop the direct includes of <arm_neon.h> and perform
> some additional cleanup to reduce the delta between ARM and arm64 code
> and Make rules.
> 
> It would probably be easiest to take all these changes through a single
> tree, and the CRC tree seems like a suitable candidate, if Eric agrees.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Eric Biggers <ebiggers@kernel.org>
> 
> [0] https://lore.kernel.org/all/20260331074940.55502-7-ardb+git@google.com/
> [1] https://lore.kernel.org/all/20260330144630.33026-7-ardb@kernel.org/
> 
> Ard Biesheuvel (8):
>   ARM: Add a neon-intrinsics.h header like on arm64
>   xor/arm: Replace vectorized implementation with arm64's intrinsics
>   xor/arm64: Use shared NEON intrinsics implementation from 32-bit ARM
>   lib/crc: Turn NEON intrinsics crc64 implementation into common code
>   lib/crc: arm: Enable arm64's NEON intrinsics implementation of crc64
>   crypto: aegis128 - Use neon-intrinsics.h on ARM too
>   lib/raid6: Include asm/neon-intrinsics.h rather than arm_neon.h
>   ARM: Remove hacked-up asm/types.h header

Applied patches 1-6 to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
