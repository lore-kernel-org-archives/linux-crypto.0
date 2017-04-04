From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 1/5] crypto/nx: Rename nx842_powernv_function as icswx
 function
Date: Tue, 04 Apr 2017 21:11:51 +1000
Message-ID: <87inmkv348.fsf@concordia.ellerman.id.au>
References: <1491065941.29552.26.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: mikey@neuling.org, suka@us.ibm.com, linux-crypto@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
To: Haren Myneni <haren@linux.vnet.ibm.com>, herbert@gondor.apana.org.au,
 ddstreet@ieee.org
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1491065941.29552.26.camel@hbabu-laptop>
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

> [PATCH 1/5] crypto/nx: Rename nx842_powernv_function as icswx function
>
> nx842_powernv_function is points to nx842_icswx_function and
> will be point to VAS function which will be added later for
> P9 NX support.

I know it's nit-picking but can you give it a better name while you're
there.

I was thinking it should be called "send" or something, but it actually
synchronously sends and waits for a request.

So perhaps just nx842_exec(), for "execute a request", and then you can
have nx842_exec_icswx() and nx842_exec_vas().

cheers
