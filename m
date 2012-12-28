From: Sandra Schlichting <littlesandra88@gmail.com>
Subject: Re: Workaround for tcrypt bug?
Date: Fri, 28 Dec 2012 21:01:34 +0100
Message-ID: <CAELiMBP60_VwjdQdnSwSAY8rpBCPtQE+f_-1LYkjiz6tfDn5wA@mail.gmail.com>
References: <CAELiMBOPsPOWNe6+LahiBqGteucai0xrqY+eQ0nxkghjAEsy-A@mail.gmail.com>
 <CAELiMBOtmQwY8kH=nLTZzjPtNqPsC_GGgs=gDe7pQwFewsxY1A@mail.gmail.com>
 <20121228141825.11102bkeriixmuqs@www.dalek.fi> <CAELiMBMrmagP14SoE1aaDqnuXvwdtVM69zpmK5dn+9Zqby8sQw@mail.gmail.com>
 <20121228145509.16824jqi8bl9komo@www.dalek.fi> <CAELiMBNaV8mS=R2O6N0eK1sm5528XMC8ex=QAjeecaJ+8KEJXg@mail.gmail.com>
 <20121228185810.28972ewnk1vl5cis@www.dalek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:38416 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab2L1UCP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Dec 2012 15:02:15 -0500
Received: by mail-qa0-f50.google.com with SMTP id cr7so6999778qab.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Dec 2012 12:02:15 -0800 (PST)
In-Reply-To: <20121228185810.28972ewnk1vl5cis@www.dalek.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Tcrypt does all work in module init, which can take long time and therefore
> triggers 'soft lockup' warning.
>
> Possible solutions are:
>  1. Build kernel with CONFIG_LOCKUP_DETECTOR option disabled,
>  2. Boot kernel with 'nowatchdog' argument,
>  3. Ignore warning.
>
>
>> ERROR: could not insert 'tcrypt': Resource temporarily unavailable
>
>
> Tcrypt fails to load after running tests, that's expected.

Thanks a lot for clearing that out =)
