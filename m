From: "Tsai, Hong-Bin" <hbtsai@gmail.com>
Subject: How to utilize crypto source in kernel?
Date: Thu, 22 Mar 2007 17:48:20 +0800
Message-ID: <3befbf920703220248k3449d916ycd578bddc814246a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:8448 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbXCVJsY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Mar 2007 05:48:24 -0400
Received: by ug-out-1314.google.com with SMTP id 44so635194uga
        for <linux-crypto@vger.kernel.org>; Thu, 22 Mar 2007 02:48:22 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dear gurus:

I'd like to modify the kernel to load a encrypted initrd. While
loading the initial ramdisk, kernel reads secret key from somewhere
else and decrypts initrd, and then continues the boot process.
However, I met a problem.

Since there are crypto libraries reside in kernel, I believe that's
the best resource for me to implement this mechanism. At first I
followed the interfaces found in crypto/api.c, but found it is loads
crypto-algorithms from modules. Even after I configured an algo as
build-in module (say, aes), I always failed at its initialization
stage. (crypto_alloc_blkcipher returns error)

Please give me suggestions. Am I on a right course?

-- 
Best regards,
Hong-Bin
blog: http://furseal.wordpress.com
msn: benjamin@benjamin.idv.tw
