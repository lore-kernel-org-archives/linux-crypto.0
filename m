From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5/5] crypto/nx: Add P9 NX specific error codes for 842
 engine
Date: Tue, 04 Apr 2017 21:15:24 +1000
Message-ID: <87a87wv2yb.fsf@concordia.ellerman.id.au>
References: <1491066154.29552.30.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: mikey@neuling.org, suka@us.ibm.com, linux-crypto@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
To: Haren Myneni <haren@linux.vnet.ibm.com>, herbert@gondor.apana.org.au,
 ddstreet@ieee.org
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1491066154.29552.30.camel@hbabu-laptop>
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

Haren Myneni <haren@linux.vnet.ibm.com> writes:

> [PATCH 5/5] crypto/nx: Add P9 NX specific error codes for 842 engine
>
> This patch adds changes for checking P9 specific 842 engine
> error codes. These errros are reported in co-processor status
> block (CSB) for failures.

But you just enabled support on P9 in patch 4.

So you should reorder patch 4 and 5. ie. add the P9 error handling
before you enable P9 support.

cheers
