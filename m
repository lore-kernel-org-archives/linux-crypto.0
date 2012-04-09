From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto, xor: Sanitize checksumming function selection
	output
Date: Mon, 9 Apr 2012 15:21:59 +0800
Message-ID: <20120409072158.GB30875@gondor.apana.org.au>
References: <1333544770-21303-1-git-send-email-bp@amd64.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Borislav Petkov <borislav.petkov@amd.com>
To: Borislav Petkov <bp@amd64.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:44200 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754573Ab2DIHWW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Apr 2012 03:22:22 -0400
Content-Disposition: inline
In-Reply-To: <1333544770-21303-1-git-send-email-bp@amd64.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 04, 2012 at 03:06:10PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Currently, it says
> 
> [    1.015541] xor: automatically using best checksumming function: generic_sse
> [    1.040769]    generic_sse:  6679.000 MB/sec
> [    1.045377] xor: using function: generic_sse (6679.000 MB/sec)
> 
> and repeats the function name three times unnecessarily. Change it into
> 
> [    1.015115] xor: automatically using best checksumming function:
> [    1.040794]    generic_sse:  6680.000 MB/sec
> 
> and save us a line in dmesg.
> 
> No functional change.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
