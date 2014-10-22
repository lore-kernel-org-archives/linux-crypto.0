From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64/crypto: use crypto instructions for generating AES
 key schedule
Date: Wed, 22 Oct 2014 17:25:49 +0100
Message-ID: <20141022162548.GH15370@e104818-lin.cambridge.arm.com>
References: <1413962132-19882-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	Will Deacon <Will.Deacon@arm.com>,
	"jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>,
	Andrew Wafaa <Andrew.Wafaa@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:47202 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaJVQ0A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Oct 2014 12:26:00 -0400
Content-Disposition: inline
In-Reply-To: <1413962132-19882-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 22, 2014 at 08:15:32AM +0100, Ard Biesheuvel wrote:
> This patch implements the AES key schedule generation using ARMv8
> Crypto Instructions. It replaces the table based C implementation
> in aes_generic.ko, which means we can drop the dependency on that
> module.

I don't really understand the AES stuff but there's something else I
noticed: if you build a kernel with the crypto stuff and run it on an
implementation that does not have the crypto extensions, there does not
seem to be any check for not using these algorithms (or falling back to
the generic implementation). Does the kernel end up with undef faults?

-- 
Catalin
