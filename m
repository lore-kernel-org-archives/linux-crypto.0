From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sahara: set array of const as const
Date: Wed, 14 Oct 2015 21:14:19 +0200
Message-ID: <1444850059-16740-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34964 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbbJNTO1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 15:14:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some array of const char are not set as const.
This patch fix that.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sahara.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 804c0f5..f68c24a 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -272,7 +272,7 @@ static u32 sahara_aes_data_link_hdr(struct sahara_dev *dev)
 			SAHARA_HDR_CHA_SKHA | SAHARA_HDR_PARITY_BIT;
 }
 
-static char *sahara_err_src[16] = {
+static const char *sahara_err_src[16] = {
 	"No error",
 	"Header error",
 	"Descriptor length error",
@@ -291,14 +291,14 @@ static char *sahara_err_src[16] = {
 	"DMA error"
 };
 
-static char *sahara_err_dmasize[4] = {
+static const char *sahara_err_dmasize[4] = {
 	"Byte transfer",
 	"Half-word transfer",
 	"Word transfer",
 	"Reserved"
 };
 
-static char *sahara_err_dmasrc[8] = {
+static const char *sahara_err_dmasrc[8] = {
 	"No error",
 	"AHB bus error",
 	"Internal IP bus error",
@@ -309,7 +309,7 @@ static char *sahara_err_dmasrc[8] = {
 	"DMA HW error"
 };
 
-static char *sahara_cha_errsrc[12] = {
+static const char *sahara_cha_errsrc[12] = {
 	"Input buffer non-empty",
 	"Illegal address",
 	"Illegal mode",
@@ -324,7 +324,7 @@ static char *sahara_cha_errsrc[12] = {
 	"Reserved"
 };
 
-static char *sahara_cha_err[4] = { "No error", "SKHA", "MDHA", "RNG" };
+static const char *sahara_cha_err[4] = { "No error", "SKHA", "MDHA", "RNG" };
 
 static void sahara_decode_error(struct sahara_dev *dev, unsigned int error)
 {
@@ -354,7 +354,7 @@ static void sahara_decode_error(struct sahara_dev *dev, unsigned int error)
 	dev_err(dev->device, "\n");
 }
 
-static char *sahara_state[4] = { "Idle", "Busy", "Error", "HW Fault" };
+static const char *sahara_state[4] = { "Idle", "Busy", "Error", "HW Fault" };
 
 static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
 {
-- 
2.4.9
