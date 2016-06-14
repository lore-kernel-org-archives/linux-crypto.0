From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto : async implementation for sha1-mb
Date: Tue, 14 Jun 2016 12:34:10 +0800
Message-ID: <20160614043410.GA18257@gondor.apana.org.au>
References: <1465323282-2235-1-git-send-email-megha.dey@intel.com>
 <20160613082202.GA7148@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE703CABA2C@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	Megha Dey <megha.dey@linux.intel.com>
To: "Dey, Megha" <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48326 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbcFNEei (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 00:34:38 -0400
Content-Disposition: inline
In-Reply-To: <C440BA31B54DCD4AAC682D2365C8FEE703CABA2C@ORSMSX111.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 13, 2016 at 07:10:26PM +0000, Dey, Megha wrote:
>
> > In the current implementation, the inner algorithm is called directly, and we use the outer algorithm's callback. We do not use the callback in inner algorithm. We are actually calling the child functions directly and the child is using the parent's call back function. Probably I can add a comment before the set callback function.. will this be ok?

No this is a hack and you should not do that.

You can of course set the inner request's callback to that of the outer request.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
