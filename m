From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 10/10] crypto: CCP maintainer information
Date: Tue, 12 Nov 2013 11:46:57 -0600
Message-ID: <20131112174657.19746.44224.stgit@tlendack-t1.amdoffice.net>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Update the MAINTAINERS file for the AMD CCP device driver.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 051e4dc..de22604 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -525,6 +525,13 @@ F:	drivers/tty/serial/altera_jtaguart.c
 F:	include/linux/altera_uart.h
 F:	include/linux/altera_jtaguart.h
 
+AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER
+M:	Tom Lendacky <thomas.lendacky@amd.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/crypto/ccp/
+F:	include/linux/ccp.h
+
 AMD FAM15H PROCESSOR POWER MONITORING DRIVER
 M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
 L:	lm-sensors@lm-sensors.org
