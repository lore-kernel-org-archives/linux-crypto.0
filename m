From: srishti sharma <srishtishar@gmail.com>
Subject: Re: [PATCH] Staging: ccree: ssi_aead.h: Fixed a pointer declaration error.
Date: Sat, 3 Jun 2017 23:28:31 +0530
Message-ID: <CAB3L5oz_yXuwddZ3O2yaZ3xkJkbntN6+U1bt=Vj3hO49cvy6ig@mail.gmail.com>
References: <1496443518-18497-1-git-send-email-srishtishar@gmail.com> <20170603083741.GB29531@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:36481 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdFCR6c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Jun 2017 13:58:32 -0400
In-Reply-To: <20170603083741.GB29531@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey,

checkpatch.pl generated two errors , because the dereferencing
operator was placed next to the structure name instead of being placed
with the pointer .

for eg:
  struct scatterlist* srcSgl; (this was giving an error)

whereas
 struct scatterlist *srcSgl; (this did not give an error)


Both of them will compile , but the second one is a better
representation of it and does not produce an error on running
checkpatch.pl .

Regards,
Srishti

On Sat, Jun 3, 2017 at 2:07 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Jun 03, 2017 at 04:15:17AM +0530, srishti sharma wrote:
>> Fixed a pointer declaration error , the dereferencing operator was misplaced.
>
> Odd use of a ,
>
> Also, I don't understand what was "misplaced" here?  There does not seem
> to be a "error" fixed here...
>
