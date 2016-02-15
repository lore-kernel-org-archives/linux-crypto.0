From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm/arm64/crypto: assure that ECB modes don't require an
 IV
Date: Mon, 15 Feb 2016 15:51:09 +0000
Message-ID: <20160215155108.GG6298@arm.com>
References: <1455292072-5236-1-git-send-email-jeremy.linton@arm.com>
 <CAKv+Gu8_Z5=0dTeBsVgx_BT0c+_O5PNUCyKFjuDf9x470bxHOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Linton <jeremy.linton@arm.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:46078 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbcBOPvE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Feb 2016 10:51:04 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8_Z5=0dTeBsVgx_BT0c+_O5PNUCyKFjuDf9x470bxHOA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 12, 2016 at 06:00:01PM +0100, Ard Biesheuvel wrote:
> On 12 February 2016 at 16:47, Jeremy Linton <jeremy.linton@arm.com> wrote:
> > ECB modes don't use an initialization vector. The kernel
> > /proc/crypto interface doesn't reflect this properly.
> >
> > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> 
> Thanks for spotting that!
> 
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks, I'll queue this for -rc5.

Will
