From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/2] KEYS: Use pkcs1pad for padding in software_pkey
Date: Wed, 24 Feb 2016 09:12:37 -0800
Message-ID: <20160224171237.29272.51126.stgit@tstruk-mobl1>
References: <12559.1456224799@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	balrogg@googlemail.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: dhowells@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <12559.1456224799@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi David,
I have converted the software_pkey to make use of the pkcs1pad
template. The rsa.c is reverted back to what it was i.e. just
math primitives and all padding is done in rsa-pkcs1padd.c
software_pkey.c just allocates pksc1padd(alg,hash)

This is incremental series on top of the current
http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-rsa

---

Tadeusz Struk (2):
      crypto: Add hash param to pkcs1pad
      crypto: remove paddings logic from rsa.c


 crypto/asymmetric_keys/software_pkey.c |   28 ++++
 crypto/rsa-pkcs1pad.c                  |  182 ++++++++++++++++++++++++----
 crypto/rsa.c                           |  210 +++++---------------------------
 crypto/testmgr.c                       |    5 -
 include/crypto/akcipher.h              |    7 -
 5 files changed, 212 insertions(+), 220 deletions(-)
