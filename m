Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.122.197.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792881431;
	b=Mc4QiLFT+jSctVJmLJ55Zue8ykJI9BA8pcZHNqqobkG+LTtngwK+AMyT5+aBV5xcD/M6
	 eonU4fUbqcLDiM63aumwTnK2PwZLBEnYbZnxANleFd2OyqRbejf0PFIK1I4SHOgMTgZMX
	 TG7222b4BNTMCNngppFXjL+AonCBHAFqa7mRBGjR626SMGXUQVmfr8YLFbcHw6b0vHsHY
	 4VtMf2C63QjxS2Sgkz+5WpR0A1i1nsAFn4PKi1x11taQvD3/ttZLxlG2b6vmrpTUnEFf8
	 VEAwf4i0O3/BHN96Ui+MC+rfoQHSMR+37HRX+KO2DXmt5XevS5FTISe161gRCpLdn0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792881431;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=VVKD3na+bVs9ZuO7FDO8zkzt1hdPHTP6hO5IT1Igttk=;
	b=S38zl/O0/nCAVhNai3X+xmB0bmnlXi32fMGAJBrLS8H0JG+mqjRV0u7a+prYBXHLoRTq
	 NC19uwtF+ZixTvpm+VoWXwamvgkhvrRQ+JCnT/EUptGDG4tyVuiPP9jo37Sy87/pgeE3p
	 ggq77kft88/4jwCw+ij/mHXdEB+6YqkmJoi0E6hWjk5gp98PvMHET35zNdTbwY7vKPCOE
	 Td3GycTJlDxW0dHxdWP6iHFiG39mcX41ahMi6M2lLFita5RyHCVdRXiPrEQs8ka5GJE32
	 bbkM7EaSaPgtce1RLbYrlpnmJkGCz6JVF3h0HVTVKzheUQ935E1cTYjC5iogQBEtjKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ptudor.net;
	spf=pass smtp.mailfrom=ptudor.net;
	dkim=pass header.d=ptudor.net header.i=@ptudor.net header.a=rsa-sha256 header.s=epistula202610 header.b=uGe31qGo;
	arc=none smtp.remote-ip=74.122.197.115
Received: from junia.packetexport.com (unknown [74.122.197.115])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 645B0606A31B;
	Sat, 24 Oct 2026 22:37:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 645B0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ptudor.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ptudor.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ptudor.net header.i=@ptudor.net header.a=rsa-sha256 header.s=epistula202610 header.b=uGe31qGo
Received: from junia.packetexport.com (unknown [74.122.197.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by junia.packetexport.com (Postfix) with UTF8SMTPSA id 8F3FF1AA5E;
	Sat, 24 Oct 2026 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ptudor.net;
	s=epistula202610; t=1792881429;
	bh=VVKD3na+bVs9ZuO7FDO8zkzt1hdPHTP6hO5IT1Igttk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uGe31qGofRhqtie5KJ8wRb7wHTeGZY9Q6shj4e3qSScjLgXVTzpXcjzH7b0OYuwRY
	 S49gYPjJQLrTS6DzAPHsV3UrDr6LAGm9r59AXQgeTBbqMuNgrJodO3MNEYwBQ2egAB
	 CNtVFb10AvoLXiNPX4PCo7huWf7ImzalwtX6y1i/Yma3K/INlGx50mswrg6TkMewht
	 wz7d84629Yw7rk9V5KUZcGyS2J0AF9aLOU4pU1uRCc56FDzYLc68SSav2ItohXglwn
	 hKpky83Q8jYRaZZ9hrPtfm+WpOTvp2DHJ6yku/okdGaoQQp6qqEn77ciy3KP3TQgpm
	 9u4hnfZg6q4cQ==
From: Patrick Tudor <ptudor@ptudor.net>
Date: Sat, 24 Oct 2026 20:18:24 +0000
Subject: [PATCH 3/3] hwrng: rng90: add KUnit tests
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
Message-Id: <20261024-rng90-submit-v1-v1-3-e265cfabc9af@ptudor.net>
References: <20261024-rng90-submit-v1-v1-0-e265cfabc9af@ptudor.net>
In-Reply-To: <20261024-rng90-submit-v1-v1-0-e265cfabc9af@ptudor.net>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, Patrick Tudor <ptudor@ptudor.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=31804; i=ptudor@ptudor.net;
 h=from:subject:message-id; bh=EEvp2ClZsAHvrkgt6KE+mNVAvdKDRKkKR1Nhb7GEqfQ=;
 b=owEBiQJ2/ZANAwAKAUJsSqIaQAcoAcsmYgBq3RMN33lEpCix13iwbbKG1Tuux5FK69nqUVW8P
 szYKZkEZuiJAk8EAAEKADkWIQSMT1jvuUVJAiZ9mz5CbEqiGkAHKAUCat0TDRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwwLDMACgkQQmxKohpAByhLAxAAg7MLi3LFz6flvCzuJRLJlEgLzlzCOcP
 omI8pXVxfTGlSlL3Ybfo9iDJXjK4ayunTIPCsW6W0wQ0JKwa9PbzxY4elon5A+1+3UHCYFOrP0V
 +2InovlT+u4ubxu6OV2QhDJDdRosMZwN/g1q0wCdwnmbbrz6czDIrjhJegeu3yD4Q2uQ/UqV8IM
 YDxrfKiTQKKL+s9IgOHsqyR/y9Hs50D1fXUFMeRLb3IUtja/6RmwVguVzytstJwqcOBT9/Xmi/P
 UzoMV1ad2DXCfkAn1oKOKFfJmx1kwxhgLfJbJ7NoSP6Jvja+/7A+QNrtr0hVkioEe9bdx7xSNjn
 30qQPRp3gbm0rGSAgt2EPD3oV1EPjAEGDq38yNEoKz205AerMw7MipO7h4ITOQItdxt8tdMf1Rr
 HwmWIDCndCT1vEs220xxcF6G413ZnZcFZkUxBUju/fcIWpnG/d8q9EcHytbyrr6YJu+KRVVljmQ
 u+FHZjIb1dDeKk0Tsu2Hce+LV2jqIhOoFGmL+WtHQYh39WwwnzH5ceY8GFA+W7MK/+PpjPrYzUp
 cFmLNTTjXCm6pvAW4gCgEqAwXSekSHeSzvAxVnXY9RohSxlJ1Id6hqD05Fa7r740BlTHYZP/Dgn
 23pObilL7Mv98it0t0cQmwzuND9/pKGTvLRG94hGpZop5zIXCf1A=
X-Developer-Key: i=ptudor@ptudor.net; a=openpgp;
 fpr=8C4F58EFB9454902267D9B3E426C4AA21A400728

Exercise the RNG90 driver through the I2C core with a scripted adapter.
The 32 cases cover published CRC vectors, exact command framing, wake and
busy behavior, response validation, bounded recovery, health-failure
latching, nonblocking reads, suspend and resume, cleanup, and device
removal.

Keep the tests built-in-only so their deterministic fixture data can never
be registered with the hwrng core.

Signed-off-by: Patrick Tudor <ptudor@ptudor.net>
---
 drivers/char/hw_random/Kconfig       |  11 +
 drivers/char/hw_random/rng90-kunit.c | 820 +++++++++++++++++++++++++++++++++++
 drivers/char/hw_random/rng90.c       |   4 +
 3 files changed, 835 insertions(+)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index af276d476..e0e9eaa44 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -103,6 +103,17 @@ config HW_RANDOM_RNG90
 	  To compile this driver as a module, choose M here: the module
 	  will be called rng90.
 
+config HW_RANDOM_RNG90_KUNIT_TEST
+	bool "KUnit tests for the RNG90 driver" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y && HW_RANDOM_RNG90=y
+	default KUNIT_ALL_TESTS
+	help
+	  Exercise the real driver against a scripted I2C adapter, without
+	  RNG90 hardware.
+	  Tests cover command framing, CRC validation and polling behavior.
+	  They also cover recovery, health failures, and suspend and resume.
+	  No predictable test data is registered with the hwrng core.
+
 config HW_RANDOM_BA431
 	tristate "Silex Insight BA431 Random Number Generator support"
 	depends on HAS_IOMEM
diff --git a/drivers/char/hw_random/rng90-kunit.c b/drivers/char/hw_random/rng90-kunit.c
new file mode 100644
index 000000000..f6daffb2e
--- /dev/null
+++ b/drivers/char/hw_random/rng90-kunit.c
@@ -0,0 +1,820 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Included by rng90.c only for built-in KUnit tests. */
+
+#include <kunit/test.h>
+#include <linux/limits.h>
+
+static const u8 rng90_test_reset[] = { 0x00 };
+static const u8 rng90_test_sleep[] = { 0x01 };
+static const u8 rng90_test_wake[] = { 0x04, 0x11, 0x33, 0x43 };
+static const u8 rng90_test_info_command[] = {
+	0x03, 0x07, 0x30, 0x00, 0x00, 0x00, 0x03, 0x5d,
+};
+
+static const u8 rng90_test_info_reply[] = {
+	0x07, 0x00, 0xd0, 0x20, 0x10, 0xac, 0x35,
+};
+
+static const u8 rng90_test_random_command[] = {
+	0x03, 0x1b, 0x16, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x7d, 0xe0,
+};
+
+static const u8 rng90_test_random_reply[] = {
+	0x23, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
+	0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e,
+	0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16,
+	0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e,
+	0x1f, 0x70, 0xfa,
+};
+
+/* A busy step NACKs every matching poll until the driver moves on. */
+#define RNG90_TEST_BUSY		UINT_MAX
+
+struct rng90_test_step {
+	bool read;
+	const u8 *bytes;
+	size_t len;
+	int result;
+	unsigned int repeat;
+	unsigned int hits;
+};
+
+struct rng90_test_context {
+	struct kunit *test;
+	struct i2c_adapter adapter;
+	struct i2c_client *client;
+	struct rng90 priv;
+	struct rng90_test_step steps[48];
+	unsigned int count;
+	unsigned int next;
+};
+
+static bool rng90_test_matches(const struct rng90_test_step *step,
+			       const struct i2c_msg *msg)
+{
+	if (msg->flags != (step->read ? I2C_M_RD : 0) || msg->len != step->len)
+		return false;
+	return step->read || !memcmp(msg->buf, step->bytes, step->len);
+}
+
+static int rng90_test_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
+			   int num)
+{
+	struct rng90_test_context *ctx = adapter->algo_data;
+	struct rng90_test_step *step;
+	struct kunit *test = ctx->test;
+
+	if (num != 1 || ctx->next >= ctx->count)
+		goto unexpected;
+	step = &ctx->steps[ctx->next];
+	if (step->repeat == RNG90_TEST_BUSY && step->hits &&
+	    !rng90_test_matches(step, msgs)) {
+		/* The driver stopped polling; the next step is due. */
+		if (++ctx->next >= ctx->count)
+			goto unexpected;
+		step = &ctx->steps[ctx->next];
+	}
+	KUNIT_EXPECT_EQ(test, msgs[0].addr, RNG90_ADDRESS);
+	KUNIT_EXPECT_EQ(test, msgs[0].flags, step->read ? I2C_M_RD : 0);
+	KUNIT_EXPECT_EQ(test, msgs[0].len, step->len);
+	if (msgs[0].len != step->len)
+		return -EIO;
+	if (!step->read)
+		KUNIT_EXPECT_MEMEQ(test, msgs[0].buf, step->bytes, step->len);
+	else if (step->result == 1)
+		memcpy(msgs[0].buf, step->bytes, step->len);
+	if (++step->hits == step->repeat)
+		ctx->next++;
+
+	return step->result;
+
+unexpected:
+	KUNIT_FAIL(test, "unexpected I2C transfer");
+	return -EIO;
+}
+
+static u32 rng90_test_functionality(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C;
+}
+
+static const struct i2c_algorithm rng90_test_algorithm = {
+	.master_xfer = rng90_test_xfer,
+	.functionality = rng90_test_functionality,
+};
+
+static int rng90_test_init(struct kunit *test)
+{
+	struct rng90_test_context *ctx;
+	int ret;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	test->priv = ctx;
+	ctx->test = test;
+	ctx->adapter.owner = THIS_MODULE;
+	ctx->adapter.algo = &rng90_test_algorithm;
+	ctx->adapter.algo_data = ctx;
+	strscpy(ctx->adapter.name, "rng90-kunit", sizeof(ctx->adapter.name));
+	ret = i2c_add_adapter(&ctx->adapter);
+	if (ret)
+		return ret;
+	ctx->client = i2c_new_dummy_device(&ctx->adapter, RNG90_ADDRESS);
+	if (IS_ERR(ctx->client)) {
+		ret = PTR_ERR(ctx->client);
+		i2c_del_adapter(&ctx->adapter);
+		return ret;
+	}
+	ctx->priv.client = ctx->client;
+	mutex_init(&ctx->priv.lock);
+	i2c_set_clientdata(ctx->client, &ctx->priv);
+	/* Never register this predictable test source with the hwrng core. */
+	return 0;
+}
+
+/* Verify the script was consumed, allowing a final busy step at the deadline. */
+static void rng90_test_settled(struct rng90_test_context *ctx)
+{
+	if (ctx->next < ctx->count &&
+	    ctx->steps[ctx->next].repeat == RNG90_TEST_BUSY &&
+	    ctx->steps[ctx->next].hits)
+		ctx->next++;
+	KUNIT_EXPECT_EQ(ctx->test, ctx->next, ctx->count);
+}
+
+static void rng90_test_exit(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+
+	rng90_test_settled(ctx);
+	i2c_unregister_device(ctx->client);
+	i2c_del_adapter(&ctx->adapter);
+}
+
+/* Verify the previous script was consumed before starting another. */
+static void rng90_test_restart(struct rng90_test_context *ctx)
+{
+	rng90_test_settled(ctx);
+	memset(ctx->steps, 0, sizeof(ctx->steps));
+	ctx->count = 0;
+	ctx->next = 0;
+}
+
+static void rng90_test_add(struct rng90_test_context *ctx, bool read,
+			   const u8 *bytes, size_t len, int result)
+{
+	struct rng90_test_step *step;
+
+	KUNIT_ASSERT_LT(ctx->test, ctx->count, ARRAY_SIZE(ctx->steps));
+	step = &ctx->steps[ctx->count++];
+	step->read = read;
+	step->bytes = bytes;
+	step->len = len;
+	step->result = result;
+	step->repeat = 1;
+	step->hits = 0;
+}
+
+/* NACK a read of len bytes repeat times. */
+static void rng90_test_add_busy(struct rng90_test_context *ctx, size_t len,
+				int nack, unsigned int repeat)
+{
+	rng90_test_add(ctx, true, NULL, len, nack);
+	ctx->steps[ctx->count - 1].repeat = repeat;
+}
+
+static void rng90_test_start_script(struct rng90_test_context *ctx, int wake_ret)
+{
+	rng90_test_add(ctx, false, rng90_test_reset, 1, wake_ret);
+	rng90_test_add(ctx, false, rng90_test_sleep, 1, 1);
+	rng90_test_add(ctx, false, rng90_test_reset, 1, wake_ret);
+	rng90_test_add(ctx, true, rng90_test_wake, 4, 1);
+	rng90_test_add(ctx, false, rng90_test_reset, 1, 1);
+	rng90_test_add(ctx, false, rng90_test_info_command, 8, 1);
+	rng90_test_add(ctx, true, rng90_test_info_reply, 7, 1);
+}
+
+static void rng90_test_random_script(struct rng90_test_context *ctx,
+				     const u8 *reply, int read_ret)
+{
+	rng90_test_add(ctx, false, rng90_test_reset, 1, 1);
+	rng90_test_add(ctx, false, rng90_test_random_command, 28, 1);
+	rng90_test_add(ctx, true, reply, 35, read_ret);
+}
+
+/* Script busy NACKs for Random, followed by an optional reply. */
+static void rng90_test_random_busy_script(struct rng90_test_context *ctx,
+					  int nack, unsigned int busy,
+					  const u8 *reply)
+{
+	rng90_test_add(ctx, false, rng90_test_reset, 1, 1);
+	rng90_test_add(ctx, false, rng90_test_random_command, 28, 1);
+	rng90_test_add_busy(ctx, 35, nack, busy);
+	if (reply)
+		rng90_test_add(ctx, true, reply, 35, 1);
+}
+
+/* A four-byte status reply with the 0xff padding returned by an over-read. */
+static void rng90_test_status_reply(u8 *reply, u8 status)
+{
+	memset(reply, 0xff, RNG90_REPLY_SIZE);
+	reply[0] = RNG90_STATUS_SIZE;
+	reply[1] = status;
+	put_unaligned_le16(rng90_crc(reply, 2), reply + 2);
+}
+
+static void rng90_test_wiped(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 zero[RNG90_REPLY_SIZE] = { };
+
+	KUNIT_EXPECT_MEMEQ(test, ctx->priv.command, zero, sizeof(ctx->priv.command));
+	KUNIT_EXPECT_MEMEQ(test, ctx->priv.reply, zero, sizeof(ctx->priv.reply));
+}
+
+static void rng90_crc_vectors_test(struct kunit *test)
+{
+	static const u8 info[] = { 0x07, 0x30, 0x01, 0x00, 0x00 };
+	static const u8 text[] = "MICROCHIPTECHNOLOGY";
+
+	/* Independent published vectors: DS40002499A section 5.4. */
+	KUNIT_EXPECT_EQ(test, rng90_crc(info, sizeof(info)), 0xd700);
+	KUNIT_EXPECT_EQ(test, rng90_crc(text, sizeof(text) - 1), 0xfee3);
+	KUNIT_EXPECT_EQ(test, rng90_crc(rng90_test_wake, 2), 0x4333);
+}
+
+static void rng90_command_vectors_test(struct kunit *test)
+{
+	u8 command[RNG90_COMMAND_SIZE];
+
+	KUNIT_EXPECT_EQ(test, rng90_build_command(command, RNG90_OP_RANDOM), 28);
+	KUNIT_EXPECT_MEMEQ(test, command, rng90_test_random_command, 28);
+	KUNIT_EXPECT_EQ(test, rng90_build_command(command, RNG90_OP_INFO), 8);
+	KUNIT_EXPECT_MEMEQ(test, command, rng90_test_info_command, 8);
+}
+
+static void rng90_wake_nack_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+
+	rng90_test_start_script(ctx, -ENXIO);
+	KUNIT_EXPECT_EQ(test, rng90_init(&ctx->priv.rng), 0);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_AWAKE);
+	KUNIT_EXPECT_TRUE(test, ctx->priv.first_random);
+	rng90_test_wiped(test);
+}
+
+static void rng90_cp2112_wake_timeout_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+
+	rng90_test_start_script(ctx, -ETIMEDOUT);
+	KUNIT_EXPECT_EQ(test, rng90_init(&ctx->priv.rng), 0);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_AWAKE);
+	KUNIT_EXPECT_TRUE(test, ctx->priv.first_random);
+}
+
+static void rng90_wake_adapter_retry_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+
+	rng90_test_start_script(ctx, 1);
+	KUNIT_EXPECT_EQ(test, rng90_init(&ctx->priv.rng), 0);
+}
+
+/* A vanished device ends the wake loop after one attempt. */
+static void rng90_vanished_wake_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+
+	rng90_test_add(ctx, false, rng90_test_reset, 1, -ENODEV);
+	KUNIT_EXPECT_EQ(test, rng90_init(&ctx->priv.rng), -ENODEV);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_UNKNOWN);
+	rng90_test_wiped(test);
+}
+
+static void rng90_absent_bounded_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		rng90_test_add(ctx, false, rng90_test_reset, 1, -ENXIO);
+		rng90_test_add(ctx, false, rng90_test_sleep, 1, -ENXIO);
+	}
+	KUNIT_EXPECT_EQ(test, rng90_init(&ctx->priv.rng), -ENXIO);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_UNKNOWN);
+	rng90_test_wiped(test);
+}
+
+static void rng90_wake_requires_valid_reply_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 bad_wake[] = { 0x04, 0x11, 0x33, 0x42 };
+	int i;
+
+	/* Accepting a bridge wake timeout must not bypass wake validation. */
+	for (i = 0; i < 2; i++) {
+		rng90_test_add(ctx, false, rng90_test_reset, 1, -ETIMEDOUT);
+		rng90_test_add(ctx, false, rng90_test_sleep, 1, 1);
+		rng90_test_add(ctx, false, rng90_test_reset, 1, -ETIMEDOUT);
+		rng90_test_add(ctx, true, bad_wake, sizeof(bad_wake), 1);
+	}
+	KUNIT_EXPECT_EQ(test, rng90_init(&ctx->priv.rng), -EBADMSG);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_UNKNOWN);
+	rng90_test_wiped(test);
+}
+
+static void rng90_identity_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 wrong[7];
+
+	memcpy(wrong, rng90_test_info_reply, sizeof(wrong));
+	wrong[2] = 0xd1;
+	put_unaligned_le16(rng90_crc(wrong, 5), wrong + 5);
+	rng90_test_start_script(ctx, -ENXIO);
+	ctx->steps[ctx->count - 1].bytes = wrong;
+	KUNIT_EXPECT_EQ(test, rng90_init(&ctx->priv.rng), -ENODEV);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_UNKNOWN);
+	rng90_test_wiped(test);
+}
+
+static void rng90_info_busy_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+
+	rng90_test_add(ctx, false, rng90_test_reset, 1, -ENXIO);
+	rng90_test_add(ctx, false, rng90_test_sleep, 1, 1);
+	rng90_test_add(ctx, false, rng90_test_reset, 1, -ENXIO);
+	rng90_test_add(ctx, true, rng90_test_wake, 4, 1);
+	rng90_test_add(ctx, false, rng90_test_reset, 1, 1);
+	rng90_test_add(ctx, false, rng90_test_info_command, 8, 1);
+	rng90_test_add_busy(ctx, 7, -ENXIO, 2);
+	rng90_test_add(ctx, true, rng90_test_info_reply, 7, 1);
+	KUNIT_EXPECT_EQ(test, rng90_init(&ctx->priv.rng), 0);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_AWAKE);
+	rng90_test_wiped(test);
+}
+
+static void rng90_random_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 output[40];
+	u8 untouched[8];
+
+	ctx->priv.state = RNG90_AWAKE;
+	ctx->priv.first_random = true;
+	memset(output, 0xa5, sizeof(output));
+	memset(untouched, 0xa5, sizeof(untouched));
+	rng90_test_random_script(ctx, rng90_test_random_reply, 1);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), 32);
+	KUNIT_EXPECT_MEMEQ(test, output, rng90_test_random_reply + 1, 32);
+	KUNIT_EXPECT_MEMEQ(test, output + 32, untouched, sizeof(untouched));
+	KUNIT_EXPECT_FALSE(test, ctx->priv.first_random);
+	rng90_test_wiped(test);
+}
+
+static void rng90_small_buffer_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 output[8] = { };
+	u8 zero[4] = { };
+
+	ctx->priv.state = RNG90_AWAKE;
+	rng90_test_random_script(ctx, rng90_test_random_reply, 1);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, 4, true), 4);
+	KUNIT_EXPECT_MEMEQ(test, output, rng90_test_random_reply + 1, 4);
+	KUNIT_EXPECT_MEMEQ(test, output + 4, zero, 4);
+	rng90_test_wiped(test);
+}
+
+static void rng90_busy_poll_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	/* The I2C core, the Raspberry Pi controllers and hid-cp2112. */
+	static const int nacks[] = { -ENXIO, -EREMOTEIO, -ETIMEDOUT };
+	u8 output[32];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nacks); i++) {
+		ctx->priv.state = RNG90_AWAKE;
+		ctx->priv.first_random = false;
+		rng90_test_random_busy_script(ctx, nacks[i], 3, rng90_test_random_reply);
+		KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), 32);
+		KUNIT_EXPECT_MEMEQ(test, output, rng90_test_random_reply + 1, 32);
+		KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_AWAKE);
+		rng90_test_wiped(test);
+		rng90_test_restart(ctx);
+	}
+}
+
+static void rng90_busy_deadline_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 output[32], untouched[32];
+	ktime_t start;
+	s64 elapsed;
+
+	ctx->priv.state = RNG90_AWAKE;
+	ctx->priv.first_random = false;
+	memset(output, 0xa5, sizeof(output));
+	memset(untouched, 0xa5, sizeof(untouched));
+	/* Still busy at the deadline, and again after resynchronization. */
+	rng90_test_random_busy_script(ctx, -ETIMEDOUT, RNG90_TEST_BUSY, NULL);
+	rng90_test_start_script(ctx, -ETIMEDOUT);
+	rng90_test_random_busy_script(ctx, -ETIMEDOUT, RNG90_TEST_BUSY, NULL);
+	start = ktime_get();
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), -ETIMEDOUT);
+	elapsed = ktime_ms_delta(ktime_get(), start);
+	/* The subsequent-Random deadline, then the first-Random one: 34 + 92 ms. */
+	KUNIT_EXPECT_GE(test, elapsed, 126);
+	KUNIT_EXPECT_MEMEQ(test, output, untouched, sizeof(output));
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_UNKNOWN);
+	KUNIT_EXPECT_TRUE(test, ctx->priv.first_random);
+	KUNIT_EXPECT_FALSE(test, ctx->priv.failed);
+	rng90_test_wiped(test);
+}
+
+/* A device verdict ends the read without changing the caller's buffer. */
+static void rng90_rejected_read(struct kunit *test, const u8 *reply, int read_ret,
+				int expected)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 output[32], untouched[32];
+
+	ctx->priv.state = RNG90_AWAKE;
+	memset(output, 0xa5, sizeof(output));
+	memset(untouched, 0xa5, sizeof(untouched));
+	rng90_test_random_script(ctx, reply, read_ret);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), expected);
+	KUNIT_EXPECT_MEMEQ(test, output, untouched, sizeof(output));
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_UNKNOWN);
+	KUNIT_EXPECT_TRUE(test, ctx->priv.first_random);
+	rng90_test_wiped(test);
+}
+
+/* A repeated transport failure is returned after one recovery attempt. */
+static void rng90_rejected_twice(struct kunit *test, const u8 *reply, int read_ret,
+				 int expected)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 output[32], untouched[32];
+
+	ctx->priv.state = RNG90_AWAKE;
+	memset(output, 0xa5, sizeof(output));
+	memset(untouched, 0xa5, sizeof(untouched));
+	rng90_test_random_script(ctx, reply, read_ret);
+	rng90_test_start_script(ctx, -ENXIO);
+	rng90_test_random_script(ctx, reply, read_ret);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), expected);
+	KUNIT_EXPECT_MEMEQ(test, output, untouched, sizeof(output));
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_UNKNOWN);
+	KUNIT_EXPECT_TRUE(test, ctx->priv.first_random);
+	rng90_test_wiped(test);
+}
+
+static void rng90_crc_failure_test(struct kunit *test)
+{
+	u8 reply[35];
+
+	memcpy(reply, rng90_test_random_reply, sizeof(reply));
+	reply[17] ^= 0x01;
+	rng90_rejected_twice(test, reply, 1, -EBADMSG);
+}
+
+static void rng90_resync_recovery_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 reply[35], output[32];
+
+	memcpy(reply, rng90_test_random_reply, sizeof(reply));
+	reply[17] ^= 0x01;
+	ctx->priv.state = RNG90_AWAKE;
+	/* Recover from one damaged frame with sleep, wake, Info and a fresh Random. */
+	rng90_test_random_script(ctx, reply, 1);
+	rng90_test_start_script(ctx, -ENXIO);
+	rng90_test_random_script(ctx, rng90_test_random_reply, 1);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), 32);
+	KUNIT_EXPECT_MEMEQ(test, output, rng90_test_random_reply + 1, sizeof(output));
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_AWAKE);
+	KUNIT_EXPECT_FALSE(test, ctx->priv.failed);
+	rng90_test_wiped(test);
+}
+
+static void rng90_transport_eio_recovery_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 output[32];
+
+	ctx->priv.state = RNG90_AWAKE;
+	/* An adapter's generic I/O failure is transport, not a chip verdict. */
+	rng90_test_random_script(ctx, rng90_test_random_reply, -EIO);
+	rng90_test_start_script(ctx, -ENXIO);
+	rng90_test_random_script(ctx, rng90_test_random_reply, 1);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), 32);
+	KUNIT_EXPECT_MEMEQ(test, output, rng90_test_random_reply + 1, sizeof(output));
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_AWAKE);
+	rng90_test_wiped(test);
+}
+
+/*
+ * The transfer in flight at a USB disconnect fails with -ESHUTDOWN: no
+ * recovery attempt, nothing published, -ENODEV to the caller.
+ */
+static void rng90_vanished_read_test(struct kunit *test)
+{
+	rng90_rejected_read(test, rng90_test_random_reply, -ESHUTDOWN, -ENODEV);
+}
+
+static void rng90_corrupt_status_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 reply[35];
+
+	rng90_test_status_reply(reply, RNG90_STATUS_HEALTH);
+	put_unaligned_le16(rng90_crc(reply, 2) ^ 1, reply + 2);
+	rng90_rejected_twice(test, reply, 1, -EBADMSG);
+	/* A corrupted frame is rejected before its status can be trusted. */
+	KUNIT_EXPECT_FALSE(test, ctx->priv.failed);
+	KUNIT_EXPECT_EQ(test, ctx->priv.strikes, 0U);
+}
+
+static void rng90_count_failure_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	static const u8 counts[] = { 0, 3, 5, 34, 36, 255 };
+	u8 reply[35];
+	int i;
+
+	memcpy(reply, rng90_test_random_reply, sizeof(reply));
+	for (i = 0; i < ARRAY_SIZE(counts); i++) {
+		reply[0] = counts[i];
+		rng90_rejected_twice(test, reply, 1, -EPROTO);
+		rng90_test_restart(ctx);
+	}
+}
+
+static void rng90_short_read_test(struct kunit *test)
+{
+	rng90_rejected_twice(test, rng90_test_random_reply, 0, -EPROTO);
+}
+
+static void rng90_short_write_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 output[32] = { }, zero[32] = { };
+
+	ctx->priv.state = RNG90_AWAKE;
+	rng90_test_add(ctx, false, rng90_test_reset, 1, 1);
+	rng90_test_add(ctx, false, rng90_test_random_command, 28, 0);
+	rng90_test_start_script(ctx, -ENXIO);
+	rng90_test_add(ctx, false, rng90_test_reset, 1, 1);
+	rng90_test_add(ctx, false, rng90_test_random_command, 28, 0);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), -EPROTO);
+	KUNIT_EXPECT_MEMEQ(test, output, zero, sizeof(output));
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_UNKNOWN);
+	rng90_test_wiped(test);
+}
+
+static void rng90_status_is_not_entropy_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	/* Success, parse error, execution error and an unknown code. */
+	static const u8 statuses[] = { 0x00, 0x03, 0x0f, 0x55 };
+	u8 reply[35];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(statuses); i++) {
+		rng90_test_status_reply(reply, statuses[i]);
+		rng90_rejected_read(test, reply, 1, -EIO);
+		KUNIT_EXPECT_FALSE(test, ctx->priv.failed);
+		KUNIT_EXPECT_EQ(test, ctx->priv.strikes, 0U);
+		rng90_test_restart(ctx);
+	}
+}
+
+static void rng90_transient_status_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	/* A wake group or a rejected command where a result was due. */
+	static const u8 statuses[] = { RNG90_STATUS_WAKE, RNG90_STATUS_COMM };
+	static const int reported[] = { -EIO, -EBADMSG };
+	u8 reply[35], output[32];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(statuses); i++) {
+		rng90_test_status_reply(reply, statuses[i]);
+		ctx->priv.state = RNG90_AWAKE;
+		rng90_test_random_script(ctx, reply, 1);
+		rng90_test_start_script(ctx, -ENXIO);
+		rng90_test_random_script(ctx, rng90_test_random_reply, 1);
+		KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), 32);
+		KUNIT_EXPECT_MEMEQ(test, output, rng90_test_random_reply + 1, 32);
+		rng90_test_restart(ctx);
+		rng90_rejected_twice(test, reply, 1, reported[i]);
+		KUNIT_EXPECT_FALSE(test, ctx->priv.failed);
+		KUNIT_EXPECT_EQ(test, ctx->priv.strikes, 0U);
+		rng90_test_restart(ctx);
+	}
+}
+
+static void rng90_latched_failure(struct kunit *test, u8 status)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 reply[35], output[32] = { };
+	unsigned int i;
+
+	rng90_test_status_reply(reply, status);
+	for (i = 1; i <= RNG90_HEALTH_STRIKES; i++) {
+		/* Each failure requires a sleep/wake before the next Random. */
+		if (i == 1)
+			ctx->priv.state = RNG90_AWAKE;
+		else
+			rng90_test_start_script(ctx, -ENXIO);
+		rng90_test_random_script(ctx, reply, 1);
+		KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true),
+				-EIO);
+		KUNIT_EXPECT_EQ(test, ctx->priv.strikes, i);
+		KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_UNKNOWN);
+		if (i < RNG90_HEALTH_STRIKES)
+			KUNIT_EXPECT_FALSE(test, ctx->priv.failed);
+		else
+			KUNIT_EXPECT_TRUE(test, ctx->priv.failed);
+		rng90_test_restart(ctx);
+	}
+	/* The latch blocks reads and init; suspend may still send Sleep. */
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), -EIO);
+	KUNIT_EXPECT_EQ(test, rng90_init(&ctx->priv.rng), -EIO);
+	/* Model an awake chip after a verdict, despite the driver's unknown state. */
+	rng90_test_add(ctx, false, rng90_test_sleep, 1, 1);
+	KUNIT_EXPECT_EQ(test, rng90_suspend(&ctx->client->dev), 0);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_ASLEEP);
+	KUNIT_EXPECT_EQ(test, rng90_resume(&ctx->client->dev), 0);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), false), -EIO);
+	rng90_test_wiped(test);
+}
+
+static void rng90_health_failure_test(struct kunit *test)
+{
+	rng90_latched_failure(test, RNG90_STATUS_HEALTH);
+}
+
+static void rng90_selftest_failure_test(struct kunit *test)
+{
+	rng90_latched_failure(test, RNG90_STATUS_SELFTEST);
+}
+
+static void rng90_strikes_reset_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 reply[35], output[32];
+
+	rng90_test_status_reply(reply, RNG90_STATUS_HEALTH);
+	/* A verified block resets the count between two pairs of failures. */
+	ctx->priv.state = RNG90_AWAKE;
+	rng90_test_random_script(ctx, reply, 1);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), -EIO);
+	rng90_test_restart(ctx);
+	rng90_test_start_script(ctx, -ENXIO);
+	rng90_test_random_script(ctx, reply, 1);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), -EIO);
+	KUNIT_EXPECT_EQ(test, ctx->priv.strikes, 2U);
+	rng90_test_restart(ctx);
+	rng90_test_start_script(ctx, -ENXIO);
+	rng90_test_random_script(ctx, rng90_test_random_reply, 1);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), 32);
+	KUNIT_EXPECT_EQ(test, ctx->priv.strikes, 0U);
+	rng90_test_restart(ctx);
+	rng90_test_random_script(ctx, reply, 1);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), -EIO);
+	rng90_test_restart(ctx);
+	rng90_test_start_script(ctx, -ENXIO);
+	rng90_test_random_script(ctx, reply, 1);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), -EIO);
+	KUNIT_EXPECT_EQ(test, ctx->priv.strikes, 2U);
+	KUNIT_EXPECT_FALSE(test, ctx->priv.failed);
+	rng90_test_wiped(test);
+}
+
+static void rng90_nonblocking_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 output[32] = { };
+
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), false), 0);
+	mutex_lock(&ctx->priv.lock);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), false), 0);
+	mutex_unlock(&ctx->priv.lock);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, 0, true), 0);
+}
+
+static void rng90_suspend_resume_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+	u8 output[32] = { };
+
+	ctx->priv.state = RNG90_AWAKE;
+	memset(ctx->priv.reply, 0xa5, sizeof(ctx->priv.reply));
+	rng90_test_add(ctx, false, rng90_test_sleep, 1, 1);
+	KUNIT_EXPECT_EQ(test, rng90_suspend(&ctx->client->dev), 0);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), -EHOSTDOWN);
+	rng90_test_wiped(test);
+	KUNIT_EXPECT_EQ(test, rng90_resume(&ctx->client->dev), 0);
+	rng90_test_start_script(ctx, -ENXIO);
+	rng90_test_random_script(ctx, rng90_test_random_reply, 1);
+	KUNIT_EXPECT_EQ(test, rng90_read(&ctx->priv.rng, output, sizeof(output), true), 32);
+	KUNIT_EXPECT_MEMEQ(test, output, rng90_test_random_reply + 1, 32);
+	rng90_test_wiped(test);
+}
+
+static void rng90_cleanup_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+
+	ctx->priv.state = RNG90_AWAKE;
+	rng90_test_add(ctx, false, rng90_test_sleep, 1, 1);
+	rng90_cleanup(&ctx->priv.rng);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_ASLEEP);
+	rng90_cleanup(&ctx->priv.rng);
+	rng90_test_wiped(test);
+}
+
+static void rng90_unknown_cleanup_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+
+	ctx->priv.state = RNG90_UNKNOWN;
+	/* Model an asleep chip: the first address wakes it, then the retry sleeps it. */
+	rng90_test_add(ctx, false, rng90_test_sleep, 1, -ENXIO);
+	rng90_test_add(ctx, false, rng90_test_sleep, 1, 1);
+	rng90_cleanup(&ctx->priv.rng);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_ASLEEP);
+	rng90_test_wiped(test);
+}
+
+/*
+ * A removed USB adapter can answer -ENODEV: cleanup writes Sleep once, does
+ * not wait to retry, and records the state unknown.
+ * The one scripted step is the attempt budget; a second write fails the test.
+ * The adapter is not deleted here, so the client outlives the cleanup.
+ */
+static void rng90_vanished_cleanup_test(struct kunit *test)
+{
+	struct rng90_test_context *ctx = test->priv;
+
+	ctx->priv.state = RNG90_AWAKE;
+	rng90_test_add(ctx, false, rng90_test_sleep, 1, -ENODEV);
+	rng90_cleanup(&ctx->priv.rng);
+	KUNIT_EXPECT_EQ(test, ctx->priv.state, RNG90_UNKNOWN);
+	rng90_test_wiped(test);
+}
+
+static struct kunit_case rng90_test_cases[] = {
+	KUNIT_CASE(rng90_crc_vectors_test),
+	KUNIT_CASE(rng90_command_vectors_test),
+	KUNIT_CASE(rng90_wake_nack_test),
+	KUNIT_CASE(rng90_cp2112_wake_timeout_test),
+	KUNIT_CASE(rng90_wake_adapter_retry_test),
+	KUNIT_CASE(rng90_vanished_wake_test),
+	KUNIT_CASE(rng90_absent_bounded_test),
+	KUNIT_CASE(rng90_wake_requires_valid_reply_test),
+	KUNIT_CASE(rng90_identity_test),
+	KUNIT_CASE(rng90_info_busy_test),
+	KUNIT_CASE(rng90_random_test),
+	KUNIT_CASE(rng90_small_buffer_test),
+	KUNIT_CASE(rng90_busy_poll_test),
+	KUNIT_CASE(rng90_busy_deadline_test),
+	KUNIT_CASE(rng90_crc_failure_test),
+	KUNIT_CASE(rng90_resync_recovery_test),
+	KUNIT_CASE(rng90_transport_eio_recovery_test),
+	KUNIT_CASE(rng90_vanished_read_test),
+	KUNIT_CASE(rng90_corrupt_status_test),
+	KUNIT_CASE(rng90_count_failure_test),
+	KUNIT_CASE(rng90_short_read_test),
+	KUNIT_CASE(rng90_short_write_test),
+	KUNIT_CASE(rng90_status_is_not_entropy_test),
+	KUNIT_CASE(rng90_transient_status_test),
+	KUNIT_CASE(rng90_health_failure_test),
+	KUNIT_CASE(rng90_selftest_failure_test),
+	KUNIT_CASE(rng90_strikes_reset_test),
+	KUNIT_CASE(rng90_nonblocking_test),
+	KUNIT_CASE(rng90_suspend_resume_test),
+	KUNIT_CASE(rng90_cleanup_test),
+	KUNIT_CASE(rng90_unknown_cleanup_test),
+	KUNIT_CASE(rng90_vanished_cleanup_test),
+	{ }
+};
+
+static struct kunit_suite rng90_test_suite = {
+	.name = "rng90",
+	.init = rng90_test_init,
+	.exit = rng90_test_exit,
+	.test_cases = rng90_test_cases,
+};
+
+kunit_test_suite(rng90_test_suite);
diff --git a/drivers/char/hw_random/rng90.c b/drivers/char/hw_random/rng90.c
index ec9ee3e27..9bac89cc4 100644
--- a/drivers/char/hw_random/rng90.c
+++ b/drivers/char/hw_random/rng90.c
@@ -549,3 +549,7 @@ module_i2c_driver(rng90_driver);
 MODULE_AUTHOR("Patrick Tudor <ptudor@ptudor.net>");
 MODULE_DESCRIPTION("Microchip RNG90 I2C hardware random number generator");
 MODULE_LICENSE("GPL");
+
+#if IS_ENABLED(CONFIG_HW_RANDOM_RNG90_KUNIT_TEST)
+#include "rng90-kunit.c"
+#endif

-- 
2.56.0

