From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1/1 v5] Add CryptoAPI User Interface Patch v5
Date: Fri, 5 Sep 2008 20:32:08 +0400
Message-ID: <20080905163206.GA10078@2ka.mipt.ru>
References: <DB599F406D04E34389140B7D99C71B1B05FDE273@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Loc Ho <lho@amcc.com>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:55082 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbYIEQcx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Sep 2008 12:32:53 -0400
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B05FDE273@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

Sorry for late reply.

On Wed, Aug 27, 2008 at 02:23:31PM -0700, Shasi Pulijala (spulijala@amcc.com) wrote:
> Hi Evgeniy,
>  This is Linux CryptoAPI user space interface support patch v5. This version adds:
> -Preventing race conditions in session creation.
> -Crypto operations are now issued from user space using writev(sync) and AIO write(async) instead of ioctls.

There is number of issues I found with this version.
1. It does not apply since your mailer damaged the patch.
2. It does not follow codying style in several places (like spaces,
empty lines and other similar small stuff).
3. There are way _too_ many allocations. I think it does not matter too
much in case of expensive crypto processing, but I think it can be
reduced.
4. You should not pass double pointer to csession in allocation path.
Instead return allocated structure as a result value, and use ERR_PTR,
PTR_ERR and IS_ERR functions to check that returned pointer is valid or
error.
5. Main issue: it is not asynchronous crypto layer. I did not check
aio_write() processing, but otherwise you wait in the submission fuction
for the operation to complete. Also I'm not sure it works as expected,
since waiting in wait_for_completion_interruptible(&result->crypto_completion)
can be interrupted and storage freed (tmp variable and thus result
variable), so eventually when crypto core will invoke async completion
callback, it will oops.

-- 
	Evgeniy Polyakov
