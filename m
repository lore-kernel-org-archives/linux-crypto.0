From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 17/17] Documentation/bindings: crypto: document the SafeXcel EIP97 compatible
Date: Thu, 14 Dec 2017 15:26:59 +0100
Message-ID: <20171214142659.16987-18-antoine.tenart@free-electrons.com>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36777 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753141AbdLNOaF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:05 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the SafeXcel EIP97 compatible to the Inside Secure
device tree bindings documentation.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
index fbc07d12322f..30c3ce6b502e 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
+++ b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
@@ -1,7 +1,8 @@
 Inside Secure SafeXcel cryptographic engine
 
 Required properties:
-- compatible: Should be "inside-secure,safexcel-eip197".
+- compatible: Should be "inside-secure,safexcel-eip197" or
+              "inside-secure,safexcel-eip97".
 - reg: Base physical address of the engine and length of memory mapped region.
 - interrupts: Interrupt numbers for the rings and engine.
 - interrupt-names: Should be "ring0", "ring1", "ring2", "ring3", "eip", "mem".
-- 
2.14.3
