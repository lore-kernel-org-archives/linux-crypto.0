From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: crypto: qat - Ensure ipad and opad are zeroed
Date: Tue, 13 Jan 2015 15:20:51 -0800
Message-ID: <54B5A853.3030304@intel.com>
References: <20150113202753.32216.26250.stgit@tstruk-mobl1> <20150113212515.GA11562@gondor.apana.org.au> <54B59A86.10803@intel.com> <20150113224756.GA12432@gondor.apana.org.au> <54B5A25C.9070007@intel.com> <20150113230703.GA12608@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:49405 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbAMXYM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 18:24:12 -0500
In-Reply-To: <20150113230703.GA12608@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/13/2015 03:07 PM, Herbert Xu wrote:
> The patch ad511e260a27b8e35d273cc0ecfe5a8ff9543181 (crypto: qat -
> Fix incorrect uses of memzero_explicit) broke hashing because the
> code was in fact overwriting the qat_auth_state variable.
> 
> In fact there is no reason for the variable to exist anyway since
> all we are using it for is to store ipad and opad.  So we could
> simply create ipad and opad directly and avoid this whole mess.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Ok that looks better. Thanks. I think we should also remove the
definition of struct qat_auth_state in line 107 and the #def above.
Regards,
Tadeusz
