From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1/1 v4] Add CryptoAPI User Interface Support
Date: Wed, 6 Aug 2008 13:09:38 +0400
Message-ID: <20080806090938.GB14382@2ka.mipt.ru>
References: <0CA0A16855646F4FA96D25A158E299D604CAFC9B@SDCEXCHANGE01.ad.amcc.com> <20080804142143.GA21120@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D604CB04AE@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Shasi Pulijala <spulijala@amcc.com>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:43867 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764614AbYHFJJt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Aug 2008 05:09:49 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604CB04AE@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Mon, Aug 04, 2008 at 10:43:13AM -0700, Loc Ho (lho@amcc.com) wrote:
> We wasn't plan on protecting this. It is the caller responsibity to call in the proper order. If the caller want to change the key, it musts do so before issue run or after all run operations completed. Actually, I think it is better if we drop setkey. If the caller want to operate on a different key, create another transform. Are you concern that the underlying driver might have problem handling key change?

Fair enough. If caller is not responsible to protect against
simultaneous runs it is not a task for kernel to help him.

But problem still exists, since there can be a leak in
cryptodev_ioctl(CIOCGSESSION): if two or more threads simultaneously
entered cryptdev_user_create_session() and each one allocated own
session, only the last one will be assigned to the file->private_data
and will be eventually freed, others will leak.

-- 
	Evgeniy Polyakov
