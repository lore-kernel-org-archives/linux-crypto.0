From: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: Asynchronus crypto API
Date: Fri, 9 Feb 2007 12:08:00 +0100
Message-ID: <20070209110800.GB25171@amd.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64563 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161237AbXBILOG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Feb 2007 06:14:06 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

recently I read the documentation in Documentation/crypto/ to learn
something about the Linux crypto API internals. There I read the
following sentence

"Support for hardware crypto devices via an asynchronous interface is
under development."

Since this sentence is present at least since kernel 2.6.0 I would like
to ask what the current state in the development of that API is?
Is somebody still working on that API or are there some existing ideas
for that which want to be implemented? I would like to help out with
that if the help is needed.
Background: I recently bought a HIFN crypto card and would like to use
it under Linux without the need to use some external patchsets :)

Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG
