From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: async hash & hmac
Date: Fri, 11 May 2012 11:58:03 +0300
Message-ID: <CALLzPKYuFWAbzB8EQ=QxWe+kpFqkEZRVJVimtVUNsw39miUntA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13799 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2EKI6D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 May 2012 04:58:03 -0400
Received: by dano14 with SMTP id o14so9760959dan.25
        for <linux-crypto@vger.kernel.org>; Fri, 11 May 2012 01:58:03 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

When allocating hmac like: crypto_alloc_ahash("hmac(sha1)", ..),
it is actually fallsback to  "shash" hmac and software shash hash
implementation..
Even when HW accelerator provides AHASH it will not be used with hmac.

Basically HW driver needs to provide its own implementation for async
hmac, like I did for omap-sham.

		.cra_name		= "hmac(sha1)",
		.cra_driver_name	= "omap-hmac-sha1",

Is that correct, right?

Thanks.

- Dmitry
