From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1/1 v4] Add CryptoAPI User Interface Support
Date: Mon, 4 Aug 2008 18:21:43 +0400
Message-ID: <20080804142143.GA21120@2ka.mipt.ru>
References: <0CA0A16855646F4FA96D25A158E299D604CAFC9B@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Shasi Pulijala <spulijala@amcc.com>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:56683 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbYHDOVo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 10:21:44 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604CAFC9B@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Wed, Jul 30, 2008 at 04:53:01PM -0700, Loc Ho (lho@amcc.com) wrote:
> This is Linux CryptoAPI user space interface support patch v4. This version includes:
> 
> * Add async support using Linux AIO.
> * Interafce to choose Copy to/from user and pinning pages based on size of data.
> * Asynchronous operations are issued through aio write function call. And result data
> is read back in the same context using the retry aio operations.
> * The crypto operation structure is passed via the data parameter of the write function.
> Internally, it will perform a copy from user call just as the synchronous I/O control version.

What does prevent from simultaneous command execution? Or setkey() vs.
run() race? Do you rely on BKL which 'guards' ioctl execution? How is
->write() protected from ioctl()?

Please also remove forward declarations and rearrange code if needed.
You can also drop looong ******** lines from comments.

-- 
	Evgeniy Polyakov
