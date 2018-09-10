From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 01/11] bus: fsl-mc: add support for dpseci device type
Date: Mon, 10 Sep 2018 20:15:40 +0300
Message-ID: <20180910171550.5659-2-horia.geanta@nxp.com>
References: <20180910171550.5659-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "David S . Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Roy Pledge <roy.pledge@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180910171550.5659-1-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 5 +++++
 include/linux/fsl/mc.h          | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 5d8266c6571f..4552b06fe601 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -188,6 +188,10 @@ struct device_type fsl_mc_bus_dprtc_type = {
 	.name = "fsl_mc_bus_dprtc"
 };
 
+struct device_type fsl_mc_bus_dpseci_type = {
+	.name = "fsl_mc_bus_dpseci"
+};
+
 static struct device_type *fsl_mc_get_device_type(const char *type)
 {
 	static const struct {
@@ -203,6 +207,7 @@ static struct device_type *fsl_mc_get_device_type(const char *type)
 		{ &fsl_mc_bus_dpmcp_type, "dpmcp" },
 		{ &fsl_mc_bus_dpmac_type, "dpmac" },
 		{ &fsl_mc_bus_dprtc_type, "dprtc" },
+		{ &fsl_mc_bus_dpseci_type, "dpseci" },
 		{ NULL, NULL }
 	};
 	int i;
diff --git a/include/linux/fsl/mc.h b/include/linux/fsl/mc.h
index f27cb14088a4..5160f06ffbac 100644
--- a/include/linux/fsl/mc.h
+++ b/include/linux/fsl/mc.h
@@ -405,6 +405,7 @@ extern struct device_type fsl_mc_bus_dpcon_type;
 extern struct device_type fsl_mc_bus_dpmcp_type;
 extern struct device_type fsl_mc_bus_dpmac_type;
 extern struct device_type fsl_mc_bus_dprtc_type;
+extern struct device_type fsl_mc_bus_dpseci_type;
 
 static inline bool is_fsl_mc_bus_dprc(const struct fsl_mc_device *mc_dev)
 {
@@ -451,6 +452,11 @@ static inline bool is_fsl_mc_bus_dprtc(const struct fsl_mc_device *mc_dev)
 	return mc_dev->dev.type == &fsl_mc_bus_dprtc_type;
 }
 
+static inline bool is_fsl_mc_bus_dpseci(const struct fsl_mc_device *mc_dev)
+{
+	return mc_dev->dev.type == &fsl_mc_bus_dpseci_type;
+}
+
 /*
  * Data Path Buffer Pool (DPBP) API
  * Contains initialization APIs and runtime control APIs for DPBP
-- 
2.16.2
