From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10 2/3] crypto: kpp - Add DH software implementation
Date: Wed, 22 Jun 2016 18:08:42 +0800
Message-ID: <20160622100842.GA30493@gondor.apana.org.au>
References: <1466541931-2875-1-git-send-email-salvatore.benedetto@intel.com>
 <1466541931-2875-3-git-send-email-salvatore.benedetto@intel.com>
 <20160622005115.GB27134@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D03193664C@IRSMSX102.ger.corp.intel.com>
 <20160622064047.GA29318@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D0319366BB@IRSMSX102.ger.corp.intel.com>
 <20160622100341.GA30383@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D0319367A3@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41697 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbcFVMel (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 08:34:41 -0400
Content-Disposition: inline
In-Reply-To: <309B30E91F5E2846B79BD9AA9711D0319367A3@IRSMSX102.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 10:06:32AM +0000, Benedetto, Salvatore wrote:
>
> It is pointless because it will only be used for the testmanager.
> I can merge the test functions but I'll still have two set_secret functions
> based on the alg value. Would that be enough for you?

I have made myself perfectly clear, I don't want to see anything
specific to DH or ECDH in testmgr.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
