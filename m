From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC 0/4] crypto: qat - Add userspace access to QAT services
Date: Thu, 06 Nov 2014 11:59:32 -0800
Message-ID: <20141106195931.13328.90501.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57822 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaKFUCP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 15:02:15 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
This series adds support for user space access to QAT services.
Intel (R) Quick Assist Technology provides acceleration for symmetric,
asymmetric cryptography and compression. Many of these algorithms like
RSA, DSA, Diffie=E2=80=93Hellman, Elliptic Curve are very computational=
 expensive and
accelerating is highly desirable. This patch series implement a new
qat_sym and qat_asym PF_ALG interface that allows access acceleration H=
W from
user space thorough a QAT library available from 01.org website.
User space applications can use the QAT services through QAT API.
The QAT user space library creates job description requests, and sends
it through qat socket to QAT driver. The driver validates the request,
remaps user virtual memory (for symmetric ciphers) or copies the input
parameters (for public key crypto) and sends it to the acceleration har=
dware.
The data is then processed and the library is notified when it is ready
by calling select on the socket.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

Tadeusz Struk (4):
      crytpo: qat - Fix 64 bytes requests
      crypto: qat - Add PKE firmware
      crypto: qat - Add userspace instances
      crypto: qat - Add new algif interface for userspace


 drivers/crypto/qat/Kconfig                         |    9=20
 drivers/crypto/qat/qat_common/Makefile             |    3=20
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   19=20
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |   42 +
 drivers/crypto/qat/qat_common/adf_cfg_strings.h    |    1=20
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   39 +
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |   13=20
 .../qat/qat_common/adf_transport_access_macros.h   |    9=20
 drivers/crypto/qat/qat_common/algif_qat.c          |  532 ++++++++++++=
+
 drivers/crypto/qat/qat_common/algif_qat_asym.c     |  791 ++++++++++++=
++++++++
 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h     |   99 +++
 drivers/crypto/qat/qat_common/qat_algs.c           |   22 -
 drivers/crypto/qat/qat_common/qat_bufs.h           |   65 ++
 drivers/crypto/qat/qat_common/qat_crypto.c         |  189 +++--
 drivers/crypto/qat/qat_common/qat_crypto_user.c    |  251 ++++++
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   86 --
 16 files changed, 1997 insertions(+), 173 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/algif_qat.c
 create mode 100644 drivers/crypto/qat/qat_common/algif_qat_asym.c
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_bufs.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_crypto_user.c

--=20
