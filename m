From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] Fix crypto/vmx/p8_ghash memory corruption
Date: Sun, 2 Oct 2016 22:40:16 +0800
Message-ID: <20161002144016.GF18268@gondor.apana.org.au>
References: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        George Wilson <gcwilson@us.ibm.com>
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 28, 2016 at 01:42:08PM -0300, Marcelo Cerri wrote:
> This series fixes the memory corruption found by Jan Stancek in 4.8-rc7. The
> problem however also affects previous versions of the driver.
> 
> Marcelo Cerri (3):
>   crypto: ghash-generic - move common definitions to a new header file
>   crypto: vmx - Fix memory corruption caused by p8_ghash
>   crypto: vmx - Ensure ghash-generic is enabled

Patch 1/2 applied to crypto.  I have changed patch 3 to use select
instead of depend and have applied it to cryptodev.

Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
