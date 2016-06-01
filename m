From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 00/28] crypto: omap fixes / support additions
Date: Wed, 1 Jun 2016 11:56:01 +0300
Message-ID: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: lokeshvutla@ti.com, linux-arm-kernel@lists.infradead.org
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
 <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <tony@atomide.com>
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

This series adds support for crypto hardware accelerators on TI DRA7xx
and AM43xx SoCs, and fixes a number of bugs in the existing codebase.
This series also addresses performance issues with the AES / SHA
accelerators, doing some optimizations on these.

Patch #7 and #13 are generic crypto API implementation changes.
Without #7, omap-sham export/import does not work, #13 is kind
of nice to have.

Patches 16+ should be picked-up / acked by Tony, but they have
dependencies on the preceding patches; at least the AES dual core
support must be in before applying the rest, otherwise bad things
will happen.

-Tero
