From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 0/5] RFC v2: AF_ALG auditing
Date: Wed, 24 Nov 2010 18:05:50 +0100
Message-ID: <1290618355-31193-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-audit@redhat.com, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: eparis@redhat.com, herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab0KXRGL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Nov 2010 12:06:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,
these patches add support for auditing uses of the AF_ALG protocol fami=
ly
developed by Herbert Xu to provide user-space access to kernel crypto
accelerators.

One new record is defined: AUDIT_CRYPTO_USERSPACE_OP.  An audited event
is always caused by a syscall, and all other syscall-related data
(process identity, syscall result) is audited in the usual records.

To disable auditing crypto by default and to allow the users to
selectively enable them using filters, a new filter field
AUDIT_CRYPTO_OP is defined; auditing of all crypto operations can
thus be enabled using (auditctl -a exit,always -F crypto_op!=3D0).

Changes since the previous version:
* Use audit_aux_data instead of a separate linked list
* Don't overwrite initial values of "err" by 0 in algif_skcipher.c
    Mirek

Miloslav Trma=C4=8D (5):
  Add general crypto auditing infrastructure
  Add unique IDs to AF_ALG sockets
  Add "alg_name" operation to af_alg_type.
  Audit type-independent events
  Audit type-specific crypto operations

 crypto/af_alg.c         |  110 +++++++++++++++++++++++++++++++++++++++=
+++++++-
 crypto/algif_hash.c     |   35 +++++++++++++--
 crypto/algif_skcipher.c |   28 +++++++++++-
 include/crypto/if_alg.h |   17 +++++--
 include/linux/audit.h   |   22 +++++++++
 kernel/auditfilter.c    |    2 +
 kernel/auditsc.c        |   97 +++++++++++++++++++++++++++++++++++++++=
++
 7 files changed, 296 insertions(+), 15 deletions(-)

--=20
1.7.3.2
