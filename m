From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] modsign: Handle signing key in source tree
Date: Fri, 14 Aug 2015 16:57:19 +0100
Message-ID: <20150814155719.23941.53193.stgit@warthog.procyon.org.uk>
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

Since commit 1329e8cc69 ("modsign: Extract signing cert from
CONFIG_MODULE_SIG_KEY if needed"), the build system has carefully coped
with the signing key being specified as a relative path in either the
source or or the build trees.

However, the actual signing of modules has not worked if the filename
is relative to the source tree.

Fix that by moving the config_filename helper into scripts/Kbuild.include
so that it can be used from elsewhere, and then using it in the top-level
Makefile to find the signing key file.

Kill the intermediate $(MODPUBKEY) and $(MODSECKEY) variables too, while
we're at it. There's no need for them.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Makefile               |    7 +++---
 certs/Makefile         |   54 ------------------------------------------------
 scripts/Kbuild.include |   51 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 58 deletions(-)

diff --git a/Makefile b/Makefile
index 2341942feb85..7c90dda898f6 100644
--- a/Makefile
+++ b/Makefile
@@ -870,10 +870,9 @@ INITRD_COMPRESS-$(CONFIG_RD_LZ4)   := lz4
 # export INITRD_COMPRESS := $(INITRD_COMPRESS-y)
 
 ifdef CONFIG_MODULE_SIG_ALL
-MODSECKEY = $(CONFIG_MODULE_SIG_KEY)
-MODPUBKEY = certs/signing_key.x509
-export MODPUBKEY
-mod_sign_cmd = scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
+$(eval $(call config_filename,MODULE_SIG_KEY))
+
+mod_sign_cmd = scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODULE_SIG_KEY_SRCPREFIX)$(CONFIG_MODULE_SIG_KEY) certs/signing_key.x509
 else
 mod_sign_cmd = true
 endif
diff --git a/certs/Makefile b/certs/Makefile
index 3c782d025c36..28ac694dd11a 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -4,60 +4,6 @@
 
 obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o
 
-###############################################################################
-#
-# When a Kconfig string contains a filename, it is suitable for
-# passing to shell commands. It is surrounded by double-quotes, and
-# any double-quotes or backslashes within it are escaped by
-# backslashes.
-#
-# This is no use for dependencies or $(wildcard). We need to strip the
-# surrounding quotes and the escaping from quotes and backslashes, and
-# we *do* need to escape any spaces in the string. So, for example:
-#
-# Usage: $(eval $(call config_filename,FOO))
-#
-# Defines FOO_FILENAME based on the contents of the CONFIG_FOO option,
-# transformed as described above to be suitable for use within the
-# makefile.
-#
-# Also, if the filename is a relative filename and exists in the source
-# tree but not the build tree, define FOO_SRCPREFIX as $(srctree)/ to
-# be prefixed to *both* command invocation and dependencies.
-#
-# Note: We also print the filenames in the quiet_cmd_foo text, and
-# perhaps ought to have a version specially escaped for that purpose.
-# But it's only cosmetic, and $(patsubst "%",%,$(CONFIG_FOO)) is good
-# enough.  It'll strip the quotes in the common case where there's no
-# space and it's a simple filename, and it'll retain the quotes when
-# there's a space. There are some esoteric cases in which it'll print
-# the wrong thing, but we don't really care. The actual dependencies
-# and commands *do* get it right, with various combinations of single
-# and double quotes, backslashes and spaces in the filenames.
-#
-###############################################################################
-#
-quote := $(firstword " ")
-space :=
-space +=
-space_escape := %%%SPACE%%%
-#
-define config_filename
-ifneq ($$(CONFIG_$(1)),"")
-$(1)_FILENAME := $$(subst \\,\,$$(subst \$$(quote),$$(quote),$$(subst $$(space_escape),\$$(space),$$(patsubst "%",%,$$(subst $$(space),$$(space_escape),$$(CONFIG_$(1)))))))
-ifneq ($$(patsubst /%,%,$$(firstword $$($(1)_FILENAME))),$$(firstword $$($(1)_FILENAME)))
-else
-ifeq ($$(wildcard $$($(1)_FILENAME)),)
-ifneq ($$(wildcard $$(srctree)/$$($(1)_FILENAME)),)
-$(1)_SRCPREFIX := $(srctree)/
-endif
-endif
-endif
-endif
-endef
-#
-###############################################################################
-
 ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
 
 $(eval $(call config_filename,SYSTEM_TRUSTED_KEYS))
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index d3437b82ac25..608ac65c61e3 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -303,3 +303,54 @@ why =                                                                        \
 
 echo-why = $(call escsq, $(strip $(why)))
 endif
+
+###############################################################################
+#
+# When a Kconfig string contains a filename, it is suitable for
+# passing to shell commands. It is surrounded by double-quotes, and
+# any double-quotes or backslashes within it are escaped by
+# backslashes.
+#
+# This is no use for dependencies or $(wildcard). We need to strip the
+# surrounding quotes and the escaping from quotes and backslashes, and
+# we *do* need to escape any spaces in the string. So, for example:
+#
+# Usage: $(eval $(call config_filename,FOO))
+#
+# Defines FOO_FILENAME based on the contents of the CONFIG_FOO option,
+# transformed as described above to be suitable for use within the
+# makefile.
+#
+# Also, if the filename is a relative filename and exists in the source
+# tree but not the build tree, define FOO_SRCPREFIX as $(srctree)/ to
+# be prefixed to *both* command invocation and dependencies.
+#
+# Note: We also print the filenames in the quiet_cmd_foo text, and
+# perhaps ought to have a version specially escaped for that purpose.
+# But it's only cosmetic, and $(patsubst "%",%,$(CONFIG_FOO)) is good
+# enough.  It'll strip the quotes in the common case where there's no
+# space and it's a simple filename, and it'll retain the quotes when
+# there's a space. There are some esoteric cases in which it'll print
+# the wrong thing, but we don't really care. The actual dependencies
+# and commands *do* get it right, with various combinations of single
+# and double quotes, backslashes and spaces in the filenames.
+#
+###############################################################################
+#
+space_escape := %%%SPACE%%%
+#
+define config_filename
+ifneq ($$(CONFIG_$(1)),"")
+$(1)_FILENAME := $$(subst \\,\,$$(subst \$$(quote),$$(quote),$$(subst $$(space_escape),\$$(space),$$(patsubst "%",%,$$(subst $$(space),$$(space_escape),$$(CONFIG_$(1)))))))
+ifneq ($$(patsubst /%,%,$$(firstword $$($(1)_FILENAME))),$$(firstword $$($(1)_FILENAME)))
+else
+ifeq ($$(wildcard $$($(1)_FILENAME)),)
+ifneq ($$(wildcard $$(srctree)/$$($(1)_FILENAME)),)
+$(1)_SRCPREFIX := $(srctree)/
+endif
+endif
+endif
+endif
+endef
+#
+###############################################################################
