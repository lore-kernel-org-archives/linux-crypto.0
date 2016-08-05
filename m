From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH v2 0/7] crypto: img-hash - fixes and interface changes
Date: Fri, 5 Aug 2016 14:00:13 +0100
Message-ID: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Will Thomas <will.thomas@imgtec.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:30908 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617AbcHENIM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 09:08:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This patchset includes small stability fixes, power management
and import/export interface functions for the img-hash driver.

Changes as discussed for [1/7], [2/7] and [5/7].


Govindraj Raja (1):
  crypto: img-hash - Add suspend resume hooks for img hash

James Hartley (2):
  crypto: img-hash - Add support for export and import
  crypto: img-hash - log a successful probe

Will Thomas (4):
  crypto: img-hash - Fix null pointer exception
  crypto: img-hash - Fix hash request context
  crypto: img-hash - Reconfigure DMA Burst length
  crypto: img-hash - Fix set_reqsize call

 drivers/crypto/img-hash.c | 108 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 98 insertions(+), 10 deletions(-)

-- 
2.1.4
