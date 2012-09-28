From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/2] modsign: don't use bashism in sh scripts.
Date: Fri, 28 Sep 2012 15:28:23 +0930
Message-ID: <87obkq3czk.fsf@rustcorp.com.au>
References: <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <16088.1348736905@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/scripts/sign-file b/scripts/sign-file
index 1a472bb..e58e34e 100644
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -10,7 +10,7 @@ scripts=`dirname $0`
 CONFIG_MODULE_SIG_SHA512=y
 if [ -r .config ]
 then
-    source ./.config
+    . ./.config
 fi
 
 key="$1"
