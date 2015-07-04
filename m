From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: marvell/CESA: Issues with non cache-line aligned buffers
Date: Sat, 4 Jul 2015 15:37:17 +0800
Message-ID: <20150704073717.GA6539@gondor.apana.org.au>
References: <20150703114305.15611807@bbrezillon>
 <20150704073355.GA6451@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 Russell King - ARM Linux <linux@arm.linux.org.uk>,
 Arnaud Ebalard <arno@natisbad.org>, Will Deacon <will.deacon@arm.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Gregory CLEMENT <gregory.clement@free-electrons.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20150704073355.GA6451@gondor.apana.org.au>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jul 04, 2015 at 03:33:55PM +0800, Herbert Xu wrote:
> Note that I don't think we have a suitable helper for DMA-aligned
> processing of SG lists.  The ablkcipher_walk_* interface is mostly
> identical to the blkcipher_walk_* interface.

Actually I take that back.  The ablkcipher_walk_* should work
even if may be a bit unwieldy.  Patches to improve it are of
course welcome :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
