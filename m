From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] Fixing vmx-crypto AES-CTR counter bug
Date: Tue, 18 Aug 2015 10:40:40 +0800
Message-ID: <20150818024040.GC4957@gondor.apana.org.au>
References: <20150814131218.GA11746@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Paulo Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>
To: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44459 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbbHRCkn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 22:40:43 -0400
Content-Disposition: inline
In-Reply-To: <20150814131218.GA11746@bluepex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 14, 2015 at 10:12:22AM -0300, Leonidas S Barbosa wrote:
> AES-CTR is using a counter 8bytes-8bytes what miss match with
> kernel specs.
> 
> In the previous code a vadduwm was done to increment counter.
> Replacing this for a vadduqm now considering both cases counter
> 8-8 bytes and full 16bytes.
> 
> Signed-off-by: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>

Both fixes applied but I'll push them after the merge window opens
as they don't seem to be critical.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
