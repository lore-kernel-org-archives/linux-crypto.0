From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v4 11/14] treewide: Prepare to remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Wed, 11 Jul 2018 13:36:16 -0700
Message-ID: <20180711203619.1020-12-keescook@chromium.org>
References: <20180711203619.1020-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711203619.1020-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Several uses of AHASH_REQUEST_ON_STACK() will trigger FRAME_WARN warnings
(when less than 2048) once the VLA is no longer hidden from the check:

drivers/block/drbd/drbd_worker.c:325:1: warning: the frame size of 1112 bytes is larger than 1024 bytes [-Wframe-larger-than=]
drivers/block/drbd/drbd_worker.c:352:1: warning: the frame size of 1120 bytes is larger than 1024 bytes [-Wframe-larger-than=]
crypto/ccm.c:235:1: warning: the frame size of 1184 bytes is larger than 1024 bytes [-Wframe-larger-than=]
drivers/md/dm-crypt.c:353:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
drivers/net/ppp/ppp_mppe.c:158:1: warning: the frame size of 1168 bytes is larger than 1024 bytes [-Wframe-larger-than=]
net/wireless/lib80211_crypt_tkip.c:537:1: warning: the frame size of 1136 bytes is larger than 1024 bytes [-Wframe-larger-than=]
drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c:528:1: warning: the frame size of 1136 bytes is larger than 1024 bytes [-Wframe-larger-than=]
drivers/staging/rtl8192e/rtllib_crypt_tkip.c:531:1: warning: the frame size of 1136 bytes is larger than 1024 bytes [-Wframe-larger-than=]

This bumps the affected objects by 20% to silence the warnings while still
providing coverage is anything grows even more.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/Makefile                             | 1 +
 drivers/block/drbd/Makefile                 | 2 ++
 drivers/md/Makefile                         | 1 +
 drivers/net/ppp/Makefile                    | 1 +
 drivers/staging/rtl8192e/Makefile           | 1 +
 drivers/staging/rtl8192u/Makefile           | 1 +
 drivers/staging/rtl8192u/ieee80211/Makefile | 1 +
 net/wireless/Makefile                       | 1 +
 8 files changed, 9 insertions(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 6d1d40eeb964..a4487b61ac4e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_KEYWRAP) += keywrap.o
 obj-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
+CFLAGS_ccm.o += $(FRAME_WARN_BUMP_FLAG)
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
 obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
 obj-$(CONFIG_CRYPTO_AEGIS128L) += aegis128l.o
diff --git a/drivers/block/drbd/Makefile b/drivers/block/drbd/Makefile
index 8bd534697d1b..9b6184487cb4 100644
--- a/drivers/block/drbd/Makefile
+++ b/drivers/block/drbd/Makefile
@@ -7,3 +7,5 @@ drbd-y += drbd_nla.o
 drbd-$(CONFIG_DEBUG_FS) += drbd_debugfs.o
 
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd.o
+
+CFLAGS_drbd_worker.o += $(FRAME_WARN_BUMP_FLAG)
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 822f4e8753bc..639ff6599846 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_DM_UNSTRIPED)	+= dm-unstripe.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
 obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
+CFLAGS_dm-crypt.o		+= $(FRAME_WARN_BUMP_FLAG)
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
diff --git a/drivers/net/ppp/Makefile b/drivers/net/ppp/Makefile
index 16c457d6b324..18f35e449c93 100644
--- a/drivers/net/ppp/Makefile
+++ b/drivers/net/ppp/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_PPP_ASYNC) += ppp_async.o
 obj-$(CONFIG_PPP_BSDCOMP) += bsd_comp.o
 obj-$(CONFIG_PPP_DEFLATE) += ppp_deflate.o
 obj-$(CONFIG_PPP_MPPE) += ppp_mppe.o
+CFLAGS_ppp_mppe.o += $(FRAME_WARN_BUMP_FLAG)
 obj-$(CONFIG_PPP_SYNC_TTY) += ppp_synctty.o
 obj-$(CONFIG_PPPOE) += pppox.o pppoe.o
 obj-$(CONFIG_PPPOL2TP) += pppox.o
diff --git a/drivers/staging/rtl8192e/Makefile b/drivers/staging/rtl8192e/Makefile
index 6af519938868..fde738cdf876 100644
--- a/drivers/staging/rtl8192e/Makefile
+++ b/drivers/staging/rtl8192e/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_RTLLIB) += rtllib.o
 
 obj-$(CONFIG_RTLLIB_CRYPTO_CCMP) += rtllib_crypt_ccmp.o
 obj-$(CONFIG_RTLLIB_CRYPTO_TKIP) += rtllib_crypt_tkip.o
+CFLAGS_rtllib_crypt_tkip.o += $(FRAME_WARN_BUMP_FLAG)
 obj-$(CONFIG_RTLLIB_CRYPTO_WEP) += rtllib_crypt_wep.o
 
 obj-$(CONFIG_RTL8192E) += rtl8192e/
diff --git a/drivers/staging/rtl8192u/Makefile b/drivers/staging/rtl8192u/Makefile
index 3022728a364c..ad059546df88 100644
--- a/drivers/staging/rtl8192u/Makefile
+++ b/drivers/staging/rtl8192u/Makefile
@@ -26,5 +26,6 @@ r8192u_usb-y := r8192U_core.o r8180_93cx6.o r8192U_wx.o		\
 		  ieee80211/rtl819x_TSProc.o				\
 		  ieee80211/rtl819x_BAProc.o				\
 		  ieee80211/dot11d.o
+CFLAGS_ieee80211_crypt_tkip.o += $(FRAME_WARN_BUMP_FLAG)
 
 obj-$(CONFIG_RTL8192U) += r8192u_usb.o
diff --git a/drivers/staging/rtl8192u/ieee80211/Makefile b/drivers/staging/rtl8192u/ieee80211/Makefile
index 0d4d6489f767..9f3a06674c1a 100644
--- a/drivers/staging/rtl8192u/ieee80211/Makefile
+++ b/drivers/staging/rtl8192u/ieee80211/Makefile
@@ -17,6 +17,7 @@ ieee80211-rsl-objs := ieee80211_rx.o \
 
 ieee80211_crypt-rsl-objs := ieee80211_crypt.o
 ieee80211_crypt_tkip-rsl-objs := ieee80211_crypt_tkip.o
+CFLAGS_ieee80211_crypt_tkip.o += $(FRAME_WARN_BUMP_FLAG)
 ieee80211_crypt_ccmp-rsl-objs := ieee80211_crypt_ccmp.o
 ieee80211_crypt_wep-rsl-objs := ieee80211_crypt_wep.o
 
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 1d84f91bbfb0..f6af5a6233e1 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_LIB80211) += lib80211.o
 obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib80211_crypt_wep.o
 obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
+CFLAGS_lib80211_crypt_tkip.o += $(FRAME_WARN_BUMP_FLAG)
 
 obj-$(CONFIG_WEXT_CORE) += wext-core.o
 obj-$(CONFIG_WEXT_PROC) += wext-proc.o
-- 
2.17.1
