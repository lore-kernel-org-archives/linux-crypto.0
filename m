From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: drivers/media/video/s5p-fimc/fimc-capture.c: boolean and / or
 confusion
Date: Tue, 13 Dec 2011 15:26:31 +0100
Message-ID: <4EE76097.4020303@samsung.com>
References: <4EE688FC.8090606@gmail.com> <1323733493.1812.10.camel@joe2Laptop>
 <1323734123.3837.2.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7BIT
Cc: roel <roel.kluin@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61018 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1LMO0e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 09:26:34 -0500
In-reply-to: <1323734123.3837.2.camel@joe2Laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/13/2011 12:55 AM, Joe Perches wrote:
> On Tue, 2011-12-13 at 00:06 +0100, roel wrote:
>> The test not [val1] or not [val2] always evaluates to true
> 
> Hello
> 
> Looking at drivers with:
> 
> $ grep -rP --include=*.[ch] "(\b[\w\[\]\>\._\-]+)\s*\!\=\s*[\w\[\]\>\._\-]+\s*\|\|\s*\1\s*\!\=" drivers
> 
> drivers/media/video/s5p-fimc/fimc-capture.c:		if (mf->width != tfmt->width || mf->width != tfmt->width) {
> drivers/media/video/s5p-fimc/fimc-capture.c:			if (mf->width != tfmt->width || mf->width != tfmt->width)
> 
> Most likely these tests should be:
> 	if (mf->height != tfmt->height || mf->width != tfmt->width)

Indeed. I'll prepare a patch fixing this.

-- 
Thank you,
Sylwester
