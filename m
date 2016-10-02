From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha1-powerpc: little-endian support
Date: Sun, 2 Oct 2016 22:37:58 +0800
Message-ID: <20161002143758.GC18268@gondor.apana.org.au>
References: <1474659116-4689-1-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        George Wilson <gcwilson@us.ibm.com>,
        Claudio Carvalho <cclaudio@br.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@br.ibm.com>,
        joy.latten@canonical.com
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474659116-4689-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 23, 2016 at 04:31:56PM -0300, Marcelo Cerri wrote:
> The driver does not handle endianness properly when loading the input
> data.
> 
> Signed-off-by: Marcelo Cerri <marcelo.cerri@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
