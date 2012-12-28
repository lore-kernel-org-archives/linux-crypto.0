From: Sandra Schlichting <littlesandra88@gmail.com>
Subject: Re: Workaround for tcrypt bug?
Date: Fri, 28 Dec 2012 13:36:10 +0100
Message-ID: <CAELiMBMrmagP14SoE1aaDqnuXvwdtVM69zpmK5dn+9Zqby8sQw@mail.gmail.com>
References: <CAELiMBOPsPOWNe6+LahiBqGteucai0xrqY+eQ0nxkghjAEsy-A@mail.gmail.com>
 <CAELiMBOtmQwY8kH=nLTZzjPtNqPsC_GGgs=gDe7pQwFewsxY1A@mail.gmail.com> <20121228141825.11102bkeriixmuqs@www.dalek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:39868 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2L1Mgu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Dec 2012 07:36:50 -0500
Received: by mail-qa0-f43.google.com with SMTP id cr7so9515314qab.9
        for <linux-crypto@vger.kernel.org>; Fri, 28 Dec 2012 04:36:50 -0800 (PST)
In-Reply-To: <20121228141825.11102bkeriixmuqs@www.dalek.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Why you want to workaround this? It's safe to ignore hmac(crc32) warning.

Because it stops from proceeding. I would have expected that

modprobe tcrypt sec=1 type=1000

would have executed all test cases.

Even if I just want to test one

[root@amd ~]# modprobe tcrypt sec=2 type=402
ERROR: could not insert 'tcrypt': No such file or directory

I get an error.
