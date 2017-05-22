From: Rick Altherr <raltherr@google.com>
Subject: [PATCH v2 2/2] hw_random: timeriomem_rng: Allow setting RNG quality from platform data
Date: Mon, 22 May 2017 14:12:24 -0700
Message-ID: <20170522211224.12202-2-raltherr@google.com>
References: <20170522211224.12202-1-raltherr@google.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34242 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935792AbdEVVM3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 May 2017 17:12:29 -0400
Received: by mail-pf0-f180.google.com with SMTP id 9so93435190pfj.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 May 2017 14:12:29 -0700 (PDT)
In-Reply-To: <20170522211224.12202-1-raltherr@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When a hw_random device's quality is non-zero, it will automatically be
used to fill the kernel's entropy pool.  Since timeriomem_rng is used by
many different devices, the quality needs to be provided by platform
data or device tree.

Signed-off-by: Rick Altherr <raltherr@google.com>
---

Changes in v2:
- Adjust header comment for platform data quality property to match code
and DT bindings

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
index 46eb27ddbfab..3e00122bcf88 100644
--- a/include/linux/timeriomem-rng.h
+++ b/include/linux/timeriomem-rng.h
@@ -13,4 +13,7 @@ struct timeriomem_rng_data {
 
 	/* measures in usecs */
 	unsigned int		period;
+
+	/* bits of entropy per 1024 bits read */
+	unsigned int		quality;
 };
-- 
2.13.0.303.g4ebf302169-goog
