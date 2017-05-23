From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/4] crypto: async crypto op fixes
Date: Tue, 23 May 2017 13:03:05 +0800
Message-ID: <20170523050305.GE17569@gondor.apana.org.au>
References: <1495114167-3073-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:48006 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758115AbdEWFDh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 01:03:37 -0400
Content-Disposition: inline
In-Reply-To: <1495114167-3073-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 18, 2017 at 04:29:22PM +0300, Gilad Ben-Yossef wrote:
> This patch set fixes various usage and documentation errors
> in waiting for async crypto op to complete which can result
> in data corruption.
> 
> Note: these were discovered in the process of working on a
> patch set that replaces these call sites and more with a
> generic implementation that will prevent these problems
> going forward. These are just the fix ups for current code.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> CC: stable@vger.kernel.org
> CC: Eric Biggers <ebiggers3@gmail.com>

Patches 1-3 applied.  Please fix patch 4 and resubmit.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
