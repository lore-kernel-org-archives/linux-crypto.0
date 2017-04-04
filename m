From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 3/5] crypto/nx: Create nx842_delete_coproc function
Date: Tue, 04 Apr 2017 21:13:23 +1000
Message-ID: <87d1csv31o.fsf@concordia.ellerman.id.au>
References: <1491066046.29552.28.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: mikey@neuling.org, suka@us.ibm.com, linux-crypto@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
To: Haren Myneni <haren@linux.vnet.ibm.com>, herbert@gondor.apana.org.au,
 ddstreet@ieee.org
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1491066046.29552.28.camel@hbabu-laptop>
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

> [PATCH 3/5] crypto/nx: Create nx842_delete_coproc function
>
> Move deleting coprocessor info upon exit or failure to
> nx842_delete_coproc().

Naming again, this deletes *all* the coprocs, so the name should be
plural.

cheers
