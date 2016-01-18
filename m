From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [V3] crypto: qat - fix timeout issues
Date: Mon, 18 Jan 2016 23:22:43 +0800
Message-ID: <20160118152242.GB717@gondor.apana.org.au>
References: <1452130786-147187-1-git-send-email-pingchao.yang@intel.com>
 <56993A6D.4060901@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pingchao Yang <pingchao.yang@intel.com>,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59340 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbcARPWp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 10:22:45 -0500
Content-Disposition: inline
In-Reply-To: <56993A6D.4060901@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 15, 2016 at 10:29:01AM -0800, Tadeusz Struk wrote:
> On 01/06/2016 05:39 PM, Pingchao Yang wrote:
> > Change the variable times data type and timeout conditon since the value
> > of times should be -1 after loop.
> > 
> > Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
