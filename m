From: "Kevin Coffman" <kwc@citi.umich.edu>
Subject: AES with CTS Mode
Date: Tue, 15 Jan 2008 15:28:15 -0500
Message-ID: <4d569c330801151228o1cf32b2dn6f6e49922b1036e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.233]:28077 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbYAOU2S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Jan 2008 15:28:18 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1499257wxd.4
        for <linux-crypto@vger.kernel.org>; Tue, 15 Jan 2008 12:28:17 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,
I need to implement AES with CTS mode for NFSv4 (rfc3962 & rfc4121).

I have implemented CTS starting with a copy of CBC (crypto/cbc.c),
since CTS is the same as CBC except for the last two blocks.

A problem that I'm running into is that the NFS/RPC code needs to call
the crypt functions in chunks as we currently do for other encryption
types.  However, I am not seeing a way to inform the crypto code of
the total length to be encrypted such that it can just do regular CBC
until the last two blocks (of the last chunk).

Am I missing something, or is there an example of this sort of thing
that I am missing?  Any other suggestions?

Thanks,
K.C.
