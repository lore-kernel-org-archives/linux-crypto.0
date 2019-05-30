Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B30C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69A7A25945
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfE3NGo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 09:06:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:50325 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbfE3NGo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 09:06:44 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 06:06:43 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 30 May 2019 06:06:42 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hWKlV-000B80-Q9; Thu, 30 May 2019 21:06:41 +0800
Date:   Thu, 30 May 2019 21:05:53 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [cryptodev:master 56/59] drivers/crypto/atmel-i2c.c:39:18: sparse:
 sparse: incorrect type in assignment (different base types)
Message-ID: <201905302147.hxqMVXTS%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   0adb0c99594b73844cf9a5714faa6553ea04ba04
commit: c34a320176a59445d76783e5ee043d6ecd22d011 [56/59] crypto: atmel-ecc - factor out code that can be shared
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        git checkout c34a320176a59445d76783e5ee043d6ecd22d011
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/crypto/atmel-i2c.c:39:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
>> drivers/crypto/atmel-i2c.c:39:18: sparse:    expected unsigned short [usertype]
>> drivers/crypto/atmel-i2c.c:39:18: sparse:    got restricted __le16 [usertype]
>> drivers/crypto/atmel-i2c.c:68:21: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] param2 @@    got resunsigned short [usertype] param2 @@
>> drivers/crypto/atmel-i2c.c:68:21: sparse:    expected unsigned short [usertype] param2
   drivers/crypto/atmel-i2c.c:68:21: sparse:    got restricted __le16 [usertype]
   drivers/crypto/atmel-i2c.c:87:21: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] param2 @@    got resunsigned short [usertype] param2 @@
   drivers/crypto/atmel-i2c.c:87:21: sparse:    expected unsigned short [usertype] param2
   drivers/crypto/atmel-i2c.c:87:21: sparse:    got restricted __le16 [usertype]

vim +39 drivers/crypto/atmel-i2c.c

    23	
    24	/**
    25	 * atmel_i2c_checksum() - Generate 16-bit CRC as required by ATMEL ECC.
    26	 * CRC16 verification of the count, opcode, param1, param2 and data bytes.
    27	 * The checksum is saved in little-endian format in the least significant
    28	 * two bytes of the command. CRC polynomial is 0x8005 and the initial register
    29	 * value should be zero.
    30	 *
    31	 * @cmd : structure used for communicating with the device.
    32	 */
    33	static void atmel_i2c_checksum(struct atmel_i2c_cmd *cmd)
    34	{
    35		u8 *data = &cmd->count;
    36		size_t len = cmd->count - CRC_SIZE;
    37		u16 *__crc16 = (u16 *)(data + len);
    38	
  > 39		*__crc16 = cpu_to_le16(bitrev16(crc16(0, data, len)));
    40	}
    41	
    42	void atmel_i2c_init_read_cmd(struct atmel_i2c_cmd *cmd)
    43	{
    44		cmd->word_addr = COMMAND;
    45		cmd->opcode = OPCODE_READ;
    46		/*
    47		 * Read the word from Configuration zone that contains the lock bytes
    48		 * (UserExtra, Selector, LockValue, LockConfig).
    49		 */
    50		cmd->param1 = CONFIG_ZONE;
    51		cmd->param2 = DEVICE_LOCK_ADDR;
    52		cmd->count = READ_COUNT;
    53	
    54		atmel_i2c_checksum(cmd);
    55	
    56		cmd->msecs = MAX_EXEC_TIME_READ;
    57		cmd->rxsize = READ_RSP_SIZE;
    58	}
    59	EXPORT_SYMBOL(atmel_i2c_init_read_cmd);
    60	
    61	void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid)
    62	{
    63		cmd->word_addr = COMMAND;
    64		cmd->count = GENKEY_COUNT;
    65		cmd->opcode = OPCODE_GENKEY;
    66		cmd->param1 = GENKEY_MODE_PRIVATE;
    67		/* a random private key will be generated and stored in slot keyID */
  > 68		cmd->param2 = cpu_to_le16(keyid);
    69	
    70		atmel_i2c_checksum(cmd);
    71	
    72		cmd->msecs = MAX_EXEC_TIME_GENKEY;
    73		cmd->rxsize = GENKEY_RSP_SIZE;
    74	}
    75	EXPORT_SYMBOL(atmel_i2c_init_genkey_cmd);
    76	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
