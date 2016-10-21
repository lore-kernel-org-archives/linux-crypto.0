From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v9 1/8] crypto: add asynchronous compression api
Date: Fri, 21 Oct 2016 10:55:18 +0800
Message-ID: <20161021025518.GA22979@gondor.apana.org.au>
References: <1475144342-1157-1-git-send-email-giovanni.cabiddu@intel.com>
 <1475144342-1157-2-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58563 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753532AbcJUCzY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 22:55:24 -0400
Content-Disposition: inline
In-Reply-To: <1475144342-1157-2-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 29, 2016 at 11:18:55AM +0100, Giovanni Cabiddu wrote:
>
> +	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
> +		    sizeof(struct crypto_report_comp), &racomp))
> +		goto nla_put_failure;

This bit doesn't compile for me.  Please fix up and resubmit.

../crypto/crypto_user.c: In function ‘crypto_report_acomp’:
../crypto/crypto_user.c:117:29: error: storage size of ‘racomp’ isn’t known
../crypto/crypto_user.c:121:19: error: ‘CRYPTOCFGA_REPORT_ACOMPRESS’ undeclared (first use in this function)
../crypto/crypto_user.c:121:19: note: each undeclared identifier is reported only once for each function it appears in
../crypto/crypto_user.c:122:14: error: invalid application of ‘sizeof’ to incomplete type ‘struct crypto_report_acomp’
../crypto/crypto_user.c:117:29: warning: unused variable ‘racomp’ [-Wunused-variable]

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
