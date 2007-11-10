From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [patch 0/2] remove setkey function in VIA's padlock
Date: Sat, 10 Nov 2007 22:23:56 +0100
Message-ID: <20071110212356.GD15150@Chamillionaire.breakpoint.cc>
References: <20071102181323.632030242@ml.breakpoint.cc> <472E5BCA.2060000@logix.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Michal Ludvig <michal@logix.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51541 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212AbXKJVX6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Nov 2007 16:23:58 -0500
Content-Disposition: inline
In-Reply-To: <472E5BCA.2060000@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Michal Ludvig | 2007-11-05 12:54:50 [+1300]:

> I'll test and get back to you.
thx.

>
>> I have one question regarding the size of the expanded key: You reserve
>> 64 * 4 bytes for each key but it seems that you use only 60 * 4 bytes.
>> Are the other bytes used by the hardware or did you allocate it by
>> accident?
>
> The hardware needs it. From the VIA Padlock Programming Guide:
>
> | For the application-loaded keys option, the hardware always
> | loads sixteen 128-bit values from memory regardless of the
> | specified key size. Any values beyond the normal extended key
> | size are ignored and have no effect on the results, but that
> | memory area must be accessible (within the segment limit, etc.)

Since we only have to make sure that we can access the memory, what
about:

 struct aes_ctx {
     u32 E[15 * 16]
         __attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));
     u32 d_data[15 * 16]
         __attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));
     struct {
         struct cword encrypt;
         struct cword decrypt;
     } cword;
     u32 *D;
     int key_length;
 };

> Michal

Sebastian
