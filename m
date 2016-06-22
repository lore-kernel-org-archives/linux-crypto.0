From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [[PATCH v2] 11/11] hwrng: exynos - fixup IO accesors
Date: Wed, 22 Jun 2016 18:37:05 +0800
Message-ID: <20160622103705.GA30967@gondor.apana.org.au>
References: <1466504432-24187-12-git-send-email-ben.dooks@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@lists.codethink.co.uk, k.kozlowski@samsung.com,
 linux-samsung-soc@vger.kernel.org, matthew.leach@codethink.co.uk,
 ben.dooks@codethink.co.uk, linux-crypto@vger.kernel.org, mpm@selenic.com,
 linux-arm-kernel@lists.infradead.org
To: Ben Dooks <ben.dooks@codethink.co.uk>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1466504432-24187-12-git-send-email-ben.dooks@codethink.co.uk>
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

Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> The __raw IO functions are not endian safe, so use the readl_relaxed
> and writel_relaxed versions of these.
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

This patch has already been merged.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
