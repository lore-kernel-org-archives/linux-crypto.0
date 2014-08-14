From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: caamhash.c fixes
Date: Thu, 14 Aug 2014 13:51:55 +0300
Message-ID: <1408013517-15526-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<davem@davemloft.net>
To: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:46675
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752916AbaHNKwu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2014 06:52:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a set of two independent fixes for caamhash driver


drivers/crypto/caam/caamhash.c   | 28 +++++++++++++++++-----------
drivers/crypto/caam/sg_sw_sec4.h | 54 ------------------------------------------------------
2 files changed, 17 insertions(+), 65 deletions(-)
