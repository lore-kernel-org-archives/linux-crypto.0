From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 4/5] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Sat, 10 Jun 2017 12:16:17 +0800
Message-ID: <20170610041617.GD14719@gondor.apana.org.au>
References: <20170524141035.21031-1-antoine.tenart@free-electrons.com>
 <20170524141035.21031-5-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: thomas.petazzoni@free-electrons.com, andrew@lunn.ch, jason@lakedaemon.net,
 igall@marvell.com, oferh@marvell.com, nadavh@marvell.com,
 linux-crypto@vger.kernel.org, gregory.clement@free-electrons.com,
 robin.murphy@arm.com, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org, sebastian.hesselbarth@gmail.com
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170524141035.21031-5-antoine.tenart@free-electrons.com>
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

On Wed, May 24, 2017 at 04:10:34PM +0200, Antoine Tenart wrote:
> Add support for Inside Secure SafeXcel EIP197 cryptographic engine,
> which can be found on Marvell Armada 7k and 8k boards. This driver
> currently implements: ecb(aes), cbc(aes), sha1, sha224, sha256 and
> hmac(sah1) algorithms.
> 
> Two firmwares are needed for this engine to work. Their are mostly used
> for more advanced operations than the ones supported (as of now), but we
> still need them to pass the data to the internal cryptographic engine.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
