From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: Workaround for tcrypt bug?
Date: Fri, 28 Dec 2012 18:58:10 +0200
Message-ID: <20121228185810.28972ewnk1vl5cis@www.dalek.fi>
References: <CAELiMBOPsPOWNe6+LahiBqGteucai0xrqY+eQ0nxkghjAEsy-A@mail.gmail.com>
 <CAELiMBOtmQwY8kH=nLTZzjPtNqPsC_GGgs=gDe7pQwFewsxY1A@mail.gmail.com>
 <20121228141825.11102bkeriixmuqs@www.dalek.fi>
 <CAELiMBMrmagP14SoE1aaDqnuXvwdtVM69zpmK5dn+9Zqby8sQw@mail.gmail.com>
 <20121228145509.16824jqi8bl9komo@www.dalek.fi>
 <CAELiMBNaV8mS=R2O6N0eK1sm5528XMC8ex=QAjeecaJ+8KEJXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sandra Schlichting <littlesandra88@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:59986 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2L1Q6O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Dec 2012 11:58:14 -0500
In-Reply-To: <CAELiMBNaV8mS=R2O6N0eK1sm5528XMC8ex=QAjeecaJ+8KEJXg@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Sandra Schlichting <littlesandra88@gmail.com>:

>> I think you are using wrong module argument, type= instead of mode=. Try
>> 'modprobe tcrypt sec=2 mode=402' instead.
>
> Thanks. I would never have thought of that =)
>
> Now it preforms the test, but gives this interesting error:
>
> [root@amd ~]# modprobe tcrypt sec=2 mode=402
>
> Message from syslogd@amd at Dec 28 14:01:05 ...
>  kernel:[ 5508.698788] BUG: soft lockup - CPU#0 stuck for 22s!  
> [modprobe:3416]

Tcrypt does all work in module init, which can take long time and  
therefore triggers 'soft lockup' warning.

Possible solutions are:
  1. Build kernel with CONFIG_LOCKUP_DETECTOR option disabled,
  2. Boot kernel with 'nowatchdog' argument,
  3. Ignore warning.

> ERROR: could not insert 'tcrypt': Resource temporarily unavailable

Tcrypt fails to load after running tests, that's expected.

-Jussi
