From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: Workaround for tcrypt bug?
Date: Fri, 28 Dec 2012 14:18:25 +0200
Message-ID: <20121228141825.11102bkeriixmuqs@www.dalek.fi>
References: <CAELiMBOPsPOWNe6+LahiBqGteucai0xrqY+eQ0nxkghjAEsy-A@mail.gmail.com>
 <CAELiMBOtmQwY8kH=nLTZzjPtNqPsC_GGgs=gDe7pQwFewsxY1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sandra Schlichting <littlesandra88@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:51859 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab2L1MS2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Dec 2012 07:18:28 -0500
In-Reply-To: <CAELiMBOtmQwY8kH=nLTZzjPtNqPsC_GGgs=gDe7pQwFewsxY1A@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Sandra Schlichting <littlesandra88@gmail.com>:

> Hi all,
>
> On my Fedora 17 64bit AMD desktop computer I get this error
>
> [root@amd ~]# uname -a
> Linux amd 3.6.10-2.fc17.x86_64 #1 SMP Tue Dec 11 18:07:34 UTC 2012
> x86_64 x86_64 x86_64 GNU/Linux
> [root@amd ~]# modprobe tcrypt sec=1 type=1000
> ERROR: could not insert 'tcrypt': No such file or directory
> [root@amd ~]# tail -f /var/log/messages
> Dec 26 02:32:04 amd kernel: [ 1908.753473] alg: hash: Failed to load
> transform for hmac(crc32): -2
> Dec 26 02:32:04 amd kernel: [ 1908.765333] alg: hash: Failed to load
> transform for hmac(crc32): -2
> Dec 26 02:32:04 amd kernel: [ 1908.772012] tcrypt: one or more tests failed!
>
> Does anyone know of a way to workaround this?

Why you want to workaround this? It's safe to ignore hmac(crc32) warning.

-Jussi

>
> Hugs,
> Sandra
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
