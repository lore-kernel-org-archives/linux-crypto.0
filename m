From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 03/18] docs: */index.rst: Add newer documents to their respective index.rst
Date: Mon,  7 May 2018 06:35:39 -0300
Message-ID: <e6852448ac11e827f86dab1e183b82af6a320559.1525684985.git.mchehab+samsung@kernel.org>
References: <cover.1525684985.git.mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <treding@nvidia.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Ingo Molnar <mingo@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, linux-crypto@vger.kernel.org
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1525684985.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1525684985.git.mchehab+samsung@kernel.org>
References: <cover.1525684985.git.mchehab+samsung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

A number of new docs were added, but they're currently not on
the index.rst from the session they're supposed to be, causing
Sphinx warnings.

Add them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/crypto/index.rst     | 1 +
 Documentation/driver-api/index.rst | 1 +
 Documentation/process/index.rst    | 1 +
 Documentation/security/index.rst   | 2 ++
 4 files changed, 5 insertions(+)

diff --git a/Documentation/crypto/index.rst b/Documentation/crypto/index.rst
index 94c4786f2573..c4ff5d791233 100644
--- a/Documentation/crypto/index.rst
+++ b/Documentation/crypto/index.rst
@@ -20,5 +20,6 @@ for cryptographic use cases, as well as programming examples.
    architecture
    devel-algos
    userspace-if
+   crypto_engine
    api
    api-samples
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index 6d8352c0f354..3ac51c94f97b 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -18,6 +18,7 @@ available subsections can be seen below.
    infrastructure
    pm/index
    device-io
+   device_connection
    dma-buf
    device_link
    message-based
diff --git a/Documentation/process/index.rst b/Documentation/process/index.rst
index 1c9fe657ed01..37bd0628b6ee 100644
--- a/Documentation/process/index.rst
+++ b/Documentation/process/index.rst
@@ -52,6 +52,7 @@ lack of a better place.
    adding-syscalls
    magic-number
    volatile-considered-harmful
+   clang-format
 
 .. only::  subproject and html
 
diff --git a/Documentation/security/index.rst b/Documentation/security/index.rst
index 298a94a33f05..85492bfca530 100644
--- a/Documentation/security/index.rst
+++ b/Documentation/security/index.rst
@@ -9,5 +9,7 @@ Security Documentation
    IMA-templates
    keys/index
    LSM
+   LSM-sctp
+   SELinux-sctp
    self-protection
    tpm/index
-- 
2.17.0
