From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [Freedombox-discuss] Hardware Crypto
Date: Thu, 10 Aug 2017 10:23:44 -0400
Message-ID: <CACXcFmn_5a-Ygv9RRLA8Jey+XWH7Ez6KdUDE9jE5TRqvuECMuw@mail.gmail.com>
References: <87pqldrq15.fsf@freedomboxfoundation.org> <CAMhXSQpkScTzZB4fZ0KGbTPKmtiwv_o7cz7MrWXc_rqrCfO3Pg@mail.gmail.com>
 <4E1FF66C.6010908@mray.de> <87wrfe1acu.fsf@freedomboxfoundation.org>
 <CA+FSnD1NO97U1zQQZV=VD+dbCGR0oQTgEYBmH6VupGUKo8uRFA@mail.gmail.com>
 <87r55m175w.fsf@freedomboxfoundation.org> <CAJVWO9aUCLb6k87do-ckOdkV-1U7d2SiG3gtBOVVXouog04Tpw@mail.gmail.com>
 <CAJVWO9YDKD72Sbb9_wWvxFVEppDg=4+XfBAY3uxvxcZ0b2t3yg@mail.gmail.com>
 <20110720063824.GA15748@havelock.liw.fi> <CAJVWO9bXs7_bx8-37O++n8kSJTuASC_benwmyeLgfiik8nGrmA@mail.gmail.com>
 <8762mx14co.fsf@freedomboxfoundation.org> <6556610b-9ddf-4bc2-b235-a2c91598a040@email.android.com>
 <201107220153.p6M1rVDn004794@new.toad.com> <CACXcFm=CBZmSaiwt7RaGUtS1u-q5HUrACKrvj=7Y201R6Fzmtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:38076 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752666AbdHJOXq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 10:23:46 -0400
Received: by mail-wr0-f182.google.com with SMTP id f21so3577611wrf.5
        for <linux-crypto@vger.kernel.org>; Thu, 10 Aug 2017 07:23:45 -0700 (PDT)
In-Reply-To: <CACXcFm=CBZmSaiwt7RaGUtS1u-q5HUrACKrvj=7Y201R6Fzmtw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To me it seems obvious that if the hardware provides a real RNG, that
should be used to feed random(4). This solves a genuine problem and,
even if calls to the hardware are expensive, overall overhead will not
be high because random(4) does not need huge amounts of input.

I'm much less certain hardware acceleration is worthwhile for ciphers
& hashes, except where the CPU itself includes instructions to speed
them up.
