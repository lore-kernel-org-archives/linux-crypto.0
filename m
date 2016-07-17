From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/3] KEYS: Miscellaneous fixes
Date: Mon, 18 Jul 2016 00:10:32 +0100
Message-ID: <146879703192.32133.3670984393495441516.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, keyring@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: jmorris@namei.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbcGQXKe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jul 2016 19:10:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi James,

Here are three miscellaneous fixes:

 (1) Fix a panic in some debugging code in PKCS#7.  This can only happen by
     explicitly inserting a #define DEBUG into the code.

 (2) Fix the calculation of the digest length in the PE file parser.  This
     causes a failure where there should be a success.

 (3) Fix the case where an X.509 cert can be added as an asymmetric key to
     a trusted keyring with no trust restriction if no AKID is supplied.

Bugs (1) and (2) aren't particularly problematic, but (3) allows a security
check to be bypassed.  Bug (3) is added since the 4.6 kernel.

The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-fixes

at tag:

	keys-fixes-20160718

David
---
Lans Zhang (2):
      PKCS#7: Fix panic when referring to the empty AKID when DEBUG defined
      pefile: Fix the failure of calculation for digest

Mat Martineau (1):
      KEYS: Fix for erroneous trust of incorrectly signed X.509 certs


 crypto/asymmetric_keys/mscode_parser.c |    7 ++++++-
 crypto/asymmetric_keys/pkcs7_verify.c  |    2 +-
 crypto/asymmetric_keys/restrict.c      |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)
