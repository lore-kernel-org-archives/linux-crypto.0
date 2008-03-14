From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] [crypto] padlock-AES, use generic setkey function
Date: Fri, 14 Mar 2008 12:44:07 +0100
Message-ID: <20080314114407.GA30663@Chamillionaire.breakpoint.cc>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <1203850864-16681-3-git-send-email-sebastian@breakpoint.cc> <47D99F62.7010100@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Michal Ludvig <michal@logix.cz>
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55552 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbYCNLoM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Mar 2008 07:44:12 -0400
Content-Disposition: inline
In-Reply-To: <47D99F62.7010100@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Stefan Hellermann | 2008-03-13 22:40:50 [+0100]:

>Sebastian Siewior schrieb:
>> Padlock AES' setkey routine is the same as exported by the generic
>> implementation. So we could use it.
>> 
>
>I tested this and "[RFC] generic_aes: export generic setkey" on a padlock-enabled Via
>board, and did the following test:
>
>Create, open, write to, read from and close a linux dm-crypt device with aes-cbc-essiv,
>aes-lrw-benbi and aes-xts-plain.
>
>Then I took a huge encrypted disk-image (encrypted without this patches), opened it with
>cryptsetup-luks, booted the OS from the disc over iscsi, started a filesystem-check. The
>check completed successful.
Looks like an interresting setup :)

>
>So I think this and the other patch are save.

That patch uses different (but I hope the same) algorithm for key
generation which is only used for keys >128 bit. If your dm-crypt setup
used 192 or 256 bit keys than the test should be valid.
In the other case (or just to be sure) please run
|modprobe tcrypt mode=10
which just does work.

Sebastian
