From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: talitos - protect against possible null ptr
 upon error
Date: Tue, 24 Mar 2009 16:23:45 -0500
Message-ID: <20090324162345.4b1b94d2.kim.phillips@freescale.com>
References: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Lee Nipper <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:59230 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZCXVFU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2009 17:05:20 -0400
In-Reply-To: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 15 Mar 2009 20:21:47 -0500
Lee Nipper <lee.nipper@gmail.com> wrote:

> Added test for null descriptor returned from current_desc.
> Also removed the diagnostic from current_desc,
> and added one instead in talitos_error
> to report an EU error without finding the descriptor.

Hi Lee, thanks for this - I'm not clear on how the channel error gets
triggered, points to an EU, and all of this without a referencing a
current descriptor.  How did you run into this case?  Assuming one does
get propagated back, what error status does the callback receive?
afaict, interrupt mitigation should not be intervening in this case.

Kim
