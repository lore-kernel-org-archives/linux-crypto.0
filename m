From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/1] crypto: AES CTR x86_64 "by8" AVX optimization
Date: Sat, 21 Jun 2014 02:43:22 +0800
Message-ID: <20140620184321.GL3169@gondor.apana.org.au>
References: <1402417367.2363.10.camel@pegasus.jf.intel.com>
 <CA+rthh93UmeCE5CCTJ+_9EKxThShdyW7wCJMECYQ3X9NE1pv8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chandramouli narayanan <mouli@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	James Guilford <james.guilford@intel.com>,
	"Tadeusz Struk,Huang Ying" <ying.huang@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58684 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965975AbaFTSoO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Jun 2014 14:44:14 -0400
Content-Disposition: inline
In-Reply-To: <CA+rthh93UmeCE5CCTJ+_9EKxThShdyW7wCJMECYQ3X9NE1pv8Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 10, 2014 at 10:34:47PM +0200, Mathias Krause wrote:
> On 10 June 2014 18:22, chandramouli narayanan <mouli@linux.intel.com> wrote:
>
> Patch is
> Reviewed-by: Mathias Krause <minipli@googlemail.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
