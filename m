From: Stephan Mueller <smueller@chronox.de>
Subject: DH & KDF
Date: Sat, 02 Jul 2016 20:46:43 +0200
Message-ID: <47344115.AvlVGsj60Z@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:38588 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbcGBSrQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Jul 2016 14:47:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Mat, David,

I am currently working on adding the KDF support to the DH key service. The 
plan is to make it consistent with SP800-56A section 5.8.1 and yet open enough 
to allow other use cases with other KDFs.

Is there already a test tool that already exercises the DH logic that I can 
use to test my extension?

Thanks.

Ciao
Stephan
