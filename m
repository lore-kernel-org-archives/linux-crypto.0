From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: KEYS: convert public key to the akcipher
 api
Date: Tue, 22 Dec 2015 20:09:19 +0800
Message-ID: <20151222120919.GA25163@gondor.apana.org.au>
References: <201512200735.x3U85zQL%fengguang.wu@intel.com>
 <5678684F.2020308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <lkp@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>, kbuild-all@01.org,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Tadeusz Struk <tstruk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47397 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbbLVMJh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Dec 2015 07:09:37 -0500
Content-Disposition: inline
In-Reply-To: <5678684F.2020308@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 21, 2015 at 12:59:59PM -0800, Tadeusz Struk wrote:
> 
> The previous patch was broken, re-sending again, sorry.
> 
> I think there is something missing in this configuration.
> cat .config | grep KEXEC_BZIMAGE_VERIFY_SIG gives nothing.
> Anyways, this patch should fix it.

No this is unacceptable.  Please fix it properly by making the
header file self-contained, e.g., by using a forward declaration.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
