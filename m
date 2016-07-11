From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH 0/6] crypto: img-hash - fixes and interface changes
Date: Mon, 11 Jul 2016 10:33:30 +0100
Message-ID: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Will Thomas <will.thomas@imgtec.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:18258 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbcGKJeL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jul 2016 05:34:11 -0400
Received: from HHMAIL01.hh.imgtec.org (unknown [10.100.10.19])
	by Forcepoint Email with ESMTPS id B5296B96195D5
	for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2016 10:34:06 +0100 (IST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set includes small stability fixes, power management
and import/export interface functions for the img-hash driver.

Govindraj Raja (1):
  crypto: img-hash - Add suspend resume hooks for img hash

James Hartley (2):
  crypto: img-hash - Add support for export and import
  crypto: img-hash - log a successful probe

Will Thomas (3):
  crypto: img-hash - Fix null pointer exception
  crypto: img-hash - Fix hash request context
  crypto: img-hash - Reconfigure DMA Burst length

 drivers/crypto/img-hash.c | 76 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 4 deletions(-)

-- 
2.1.4
