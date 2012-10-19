From: Gurucharan Shetty <gurucharan.shetty@gmail.com>
Subject: Re: [PATCH] Re: aesni intel and kernel crashes.
Date: Fri, 19 Oct 2012 16:05:12 -0700
Message-ID: <CA+sc+0Qga4+P79=nCvJn6igsugA19+pPVBFZgXgwWyZ0gn84ZA@mail.gmail.com>
References: <CA+sc+0T3CFwv6JdcLA66=pD=6LcaQOJZnvDGqp3o4LKN85ZbZg@mail.gmail.com>
 <20121018115249.22157.69385.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45235 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab2JSXFe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Oct 2012 19:05:34 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so743384wib.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2012 16:05:33 -0700 (PDT)
In-Reply-To: <20121018115249.22157.69385.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 October 2012 04:52, Jussi Kivilinna <jussi.kivilinna@mbnet.fi> wrote:
> Does this patch help?
>
> It applies cleanly to 3.2.x, if that version easier for you to reproduce the
> issue.
>
> ...
>
> cryptd_queue_worker attempts to prevent simultanious accesses to crypto-work
> queue by cryptd_enqueue_request using preempt_disable/preempt_enable. However
> cryptd_enqueue_request might be called from interrupt context, so add
> local_irq_save/local_irq_restore to prevent data corruption and panics.
> ---
>  crypto/cryptd.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
I applied this patch on 3.2.y and I have been running tests for the
past 30+ hours. I have not seen the crash yet (Previously I would see
a crash on an average every 15 min.). It looks like it does help.
Thanks much for the patch.

I will continue the tests for the next week or so for any other bugs.

Thanks,
Guru
