From: "Russ Dill" <russ.dill@gmail.com>
Subject: CTS (cipher text stealing mode) and short packets
Date: Mon, 29 Sep 2008 15:18:56 -0700
Message-ID: <f9d2a5e10809291518l5de2c8c1i3b7750c0e50076bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Kevin Coffman" <kwc@citi.umich.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:44957 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYI2WS5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Sep 2008 18:18:57 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2507823rvb.1
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2008 15:18:56 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto/cts.c currently implements RFC 3962. It deviates from the basic
CTS algorithm in two ways. The first is that it does not support
encrypting data blocks smaller than the underlying block size. Reading
and writing past the end of buffers will occur if it is attempted.

Second, when the length of data to be encrypted is exactly one block,
it is encrypted with plain CBC.

Normally, when packets are of size less than or equal to the block
size, the algorithm uses the IV as the "previous block" and swaps bits
with that data instead.

What would be the best way to implement these slightly two different
behaviors? The primary difference between the two CTS methods seems to
be what to do when the input size is equal to the block size.
