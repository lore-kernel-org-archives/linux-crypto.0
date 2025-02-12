Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8A71FF7D7;
	Wed, 12 Feb 2025 20:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739391024; cv=none; b=SIee9Nb4DY9JIMrhNe2gqjoD7B2URn1NH60AyJQrULqdiJDH3eVIxPdwMwRY7n8oaVpw23tWSYFh8QdzRq/4+HMqX+mvSNePARHqeIc/49YIp3FdK1Q9WQn0xX7V447aBBXBxV+Xcd/0VAZWSg4TVlA2lirIZp0hOGgrRXml0K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739391024; c=relaxed/simple;
	bh=MnKhK0zOJBzcyNRgjiIUC2lRoRSPV9C2Ro3ePenE6bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QdpOYYEe5E9R3b4hJcjbL3oESTObo0+b/PYPSUT4d9qgZ7WI6Zq9qgUW3G7ll3kVAXu/OBdKedtgswPKbGXc87zu+FMefN+sdvrZ6X8Ym2oDtk8cEoUcszfI5s8/4Y0MuJOImzxsa/gyagmi59JdjYqtDUwwBpJMGlgeFxhmdbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkdxz7t/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkdxz7t/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0038AC4CEDF;
	Wed, 12 Feb 2025 20:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739391024;
	bh=MnKhK0zOJBzcyNRgjiIUC2lRoRSPV9C2Ro3ePenE6bk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mkdxz7t/rLARM5ml+gzAnpeA3F/KcTQ2v9DqvEEdbHyf72+3F6QaGzDtjo+Uxg/px
	 WGL4Rq+XIAhOJXJg+J3pD6BGhPlP40EDpiWpLe+0XXrDfxQOGW+2yXrXzqkGK6blhn
	 vG4/7sKVlOMo+1uTmM4pd8snhgt9lXmiBQG6W9+MIgFMtppikqxJOmAp/+3FLYFBzm
	 mCvFsmWBqvqCM2oxfnNYyymaCkvrcACrTfzFc9a7/T5y5HfqtAFvlR/shNPx/g5219
	 3+wcDwGV5xLSQkPdh3NF0zDCtvrU1naDMKPCc5ItvCPMvWWsJTHw8jNgSDaxNf7Y48
	 /LUdELGo1ageQ==
Date: Wed, 12 Feb 2025 12:10:22 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	x86@kernel.org
Subject: Re: [PATCH] x86/crc32: improve crc32c_arch() code generation with
 clang
Message-ID: <20250212201022.GB128826@sol.localdomain>
References: <20250210210741.471725-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210210741.471725-1-ebiggers@kernel.org>

On Mon, Feb 10, 2025 at 01:07:41PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> crc32c_arch() is affected by
> https://github.com/llvm/llvm-project/issues/20571 where clang
> unnecessarily spills the inputs to "rm"-constrained operands to the
> stack.  Replace "rm" with ASM_INPUT_RM which partially works around this
> by expanding to "r" when the compiler is clang.  This results in better
> code generation with clang, though still not optimal.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This applies to
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

Applied to crc-next.

- Eric
