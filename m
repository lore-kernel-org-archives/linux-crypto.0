From: Ronen Shitrit <rshitrit@gmail.com>
Subject: Re: GCM counter inc
Date: Fri, 29 Jun 2012 14:01:47 +0300
Message-ID: <CAHFzjDCCaUwNoRXjjLJkbnChbYCf3rEqq42707En_yW1r1W_BA@mail.gmail.com>
References: <CAHFzjDAWhbM+MYAGs1P+6Ewb1VBG6z2n4c6HGYphMGpFdt8xTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62567 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2F2LBt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jun 2012 07:01:49 -0400
Received: by lbbgm6 with SMTP id gm6so4481703lbb.19
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jun 2012 04:01:48 -0700 (PDT)
In-Reply-To: <CAHFzjDAWhbM+MYAGs1P+6Ewb1VBG6z2n4c6HGYphMGpFdt8xTA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Can someone verify if it is a bug?

Thanks

On Wed, Jun 20, 2012 at 11:44 AM, Ronen Shitrit <rshitrit@gmail.com> wrote:
> Hi
>
> According to the GCM NIST publication, the counter increment should be
> module 32 bit.
> Looking into the crypto code, I can see that when using gcm(aes) the
> gcm will use the ctr over aes,
> ctr.c is using the crypto_inc with size of blocksize, which is 16 for AES.
> in case crypto_inc will overflow in 32bit it will inc the next 32bit...
>
> Is this a bug or am I missing something?
>
> Regards
