From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: virtio:rng: Virtio RNG devices need to be re-registered after suspend/resume
Date: Fri, 3 Nov 2017 21:03:12 +0530
Message-ID: <CANc+2y6=uXv=1Augn22P2_WCLO3mJY6h3+cznGMsEw9L+LXqJQ@mail.gmail.com>
References: <1509703041-6281-1-git-send-email-Jim.Quigley@oracle.com>
 <CANc+2y7jg67sT9GdxEA4NXA+xCFpLNHUVAJbrGs8p0bC77JJOQ@mail.gmail.com>
 <a8cc4bc4-abb5-b9ba-018f-bee985b09117@oracle.com> <CANc+2y4cEAHudxdK6Y0TbskGMH6jpLg0cfWt77JR44fzYU94HA@mail.gmail.com>
 <CANc+2y7MjX4WKagAiUGz2NA2w-p8NkF4CXMOOEtTW8PdpsHj6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Jim Quigley <Jim.Quigley@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:44190 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753635AbdKCPdN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 11:33:13 -0400
Received: by mail-io0-f174.google.com with SMTP id m16so7132646iod.1
        for <linux-crypto@vger.kernel.org>; Fri, 03 Nov 2017 08:33:13 -0700 (PDT)
In-Reply-To: <CANc+2y7MjX4WKagAiUGz2NA2w-p8NkF4CXMOOEtTW8PdpsHj6A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jim,

Have second thoughts on this.

On 3 November 2017 at 20:55, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
>>
>>     It would be cleaner to just get rid of probe_common() altogether in that
>> case, and do whatever
>>     needs to be done in virtrng_probe()/virtrng_restore() respectively, but
>
> That's correct.
>
>> I didn't want to change code
>>     affecting the normal probe path as well as suspend/resume. Is it OK to
>> leave it that way to avoid
>>     the more extensive changes ?
>
> Personally I would prefer to do the cleaner way. It is up to the
> virtio and hwrng maintainer.

You are trying to restore the status quo of the driver that was before
the commit 5c06273401. It is really important and valid. The driver's
suspend/resume code is not in best shape but that is not what you are
trying to solve. I am fine with this change.

Regards,
PrasannaKumar
