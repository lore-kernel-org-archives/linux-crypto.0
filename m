From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: stm32 - Support for STM32 HASH module
Date: Thu, 10 Aug 2017 00:27:18 +0300
Message-ID: <20170809212718.7xcib3rhexiy52cb@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: lionel.debieve@st.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19062 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdHIV1i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 17:27:38 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello lionel.debieve@st.com,

The patch 8a1012d3f2ab: "crypto: stm32 - Support for STM32 HASH
module" from Jul 13, 2017, leads to the following static checker
warning:

	drivers/crypto/stm32/stm32-hash.c:1088 stm32_hash_irq_thread()
	error: uninitialized symbol 'err'.

drivers/crypto/stm32/stm32-hash.c
  1067  static irqreturn_t stm32_hash_irq_thread(int irq, void *dev_id)
  1068  {
  1069          struct stm32_hash_dev *hdev = dev_id;
  1070          int err;
                ^^^^^^^^
  1071  
  1072          if (HASH_FLAGS_CPU & hdev->flags) {
  1073                  if (HASH_FLAGS_OUTPUT_READY & hdev->flags) {
  1074                          hdev->flags &= ~HASH_FLAGS_OUTPUT_READY;
  1075                          goto finish;
  1076                  }
  1077          } else if (HASH_FLAGS_DMA_READY & hdev->flags) {
  1078                  if (HASH_FLAGS_DMA_ACTIVE & hdev->flags) {
  1079                          hdev->flags &= ~HASH_FLAGS_DMA_ACTIVE;
  1080                                  goto finish;
  1081                  }
  1082          }
  1083  
  1084          return IRQ_HANDLED;
  1085  
  1086  finish:
  1087          /*Finish current request */
  1088          stm32_hash_finish_req(hdev->req, err);
                                                 ^^^
Never initialized.

  1089  
  1090          return IRQ_HANDLED;
  1091  }


regards,
dan carpenter
