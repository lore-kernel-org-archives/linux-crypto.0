From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/3] SCRIPTS: Better error message for checkpath.pl
Date: Wed, 10 Feb 2010 01:40:52 +0100
Message-ID: <1265762453-21083-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Andy Whitcroft <apw@canonical.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Walker <dwalker@fifo99.com>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48883 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0BJAla (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 19:41:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the input file for checkpatch.pl is not a patch, print an error message
that suggets -f.

Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3257d3d..d5405aa 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2693,7 +2693,7 @@ sub process {
 	}
 
 	if (!$is_patch) {
-		ERROR("Does not appear to be a unified-diff format patch\n");
+		ERROR("Does not appear to be a unified-diff format patch. Add -f?\n");
 	}
 	if ($is_patch && $chk_signoff && $signoff == 0) {
 		ERROR("Missing Signed-off-by: line(s)\n");
-- 
1.6.6.1

