From: David Howells <dhowells@redhat.com>
Subject: Moving asymmetric keys from crypto/ to security/keys/
Date: Wed, 13 Apr 2016 13:45:38 +0100
Message-ID: <776.1460551538@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
To: jmorris@namei.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbcDMMpm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Apr 2016 08:45:42 -0400
Content-ID: <775.1460551538.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James, Herbert,

Since the actual crypto bits (RSA) have been extracted from the asymmetric
keys code and moved to base crypto, shall I move the asymmetric_keys/ subdir
over to security/keys/?

If so, how best to do it?  I'm thinking that it might be best for me to create
a git branch that effects the change and then have both of you merge it so
that when Linus pulls your stuff in the next merge window git just handles it.

That said, there is a change to the PKCS#7 code in Herbert's tree that's not
in security/next or upstream which complicates matters - though possibly this
being fixed up in the merge will be handled by git.

David
