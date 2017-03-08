From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: powerpc - Fix initialisation of crc32c context
Date: Wed, 8 Mar 2017 16:47:10 +0800
Message-ID: <20170308084710.GA4867@gondor.apana.org.au>
References: <20170303065655.7317-1-dja@axtens.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dja@axtens.net, linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
 anton@samba.org
To: Daniel Axtens <dja@axtens.net>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20170303065655.7317-1-dja@axtens.net>
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

Daniel Axtens <dja@axtens.net> wrote:
> Turning on crypto self-tests on a POWER8 shows:
> 
>    alg: hash: Test 1 failed for crc32c-vpmsum
>    00000000: ff ff ff ff
> 
> Comparing the code with the Intel CRC32c implementation on which
> ours is based shows that we are doing an init with 0, not ~0
> as CRC32c requires.
> 
> This probably wasn't caught because btrfs does its own weird
> open-coded initialisation.
> 
> Initialise our internal context to ~0 on init.
> 
> This makes the self-tests pass, and btrfs continues to work.
> 
> Fixes: 6dd7a82cc54e ("crypto: powerpc - Add POWER8 optimised crc32c")
> Cc: Anton Blanchard <anton@samba.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Axtens <dja@axtens.net>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
