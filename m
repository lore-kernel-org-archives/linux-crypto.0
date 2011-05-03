From: Tzvi Chumash <tzvi@research.att.com>
Subject: Re: blowfish from openSSL to kernel cryptoAPI
Date: Tue, 03 May 2011 11:46:35 -0400
Message-ID: <ipp84b$m6s$1@dough.gmane.org>
References: <ipnbl5$ug4$1@dough.gmane.org> <4DC015AD.BA46DC3F@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43563 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1ECPsp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2011 11:48:45 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1QHHq7-000439-Sq
	for linux-crypto@vger.kernel.org; Tue, 03 May 2011 17:48:43 +0200
Received: from 135.207.174.202 ([135.207.174.202])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 03 May 2011 17:48:43 +0200
Received: from tzvi by 135.207.174.202 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 03 May 2011 17:48:43 +0200
In-Reply-To: <4DC015AD.BA46DC3F@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks for your response, Jari. I tried changing the byte ordering on 
the key,iv and the data(before and after decrypt) and the result is 
still wrong. Unless someone has another idea, I will have to change the 
user-space part to also encrypt in-kernel instead of using openSSL...

I was assuming that given the same parameters (e.g. encryption 
algorithm, CBC, key, iv), the cipher data would be equivalent between 
different implementations (in this case openSSL/cryptoapi). Was that a 
wrong assumption?

Thanks again,

Tzvi


On 5/3/2011 10:48 AM, Jari Ruusu wrote:
> Tzvi Chumash wrote:
>> I'm trying (without much success) to decrypt in-kernel
>> (2.6.18-194.el5PAE) a cipher that was created using openSSL
>> (0.9.8e-fips-rhel5) using blowfish with a 56-byte key/8-byte iv. Are the
>> implementations incompatible (i.e. can't encrypt in one and decrypt in
>> the other?) or am I doing something wrong?
>
> Check byte order of the two implementations. Many blowfish implementations
> got byte order wrong. Does it help if you swap byte order from
> 0-1-2-3-4-5-6-7 to 7-6-5-4-3-2-1-0 of key/data/IV before and after crypto
> operation?
>
