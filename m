From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3 v2] Optimize CRC32C calculation with PCLMULQDQ
 instruction
Date: Wed, 27 Feb 2013 10:02:23 +0800
Message-ID: <20130227020223.GA26188@gondor.apana.org.au>
References: <cover.1348784343.git.tim.c.chen@linux.intel.com>
 <1348785862.17632.17.camel@schen9-DESK>
 <20130226095424.GA19924@gondor.apana.org.au>
 <1361897861.17632.222.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Chaohong Guo <chaohong.guo@intel.com>,
	Austin Zhang <austin_zhang@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Min Li <min.a.li@intel.com>,
	David Cote <david.m.cote@intel.com>,
	Fengguang Wu <fengguang.wu@intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:51975 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756859Ab3B0CCc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Feb 2013 21:02:32 -0500
Content-Disposition: inline
In-Reply-To: <1361897861.17632.222.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 26, 2013 at 08:57:41AM -0800, Tim Chen wrote:
>
> BTW, Herbert, I've also sent you a patch a few days ago to update the
> link to the whitepaper on the CRC32C algorithm in the code.  Wonder if
> you have received it.  Thanks.

Tim it's in my queue.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
