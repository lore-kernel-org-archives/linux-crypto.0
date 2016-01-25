From: Anatoly Pugachev <matorola@gmail.com>
Subject: [PATCH 1/2] n2rng: documentation, add DT bindings, vendor prefixes
Date: Mon, 25 Jan 2016 19:09:21 +0300
Message-ID: <20160125160921.GA26873@yogzotot>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sparclinux@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

n2rng: documentation, add DT bindings, vendor prefixes

Signed-off-by: Anatoly Pugachev <matorola@gmail.com>
---
 .../devicetree/bindings/sparc_sun_oracle_rng.txt   | 30 ++++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  2 ++
 2 files changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sparc_sun_oracle_rng.txt

diff --git a/Documentation/devicetree/bindings/sparc_sun_oracle_rng.txt b/Documentation/devicetree/bindings/sparc_sun_oracle_rng.txt
new file mode 100644
index 0000000..b0b2111
--- /dev/null
+++ b/Documentation/devicetree/bindings/sparc_sun_oracle_rng.txt
@@ -0,0 +1,30 @@
+HWRNG support for the n2_rng driver
+
+Required properties:
+- reg		: base address to sample from
+- compatible	: should contain one of the following
+	RNG versions:
+	- 'SUNW,n2-rng' for Niagara 2 Platform (SUN UltraSPARC T2 CPU)
+	- 'SUNW,vf-rng' for Victoria Falls Platform (SUN UltraSPARC T2 Plus CPU)
+	- 'SUNW,kt-rng' for Rainbow/Yosemite Falls Platform (SUN SPARC T3/T4), (UltraSPARC KT/Niagara 3 - development names)
+	more recent systems (after Oracle acquisition of SUN)
+	- 'ORCL,m4-rng' for SPARC T5/M5
+	- 'ORCL,m7-rng' for SPARC T7/M7
+
+Examples:
+/* linux LDOM on SPARC T5-2 */
+Node 0xf029a4f4
+	.node:  f029a4f4
+	rng-#units:  00000002
+	compatible: 'ORCL,m4-rng'
+	reg:  0000000e
+	name: 'random-number-generator'
+
+/* solaris on SPARC M7-8 */
+Node 0xf028c08c
+	rng-#units:  00000003
+	compatible: 'ORCL,m7-rng'
+	reg:  0000000e
+	name:  'random-number-generator'
+
+PS: see as well prtconfs.git by DaveM
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 72e2c5a..e00029d 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -170,6 +170,7 @@ opencores	OpenCores.org
 option	Option NV
 ortustech	Ortus Technology Co., Ltd.
 ovti	OmniVision Technologies
+ORCL	Oracle Corporation
 panasonic	Panasonic Corporation
 parade	Parade Technologies Inc.
 pericom	Pericom Technology Inc.
@@ -227,6 +228,7 @@ startek	Startek
 ste	ST-Ericsson
 stericsson	ST-Ericsson
 synology	Synology, Inc.
+SUNW	Sun Microsystems, Inc
 tbs	TBS Technologies
 tcl	Toby Churchill Ltd.
 technologic	Technologic Systems
-- 
2.7.0

