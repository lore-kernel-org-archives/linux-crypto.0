From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: crypto4xx - Perform read/modify/write on
	device control register
Date: Mon, 27 Jun 2011 15:33:29 +0800
Message-ID: <20110627073329.GA9206@gondor.apana.org.au>
References: <20110621121321.GA2414@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, James Hsiao <jhsiao@amcc.com>,
	linux-crypto@vger.kernel.org
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20110621121321.GA2414@zod.rchland.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 21, 2011 at 08:13:21AM -0400, Josh Boyer wrote:
> The Security function on the AMCC SoCs has multiple engines within a
> single MMIO range.  The crypto driver currently enables the 3DES
> functionality by doing a blind write to the device control register.
> This can unintentionally disable other functions like the PKA or TRNG
> when the driver is loaded.
> 
> Perform a read/modify/write to enable the 3DES function instead.
> 
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
