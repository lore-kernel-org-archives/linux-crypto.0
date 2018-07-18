From: Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation encryption
Date: Thu, 19 Jul 2018 00:38:06 +0800
Message-ID: <cover.1531924968.git.yu.c.chen@intel.com>
Cc: linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Gu, Kookoo" <kookoo.gu@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>, Chen Yu <yu.c.chen@intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Eric Biggers <ebiggers@google.com>,
        Len Brown <len.brown@intel.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, "Theodore Ts o" <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

As security becomes more and more important, we add the in-kernel
encryption support for hibernation.

This prototype is a trial version to implement the hibernation
encryption in the kernel. This patch set is divided
into two parts:
1. The hibernation snapshot encryption in kernel space.
2. The key derivation implementation in user space.

The whole process is illustrated below:
1. install the kernel module:
   modprobe crypto_hibernation
2. run the tool to generate the key from
   user provided passphrase (salt has been read
   from kernel).
3. launch the hibernation process, the kernel
   uses the key in step 2 to encrypt the
   hibernation snapshot.
4. resume the system and the initrd will
   launch cryto_hibernate to read previous salt
   from kernel and probe the user passphrase
   and generate the same key.
5. kernel uses this key to decrypt the hibernation
   snapshot and restore to previous system.

Chen Yu (4):
  PM / Hibernate: Add helper functions for hibernation encryption
  PM / hibernate: Install crypto hooks for hibernation encryption
  PM / Hibernate: Encrypt the snapshot pages before submitted to the
    block device
  tools: create power/crypto utility

 include/linux/suspend.h               |  40 +++
 kernel/power/Kconfig                  |  14 ++
 kernel/power/Makefile                 |   1 +
 kernel/power/crypto_hibernation.c     | 421 +++++++++++++++++++++++++++++++
 kernel/power/hibernate.c              |  67 +++++
 kernel/power/power.h                  |  67 +++++
 kernel/power/swap.c                   | 182 +++++++++++++-
 tools/power/crypto/Makefile           |  24 ++
 tools/power/crypto/crypto_hibernate.c | 462 ++++++++++++++++++++++++++++++++++
 9 files changed, 1270 insertions(+), 8 deletions(-)
 create mode 100644 kernel/power/crypto_hibernation.c
 create mode 100644 tools/power/crypto/Makefile
 create mode 100644 tools/power/crypto/crypto_hibernate.c

-- 
2.7.4
