From: "Benjamin Gilbert" <bgilbert@cs.cmu.edu>
Subject: [PATCH 0/3] Remove dangling pieces of old digest/hash implementation
Date: Thu,  8 Oct 2009 17:41:02 -0400
Message-ID: <1255038065-3113-1-git-send-email-bgilbert@cs.cmu.edu>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from SMTP03.SRV.CS.CMU.EDU ([128.2.217.198]:32782 "EHLO
	smtp03.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbZJHVrb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2009 17:47:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello world,

This series removes several unused bits of code associated with the legacy
digest/hash implementation.  It also fixes one bug: out-of-tree algorithm
implementations which still use the legacy interface will build
successfully against 2.6.32-rc but oops when they are loaded.  Patch 3/3
causes such modules to FTBFS instead.

Compile-tested with allmodconfig.

--Benjamin Gilbert

