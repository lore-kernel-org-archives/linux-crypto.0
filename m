From: Gary R Hook <ghook@amd.com>
Subject: testmgr.h
Date: Tue, 9 Aug 2016 08:21:43 -0500
Message-ID: <e1ec0bc6-59cf-22d7-f8fd-59a337393b6d@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0052.outbound.protection.outlook.com ([104.47.32.52]:8357
	"EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932223AbcHINV4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 09:21:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Q: Is there a policy (de facto or otherwise) on adding tests to testmgr.h?
Two cases:

1) Tests from the NIST document(s) on various ciphers and hashes wherein
we add to an existing set of tests? For example, 3DES ECB mode, or AES
GCM? I suppose this question is really about, "how much is enough?"

2) Adding testing for a mode that has not heretofore been included? For
example, 3DES CFB mode? Pretty sure the answer here is "yes".

Over-arching concern: do we want to include official NIST test cases, or
eschew them?

There was no obvious reference to this (by way of grepping for testmgr)
in any of the existing Documentation. That I could find. If I missed
something, please excuse me.

Thanks,
Gary
