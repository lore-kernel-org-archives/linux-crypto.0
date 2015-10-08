From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1 0/4] crypto: ccp - CCP driver updates 2015-10-01
Date: Thu, 8 Oct 2015 22:22:55 +0800
Message-ID: <20151008142255.GA25166@gondor.apana.org.au>
References: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58221 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbbJHOXB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 10:23:01 -0400
Content-Disposition: inline
In-Reply-To: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 01, 2015 at 04:32:25PM -0500, Tom Lendacky wrote:
> The following patches are included in this driver update series:
> 
> - Remove the usage of BUG_ON and replace with WARN_ON and an error
>   return code
> - Remove unused variable
> - Change references to accelerator to offload
> - Use the module name in the driver structure instead of a
>   descriptive name
>  
> This patch series is based on cryptodev-2.6.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
