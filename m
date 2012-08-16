From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: on stack dynamic allocations
Date: Fri, 17 Aug 2012 00:20:53 +0300
Message-ID: <CALLzPKYzc5FwPFTn5Ztg58vfkMO2EZ8P-MLEmVXRqdBE+CkkSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:31655 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030486Ab2HPVUz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2012 17:20:55 -0400
Received: by qcmv28 with SMTP id v28so2383829qcm.25
        for <linux-crypto@vger.kernel.org>; Thu, 16 Aug 2012 14:20:53 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Some places in the code uses variable-size allocation on stack..
For example from hmac_setkey():

	struct {
		struct shash_desc shash;
		char ctx[crypto_shash_descsize(hash)];
	} desc;


sparse complains

CHECK   crypto/hmac.c
crypto/hmac.c:57:47: error: bad constant expression

I like it instead of kmalloc..

But what is position of kernel community about it?

- Dmitry
