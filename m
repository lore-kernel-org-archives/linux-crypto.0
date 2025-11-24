Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE781E4AF;
	Mon, 24 Nov 2025 13:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763989459; cv=none; b=NNDnzC9vi7odx1zB8rdh+jdAWPGRipLqldcM4unZvYc6suHQXNLMsVGhpNEKyzyyn/MDXU+sAlqACsLeHiTI7MT2cvmaYQBwnyUNH5QcqU+8QOTMvb2J01uZEw5FOXDHj9ZXW9JgzkWk5YAq5y7fuVKuxkbAa0TtemRbOWOxsxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763989459; c=relaxed/simple;
	bh=JckmVSzukyidG2dui/LSzqe71K/hORksPnHdkUfcy0s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V4uwEZY0Gj71zjZqQjz71RA3r6tYmXqItOI2bnnT/D0cwsh6CsWD8DnW5YQcpWCzM2zbjyTG6z+s7svTSHR5RdJvCk0cM/fy9kJ5aIMZ2OCVoMCF4N2YB3W4OHW8Ma4la1bEUhsjLF4QJ02rQHiJeN7iqRXc5iGU9VGeK0G0JfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org; spf=pass smtp.mailfrom=yoseli.org; dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b=HjKSXCJ+; arc=none smtp.client-ip=217.70.183.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yoseli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b="HjKSXCJ+"
Received: by mail.gandi.net (Postfix) with ESMTPSA id D9D63443F5;
	Mon, 24 Nov 2025 13:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yoseli.org; s=gm1;
	t=1763989455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8jK/BJit61+AKutAJR0P94X+7KV8Ubt7aBKM7Qa21V0=;
	b=HjKSXCJ+38Iqegz8ch4Vpn4xWfuf/j1Lb/GsEccKlsnHRrVAviKvgwEkZ6wC/Hf5OLe6IF
	ZwfSpGNfcKl07b9dSxknfgsmGohxUlTWckd98JGhrHVTuo4iOUeupHTqz2cbAaY8WDbtKy
	pjgRFw5z7vheRp0ATNicb1Mz8/sjnHz08d/w+p7UHq0u4dhR9+sSVjLzs26ByILIdOCvSm
	HK+yb9hL9cohHyd81msZnEPPAYG8OU/F7jrLxTxrasJhiHe1bBwMRVb02N+78nFpUazGym
	qm5rHBmX04c3nM7SMZtyGxkQE4u/LBAKYdf6pBzPjGq1dHLrXZ9j5tfpSz5oeg==
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Date: Mon, 24 Nov 2025 14:04:06 +0100
Subject: [PATCH v3 1/3] m68k: coldfire: Mark platform device resource
 arrays as const
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251124-b4-m5441x-add-rng-support-v3-1-f447251dad27@yoseli.org>
References: <20251124-b4-m5441x-add-rng-support-v3-0-f447251dad27@yoseli.org>
In-Reply-To: <20251124-b4-m5441x-add-rng-support-v3-0-f447251dad27@yoseli.org>
To: Greg Ungerer <gerg@linux-m68k.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Shawn Guo <shawnguo@kernel.org>, 
 Sascha Hauer <s.hauer@pengutronix.de>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 Fabio Estevam <festevam@gmail.com>
Cc: linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, 
 Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763989450; l=4439;
 i=jeanmichel.hautbois@yoseli.org; s=20240925; h=from:subject:message-id;
 bh=JckmVSzukyidG2dui/LSzqe71K/hORksPnHdkUfcy0s=;
 b=L317WBNEiAsbe5JW5H6UDvOUD3cH2afXNSQ++LQh9y94DWqHfnbsyD2hV4Y8prnOqCOuH0WTr
 dGO/wmJU+NaCG7uZB1liLyFqPgWKbrnepJnaZOwmQhUfIjUjp6IG1S8
X-Developer-Key: i=jeanmichel.hautbois@yoseli.org; a=ed25519;
 pk=MsMTVmoV69wLIlSkHlFoACIMVNQFyvJzvsJSQsn/kq4=
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeekieejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhfffugggtgffkfhgjvfevofesthejredtredtjeenucfhrhhomheplfgvrghnqdfoihgthhgvlhcujfgruhhtsghoihhsuceojhgvrghnmhhitghhvghlrdhhrghuthgsohhisheshihoshgvlhhirdhorhhgqeenucggtffrrghtthgvrhhnpeffjefhtdelhffhheevheeutefghfefteeluedvudfhgeegteeitddtuefhhfelteenucfkphepvdgrtddumegvtdgrmeduieelmeejudegtdemkeeksgefmeehudehfeemtgdvieegmeegfhgsnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvdgrtddumegvtdgrmeduieelmeejudegtdemkeeksgefmeehudehfeemtgdvieegmeegfhgspdhhvghlohephihoshgvlhhiqdihohgtthhordihohhsvghlihdrohhrghdpmhgrihhlfhhrohhmpehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrghdpnhgspghrtghpthhtohepudehpdhrtghpthhtohepjhgvrghnmhhitghhvghlrdhhrghuthgsohhisheshihoshgvlhhirdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfr
 hgruggvrggurdhorhhgpdhrtghpthhtohepghgvvghrtheslhhinhhugidqmheikehkrdhorhhgpdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopehfvghsthgvvhgrmhesghhmrghilhdrtghomhdprhgtphhtthhopehshhgrfihnghhuoheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshdrhhgruhgvrhesphgvnhhguhhtrhhonhhigidruggvpdhrtghpthhtohepihhmgieslhhishhtshdrlhhinhhugidruggvvh
X-GND-Sasl: jeanmichel.hautbois@yoseli.org

Add 'const' qualifier to all static resource arrays in device.c.
These arrays are never modified at runtime, they are only read by
platform device registration functions.

Suggested-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
---
 arch/m68k/coldfire/device.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
index b6958ec2a220cf91a78a14fc7fa18749451412f7..20adba27a687029ef53249bad71b342d563d612b 100644
--- a/arch/m68k/coldfire/device.c
+++ b/arch/m68k/coldfire/device.c
@@ -111,7 +111,7 @@ static struct fec_platform_data fec_pdata = {
  *	block. It is Freescale's own hardware block. Some ColdFires
  *	have 2 of these.
  */
-static struct resource mcf_fec0_resources[] = {
+static const struct resource mcf_fec0_resources[] = {
 	{
 		.start		= MCFFEC_BASE0,
 		.end		= MCFFEC_BASE0 + MCFFEC_SIZE0 - 1,
@@ -148,7 +148,7 @@ static struct platform_device mcf_fec0 = {
 #endif /* MCFFEC_BASE0 */
 
 #ifdef MCFFEC_BASE1
-static struct resource mcf_fec1_resources[] = {
+static const struct resource mcf_fec1_resources[] = {
 	{
 		.start		= MCFFEC_BASE1,
 		.end		= MCFFEC_BASE1 + MCFFEC_SIZE1 - 1,
@@ -189,7 +189,7 @@ static struct platform_device mcf_fec1 = {
  *	The ColdFire QSPI module is an SPI protocol hardware block used
  *	on a number of different ColdFire CPUs.
  */
-static struct resource mcf_qspi_resources[] = {
+static const struct resource mcf_qspi_resources[] = {
 	{
 		.start		= MCFQSPI_BASE,
 		.end		= MCFQSPI_BASE + MCFQSPI_SIZE - 1,
@@ -340,7 +340,7 @@ static struct platform_device mcf_qspi = {
 #endif /* IS_ENABLED(CONFIG_SPI_COLDFIRE_QSPI) */
 
 #if IS_ENABLED(CONFIG_I2C_IMX)
-static struct resource mcf_i2c0_resources[] = {
+static const struct resource mcf_i2c0_resources[] = {
 	{
 		.start          = MCFI2C_BASE0,
 		.end            = MCFI2C_BASE0 + MCFI2C_SIZE0 - 1,
@@ -361,7 +361,7 @@ static struct platform_device mcf_i2c0 = {
 };
 #ifdef MCFI2C_BASE1
 
-static struct resource mcf_i2c1_resources[] = {
+static const struct resource mcf_i2c1_resources[] = {
 	{
 		.start          = MCFI2C_BASE1,
 		.end            = MCFI2C_BASE1 + MCFI2C_SIZE1 - 1,
@@ -385,7 +385,7 @@ static struct platform_device mcf_i2c1 = {
 
 #ifdef MCFI2C_BASE2
 
-static struct resource mcf_i2c2_resources[] = {
+static const struct resource mcf_i2c2_resources[] = {
 	{
 		.start          = MCFI2C_BASE2,
 		.end            = MCFI2C_BASE2 + MCFI2C_SIZE2 - 1,
@@ -409,7 +409,7 @@ static struct platform_device mcf_i2c2 = {
 
 #ifdef MCFI2C_BASE3
 
-static struct resource mcf_i2c3_resources[] = {
+static const struct resource mcf_i2c3_resources[] = {
 	{
 		.start          = MCFI2C_BASE3,
 		.end            = MCFI2C_BASE3 + MCFI2C_SIZE3 - 1,
@@ -433,7 +433,7 @@ static struct platform_device mcf_i2c3 = {
 
 #ifdef MCFI2C_BASE4
 
-static struct resource mcf_i2c4_resources[] = {
+static const struct resource mcf_i2c4_resources[] = {
 	{
 		.start          = MCFI2C_BASE4,
 		.end            = MCFI2C_BASE4 + MCFI2C_SIZE4 - 1,
@@ -457,7 +457,7 @@ static struct platform_device mcf_i2c4 = {
 
 #ifdef MCFI2C_BASE5
 
-static struct resource mcf_i2c5_resources[] = {
+static const struct resource mcf_i2c5_resources[] = {
 	{
 		.start          = MCFI2C_BASE5,
 		.end            = MCFI2C_BASE5 + MCFI2C_SIZE5 - 1,
@@ -507,7 +507,7 @@ static struct mcf_edma_platform_data mcf_edma_data = {
 	.slavecnt		= ARRAY_SIZE(mcf_edma_map),
 };
 
-static struct resource mcf_edma_resources[] = {
+static const struct resource mcf_edma_resources[] = {
 	{
 		.start		= MCFEDMA_BASE,
 		.end		= MCFEDMA_BASE + MCFEDMA_SIZE - 1,
@@ -560,7 +560,7 @@ static struct mcf_esdhc_platform_data mcf_esdhc_data = {
 	.cd_type = ESDHC_CD_NONE,
 };
 
-static struct resource mcf_esdhc_resources[] = {
+static const struct resource mcf_esdhc_resources[] = {
 	{
 		.start = MCFSDHC_BASE,
 		.end = MCFSDHC_BASE + MCFSDHC_SIZE - 1,
@@ -590,7 +590,7 @@ static struct flexcan_platform_data mcf5441x_flexcan_info = {
 	.clock_frequency = 120000000,
 };
 
-static struct resource mcf5441x_flexcan0_resource[] = {
+static const struct resource mcf5441x_flexcan0_resource[] = {
 	{
 		.start = MCFFLEXCAN_BASE0,
 		.end = MCFFLEXCAN_BASE0 + MCFFLEXCAN_SIZE,

-- 
2.39.5

