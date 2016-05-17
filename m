From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/sha1-mb: make sha1_x8_avx2() conform to C
 function ABI
Date: Tue, 17 May 2016 14:31:48 +0800
Message-ID: <20160517063148.GA10389@gondor.apana.org.au>
References: <1463095866.2594.8.camel@megha-Z97X-UD7-TH>
 <20160513031020.GA12467@gondor.apana.org.au>
 <20160513055103.GB24504@gmail.com>
 <1463160746.2594.11.camel@megha-Z97X-UD7-TH>
 <20160516144409.dkzqrpd3nlb36ygq@treble>
 <1463423472.5329.6.camel@megha-Z97X-UD7-TH>
 <20160516201618.u4zethkab3ohgtfb@treble>
 <1463434746.2538.1.camel@megha-Z97X-UD7-TH>
 <20160516214631.5cvnfgvppw74acah@treble>
 <1463440073.2547.1.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
	Ingo Molnar <mingo@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36927 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbcEQGc3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 May 2016 02:32:29 -0400
Content-Disposition: inline
In-Reply-To: <1463440073.2547.1.camel@megha-Z97X-UD7-TH>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 16, 2016 at 04:07:53PM -0700, Megha Dey wrote:
>
> ok. I tried at my end too using some printk's and nothing seems to be
> broken. Also, if you intend to use the same commit message, I spell my
> name as Megha Dey and not Day :)

Patch applied with the name corrected.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
