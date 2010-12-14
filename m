From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Date: Tue, 14 Dec 2010 10:21:51 +0800
Message-ID: <20101214022150.GA11023@gondor.apana.org.au>
References: <4CC9946D.mailLH511GU0C@intel.com> <20101104190405.GA2501@gondor.apana.org.au> <20101117172331.3bbec734.akpm@linux-foundation.org> <20101118092640.GA9486@gondor.apana.org.au> <24483BA4C9F69C43A7379639D35543D7C3450A84@irsmsx502.ger.corp.intel.com> <20101202161403.74daae6f.akpm@linux-foundation.org> <20101203013021.GA304@gondor.apana.org.au>
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
Received: from helcar.apana.org.au ([209.40.204.226]:48774 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759125Ab0LNCVy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Dec 2010 21:21:54 -0500
Content-Disposition: inline
In-Reply-To: <20101203013021.GA304@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 03, 2010 at 09:30:21AM +0800, Herbert Xu wrote:
>
> Andrew, I'll just back this out if it doesn't get resolved.

Andrew, the problem should be resolved in the current cryptodev
tree.  Please let me know if it still blows up for you.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
