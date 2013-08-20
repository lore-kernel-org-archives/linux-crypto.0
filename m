From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] crypto: tegra-aes - bitwise vs logical and
Date: Tue, 20 Aug 2013 11:54:48 +0300
Message-ID: <20130820085447.GA20170@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>,
	Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

The bug here is that:

	while (eng_busy & (!icq_empty) & dma_busy)

is never true because it's using bitwise instead of logical ANDs.  The
other bitwise AND conditions work as intended but I changed them as well
for consistency.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
Static checker stuff.  I don't have the hardware.

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 85ea752..2d58da9 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -275,7 +275,7 @@ static int aes_start_crypt(struct tegra_aes_dev *dd, u32 in_addr, u32 out_addr,
 			value = aes_readl(dd, TEGRA_AES_INTR_STATUS);
 			eng_busy = value & TEGRA_AES_ENGINE_BUSY_FIELD;
 			icq_empty = value & TEGRA_AES_ICQ_EMPTY_FIELD;
-		} while (eng_busy & (!icq_empty));
+		} while (eng_busy && !icq_empty);
 		aes_writel(dd, cmdq[i], TEGRA_AES_ICMDQUE_WR);
 	}
 
@@ -365,7 +365,7 @@ static int aes_set_key(struct tegra_aes_dev *dd)
 		eng_busy = value & TEGRA_AES_ENGINE_BUSY_FIELD;
 		icq_empty = value & TEGRA_AES_ICQ_EMPTY_FIELD;
 		dma_busy = value & TEGRA_AES_DMA_BUSY_FIELD;
-	} while (eng_busy & (!icq_empty) & dma_busy);
+	} while (eng_busy && !icq_empty && dma_busy);
 
 	/* settable command to get key into internal registers */
 	value = CMD_SETTABLE << CMDQ_OPCODE_SHIFT |
@@ -379,7 +379,7 @@ static int aes_set_key(struct tegra_aes_dev *dd)
 		value = aes_readl(dd, TEGRA_AES_INTR_STATUS);
 		eng_busy = value & TEGRA_AES_ENGINE_BUSY_FIELD;
 		icq_empty = value & TEGRA_AES_ICQ_EMPTY_FIELD;
-	} while (eng_busy & (!icq_empty));
+	} while (eng_busy && !icq_empty);
 
 	return 0;
 }
