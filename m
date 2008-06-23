From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1/1 v2] crypto: Add CryptoAPI User Interface Support
Date: Mon, 23 Jun 2008 16:01:17 +0400
Message-ID: <20080623120117.GA29087@2ka.mipt.ru>
References: <0CA0A16855646F4FA96D25A158E299D604921C4D@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53319 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbYFWMBR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Jun 2008 08:01:17 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604921C4D@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Thu, Jun 12, 2008 at 01:54:00PM -0700, Loc Ho (lho@amcc.com) wrote:
> This is CryptoAPI user space interface support patch v2. This version
> includes:
> 
> 1. a file descriptor per tfm
> 2. Direct I/O for user data buffer (with option for single mapping)
> 3. algorithm properties is set via I/O control call
> 4. Per buffer operation is operated via I/O control call

Number of overall moments:
 * your mailer heavily mangled patch, please fix it or attach patch next
 	time
 * be ready to defend, why /dev/crypto should be char device and not
 	misc, also why it is not a syscall :)
 * overall approach of multiple copy_from_user is noticebly slower than
 	single copy_from_user of the whole structure and they parse it
	according to internal fields
 * the same applies to multiple allocations: try to avoid it as much as
 	possible and allocate whole structure in one go

-- 
	Evgeniy Polyakov
