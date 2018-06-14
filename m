From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] crypto: sun4i-ss: prevent deadlock on emulated hardware
Date: Thu, 14 Jun 2018 21:36:59 +0200
Message-ID: <20180614193659.29261-1-clabbe.montjoie@gmail.com>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	maxime.ripard-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org,
	wens-jdAy2FN1RRM@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBB44IRPMQKGQEC2CFKCA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Running a qemu emulated cubieboard with sun4i-ss driver enabled led to a never
ending boot.
This is due to sun4i-ss deadlocked and taking all cpu in an infinite loop.
Since the crypto hardware is not implemented, all registers are read as 0.
So sun4i-ss will never progress in any operations. (TX_CNT being always 0)

The first idea is to add a "TX_CNT always zero timeout" but this made cipher/hash loops
more complex and prevent a case that never happen on real hardware.

The best way to fix is to check at probe time if we run on a virtual
machine with hardware emulated but non-implemented and prevent
sun4i-ss to be loaded in that case.
Letting sun4i-ss to load is useless anyway since all crypto algorithm will be
disabled since they will fail crypto selftests.

Tested-on: qemu-cubieboard
Tested-on: cubieboard2

Signed-off-by: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index a81d89b3b7d8..a178e80adcf3 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -341,9 +341,18 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 	 * I expect to be a sort of Security System Revision number.
 	 * Since the A80 seems to have an other version of SS
 	 * this info could be useful
+	 * Detect virtual machine with non-implemented hardware
+	 * (qemu-cubieboard) by checking the register value after a write to it.
+	 * On non-implemented hardware, all registers are read as 0.
+	 * On real hardware we should have a value > 0.
 	 */
 	writel(SS_ENABLED, ss->base + SS_CTL);
 	v = readl(ss->base + SS_CTL);
+	if (!v) {
+		dev_err(&pdev->dev, "Qemu with non-implemented SS detected.\n");
+		err = -ENODEV;
+		goto error_rst;
+	}
 	v >>= 16;
 	v &= 0x07;
 	dev_info(&pdev->dev, "Die ID %d\n", v);
@@ -398,6 +407,7 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 			break;
 		}
 	}
+error_rst:
 	if (ss->reset)
 		reset_control_assert(ss->reset);
 error_clk:
-- 
2.16.4
