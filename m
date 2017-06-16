From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH 0/1] Add firmware for CNN55XX crypto driver
Date: Fri, 16 Jun 2017 19:52:25 +0530
Message-ID: <20170616142226.3950-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: davem@davemloft.net, linux-firmware@kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Sreerama.Gadam@cavium.com,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

CNN55XX driver is accepted and needs firmware to functional.
This patchset adds CNN55XX firmware v07 supports
symmetric crypto operations.

Srikanth Jampala (1):
  cavium: Add firmware for CNN55XX crypto driver.

 WHENCE        |   9 +++++++++
 cnn55xx_se.fw | Bin 0 -> 27698 bytes
 2 files changed, 9 insertions(+)
 create mode 100644 cnn55xx_se.fw

-- 
2.9.4
