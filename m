From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 0/6] Fix additional alignment issues in staging/ccree
Date: Tue, 18 Jul 2017 22:03:51 +0200
Message-ID: <20170718200357.32646-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33763 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdGRUFR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 16:05:17 -0400
Received: by mail-lf0-f42.google.com with SMTP id z78so22205925lff.0
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 13:05:16 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Here are a few more patches that fixes alignment issues in
staging/ccree. Includes the patches that I sent previously which could
not be applied plus a few more fixes for issues that I found. These
patches should fix all remaining alignment warnings reported by
checkpatch.pl in staging/ccree.

- Simon

---

Simon Sandström (6):
  staging: ccree: Fix alignment issues in ssi_aead.c
  staging: ccree: Fix alignment issues in ssi_hash.c
  staging: ccree: Fix alignment issues in ssi_buffer_mgr.c
  staging: ccree: Fix alignment issues in ssi_cipher.c
  staging: ccree: Fix alignment issues in ssi_ivgen.c
  staging: ccree: Fix alignment issues in ssi_request_mgr.c

 drivers/staging/ccree/ssi_aead.c        |  47 +++++++-------
 drivers/staging/ccree/ssi_buffer_mgr.c  |  40 +++++++-----
 drivers/staging/ccree/ssi_cipher.c      |   3 +-
 drivers/staging/ccree/ssi_hash.c        | 105 +++++++++++++++++---------------
 drivers/staging/ccree/ssi_ivgen.c       |   3 +-
 drivers/staging/ccree/ssi_request_mgr.c |   4 +-
 6 files changed, 112 insertions(+), 90 deletions(-)

-- 
2.11.0
