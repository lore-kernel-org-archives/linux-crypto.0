From: Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 0/3] crypto: inside-secure: improve clock management
Date: Tue, 13 Mar 2018 17:48:39 +0100
Message-ID: <20180313164842.20042-1-gregory.clement@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
 Gregory CLEMENT <gregory.clement@bootlin.com>, Omri Itach <omrii@marvell.com>,
 Nadav Haklai <nadavh@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
 Igal Liberman <igall@marvell.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
 Marcin Wojtas <mw@semihalf.com>, Hanna Hawa <hannah@marvell.com>,
 linux-arm-kernel@lists.infradead.org,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
 linux-crypto@vger.kernel.org, Antoine Tenart <antoine.tenart@bootlin.com>,
 oferh@marvell.com
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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

This short series fixes the way the clocks are used for the SafeXcel
EIP-197 controller embedded in the Marvell Armada 7K/8K SoCs. On these
SoCs a second one is needed in order to clock the registers. It was
not noticed until now because we relied on the bootloader and also
because the clock driver was wrong.

Thanks to this fix, it would be possible to fix the clock driver
without introducing a regression.

While I was working on the clocks I found a bug in the clock
management which was fixed with the first patch and should be applied
to v4.16.

The second patch is a small improvement which is aim for v4.17 as well
as the last patch.

Thanks,

Gregory

Gregory CLEMENT (3):
  crypto: inside-secure - fix clock management
  crypto: inside-secure - improve clock initialization
  crypto: inside-secure - fix clock resource by adding a register clock

 .../bindings/crypto/inside-secure-safexcel.txt     |  6 ++-
 drivers/crypto/inside-secure/safexcel.c            | 47 +++++++++++++++-------
 drivers/crypto/inside-secure/safexcel.h            |  1 +
 3 files changed, 38 insertions(+), 16 deletions(-)

-- 
2.16.1
