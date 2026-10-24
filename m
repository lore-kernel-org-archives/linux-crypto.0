Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.122.197.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792881420;
	b=ycNLeZs0sKRcyV3LC5v4RKepAMMMheVeCQfs5E8de+jM1F2wH0/HBlPo8Duf84LuLCml
	 cb60bH/iRpvRZJJFJOeNhChcufY2L6VM4TPgL6o6FnTscgjlWR753Zye50VZUN1si1/9K
	 scNk88/wKz+u0iqLWMRY+oMyDFMduDPToVF8VHZA3EFuLeUFZrFkH37uExwQCdOCbJ142
	 A6NTO5SowUSCwqs4DsFFf1WmCMf/WWJTyn/mbNHiPvYYBSq/pKYNkUa942bFXjyjxygqi
	 miI1NLaphFrIdWsEaE0RtxKZLT2MIOXUNVzoztf66BhpQ4UxtegkLoEFJ3IUsKqq39Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792881420;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=p2/KMLRLIq2QDZi4sRM028w3JkZv61mDi4EwPZcLOlA=;
	b=vence0f3KpSvY09FjMUcHcOHW61BOFuzVnS0ZeGkIgxtY/fmY4xbuA4HrMeO6fNBYy1+
	 YiUoQpkKUrvK4928OTFpXOlrxEZ4JtOL4YPYx5cSMatAUPj3q945fMkB6nFHxiuCeYeS5
	 yYMccg2OffvZ3fOFo6JHbKP9Bz+gDJSntucyq8YWFzeOaIlZ4nU6ufFYJ1Jc8gnJSf+NC
	 9hJFbAVeLI0dfLTDGePiX+SiRUD1PXzXDx3w3QIK+vRZKKG2jk+slUH0TyXA4ztoKVme3
	 KjjR+tglrbewG+E2XWZdXDK0iapQtSf5EFrQTU4EWWfBz3G2EfJ3Kg7A2RRmBTFwjdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ptudor.net;
	spf=pass smtp.mailfrom=ptudor.net;
	dkim=pass header.d=ptudor.net header.i=@ptudor.net header.a=rsa-sha256 header.s=epistula202610 header.b=DffJ8uY8;
	arc=none smtp.remote-ip=74.122.197.115
Received: from junia.packetexport.com (unknown [74.122.197.115])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 509D2606A322;
	Sat, 24 Oct 2026 22:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 509D2606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ptudor.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ptudor.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ptudor.net header.i=@ptudor.net header.a=rsa-sha256 header.s=epistula202610 header.b=DffJ8uY8
Received: from junia.packetexport.com (unknown [74.122.197.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by junia.packetexport.com (Postfix) with UTF8SMTPSA id 919931AD8B;
	Sat, 24 Oct 2026 22:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ptudor.net;
	s=epistula202610; t=1792881418;
	bh=p2/KMLRLIq2QDZi4sRM028w3JkZv61mDi4EwPZcLOlA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DffJ8uY8n3tfxxAe0kkmNQg+KREJNFq57Pc2we9hiEk3iWoyBfYrjZKsknsvYF9Ln
	 x+9jRrcss+3y3tVIeEUTSSZlktJzKPZ90dOpMnUJpHu1TJYl2t2Z5VPNwzN5Qi2N4a
	 DyX3iLPTmGcG3gTLkAHNnXGlGnaRJonx930wNEwxa75y8kkP0Nt+DlscdEuIeYrAng
	 dmc6vBSmotGZBMK8lDXy9tMpaDdzgBycnjIp6ck+HHtEHz0348q7au4nz/8JN4p7xT
	 /HjUfCMcsDf0UzUKD6d7ud+S0tHgq1vX6sIOKzz3350GPVFK20jBEUJca7KT9cefQh
	 LM0wv0hNPs//g==
From: Patrick Tudor <ptudor@ptudor.net>
Date: Sat, 24 Oct 2026 20:18:23 +0000
Subject: [PATCH 2/3] hwrng: add Microchip RNG90 driver
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261024-rng90-submit-v1-v1-2-e265cfabc9af@ptudor.net>
References: <20261024-rng90-submit-v1-v1-0-e265cfabc9af@ptudor.net>
In-Reply-To: <20261024-rng90-submit-v1-v1-0-e265cfabc9af@ptudor.net>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, Patrick Tudor <ptudor@ptudor.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=18822; i=ptudor@ptudor.net;
 h=from:subject:message-id; bh=6mYwcqEMFT4bQXv8N6WZ/+goyIKtqB/ZRv+AVCo0hJ8=;
 b=owEBiQJ2/ZANAwAKAUJsSqIaQAcoAcsmYgBq3RMNksDH3uNKir8jV/SLvMVqMmjKajWh3cfow
 0hG/G6y+06JAk8EAAEKADkWIQSMT1jvuUVJAiZ9mz5CbEqiGkAHKAUCat0TDRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwwLDMACgkQQmxKohpAByiGfQ/+LoyZilHek90KDis7FKx4lnazGbF+MQo
 WN/Q7RveVaBueQDYrd69SwdiJr7GP4xds8dywPTyXDFSRLADydufAXjju8Z6WGYBzyWVHJSiMmM
 LxNM6uNOtL8DIDQ2YcbhcR0/8cwPheL9B3fXjq/lIz+1FSYoV3n1RU+70/0ztPXJZECsTMg+Vui
 52ygo22fjD5fwWW68pU+SzYHnBSlfLwZmCCwMowiuguuCON7OIePxiw3KYXopvowNlZyx07feNA
 K58maSiaYMyAk+mAAIsyClR4yaq/X/R2a2NYb7Y07IlkDZpTn6SonfcIXPuwofMZ7+r5cn4MME8
 A7MSU4orqsio6pifZ3NQzyPIYdfPb7iNK66iRihHqsteNyUesnW6IHFBDBlfsTC17d1faLD75rQ
 2Jp60h/L83RkUDl/4mdE/aVbTupgcurY4Y7c84oMEZ+vcwkFO7MwDuaFv7DLP+PqpsDT0tPiIWN
 E4USG9V7lQlS1WC6ppBDx7T08Xy3pqxW5INJQkSZiCxRgWzMK+28jRxiZukDgvcnzOd7ic/kZxG
 NA7W+VZuJNKfcZLmIJr9+ZCAgBcac+Pl5H5J14YBA7zGGsoRtAl/vTLGP/Ng7U/CoKW/9AyM92D
 wUXNhA8e+oJC5LaUiIl6osX3KyEk40Yp/N/EW0rF1KilnM2jJgDY=
X-Developer-Key: i=ptudor@ptudor.net; a=openpgp;
 fpr=8C4F58EFB9454902267D9B3E426C4AA21A400728

Add support for the Microchip RNG90 cryptographic random number generator
over I2C.

The driver wakes and identifies the device, frames Info and Random
commands, polls bounded execution deadlines, verifies response lengths and
CRCs, and handles device health and self-test failures without exposing
rejected output.

Use the minimum nonzero hwrng quality because the data sheet specifies
output security strength but does not quantify entropy per output bit. The
value remains adjustable through the hwrng sysfs interface after platform
qualification.

Tested on physical RNG90 hardware through the in-tree hid-cp2112 adapter.

Signed-off-by: Patrick Tudor <ptudor@ptudor.net>
---
 drivers/char/hw_random/Kconfig  |  15 ++
 drivers/char/hw_random/Makefile |   1 +
 drivers/char/hw_random/rng90.c  | 551 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 567 insertions(+)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 1bf5e3f8a..af276d476 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -88,6 +88,21 @@ config HW_RANDOM_ATMEL
 
 	  If unsure, say Y.
 
+config HW_RANDOM_RNG90
+	tristate "Microchip RNG90 I2C random number generator"
+	depends on I2C
+	select CRC16
+	select BITREVERSE
+	help
+	  Support the Microchip RNG90 random number generator on I2C at 0x40.
+	  Command responses are checked for framing, device errors and CRC.
+	  The driver uses the minimum nonzero hwrng entropy estimate because
+	  the device's security strength does not quantify entropy per output
+	  bit. Administrators can raise the estimate after qualification.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called rng90.
+
 config HW_RANDOM_BA431
 	tristate "Silex Insight BA431 Random Number Generator support"
 	depends on HAS_IOMEM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 8fce2aa6c..852848297 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
 obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
 obj-$(CONFIG_HW_RANDOM_AIROHA) += airoha-trng.o
 obj-$(CONFIG_HW_RANDOM_ATMEL) += atmel-rng.o
+obj-$(CONFIG_HW_RANDOM_RNG90) += rng90.o
 obj-$(CONFIG_HW_RANDOM_BA431) += ba431-rng.o
 obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
 obj-$(CONFIG_HW_RANDOM_N2RNG) += n2-rng.o
diff --git a/drivers/char/hw_random/rng90.c b/drivers/char/hw_random/rng90.c
new file mode 100644
index 000000000..ec9ee3e27
--- /dev/null
+++ b/drivers/char/hw_random/rng90.c
@@ -0,0 +1,551 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Microchip RNG90 I2C hardware random number generator, DS40002499A. */
+
+#include <linux/bitrev.h>
+#include <linux/crc16.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/hw_random.h>
+#include <linux/i2c.h>
+#include <linux/ktime.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
+
+#define RNG90_ADDRESS		0x40
+#define RNG90_WORD_RESET		0x00
+#define RNG90_WORD_SLEEP		0x01
+#define RNG90_WORD_COMMAND	0x03
+#define RNG90_OP_INFO		0x30
+#define RNG90_OP_RANDOM		0x16
+#define RNG90_STATUS_SELFTEST	0x07
+#define RNG90_STATUS_HEALTH	0x08
+#define RNG90_STATUS_WAKE		0x11
+#define RNG90_STATUS_COMM		0xff
+#define RNG90_DEVICE_ID		0xd0
+#define RNG90_RANDOM_SIZE		32
+#define RNG90_RANDOM_FILLER	20
+#define RNG90_STATUS_SIZE		4
+#define RNG90_INFO_SIZE		7
+#define RNG90_REPLY_SIZE		(1 + RNG90_RANDOM_SIZE + 2)
+#define RNG90_COMMAND_SIZE	(1 + 7 + RNG90_RANDOM_FILLER)
+
+/*
+ * Latch a fault after this many health or self-test failures without an
+ * intervening verified Random block. Before the latch is set, the next read
+ * performs a sleep/wake so its first Random reruns the self-tests. Only a
+ * verified block resets the count; rebind clears the latch.
+ */
+#define RNG90_HEALTH_STRIKES	3
+
+/*
+ * Table 4-1's wake delay and Table 5-6's Random execution times. Random waits
+ * tEXEC(typ) and then polls, as section 3.4.3 recommends; its deadline is
+ * tEXEC(max) + 25 % + 2 ms, matching the firmware's margin. Info uses a 1 ms
+ * initial delay and a 10 ms deadline to allow for scheduling slack. These
+ * deadlines limit busy polling, not individual adapter transfer timeouts.
+ */
+#define RNG90_WAKE_US			2000
+#define RNG90_POLL_US			1000
+#define RNG90_INFO_TYP_US		1000
+#define RNG90_INFO_DEADLINE_US		10000
+#define RNG90_RANDOM_TYP_US		20200
+#define RNG90_RANDOM_DEADLINE_US	34000
+#define RNG90_FIRST_RANDOM_TYP_US	57000
+#define RNG90_FIRST_RANDOM_DEADLINE_US	92000
+/* Section 3.2.3, step 3: allow a previously started Random to complete. */
+#define RNG90_SETTLE_US			RNG90_FIRST_RANDOM_DEADLINE_US
+
+enum rng90_state {
+	RNG90_UNKNOWN,
+	RNG90_ASLEEP,
+	RNG90_AWAKE,
+};
+
+struct rng90 {
+	struct i2c_client *client;
+	struct hwrng rng;
+	struct mutex lock; /* Protects device transactions, state and buffers. */
+	enum rng90_state state;
+	bool first_random;
+	bool failed;
+	bool suspended;
+	unsigned int strikes; /* Health/self-test failures since a verified block. */
+	u8 command[RNG90_COMMAND_SIZE];
+	u8 reply[RNG90_REPLY_SIZE];
+};
+
+static u16 rng90_crc(const u8 *data, size_t len)
+{
+	return bitrev16(crc16(0, data, len));
+}
+
+static void rng90_wipe(struct rng90 *priv)
+{
+	memzero_explicit(priv->command, sizeof(priv->command));
+	memzero_explicit(priv->reply, sizeof(priv->reply));
+}
+
+static void rng90_invalidate(struct rng90 *priv)
+{
+	priv->state = RNG90_UNKNOWN;
+	priv->first_random = true;
+	rng90_wipe(priv);
+}
+
+static int rng90_write(struct rng90 *priv, const u8 *data, size_t len)
+{
+	int ret = i2c_master_send(priv->client, data, len);
+
+	if (ret < 0)
+		return ret;
+	return ret == len ? 0 : -EPROTO;
+}
+
+static int rng90_word(struct rng90 *priv, u8 word)
+{
+	return rng90_write(priv, &word, sizeof(word));
+}
+
+/*
+ * Errors accepted on a wake write or retried while polling a busy chip:
+ * -ENXIO (standard I2C address NACK), -EREMOTEIO (Pi controllers) and
+ * -ETIMEDOUT (hid-cp2112 reports both NACK and bus timeout this way). None
+ * proves the chip is present. It NACKs while asleep (section 3.2.1) or busy
+ * (section 3.4.3).
+ */
+static bool rng90_nack(int ret)
+{
+	return ret == -ENXIO || ret == -EREMOTEIO || ret == -ETIMEDOUT;
+}
+
+/*
+ * The device is gone: an unplugged USB adapter answers -ENODEV, or -ESHUTDOWN
+ * for the transfer in flight at the disconnect. Nothing is retried or
+ * recovered, and removal of such a device is expected, not worth a warning.
+ */
+static bool rng90_gone(int ret)
+{
+	return ret == -ENODEV || ret == -ESHUTDOWN;
+}
+
+/*
+ * Interpret a CRC-verified four-byte status reply. Mark device verdicts
+ * separately from errno: an adapter may also return -EIO. A Random read may
+ * retry a transport failure once, but a verdict ends that read.
+ */
+static int rng90_status(struct rng90 *priv, u8 status, bool *verdict)
+{
+	struct device *dev = &priv->client->dev;
+
+	switch (status) {
+	case RNG90_STATUS_WAKE:
+		/* A wake reply indicates lost command/result state. */
+		dev_dbg(dev, "wake status in place of a result\n");
+		return -ECONNRESET;
+	case RNG90_STATUS_COMM:
+		dev_warn_ratelimited(dev, "command not received by the chip\n");
+		return -EBADMSG;
+	case RNG90_STATUS_SELFTEST:
+	case RNG90_STATUS_HEALTH:
+		if (verdict)
+			*verdict = true;
+		if (++priv->strikes < RNG90_HEALTH_STRIKES) {
+			dev_warn_ratelimited(dev, "health/self-test failure %#04x, %u of %u\n",
+					     status, priv->strikes,
+					     RNG90_HEALTH_STRIKES);
+		} else {
+			/* Suspend/resume and resynchronization never clear this latch. */
+			priv->failed = true;
+			dev_err(dev, "health/self-test failure %#04x, %u without a verified block; rebind required\n",
+				status, priv->strikes);
+		}
+		return -EIO;
+	default:
+		if (verdict)
+			*verdict = true;
+		dev_err_ratelimited(dev, "unexpected device status %#04x\n",
+				    status);
+		return -EIO;
+	}
+}
+
+static int rng90_receive(struct rng90 *priv, size_t expected, bool *verdict)
+{
+	u8 *reply = priv->reply;
+	size_t count;
+	int ret;
+
+	memzero_explicit(reply, sizeof(priv->reply));
+	ret = i2c_master_recv(priv->client, reply, expected);
+	if (ret < 0)
+		return ret;
+	if (ret != expected)
+		return -EPROTO;
+
+	/* Over-reading a four-byte status reply yields 0xff padding (section 3.3). */
+	count = reply[0];
+	if (count != expected && count != RNG90_STATUS_SIZE)
+		return -EPROTO;
+	if (rng90_crc(reply, count - 2) != get_unaligned_le16(reply + count - 2))
+		return -EBADMSG;
+	if (count != expected)
+		return rng90_status(priv, reply[1], verdict);
+
+	return 0;
+}
+
+static size_t rng90_build_command(u8 *command, u8 opcode)
+{
+	size_t count = 7;
+
+	if (opcode == RNG90_OP_RANDOM)
+		count += RNG90_RANDOM_FILLER;
+	memset(command, 0, RNG90_COMMAND_SIZE);
+	command[0] = RNG90_WORD_COMMAND;
+	command[1] = count;
+	command[2] = opcode;
+	/* Param1, Param2 and all 20 mandatory Random filler bytes are zero. */
+	put_unaligned_le16(rng90_crc(command + 1, count - 2), command + count - 1);
+
+	return count + 1;
+}
+
+static int rng90_execute(struct rng90 *priv, u8 opcode, unsigned int typ_us,
+			 unsigned int deadline_us, size_t reply_size,
+			 bool *verdict)
+{
+	ktime_t deadline;
+	size_t len;
+	int ret;
+
+	if (verdict)
+		*verdict = false;
+
+	/* Reset both FIFO counters before starting a new transaction. */
+	ret = rng90_word(priv, RNG90_WORD_RESET);
+	if (ret)
+		return ret;
+	len = rng90_build_command(priv->command, opcode);
+	ret = rng90_write(priv, priv->command, len);
+	memzero_explicit(priv->command, sizeof(priv->command));
+	if (ret)
+		return ret;
+
+	/*
+	 * The separate write supplies the STOP that starts execution. The chip
+	 * NACKs while busy. hid-cp2112 adds USB status/data exchanges to each poll;
+	 * its transfer timeout can extend elapsed time beyond this deadline.
+	 */
+	deadline = ktime_add_us(ktime_get(), deadline_us);
+	usleep_range(typ_us, typ_us + RNG90_POLL_US);
+	for (;;) {
+		ret = rng90_receive(priv, reply_size, verdict);
+		if (!rng90_nack(ret) || ktime_after(ktime_get(), deadline))
+			return ret;
+		usleep_range(RNG90_POLL_US, 2 * RNG90_POLL_US);
+	}
+}
+
+static int rng90_wake_once(struct rng90 *priv)
+{
+	int ret;
+
+	/* Addressing an asleep chip wakes it; RESET is harmless if awake. */
+	ret = rng90_word(priv, RNG90_WORD_RESET);
+	if (ret && !rng90_nack(ret))
+		return ret;
+	usleep_range(RNG90_WAKE_US, RNG90_WAKE_US + 500);
+
+	/* An acknowledged sleep discards any stale command/result state. */
+	ret = rng90_word(priv, RNG90_WORD_SLEEP);
+	if (ret)
+		return ret;
+
+	/*
+	 * Do not require zero-length writes or I2C_M_IGNORE_NAK. The chip
+	 * ignores bytes following its address during wake (section 3.2.1).
+	 * An adapter may retry and ACK RESET after the chip has woken.
+	 */
+	ret = rng90_word(priv, RNG90_WORD_RESET);
+	if (ret && !rng90_nack(ret))
+		return ret;
+	usleep_range(RNG90_WAKE_US, RNG90_WAKE_US + 500);
+	ret = rng90_receive(priv, RNG90_STATUS_SIZE, NULL);
+	if (ret)
+		return ret;
+	if (priv->reply[1] != RNG90_STATUS_WAKE)
+		return rng90_status(priv, priv->reply[1], NULL);
+
+	return 0;
+}
+
+static int rng90_start(struct rng90 *priv)
+{
+	int attempt, ret = -EIO;
+
+	lockdep_assert_held(&priv->lock);
+	if (priv->failed)
+		return -EIO;
+	if (priv->suspended)
+		return -EHOSTDOWN;
+	if (priv->state == RNG90_AWAKE)
+		return 0;
+
+	for (attempt = 0; attempt < 2; attempt++) {
+		/* Allow a command already in progress to finish (section 3.2.3). */
+		if (attempt)
+			usleep_range(RNG90_SETTLE_US,
+				     RNG90_SETTLE_US + RNG90_POLL_US);
+		ret = rng90_wake_once(priv);
+		if (!ret || priv->failed || rng90_gone(ret))
+			break;
+	}
+	if (ret)
+		goto fail;
+
+	ret = rng90_execute(priv, RNG90_OP_INFO, RNG90_INFO_TYP_US,
+			    RNG90_INFO_DEADLINE_US, RNG90_INFO_SIZE, NULL);
+	if (ret)
+		goto fail;
+	/* Byte 1 of the four-byte Info payload identifies RNG90. */
+	if (priv->reply[2] != RNG90_DEVICE_ID) {
+		ret = -ENODEV;
+		goto fail;
+	}
+	priv->state = RNG90_AWAKE;
+	priv->first_random = true;
+	rng90_wipe(priv);
+	return 0;
+
+fail:
+	rng90_invalidate(priv);
+	return ret;
+}
+
+static void rng90_stop(struct rng90 *priv)
+{
+	int attempt, ret = 0;
+
+	lockdep_assert_held(&priv->lock);
+	if (priv->state == RNG90_ASLEEP)
+		goto out;
+
+	for (attempt = 0; attempt < 2; attempt++) {
+		/*
+		 * An unknown device may be asleep (the first address wakes it) or
+		 * busy, and any state can see a transient transfer failure. Wait
+		 * out the device cases before the second bounded attempt.
+		 */
+		if (attempt)
+			usleep_range(RNG90_SETTLE_US,
+				     RNG90_SETTLE_US + RNG90_POLL_US);
+		ret = rng90_word(priv, RNG90_WORD_SLEEP);
+		if (!ret) {
+			priv->state = RNG90_ASLEEP;
+			goto out;
+		}
+		if (rng90_gone(ret))
+			break;
+	}
+	if (!rng90_gone(ret))
+		dev_warn_ratelimited(&priv->client->dev, "sleep failed: %d\n",
+				     ret);
+	priv->state = RNG90_UNKNOWN;
+out:
+	priv->first_random = true;
+	rng90_wipe(priv);
+}
+
+/* The first Random after a wake also runs the self-tests (Table 5-6, note 1). */
+static int rng90_random(struct rng90 *priv, bool *verdict)
+{
+	if (priv->first_random)
+		return rng90_execute(priv, RNG90_OP_RANDOM,
+				     RNG90_FIRST_RANDOM_TYP_US,
+				     RNG90_FIRST_RANDOM_DEADLINE_US,
+				     RNG90_REPLY_SIZE, verdict);
+	return rng90_execute(priv, RNG90_OP_RANDOM, RNG90_RANDOM_TYP_US,
+			     RNG90_RANDOM_DEADLINE_US, RNG90_REPLY_SIZE,
+			     verdict);
+}
+
+static int rng90_init(struct hwrng *rng)
+{
+	struct rng90 *priv = container_of(rng, struct rng90, rng);
+	int ret;
+
+	mutex_lock(&priv->lock);
+	ret = rng90_start(priv);
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static void rng90_cleanup(struct hwrng *rng)
+{
+	struct rng90 *priv = container_of(rng, struct rng90, rng);
+
+	mutex_lock(&priv->lock);
+	rng90_stop(priv);
+	mutex_unlock(&priv->lock);
+}
+
+static int rng90_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct rng90 *priv = container_of(rng, struct rng90, rng);
+	bool verdict = false;
+	int ret = 0;
+
+	if (!max)
+		return 0;
+	if (!wait) {
+		if (!mutex_trylock(&priv->lock))
+			return 0;
+	} else if (mutex_lock_interruptible(&priv->lock)) {
+		return -ERESTARTSYS;
+	}
+	if (priv->failed) {
+		ret = -EIO;
+		goto out;
+	}
+	if (priv->suspended) {
+		ret = -EHOSTDOWN;
+		goto out;
+	}
+	/* No asynchronous prefetch; a nonblocking read starts no I2C transfers. */
+	if (!wait)
+		goto out;
+	ret = rng90_start(priv);
+	if (ret)
+		goto fail;
+	ret = rng90_random(priv, &verdict);
+	if (ret && !verdict && !rng90_gone(ret)) {
+		/*
+		 * Recover once from transport/framing errors or lost command state.
+		 * An acknowledged Sleep discards stale output; a fresh Random
+		 * supplies the retried result. Never reread the failed response.
+		 * A CRC-verified device verdict is final for this read, and so is
+		 * a vanished device.
+		 */
+		rng90_invalidate(priv);
+		ret = rng90_start(priv);
+		if (!ret)
+			ret = rng90_random(priv, &verdict);
+	}
+	if (ret)
+		goto fail;
+
+	/* Publish nothing until the complete frame and its CRC have passed. */
+	max = min_t(size_t, max, RNG90_RANDOM_SIZE);
+	memcpy(data, priv->reply + 1, max);
+	priv->first_random = false;
+	priv->strikes = 0;
+	rng90_wipe(priv);
+	ret = max;
+	goto out;
+
+fail:
+	rng90_invalidate(priv);
+	if (ret == -ECONNRESET)
+		ret = -EIO;
+	else if (ret == -ESHUTDOWN)
+		ret = -ENODEV;
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int rng90_suspend(struct device *dev)
+{
+	struct rng90 *priv = dev_get_drvdata(dev);
+
+	mutex_lock(&priv->lock);
+	priv->suspended = true;
+	rng90_stop(priv);
+	mutex_unlock(&priv->lock);
+	return 0;
+}
+
+static int rng90_resume(struct device *dev)
+{
+	struct rng90 *priv = dev_get_drvdata(dev);
+
+	mutex_lock(&priv->lock);
+	priv->suspended = false;
+	/* The rail may have been lost; re-identify on the next blocking read. */
+	rng90_invalidate(priv);
+	mutex_unlock(&priv->lock);
+	return 0;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(rng90_pm_ops, rng90_suspend, rng90_resume);
+
+static int rng90_probe(struct i2c_client *client)
+{
+	struct device *dev = &client->dev;
+	struct rng90 *priv;
+	int ret;
+
+	if (client->addr != RNG90_ADDRESS || client->flags & I2C_CLIENT_TEN)
+		return dev_err_probe(dev, -ENODEV, "RNG90 requires 7-bit address 0x40\n");
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return dev_err_probe(dev, -EOPNOTSUPP, "raw I2C transfers are required\n");
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	priv->client = client;
+	mutex_init(&priv->lock);
+	i2c_set_clientdata(client, priv);
+	priv->rng.name = devm_kasprintf(dev, GFP_KERNEL, "rng90-%s", dev_name(dev));
+	if (!priv->rng.name)
+		return -ENOMEM;
+	priv->rng.init = rng90_init;
+	priv->rng.cleanup = rng90_cleanup;
+	priv->rng.read = rng90_read;
+	/* Security strength does not establish entropy density. */
+	priv->rng.quality = 1;
+
+	/* Identify even when a higher-quality hwrng is already selected. */
+	ret = rng90_init(&priv->rng);
+	if (ret)
+		return dev_err_probe(dev, ret, "wake/identity check failed\n");
+	rng90_cleanup(&priv->rng);
+	return devm_hwrng_register(dev, &priv->rng);
+}
+
+static void rng90_shutdown(struct i2c_client *client)
+{
+	rng90_suspend(&client->dev);
+}
+
+static const struct of_device_id rng90_of_match[] = {
+	{ .compatible = "microchip,rng90" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, rng90_of_match);
+
+static const struct i2c_device_id rng90_id[] = {
+	{ "rng90" },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, rng90_id);
+
+static struct i2c_driver rng90_driver = {
+	.driver = {
+		.name = "rng90",
+		.of_match_table = rng90_of_match,
+		.pm = pm_sleep_ptr(&rng90_pm_ops),
+	},
+	.probe = rng90_probe,
+	.shutdown = rng90_shutdown,
+	.id_table = rng90_id,
+};
+module_i2c_driver(rng90_driver);
+
+MODULE_AUTHOR("Patrick Tudor <ptudor@ptudor.net>");
+MODULE_DESCRIPTION("Microchip RNG90 I2C hardware random number generator");
+MODULE_LICENSE("GPL");

-- 
2.56.0

