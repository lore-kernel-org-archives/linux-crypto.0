From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 0/3] convert hmac to ahash
Date: Tue, 7 Jul 2009 09:23:43 +0200
Message-ID: <20090707072343.GC20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:36437 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZGGHVE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2009 03:21:04 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset converts hmac to the new ahash frontend. It has just some
basic tests and is not yet for inclusion.

Steffen
