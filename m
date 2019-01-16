Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.100]:28424 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392416AbfAPLMG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 06:12:06 -0500
From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/6] General Key Derivation Function Support
Date: Wed, 16 Jan 2019 12:06:54 +0100
Message-ID: <2082192.jPI8ve1O8G@positron.chronox.de>
In-Reply-To: <9733066.Vrs4h5eWcW@positron.chronox.de>
References: <20190103143227.9138-1-jlee@suse.com> <20190109082103.GA8586@sol.localdomain> <9733066.Vrs4h5eWcW@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes v2:
* Incorporation of all comments from Eric Biggers

Stephan Mueller (6):
  crypto: add template handling for RNGs
  crypto: kdf - SP800-108 Key Derivation Function
  crypto: kdf - add known answer tests
  crypto: hkdf - HMAC-based Extract-and-Expand KDF
  crypto: hkdf - add known answer tests
  crypto: tcrypt - add KDF test invocation

 crypto/Kconfig                |  13 +
 crypto/Makefile               |   2 +
 crypto/hkdf.c                 | 272 +++++++++++++++++++
 crypto/kdf_sp800108.c         | 491 ++++++++++++++++++++++++++++++++++
 crypto/rng.c                  |  44 +++
 crypto/tcrypt.c               |   8 +
 crypto/testmgr.c              | 245 +++++++++++++++++
 crypto/testmgr.h              | 198 ++++++++++++++
 include/crypto/internal/rng.h |  26 ++
 9 files changed, 1299 insertions(+)
 create mode 100644 crypto/hkdf.c
 create mode 100644 crypto/kdf_sp800108.c

-- 
2.20.1
