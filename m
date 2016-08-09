From: Stephan Mueller <smueller@chronox.de>
Subject: Re: testmgr.h
Date: Tue, 09 Aug 2016 15:31:46 +0200
Message-ID: <33428843.kG9ECo6VM2@tauon.atsec.com>
References: <e1ec0bc6-59cf-22d7-f8fd-59a337393b6d@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34394 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbcHINbt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 09:31:49 -0400
In-Reply-To: <e1ec0bc6-59cf-22d7-f8fd-59a337393b6d@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. August 2016, 08:21:43 CEST schrieb Gary R Hook:

Hi Gary,

> Q: Is there a policy (de facto or otherwise) on adding tests to testmgr.h?
> Two cases:
> 
> 1) Tests from the NIST document(s) on various ciphers and hashes wherein
> we add to an existing set of tests? For example, 3DES ECB mode, or AES
> GCM? I suppose this question is really about, "how much is enough?"
> 
> 2) Adding testing for a mode that has not heretofore been included? For
> example, 3DES CFB mode? Pretty sure the answer here is "yes".
> 
> Over-arching concern: do we want to include official NIST test cases, or
> eschew them?
> 
> There was no obvious reference to this (by way of grepping for testmgr)
> in any of the existing Documentation. That I could find. If I missed
> something, please excuse me.

It is always helpful to use test vectors that are created by some third 
parties. These are NIST test vectors or test vectors in RFCs. In some cases, 
vectors were created using OpenSSL.

Regarding the question how much: I can only answer to the FIPS 140-2 
requirements: all tests that need to be there for FIPS 140-2 are there for 
those with fips_allowed=1.

Ciao
Stephan
