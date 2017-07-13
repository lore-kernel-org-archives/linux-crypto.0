From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 3/6] fscrypt: use HKDF-SHA512 to derive the per-inode encryption keys
Date: Thu, 13 Jul 2017 18:18:02 +0200
Message-ID: <4273111.qD8qsi0XUh@tauon.chronox.de>
References: <20170712210035.51534-1-ebiggers3@gmail.com> <2034167.Brpu2WxA6s@tauon.chronox.de> <20170713160753.GA25989@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Alex Cope <alexcope@google.com>,
        Eric Biggers <ebiggers@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60534 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752517AbdGMQSN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 12:18:13 -0400
In-Reply-To: <20170713160753.GA25989@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 13. Juli 2017, 18:07:54 CEST schrieb Herbert Xu:

Hi Herbert,

> Sure.  Though I'd like to see what it looks like before I commit :)

Naturally. :-)

The patches would create an RNG template support. KDFs are not more than 
special-purpose RNGs.

Ciao
Stephan
