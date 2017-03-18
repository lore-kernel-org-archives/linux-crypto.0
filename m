From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Question - seeding the hw pseudo random number generator
Date: Sat, 18 Mar 2017 11:25:54 +0200
Message-ID: <20170318092554.lggkhfg5eko23o3k@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
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

Hi,

I looked at Exynos Pseudo Random Nubmer Generator driver
(drivers/char/hw_random/exynos-rng.c) and noticed that it always seeds
the device with jiffies.  Then I looked at few other drivers and found
that they do not seed themself (or at least I couldn't find this).

I think the hw_random API does not provide generic infrastructure for
seeding.

What is the preferred approach for seeding a PRNG device? Use jiffies or
a fixed value?

Or maybe the interface should be abandoned in favor of crypto API?

Best regards,
Krzysztof
