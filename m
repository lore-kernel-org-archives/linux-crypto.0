From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: OpenSSL patch to support Linux CryptoAPI.
Date: Sat, 9 Aug 2008 10:29:41 +0400
Message-ID: <20080809062941.GA25828@2ka.mipt.ru>
References: <DB599F406D04E34389140B7D99C71B1B05D9E002@SDCEXCHANGE01.ad.amcc.com> <20080808210949.GA6535@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D604D28FD5@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Shasi Pulijala <spulijala@amcc.com>
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:34077 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbYHIG31 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Aug 2008 02:29:27 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604D28FD5@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Fri, Aug 08, 2008 at 03:24:20PM -0700, Loc Ho (lho@amcc.com) wrote:
> This sound like the only solution to passing more than one pointers from user space is via custom system call - such as (new) crypto_op(...). Am I correct?

No, it is not a right solution. Linux has so ugly compat layer to fix
this problems, that it is much better not to look at it before the
dinner.

You do not need to pass multiple pointers, but instead a multiple data.
You can do that via single area provided to the kernel and multiple size
fields, where each one corresponds to the size of the contiguous sectors
in the provided data.

-- 
	Evgeniy Polyakov
