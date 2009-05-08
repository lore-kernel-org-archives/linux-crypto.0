From: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: pcomp for lzma for later use with squashfs
Date: Fri, 08 May 2009 16:08:29 +0100
Message-ID: <4A044AED.2020804@lougher.demon.co.uk>
References: <4A041EE5.4000008@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	linux-crypto@vger.kernel.org
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:37211 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbZEHPI0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 May 2009 11:08:26 -0400
In-Reply-To: <4A041EE5.4000008@hiramoto.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Karl Hiramoto wrote:
> Hi Geert,
> 
> Was wondering if there are any patches for pcomp lzma. it it just a 
> matter of adding crypto/lzma to make the calls to lib/decompress_unlzma.c ?
> 
> I just started looking at this, my end goal is to use your pcomp patch 
> for squashfs and get lzma squahsfs.
> 

If you can get crypto/lzma working with Squashfs that would be good.  It will
be an added reason to move Squashfs over to the cryto API.

Thanks

Phillip

