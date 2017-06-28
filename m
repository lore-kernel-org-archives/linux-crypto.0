From: karthik@techveda.org
Subject: [PATCH 0/2] staging: ccree: Fix coding style and remove warnings
Date: Wed, 28 Jun 2017 15:07:11 +0530
Message-ID: <1498642633-3260-1-git-send-email-karthik@techveda.org>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, sunil.m@techveda.org,
        Karthik Tummala <karthik@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Karthik Tummala <karthik@techveda.org>

This patch series fixes coding style and removes the following
checkpatch.pl warnings:

Prefer using '"%s...", __func__' to using the function's name,
in a string.

Braces {} are not necessary for single statement blocks.

Rebased on top of next-20170627.
Patches were tested and built on next-20170627

Karthik Tummala (2):
  staging: ccree: Use __func__ instead of function name
  staging: ccree: Remove braces {} for single statement blocks

 drivers/staging/ccree/ssi_aead.c | 48 ++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

-- 
1.9.1
