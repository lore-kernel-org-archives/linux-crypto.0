From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] dm: switch dm-verity to async hash crypto API
Date: Mon, 6 Feb 2017 16:02:17 +0200
Message-ID: <CAOtvUMemy1j6rB0rs43P7LLywMHvrmUUw4R6Pc4OfQd4F37OVA@mail.gmail.com>
References: <1485268704-31033-1-git-send-email-gilad@benyossef.com>
 <CAAUqJDsC8BVnudsirn96O2qTHh4jMmYYe4YBiO83UW-PGfy+Qg@mail.gmail.com>
 <CAOtvUMfx4xYQk7_NQTQsc0xxGnsKkQdGk97XY5vv2tE0aHLpfw@mail.gmail.com> <20170130002844.GB5253@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?=
        <omosnacek+linux-crypto@gmail.com>, dm-devel@redhat.com,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-crypto@vger.kernel.org, gilad.benyossef@arm.com,
        Ofir <ofir.drang@arm.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36795 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdBFOCT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Feb 2017 09:02:19 -0500
Received: by mail-io0-f195.google.com with SMTP id q20so9318134ioi.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Feb 2017 06:02:18 -0800 (PST)
In-Reply-To: <20170130002844.GB5253@zzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Eric,


On Mon, Jan 30, 2017 at 2:28 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
...
> As for the patch, I haven't looked at it in detail, but I agree that if
> dm-verity is indeed operating on sufficiently large buffers in physically
> contiguous memory, then the ahash API would be better than the shash API.  Note,
> that it also could be useful look into supporting having multiple async requests
> issued and pending at the same time, similar to what dm-crypt does.

Thank you for the feedback Eric.

I just sent out a v2 with fixes based on Ondrej feedback.

Supporting multiple outstanding async requests is a great idea. I will
look into supporting it.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
