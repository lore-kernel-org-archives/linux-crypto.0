From: Rick Altherr <raltherr@google.com>
Subject: [PATCH v1 2/2] hw_random: timeriomem_rng: Allow setting RNG quality from platform data
Date: Wed, 17 May 2017 15:29:11 -0700
Message-ID: <20170517222911.9295-2-raltherr@google.com>
References: <20170517222911.9295-1-raltherr@google.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170517222911.9295-1-raltherr@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When a hw_random device's quality is non-zero, it will automatically be
used to fill the kernel's entropy pool.  Since timeriomem_rng is used by
many different devices, the quality needs to be provided by platform
data or device tree.

Signed-off-by: Rick Altherr <raltherr@google.com>
---

 drivers/char/hw_random/timeriomem-rng.c | 7 +++++++
 include/linux/timeriomem-rng.h          | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index a0faa5f05deb..03ff5483d865 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -151,8 +151,15 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev, "missing period\n");
 			return -EINVAL;
 		}
+
+		if (!of_property_read_u32(pdev->dev.of_node,
+						"quality", &i))
+			priv->rng_ops.quality = i;
+		else
+			priv->rng_ops.quality = 0;
 	} else {
 		period = pdata->period;
+		priv->rng_ops.quality = pdata->quality;
 	}
 
 	priv->period = ns_to_ktime(period * NSEC_PER_USEC);
diff --git a/include/linux/timeriomem-rng.h b/include/linux/timeriomem-rng.h
index 46eb27ddbfab..320f743bf06b 100644
--- a/include/linux/timeriomem-rng.h
+++ b/include/linux/timeriomem-rng.h
@@ -13,4 +13,7 @@ struct timeriomem_rng_data {
 
 	/* measures in usecs */
 	unsigned int		period;
+
+	/* bits of entropy per 1000 bits read */
+	unsigned int		quality;
 };
-- 
2.13.0.303.g4ebf302169-goog
