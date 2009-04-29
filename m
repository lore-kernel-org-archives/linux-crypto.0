From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 0/2] crypto: ansi_cprng self-test infra and vectors
Date: Tue, 28 Apr 2009 21:27:32 -0400
Message-ID: <200904282127.33190.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Neil Horman <nhorman@tuxdriver.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60082 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZD2B1k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2009 21:27:40 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To be able to use ansi_cprng in fips mode, we need to run ansi_cprng
self-tests before it can be used.

[PATCH 1/2] add infrastructure for ansi_cprng self-tests
[PATCH 2/2] add ansi_cprng test vectors

-- 
Jarod Wilson
jarod@redhat.com
