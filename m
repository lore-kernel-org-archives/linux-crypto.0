From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Truncated(?) /proc/crypto on x86_64 on 2.6.22
Date: Tue, 16 Oct 2007 21:34:35 +0200
Message-ID: <20071016193435.GA31668@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.0710161949410.21430@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Krzysztof Oledzki <olel@ans.pl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48058 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759646AbXJPTeh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Oct 2007 15:34:37 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710161949410.21430@bizon.gios.gov.pl>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Krzysztof Oledzki | 2007-10-16 19:56:33 [+0200]:

> After switching from i386 to x86_64 I noticed that /proc/crypto is much 
> shorter:
>
> #  wc -l /proc/crypto crypto-64
>  482 /proc/crypto
>  349 crypto-64
>

It is all fine from what I can see in this diff.


> # diff -Nur /proc/crypto crypto-64
> --- /proc/crypto        2007-10-16 19:49:45.110694374 +0200
> +++ crypto-64   2007-10-16 19:48:10.000000000 +0200
> @@ -1,136 +1,3 @@
> -name         : cbc(twofish)
> -driver       : cbc(twofish-i586)
> -module       : kernel
> -priority     : 200
> -refcnt       : 1
> -type         : blkcipher
> -blocksize    : 16
> -min keysize  : 16
> -max keysize  : 32
> -ivsize       : 16
> -

This algo is stacked, because it was used. You have probably one output
after 'modprobe tcrypt' and the other before :)

Sebastian
