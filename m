From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha1-powerpc: little-endian support
Date: Wed, 28 Sep 2016 21:20:15 +0800
Message-ID: <20160928132015.GA21312@gondor.apana.org.au>
References: <1474659116-4689-1-git-send-email-marcelo.cerri@canonical.com>
 <20160928131551.GA31082@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        George Wilson <gcwilson@us.ibm.com>,
        Claudio Carvalho <cclaudio@br.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@br.ibm.com>,
        joy.latten@canonical.com, "David S. Miller" <davem@davemloft.net>
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56594 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932302AbcI1NUq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 09:20:46 -0400
Content-Disposition: inline
In-Reply-To: <20160928131551.GA31082@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 28, 2016 at 10:15:51AM -0300, Marcelo Cerri wrote:
> Hi Herbert,
> 
> Any thoughts on this one?

Can this patch wait until the next merge window? On the broken
platforms it should just fail the self-test, right?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
