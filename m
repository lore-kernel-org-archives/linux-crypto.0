From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: [V3, 2/2] crypto/nx: Initialize 842 high and normal RxFIFO control
 registers
Date: Thu,  9 Aug 2018 00:25:29 +1000 (AEST)
Message-ID: <41ltvw207Bz9s0n@ozlabs.org>
References: <1528875160.14408.6.camel@hbabu-laptop>
Cc: linuxppc-dev@lists.ozlabs.org, herbert@gondor.apana.org.au,
 stewart@linux.ibm.com, linux-crypto@vger.kernel.org
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1528875160.14408.6.camel@hbabu-laptop>
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

On Wed, 2018-06-13 at 07:32:40 UTC, Haren Myneni wrote:
> NX increments readOffset by FIFO size in receive FIFO control register
> when CRB is read. But the index in RxFIFO has to match with the
> corresponding entry in FIFO maintained by VAS in kernel. Otherwise NX
> may be processing incorrect CRBs and can cause CRB timeout.
> 
> VAS FIFO offset is 0 when the receive window is opened during
> initialization. When the module is reloaded or in kexec boot, readOffset
> in FIFO control register may not match with VAS entry. This patch adds
> nx_coproc_init OPAL call to reset readOffset and queued entries in FIFO
> control register for both high and normal FIFOs.
> 
> Signed-off-by: Haren Myneni <haren@us.ibm.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/656ecc16e8fc2ab44b3d70e3fcc197

cheers
