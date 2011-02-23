From: "Mark Burkley" <crypto-dev@emutex.com>
Subject: Development of asynchronous deflate for IPComp
Date: Wed, 23 Feb 2011 09:59:27 -0000
Message-ID: <010001cbd340$5ee932e0$1cbb98a0$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gran.netsource.ie ([212.17.32.37]:42084 "EHLO gran.netsource.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab1BWLB7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Feb 2011 06:01:59 -0500
Received: from 87-198-137-210.static.ptr.magnet.ie ([87.198.137.210] helo=statler.emutex.com)
	by gran.netsource.ie with esmtp (Exim 3.36 #1)
	id 1PsBVP-0005aT-00
	for linux-crypto@vger.kernel.org; Wed, 23 Feb 2011 09:59:35 +0000
Content-Language: en-ie
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

Just a short note to let you know we are almost finished development of a
patch to allow asynchronous compression in ipcomp.  This enables a module to
register asynchronous deflate in order to use a hardware deflate
accelerator.

We followed the scheme for ahash and ablkcipher to create an acompress
strcuture and modified xfrm_ipcomp.c to handle an -EINPROGRESS return from
the call to comp_compress with a callback that completes building the IPComp
header and then calls xfrm_output_resume.

I did a quick search but didn't find any other patches to enable asynch
compression but I would be interested to hear from anyone else who might be
working in this area.

There are no immediate plans to upstream the patch (we are still on 2.6.29)
but it is something I will be pushing for especially if there is interest in
adding this to the kernel.

Feedback welcome,

Thanks,

Mark


-- 
Mark Burkley <mark@emutex.com>            
http://www.emutex.com/
