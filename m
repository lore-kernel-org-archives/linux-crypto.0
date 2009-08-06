From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -v2 4/5] x86: Move kernel_fpu_using to irq_is_fpu_using
	in asm/i387.h
Date: Thu, 6 Aug 2009 17:16:47 +1000
Message-ID: <20090806071647.GA25065@gondor.apana.org.au>
References: <1249285531-22422-1-git-send-email-ying.huang@intel.com> <1249285531-22422-2-git-send-email-ying.huang@intel.com> <1249285531-22422-3-git-send-email-ying.huang@intel.com> <1249285531-22422-4-git-send-email-ying.huang@intel.com> <20090806053719.GD23557@gondor.apana.org.au> <4A7A77B6.9050306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59301 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752219AbZHFHQw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2009 03:16:52 -0400
Content-Disposition: inline
In-Reply-To: <4A7A77B6.9050306@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 05, 2009 at 11:27:02PM -0700, H. Peter Anvin wrote:
> Herbert Xu wrote:
>>
>> Peter, do you want to apply this patch in your tree or would
>> you prefer for it to go through my tree along with the rest of
>> the series?
>>
>
> I'll take it tomorrow... want to double-check that we don't have any  
> real issues w.r.t. corruption there.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
