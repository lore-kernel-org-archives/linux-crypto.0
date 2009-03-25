From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: [PATCH] crypto: talitos - protect against possible null ptr upon
	error
Date: Tue, 24 Mar 2009 23:06:16 -0500
Message-ID: <eabe9a7b0903242106t14d11946ydd62e450f4803216@mail.gmail.com>
References: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
	 <20090324162345.4b1b94d2.kim.phillips@freescale.com>
Reply-To: lee.nipper@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37151 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZCYEGT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Mar 2009 00:06:19 -0400
Received: by bwz17 with SMTP id 17so2499977bwz.37
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2009 21:06:16 -0700 (PDT)
In-Reply-To: <20090324162345.4b1b94d2.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 24, 2009 at 16:23, Kim Phillips <kim.phillips@freescale.com> wrote:
> On Sun, 15 Mar 2009 20:21:47 -0500
> Lee Nipper <lee.nipper@gmail.com> wrote:
>
>> Added test for null descriptor returned from current_desc.
>> Also removed the diagnostic from current_desc,
>> and added one instead in talitos_error
>> to report an EU error without finding the descriptor.
>
> Hi Lee, thanks for this - I'm not clear on how the channel error gets
> triggered, points to an EU, and all of this without a referencing a
> current descriptor.

I don't remember the exact case when I observed it,  but I did.
In any case, it seemed the code needed the protection against the
failed look up case (prevent null pointer use).

> How did you run into this case?

I had a misconfigured descriptor (I think), and the problem case is
not in the code.

> Assuming one does
> get propagated back, what error status does the callback receive?

Ug.  If I were still at Freescale and had access to my logs, I could
answer with detail,  But that's not the case.

> afaict, interrupt mitigation should not be intervening in this case.
>

That's right.
The interrupt with error status was occurring, and it was handling it
during the isr..

Thanks,
Lee
