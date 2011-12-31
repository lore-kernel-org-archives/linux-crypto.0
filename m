From: Mark Allyn <allyn@well.com>
Subject: Re: I have a Question about linux asynchronous crypto
Date: Sat, 31 Dec 2011 10:13:57 -0800 (PST)
Message-ID: <alpine.LRH.2.02.1112311013340.31442@well.com>
References: <4EFEE23D.7070602@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-crypto@vger.kernel.org
To: Gao feng <omarapazanadi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from newsmtp.well.com ([107.20.247.102]:55872 "EHLO newsmtp.well.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab1LaS1o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 31 Dec 2011 13:27:44 -0500
In-Reply-To: <4EFEE23D.7070602@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


As far as I can see, I agree. The generic implementations all seem to
be synchronous.

Truly,

Mark Allyn
Portland, Oregon
www.allyn.com
971-563-7588

On Sat, 31 Dec 2011, Gao feng wrote:

> Hi all
>
> sorry to borther you.
>
> I saw the linux crypto code,and found there is no asynchronous crypto 
> implemented by software,
> only the hardware such as talitos implements async crypto.
>
> I am right,or I miss someting?
>
> thanks all.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
