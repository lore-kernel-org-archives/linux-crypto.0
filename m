From: Cosar Dindar <cosardindar@gmail.com>
Subject: [RESEND,PATCH v4 0/2] Add support for the STM32F4 CRC32
Date: Mon, 17 Jul 2017 11:26:39 +0300
Message-ID: <1500279999-46120-1-git-send-email-cosardindar@gmail.com>
Cc: davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        fabien.dessenne@st.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Cosar Dindar <cosardindar@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34248 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbdGQI1B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 04:27:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series add hardware CRC32 ("Ethernet") calculation support
for STMicroelectronics STM32F429.

Polynomial and key setting are not supported, key is fixed as 0x4C11DB7
and poly is 0xFFFFFFFF.

Module is tested on STM32F429-disco board with crypto testmgr using
cases within the key 0xFFFFFFFF.

Changes in v4:
  - Edited patchset brief.

Cosar Dindar (2):
  dt-bindings : Document the STM32F4 CRC32 binding
  crypto : stm32 - Add STM32F4 CRC32 support
