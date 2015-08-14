From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] modsign: Use if_changed rule for extracting cert from
 module signing key
Date: Fri, 14 Aug 2015 16:57:09 +0100
Message-ID: <20150814155709.23941.77228.stgit@warthog.procyon.org.uk>
References: <20150814155650.23941.76513.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	dwmw2@infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: keyrings@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150814155650.23941.76513.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: David Woodhouse <David.Woodhouse@intel.com>

We couldn't use if_changed for this before, because it didn't live in
the kernel/ directory so we couldn't add it to $(targets). It was easier
just to leave it as it was.

Now it's in the certs/ directory we can use if_changed, the same as we
do for the trusted certificate list.

Aside from making things consistent, this means we don't need to depend
explicitly on the include/config/module/sig/key.h file. And we also get
to automatically do the right thing and re-extract the cert if the user
does odd things like using a relative filename and then playing silly
buggers with adding/removing that file in both the source and object
trees. We always favour the one in the object tree if it exists, and
now we'll correctly re-extract the cert when it changes. Previously we'd
*only* re-extract the cert if the config option changed, even if the
actual file we're using did change.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 certs/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/certs/Makefile b/certs/Makefile
index 5d33486d3b20..3c782d025c36 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -142,6 +142,7 @@ endif
 # GCC PR#66871 again.
 $(obj)/system_certificates.o: $(obj)/signing_key.x509
 
-$(obj)/signing_key.x509: scripts/extract-cert include/config/module/sig/key.h $(X509_DEP)
-	$(call cmd,extract_certs,$(MODULE_SIG_KEY_SRCPREFIX)$(CONFIG_MODULE_SIG_KEY))
+targets += signing_key.x509
+$(obj)/signing_key.x509: scripts/extract-cert $(X509_DEP) FORCE
+	$(call if_changed,extract_certs,$(MODULE_SIG_KEY_SRCPREFIX)$(CONFIG_MODULE_SIG_KEY))
 endif
