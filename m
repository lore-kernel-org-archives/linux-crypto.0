From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/2] modules: don't call eu-strip if it doesn't exist.
Date: Fri, 28 Sep 2012 15:29:03 +0930
Message-ID: <87lifu3cyg.fsf@rustcorp.com.au>
References: <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16088.1348736905@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 90b1bb1..2a4d1a1 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -165,11 +165,13 @@ endif
 
 # We strip the module as best we can - note that using both strip and eu-strip
 # results in a smaller module than using either alone.
+EU_STRIP = $(shell which eu-strip || echo true)
+
 quiet_cmd_sign_ko_stripped_ko_unsigned = STRIP [M] $@
       cmd_sign_ko_stripped_ko_unsigned = \
 		cp $< $@ && \
 		strip -x -g $@ && \
-		eu-strip $@
+		$(EU_STRIP) $@
 
 ifeq ($(SIGN_MODULES),1)
 
