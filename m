From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: serpent-sse2 - different key size same speed?
Date: Tue, 20 Mar 2012 08:53:19 +0200
Message-ID: <20120320085319.19374u25s60oh1gk@www.81.fi>
References: <jk7sn8$blt$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Zdenek Kaspar <zkaspar82@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:37764 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2CTGxX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Mar 2012 02:53:23 -0400
In-Reply-To: <jk7sn8$blt$1@dough.gmane.org>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Zdenek Kaspar <zkaspar82@gmail.com>:

> Hello everyone,
>
> I just quick tested 3.3.0 kernel (x86_64) to get idea how serpent-sse2
> implementation works on Core2 machine. My dirty testing revealed that
> key size doesn't have impact on speed. Is such behavior normal ?

It's expected result, serpent speed does not depend on key-size and  
for example twofish and blowfish are another such ciphers where speed  
is key-size independent.

-Jussi

>
> Test machine: Core2 E6600 (2.40GHz), 3GB RAM, Scientific Linux 6.2
> dm-crypt on /dev/loop0, 1.5G image file:
> /dev/loop0: [0010]:11323 (/dev/shm/test.img)
>
>
> Encrypt (dd if=/dev/zero of=/dev/mapper/test bs=1M)
> -s 256 -c aes-xts-plain64     : 159 - 162 MB/s
> -s 512 -c aes-xts-plain64     : 129 - 141 MB/s
>
> -s 256 -c serpent-xts-plain64 : 142 - 146 MB/s
> -s 512 -c serpent-xts-plain64 : 139 - 148 MB/s
>
>
> Decrypt (dd if=/dev/mapper/test of=/dev/null bs=1M)
> -s 256 -c aes-xts-plain64     : 113 - 114 MB/s
> -s 512 -c aes-xts-plain64     :   90.1 MB/s
>
> -s 256 -c serpent-xts-plain64 :  105.0 MB/s
> -s 512 -c serpent-xts-plain64 :  105.0 MB/s
>
>
> (perf top shows as expected high usage of: serpent_dec_blk_8way and
> serpent_enc_blk_8way)
>
> Z.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
