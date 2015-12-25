From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - use to_pci_dev and to_platform_device
Date: Fri, 25 Dec 2015 21:46:15 +0800
Message-ID: <20151225134615.GC16174@gondor.apana.org.au>
References: <3a86c7e2921be1783aaab4dfbb3f4021a0e2f8d4.1450874840.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45215 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbbLYNq3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Dec 2015 08:46:29 -0500
Content-Disposition: inline
In-Reply-To: <3a86c7e2921be1783aaab4dfbb3f4021a0e2f8d4.1450874840.git.geliangtang@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 23, 2015 at 08:49:01PM +0800, Geliang Tang wrote:
> Use to_pci_dev() and to_platform_device() instead of open-coding.
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
