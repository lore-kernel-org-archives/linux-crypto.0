From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 0/3] crypto: add testmgr support and self-tests for rfc4309
Date: Wed, 15 Apr 2009 09:35:15 -0400
Message-ID: <200904150935.15947.jarod@redhat.com>
References: <200904091434.59639.jarod@redhat.com> <20090415112053.GA10188@gondor.apana.org.au> <200904150835.38818.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39757 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbZDONgB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Apr 2009 09:36:01 -0400
In-Reply-To: <200904150835.38818.jarod@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series adds necessary fix-ups and infrastructure additions to
testmgr/tcrypt to support the inclusion of rfc4309(ccm(aes)) self-tests,
and finally, the rfc4309 test vectors themselves.

[PATCH 1/3] crypto: properly handle null input and assoc data aead test vectors
[PATCH 2/3] crypto: handle ccm dec test vectors expected to fail verification
[PATCH 3/3] crypto: add self-tests for rfc4309(ccm(aes))

-- 
Jarod Wilson
jarod@redhat.com
