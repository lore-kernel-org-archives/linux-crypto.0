From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: [V3,1/2] powerpc/powernv: Export opal_check_token symbol
Date: Thu,  9 Aug 2018 00:25:27 +1000 (AEST)
Message-ID: <41ltvs6JsBz9s4V@ozlabs.org>
References: <1528874937.14408.2.camel@hbabu-laptop>
Cc: linuxppc-dev@lists.ozlabs.org, herbert@gondor.apana.org.au,
 stewart@linux.ibm.com, linux-crypto@vger.kernel.org
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1528874937.14408.2.camel@hbabu-laptop>
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

On Wed, 2018-06-13 at 07:28:57 UTC, Haren Myneni wrote:
> Export opal_check_token symbol for modules to check the availability
> of OPAL calls before using them.
> 
> Signed-off-by: Haren Myneni <haren@us.ibm.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/6e708000ec2c93c2bde6a46aa2d6c3

cheers
