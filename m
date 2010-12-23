From: Phil Sutter <phil@nwl.cc>
Subject: Improving SHA-1 performance with Intel SSE3
Date: Thu, 23 Dec 2010 14:55:13 +0100
Message-ID: <20101223135513.GA20507@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.141.167]:51389 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0LWOB1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Dec 2010 09:01:27 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear list,

I am doing performance tests on an Intel I5 (661 i think) based machine.
Thanks to the AES-NI extensions, I am able to get a throughput of about
500MB/s when doing AES256.

But for TLS, hashing performance is important, too. SSE4.2 provides no
equivalent extension for SHA-1, so that needs to be done purely in
software - with a resulting throughput of about 200MB/s.

Given a situation where I need to both hash and encrypt some plaintext,
throughput drops even worse to about 180MB/s since both operations need
to be done sequentially (this all is done on a single core, btw).

So despite the very stunning AES performance, I guess one has a hard
time saturating the wire (full-duplex) with TLS. Is that correct so far,
or am I getting something wrong here?

The actual question (indeed related to the subject) is this: are there
any implementations/plans on using SSE3 to speed up SHA-1 as stated in
[1]? Do you see any possible problems when trying to do so (regarding
e.g. SSE3 detection or something)?

Greetings, Phil

1: http://software.intel.com/en-us/articles/improving-the-performance-of-the-secure-hash-algorithm-1/?wapkw=(sha1+optimization)
