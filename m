From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: Workaround for tcrypt bug?
Date: Fri, 28 Dec 2012 14:55:09 +0200
Message-ID: <20121228145509.16824jqi8bl9komo@www.dalek.fi>
References: <CAELiMBOPsPOWNe6+LahiBqGteucai0xrqY+eQ0nxkghjAEsy-A@mail.gmail.com>
 <CAELiMBOtmQwY8kH=nLTZzjPtNqPsC_GGgs=gDe7pQwFewsxY1A@mail.gmail.com>
 <20121228141825.11102bkeriixmuqs@www.dalek.fi>
 <CAELiMBMrmagP14SoE1aaDqnuXvwdtVM69zpmK5dn+9Zqby8sQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sandra Schlichting <littlesandra88@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:52782 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2L1MzM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Dec 2012 07:55:12 -0500
In-Reply-To: <CAELiMBMrmagP14SoE1aaDqnuXvwdtVM69zpmK5dn+9Zqby8sQw@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Sandra Schlichting <littlesandra88@gmail.com>:

>> Why you want to workaround this? It's safe to ignore hmac(crc32) warning.
>
> Because it stops from proceeding. I would have expected that
>
> modprobe tcrypt sec=1 type=1000
>
> would have executed all test cases.
>
> Even if I just want to test one
>
> [root@amd ~]# modprobe tcrypt sec=2 type=402
> ERROR: could not insert 'tcrypt': No such file or directory
>
> I get an error.

I think you are using wrong module argument, type= instead of mode=.  
Try 'modprobe tcrypt sec=2 mode=402' instead.

-Jussi
