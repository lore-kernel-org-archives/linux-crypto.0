From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v1] crypto: crypto4xx - perform aead icv check in the driver
Date: Fri, 5 Jan 2018 22:15:45 +1100
Message-ID: <20180105111545.GB16271@gondor.apana.org.au>
References: <7d26eb8de324eb17d99d2e4b0aa271b6c75ef889.1514054717.git.chunkeey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Christian Lamparter <chunkeey@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:49976 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbeAELPr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 06:15:47 -0500
Content-Disposition: inline
In-Reply-To: <7d26eb8de324eb17d99d2e4b0aa271b6c75ef889.1514054717.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 23, 2017 at 07:45:46PM +0100, Christian Lamparter wrote:
> The ccm-aes-ppc4xx now fails one of testmgr's expected
> failure test cases as such:
> 
> |decryption failed on test 10 for ccm-aes-ppc4xx:
> |ret was 0, |expected -EBADMSG
> 
> It doesn't look like the hardware sets the authentication failure
> flag. The original vendor source from which this was ported does
> not have any special code or notes about why this would happen or
> if there are any WAs.
> 
> Hence, this patch converts the aead_done callback handler to
> perform the icv check in the driver. And this fixes the false
> negative and the ccm-aes-ppc4xx passes the selftests once again.
> 
> |name         : ccm(aes)
> |driver       : ccm-aes-ppc4xx
> |module       : crypto4xx
> |priority     : 300
> |refcnt       : 1
> |selftest     : passed
> |internal     : no
> |type         : aead
> |async        : yes
> |blocksize    : 1
> |ivsize       : 16
> |maxauthsize  : 16
> |geniv        : <none>
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
