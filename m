From: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/4] hw_random: jz4780-rng: Enable hardware RNG in CI20 defconfig
Date: Sat, 27 Aug 2016 23:44:57 +0530
Message-ID: <1472321697-3094-5-git-send-email-prasannatsmkumar@gmail.com>
References: <1472321697-3094-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
        mark.rutland-5wv7dgnIgG8@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org,
        gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
        harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org, prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org, narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org,
        linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472321697-3094-1-git-send-email-prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch enables the usage of RNG in MIPS Creator CI20 default config.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 arch/mips/configs/ci20_defconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/configs/ci20_defconfig b/arch/mips/configs/ci20_defconfig
index bf164fe..51a47a4 100644
--- a/arch/mips/configs/ci20_defconfig
+++ b/arch/mips/configs/ci20_defconfig
@@ -88,7 +88,9 @@ CONFIG_SERIAL_8250_NR_UARTS=5
 CONFIG_SERIAL_8250_RUNTIME_UARTS=5
 CONFIG_SERIAL_8250_INGENIC=y
 CONFIG_SERIAL_OF_PLATFORM=y
-# CONFIG_HW_RANDOM is not set
+CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM_TIMERIOMEM is not set
+CONFIG_HW_RANDOM_JZ4780=y
 CONFIG_I2C=y
 CONFIG_I2C_JZ4780=y
 CONFIG_GPIO_SYSFS=y
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
