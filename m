From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/2] Fix out-of-bounds memory accesses in
 generic-gcm-aesni
Date: Thu, 28 Dec 2017 18:08:59 +1100
Message-ID: <20171228070859.GA9960@gondor.apana.org.au>
References: <20171221010838.54243-1-junaids@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com, ebiggers3@gmail.com
To: Junaid Shahid <junaids@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:49020 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750981AbdL1HJC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Dec 2017 02:09:02 -0500
Content-Disposition: inline
In-Reply-To: <20171221010838.54243-1-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 05:08:36PM -0800, Junaid Shahid wrote:
> Changelog:
> v3:
> - Fixed a bug in READ_PARTIAL_BLOCK when used for reading the AAD
> - Some refactoring per CR feedback

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
