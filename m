From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell/cesa - Clean up redundant #include
Date: Sat, 3 Mar 2018 00:42:02 +0800
Message-ID: <20180302164202.GD21579@gondor.apana.org.au>
References: <99d8deb60039adf572aec26b091f2b0c61edf397.1519048413.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: boris.brezillon@free-electrons.com, arno@natisbad.org, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <99d8deb60039adf572aec26b091f2b0c61edf397.1519048413.git.robin.murphy@arm.com>
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

On Mon, Feb 19, 2018 at 01:55:36PM +0000, Robin Murphy wrote:
> The inclusion of dma-direct.h was only needed temporarily to prevent
> breakage from the DMA API rework, since the actual CESA fix making it
> redundant was merged in parallel. Now that both have landed, it can go.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
