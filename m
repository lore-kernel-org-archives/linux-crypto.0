From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v2 4/5] x86: Move kernel_fpu_using to irq_is_fpu_using
 in asm/i387.h
Date: Wed, 05 Aug 2009 23:27:02 -0700
Message-ID: <4A7A77B6.9050306@zytor.com>
References: <1249285531-22422-1-git-send-email-ying.huang@intel.com> <1249285531-22422-2-git-send-email-ying.huang@intel.com> <1249285531-22422-3-git-send-email-ying.huang@intel.com> <1249285531-22422-4-git-send-email-ying.huang@intel.com> <20090806053719.GD23557@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:33848 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZHFG1H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2009 02:27:07 -0400
In-Reply-To: <20090806053719.GD23557@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> 
> Peter, do you want to apply this patch in your tree or would
> you prefer for it to go through my tree along with the rest of
> the series?
> 

I'll take it tomorrow... want to double-check that we don't have any 
real issues w.r.t. corruption there.

	-hpa
