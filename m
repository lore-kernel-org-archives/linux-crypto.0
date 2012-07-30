From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] crypto: add x86_64/avx assembler implementation of
 cast5 and cast6
Date: Mon, 30 Jul 2012 15:55:25 +0800
Message-ID: <20120730075525.GC5515@gondor.apana.org.au>
References: <cover.1342027375.git.johannes@goetzfried-amberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo Mueller <tilo.mueller@informatik.uni-erlangen.de>
To: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:41251 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752297Ab2G3Hz3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jul 2012 03:55:29 -0400
Content-Disposition: inline
In-Reply-To: <cover.1342027375.git.johannes@goetzfried-amberg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 11, 2012 at 07:36:46PM +0200, Johannes Goetzfried wrote:
> This patchset adds x86_64/avx assembler implementations of the Cast5 and the
> Cast6 cipher.
> 
> Johannes Goetzfried (6):
>   crypto: cast5 - prepare generic module for optimized implementations
>   crypto: testmgr - add larger cast5 testvectors
>   crypto: cast5 - add x86_64/avx assembler implementation
>   crypto: cast6 - prepare generic module for optimized implementations
>   crypto: testmgr - add larger cast6 testvectors
>   crypto: cast6 - add x86_64/avx assembler implementation

Nice work.  All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
