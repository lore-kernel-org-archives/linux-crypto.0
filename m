Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704E5C04AB6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 06:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45161264A0
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 06:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfEaGkC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 02:40:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46096 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbfEaGkC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 02:40:02 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWbCn-0004ZY-PA; Fri, 31 May 2019 14:39:57 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWbCh-0006Ds-B8; Fri, 31 May 2019 14:39:51 +0800
Date:   Fri, 31 May 2019 14:39:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kbuild test robot <lkp@intel.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>, kbuild-all@01.org,
        linux-crypto@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: crypto: atmel - Fix sparse endianness warnings
Message-ID: <20190531063951.2utw5ms32ph7aik4@gondor.apana.org.au>
References: <201905302147.hxqMVXTS%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201905302147.hxqMVXTS%lkp@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 30, 2019 at 09:05:53PM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   0adb0c99594b73844cf9a5714faa6553ea04ba04
> commit: c34a320176a59445d76783e5ee043d6ecd22d011 [56/59] crypto: atmel-ecc - factor out code that can be shared
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
>         git checkout c34a320176a59445d76783e5ee043d6ecd22d011
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>

Thanks for the report.  Ard, can you please check this patch
please? Thanks!

---8<---
The param2 member in atmel_i2c_cmd is supposed to be little-endian
but was marked as u16.  This patch changes it to a __le16 which
reveals a missing endian swap in atmel_i2c_init_read_cmd.

Another missing little-endian marking is also added in
atmel_i2c_checksum.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip...")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index be49ab7f4338..dc876fab2882 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -34,7 +34,7 @@ static void atmel_i2c_checksum(struct atmel_i2c_cmd *cmd)
 {
 	u8 *data = &cmd->count;
 	size_t len = cmd->count - CRC_SIZE;
-	u16 *__crc16 = (u16 *)(data + len);
+	__le16 *__crc16 = (__le16 *)(data + len);
 
 	*__crc16 = cpu_to_le16(bitrev16(crc16(0, data, len)));
 }
@@ -48,7 +48,7 @@ void atmel_i2c_init_read_cmd(struct atmel_i2c_cmd *cmd)
 	 * (UserExtra, Selector, LockValue, LockConfig).
 	 */
 	cmd->param1 = CONFIG_ZONE;
-	cmd->param2 = DEVICE_LOCK_ADDR;
+	cmd->param2 = cpu_to_le16(DEVICE_LOCK_ADDR);
 	cmd->count = READ_COUNT;
 
 	atmel_i2c_checksum(cmd);
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index c6bd43b78f33..21860b99c3e3 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -8,6 +8,7 @@
 #define __ATMEL_I2C_H__
 
 #include <linux/hw_random.h>
+#include <linux/types.h>
 
 #define ATMEL_ECC_PRIORITY		300
 
@@ -50,7 +51,7 @@ struct atmel_i2c_cmd {
 	u8 count;
 	u8 opcode;
 	u8 param1;
-	u16 param2;
+	__le16 param2;
 	u8 data[MAX_RSP_SIZE];
 	u8 msecs;
 	u16 rxsize;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
