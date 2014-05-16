From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 09/11] arm64/crypto: add voluntary preemption to
 Crypto Extensions SHA1
Date: Fri, 16 May 2014 09:57:48 +0100
Message-ID: <20140516085748.GD5624@arm.com>
References: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
 <1400091451-9117-10-git-send-email-ard.biesheuvel@linaro.org>
 <20140515172458.GE1499@arm.com>
 <CAKv+Gu-9P+vDPnvr2Cz4Bcw5=5SuEMw-xFxLM4=SoF65ESvhcQ@mail.gmail.com>
 <E28B9BA9-468D-45BD-A479-5D9289616798@arm.com>
 <CAKv+Gu_Tupu8jJX+6hRx_LOM0y05A5+MPXndzSKRNYQcG-yAvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41448 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755619AbaEPI63 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 May 2014 04:58:29 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_Tupu8jJX+6hRx_LOM0y05A5+MPXndzSKRNYQcG-yAvw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 15, 2014 at 11:10:20PM +0100, Ard Biesheuvel wrote:
> On 15 May 2014 14:47, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > For the time being I would drop the last 4 patches. We can revisit them
> > for the next kernel version.
> 
> Agreed.
> 
> Should I send an updated pull request?

As it's not a signed tag anyway, I can merge up to the relevant commit.

-- 
Catalin
