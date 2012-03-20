From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: serpent-sse2 - different key size same speed?
Date: Tue, 20 Mar 2012 09:08:22 +0100
Message-ID: <4F683AF6.30400@gmail.com>
References: <jk7sn8$blt$1@dough.gmane.org> <20120320085319.19374u25s60oh1gk@www.81.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58735 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab2CTIKi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Mar 2012 04:10:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1S9u9I-0002tI-N7
	for linux-crypto@vger.kernel.org; Tue, 20 Mar 2012 09:10:32 +0100
Received: from ip-89-176-6-41.net.upcbroadband.cz ([89.176.6.41])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 20 Mar 2012 09:10:32 +0100
Received: from zkaspar82 by ip-89-176-6-41.net.upcbroadband.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 20 Mar 2012 09:10:32 +0100
In-Reply-To: <20120320085319.19374u25s60oh1gk@www.81.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dne 20.3.2012 7:53, Jussi Kivilinna napsal(a):
> Quoting Zdenek Kaspar <zkaspar82@gmail.com>:
> 
>> Hello everyone,
>>
>> I just quick tested 3.3.0 kernel (x86_64) to get idea how serpent-sse2
>> implementation works on Core2 machine. My dirty testing revealed that
>> key size doesn't have impact on speed. Is such behavior normal ?
> 
> It's expected result, serpent speed does not depend on key-size and for
> example twofish and blowfish are another such ciphers where speed is
> key-size independent.
> 
> -Jussi

Thanks for clarification and enlighten me :) (btw: nice work with
serpent-sse2)

Z.
