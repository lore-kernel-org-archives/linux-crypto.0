From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] Fix crypto/vmx/p8_ghash memory corruption
Date: Sun, 2 Oct 2016 22:40:47 +0800
Message-ID: <20161002144047.GG18268@gondor.apana.org.au>
References: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
 <20160929065908.653ec5c2@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Cerri <marcelo.cerri@canonical.com>,
        linux-crypto@vger.kernel.org,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        George Wilson <gcwilson@us.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
To: Anton Blanchard <anton@samba.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48620 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751919AbcJBOku (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Oct 2016 10:40:50 -0400
Content-Disposition: inline
In-Reply-To: <20160929065908.653ec5c2@kryten>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 29, 2016 at 06:59:08AM +1000, Anton Blanchard wrote:
> Hi Marcelo
> 
> > This series fixes the memory corruption found by Jan Stancek in
> > 4.8-rc7. The problem however also affects previous versions of the
> > driver.
> 
> If it affects previous versions, please add the lines in the sign off to
> get it into the stable kernels.

I have added them to patches 1 and 2.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
