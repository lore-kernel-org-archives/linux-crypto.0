From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] SCRIPTS: Fix whitespace in get_maintainer output
Date: Wed, 10 Feb 2010 01:37:01 +0100
Message-ID: <1265762223-21006-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:33312 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0BJAiO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 19:38:14 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 2f3230d..430928e 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -278,7 +278,7 @@ foreach my $file (@ARGV) {
 	}
 	close(PATCH);
 	if ($file_cnt == @files) {
-	    warn "$P: file '${file}' doesn't appear to be a patch.  "
+	    warn "$P: file '${file}' doesn't appear to be a patch. "
 		. "Add -f to options?\n";
 	}
 	@files = sort_and_uniq(@files);
-- 
1.6.6.1

