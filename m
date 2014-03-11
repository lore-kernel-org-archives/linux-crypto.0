From: Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH 01/22] scripts: objdiff: detect object code changes between two commits
Date: Tue, 11 Mar 2014 21:32:33 +0000
Message-ID: <cc773270b6481ffe69516d994fbe98c13bcfdb5a.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22212 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaCKVzi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2014 17:55:38 -0400
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

objdiff is useful when doing large code cleanups.  For example, when
removing checkpatch warnings and errors from new drivers in the staging
tree.

objdiff can be used in conjunction with a git rebase to confirm that
each commit made no changes to the resulting object code.  It has the
same return values as diff(1).

This was written specifically to support adding the skein and threefish
cryto drivers to the staging tree.  I needed a programmatic way to
confirm that commits changing >90% of the lines didn't inadvertently
change the code.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 scripts/objdiff | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100755 scripts/objdiff

diff --git a/scripts/objdiff b/scripts/objdiff
new file mode 100755
index 000000000000..9e1ad8df2d07
--- /dev/null
+++ b/scripts/objdiff
@@ -0,0 +1,126 @@
+#!/bin/bash
+
+# objdiff - a small script for validating that a commit or series of commits
+# didn't change object code.
+#
+# Copyright 2014, Jason Cooper <jason@lakedaemon.net>
+#
+# Licensed under the terms of the GNU GPL version 2
+
+# usage example:
+#
+# $ git checkout COMMIT_A
+# $ <your fancy build command here>
+# $ ./scripts/objdiff record path/to/*.o
+#
+# $ git checkout COMMIT_B
+# $ <your fancy build command here>
+# $ ./scripts/objdiff record path/to/*.o
+#
+# $ ./scripts/objdiff diff COMMIT_A COMMIT_B
+# $
+
+# And to clean up (everything is in /tmp/objdiff-*)
+# $ ./scripts/objdiff clean all
+
+usage() {
+	echo "Usage: $0 <command> <args>"
+	echo "  record    <list of object files>"
+	echo "  diff      <commitA> <commitB>"
+	echo "  clean     all | <commit>"
+	exit 1
+}
+
+dorecord() {
+	[ $# -eq 0 ] && usage
+
+	FILES="$*"
+
+	CMT="`git rev-parse --short HEAD`"
+
+	OBJDUMP="${CROSS_COMPILE}objdump"
+	OBJDIFFD="/tmp/objdiff-$CMT"
+
+	[ ! -d "$OBJDIFFD" ] && mkdir -p "$OBJDIFFD"
+
+	for f in $FILES; do
+		dn="${f%/*}"
+		bn="${f##*/}"
+
+		[ ! -d "$OBJDIFFD/$dn" ] && mkdir -p "$OBJDIFFD/$dn"
+
+		# remove addresses for a more clear diff
+		# http://dummdida.tumblr.com/post/60924060451/binary-diff-between-libc-from-scientificlinux-and
+		$OBJDUMP -D "$f" | sed "s/^[[:space:]]\+[0-9a-f]\+//" \
+			>"$OBJDIFFD/$dn/$bn"
+
+		# force rebuild
+		rm -f "$f"
+	done
+}
+
+dodiff() {
+	[ $# -ne 2 ] && usage
+
+	SRC="`git rev-parse --short $1`"
+	DST="`git rev-parse --short $2`"
+
+	DIFF="`which colordiff`"
+
+	if [ ${#DIFF} -eq 0 ] || [ ! -x "$DIFF" ]; then
+		DIFF="`which diff`"
+	fi
+
+	SRCD="/tmp/objdiff-$SRC"
+	DSTD="/tmp/objdiff-$DST"
+
+	if [ ! -d "$SRCD" ]; then
+		echo "ERROR: $SRCD doesn't exist"
+		exit 1
+	fi
+
+	if [ ! -d "$DSTD" ]; then
+		echo "ERROR: $DSTD doesn't exist"
+		exit 1
+	fi
+
+	$DIFF -Nurd $SRCD $DSTD
+}
+
+doclean() {
+	[ $# -eq 0 ] && usage
+	[ $# -gt 1 ] && usage
+
+	if [ "x$1" = "xall" ]; then
+		rm -rf /tmp/objdiff-*
+	else
+		CMT="`git rev-parse --short $1`"
+
+		if [ -d "/tmp/objdiff-$CMT" ]; then
+			rm -rf /tmp/objdiff-$CMT
+		else
+			echo "$CMT not found"
+		fi
+	fi
+}
+
+[ $# -eq 0 ] &&	usage
+
+case "$1" in
+	record)
+		shift
+		dorecord $*
+		;;
+	diff)
+		shift
+		dodiff $*
+		;;
+	clean)
+		shift
+		doclean $*
+		;;
+	*)
+		echo "Unrecognized command '$1'"
+		exit 1
+		;;
+esac
-- 
1.9.0
