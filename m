From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Date: Fri, 3 Dec 2010 09:30:21 +0800
Message-ID: <20101203013021.GA304@gondor.apana.org.au>
References: <4CC9946D.mailLH511GU0C@intel.com> <20101104190405.GA2501@gondor.apana.org.au> <20101117172331.3bbec734.akpm@linux-foundation.org> <20101118092640.GA9486@gondor.apana.org.au> <24483BA4C9F69C43A7379639D35543D7C3450A84@irsmsx502.ger.corp.intel.com> <20101202161403.74daae6f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Struk, Tadeusz" <tadeusz.struk@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"O Mahony, Aidan" <aidan.o.mahony@intel.com>,
	"Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
	"Hoban, Adrian" <adrian.hoban@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:50869 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225Ab0LCBaY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Dec 2010 20:30:24 -0500
Content-Disposition: inline
In-Reply-To: <20101202161403.74daae6f.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 02, 2010 at 04:14:03PM -0800, Andrew Morton wrote:
>
> > > Tadeusz, could you please make an incremental patch that converts
> > > all the pshufb instructions to macros?
> > > 
> >
> > Will do.
> > Tadeusz
> > 
> 
> (top-posting repaired)
> 
> (busted attribution/quoting repaired)
> 
> Current mainline still has this failure.

Tadeusz, can you update us on your progress on this?

Andrew, I'll just back this out if it doesn't get resolved.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
