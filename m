From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] powerpc: crypto/vmx: various build fixes
Date: Thu, 17 Nov 2016 23:40:26 +0800
Message-ID: <20161117154026.GB1687@gondor.apana.org.au>
References: <20161116151146.15720-1-naveen.n.rao@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
 Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20161116151146.15720-1-naveen.n.rao@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 16, 2016 at 08:41:46PM +0530, Naveen N. Rao wrote:
> First up, clean up the generated .S files properly on a 'make clean'.
> Secondly, force re-generation of these files when building for different
> endian-ness than what was built previously. Finally, generate the new
> files in the build tree, rather than the source tree.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
