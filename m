From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: Questions about the Crypto API
Date: Mon, 5 Aug 2013 17:25:57 -0300
Message-ID: <20130805202557.GE5752@oc8526070481.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:54066 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab3HEU0I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Aug 2013 16:26:08 -0400
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Mon, 5 Aug 2013 17:26:06 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 848F8352005F
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2013 16:26:03 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay02.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r75KOSan26542172
	for <linux-crypto@vger.kernel.org>; Mon, 5 Aug 2013 17:24:28 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r75KQ2vw006886
	for <linux-crypto@vger.kernel.org>; Mon, 5 Aug 2013 17:26:03 -0300
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm starting to work on some platform-specific implementations using the
Crypto API. I spent some time reading the available documentation and
mainly the code, but I still have some doubts on how the Crypto API
works and how it should be used.

My first doubt is regarding which kind of concurrency the Crypto API
allows. For example, can a single `struct crypto_tfm` be used by two
concurrent calls? I'm asking about that because I noticed that for
blkcipher the only implementation-specific context that can be used is
allocated inside the tfm struct.

I'm working to fix some bugs in the NX driver (located in
drivers/crypto/nx), and one issue that we are facing is that NFS when
using Kerberos uses the same tfm with different kthreads. That causes
concurrent accesses to the internal data stored into the context and
incorrect results.

So my question here is: should this type of concurrency be handled by
the driver or a caller is not allowed to use the same tfm for concurrent
calls?

My second doubt is regarding the difference between ablkcipher and
blkcipher. I do understand their difference from caller's point of view.
But I'm not sure what are the consequences of implementing a driver
using one or another option.

For example, can a blkcipher implementation be used asynchronously and
vice versa?

Thanks for your help.
Marcelo
