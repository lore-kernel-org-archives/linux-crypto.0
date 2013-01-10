From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4] crypto api: add crc32 pclmulqdq implementation and
 wrappers for table implementation
Date: Thu, 10 Jan 2013 13:57:46 -0800
Message-ID: <1357855066.17632.141.camel@schen9-DESK>
References: <50EED427.2040309@xyratex.com>  <50EED643.2010907@xyratex.com>
	 <1357840496.17632.119.camel@schen9-DESK>  <50EF15E0.5060204@xyratex.com>
	 <1357848481.17632.140.camel@schen9-DESK>  <50EF23FB.2090808@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Dilger <adilger@whamcloud.com>
To: Alexander Boyko <alexander_boyko@xyratex.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31758 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3AJV5r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2013 16:57:47 -0500
In-Reply-To: <50EF23FB.2090808@xyratex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2013-01-11 at 00:26 +0400, Alexander Boyko wrote:

> >
> Sorry, may be I was miss understood, but I am trying to add CRC32
> pclmul, not CRC32C. They use different polynomial.

Ah, I missed that.  Thanks for clarifying.

Tim
