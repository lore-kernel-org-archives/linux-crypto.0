From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: talitos - fix bug in sg_copy_end_to_buffer
Date: Mon, 12 Jul 2010 19:22:00 -0500
Message-ID: <20100712192200.b5f6003a.kim.phillips@freescale.com>
References: <1278879846-29701-1-git-send-email-lee.nipper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Lee Nipper <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:7093
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab0GMAho (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Jul 2010 20:37:44 -0400
Received: from mail74-db3 (localhost.localdomain [127.0.0.1])	by
 mail74-db3-R.bigfish.com (Postfix) with ESMTP id 9985CB501B1	for
 <linux-crypto@vger.kernel.org>; Tue, 13 Jul 2010 00:22:40 +0000 (UTC)
Received: from DB3EHSMHS012.bigfish.com (unknown [10.3.81.241])	by
 mail74-db3.bigfish.com (Postfix) with ESMTP id 6606F1AA8099	for
 <linux-crypto@vger.kernel.org>; Tue, 13 Jul 2010 00:22:05 +0000 (UTC)
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by az33egw02.freescale.net (8.14.3/8.14.3) with ESMTP id o6D0M2KT024676	for
 <linux-crypto@vger.kernel.org>; Mon, 12 Jul 2010 17:22:02 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net
 [10.64.32.10])	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id
 o6D0Ys8f013786	for <linux-crypto@vger.kernel.org>; Mon, 12 Jul 2010 19:34:54
 -0500 (CDT)
In-Reply-To: <1278879846-29701-1-git-send-email-lee.nipper@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 11 Jul 2010 15:24:06 -0500
Lee Nipper <lee.nipper@gmail.com> wrote:

> In function sg_copy_end_to_buffer, too much data
> is copied when a segment in the scatterlist
> has .length greater than the requested copy length.
> 
> This patch adds the limit checks to fix this bug of over copying,
> which affected only the ahash algorithms.
> 
> Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
> ---
> Kim, this corrects the problem causing exceptions
> for tcrypt tests 402, 403, and 404.
> With this patch the tcrypt tests run through ok.

Ack, but..

> +				if ((boffset + len) > buflen)

inner parens aren't necessary.

Kim
