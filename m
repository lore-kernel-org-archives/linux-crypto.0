From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: vmx ghash buggy on ppc64le
Date: Tue, 19 Sep 2017 11:18:45 +0800
Message-ID: <20170919031845.GA28732@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33852 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdISDTD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Sep 2017 23:19:03 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I have received a report that ghash on ppc64le does not interoperate
with other implementations of ghash, e.g., on x86-64.

https://bugzilla.redhat.com/show_bug.cgi?id=1490972

Could you guys take a look at this and see if this is a bug in
the mainline vmx driver too?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
