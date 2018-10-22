Return-Path: <SRS0=9uPW=NC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49538 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727497AbeJVPuk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Oct 2018 11:50:40 -0400
Message-ID: <1540193596.3202.7.camel@HansenPartnership.com>
Subject: [PATCH v4 0/7] add integrity and security to TPM2 transactions
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-integrity@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 22 Oct 2018 08:33:16 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

By now, everybody knows we have a problem with the TPM2_RS_PW easy
button on TPM2 in that transactions on the TPM bus can be intercepted
and altered.  The way to fix this is to use real sessions for HMAC
capabilities to ensure integrity and to use parameter and response
encryption to ensure confidentiality of the data flowing over the TPM
bus.

This patch series is about adding a simple API which can ensure the
above properties as a layered addition to the existing TPM handling
code.  This series now includes protections for PCR extend, getting
random numbers from the TPM and data sealing and unsealing.  It
therefore eliminates all uses of TPM2_RS_PW in the kernel and adds
encryption protection to sensitive data flowing into and out of the
TPM.

In the third version I added data sealing and unsealing protection,
apart from one API based problem which means that the way trusted keys
were protected it's not currently possible to HMAC protect an authority
that comes with a policy, so the API will have to be extended to fix
that case

In this fourth version, I tidy up some of the code and add more
security features, the most notable is that we now calculate the NULL
seed name and compare our calculation to the value returned in
TPM2_ReadPublic, which means we now can't be spoofed.  This version
also gives a sysfs variable for the null seed which userspace can use
to run a key certification operation to prove that the TPM was always
secure when communicating with the kernel.

I've verified this using the test suite in the last patch on a VM
connected to a tpm2 emulator.  I also instrumented the emulator to make
sure the sensitive data was properly encrypted.

James

---


James Bottomley (7):
  tpm-buf: create new functions for handling TPM buffers
  tpm2-sessions: Add full HMAC and encrypt/decrypt session handling
  tpm2: add hmac checks to tpm2_pcr_extend()
  tpm2: add session encryption protection to tpm2_get_random()
  trusted keys: Add session encryption protection to the seal/unseal
    path
  tpm: add the null key name as a tpm2 sysfs variable
  tpm2-sessions: NOT FOR COMMITTING add sessions testing

 drivers/char/tpm/Kconfig              |    3 +
 drivers/char/tpm/Makefile             |    3 +-
 drivers/char/tpm/tpm-buf.c            |  191 ++++++
 drivers/char/tpm/tpm-chip.c           |    1 +
 drivers/char/tpm/tpm-sysfs.c          |   27 +-
 drivers/char/tpm/tpm.h                |  129 ++--
 drivers/char/tpm/tpm2-cmd.c           |  248 ++++---
 drivers/char/tpm/tpm2-sessions-test.c |  360 ++++++++++
 drivers/char/tpm/tpm2-sessions.c      | 1188 +++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2-sessions.h      |   57 ++
 10 files changed, 2027 insertions(+), 180 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-buf.c
 create mode 100644 drivers/char/tpm/tpm2-sessions-test.c
 create mode 100644 drivers/char/tpm/tpm2-sessions.c
 create mode 100644 drivers/char/tpm/tpm2-sessions.h

-- 
2.16.4
