From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: crypto: crc32c-vpmsum - Convert to CPU feature based module autoloading
Date: Tue,  9 Aug 2016 21:26:35 +1000 (AEST)
Message-ID: <3s7sRv1923z9t1n@ozlabs.org>
References: <1470292695-9829-1-git-send-email-anton@ozlabs.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	alastair@d-silva.org
To: Anton Blanchard <anton@ozlabs.org>, benh@kernel.crashing.org,
	paulus@samba.org, herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:35596 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbcHIL0g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 07:26:36 -0400
In-Reply-To: <1470292695-9829-1-git-send-email-anton@ozlabs.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2016-04-08 at 06:38:15 UTC, Anton Blanchard wrote:
> From: Anton Blanchard <anton@samba.org>
> 
> This patch utilises the GENERIC_CPU_AUTOPROBE infrastructure
> to automatically load the crc32c-vpmsum module if the CPU supports
> it.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Applied to powerpc fixes, thanks.

https://git.kernel.org/powerpc/c/d2cf5be07ff7c7cde8bef8551a

cheers
