From: Stephan Mueller <smueller@chronox.de>
Subject: Re: testmgr: templates not tested
Date: Thu, 03 Sep 2015 12:21:37 +0200
Message-ID: <1503977.HnUv4rvHWj@myon.chronox.de>
References: <2425525.lUG5gvxoc6@myon.chronox.de> <20150903074539.GA28992@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33778 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbbICKVn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Sep 2015 06:21:43 -0400
In-Reply-To: <20150903074539.GA28992@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 3. September 2015, 15:45:39 schrieb Herbert Xu:

Hi Herbert,

> It's the same bug as gcm.  cbc should use the underlying cra_name
> in its cra_name.

I see. But then it seems to be a pervasive bug as xts suffers from the same 
issue too.

Would you please be so kind and give me a hint what exactly would need to be 
done with the cra_name? I continued working on the keywrap template and have 
it now complete. The only lingering issue is the testmgr where the test for 
keywrap is not invoked.

-- 
Ciao
Stephan
